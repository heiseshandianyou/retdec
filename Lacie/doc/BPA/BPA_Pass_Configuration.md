# BPA 复现：RetDec Pass 配置指南

本文档说明在复现 BPA (Block-Based Pointer Analysis) 时，RetDec 的输入 IR 应该经过哪些 Pass，以及需要避免哪些 Pass。

---

## 1. BPA 对输入 IR 的需求

### 1.1 必需的 IR 特征

| 特征 | 说明 | LLVM IR 表示 |
|-----|------|-------------|
| **内存访问显式化** | 所有内存操作必须是 `load`/`store` | `load TYPE, ptr %addr` / `store TYPE %val, ptr %addr` |
| **栈变量识别** | 需要区分栈、堆、全局内存 | `alloca` 指令标识栈变量 |
| **地址计算** | 需要识别地址计算模式 | `getelementptr`, `ptrtoint`/`inttoptr` |
| **控制流图** | 需要基本的块和边结构 | `br`, `switch`, `indirectbr`, `call`, `ret` |
| **函数调用** | 需要识别直接/间接调用 | `call @func()` / `call %fptr()` |
| **内存块边界** | 需要识别内存对象边界 | 通过 `alloca`, 全局变量, `malloc` 调用识别 |

### 1.2 需要避免的 IR 转换

| 破坏性的 Pass | 原因 | 影响 |
|-------------|------|------|
| **`mem2reg`** | 将栈变量提升为 SSA 寄存器，消除 `alloca`/`load`/`store` | 破坏栈内存块识别，BPA 无法追踪栈变量 |
| **激进的 `instcombine`** | 可能合并/消除内存访问 | 可能消除 BPA 需要分析的 `load`/`store` |
| **`sroa` (Scalar Replacement of Aggregates)** | 将结构体分解为独立标量 | 破坏结构体作为单一内存块的模型 |
| **过于激进的 `dse` (Dead Store Elimination)** | 消除看似无用的存储 | 可能消除对后续分析有用的存储 |

---

## 2. 推荐的 Pass Pipeline

### 2.1 最小配置（仅保留内存访问模式）

```json
{
    "decompParams": {
        "llvmPasses": [
            "retdec-provider-init",
            "retdec-decoder",
            "verify",
            
            // ===== 必需的预处理 Passes =====
            "retdec-x86-addr-spaces",     // x86 地址空间处理
            "retdec-x87-fpu",             // FPU 指令处理（如果涉及浮点）
            "retdec-syscalls",            // 系统调用识别
            
            // ===== 栈分析（对 BPA 至关重要）=====
            "retdec-stack",               // 栈帧分析，识别局部变量
            
            // ===== 保守的指令优化（可选但推荐）=====
            // "retdec-inst-opt",          // 基础指令优化（保守）
            // "retdec-cond-branch-opt",   // 条件分支优化
            
            // ===== 常量传播（帮助识别地址）=====
            "retdec-constants",           // 常量传播
            
            // ===== 函数边界分析 =====
            "retdec-param-return",        // 参数/返回值分析
            "retdec-main-detection",      // main 函数检测
            
            // ===== 类型信息（可选）=====
            // "retdec-simple-types",      // 简单类型恢复
            
            // ===== 清理（保守）=====
            "retdec-remove-asm-instrs",   // 移除汇编指令标记
            "retdec-unreachable-funcs",   // 移除不可达函数
            
            // ===== 输出 =====
            "verify",
            "retdec-write-ll"
        ]
    }
}
```

### 2.2 完整配置（带详细说明）

```json
{
    "decompParams": {
        "llvmPasses": [
            // ==================== 阶段 1: 初始化和解码 ====================
            "retdec-provider-init",       // 初始化 ABI、命名等
            "retdec-decoder",             // 核心：机器码 → LLVM IR
            "verify",                     // 验证 IR 正确性
            
            // ==================== 阶段 2: 架构特定处理 ====================
            "retdec-x86-addr-spaces",     // x86 地址空间（fs/gs 段寄存器）
            "retdec-x87-fpu",             // x87 FPU 栈处理
            
            // ==================== 阶段 3: 控制流和调用图 ====================
            "retdec-main-detection",      // 识别 main 函数入口
            "retdec-idioms-libgcc",       // 识别编译器生成的模式
            // "retdec-cond-branch-opt",   // 条件分支优化（可选，可能影响控制流）
            "retdec-syscalls",            // 系统调用识别和处理
            
            // ==================== 阶段 4: 栈和内存分析（BPA关键）====================
            "retdec-stack",               // 【必需】栈帧分析
            // "retdec-stack-ptr-op-remove", // 栈指针操作移除（可选，可能过于激进）
            
            // ==================== 阶段 5: 保守的指令优化 ====================
            // ⚠️ 以下优化是可选的，如果追求精确性可以跳过
            // "retdec-inst-opt",          // 基础指令优化（相对保守）
            // "retdec-inst-opt-rda",      // 基于RDA的优化（较激进，可能移除有用存储）
            
            // ==================== 阶段 6: 常量和类型 ====================
            "retdec-constants",           // 常量传播（帮助识别地址常量）
            // "retdec-simple-types",      // 简单类型恢复（可选）
            
            // ==================== 阶段 7: 函数分析 ====================
            "retdec-param-return",        // 参数和返回值分析
            // "retdec-class-hierarchy",   // C++ 类层次结构（如果分析C++二进制）
            
            // ==================== 阶段 8: 清理和准备 ====================
            "retdec-select-fncs",         // 选择要分析的函数
            "retdec-unreachable-funcs",   // 移除不可达函数
            "retdec-remove-asm-instrs",   // 清理汇编指令标记
            
            // ==================== 阶段 9: 输出准备 ====================
            "retdec-value-protect",       // 值保护（防止后续优化破坏）
            "verify",
            "retdec-write-ll"
        ]
    }
}
```

---

## 3. 关键 Pass 详解

### 3.1 必须保留的 Pass

#### `retdec-decoder`
- **作用**: 将机器码转换为 LLVM IR
- **BPA 重要性**: ⭐⭐⭐⭐⭐ 核心输入源
- **输出特征**: 显式的 `load`/`store`，全局寄存器变量

#### `retdec-stack` ⭐⭐⭐⭐⭐
- **作用**: 分析栈帧结构，识别局部变量
- **BPA 重要性**: 识别栈内存块的关键
- **说明**: BPA 需要识别栈帧边界来建立栈内存块模型

```llvm
; retdec-stack 前：低层级的栈指针操作
%1 = load i64, i64* @rsp
%2 = sub i64 %1, 16
store i64 %2, i64* @rsp

; retdec-stack 后：识别为局部变量
%local_var = alloca i64, align 8
store i64 %val, i64* %local_var
```

#### `retdec-constants`
- **作用**: 常量传播和折叠
- **BPA 重要性**: 帮助识别全局变量地址、跳转表地址

### 3.2 应该避免的 Pass

#### `mem2reg` ❌❌❌
- **作用**: 将 `alloca` 提升为 SSA 寄存器
- **为什么避免**: 消除 `load`/`store`，破坏内存块模型
- **影响**: BPA 无法识别栈变量，无法进行栈内存分析

```llvm
; mem2reg 前：BPA 可以分析
%ptr = alloca i32
store i32 10, i32* %ptr
%val = load i32, i32* %ptr

; mem2reg 后：BPA 无法识别为内存操作
; %ptr 被替换为 SSA 值，失去内存语义
```

#### `retdec-inst-opt-rda` ⚠️
- **作用**: 基于到达定值分析的激进指令优化
- **为什么谨慎**: 可能消除 BPA 需要追踪的 `store` 指令
- **建议**: BPA 复现时禁用，或确认其行为保守

#### `sroa` (Scalar Replacement of Aggregates) ❌
- **作用**: 将聚合类型（结构体/数组）分解为标量
- **为什么避免**: 破坏结构体作为单一内存块的抽象

---

## 4. BPA 特定的 IR 准备

### 4.1 内存块识别准备

为了让 BPA 正确识别三种内存块，IR 需要包含以下特征：

#### 栈块 (Stack Blocks)
```llvm
; 需要保留 alloca 指令
%local_var = alloca i64, align 8
%gep = getelementptr i8, ptr %local_var, i64 8
store i64 %val, ptr %gep
```

#### 堆块 (Heap Blocks)
```llvm
; 需要识别 malloc/calloc 调用
%ptr = call i8* @malloc(i64 %size)
%cast = bitcast i8* %ptr to i64*
store i64 %val, i64* %cast
```

#### 全局块 (Global Blocks)
```llvm
; 全局变量定义
@global_var = global i64 42
store i64 %new_val, i64* @global_var
```

### 4.2 指针算术保留

BPA 需要识别指针算术操作：

```llvm
; 应该保留的模式
%ptr = alloca [10 x i32]
%idx = getelementptr i32, ptr %ptr, i64 %i  ; 数组索引

; 或指针算术
%ptr_int = ptrtoint ptr %base to i64
%new_int = add i64 %ptr_int, 8
%new_ptr = inttoptr i64 %new_int to ptr
```

---

## 5. 推荐的 LLVM 优化 Pass 配置

### 5.1 避免标准 LLVM 优化

标准的 LLVM 优化管道对 BPA 来说通常过于激进：

```json
// ❌ 避免这些标准 LLVM Pass
"llvmPasses": [
    // 不要包含以下 Pass：
    // "mem2reg",              // 消除 alloca/load/store
    // "sroa",                 // 分解聚合类型
    // "instcombine",          // 可能消除内存访问
    // "gvn",                  // 全局值编号，可能消除加载
    // "dse",                  // 死存储消除（过于激进）
    // "loop-load-elim",       // 循环加载消除
    // "sccp",                 // 稀疏条件常量传播（可能过度传播）
]
```

### 5.2 可选的安全 LLVM Pass

以下 Pass 相对安全，可以使用：

```json
// ✅ 相对安全的 LLVM Pass
"llvmPasses": [
    "verify",               // 验证 IR
    "strip-dead-prototypes", // 移除未使用的函数声明
    "globaldce",            // 移除未使用的全局变量（保留使用的）
]
```

---

## 6. 完整配置示例

### 6.1 最简配置（推荐用于 BPA 复现）

```json
{
    "decompParams": {
        "verboseOut": true,
        "outputFormat": "plain",
        "keepAllFuncs": true,
        "outputLlFile": "output.ll",
        "llvmPasses": [
            "retdec-provider-init",
            "retdec-decoder",
            "verify",
            "retdec-x86-addr-spaces",
            "retdec-x87-fpu",
            "retdec-main-detection",
            "retdec-syscalls",
            "retdec-stack",
            "retdec-constants",
            "retdec-param-return",
            "retdec-remove-asm-instrs",
            "retdec-unreachable-funcs",
            "verify",
            "retdec-write-ll"
        ]
    }
}
```

### 6.2 带可选优化的配置

```json
{
    "decompParams": {
        "verboseOut": true,
        "outputFormat": "plain",
        "keepAllFuncs": true,
        "outputLlFile": "output.ll",
        "llvmPasses": [
            "retdec-provider-init",
            "retdec-decoder",
            "verify",
            "retdec-x86-addr-spaces",
            "retdec-x87-fpu",
            "retdec-main-detection",
            "retdec-idioms-libgcc",
            "retdec-syscalls",
            "retdec-stack",
            // 可选：基础指令优化（相对保守）
            "retdec-inst-opt",
            // 可选：类型恢复
            "retdec-simple-types",
            "retdec-constants",
            "retdec-param-return",
            "retdec-select-fncs",
            "retdec-unreachable-funcs",
            "retdec-remove-asm-instrs",
            "retdec-value-protect",
            "verify",
            "retdec-write-ll"
        ]
    }
}
```

---

## 7. 验证 IR 是否适合 BPA

### 7.1 检查清单

运行 RetDec 后，检查生成的 `.ll` 文件：

```bash
# 1. 检查是否有 alloca（栈变量）
grep -c "alloca" output.ll
# 应该 > 0

# 2. 检查是否有 load/store
grep -c "load " output.ll
grep -c "store " output.ll
# 应该有很多

# 3. 检查是否有 malloc/calloc 调用（堆识别）
grep -c "malloc\|calloc" output.ll

# 4. 检查是否有全局变量
grep -c "^@" output.ll

# 5. 确保没有过早的 mem2reg（检查 phi 节点数量）
grep -c "phi " output.ll
# 如果 phi 过多，可能 mem2reg 已经被运行

# 6. 检查间接调用（BPA 的目标）
grep -c "call.*%" output.ll
```

### 7.2 理想的 IR 特征

适合 BPA 的 IR 应该包含：

```llvm
; 1. 显式的栈分配（alloca）
%local = alloca i64, align 8

; 2. 显式的内存访问（load/store）
store i64 %val, i64* %local
%loaded = load i64, i64* %local

; 3. 全局寄存器变量（RetDec 特有）
store i64 %val, i64* @rax
%rax_val = load i64, i64* @rax

; 4. 堆分配调用
%heap = call i8* @malloc(i64 16)

; 5. 间接调用（BPA 分析目标）
call void %fptr(i64 %arg)

; 6. 地址计算（GEP 或 ptrtoint/inttoptr）
%addr = getelementptr i8, ptr %base, i64 8
```

---

## 8. 常见问题

### Q1: `retdec-inst-opt-rda` 是否安全？
**A**: 当前实现相对保守，只启用了一个优化策略。但建议 BPA 复现时禁用，以确保所有内存访问都被保留。

### Q2: 是否可以运行 `mem2reg`？
**A**: 不建议。`mem2reg` 会消除 `alloca` 和相关的 `load`/`store`，破坏 BPA 的栈内存块识别。

### Q3: 如何处理 C++ 二进制？
**A**: 可以启用 `retdec-class-hierarchy` 来识别虚函数表，这对 BPA 分析间接调用有帮助。

### Q4: 是否需要 `retdec-register-localization`？
**A**: 不需要。该 Pass 尝试将全局寄存器变量转换为局部 SSA 值，可能会干扰 BPA 的寄存器追踪。

---

## 9. 总结

| 类别 | 推荐配置 |
|-----|---------|
| **核心必需** | `retdec-decoder`, `retdec-stack`, `retdec-constants` |
| **推荐启用** | `retdec-x86-addr-spaces`, `retdec-syscalls`, `retdec-param-return` |
| **谨慎使用** | `retdec-inst-opt`, `retdec-cond-branch-opt` |
| **建议避免** | `mem2reg`, `retdec-inst-opt-rda`, `retdec-register-localization` |
| **绝对避免** | 标准 LLVM 优化管道（`instcombine`, `gvn`, `sroa` 等）|

**核心原则**: BPA 需要显式的内存访问模式（`load`/`store`/`alloca`），任何可能消除这些模式的 Pass 都应该避免。
