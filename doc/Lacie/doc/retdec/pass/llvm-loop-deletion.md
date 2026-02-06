# LLVM Standard Pass: loop-deletion (Delete Dead Loops)

`loop-deletion` 负责移除那些没有任何可观察副作用且不再被执行的死循环。

## 核心功能

1.  **死循环移除**：如果一个循环：
    -   不包含任何有副作用的指令（如内存写操作、函数调用）。
    -   能够证明其循环次数是有限的。
    -   循环产生的任何值在循环外都不被使用。
    -   则整个循环及其相关的控制流可以被彻底物理移除。

## 算法原理

- **条件评估**：结合 `LoopInfo` 和 `ScalarEvolution` 来评估循环是否可安全删除。

## 在 RetDec 中的作用
在深度优化过程中，通过前面的常量折叠或 DCE，许多原本有意义的循环可能变成了空转逻辑。`loop-deletion` 的介入能进一步提纯最终的生成结果。

## 源码参考
- `llvm/lib/Transforms/Scalar/LoopDeletion.cpp`
