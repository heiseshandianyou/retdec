# RetDec Pass: retdec-stack

## 1. 基本信息

| 项 | 内容 |
| :--- | :--- |
| **Pass 名称** | `retdec-stack` |
| **实现类** | `StackAnalysis` |
| **源码路径** | `src/bin2llvmir/optimizations/stack/stack.cpp` |
| **核心依赖** | `ReachingDefinitionsAnalysis` (到达定值分析), `SymbolicTree` (符号树) |
| **Pass 类型** | ModulePass |
| **在全流程中的位置** | 在 decoder 之后，负责将低级别的栈指针操作转换为高级别的局部变量 |

---

## 2. 核心功能

`retdec-stack` 是 RetDec 中**栈重构**的关键 Pass，其主要任务包括：

1. **识别栈指针操作**：分析基于栈指针寄存器（如 x86 的 `esp`/`rsp`，ARM 的 `sp`）的内存访问
2. **创建局部变量**：将栈上的内存位置转换为 LLVM `alloca` 指令
3. **替换内存访问**：将复杂的栈指针计算替换为简单的局部变量访问
4. **利用调试信息**：如果存在调试信息，恢复局部变量的原始名称

### 2.1 转换示例

**转换前（Decoder 输出）：**
```llvm
; x86 汇编: mov [ebp-4], eax
%ebp = load i64, i64* @ebp
%addr = add i64 %ebp, -4
%ptr = inttoptr i64 %addr to i32*
store i32 %eax_val, i32* %ptr
```

**转换后（Stack Pass 输出）：**
```llvm
; 创建局部变量
%local_var = alloca i32, align 4

; 简化存储
store i32 %eax_val, i32* %local_var
```

---

## 3. 详细算法流程

### 3.1 整体流程

```
┌─────────────────────────────────────────────────────────────────┐
│                     StackAnalysis::run()                         │
├─────────────────────────────────────────────────────────────────┤
│  1. 运行到达定值分析 (RDA)                                       │
│     └─> 获取每个值的定值-使用链                                  │
│                                                                  │
│  2. 遍历每个函数的所有指令                                        │
│     └─> 处理 StoreInst 和 LoadInst                              │
│                                                                  │
│  3. 调用 handleInstruction() 处理每条内存访问指令                 │
│     └─> 构建符号树，识别栈指针模式                                │
│                                                                  │
│  4. 如果识别为栈访问，创建/获取对应的 alloca                       │
│     └─> 替换原有的复杂地址计算                                   │
│                                                                  │
│  5. 清理被替换的指令                                             │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 核心算法详解

#### 步骤 1：到达定值分析（RDA）

```cpp
ReachingDefinitionsAnalysis RDA;
RDA.runOnModule(*_module, _abi);
```

RDA 为后续分析提供数据流信息，用于追踪栈指针值的传播。

#### 步骤 2：识别栈指针模式

```cpp
// 遍历符号树的所有节点
for (SymbolicTree* n : root.getPostOrder())
{
    // 检查是否包含栈指针寄存器
    if (_abi->isStackPointerRegister(n->value))
    {
        stackPtr = true;
        break;
    }
}
```

**关键函数**：`Abi::isStackPointerRegister()`

### ⚠️ 重要澄清：只识别栈指针，不包括帧指针

`isStackPointerRegister()` 只返回**真正的栈指针寄存器**，不包括帧指针（RBP/EBP/BP）：

| 架构 | 栈指针寄存器 (`isStackPointerRegister() == true`) | 帧指针寄存器 (`isStackPointerRegister() == false`) |
|-----|--------------------------------------------------|--------------------------------------------------|
| x86 | `esp` | `ebp` ❌ |
| x64 | `rsp` | `rbp` ❌ |
| ARM | `sp` | `fp`/`r11` ❌ |
| ARM64 | `sp` | `fp`/`x29` ❌ |
| MIPS | `sp` | `fp`/`s8` ❌ |
| PowerPC | `r1` | - |

**代码实现：**
```cpp
// abi.cpp
bool Abi::isStackPointerRegister(const llvm::Value* val) const
{
    return getStackPointerRegister() == val;  // 只检查一个特定寄存器
}

// 各架构初始化（如 x64.cpp）
_regStackPointerId = X86_REG_RSP;  // 只设置 RSP，不包括 RBP
```

### 那 RBP/EBP 访问怎么处理？

**实际行为：** 根据源码分析，`handleInstruction` 中的逻辑如下：

```cpp
if (!root.isVal2ValMapUsed())
{
    bool stackPtr = false;
    for (SymbolicTree* n : root.getPostOrder())
    {
        if (_abi->isStackPointerRegister(n->value))  // 只检查 SP，不包括 BP
        {
            stackPtr = true;
            break;
        }
    }
    if (!stackPtr)  // 如果不是栈指针，直接返回！
    {
        LOG << "===> no SP" << std::endl;
        return;
    }
}
```

**结论：**
- ✅ **RSP/ESP 访问**：能通过检查，被处理
- ❌ **RBP/EBP 访问**：**不能**通过检查，**不会被处理**（除非 `isVal2ValMapUsed()` 返回 true，但这种情况罕见）

**这意味着：**
- Stack pass 主要处理基于 **RSP/ESP** 的栈访问
- 基于 **RBP/EBP** 的局部变量访问**保持原样**（不会被转换为 alloca）

#### 步骤 3：计算栈偏移（仅适用于 RSP/ESP 访问）

**重要限制：** 只有包含 **RSP/ESP**（栈指针）的访问才会执行到这一步。RBP/EBP（帧指针）访问在第 2 步就被过滤掉了。

提取相对于栈指针的偏移量：

```cpp
std::optional<int> StackAnalysis::getBaseOffset(SymbolicTree& root)
{
    std::optional<int> baseOffset;
    
    // 情况 1: 直接是常量（例如 -4, -8, 16）
    if (auto* ci = dyn_cast_or_null<ConstantInt>(root.value))
    {
        baseOffset = ci->getSExtValue();
    }
    // 情况 2: 寄存器 + 常量的模式
    // 例如: [ebp - 4], [rsp + 16]
    else
    {
        for (SymbolicTree* n : root.getLevelOrder())
        {
            if (isa<AddOperator>(n->value)
                    && n->ops.size() == 2
                    && isa<LoadInst>(n->ops[0].value)
                    && isa<ConstantInt>(n->ops[1].value))
            {
                auto* l = cast<LoadInst>(n->ops[0].value);
                auto* ci = cast<ConstantInt>(n->ops[1].value);
                
                // 检查是否是寄存器 + 常量
                if (_abi->isRegister(l->getPointerOperand()))
                {
                    baseOffset = ci->getSExtValue();
                }
                break;
            }
        }
    }
    return baseOffset;
}
```

**偏移计算示例（仅适用于栈指针访问）：**

| x86 汇编 | 地址表达式 | 计算出的偏移 | 是否处理 | 说明 |
|---------|-----------|-------------|---------|------|
| `mov [ebp-4], eax` | `ebp + (-4)` | - | ❌ **不处理** | EBP 不是栈指针，保持原样 |
| `mov [ebp+8], ecx` | `ebp + 8` | - | ❌ **不处理** | EBP 不是栈指针，保持原样 |
| `mov [rsp+16], rdx` | `rsp + 16` | `+16` | ✅ **处理** | 临时栈空间（相对于 RSP） |
| `push rax` | `rsp - 8` | `-8` | ✅ **处理** | 栈顶操作（相对于 RSP） |

---

## 4. 栈偏移识别的核心机制

### 4.1 如何确定一个值是"栈上的偏移"

Stack Pass 通过以下**组合条件**判断：

```cpp
void StackAnalysis::handleInstruction(...)
{
    // 1. 构建符号树（展开地址计算表达式）
    auto root = SymbolicTree::PrecomputedRdaWithValueMap(RDA, val, &val2val);
    
    // 2. 检查表达式树中是否包含栈指针寄存器
    bool stackPtr = false;
    for (SymbolicTree* n : root.getPostOrder())
    {
        if (_abi->isStackPointerRegister(n->value))  // 是 RSP/ESP/RBP/EBP 吗？
        {
            stackPtr = true;
            break;
        }
    }
    
    // 3. 如果不包含栈指针，直接返回
    if (!stackPtr)
    {
        LOG << "===> no SP" << std::endl;
        return;
    }
    
    // 4. 简化表达式（常量折叠）
    root.simplifyNode();
    
    // 5. 提取偏移量
    auto* ci = dyn_cast_or_null<ConstantInt>(root.value);
    if (ci == nullptr)
    {
        return;  // 无法简化为常量，无法处理
    }
    int64_t offset = ci->getSExtValue();  // 这就是栈偏移！
    
    // 6. 创建局部变量
    // ...
}
```

### 4.2 Stack Pass 实际处理的访问模式

#### ❌ 模式 A：基于帧指针（RBP/EBP）- **不被 Stack Pass 处理**

**重要事实：**
- `isStackPointerRegister()` **只识别 SP 寄存器**，不识别 BP 寄存器
- 基于 RBP/EBP 的访问在 `handleInstruction` 第 2 步就被过滤掉
- **Stack Pass 不处理、不转换 RBP/EBP 访问**

```asm
; 基于 EBP 的访问（保持原样，不转换）
mov [ebp-4], eax   ; ❌ 不处理
mov [ebp-8], ebx   ; ❌ 不处理
mov eax, [ebp+8]   ; ❌ 不处理（函数参数）
```

**保持原样的 IR：**
```llvm
; Stack Pass 不会修改这些指令
%ebp = load i64, i64* @ebp
%addr = add i64 %ebp, -4
%ptr = inttoptr i64 %addr to i32*
store i32 %val, i32* %ptr   ; 保持复杂的地址计算
```

---

#### ✅ 模式 B：基于栈指针（RSP/ESP）- **Stack Pass 处理的唯一模式**

**这是 Stack Pass 实际处理的唯一模式：**
```

#### 模式 B：基于栈指针（RSP/ESP）- 复杂

**特征：** 直接使用 RSP 访问栈

```asm
sub rsp, 32       ; 分配栈空间
mov [rsp+24], rax ; 保存寄存器，offset = +24
mov [rsp+16], rbx ; 保存寄存器，offset = +16

; 中间可能有其他操作改变 RSP...

mov rax, [rsp+24] ; 恢复寄存器
add rsp, 32       ; 恢复栈
```

**问题：RSP 在运行中变化**

| 指令 | 执行后 RSP 值 | 访问位置计算 |
|-----|-------------|-------------|
| `sub rsp, 32` | RSP₀ - 32 | - |
| `mov [rsp+24], rax` | RSP₀ - 32 | (RSP₀-32)+24 = **RSP₀-8** |
| `call some_func` | RSP₀ - 40 | push 返回地址 |
| `mov rax, [rsp+24]` | RSP₀ - 40 | (RSP₀-40)+24 = **RSP₀-16** ❌ |

**Stack Pass 的局限性：**

```cpp
// 只提取表达式中的常量部分
if (isa<ConstantInt>(n->ops[1].value)) {
    return ci->getSExtValue();  // 返回 +24
}

// 不追踪 RSP 在运行时的动态变化！
```

**结果：**
- `[rsp+24]` 在 **位置 A** 和 **位置 B** 可能被当作**同一个偏移**处理
- 但实际上它们相对于函数入口的偏移是不同的

### 4.3 RDA 的作用和局限

**RDA 能做什么：**
```cpp
// 追踪简单的常量传播
%rsp_after_sub = sub i64 %rsp, 32   ; RDA 知道这是 RSP₀ - 32
%addr = add i64 %rsp_after_sub, 24  ; RDA 能计算出 RSP₀ - 8
```

**RDA 不能做什么：**
```asm
; 复杂控制流
sub rsp, 32
jz label_a
add rsp, 8    ; 路径 1: RSP = RSP₀ - 24
jmp label_b
label_a:
add rsp, 16   ; 路径 2: RSP = RSP₀ - 16
label_b:
; 此时 RSP 可能是 RSP₀-24 或 RSP₀-16（RDA 会合并）
mov [rsp+8], rax  ; 无法确定具体偏移
```

---

## 5. 栈顶/栈底识别机制

### 5.1 栈帧布局模型

```
高地址
┌─────────────────┐ ← RBP + 16 (参数 3)
│   参数 2         │ ← RBP + 12
├─────────────────┤
│   参数 1         │ ← RBP + 8
├─────────────────┤
│   返回地址       │ ← RBP + 4 (x86 32-bit)
├─────────────────┤
│   保存的 EBP     │ ← EBP (基址指针，稳定参考点)
├─────────────────┤
│   局部变量 1     │ ← EBP - 4
│   局部变量 2     │ ← EBP - 8
│      ...        │
│   局部变量 N     │ ← EBP - N*4
├─────────────────┤
│   临时空间       │ ← ESP (栈指针，动态变化)
└─────────────────┘ ← 栈向下增长
低地址
```

### 5.2 Stack Pass 处理的偏移类型

| 偏移范围 | 访问类型 | 参考点 | 是否处理 | 稳定性 |
|---------|---------|-------|---------|-------|
| **负偏移** `[ebp - N]` | 局部变量 | EBP | ❌ **不处理** | - |
| **正偏移** `[ebp + N]` | 函数参数 | EBP | ❌ **不处理** | - |
| **RSP 偏移** `[rsp + N]` | 临时栈空间 | RSP | ✅ **处理** | ⭐ 动态变化 |
| **RSP 偏移** `[rsp - N]` | push 操作 | RSP | ✅ **处理** | ⭐ 动态变化 |

**关键区别：**
- Stack Pass **只处理 RSP/ESP 访问**，不处理 RBP/EBP 访问
- RBP/EBP 访问保持原样（复杂的地址计算）

### 5.3 代码中的区分逻辑

```cpp
// Stack pass 不区分正负偏移，只提取常量值
int64_t offset = ci->getSExtValue();

// offset < 0: 通常是局部变量（相对于 RBP）
// offset > 0: 可能是参数（相对于 RBP）或临时空间（相对于 RSP）

// 创建 alloca 时使用该偏移作为标识
auto p = irModif.getStackVariable(
    inst->getFunction(),
    offset,        // 栈偏移作为唯一标识
    t,             // 类型
    name,          // 变量名
    ...
);
```

---

## 6. 实际转换示例详解

### 6.1 RBP 访问 - **不被处理**

**输入汇编：**
```asm
mov [ebp-4], eax   ; 基于 EBP 的局部变量赋值
```

**Decoder 输出：**
```llvm
%ebp = load i64, i64* @ebp
%addr = add i64 %ebp, -4
%ptr = inttoptr i64 %addr to i32*
store i32 %eax_val, i32* %ptr
```

**Stack Pass 处理：**
```cpp
// 检查栈指针
for (SymbolicTree* n : root.getPostOrder())
{
    if (_abi->isStackPointerRegister(n->value))
    {
        // @ebp 不是栈指针（isStackPointerRegister 返回 false）
        stackPtr = true;  // 不会执行到这里
        break;
    }
}

if (!stackPtr)
{
    LOG << "===> no SP" << std::endl;
    return;  // ❌ 直接返回，不做任何处理！
}
```

**输出（保持原样）：**
```llvm
; 与输入相同，未被修改
%ebp = load i64, i64* @ebp
%addr = add i64 %ebp, -4
%ptr = inttoptr i64 %addr to i32*
store i32 %eax_val, i32* %ptr
```

---

### 6.2 RSP 访问 - **被处理**

**输入汇编：**
```asm
sub rsp, 16
mov [rsp+8], rax
```

**Decoder 输出：**
```llvm
; 简化表示
%rsp_old = load i64, i64* @rsp
%rsp_new = sub i64 %rsp_old, 16
store i64 %rsp_new, i64* @rsp
%addr = add i64 %rsp_new, 8   ; offset = +8
%ptr = inttoptr i64 %addr to i64*
store i64 %rax, i64* %ptr
```

**问题：**
- Stack pass 提取的 offset 是 `+8`
- 但这个 `+8` 是相对于 `%rsp_new`（RSP₀ - 16）
- 相对于函数入口的实际偏移是：(RSP₀ - 16) + 8 = RSP₀ - 8

**RDA 的作用：**
```cpp
// RDA 追踪到 %rsp_new 是 RSP₀ - 16
// SymbolicTree 展开时可能传播这个信息
// 但实际源码中简化后只提取 +8
```

**局限性：**
- 如果后面有 `add rsp, 16` 恢复栈，RDA 可能能追踪
- 但如果 RSP 变化复杂（如条件分支），可能无法准确追踪

---

## 7. 边界情况和限制

### 7.1 无法处理的情况

| 情况 | 原因 | Stack Pass 行为 |
|-----|------|----------------|
| **动态栈分配** | `alloca` 大小是变量 | 无法确定偏移，跳过 |
| **复杂的指针算术** | 多级加减 | 简化失败，跳过 |
| **寄存器别名** | 使用非标准栈指针 | 无法识别，跳过 |
| **高度优化的代码** | 指令重排 | 模式匹配失败 |
| **跨函数栈访问** | 通过指针传递栈地址 | 无法识别为栈变量 |

### 7.2 保守策略

```cpp
// 如果无法简化为常量，直接返回
auto* ci = dyn_cast_or_null<ConstantInt>(root.value);
if (ci == nullptr)
{
    return;  // 不处理，保留原样
}

// 如果不是栈指针相关的访问
if (!stackPtr)
{
    return;  // 不处理
}
```

**结果：** 复杂情况保持原样，不强行转换，避免错误。

---

## 8. 与 BPA 的关系

### 8.1 Stack Pass 的实际输出

**Stack Pass 创建 `alloca` 的情况：**
- ✅ **基于 RSP/ESP 的访问**：转换为 `alloca`
- ❌ **基于 RBP/EBP 的访问**：**不转换**，保持原样

**BPA 面临的实际情况：**
- 只有 **RSP/ESP 访问**生成的 `alloca` 能被识别为栈块
- **RBP/EBP 访问**保持为复杂地址计算，BPA 需要额外处理才能识别

### 8.2 BPA 需要注意的问题

**实际情况：**
1. **RSP 访问被转换**：生成 `alloca`，BPA 可直接识别为栈块
2. **RBP 访问保持原样**：复杂的地址计算，BPA 需要额外处理

**建议：**
1. **识别 RSP 生成的 alloca**：这些是明确的栈块
2. **额外处理 RBP 访问**：需要分析 `[ebp+offset]` 模式识别栈变量
3. **谨慎处理 RSP 的动态变化**：如果函数有复杂的栈操作，offset 可能不准确

**验证方法：**
```bash
# 检查 RSP 访问生成的 alloca
grep "alloca" output.ll | wc -l

# 检查未转换的 RBP 访问（保持原样）
grep "load.*@ebp\|store.*@ebp" output.ll | wc -l

# 检查未转换的 RSP 访问（复杂的栈操作）
grep "load.*@rsp\|store.*@rsp" output.ll | wc -l
```

### 8.3 推荐配置

```json
{
    "decompParams": {
        "llvmPasses": [
            "retdec-decoder",
            "retdec-stack",              // ✅ 保留：创建栈变量 alloca
            // "retdec-stack-ptr-op-remove", // 可选：进一步规范化 RSP 操作
            // "retdec-register-localization", // ❌ BPA 禁用
            // "mem2reg",                      // ❌ BPA 禁用
            "retdec-write-ll"
        ]
    }
}
```

---

## 9. 总结

### 9.1 核心机制回顾

| 步骤 | 操作 | 关键代码 |
|-----|------|---------|
| **识别** | 检查是否包含栈指针寄存器 | `isStackPointerRegister()` |
| **展开** | 构建符号树，展开地址计算 | `SymbolicTree::PrecomputedRdaWithValueMap()` |
| **简化** | 常量折叠，简化表达式 | `root.simplifyNode()` |
| **提取** | 获取常量偏移 | `getBaseOffset()` |
| **创建** | 创建/获取局部 alloca | `getStackVariable()` |
| **替换** | 替换原有内存访问 | `new StoreInst/loadInst` |

### 9.2 关键澄清：Stack Pass 只处理 RSP/ESP 访问

| 访问模式 | 是否处理 | 转换结果 | 说明 |
|---------|---------|---------|------|
| `[rsp + N]` / `[rsp - N]` | ✅ **处理** | `alloca` + 简化访问 | 临时栈空间、push/pop |
| `[ebp - N]` / `[ebp + N]` | ❌ **不处理** | 保持复杂地址计算 | 局部变量/参数（保持原样）|

**重要事实：**
- `isStackPointerRegister()` **只识别 SP**，不识别 BP
- RBP/EBP 访问在 `handleInstruction` 第 2 步被过滤掉
- 只有基于 **RSP/ESP** 的访问会被转换为 `alloca`

**参考基准：**
- **RSP 访问**：参考点是动态的（访问时刻的 RSP），Stack Pass 处理
- **RBP 访问**：参考点是稳定的（函数入口的 RBP），**Stack Pass 不处理**

### 9.3 对于 BPA 的建议

1. **识别两种栈访问**：
   - RSP 访问 → `alloca`（已被 Stack Pass 转换）
   - RBP 访问 → 复杂地址计算（保持原样，需额外处理）
2. **注意 RSP 的动态变化**：复杂的栈操作可能导致 offset 不准确
3. **结合调试信息**：如果有 DWARF 信息，可以验证变量位置
4. **保守处理**：对于无法确定的情况，保持原始内存访问
