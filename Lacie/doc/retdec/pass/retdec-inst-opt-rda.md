# LLVM Pass: retdec-inst-opt-rda

`retdec-inst-opt-rda` 是 `retdec-inst-opt` 的高级版本，它通过 **到达定值分析（Reaching Definitions Analysis, RDA）** 来执行更激进的指令级优化，特别是针对寄存器和局部变量的冗余存取消除。

## 核心功能

1.  **数据流驱动的优化**：传统的 `inst-opt` 主要依赖局部模式匹配，而本 Pass 利用全局数据流信息来判断一个内存操作是否真的有必要。
2.  **冗余消除**：
    -   消除从未被使用的存储（Dead Stores）。
    -   将加载指令（Load）直接替换为其对应的存储值（Store-to-Load Forwarding）。
3.  **寄存器操作规范化**：由于二进制反编译生成的 IR 会产生大量的全局寄存器存取，该 Pass 对于简化这些伪寄存器操作至关重要。

## 算法原理

该 Pass 主要包含以下几类核心优化逻辑：

### 1. 消除未使用的存储 (`unusedStores`)
- **逻辑**：如果一个 `store` 指令将值写入寄存器或局部变量，但 RDA 分析显示该定值（Definition）没有任何后续的 `load` 使用它，或者它在被使用前就被另一个 `store` 覆盖了。
- **动作**：安全地移除该 `store` 指令。

### 2. 同一基本块内的单定值优化 (`usesWithOneDefInSameBb`)
- **逻辑**：如果一个 `load` 指令在同一个基本块内只有一个到达定值，且该定值是一个 `store` 指令。
- **动作**：将 `load` 的所有使用者直接链接到 `store` 的源操作数上，并移除该 `load`。

### 3. 基于支配关系的定值替换 (`defWithUsesInTheSameBb`)
- **逻辑**：如果一个 `store`（定值）在同一个基本块内有多个 `load` 使用者，且该 `store` 支配（Dominates）这些 `load`。
- **动作**：将所有的 `load` 替换为 `store` 的值。如果所有使用者都被替换，且该定值不再流向块外，则 store 也可以被移除。

## 算法流程

1.  运行 **到达定值分析（RDA）**，获取模块内详尽的定值-使用（Def-Use）链信息。
2.  遍历模块中的所有指令。
3.  对每条指令尝试运行优化规则：
    -   如果是 `store`：检查其定值是否有实际意义。
    -   如果是 `load`：寻找唯一的、位于同块内的前序 `store`。
4.  使用 `IrModifier` 执行递归的死代码清理，确保被替换的指令及其依赖链被妥善移除。

## 源码位置
- `third_party/retdec/src/bin2llvmir/optimizations/inst_opt_rda/`

## 总结
`retdec-inst-opt-rda` 是 RetDec 优化序列中承上启下的关键，它利用深度的静态分析（RDA）解决了初级解码阶段产生的冗余指令问题，为后续的 `mem2reg` 和类型推断扫清了障碍。
