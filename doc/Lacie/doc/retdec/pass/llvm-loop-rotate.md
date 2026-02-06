# LLVM Standard Pass: loop-rotate (Rotate Loops)

`loop-rotate` 负责将循环转换为 `do-while` 风格，从而提高执行效率并暴露更多的优化机会。

## 核心功能

1.  **转换循环结构**：将 `while (cond) { body }` 转换为 `if (cond) { do { body } while (cond); }`。
2.  **提升条件判断**：将循环的条件检查从头部移动到尾部。
3.  **常量外提**：通过旋转，许多循环内的条件分支会变成循环外的保护检查，从而允许更多的代码外提（LICM）。

## 算法原理

- **基本块复制**：它将 Header 块复制一份，作为循环前的保护条件（Guard）。
- **更新控制流**：重组 Latch 和 Header 的连接方式，使原来的 Header 变成循环的 Latch 部分。

## 在 RetDec 中的作用
二进制程序中常见的 `for` 循环在底层汇编中往往表现为带保护条件的 `do-while`。`loop-rotate` 能够帮助 RetDec 还原这种结构，使得生成的 HLL 代码更自然地对应原始程序的逻辑。

## 源码参考
- `llvm/lib/Transforms/Scalar/LoopRotation.cpp`
