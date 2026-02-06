# retdec-write-bc, retdec-write-ll, retdec-write-dsm

这组 Pass 负责将反编译过程中处于不同中间状态的 LLVM 模块导出为文件，以便进行调试、进一步分析或作为最终结果输出。

## 功能概述

在 RetDec 的流水线中，代码以多种形式存在。为了方便开发者和逆向工程师查看，RetDec 提供了三种主要的导出器：
1.  **`retdec-write-bc` (Bitcode Writer)**：将 LLVM 模块序列化为紧凑的二进制格式（`.bc`），通常用于在不同的反编译工具之间传递中间状态。
2.  **`retdec-write-ll` (LLVM IR Writer)**：将 LLVM 模块输出为人类可读的长文本格式（`.ll`），是调试 Pass 逻辑、查看变量流转最常用的文件。
3.  **`retdec-write-dsm` (Disassembly Writer)**：生成一份带有 LLVM 内容注释的“反汇编”清单（`.dsm`），重点在于展示 LLVM IR 指令与原始汇编指令地址之间的对应关系。

## 算法流程

### `retdec-write-bc` 与 `retdec-write-ll`
这两个 Pass 的逻辑相对直接，作为 LLVM 原生能力的封装：
-   **获取路径**：从全局配置（Config）中读取用户指定的输出文件名。
-   **创建输出文件**：利用 LLVM 的 `ToolOutputFile` 安全地创建目标文件。
-   **调用 LLVM 接口**：
    -   `BitcodeWriter` 使用 `WriteBitcodeToFile`。
    -   `LlvmIrWriter` 使用 `M.print()`。
-   **持久化**：调用 `keep()` 确保文件在磁盘上正确关闭和保存。

### `retdec-write-dsm`
这个 Pass 的逻辑更为复杂，因为它不是简单的格式转换，而是要“生成内容”：
1.  **准备环境**：获取文件镜像（FileImage）、ABI 和配置信息。
2.  **生成头部（Header）**：输出关于文件格式、架构、入口点等元数据信息。
3.  **生成代码段（Code Section）**：
    -   遍历加载器（Loader）中的代码段。
    -   利用 `AsmInstruction` 提供者，将 LLVM IR 指令关联回物理地址。
    -   格式化输出：地址、原始机器码字节、以及反编译后的汇编助记符。
4.  **生成数据段（Data Section）**：
    -   分析全局变量和常量。
    -   以十六进制形式展示数据布局，并尝试注释出字符串、数组或函数指针。
5.  **文本优化**：
    -   包含对符号名的转义（`escapeString`）和负数偏移量的视觉优化（`reduceNegativeNumbers`），使其更符合人类阅读习惯。

## 相关文件

-   `writer_bc/writer_bc.cpp`
-   `writer_ll/writer_ll.cpp`
-   `writer_dsm/writer_dsm.cpp`

## 总结

Writer 系列 Pass 是 RetDec 的“输出窗口”。它们不仅满足了反编译工作的最终交付需求，也通过生成不同维度的视图（二进制、源码、注释反汇编），极大地方便了开发者对反编译引擎本身的开发与调试。
