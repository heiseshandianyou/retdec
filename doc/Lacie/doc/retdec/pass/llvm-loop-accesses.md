# LLVM Standard Pass: loop-accesses (Loop Access Analysis)

`loop-accesses` 是一个专门分析循环中内存访问依赖关系的 Pass，为循环向量化和高级重构提供数据。

## 核心功能

1.  **冲突检测**：分析循环内不同的 `load/store` 是否可能访问重叠的地址空间。
2.  **跨迭代依赖分析**：判定是否存在从当前迭代到未来迭代的数据依赖（如 `A[i] = A[i-1]`）。
3.  **运行时检查生成**：如果无法静态确定不冲突，它可以生成运行时地址比较代码。

## 算法原理

- **基于 SCEV 的内存间距分析**：通过计算地址表达式的步长和间隔，判定是否存在循环携带的依赖（Loop-carried dependence）。

## 在 RetDec 中的作用
在进行结构化恢复和数组还原时，理解循环各迭代间的内存交互是非常关键的。这有助于 RetDec 确定一个变量是在循环内部更新的临时状态还是在整个处理流中承上启下的关键数据。

## 源码参考
- `llvm/lib/Analysis/LoopAccessAnalysis.cpp`
