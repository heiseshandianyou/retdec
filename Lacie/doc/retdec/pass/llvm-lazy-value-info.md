# LLVM Standard Pass: lazy-value-info (Lazy Value Information)

`lazy-value-info` (简称 LVI) 是一种按需执行（On-demand）的分析，旨在推断 SSA 变量在程序特定点的可能取值范围。

## 核心功能

1.  **取值范围推断**：确定变量在某个基本块开始处或结束处的最大/最小整数范围。
2.  **常量推断**：识别变量是否在某些特定路径上必然是某个常量。
3.  **结果缓存**：为了提高效率，LVI 会缓存已计算出的结果，仅在需要时递归分析其操作数。

## 算法原理

- **格理论（Lattice）分析**：使用类似于 `sccp` 的格模型。
- **路径敏感性**：分析控制流分支（如 `icmp` 结果）对变量范围的约束。例如在 `if (x < 10)` 的 True 路径上，`x` 的范围被修正为 `[-inf, 9]`。

## 在 RetDec 中的作用
LVI 为许多控制流优化（如 `jump-threading`）提供了必要的证据。在反编译过程中，它可以帮助确定某些“看似动态”的分支在特定条件下是否是死代码，从而简化生成的函数逻辑。

## 源码参考
- `llvm/lib/Analysis/LazyValueInfo.cpp`
