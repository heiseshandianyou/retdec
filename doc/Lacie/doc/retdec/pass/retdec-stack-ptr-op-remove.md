# LLVM Pass: retdec-stack-ptr-op-remove

`retdec-stack-ptr-op-remove` 负责移除 LLVM IR 中残余的栈指针（ESP/RSP/EBP/RBP）操作指令。

## 核心功能

1.  **栈指针存储清理**：在 `retdec-stack` 等前面的 Pass 完成栈变量还原后，原始汇编中显式的栈指针修改（如 `sub esp, 4` 产生的存储）已经失去了意义。该 Pass 负责将这些冗余的存储指令删除。
2.  **帧指针保护逻辑消除**：识别并移除典型的编译器生成的“保护/恢复基址指针（EBP/RBP）”的代码序列。

## 算法原理

该 Pass 主要通过以下两个子过程实现：

### 1. 移除栈指针存储 (`removeStackPointerStores`)
- **逻辑**：遍历模块中的所有 `store` 指令。
- **校验**：调用 ABI 提供者检查该 `store` 的目标操作数是否为当前架构的 **栈指针寄存器**（如 x86 的 ESP）。
- **动作**：如果是，则直接将该指令从基本块中移除。因为这些操作在提升为 `alloca` 模型后，不再需要显式的指针维护。

### 2. 移除寄存器保存/恢复存储 (`removePreservationStores`)
- **场景**：编译器在进入函数时通常会通过 `push ebp; mov ebp, esp` 来保存调用者的基址。在提升为 LLVM IR 后，这表现为一种特定的 `alloca` 存取模式。
- **逻辑**：
    - 寻找仅用于存储和加载 EBP/RBP 寄存器值的 `alloca` 实例。
    - 检查该 `alloca` 是否有除“保存 EBP -> 存储到 alloca”和“从 alloca 加载 -> 恢复到 EBP”之外的其他用途。
- **动作**：如果该 `alloca` 仅用于此类物理寄存器的备份保护（Spill/Restore），则移除所有相关的存储和加载指令。

## 算法流程

1.  初始化 LLVM 模块和 ABI。
2.  执行 `removeStackPointerStores`：
    - 线性扫描模块内所有基本块。
    - 发现对栈指针的全局变量执行 `store` 操作时，将其删除。
3.  执行 `removePreservationStores`：
    - 遍历函数内的 `alloca` 指令。
    - 深度检查其所有使用者（Users）。
    - 确定其完全符合寄存器保护模式后，批量删除该 `alloca` 及其相关的存取指令。

## 源码位置
- `third_party/retdec/src/bin2llvmir/optimizations/stack_pointer_ops/`

## 总结
该 Pass 是提高反编译结果“整洁度”的关键。它通过剥离汇编层面的栈帧维护开销（Mechanical details），使得生成的 IR 更纯粹地表达函数的业务逻辑。
