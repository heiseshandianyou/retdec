# retdec-stack
 
 `retdec-stack` 是 RetDec 中的一个 LLVM Pass，用于从原始汇编转换而来的 LLVM IR 中重建栈结构和局部变量。
 
 ## 功能概述
 
 在二进制反编译过程中，栈操作最初被建模为对一个大内存数组或寄存器的偏移访问（如 `esp + offset`）。`retdec-stack` 的任务是识别出这些基于栈指针的访问，并将其转换为具体的 LLVM `alloca` 指令（即局部变量），从而使 IR 更加接近高级语言的表示。
 
 ## 核心算法：基于符号树的栈帧重建

`retdec-stack` 的核心挑战在于：在 LLVM IR 中，栈地址通常表现为复杂的算术运算（如 `add i32 %esp_val, -16`）。该 Pass 通过以下深层机制解决此问题：

### 1. 增强型到达定值分析 (RDA)
该 Pass 依赖于 `Reaching Definitions Analysis`。它不仅追踪值的定义，还通过 `SymbolicTree` 将这些定义聚合为一个符号表达式。

### 2. 符号树构建与 `val2val` 缓存
在处理函数指令时，Pass 维护一个 `val2val` 映射：
*   **缓存机制**：如果一个复杂的地址计算结果被存储到寄存器或内存位置，`val2val` 会记录其对应的符号常数值。
*   **回溯追踪**：当遇到 `Load` 或 `Store` 时，`SymbolicTree` 会递归地向上寻找操作数的来源。如果遇到栈指针寄存器（由 ABI 决定，如 x86 的 `ESP`），它会将整个表达式折算为相对于栈顶的偏移。

### 3. 基准偏移提取 (Base Offset Extraction)
算法通过 `getBaseOffset` 方法从符号树中提取常量偏移：
*   **直接常量**：如果符号树简化后是一个常量，直接提取。
*   **模式匹配**：识别 `[Register + Constant]` 这种常见的寻址模式，从中提取 `Constant` 作为栈内偏移量。

### 4. 变量重建与语义注入
一旦确定了某个内存访问是在操作栈（即：符号树包含 SP 且能算出一个确定的 Offset），Pass 执行以下转换：

1.  **创建 Alloca**：调用 `IrModifier::getStackVariable`。
    *   **唯一性检查**：如果该偏移量（Offset）在当前函数中已经创建过 `alloca` 指令，则复用该指令。
    *   **元数据关联**：如果调试信息中有对应的变量名（如 `int a`），则将 `alloca` 命名为 `a`，否则生成默认名（如 `stack_-16`）。
2.  **指令改写 (Rewriting)**：
    *   **Store 改写**：`store %val, %stack_ptr` 变为 `store %val, %alloca_inst`。
    *   **Load 改写**：`%res = load %stack_ptr` 变为 `%res = load %alloca_inst`。
    *   **类型适配**：使用 `IrModifier::convertValueToType` 自动处理整型、指针或结构体之间的类型转换，确保生成的 IR 符合 LLVM 的类型检查（Verifier）。

## 实例演示：栈变量恢复对比

以下展示了 `retdec-stack` 如何将底层的寄存器操作转换为高层的局部变量访问。

### 场景：识别栈变量赋值

#### Pass 运行前：原始汇编转换的 IR
此时的 IR 充满了底层对寄存器（全局变量）和内存（偏移量）的操作。
```llvm
; %stack_ptr 是全局变量，代表 ESP 寄存器
%1 = load i32, i32* @stack_ptr    ; 获取当前栈顶
%2 = sub i32 %1, 16               ; 计算局部变量地址 (ESP - 16)
%3 = inttoptr i32 %2 to i32*      ; 地址转为指针
store i32 123, i32* %3            ; [ESP-16] = 123
```

#### Pass 运行后：语义恢复后的 IR
`retdec-stack` 运行后，在函数入口创建了 `alloca`，并将上述指令重写为：
```llvm
; 函数入口 (Entry Block)
%var_10 = alloca i32               ; 重建出的栈变量

; ... 指令原位置被重写 ...
store i32 123, i32* %var_10        ; 语义清晰的局部变量赋值
```

---

## 相关文件

-   `stack.cpp`: Pass 的核心实现逻辑，包含 `handleInstruction`。
-   `stack.h`: 类定义。
-   `retdec/bin2llvmir/analyses/reaching_definitions.h`: 定值到达分析的接口。
-   `retdec/bin2llvmir/utils/symbolic_tree.h`: 符号表达式树的实现，支持基于 RDA 的动态构建。
-   `retdec/bin2llvmir/utils/ir_modifier.h`: 提供创建 `alloca`、重命名函数和指令替换的高级 API。

## 总结

`retdec-stack` 是将反汇编代码“去汇编化”的关键步骤。它通过分析复杂的寄存器操作，提取出隐藏的栈帧布局，将底层的内存读写转化为高层的局部变量操作，为后续的结构化分析（如控制流重建）提供了清晰的数据基础。
