# LLVM Standard Pass: loops (Loop Information)

`loops` 是一个分析型 Pass，负责识别和计算函数中的循环结构。

## 核心功能

1.  **循环检测**：通过强连通分量（SCC）算法识别控制流图中的循环。
2.  **层次结构构建**：识别嵌套循环（外层循环与内层循环的包含关系）。
3.  **循环属性提取**：识别循环的基本组成部分，包括：
    -   **Preheader**：循环开始前的唯一前驱块。
    -   **Header**：循环的入口点。
    -   **Exiting Blocks**：循环内跳转到循环外的块。
    -   **Exit Blocks**：循环外的目标块。
    -   **Latch**：分支回 Header 的块。

## 算法原理

- **基于支配关系**：LLVM 将循环定义为满足以下条件的边 `n -> h`：`h` 支配 `n`。这条边被称为回边（Backedge）。
- **递归发现**：从回边出发，逆向遍历可以到达 `h` 且不经过 `h` 的所有基本块，这些块共同构成了该循环的体部。

## 在 RetDec 中的作用
它是后续所有循环优化（如 `licm`）的基础，同时也是后端 `llvmir2hll` 能够准确还原 C 语言中 `while`, `for`, `do-while` 结构的关键信息源。

## 源码参考
- `llvm/include/llvm/Analysis/LoopInfo.h`
