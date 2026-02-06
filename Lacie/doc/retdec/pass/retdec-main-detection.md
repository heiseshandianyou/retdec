# retdec-main-detection: 主函数识别 Pass

在反编译过程中，找到“用户代码的起点”（即 `main` 函数）是至关重要的。虽然二进制文件有一个 `Entry Point`，但那通常是编译器插入的启动代码（CRT, C Runtime），真正的 `main` 地址往往作为参数传递给启动函数（如 `__libc_start_main`）。

`retdec-main-detection` 的职责就是从这堆乱麻中把 `main` 找出来。

## 1. 为什么不在 Decoder 阶段直接识别？

这是一个非常好的问题。Decoder 本身是一个**递归下降解码器**，它主要依赖控制流（Direct Calls/Jumps）来发现新代码。

*   **Decoder 的局限**：在许多架构（尤其是 x86 Linux/Windows）中，`main` 的地址是以**参数数据**的形式传递给启动函数的，而不是通过一个直观的 `call main`。这意味着 Decoder 虽然可能已经解码了 `main` 的机器码（如果它被某种逻辑引用了），但它并不知道这个函数就是程序的主逻辑。
*   **语义断层**：Decoder 的核心目标是“翻译机器码”，它不具备理解“启动代码模式匹配”的高级语义。而 `main-detection` 跑在 Decoder 之后，就是为了利用已经生成的 IR 进行**模式匹配分析**。

## 2. 识别算法与启发式 (Heuristics)

该 Pass 并不只是看函数名，而是采用了一套极其复杂的“找人”逻辑：

1.  **名称优先**：如果符号表里本来就有 `main`、`WinMain` 或 `wmain`，直接采信。
2.  **启动代码分析 (Context Analysis)**：这是最核心的补救措施。
    *   它会去分析 `_start`（Entry Point）生成的 LLVM IR 指令。
    *   **寻找模式**：例如在 x86 Linux 下，它会寻找调用 `__libc_start_main` 之前的 `push` 指令或寄存器赋值。第一个参数通常就是 `main` 的地址。
    *   **架构特定偏移**：针对不同版本的 MSVC、MinGW、GCC，这个 Pass 预设了大量的硬编码偏移（EntryPoint Offset）。例如：在 MSVC 10.0 中，`main` 往往位于 EntryPoint 偏移 `-0x5b` 或 `-0x126` 的位置。
3.  **库函数排除**：它会利用 `retdec-constants` 等 Pass 识别出的信息，排除掉那些明显的库函数。

## 3. 为什么需要“重新反编译”？（误区澄清）

用户通常会对“重新反编译”产生误解。这里其实包含两层含义：

*   **标记而非重扫**：`retdec-main-detection` 找到 `main` 后，绝大多数情况下**并不会**重新启动 Capstone 去二进制里扫描。它做的是：**给现有的函数改名**（改为 `main`），并在配置中将其设为 `MainAddress`。
*   **触发后续链条**：一旦 `main` 被识别，后续的 `retdec-unreachable-funcs` 才有了一个明确的“生存根节点”。它会把所有从 `main` 无法到达的函数（比如那些枯燥的 libc 启动胶水代码）通通删掉。
*   **视觉上的“重新反编译”**：对于用户来说，原本杂乱无章、从 `_start` 开始的伪代码，突然变回了干净利落、以 `int main(...)` 开头的代码。这在感官上就像是“重新反编译”了一遍，但本质上是 **IR 层面的重组与重命名**。

## 4. 详细识别算法 (Algorithm Details)

`retdec-main-detection` 遵循以下严格的优先级顺序来锁定目标：

### 阶段 1：先验知识检查
*   **配置优先**：如果用户通过编译参数 `--main-address` 手动指定了地址，Pass 直接采用并退出。
*   **库文件跳过**：如果是共享库（`.so` / `.dll`），通常不含有 `main`，Pass 会跳过分析。

### 阶段 2：名称匹配 (Symbol Name Matching)
搜索符号表，优先级为：`main` > `_main` > `wmain` > `WinMain`。一旦命中，立即标记。

### 阶段 3：上下文启发式分析 (Context Heuristics)
这是该 Pass 的“黑科技”所在，针对不同编译器产生的启动代码（Startup Code）模板进行匹配：

*   **MSVC (x86)**：
    *   **入口点偏移法**：检查 `EntryPoint` 之前的特定偏移（如 `-0x5b`, `-0x82`, `-0x14e`）。在 MSVC 启动模板中，真正的 `main` 调用往往就在这些固定位置。
    *   **锚点函数法**：寻找对 `_CrtSetCheckCount` 或 `InterlockedExchange` 的调用。在 CRT 初始化序列中，`main` 的调用通常紧跟在这些函数之后（例如 `anchor_addr + 0x2b` 或 `+ 0x46`）。
*   **MinGW (x86)**：检查特定硬编码地址（如 `0x4013f5`）是否存在 `call` 指令。
*   **PowerPC (GCC)**：在 `.rodata` 段的起始地址偏移 `+4` 的位置读取一个字，将其作为 `main` 的地址。
*   **MIPS / ARM**：识别特定的寄存器加载序列。例如，寻找将常量地址加载到 `t9` 或 `pc` 的逻辑。

### 阶段 4：执行结果应用 (Applying Results)
1.  **重命名**：调用 `IrModifier` 将识别出的 LLVM Function 重命名为 `"main"`。
2.  **更新元数据**：在 `NameContainer` 中将该地址标记为最高优先级名称。
3.  **库代码“肢解” (Body Deletion)**：
    这是最容易被误解的一步。Pass 会遍历所有被识别为“静态链接（Statically Linked）”的库函数（如 `printf`, `malloc` 等），并调用 `f.deleteBody()`。

#### 库函数移除算法详解 (Library Removal Algorithm)
该算法的逻辑非常直白（见 `removeStaticallyLinked` 方法）：
1.  **全局扫描**：遍历 LLVM Module 中的所有 `llvm::Function`。
2.  **配置核对**：查询 RetDec 的内部配置对象（`Config`），获取该函数对应的元数据。
3.  **状态判定**：检查该函数是否被标记为 `isStaticallyLinked`。
    > [!NOTE]
    > 这个标记通常是在更早的阶段（如 `retdec-decoder` 之前的静态签名匹配阶段）通过 Yara 插件完成的。
4.  **身体切除**：一旦确认是静态链接库函数且不是用户定义的，直接调用 LLVM 的 API `f.deleteBody()`。
    *   **删掉了什么？**：删掉了这些库函数内部的复杂 LLVM IR 指令。
    *   **保留了什么？**：保留了函数的**声明 (Declaration)**。这意味着程序中对 `printf` 的调用依然存在，只是你不再需要去看 `printf` 内部是怎么实现的了。
5.  **目的**：极大地精简 IR 体积，让后续的分析 Pass 只聚焦于用户编写的代码逻辑。

## 5. 总结

`retdec-main-detection` 不是 Decoder 的替代者，而是其**语义补充**。

| 特性 | retdec-decoder | retdec-main-detection |
| --- | --- | --- |
| **主要任务** | 递归解码机器码 -> IR | 识别 IR 中的 `main` 语义 |
| **依赖项** | 跳转、调用、符号表 | 启动代码模式、编译器特征 |
| **核心产出** | 完整的代码森林 | 森林中的“主干”标记 |

如果没有这个 Pass，你的反编译结果可能会以一个晦涩的 `_start` 函数开头，包含大量无用的环境初始化代码，而真正的业务逻辑则被埋没在成百上千个名为 `sub_xxxxxx` 的函数中。
