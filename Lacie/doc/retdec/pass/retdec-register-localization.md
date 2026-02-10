# RetDec Pass: retdec-register-localization

## 1. 基本信息

| 项 | 内容 |
| :--- | :--- |
| **Pass 名称** | `retdec-register-localization` |
| **实现类** | `RegisterLocalization` |
| **源码路径** | `src/bin2llvmir/optimizations/register_localization/` |
| **Pass 类型** | ModulePass |
| **在全流程中的位置** | 在 `retdec-stack` 之后，`mem2reg` 之前，承上启下的关键转换 Pass |

---

## 2. 核心功能

`retdec-register-localization` 的核心任务是：**将全局寄存器变量转换为函数局部的 `alloca` 变量**。

### 2.1 为什么要做这个转换？

**Decoder 输出的问题：**
```llvm
; 所有寄存器都是全局变量
@rax = internal global i64 0
@rbx = internal global i64 0

define void @func1() {
  store i64 42, i64* @rax    ; 写全局 rax
  ...
}

define void @func2() {
  %val = load i64, i64* @rax  ; 读全局 rax（可能读到 func1 写的值）
  ...
}
```

**问题：**
- 寄存器在物理上是全局共享的，但在函数级别分析时需要视为局部状态
- 全局变量无法被 `mem2reg` 优化（`mem2reg` 只处理局部的 `alloca`）
- LLVM 的局部分析（如基于栈的优化）无法应用于全局寄存器

**Register Localization 的解决方案：**
```llvm
define void @func1() {
  %rax.local = alloca i64      ; 每个函数有自己的 rax 副本
  store i64 42, i64* %rax.local
  ...
}

define void @func2() {
  %rax.local = alloca i64      ; 独立的 rax 副本
  %val = load i64, i64* %rax.local
  ...
}
```

---

## 3. 详细算法流程

### 3.1 整体流程

```
┌─────────────────────────────────────────────────────────────────┐
│              RegisterLocalization::run()                         │
├─────────────────────────────────────────────────────────────────┤
│  1. 获取 ABI 定义的所有寄存器全局变量列表                          │
│     └─> @rax, @rbx, @rcx, @rsp, @rbp, ...                        │
│                                                                  │
│  2. 遍历每个寄存器                                                │
│     └─> 为每个寄存器维护独立的 fnc2alloca 映射                     │
│                                                                  │
│  3. 遍历寄存器的所有使用者（Users）                               │
│     ├─> 如果是 Instruction：直接局部化                            │
│     └─> 如果是 ConstantExpr：先物化再局部化                        │
│                                                                  │
│  4. 在函数入口创建对应的 alloca                                    │
│     └─> 使用 getLocalized() 懒加载创建                            │
│                                                                  │
│  5. 替换所有对全局寄存器的引用                                     │
│     └─> replaceUsesOfWith(reg, localized)                        │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 核心算法详解

#### 步骤 1：获取寄存器列表

```cpp
const auto& regs = _abi->getRegisters();
// 返回所有 ABI 定义的寄存器全局变量
// 如 x86: @eax, @ebx, @ecx, @edx, @esi, @edi, @esp, @ebp
```

#### 步骤 2：遍历寄存器的使用者

```cpp
for (GlobalVariable* reg : regs)
{
    std::map<Function*, AllocaInst*> fnc2alloca;
    
    // 遍历该寄存器的所有使用者
    for (auto uIt = reg->user_begin(); uIt != reg->user_end(); )
    {
        User* user = *uIt;
        ++uIt;
        
        // 情况 1: 直接使用（指令）
        if (auto* insn = dyn_cast<Instruction>(user))
        {
            changed = localize(reg, fnc2alloca, insn);
        }
        // 情况 2: 常量表达式（需要特殊处理）
        else if (auto* expr = dyn_cast<ConstantExpr>(user))
        {
            // 见下文详细说明
        }
    }
}
```

#### 步骤 3：懒加载创建局部 alloca

```cpp
llvm::AllocaInst* RegisterLocalization::getLocalized(
        llvm::GlobalVariable* reg,
        llvm::Function* fnc,
        std::map<llvm::Function*, llvm::AllocaInst*>& fnc2alloca)
{
    // 检查是否已创建
    auto fIt = fnc2alloca.find(fnc);
    if (fIt != fnc2alloca.end())
    {
        return fIt->second;  // 返回已创建的 alloca
    }
    
    // 在函数入口块创建新的 alloca
    if (!fnc->empty() && !fnc->front().empty())
    {
        auto* a = new AllocaInst(
                reg->getValueType(),          // 类型与寄存器相同
                reg->getAddressSpace(),
                nullptr,                       // 无数组大小（单个值）
                reg->getName(),                // 名称保持（如 "rax"）
                &fnc->front().front());        // 插入到入口块第一条指令前
        
        fnc2alloca.emplace(fnc, a);           // 缓存
        return a;
    }
    
    return nullptr;  // 空函数（不应发生）
}
```

#### 步骤 4：替换引用

```cpp
bool RegisterLocalization::localize(
        llvm::GlobalVariable* reg,
        std::map<llvm::Function*, llvm::AllocaInst*>& fnc2alloca,
        llvm::Instruction* insn)
{
    // 获取或创建对应的局部 alloca
    AllocaInst* localized = getLocalized(reg, insn->getFunction(), fnc2alloca);
    
    if (localized == nullptr)
    {
        return false;
    }
    
    // 替换指令中对全局寄存器的引用
    // 例如：store i64 %val, i64* @rax
    //   -> store i64 %val, i64* %rax.local
    insn->replaceUsesOfWith(reg, localized);
    return true;
}
```

---

## 4. 关键机制详解

### 4.1 常量表达式物化（Materialization）

**问题：** 寄存器地址可能以常量表达式的形式出现：
```llvm
; 原始 IR
%gep = getelementptr i64, i64* @rax, i64 1  ; 常量表达式
%val = load i64, i64* %gep
```

常量表达式不是指令，无法直接修改。

**解决方案：** 物化为实际指令后再替换

```cpp
else if (auto* expr = dyn_cast<ConstantExpr>(user))
{
    // 遍历常量表达式的所有使用者
    for (auto euIt = expr->user_begin(); euIt != expr->user_end(); )
    {
        User* euser = *euIt;
        ++euIt;
        
        if (auto* insn = dyn_cast<Instruction>(euser))
        {
            // 1. 将常量表达式转换为实际指令
            // 例如：gep(@rax, 1) -> getelementptr i64, i64* %rax.local, i64 1
            auto* einsn = expr->getAsInstruction();
            
            // 2. 插入到使用它的指令之前
            einsn->insertBefore(insn);
            
            // 3. 对物化后的指令进行局部化
            if (localize(reg, fnc2alloca, einsn))
            {
                // 4. 替换原指令中对常量表达式的引用
                insn->replaceUsesOfWith(expr, einsn);
                changed = true;
            }
        }
    }
}
```

**物化示例：**

```llvm
; 转换前
@rax = internal global i64 0

define void @func() {
  %gep = getelementptr i64, i64* @rax, i64 1  ; 常量表达式
  store i64 42, i64* %gep
}

; 转换过程
; 1. 物化：将常量表达式转为指令
; 2. 局部化：@rax -> %rax.local

; 转换后
define void @func() {
  %rax.local = alloca i64
  %gep = getelementptr i64, i64* %rax.local, i64 1
  store i64 42, i64* %gep
}
```

### 4.2 函数级局部变量映射（fnc2alloca）

**核心数据结构：**
```cpp
std::map<Function*, AllocaInst*> fnc2alloca;
```

**作用：**
- 确保**同一函数内**对同一寄存器的所有引用都指向**同一个 `alloca`**
- 避免重复创建多个独立的局部变量

**示例：**
```llvm
; 函数内多次使用 @rax
define void @func() {
  store i64 1, i64* @rax    ; 使用 1
  %a = load i64, i64* @rax  ; 使用 2
  store i64 2, i64* @rax    ; 使用 3
}

; 转换后（只有一个 %rax.local）
define void @func() {
  %rax.local = alloca i64    ; 创建一次，复用多次
  store i64 1, i64* %rax.local
  %a = load i64, i64* %rax.local
  store i64 2, i64* %rax.local
}
```

### 4.3 跨函数寄存器状态

**重要特性：** 每个函数有自己独立的寄存器副本，**不保留跨函数状态**。

```llvm
; 转换前（全局状态共享）
define void @caller() {
  store i64 42, i64* @rax    ; 设置 rax
  call void @callee()
  %val = load i64, i64* @rax  ; 期望读到 callee 修改后的值
}

define void @callee() {
  store i64 100, i64* @rax   ; 修改全局 rax
}

; 转换后（独立局部副本）
define void @caller() {
  %rax.local = alloca i64
  store i64 42, i64* %rax.local
  call void @callee()
  ; ⚠️ 这里仍然加载 caller 的局部 rax，不是 callee 的！
  %val = load i64, i64* %rax.local
}

define void @callee() {
  %rax.local = alloca i64    ; 独立的局部副本
  store i64 100, i64* %rax.local
}
```

**问题：** 这种转换破坏了寄存器在函数调用间的传递语义。

**解决方案：** 由其他 Pass 处理（如 `param-return` 分析参数/返回值传递）

---

## 5. 转换示例

### 5.1 基础转换

**转换前：**
```llvm
@rax = internal global i64 0
@rbx = internal global i64 0

define i64 @add(i64 %a, i64 %b) {
entry:
  store i64 %a, i64* @rax       ; 保存参数到 rax
  store i64 %b, i64* @rbx       ; 保存参数到 rbx
  %0 = load i64, i64* @rax      ; 读取 rax
  %1 = load i64, i64* @rbx      ; 读取 rbx
  %sum = add i64 %0, %1         ; 相加
  store i64 %sum, i64* @rax     ; 结果存回 rax
  %ret = load i64, i64* @rax    ; 读取结果
  ret i64 %ret
}
```

**转换后：**
```llvm
define i64 @add(i64 %a, i64 %b) {
entry:
  %rax = alloca i64             ; 局部 rax
  %rbx = alloca i64             ; 局部 rbx
  
  store i64 %a, i64* %rax       ; 使用局部 rax
  store i64 %b, i64* %rbx       ; 使用局部 rbx
  %0 = load i64, i64* %rax
  %1 = load i64, i64* %rbx
  %sum = add i64 %0, %1
  store i64 %sum, i64* %rax
  %ret = load i64, i64* %rax
  ret i64 %ret
}
```

### 5.2 带常量表达式的转换

**转换前：**
```llvm
@rax = internal global i64 0

define void @access_offset() {
  ; 访问 rax[1]（即 rax + 8 字节处）
  %gep = getelementptr i64, i64* @rax, i64 1  ; 常量表达式
  store i64 42, i64* %gep
}
```

**转换后：**
```llvm
define void @access_offset() {
  %rax = alloca i64
  
  ; 常量表达式被物化为指令
  %gep = getelementptr i64, i64* %rax, i64 1
  store i64 42, i64* %gep
}
```

---

## 6. 与 mem2reg 的配合

### 6.1 为什么要先运行 register-localization？

```
decoder -> register-localization -> mem2reg
   ↓              ↓                  ↓
 全局变量      局部 alloca       SSA 虚拟寄存器
 (@rax)       (%rax.local)      (%rax.0, %rax.1)
```

**原因：**
- `mem2reg` **只处理局部的 `alloca`**，不处理全局变量
- 不运行 `register-localization`，`@rax` 等全局寄存器无法被 `mem2reg` 优化

### 6.2 mem2reg 后的最终形态

```llvm
; register-localization 后
define i64 @add(i64 %a, i64 %b) {
  %rax = alloca i64
  %rbx = alloca i64
  store i64 %a, i64* %rax
  store i64 %b, i64* %rbx
  %0 = load i64, i64* %rax
  %1 = load i64, i64* %rbx
  %sum = add i64 %0, %1
  store i64 %sum, i64* %rax
  %ret = load i64, i64* %rax
  ret i64 %ret
}

; mem2reg 后（最终 SSA 形式）
define i64 @add(i64 %a, i64 %b) {
  ; alloca 被消除，load/store 转为直接值传递
  %sum = add i64 %a, %b
  ret i64 %sum
}
```

---

## 7. 对 BPA 的影响

### 7.1 BPA 应该禁用 register-localization

**原因：**

| 因素 | 说明 |
|-----|------|
| **全局寄存器变量** | BPA 可以追踪全局 `@rax` 等寄存器的数据流 |
| **局部 alloca** | 也是内存访问，BPA 可以分析 |
| **关键问题** | register-localization 后，跨函数的寄存器传递语义丢失 |

**示例：** 间接调用目标通过寄存器传递

```llvm
; 转换前（BPA 可以分析）
define void @caller() {
  store i64 @target_func, i64* @rax    ; 设置目标函数地址
  call void @callee()
}

define void @callee() {
  %target = load i64, i64* @rax        ; 读取目标地址
  call i64 %target()                   ; 间接调用
}

; 转换后（跨函数数据流断裂）
define void @caller() {
  %rax.local = alloca i64
  store i64 @target_func, i64* %rax.local  ; 存储到 caller 的局部 rax
  call void @callee()
}

define void @callee() {
  %rax.local = alloca i64
  %target = load i64, i64* %rax.local      ; 读取 callee 的局部 rax（未初始化！）
  call i64 %target()                       ; 错误的目标
}
```

### 7.2 BPA 推荐配置

```json
{
    "decompParams": {
        "llvmPasses": [
            "retdec-decoder",
            "retdec-stack",              // ✅ 保留：创建栈变量 alloca
            // "retdec-register-localization",  // ❌ 禁用：破坏跨函数寄存器语义
            // "mem2reg",                       // ❌ 禁用：消除内存访问
            "retdec-write-ll"
        ]
    }
}
```

---

## 8. 边界情况和限制

### 8.1 未定义行为

```cpp
// Should not really happen.
return nullptr;
```

当函数为空（无基本块）时，无法创建 `alloca`，此时返回 `nullptr`，对应的引用不会被替换。

### 8.2 不处理的情况

| 情况 | 原因 | 结果 |
|-----|------|------|
| **全局初始化** | `@rax = global i64 42` | 全局变量的初始化器不被处理 |
| **非指令使用者** | 除 Instruction 和 ConstantExpr 外的 User | 忽略 |
| **空函数** | 无 entry block | 返回 nullptr，不替换 |

---

## 9. 总结

`retdec-register-localization` 是连接低级硬件模型和高级 SSA 模型的桥梁：

| 特性 | 说明 |
|-----|------|
| **核心功能** | 全局寄存器变量 → 局部 `alloca` |
| **关键技术** | 常量表达式物化、懒加载创建、函数级缓存 |
| **目的** | 使寄存器可被 `mem2reg` 优化，进入标准 SSA 形式 |
| **副作用** | 丢失跨函数寄存器传递语义 |

**使用建议：**
- **标准反编译流程**：保留，为后续优化做准备
- **BPA 复现**：**禁用**，避免破坏跨函数寄存器数据流
