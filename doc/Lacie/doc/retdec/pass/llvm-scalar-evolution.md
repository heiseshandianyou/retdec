# LLVM Standard Pass: scalar-evolution (Scalar Evolution Analysis)

`scalar-evolution` (简称 SCEV) 是 LLVM 中处理标量表达式演变的核心分析框架，被誉为循环优化的“大脑”。

## 核心功能

1.  **增量建模**：将循环中的变量演变建模为数学上的复合表达式。最典型的表示是：`{Start, +, Step}<Loop>`。
2.  **循环次数预测**：通过分析循环退出的限定条件，解出循环的迭代次数上限（Backedge Taken Count）。
3.  **溢出安全分析**：判定加法、乘法等操作在循环过程中是否会发生溢出，从而支持更激进的代数简化。
4.  **等价性判定**：判断两个看似不同的指针计算是否在运行过程中指向相同的地址。

## 算法原理

- **链式递归（Chains of Recurrences）**：基于数学上的差分方程理论。它试图将每一个 SSA 变量转化为一个闭式解或递归定义。

## 在 RetDec 中的作用
RetDec 的许多高级优化（如数组恢复、复杂循环重构）都深挖了 SCEV 提供的数学模型。没有它，反编译器将无法理解复杂的 `i * scale + constant` 地址计算背后的真实含义。

## 源码参考
- `llvm/lib/Analysis/ScalarEvolution.cpp`
