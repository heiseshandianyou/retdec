# RetDec 二进制到 LLVM IR 转换流程详解

本文档详细描述了 RetDec 反编译器将二进制代码转换为 LLVM IR 的初始工作流程。

## 1. 整体架构概览

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         RetDec 反编译流程                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐            │
│   │ 二进制文件 │ -> │  加载器   │ -> │ Decoder  │ -> │ LLVM IR  │            │
│   │ (ELF/PE) │    │ (Loader) │    │ (bin2ll  │    │  生成     │            │
│   │          │    │          │    │ vmir)    │    │          │            │
│   └──────────┘    └──────────┘    └────┬─────┘    └──────────┘            │
│                                        │                                    │
│                                        ▼                                    │
│                              ┌──────────────────┐                          │
│                              │ capstone2llvmir  │                          │
│                              │  (指令翻译引擎)   │                          │
│                              └──────────────────┘                          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 2. 核心组件介绍

### 2.1 Loader（加载器）

**位置**: `src/loader/`

负责解析各种二进制文件格式（ELF、PE、Mach-O、COFF 等），提取可执行代码段和数据段。

**主要类**:
- `Image` - 内存镜像的抽象基类
- `ElfImage` - ELF 文件加载
- `PeImage` - PE 文件加载
- `MachOImage` - Mach-O 文件加载

### 2.2 Decoder（解码器）

**位置**: `src/bin2llvmir/optimizations/decoder/`

Decoder 是整个转换流程的核心，负责：
1. 控制流分析
2. 函数识别与边界确定
3. 基本块（Basic Block）划分
4. 调用 capstone2llvmir 进行指令翻译

**主要类**:
- `Decoder` - 核心解码器类，继承自 `llvm::ModulePass`

### 2.3 capstone2llvmir（指令翻译引擎）

**位置**: `src/capstone2llvmir/`

基于 Capstone 反汇编引擎，将机器指令转换为 LLVM IR。

**支持的架构**:
- x86/x64 (`src/capstone2llvmir/x86/`)
- ARM/Thumb (`src/capstone2llvmir/arm/`)
- ARM64 (`src/capstone2llvmir/arm64/`)
- MIPS (`src/capstone2llvmir/mips/`)
- PowerPC (`src/capstone2llvmir/powerpc/`)

## 3. 详细工作流程

### 3.1 阶段一：初始化

```cpp
// Decoder::run() 主入口
bool Decoder::run()
{
    initTranslator();        // 初始化 capstone2llvmir 翻译器
    initDryRunCsInstruction(); // 分配 Capstone 指令结构
    initEnvironment();       // 初始化环境（寄存器、伪函数等）
    initRanges();            // 确定需要解码的地址范围
    initJumpTargets();       // 初始化跳转目标（入口点、符号表等）
    
    decode();                // 核心解码循环
    
    resolvePseudoCalls();    // 解析伪调用
    patternsRecognize();     // 模式识别优化
    finalizePseudoCalls();   // 最终化伪调用
    initConfigFunctions();   // 初始化函数配置
}
```

#### 3.1.1 初始化翻译器

```cpp
void Decoder::initTranslator()
{
    // 根据目标架构选择合适的 Capstone 架构和模式
    cs_arch arch = CS_ARCH_X86;  // 或其他架构
    cs_mode basicMode = CS_MODE_32;  // 16/32/64 位
    cs_mode extraMode = CS_MODE_LITTLE_ENDIAN;  // 大小端
    
    // 创建翻译器实例
    _c2l = Capstone2LlvmIrTranslator::createArch(
        arch, _module, basicMode, extraMode);
}
```

#### 3.1.2 初始化环境

```cpp
void Decoder::initEnvironment()
{
    initEnvironmentAsm2LlvmMapping();  // ASM 到 LLVM 的映射
    initEnvironmentPseudoFunctions();  // 创建伪函数（call/ret/branch）
    initEnvironmentRegisters();        // 初始化寄存器全局变量
}
```

**伪函数（Pseudo Functions）**:
- `__pseudo_call` - 表示函数调用
- `__pseudo_return` - 表示函数返回
- `__pseudo_branch` - 表示无条件跳转
- `__pseudo_cond_branch` - 表示条件跳转

这些伪函数在解码时作为占位符，后续被转换为真实的 LLVM 控制流指令。

#### 3.1.3 确定解码范围

```cpp
void Decoder::initRanges()
{
    // 从各个来源收集可执行代码段：
    // 1. 配置文件中指定的范围
    // 2. 文件段表中的可执行段
    // 3. 入口点周围的代码
    // 4. 符号表中的函数地址
}
```

#### 3.1.4 初始化跳转目标

```cpp
void Decoder::initJumpTargets()
{
    initJumpTargetsConfig();      // 配置文件中的目标
    initJumpTargetsEntryPoint();  // 程序入口点
    initJumpTargetsExterns();     // 外部符号
    initJumpTargetsImports();     // 导入函数
    initJumpTargetsExports();     // 导出函数
    initJumpTargetsDebug();       // 调试信息中的函数
    initJumpTargetsSymbols();     // 符号表
}
```

### 3.2 阶段二：核心解码循环

```cpp
void Decoder::decode()
{
    JumpTarget jt;
    while (getJumpTarget(jt))  // 从队列中获取跳转目标
    {
        decodeJumpTarget(jt);  // 解码该目标
    }
}
```

#### 3.2.1 跳转目标处理

```cpp
void Decoder::decodeJumpTarget(const JumpTarget& jt)
{
    // 1. 验证地址有效性
    // 2. 获取二进制数据
    ByteData bytes = _image->getImage()->getRawSegmentData(start);
    
    // 3. 获取或创建基本块
    llvm::BasicBlock* bb = getBasicBlockAtAddress(start);
    
    // 4. 逐条指令解码
    Address addr = start;
    bool bbEnd = false;
    do {
        auto res = translate(bytes, addr, irb);
        
        // 记录映射关系
        _llvm2capstone->emplace(res.llvmInsn, res.capstoneInsn);
        
        // 提取跳转目标
        bbEnd |= getJumpTargetsFromInstruction(oldAddr, res, bytes.second);
        
        // 处理延迟槽（MIPS 等架构）
        handleDelaySlotTypical(addr, res, bytes, irb);
        handleDelaySlotLikely(addr, res, bytes, irb);
        
    } while (!bbEnd);
    
    // 5. 标记已解码范围
    _ranges.remove(start, addr);
}
```

#### 3.2.2 单条指令翻译

```cpp
TranslationResultOne Decoder::translate(
    ByteData& bytes, 
    common::Address& addr, 
    llvm::IRBuilder<>& irb)
{
    // 调用 capstone2llvmir 进行翻译
    auto res = _c2l->translateOne(bytes.first, bytes.second, addr, irb);
    
    // MIPS 特殊处理：32位模式失败时尝试64位模式
    if (isMips && res.failed()) {
        _c2l->modifyBasicMode(CS_MODE_MIPS64);
        res = _c2l->translateOne(bytes.first, bytes.second, addr, irb);
        _c2l->modifyBasicMode(CS_MODE_MIPS32);
    }
    
    return res;
}
```

### 3.3 阶段三：控制流重建

#### 3.3.1 函数调用处理

```cpp
bool Decoder::getJumpTargetsFromInstruction(...)
{
    if (_c2l->isCallFunctionCall(pCall)) {
        // 获取调用目标地址
        auto t = getJumpTarget(addr, pCall, pCall->getArgOperand(0));
        
        // 创建目标函数
        getOrCreateCallTarget(t, tFnc, tBb);
        
        if (tFnc) {
            // 将伪调用转换为真实调用
            transformToCall(pCall, tFnc);
        }
        
        // 将目标加入跳转队列
        _jumpTargets.push(t, JumpTarget::eType::CONTROL_FLOW_CALL_TARGET, ...);
    }
}
```

#### 3.3.2 条件分支处理

```cpp
// 伪条件分支转换为真实条件分支
llvm::BranchInst* Decoder::transformToCondBranch(
    llvm::CallInst* pseudo,
    llvm::Value* cond,
    llvm::BasicBlock* trueBb,
    llvm::BasicBlock* falseBb)
{
    auto* term = pseudo->getParent()->getTerminator();
    auto* br = BranchInst::Create(trueBb, falseBb, cond, term);
    term->eraseFromParent();
    return br;
}
```

#### 3.3.3 Switch 语句处理

```cpp
llvm::SwitchInst* Decoder::transformToSwitch(
    llvm::CallInst* pseudo,
    llvm::Value* val,
    llvm::BasicBlock* defaultBb,
    const std::vector<llvm::BasicBlock*>& cases)
{
    auto* sw = SwitchInst::Create(val, defaultBb, numCases, term);
    for (auto& c : cases) {
        if (c != defaultBb) {
            sw->addCase(ConstantInt::get(intType, cntr), c);
        }
    }
    return sw;
}
```

### 3.4 阶段四：后处理

```cpp
void Decoder::resolvePseudoCalls()
{
    // 解析所有伪调用，转换为 LLVM 控制流指令
}

void Decoder::patternsRecognize()
{
    // 识别常见模式：
    // 1. 终止函数调用（如 exit）
    // 2. 静态链接库函数
}

void Decoder::finalizePseudoCalls()
{
    // 最终处理所有未解析的伪调用
}
```

## 4. capstone2llvmir 详细实现

### 4.1 翻译器接口

```cpp
class Capstone2LlvmIrTranslator
{
public:
    // 工厂方法
    static std::unique_ptr<Capstone2LlvmIrTranslator> createX86_32(llvm::Module* m);
    static std::unique_ptr<Capstone2LlvmIrTranslator> createX86_64(llvm::Module* m);
    static std::unique_ptr<Capstone2LlvmIrTranslator> createArm(llvm::Module* m);
    // ...
    
    // 翻译方法
    TranslationResultOne translateOne(
        const uint8_t*& bytes,
        std::size_t& size,
        Address& a,
        llvm::IRBuilder<>& irb);
    
    // 寄存器访问
    llvm::GlobalVariable* getRegister(uint32_t r);
    
    // 伪函数查询
    bool isCallFunctionCall(llvm::CallInst* c);
    bool isReturnFunctionCall(llvm::CallInst* c);
    bool isBranchFunctionCall(llvm::CallInst* c);
};
```

### 4.2 x86 实现示例

```cpp
// src/capstone2llvmir/x86/x86.cpp
void Capstone2LlvmIrTranslatorX86_impl::generateRegisters()
{
    // 为所有 x86 寄存器创建 LLVM 全局变量
    // 例如：eax, ebx, ecx, edx, esp, ebp, eip 等
    // 64位：rax, rbx, rcx, rdx, rsp, rbp, rip 等
}

// 翻译单条指令
void Capstone2LlvmIrTranslatorX86_impl::translateInstruction(
    cs_insn* insn,
    llvm::IRBuilder<>& irb)
{
    switch (insn->id) {
        case X86_INS_MOV:
            translateMOV(insn, irb);
            break;
        case X86_INS_ADD:
            translateADD(insn, irb);
            break;
        case X86_INS_CALL:
            translateCALL(insn, irb);
            break;
        // ... 更多指令
    }
}
```

### 4.3 指令映射关系

每条汇编指令被映射为特定的 LLVM IR 序列：

**x86 MOV 指令**:
```asm
mov eax, ebx
```

转换为 LLVM IR:
```llvm
%ebx_val = load i32, i32* @ebx
store i32 %ebx_val, i32* @eax
```

**x86 ADD 指令**:
```asm
add eax, 5
```

转换为 LLVM IR:
```llvm
%eax_val = load i32, i32* @eax
%result = add i32 %eax_val, 5
store i32 %result, i32* @eax
; 更新 EFLAGS...
```

**函数调用**:
```asm
call 0x401000
```

转换为 LLVM IR（初始）:
```llvm
call void @__pseudo_call(i32 4198400)  ; 0x401000
```

最终转换为:
```llvm
%call_ret = call i32 @function_401000()
store i32 %call_ret, i32* @eax
```

## 5. 数据结构说明

### 5.1 JumpTarget（跳转目标）

```cpp
class JumpTarget
{
    Address _address;      // 目标地址
    eType _type;           // 目标类型（调用、分支、入口点等）
    cs_mode _mode;         // 架构模式（ARM/Thumb）
    Address _fromAddress;  // 来源地址
};
```

### 5.2 地址范围管理

```cpp
class RangesToDecode
{
    // 待解码的主范围
    std::map<Address, AddressRange> _primary;
    // 备选范围（可能的数据/代码混淆）
    std::map<Address, AddressRange> _alternative;
};
```

### 5.3 基本块和函数映射

```cpp
// 地址到基本块的映射
std::map<common::Address, llvm::BasicBlock*> _addr2bb;

// 地址到函数的映射
std::map<common::Address, llvm::Function*> _addr2fnc;

// LLVM IR 到 Capstone 指令的映射
std::map<llvm::StoreInst*, cs_insn*> _llvm2capstone;
```

## 6. 架构特定处理

### 6.1 ARM/Thumb 模式切换

```cpp
cs_mode Decoder::determineMode_arm(cs_insn* insn, Address& target)
{
    // 检查指令是否为模式切换指令（如 BX）
    // 根据目标地址的最低位确定 ARM 或 Thumb 模式
    if (target & 1) {
        target = target & ~1;  // 清除最低位
        return CS_MODE_THUMB;
    }
    return CS_MODE_ARM;
}
```

### 6.2 MIPS 延迟槽处理

```cpp
void Decoder::handleDelaySlotTypical(...)
{
    // MIPS 分支指令后的指令（延迟槽）总是执行
    // 需要在翻译时特殊处理
}

void Decoder::handleDelaySlotLikely(...)
{
    // MIPS "likely" 分支的延迟槽只在分支成功时执行
}
```

### 6.3 x86 地址空间

```cpp
// x86 有独特的内存分段机制
// 实模式：段:偏移 地址计算
// 保护模式： flat 内存模型
void Decoder::initX86AddrSpaces()
{
    // 处理 x86 特有的地址空间
}
```

## 7. 错误处理与调试

### 7.1 异常处理机制

```cpp
bool Decoder::runCatcher()
{
    try {
        return run();
    }
    catch (const BaseError& e) {
        Log::error() << "[capstone2llvmir]: " << e.what() << std::endl;
        exit(1);
    }
}
```

### 7.2 调试输出

Decoder 提供了详细的日志输出，可以通过 `LOG` 宏启用：

```cpp
LOG << "\t" << "processing : " << jt << std::endl;
LOG << "\t\t" << "found range = " << *range << std::endl;
LOG << "\t\t" << "decoded range = " << AddressRange(start, end) << std::endl;
```

### 7.3 干运行（Dry Run）

在解码前进行干运行，检查目标地址是否包含有效指令：

```cpp
std::size_t Decoder::decodeJumpTargetDryRun(const JumpTarget& jt, ...)
{
    // 架构特定的干运行检查
    if (isX86()) return decodeJumpTargetDryRun_x86(jt, bytes, strict);
    if (isArm()) return decodeJumpTargetDryRun_arm(jt, bytes, strict);
    // ...
}
```

## 8. 关键设计决策

### 8.1 伪函数设计

使用伪函数而不是直接生成 LLVM 控制流指令的原因：
1. **延迟解析**: 跳转目标可能还未解码
2. **简化翻译**: 每条指令独立翻译，不需要知道后续指令
3. **灵活性**: 后续可以更容易地进行控制流分析

### 8.2 寄存器建模

所有 CPU 寄存器都建模为 LLVM 全局变量：
- 简化状态跟踪
- 统一的内存访问接口
- 便于后续的寄存器分配优化

### 8.3 指令映射

使用特殊的 Store 指令建立 LLVM IR 和 Capstone 指令的双向映射：

```llvm
store i64 <address>, i64* @__asm2llvm_mapping_global
```

这使得可以在 LLVM IR 中快速定位对应的汇编指令。

## 9. 输出示例

### 9.1 原始二进制

```asm
; x86-32 代码示例
_start:
    push ebp
    mov ebp, esp
    sub esp, 16
    mov eax, [ebp+8]
    add eax, 1
    leave
    ret
```

### 9.2 生成的 LLVM IR

```llvm
; 全局寄存器定义
@eax = global i32 0
@ebx = global i32 0
@ecx = global i32 0
@edx = global i32 0
@esp = global i32 0
@ebp = global i32 0
; ... 其他寄存器

; 函数定义
define void @function_401000() {
entry:
    ; push ebp
    %ebp_val = load i32, i32* @ebp
    %esp_val = load i32, i32* @esp
    %esp_sub4 = sub i32 %esp_val, 4
    store i32 %esp_sub4, i32* @esp
    %esp_val2 = load i32, i32* @esp
    %esp_ptr = inttoptr i32 %esp_val2 to i32*
    store i32 %ebp_val, i32* %esp_ptr
    
    ; mov ebp, esp
    %esp_val3 = load i32, i32* @esp
    store i32 %esp_val3, i32* @ebp
    
    ; sub esp, 16
    %esp_val4 = load i32, i32* @esp
    %esp_sub16 = sub i32 %esp_val4, 16
    store i32 %esp_sub16, i32* @esp
    
    ; mov eax, [ebp+8]
    %ebp_val5 = load i32, i32* @ebp
    %addr = add i32 %ebp_val5, 8
    %ptr = inttoptr i32 %addr to i32*
    %val = load i32, i32* %ptr
    store i32 %val, i32* @eax
    
    ; add eax, 1
    %eax_val = load i32, i32* @eax
    %eax_add = add i32 %eax_val, 1
    store i32 %eax_add, i32* @eax
    
    ; leave (mov esp, ebp; pop ebp)
    %ebp_val6 = load i32, i32* @ebp
    store i32 %ebp_val6, i32* @esp
    ; ... pop 操作
    
    ; ret
    call void @__pseudo_return(i32 0)
    unreachable
}
```

## 10. 总结

RetDec 的二进制到 LLVM IR 转换流程可以概括为：

1. **加载阶段**: Loader 解析二进制文件，提取代码段和元数据
2. **初始化阶段**: Decoder 初始化翻译器和环境，确定解码范围
3. **解码阶段**: 使用 capstone2llvmir 逐条翻译指令，构建控制流图
4. **重建阶段**: 解析伪调用，重建函数调用图和基本块关系
5. **输出阶段**: 生成完整的 LLVM IR 模块

这种设计使得 RetDec 能够：
- 支持多种处理器架构
- 处理复杂的控制流（间接跳转、函数指针等）
- 保留足够的语义信息用于后续的反编译优化
- 利用 LLVM 的基础设施进行代码分析和转换

## 11. 相关文件索引

| 组件 | 主要文件 |
|------|----------|
| Loader | `src/loader/loader/image.cpp`, `src/loader/loader/*/`*_image.cpp` |
| Decoder | `src/bin2llvmir/optimizations/decoder/decoder.cpp` |
| capstone2llvmir | `src/capstone2llvmir/capstone2llvmir.cpp`, `src/capstone2llvmir/*/`*`
| 寄存器定义 | `include/retdec/capstone2llvmir/*/`*_defs.h` |
| 工具函数 | `src/bin2llvmir/utils/ir_modifier.cpp` |
