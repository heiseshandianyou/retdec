# LLVM Standard Pass: globaldce (Global Dead Code Elimination)

`globaldce` 负责在模块级删除那些不再被使用的全局变量、函数和全局别名。

## 核心功能

1.  **死全局符号移除**：移除所有不可达且无外部引用的全局符号。
2.  **递归清理**：如果一个全局变量被删除，它对其他全局对象的引用也会随之消失，从而可能触发连锁的删除。

## 算法原理

- **活跃度分析**：从“外部可见”（External Linkage）的符号出发，进行可达性扫描。

## 在 RetDec 中的作用
有效地缩减了反编译结果的体积。特别是在处理静态链接的大型二进制文件时，该 Pass 能自动隐藏掉那些未被主程序调用的库函数实现。

## 源码参考
- `llvm/lib/Transforms/IPO/GlobalDCE.cpp`
