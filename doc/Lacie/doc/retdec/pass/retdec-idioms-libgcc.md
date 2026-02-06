# retdec-idioms-libgcc

`retdec-idioms-libgcc` 是 RetDec 中用于识别并转换编译器（特别是 GCC/libgcc）生成的特殊算术惯用法（Idioms）的 LLVM Pass。它将这些复杂的运行时库调用还原为标准的 LLVM IR 指令。

## 功能概述

在某些架构（如 ARM 或某些位宽受限的 x86）上，编译器无法直接用单条硬件指令完成复杂的算术运算（如 64 位除法、浮点转整数等）。此时，GCC 等编译器会生成对运行时辅助库（`libgcc` 或 `aeabi`）的函数调用。这些调用在 IR 中表现为普通的 `CallInst`，但其语义实际上是基础算术运算。`retdec-idioms-libgcc` 的目标是识别这些特定的函数名，并将其替换为更直观的 LLVM 原生指令（如 `sdiv`, `fptosi`），从而简化代码结构并提高反编译结果的可读性。

## 算法流程

该 Pass 通过函数名匹配和操作数重组来实现语义恢复：

1.  **标识符定义**：
    -   Pass 维护了一个庞大的已知 `libgcc` 函数名列表。
    -   例如：`__aeabi_idivmod` (除法余数), `__ashldi3` (64位左移), `__floatsidf` (整型转双精度), `__adddf3` (双精度加法) 等。

2.  **指令扫描**：
    -   遍历模块中所有的 `CallInst` 指令。
    -   提取被调用函数的名称，并检查是否匹配已知的惯用法列表。

3.  **分门别类的转换逻辑（`IdiomsLibgccImpl`）**：
    -   **整数除法/取模**：将 `__aeabi_idiv` 等调用转换为 LLVM 的 `sdiv`, `udiv`, `srem`, `urem` 指令。如果函数同时返回商和余数，则正确分发结果。
    -   **位移运算**：将 `__ashldi3` 等 64 位位移辅助函数转换为 LLVM 的 `shl`, `ashr`, `lshr`。
    -   **浮点运算**：将双精度/单精度的加减乘除辅助库（如 `__adddf3`）转换为 `fadd`, `fsub`, `fmul`, `fdiv`。
    -   **类型转换**：将浮点与整数、单精度与双精度之间的转换函数（如 `__fixdfsi`）还原为 `fptosi`, `sitofp`, `fpext`, `fptrunc`。
    -   **浮点比较**：将 `__cmpsf2` 等返回整数值的比较函数还原为 `fcmp` 结合 `select` 指令。

4.  **操作数提取与重组**：
    -   利用 `getOp0`, `getOp1` 等内部辅助函数提取被调用函数的实参。
    -   创建新的 LLVM 指令，并将原本 `CallInst` 的所有使用者替换为新指令的结果（`replaceAllUsesWith`）。
    -   最后删除原始的库函数调用。

## 相关文件

-   `idioms_libgcc.cpp`: 包含完整的惯用法识别列表和具体的转换函数。
-   `idioms_libgcc.h`: 类定义。

## 总结

`retdec-idioms-libgcc` 是针对“跨架构辅助函数”的定向优化。它抹去了编译器为了兼容硬件而引入的实现细节，通过将这些人为制造的库调用还原回基本的数学运算，使得生成的代码更符合程序员的逻辑思维，同时也增强了反编译引擎对不同平台的兼容性。
