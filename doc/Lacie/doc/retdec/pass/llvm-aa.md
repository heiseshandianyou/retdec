# LLVM Standard Pass: aa (Alias Analysis)

`aa` 是一组分析型 Pass 的统称，负责判定两个指针是否可能指向内存中的同一位置。

## 核心功能

1.  **别名判定**：给定两个指针 A 和 B，分析器返回以下结果之一：
    -   **NoAlias**：A 和 B 永远不会指向同一地址。
    -   **MayAlias**：A 和 B 可能指向同一地址。
    -   **MustAlias**：A 和 B 总是指向同一地址。
2.  **内存副作用分析（Mod/Ref）**：判定一个指令或函数调用是否会修改（Mod）或读取（Ref）特定位置的内存。

## 算法原理

LLVM 采用多层级、可插拔的 AA 架构：
-   **BasicAA**：基于基础语法常识的分析。例如，来自不同 `alloca` 的指针必然 NoAlias；偏移量明显不重叠的结构体成员也 NoAlias。
-   **GlobalsAA**：分析全局变量之间的引用关系。
-   **SCEV-AA**：利用 `ScalarEvolution` 分析循环中指针随迭代演变的规律。
-   **CFL-AA**：基于约束流（Constraint-Free Language）的高级分析。

## 在 RetDec 中的作用
别名分析是所有内存优化的基石。RetDec 需要它来识别哪些寄存器访问是独立的，哪些全局数据访问是互斥的，从而支持后续的变量提升、冗余加载消除和高级数据结构还原。

## 源码参考
-   `llvm/include/llvm/Analysis/AliasAnalysis.h`
