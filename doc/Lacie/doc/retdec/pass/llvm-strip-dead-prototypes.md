# LLVM Standard Pass: strip-dead-prototypes

`strip-dead-prototypes` 负责移除模块中那些声明了但从未被使用的函数原型。

## 核心功能

1.  **原型清理**：扫描模块中的函数声明（Prototypes）。如果一个声明没有对应的定义，且在整个模块中没有任何调用点引用它，则将其删除。

## 算法原理

- **线性检查**：算法非常简单，直接统计每个声明的引用计数（Use count）。

## 在 RetDec 中的作用
RetDec 在分析之初可能会加载大量的库函数原型或根据链接信息预测许多 API 调用。随着优化的进行，许多调用可能被判定为不可能发生。该 Pass 能确保最终生成的代码头文件中不包含这些无关紧要的杂质说明。

## 源码参考
- `llvm/lib/Transforms/IPO/StripDeadPrototypes.cpp`
