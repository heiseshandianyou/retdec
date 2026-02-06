# LLVM Standard Pass: correlated-propagation (Value Propagation)

`correlated-propagation` 负责利用控制流中的隐含约束信息来优化指令。

## 核心功能

1.  **比较指令简化**：如果能证明 `a < b` 在某处总是成立，将其替换为常量。
2.  **溢出检查消除**：利用变量范围推断（基于 LVI），判定加法等操作是否会溢出。
3.  **位操作简化**：如果已知某些位必然为 0 或 1。
4.  **死代码移除**：识别并删除永远不会执行的分支或无用的 `select`。

## 算法原理

- **基于 LVI 的深度分析**：它大量调用 `LazyValueInfo` 接口来查询变量在特定节点的属性。
- **由于分支导致的关联（Correlation）**：核心在于理解“因为我刚通过了 `x > 0` 的检查，所以在这条路上 `x` 不可能是负数”这种路径相关的逻辑。

## 在 RetDec 中的作用
在 RetDec 的优化管道中，它能配合 `sccp` 和 `gvn` 进一步提纯代码，消除掉由于底层物理逻辑（如符号位检查）产生的、在高级语义层面上显而易见的冗余判断。

## 源码参考
- `llvm/lib/Transforms/Scalar/CorrelatedValuePropagation.cpp`
