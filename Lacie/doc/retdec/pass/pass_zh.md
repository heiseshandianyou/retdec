# RetDec LLVM Passes (中文文档)

本文档详述了 RetDec 反编译器编排序列中使用的所有 LLVM Pass，包括 RetDec 自定义 Pass 以及所依赖的 LLVM 标准优化 Pass。

## LLVM 标准优化 Pass

这些 Pass 来自 LLVM 项目，RetDec 在反编译流水线中多次调用它们以清理和规范化生成的 IR。
源码基础路径：`third_party/retdec/build/external/src/llvm-project/`

### 1. 核心优化组
这些 Pass 执行最基础的 IR 规范化和局部/全局优化。

| Pass 名称 | 描述 | 源码相对路径 |
| :--- | :--- | :--- |
| **verify** | IR 验证器：确保 IR 格式和语义正确。 | `lib/IR/Verifier.cpp` |
| **instcombine** | 指令合并：通过代数化简合并冗余指令。 | `lib/Transforms/InstCombine/InstructionCombining.cpp` |
| **simplifycfg** | 简化 CFG：清理死代码块、合并基本块。 | `lib/Transforms/Scalar/SimplifyCFGPass.cpp` |
| **early-cse** | 早期 CSE：快速完成简单的公共子表达式消除。 | `lib/Transforms/Scalar/EarlyCSE.cpp` |
| **globalopt** | 全局优化：对静态变量、全局常量进行优化。 | `lib/Transforms/IPO/GlobalOpt.cpp` |
| **mem2reg** | 内存到寄存器提升：将栈上的 alloca 提升为 SSA 寄存器。 | `lib/Transforms/Utils/PromoteMemoryToRegister.cpp` |
| **gvn** | 全局值编号：一种比 CSE 更强大的冗余消除算法。 | `lib/Transforms/Scalar/GVN.cpp` |
| **sccp** | 稀疏值条件常量传播：根据条件进行精准常量计算。 | `lib/Transforms/Scalar/SCCP.cpp` |

### 2. 循环与变量组
专门针对循环结构进行识别、规范化和优化。

| Pass 名称 | 描述 | 源码相对路径 |
| :--- | :--- | :--- |
| **loops** | 循环分析：识别 IR 中的循环结构。 | `lib/Analysis/LoopInfo.cpp` |
| **loop-simplify** | 循环简化：将循环转化为标准规范形式。 | `lib/Transforms/Utils/LoopSimplify.cpp` |
| **lcssa** | LCSSA 表取：在循环出口处插入 PHI 节点以辅助分析。 | `lib/Transforms/Utils/LCSSA.cpp` |
| **loop-rotate** | 循环旋转：将循环改为 do-while 结构。 | `lib/Transforms/Scalar/LoopRotation.cpp` |
| **licm** | 循环不变代码外提：将循环内无关的计算移到循环外。 | `lib/Transforms/Scalar/LICM.cpp` |
| **indvars** | 感应变量简化：规范化循环计数器。 | `lib/Transforms/Scalar/IndVarSimplify.cpp` |
| **loop-idiom** | 循环惯用法识别：将循环识别为 memset/memcpy 等。 | `lib/Transforms/Scalar/LoopIdiomRecognize.cpp` |
| **loop-deletion** | 死循环删除：删除对程序结果无影响的循环。 | `lib/Transforms/Scalar/LoopDeletion.cpp` |
| **scalar-evolution** | 标量演进：分析循环中变量的变化规律（SCEV）。 | `lib/Analysis/ScalarEvolution.cpp` |

### 3. 数据流与别名分析
提供深度的内存访问和值取值范围分析。

| Pass 名称 | 描述 | 源码相对路径 |
| :--- | :--- | :--- |
| **aa (basicaa/tbaa)** | 别名分析：判断两个访问是否指向同一内存地址。 | `lib/Analysis/BasicAliasAnalysis.cpp` |
| **lazy-value-info** | 惰性值分析：为其他 Pass 提供值的范围和属性信息。 | `lib/Analysis/LazyValueInfo.cpp` |
| **jump-threading** | 跳转线程优化：寻找并消除可以跨越基本块的条件跳转。 | `lib/Transforms/Scalar/JumpThreading.cpp` |
| **correlated-propagation** | 相关值传播：基于控制流条件传播值信息。 | `lib/Transforms/Scalar/CorrelatedValuePropagation.cpp` |
| **reassociate** | 表达式重结合：规范化算术表达式顺序以辅助合并。 | `lib/Transforms/Scalar/Reassociate.cpp` |
| **loop-accesses** | 循环访问分析：分析循环内的内存访问依赖。 | `lib/Analysis/LoopAccessAnalysis.cpp` |
| **loop-load-elim** | 循环加载消除：移除循环中多余的内存读取。 | `lib/Transforms/Scalar/LoopLoadElimination.cpp` |

### 4. 死代码与清理
移除冗余指令、不可达函数和无效全局符号。

| Pass 名称 | 描述 | 源码相对路径 |
| :--- | :--- | :--- |
| **dse** | 死存储消除：移除会被后续覆盖的无用内存写入。 | `lib/Transforms/Scalar/DeadStoreElimination.cpp` |
| **bdce** | 位分析死消除：根据位掩码移除无用的位操作。 | `lib/Transforms/Scalar/BDCE.cpp` |
| **adce** | 侵略性死消除：激进地移除所有无副作用的冗余计算。 | `lib/Transforms/Scalar/ADCE.cpp` |
| **strip-dead-prototypes**| 擦除死原型：移除模块中未被使用的外部函数声明。 | `lib/Transforms/IPO/StripDeadPrototypes.cpp` |
| **globaldce** | 全局死代码消除：从模块中移除未使用的全局定义。 | `lib/Transforms/IPO/GlobalDCE.cpp` |
| **constmerge** | 常量合并：将内容相同的全局常量合并为一处。 | `lib/Transforms/IPO/ConstantMerge.cpp` |
| **constprop** | 常量传播：执行基本的常量折叠与替换。 | `lib/Transforms/Scalar/ConstantProp.cpp` |
| **sink** | 代码下沉：将指令移动到其结果被使用的基本块。 | `lib/Transforms/Scalar/Sink.cpp` |

---

## RetDec 自定义 Pass

这些 Pass 构成了 RetDec 核心的二进制分析与语义恢复能力。
源码基础路径：`third_party/retdec/src/bin2llvmir/`

### 1. 基础转换与解码
| Pass 名称 | 源码相对路径 | 描述 |
| :--- | :--- | :--- |
| **retdec-provider-init** | `optimizations/provider_init/` | 初始化 ABI、寄存器、配置等核心分析组件。 |
| [retdec-decoder](file:///home/lacie/project/Pinpoint/tools/doc/retdec/pass/retdec-decoder.md) | `optimizations/decoder/` | 使用 Capstone 将机器码递归解码为 LLVM IR。 |
| **retdec-remove-asm-instrs** | `optimizations/asm_inst_remover/` | 移除解码时的锚点指令，将地址信息转为元数据。 |

### 2. 架构特定修复
| Pass 名称 | 源码相对路径 | 描述 |
| :--- | :--- | :--- |
| **retdec-x86-addr-spaces** | `optimizations/x86_addr_spaces/` | 识别 x86 段寄存器（FS/GS）访问并还原为 intrinsic。 |
| **retdec-x87-fpu** | `optimizations/x87_fpu/` | 求解 x87 浮点栈顶指针，将栈操作还原为寄存器操作。 |
| **retdec-syscalls** | `optimizations/syscalls/` | 识别平台特定的系统调用指令并提升为函数调用。 |

### 3. 应用逻辑与语义分析
| Pass 名称 | 源码相对路径 | 描述 |
| :--- | :--- | :--- |
| **retdec-main-detection** | `optimizations/main_detection/` | 利用启发式模式匹配寻找程序的 `main` 入口点。 |
| **retdec-idioms-libgcc** | `optimizations/idioms_libgcc/` | 将编译器辅助库调用（如 64 位除法）还原为数学运算。 |
| **retdec-idioms** | `optimizations/idioms/` | 识别并转换编译器生成的特定指令序列（如位操作技巧）。 |
| **retdec-constants** | `optimizations/constants/` | 识别 IR 中的立即数是否为全局变量/内存地址并进行替换。 |

### 4. 核心逆向分析
| Pass 名称 | 源码相对路径 | 描述 |
| :--- | :--- | :--- |
| **retdec-stack** | `optimizations/stack/` | 分析栈指针变化，重建本地方地变量和栈帧布局。 |
| **retdec-param-return** | `optimizations/param_return/` | 基于数据流推断函数的参数数量、类型和返回值。 |
| **retdec-simple-types** | `optimizations/simple_types/` | 基于等价类约束求解器重建基础数据类型。 |
| **retdec-types-propagation** | `optimizations/types_propagator/` | 在 IR 价值流中进行类型的正向与反向传播。 |
| **retdec-class-hierarchy** | `optimizations/class_hierarchy/` | 扫描 RTTI 和虚表，恢复 C++ 类继承关系与多态属性。 |

### 5. 优化与辅助分析
| Pass 名称 | 源码相对路径 | 描述 |
| :--- | :--- | :--- |
| **retdec-cond-branch-opt** | `optimizations/cond_branch_opt/` | 将复杂的标志位组合（ZF/SF/OF）还原为高级条件跳转。 |
| **retdec-inst-opt** | `optimizations/inst_opt/` | 基于模式匹配的局部指令简化（加减乘除、位移等）。 |
| **retdec-inst-opt-rda** | `optimizations/inst_opt_rda/` | 利用到达定值分析（RDA）进行的更激进的指令消除。 |
| **retdec-unreachable-funcs** | `optimizations/unreachable_funcs/` | 清理调用图中不可达的函数体。 |
| **retdec-register-localization** | `optimizations/register_localization/` | 将全局寄存器变量转化为局部 alloca 变量以辅助 mem2reg。 |
| **retdec-stack-ptr-op-remove** | `optimizations/stack_pointer_ops/` | 移除不再需要的栈指针（ESP/EBP）修改指令。 |
| **retdec-remove-phi** | `optimizations/phi_remover/` | 将 PHI 节点转换为显式的内存存取，辅助反编译逻辑展示。 |
| **retdec-value-protect** | `optimizations/value_protect/` | 锁定关键逆向信息，防止被后续 LLVM 优化误删。 |

### 6. 集成引擎与后端
| Pass 名称 | 源码路径 | 描述 |
| :--- | :--- | :--- |
| **retdec-plankton-scope** | `optimizations/plankton_scope/` | 调用 Plankton 作用域推断引擎增强变量可见性分析。 |
| **retdec-plankton-type** | `optimizations/plankton_type/` | 调用 Plankton 类型强制引擎提升类型连贯性。 |
| **retdec-llvmir2hll** | `src/llvmir2hll/` | 将 LLVM IR 转换为中间表示 BIR，并最终生成高级语言（C）。 |
| **retdec-write-dsm** | `optimizations/writer_dsm/` | [生成中间反汇编报告 (.dsm)](file:///home/lacie/project/Pinpoint/tools/doc/retdec/pass/retdec-write-dsm.md) |
| **retdec-write-ll** | `optimizations/writer_ll/` | 将当前 IR 写入磁盘 (.ll)。 |
| **retdec-write-bc** | `optimizations/writer_bc/` | 将当前 IR 写入位代码文件 (.bc)。 |

---
**配置源**：执行顺序和完整链条定义在 `src/retdec-decompiler/decompiler-config.json` 的 `llvmPasses` 字段中。