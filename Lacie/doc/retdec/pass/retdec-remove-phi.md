# retdec-remove-phi

`retdec-remove-phi` 是 RetDec 中的一个 LLVM Pass，用于将模块中的所有 Phi 节点（`PHINode`）转换为基于栈的内存操作（`alloca`, `load`, `store`）。

## 功能概述

在 LLVM IR 的 SSA（静态单赋值）形式中，Phi 节点用于处理控制流合并时的变量多版本问题。虽然 SSA 形式对编译器优化非常有利，但在反编译的后期阶段，Phi 节点可能会让控制流图和变量识别变得复杂。`retdec-remove-phi` 的目的是通过“降级”这些 Phi 节点，将 SSA 形式恢复为类似于非 SSA 的内存读写形式，从而简化后续的结构化分析（如控制流重建）。

## 算法流程

该 Pass 的核心是将每一个 Phi 节点“降级到栈”（Demote to Stack），采用了类似于 LLVM 官方 `demotePHIToStack` 的算法，但额外保留了指令地址元数据：

1.  **全局遍历**：
    -   遍历模块中的所有非声明函数。

2.  **定位 Phi 节点**：
    -   检查函数内所有的指令，找出 `PHINode`。

3.  **Phi 节点降级（`demotePhiToStack`）**：
    -   **创建栈槽**：在函数的入口块（Entry Block）创建一个 `AllocaInst`。这个栈槽将作为该 Phi 节点所代表的变量的物理存储位置。
    -   **插入存储（Stores）**：
        -   遍历该 Phi 节点的所有前驱块（Incoming Blocks）。
        -   在每个前驱块的末尾（通常是终止指令之前），插入一个 `StoreInst`，将对应的传入值（Incoming Value）存储到刚才创建的栈槽中。
    -   **插入加载（Loads）**：
        -   在原 Phi 节点的位置之后（跳过其他 Phi 节点或 EH 指令），插入一个 `LoadInst`，从栈槽中加载值。
    -   **替换与删除**：
        -   将原 Phi 节点的所有引用（Uses）替换为新插入的 `LoadInst` 的结果。
        -   从基本块中移除并删除该 Phi 节点。

4.  **元数据维护**：
    -   在创建新的 `alloca`, `store`, `load` 指令时，算法会尽量保留和复制原指令的 `insn.addr` 元数据，确保指令与其对应的原始汇编地址之间的关联不丢失。

## 相关文件

-   `phi_remover.cpp`: Pass 的主要实现逻辑，包含 `demotePhiToStack` 自定义算法。
-   `phi_remover.h`: 类定义。

## 总结

`retdec-remove-phi` 是 RetDec 从高度优化的中间表示回归到更贴近源代码逻辑表示的重要步骤。通过消除 Phi 节点，它实质上将复杂的 SSA 并发赋值转化为了顺序的内存读写，这对于后续将 LLVM IR 转换为高级语言（如 C）的结构化语句（如 `if-else`, `loops`）至关重要。
