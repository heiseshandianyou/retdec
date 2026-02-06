# retdec-plankton-type

`retdec-plankton-type` 是 Pinpoint 项目为 RetDec 贡献的一个集成 Pass，它利用 Plankton 引擎的类型增强（Type Enhancement）功能来自动推断并强制执行 LLVM 模块中的类型信息。

## 功能概述

在二进制反编译过程中，初始识别出的指令通常只包含原始的、无符号的数据（如 32 位或 64 位整数）。`retdec-plankton-type` 的目标是利用 Plankton 引擎提供的静态分析算法，推断出数据背后的真实语义类型（如指针、结构体、浮点数、数组等），并将这些类型信息强制应用到 LLVM IR 中。

## 算法流程

该 Pass 本身主要作为一个集成接口，核心逻辑由 Plankton 库中的 `TypeEnforcementEngine` 实现：

1.  **接口调用**：
    -   获取当前 LLVM 模块。
    -   实例化 `plankton::TypeEnforcementEngine` 引擎。

2.  **引擎运行（`engine.run()`）**：
    -   **数据分析**：Plankton 引擎会对模块中的全局变量、函数参数、局部变量以及指令之间的数据流进行深度分析。
    -   **类型推断**：利用基于启发式规则和约束求解的算法，推断出每个变量和操作的最可能类型。
    -   **类型强制执行（Enforcement）**：
        -   修改 LLVM 变量、函数签名和指令的操作数类型。
        -   在必要时插入 `bitcast` 指令或其他转换指令，确保修改后的 IR 依然符合 LLVM 的强类型规范。

3.  **结果返回**：
    -   如果引擎对模块进行了任何修改，则返回 `true`，告知 LLVM 优化器模块已变更。

## 相关文件

-   `plankton_type.cpp`: Pass 的集成逻辑实现。
-   `plankton_type.h`: 类定义。
-   集成的 Plankton 库核心：`TypeEnforcementEngine.h` 和 `TypeEnforcementEngine.cpp`。

## 总结

`retdec-plankton-type` 是 RetDec 原有类型分析能力的增强版。它通过引入专门的外部类型推断引擎，能够补全 RetDec 自身分析中缺失的复杂类型信息（特别是对于指针和结构体），从而生成更高质量、更具代码感的可编译代码。
