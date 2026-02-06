# retdec-plankton-scope

`retdec-plankton-scope` 是 Pinpoint 项目为 RetDec 贡献的一个集成 Pass，它利用 Plankton 引擎的作用域推断（Scope Inference）功能来增强反编译流程中变量作用域的识别。

## 功能概述

该 Pass 的主要目标是提升反编译代码中局部变量识别的准确度。传统的反编译方法往往将所有通过栈指针偏移访问的内存视为同一个函数的局部变量域。`retdec-plankton-scope` 通过集成更先进的推断算法，能够识别出嵌套的作用域、重用的栈槽以及跨函数调用的变量生命周期，从而生成更符合程序员逻辑的变量定义。

## 算法流程

该 Pass 的执行流程分为“分析”和“修补”两个主要阶段：

1.  **准备与数据提取**：
    -   获取 ABI、配置（Config）和 RDA（到达定值分析）信息。
    -   从 LLVM 函数中提取原始指令信息，并将其转换为 Plankton 引擎可识别的格式（如 `plankton::CapstoneInstruction`）。

2.  **Plankton 引擎推断**：
    -   调用 Plankton 的作用域推断引擎，分析指令序列，识别出每个基本块或指令序列对应的潜在作用域（Scopes）和变量对象（Enhanced Debug Info）。

3.  **变量注入（Inject Variables）**：
    -   根据 Plankton 返回的增强调试信息，在 LLVM 函数的入口处（Entry Block）创建对应的 `AllocaInst`（局部变量）。
    -   建立偏移量（Offset）到 `AllocaInst` 的映射表。

4.  **扫描与修补规则生成（Scan for Patches）**：
    -   再次遍历函数中的指令，利用 RDA 和符号树（Symbolic Tree）分析。
    -   **解析栈表达式**（`resolveStackExpression`）：识别复杂的栈访问模式（如寄存器基址 + 偏移）。
    -   为每一个被识别为栈访问的 `Load`/`Store` 指令建议一个“修补作业”（`PatchJob`），将其指向之前注入的特定 `AllocaInst`。

5.  **应用修补（Apply Patches）**：
    -   根据生成的 `PatchJob` 列表，修改 LLVM IR：
        -   将原始的内存访问指令替换为对新创建出的、具有明确作用域意义的局部变量的访问。
        -   确保类型转换符合 LLVM 的约束。

## 相关文件

-   `plankton_scope.cpp`: Pass 的主要集成逻辑，负责 RetDec IR 与 Plankton 数据的适配。
-   `plankton_scope.h`: 类定义。
-   集成的 Plankton 库（位于 `third_party`）。

## 总结

`retdec-plankton-scope` 是 RetDec 原有栈分析（`retdec-stack`）的一个增强补充。它引入了外部专门的静态分析引擎来辅助作用域判定，通过将低级的内存偏移映射到更具语义的变量对象，有效地解决了反编译中复杂的变量重用和作用域交叠问题，显著提升了最终代码的可阅读性。
