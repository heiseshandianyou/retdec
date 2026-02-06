# LLVM Standard Pass: mem2reg (Promote Memory to Register)

`mem2reg` 是 LLVM 构建 SSA（静态单赋值）形式的核心工具，负责将显式的内存访问转换为虚拟寄存器引用。

## 核心功能

1.  **Alloca 提升**：识别那些可以被虚拟寄存器替代的 `alloca` 指令（通常是局部标量变量的内存申请）。
2.  **插入 Phi 节点**：在控制流汇合点插入正确的 `phi` 指令，以保持各个执行路径上的值正确关联。
3.  **消除显式 Load/Store**：通过建立“定值-使用”链，将对 `alloca` 内存的读写操作替换为直接的寄存器传递。

## 算法原理

- **支配边界（Dominance Frontiers）算法**：`mem2reg` 使用经典的 SSA 构造算法。首先计算支配树，然后确定所有 `store` 的支配边界，在这些位置插入 `phi` 节点，最后通过一次遍历重命名所有操作数。
- **安全性检查**：仅提升那些从未进行过“取地址”操作（即没有逃逸）的 `alloca`。

## 在 RetDec 中的作用
这是反编译中最神圣的一步。解码器最初生成的 IR 将所有的寄存器和栈变量都视为内存地址。`mem2reg` 完成了从“物理内存模型”向“数学变量模型”的蜕变，是后续所有复杂数据流分析的基础。

## 源码参考
- `llvm/lib/Transforms/Utils/PromoteMemoryToRegister.cpp`
