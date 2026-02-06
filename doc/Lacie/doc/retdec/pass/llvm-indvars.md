# LLVM Standard Pass: indvars (Induction Variable Simplification)

`indvars` 负责识别并简化循环中的感应变量（Induction Variables，通常是循环计数器 `i`）。

## 核心功能

1.  **规范化感应变量**：将所有的循环计数器转换为基于 0 开始、步长为 1 的标准形式。
2.  **消除冗余计算**：利用感应变量的线性性质，简化循环内的地址计算（如 `&A[i]`）。
3.  **计算循环次数**：推导循环的确切或最大迭代次数。
4.  **消除退出条件**：如果能证明循环次数是常量，将动态判断替换为静态判断。

## 算法原理

- **基于 ScalarEvolution (SCEV)**：深深依赖于 SCEV 提供的代数分析能力，将循环变量建模为数学上的等差或等比数列。

## 在 RetDec 中的作用
对于还原 `for (int i = 0; i < N; ++i)` 这种标准模式至关重要。它能将机器码中复杂的指针算术重新还原为简单易懂的索引访问。

## 源码参考
- `llvm/lib/Transforms/Scalar/IndVarSimplify.cpp`
