# LLVM Standard Pass: constprop (Simple Constant Propagation)

`constprop` 是一种简单的初级常量传播 Pass。

## 核心功能

1.  **逐指令折叠**：寻找操作数全为常量的指令，计算其结果并替换。

## 算法原理

- **单向流动**：它不像 `sccp` 那样具有路径敏感性，只是简单地利用 SSA 链进行一步到位的替换。

## 在 RetDec 中的作用
作为一种廉价的“润滑剂”，它常在其他大型变换之间运行，确保显而易见的常量计算能够被立即处理，从而降低后续复杂分析（如别名分析）的负担。

## 源码参考
- `llvm/lib/Transforms/Scalar/ConstantProp.cpp`
