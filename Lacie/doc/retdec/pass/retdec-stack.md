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

各架构的栈指针寄存器：
| 架构 | 栈指针寄存器 |
|-----|-------------|
| x86 | `esp` (32-bit) |
| x64 | `rsp` (64-bit) |
| ARM | `sp` |
| ARM64 | `sp` |
| MIPS | `sp` |
| PowerPC | `r1` |

#### 步骤 3：计算栈偏移

```cpp
std::optional<int> StackAnalysis::getBaseOffset(SymbolicTree& root)
{
    // 情况 1: 直接是常量
    if (auto* ci = dyn_cast_or_null<ConstantInt>(root.value))
    {
        return ci->getSExtValue();  // 返回常量值作为偏移
    }
    
    // 情况 2: 寄存器 + 常量的模式
    // 例如: [ebp + offset] 或 [rsp + offset]
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
                return ci->getSExtValue();  // 返回偏移量
            }
        }
    }
    return std::nullopt;
}
```

**偏移计算示例：**

| x86 汇编 | 地址表达式 | 计算出的偏移 |
|---------|-----------|-------------|
| `mov [ebp-4], eax` | `ebp + (-4)` | `-4` |
| `mov [ebp+8], ecx` | `ebp + 8` | `+8` (参数) |
| `mov [rsp+16], rdx` | `rsp + 16` | `+16` |

#### 步骤 4：查找调试信息

```cpp
// 尝试从调试信息获取变量名
auto* debugSv = getDebugStackVariable(inst->getFunction(), root);

// 尝试从配置文件获取变量名
auto* configSv = getConfigStackVariable(inst->getFunction(), root);
```

**调试信息查找逻辑：**
1. 计算栈偏移
2. 在调试信息的 `locals` 列表中查找匹配的栈变量
3. 比较栈偏移是否相等

#### 步骤 5：创建/获取局部变量

```cpp
// 使用 IrModifier 创建或获取栈变量
auto p = irModif.getStackVariable(
    inst->getFunction(),    // 当前函数
    ci->getSExtValue(),     // 栈偏移
    t,                      // 变量类型
    name,                   // 变量名（来自调试信息或自动生成）
    realName,               // 真实名称
    debugSv || configSv     // 是否有调试信息
);

AllocaInst* a = p.first;    // 获取创建的 alloca
```

#### 步骤 6：替换指令

```cpp
// 情况 1: Store 指令
if (s && s->getPointerOperand() == val)
{
    auto* conv = IrModifier::convertValueToType(
            s->getValueOperand(),
            a->getType()->getElementType(),
            inst);
    new StoreInst(conv, a, inst);    // 创建新的 store 到 alloca
    _toRemove.insert(s);              // 标记原指令删除
}
// 情况 2: Load 指令
else if (l && l->getPointerOperand() == val)
{
    auto* nl = new LoadInst(a, "", l);  // 从 alloca 加载
    auto* conv = IrModifier::convertValueToType(nl, l->getType(), l);
    l->replaceAllUsesWith(conv);         // 替换所有使用
    _toRemove.insert(l);                 // 标记原指令删除
}
```

---

## 4. 栈顶/栈底识别机制

### 4.1 栈帧布局模型

RetDec 使用以下模型识别栈变量：

```
高地址
┌─────────────────┐
│   返回地址       │  <- ebp + 4 (x86)
├─────────────────┤
│   保存的 ebp     │  <- ebp (基址指针)
├─────────────────┤
│   局部变量 1     │  <- ebp - 4
│   局部变量 2     │  <- ebp - 8
│      ...        │
│   局部变量 N     │  <- ebp - N*4
├─────────────────┤
│   临时空间       │  <- esp (栈指针)
└─────────────────┘
低地址
```

### 4.2 正负偏移的区分

| 偏移范围 | 说明 | 示例 |
|---------|------|------|
| **负偏移** (ebp - N) | 局部变量 | `[ebp-4]`, `[ebp-8]` |
| **正偏移** (ebp + N) | 函数参数 | `[ebp+8]`, `[ebp+12]` |
| **rsp 偏移** | 临时栈空间 | `[rsp+16]` |

### 4.3 识别逻辑

```cpp
// 在 getBaseOffset() 中
if (isa<AddOperator>(n->value) && n->ops.size() == 2)
{
    // 模式: 寄存器 + 常量偏移
    // 例如: add i64 %ebp, -4
    auto* ci = cast<ConstantInt>(n->ops[1].value);
    int64_t offset = ci->getSExtValue();
    
    // offset < 0: 局部变量 (ebp - N)
    // offset > 0: 函数参数 (ebp + N)
}
```

---

## 5. SymbolicTree 的作用

### 5.1 符号树构建

`SymbolicTree` 用于表示和展开复杂的地址计算表达式：

```llvm
; 原始表达式
%addr = add i64 %ebp, -4

; 符号树表示
AddOperator (add)
├── LoadInst (ebp)
│   └── GlobalVariable (@ebp)
└── ConstantInt (-4)
```

### 5.2 展开过程

```cpp
SymbolicTree::expandNode(
    ReachingDefinitionsAnalysis* RDA,
    ...,
    bool linear)
{
    // 根据值的类型展开节点
    if (isa<AddOperator>(value))
    {
        // 展开加法操作的两个操作数
        ops.emplace_back(...);
        ops.emplace_back(...);
    }
    else if (isa<LoadInst>(value))
    {
        // 如果是 load，可以继续展开定值
        if (RDA)
        {
            auto* def = RDA->getDef(...);
            // 展开定值...
        }
    }
    // ... 其他类型
}
```

### 5.3 简化节点

```cpp
root.simplifyNode();
```

简化过程会折叠常量表达式，例如：
- `(ebp + 4) + (-8)` → `ebp + (-4)`
- `(rsp + 16) - 8` → `rsp + 8`

---

## 6. 调试信息的利用

### 6.1 调试信息匹配

```cpp
const retdec::common::Object* StackAnalysis::getDebugStackVariable(
        llvm::Function* fnc,
        SymbolicTree& root)
{
    // 1. 计算栈偏移
    auto baseOffset = getBaseOffset(root);
    if (!baseOffset.has_value()) return nullptr;
    
    // 2. 从调试格式获取函数信息
    auto* debugFnc = _dbgf->getFunction(_config->getFunctionAddress(fnc));
    if (debugFnc == nullptr) return nullptr;
    
    // 3. 遍历局部变量，匹配栈偏移
    for (auto& var : debugFnc->locals)
    {
        if (!var.getStorage().isStack()) continue;
        
        if (var.getStorage().getStackOffset() == baseOffset)
        {
            return &var;  // 找到匹配的变量
        }
    }
    return nullptr;
}
```

### 6.2 命名策略

| 信息来源 | 命名方式 | 优先级 |
|---------|---------|-------|
| 调试信息 | 原始变量名（如 `local_count`） | 最高 |
| 配置文件 | 配置中的变量名 | 中 |
| 自动生成 | `stack_var_X` 或基于偏移 | 低 |

---

## 7. 边界情况和限制

### 7.1 无法处理的情况

| 情况 | 原因 | 结果 |
|-----|------|------|
| **动态栈分配** | `alloca` 大小是变量 | 无法确定偏移 |
| **复杂的指针算术** | 多级指针操作 | 可能无法展开 |
| **寄存器别名** | 使用非标准栈指针 | 无法识别 |
| **优化的代码** | 高度优化的栈操作 | 模式匹配失败 |

### 7.2 保守策略

```cpp
// 如果无法识别为栈访问，直接返回不做处理
if (!stackPtr)
{
    LOG << "===> no SP" << std::endl;
    return;
}

// 如果无法简化为常量，无法处理
auto* ci = dyn_cast_or_null<ConstantInt>(root.value);
if (ci == nullptr)
{
    return;
}
```

---

## 8. 与其他 Pass 的关系

### 8.1 Pipeline 位置

```
decoder -> stack -> register-localization -> mem2reg -> ...
   ↓          ↓                ↓               ↓
机器码    栈变量识别     全局寄存器      提升为 SSA
        (alloca)       转为局部        虚拟寄存器
```

### 8.2 与 BPA 的关系

**对 BPA 的重要性：**
- `stack` pass **创建** `alloca` 指令，标识栈内存块
- BPA 需要这些 `alloca` 来识别**栈内存块**
- **建议 BPA 复现时保留此 pass**，否则无法分析栈变量

### 8.3 与 mem2reg 的关系

| 阶段 | IR 形式 | 说明 |
|-----|---------|------|
| decoder 后 | 全局变量 `@rax`, `@rsp` + 复杂地址计算 | 最低级 |
| stack 后 | `alloca` + 简单 load/store | 中级 |
| mem2reg 后 | SSA 虚拟寄存器 | 最高级 |

**BPA 建议停在 stack 阶段**，不要运行 mem2reg。

---

## 9. 调试技巧

### 9.1 查看转换前后的 IR

```bash
# 运行到 stack pass 前
retdec-decompiler --stop-after decoder binary -o before.ll

# 运行 stack pass
opt -load libretdec.so -retdec-stack before.ll -o after.ll

# 对比
diff before.ll after.ll
```

### 9.2 检查栈变量识别

```bash
# 统计 alloca 数量（stack pass 创建）
grep -c "alloca" output.ll

# 查看栈变量名
grep "alloca" output.ll | head -20
```

### 9.3 日志输出

设置日志级别查看详细过程：
```cpp
LOG << "===> " << llvmObjToString(ci) << std::endl;
LOG << "===> " << ci->getSExtValue() << std::endl;
LOG << "===> " << llvmObjToString(a) << std::endl;
```

---

## 10. 总结

`retdec-stack` 是 RetDec 栈分析的核心 Pass，它：

1. **识别栈指针模式**：通过 ABI 识别各架构的栈指针寄存器
2. **计算栈偏移**：使用符号树展开和简化地址表达式
3. **创建局部变量**：将栈位置转换为 LLVM `alloca`
4. **利用调试信息**：恢复原始变量名（如果可用）

**对于 BPA 复现**：
- ✅ **必须运行**，创建 `alloca` 供 BPA 识别栈内存块
- ⚠️ **不要运行 mem2reg**，否则会消除 `alloca`

**关键输出**：
- 带有 `alloca` 的 LLVM IR
- 简化后的栈访问（直接对 `alloca` 的 load/store）
- 保留的调试信息变量名
