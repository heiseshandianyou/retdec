# LLVM Standard Pass: loop-simplify (Canonicalize natural loops)

`loop-simplify` 负责将各种形式的循环转换（规范化）为易于后续优化处理的标准形式。

## 核心功能

1.  **创建 Preheader**：确保每个循环都有且仅有一个 Preheader 块。
2.  **创建单个 Latch**：确保每个循环只有一个将控制流传回 Header 的块。
3.  **创建唯一 Exit 块**：确保循环外所有被循环内引用的块，其前驱全部来自该循环。
4.  **嵌套规范化**：确保内层循环完全包含在外层循环中，没有交叠。

## 算法原理

- **基本块剥离（Splitting）**：当现有的 CFG 不满足规范（例如 Header 有多个来自循环外的输入）时，Pass 通过插入新的空跳转块来“剥离”这些路径，从而构造出标准的 Preheader 等结构。

## 在 RetDec 中的作用
反编译得到的初始控制流往往非常杂乱。`loop-simplify` 能将复杂的跳转网络梳理成规整的标准循环形态，这极大地简化了后端在生成 HLL 代码时处理多重退出、多重进入等复杂情形的需求。

## 源码参考
- `llvm/lib/Transforms/Utils/LoopSimplify.cpp`
