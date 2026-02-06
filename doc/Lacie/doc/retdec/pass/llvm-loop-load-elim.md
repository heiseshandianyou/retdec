# LLVM Standard Pass: loop-load-elim (Loop Load Elimination)

`loop-load-elim` 负责消除循环执行过程中不必要的重复内存读取指令。

## 核心功能

1.  **循环内存储到加载转发**：如果一个循环迭代内刚写入了某个内存位置，接着又读取它，将读取替换为直接使用被写入的值。
2.  **跨迭代加载消除**：识别出当前迭代读取的值实际上是上一迭代中写入并保持不变的（通过建立跨迭代的数据流）。

## 算法原理

- **依赖图重排**：利用 `LoopAccessAnalysis` 的结果。
- **Phi 节点提升**：通过在 Header 中创建 `phi` 节点，将上一轮的结果保存并传递给当前轮，从而消除物理性的内存加载指令。

## 在 RetDec 中的作用
显著简化了由于频繁访问栈上或全局标志位导致的冗余代码。在反编译出的循环体中，消除这些低级的存取指令能让核心的算术或逻辑操作浮现出来。

## 源码参考
- `llvm/lib/Transforms/Scalar/LoopLoadElimination.cpp`
