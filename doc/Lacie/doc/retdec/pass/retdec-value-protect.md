# retdec-value-protect

`retdec-value-protect` 是 RetDec 中的一个重要分析辅助 Pass，用于“保护”特定的 LLVM 值（如寄存器、栈变量和关键常量）不被 LLVM 默认的优化 Pass（如 `instcombine`, `gvn`, `dce`）修改或消除。

## 功能概述

LLVM 的内置优化虽然强大，但它们是为正向编译设计的。在反编译过程中，LLVM 可能会认为某些“看似无用”的硬件状态操作（如对未初始化寄存器的读写，或对 `nullptr`/`undef` 的操作）是死代码并将其删除。`retdec-value-protect` 的作用是在 LLVM 优化运行前，通过插入虚假的依赖关系（“保护”），保留这些逆向分析中不可或缺的信息。

## 算法流程

该 Pass 的工作模式分为“保护（Protect）”和“取消保护（Unprotect）”两个阶段：

### 1. 保护阶段（Protect）
通过插入外部函数调用来制造“值正在被使用”的假象，防止优化器将其删除：

-   **栈保护（`protectStack`）**：遍历函数入口块的所有 `AllocaInst`（栈变量），在它们后面插入一个虚假的存储操作（`StoreInst`），数据来源于一个外部定义的影子函数（如 `__undef_function_0`）。
-   **寄存器保护（`protectRegisters`）**：对于 ABI 中定义的全局寄存器，如果它们在函数中被使用，同样在函数开始处插入虚假的读写操作，使优化器认为寄存器状态在函数入口处是“活跃”的。
-   **异常内存访问保护（`protectLoadStores`）**：
    -   如果代码中出现了对 `undef` 或 `nullptr` 的 `load`/`store`（这在反编译不完整时很常见），LLVM 优化器可能会将后续代码判定为不可达。
    -   该 Pass 将这些危险操作替换为对特殊内部函数（如 `__readNullptrDword`, `__writeUndefByte` 等）的调用。这些函数被标记为具有副作用，从而阻止 LLVM 优化器进行破坏性假设。

### 2. 取消保护阶段（Unprotect）
在 LLVM 优化 Pass 运行完毕后，再次运行该 Pass：

-   识别出之前插入的所有虚假调用（Shadow functions）。
-   移除这些虚假调用。
-   如果被保护的值仍有其他引用，则使用合法的 `AllocaInst` 或 `LoadInst` 将其替换回原本的形态。
-   清理所有不再使用的影子函数定义。

## 相关文件

-   `value_protect.cpp`: 核心保护算法实现。
-   `value_protect.h`: 类定义。

## 总结

`retdec-value-protect` 是 RetDec 与 LLVM 优化器之间的一道“防火墙”。它利用 LLVM 自身对外部函数副作用的保守假设，巧妙地锁定了反编译所需的原始硬件语义。通过“先保护、后优化、再还原”的策略，它既享受了 LLVM 带来的代码简化，又确保了关键逆向信息的准确留存。
