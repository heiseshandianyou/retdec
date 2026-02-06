# LLVM Standard Pass: simplifycfg (Simplify the CFG)

`simplifycfg` 专门用于简化函数的控制流图（CFG），消除冗余的逻辑分支。

## 核心功能

1.  **死块移除**：删除任何从函数入口点不可达的基本块。
2.  **基本块合并**：如果块 A 只有一个前驱 B，且 B 只有一个后继 A，则将这两个块合并。
3.  **空块消除**：移除仅包含无条件跳转的“跳板”块。
4.  **分支化简**：将条件跳转转换为无条件跳转（如果条件已知），或将 `switch` 语句优化为简单的分支。
5.  **Phi 节点提升**：在可能的情况下，将简单的分支赋值转换为 `select` 指令。

## 算法原理

- **基于规则的变换**：Pass 循环应用系列规则直到收敛。
- **局部性分析**：它关注基本块之间的连接关系，通过调整终止指令（Terminator Instructions）来重塑 CFG。

## 在 RetDec 中的作用
二进制程序中常包含大量的跳转和复杂的控制流逻辑。`simplifycfg` 能够帮助 RetDec 理顺这些复杂的控制逻辑，将机器级的琐碎跳转整合成更规整的代码块，这直接影响到最后 HLL 阶段对 `if` 和 `loop` 的还原质量。

## 源码参考
- `llvm/lib/Transforms/Utils/SimplifyCFG.cpp`
