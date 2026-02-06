# retdec-inst-opt

`retdec-inst-opt` 是 RetDec 中的一个 LLVM Pass，专注于对单个 LLVM 指令进行局部的、基于模式匹配的优化。

## 功能概述

虽然 LLVM 自身提供了大量的优化 Pass（如 `instcombine`），但 `retdec-inst-opt` 针对反编译场景中的特定模式进行了定制。它的主要目的是简化由反汇编转换而来的冗余指令流，使 IR 更加简洁，并消除一些不利于后续反编译分析的 LLVM 标准优化副作用。

## 算法流程

该 Pass 的实现逻辑非常直接：

1.  **全局遍历**：
    -   遍历模块中的所有函数、基本块和指令。

2.  **模式匹配与替换**：
    -   对于每一条指令，依次应用一系列预定义的优化规则（函数指针数组 `optimizations`）。
    -   如果某个规则匹配成功并修改了指令，Pass 会标记 `changed = true`。

## 核心优化规则（部分）

-   **算术简化**：
    -   `addZero`: 将 `x + 0` 简化为 `x`。
    -   `subZero`: 将 `x - 0` 简化为 `x`。
    -   `addSequence`: 将连续的常量加法 `(x + c1) + c2` 合并为 `x + (c1 + c2)`。

-   **位运算简化**：
    -   `xorXX`: 将 `x ^ x` 简化为 `0`。
    -   `orAndXX`: 将 `x | x` 或 `x & x` 简化为 `x`。
    -   `truncZext`: 简化截断后再零扩展的序列（如 `(zext (trunc x))`），将其转换为位与运算（`and`）。

-   **布尔逻辑简化**：
    -   `xor_i1`: 将 `i1` 类型的 `xor` 转换为 `icmp ne`。
    -   `and_i1`: 将 `i1` 类型的 `and` 转换为 `icmp eq`。

-   **类型与转换优化**：
    -   `castSequenceWrapper`: 递归简化冗余的类型转换序列（如多次 `bitcast` 或 `ptrtoint`/`inttoptr` 的组合）。
    -   `storeToBitcastPointer` / `loadFromBitcastPointer`: 纠正 LLVM 某些优化 Pass 将指针 `bitcast` 后的异常读写模式，将其还原为对原始全局变量或内存的直接操作。

-   **内存操作简化**：
    -   `xorLoadXX` / `orAndLoadXX`: 识别对同一内存地址连续两次 `load` 后的冗余位运算。

## 相关文件

-   `inst_opt.cpp`: 包含所有具体的优化模式匹配函数。
-   `inst_opt_pass.cpp`: Pass 的入口类实现。
-   `inst_opt.h`: 函数定义和优化器接口。

## 总结

`retdec-inst-opt` 扮演了类似“补丁”和“清洁工”的角色。它通过简单的模式匹配，消除了反汇编过程中产生的大量琐碎冗余，并确保 IR 的状态能够更好地配合后续的符号分析、类型推断和控制流重建工作。
