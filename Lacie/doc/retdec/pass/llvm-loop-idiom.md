# LLVM Standard Pass: loop-idiom (Recognize Loop Idioms)

`loop-idiom` 负责识别执行特定高层次功能的循环模式，并将其替换为高效的内建函数或库函数调用。

## 核心功能

1.  **Memset 识别**：将逐字节初始化数组的循环识别并替换为 `llvm.memset`（或最终的 `memset` 调用）。
2.  **Memcpy 识别**：将数数组拷贝循环识别并替换为 `llvm.memcpy` (或 `memcpy`)。
3.  **位操作识别**：在某些架构上，将特定的位统计或位搜索循环替换为硬件指令（如 `popcount`）。

## 算法原理

- **模板匹配**：扫描循环体，寻找满足存储/加载连续性、基地址线性增长等条件的指令序列。

## 在 RetDec 中的作用
极大提升了代码的可读性。将原本占据十几行反编译代码的数组初始化循环转变为一行简洁的 `memset` 调用，能帮助分析者迅速抓住程序的高层意图。

## 源码参考
- `llvm/lib/Transforms/Scalar/LoopIdiomRecognize.cpp`
