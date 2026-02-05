# RetDec 函数识别机制详解

本文档详细说明 RetDec 如何确定二进制代码中的某些地址是一个函数。

---

## 1. 概述

RetDec 使用**多阶段迭代**的方法来识别函数：

1. **元数据收集阶段**：从文件格式（PE/ELF/Mach-O）的符号表、导入/导出表、调试信息中收集已知的函数地址
2. **迭代解码阶段**：从已知函数开始反汇编，通过分析 `call` 指令、分支跳转、模式匹配等动态发现新函数
3. **递归发现阶段**：对新发现的函数重复解码过程，直到没有新的函数被发现

---

## 2. 从文件元数据识别函数

### 2.1 入口点 (Entry Point)

PE/ELF/Mach-O 文件头中指定了程序启动地址。

```cpp
// src/bin2llvmir/optimizations/decoder/decoder_init.cpp:595
void Decoder::initJumpTargetsEntryPoint()
{
    auto ep = _config->getConfig().parameters.getEntryPoint();
    if (auto* jt = _jumpTargets.push(
            ep,
            JumpTarget::eType::ENTRY_POINT,
            _c2l->getBasicMode(),
            Address::Undefined))
    {
        _entryPointFunction = createFunction(jt->getAddress());
        // ...
    }
}
```

### 2.2 符号表 (Symbol Table)

编译器生成的函数符号信息。

```cpp
// src/bin2llvmir/optimizations/decoder/decoder_init.cpp:840
void Decoder::initJumpTargetsSymbols()
{
    for (const auto* t : _image->getFileFormat()->getSymbolTables())
    for (const auto& s : *t)
    {
        // 检查符号类型是否为函数
        if (!s->isFunction())
        {
            continue;
        }
        
        unsigned long long a = 0;
        if (!s->getRealAddress(a))
        {
            continue;
        }
        
        // 创建函数
        if (auto* jt = _jumpTargets.push(
                addr,
                JumpTarget::eType::SYMBOL,
                s->isThumbSymbol() ? CS_MODE_THUMB :_c2l->getBasicMode(),
                Address::Undefined,
                sz))
        {
            auto* nf = createFunction(jt->getAddress());
            // ...
        }
    }
}
```

### 2.3 导入表 (Import Table)

外部函数的引用地址。

```cpp
// src/bin2llvmir/optimizations/decoder/decoder_init.cpp:666
void Decoder::initJumpTargetsImports()
{
    auto* impTbl = _image->getFileFormat()->getImportTable();
    if (impTbl == nullptr)
    {
        return;
    }
    
    for (const auto &imp : *impTbl)
    {
        common::Address a = imp->getAddress();
        
        if (auto* jt = _jumpTargets.push(
                a,
                JumpTarget::eType::IMPORT,
                _c2l->getBasicMode(),
                Address::Undefined))
        {
            auto* f = createFunction(jt->getAddress());
            // ...
        }
    }
}
```

### 2.4 导出表 (Export Table)

DLL 导出的函数地址。

```cpp
// src/bin2llvmir/optimizations/decoder/decoder_init.cpp:786
void Decoder::initJumpTargetsExports()
{
    auto* exTbl = _image->getFileFormat()->getExportTable();
    if (exTbl == nullptr)
    {
        return;
    }
    
    for (const auto& exp : *exTbl)
    {
        common::Address addr = exp.getAddress();
        
        if (auto* jt = _jumpTargets.push(
                addr,
                JumpTarget::eType::EXPORT,
                _c2l->getBasicMode(),
                Address::Undefined))
        {
            auto* nf = createFunction(jt->getAddress());
            // ...
        }
    }
}
```

### 2.5 调试信息 (Debug Info)

PDB/DWARF 中的函数信息。

```cpp
// src/bin2llvmir/optimizations/decoder/decoder_init.cpp:886
void Decoder::initJumpTargetsDebug()
{
    if (_debug == nullptr)
    {
        return;
    }
    
    for (const auto& p : _debug->functions)
    {
        common::Address addr = p.first;
        
        if (auto* jt = _jumpTargets.push(
                addr,
                JumpTarget::eType::DEBUG,
                f.isThumb() ? CS_MODE_THUMB : _c2l->getBasicMode(),
                Address::Undefined,
                sz))
        {
            auto* nf = createFunction(jt->getAddress());
            // ...
        }
    }
}
```

---

## 3. 扫描二进制代码识别函数

### 3.1 Call 指令目标识别

**原理**：如果一个地址被 `call` 指令调用，它很可能是一个函数。

```cpp
// src/bin2llvmir/optimizations/decoder/decoder.cpp:498
void Decoder::decode()
{
    // ...
    // 检查是否是函数调用伪指令
    if (_c2l->isCallFunctionCall(pCall))
    {
        // Function call -> insert target (if computed).
        llvm::Value* calledVal = pCall->getArgOperand(0);
        
        // 尝试获取调用的目标地址
        if (auto* addrConst = llvm::dyn_cast<llvm::ConstantInt>(calledVal))
        {
            std::uint64_t targetAddr = addrConst->getZExtValue();
            
            // 创建或获取目标函数
            getOrCreateCallTarget(targetAddr, tFnc, tBb);
            
            // 将目标加入跳转队列
            _jumpTargets.push(
                targetAddr,
                JumpTarget::eType::CONTROL_FLOW_CALL_TARGET,
                _c2l->getBasicMode(),
                start);
        }
    }
}
```

### 3.2 函数创建/获取逻辑

```cpp
// src/bin2llvmir/optimizations/decoder/ir_modifications.cpp:186
void Decoder::getOrCreateCallTarget(
        common::Address addr,
        llvm::Function*& tFnc,
        llvm::BasicBlock*& tBb)
{
    tBb = nullptr;
    tFnc = nullptr;

    // 1. 检查该地址是否已有函数
    if (auto* f = getFunctionAtAddress(addr))
    {
        tFnc = f;
        tBb = tFnc->empty() ? nullptr : &tFnc->front();
    }
    // 2. 检查是否在现有函数中间，如果是则拆分函数
    else if (auto* f = splitFunctionOn(addr))
    {
        tFnc = f;
        tBb = tFnc->empty() ? nullptr : &tFnc->front();
    }
    // 3. 检查是否有基本块在该地址
    else if (auto* bb = getBasicBlockAtAddress(addr))
    {
        tBb = bb;
    }
    // 4. 检查地址是否在某个函数内部
    else if (getBasicBlockContainingAddress(addr))
    {
        // Nothing - we are not splitting BBs here.
    }
    else if (getFunctionContainingAddress(addr))
    {
        auto* bb = getBasicBlockBeforeAddress(addr);
        tBb = createBasicBlock(addr, bb->getParent(), bb);
    }
    // 5. 创建新函数
    else
    {
        tFnc = createFunction(addr);
        tBb = tFnc && !tFnc->empty() ? &tFnc->front() : nullptr;
    }
}
```

### 3.3 分支跳转目标识别

**无条件跳转** (`jmp`) 和 **条件跳转** (`jz`, `je`, `jne` 等) 的目标也可能是函数：

```cpp
// src/bin2llvmir/optimizations/decoder/decoder.cpp:608
else if (_c2l->isBranchFunctionCall(pCall))
{
    // Unconditional branch -> insert target (if computed).
    llvm::Value* calledVal = pCall->getArgOperand(0);
    
    if (auto* addrConst = llvm::dyn_cast<llvm::ConstantInt>(calledVal))
    {
        std::uint64_t targetAddr = addrConst->getZExtValue();
        
        getOrCreateBranchTarget(targetAddr, tBb, tFnc, start);
        
        _jumpTargets.push(
            targetAddr,
            JumpTarget::eType::CONTROL_FLOW_BR_TRUE,  // 或 BR_FALSE
            _c2l->getBasicMode(),
            start);
    }
}
```

### 3.4 架构特定的跳转处理

不同架构有不同的分支/调用指令格式。

#### x86

```cpp
// src/bin2llvmir/optimizations/decoder/x86.cpp:53
if (_c2l->isReturnInstruction(*_dryCsInsn)
        || _c2l->isBranchInstruction(*_dryCsInsn))
{
    // 处理返回和分支指令
}
```

#### ARM

```cpp
// src/bin2llvmir/optimizations/decoder/arm.cpp:158
if (getBasicBlockAtAddress(addr) && getFunctionAtAddress(addr) == nullptr)
{
    // ARM 特定的函数检测逻辑
    splitFunctionOn(addr);
}
```

#### MIPS

```cpp
// src/bin2llvmir/optimizations/decoder/mips.cpp:101
if (_c2l->isReturnInstruction(*_dryCsInsn))
{
    // MIPS 返回指令处理
}
if (_c2l->isBranchInstruction(*_dryCsInsn)
        || _c2l->isCondBranchInstruction(*_dryCsInsn)
        || _c2l->isCallInstruction(*_dryCsInsn))
{
    // MIPS 分支/调用指令处理
}
```

---

## 4. 静态代码模式匹配 (stacofin)

RetDec 使用 YARA 风格的模式匹配在二进制中搜索已知的函数签名。

```cpp
// src/bin2llvmir/optimizations/decoder/decoder_init.cpp:933
void Decoder::initStaticCode()
{
    stacofin::Finder SCA;
    SCA.searchAndConfirm(*_image->getImage(), _config->getConfig());
    
    for (auto& p : SCA.getConfirmedDetections())
    {
        auto* sf = p.second;
        
        // 为检测到的静态函数创建函数对象
        if (auto* jt = _jumpTargets.push(
                sf->getAddress(),
                JumpTarget::eType::STATIC_CODE,
                sf->isThumb() ? CS_MODE_THUMB : _c2l->getBasicMode(),
                Address::Undefined,
                sf->size))
        {
            auto* nf = createFunction(jt->getAddress());
            _staticFncs.insert(jt->getAddress());
            
            if (sf->isTerminating())
            {
                _terminatingFncs.insert(nf);
            }
        }
    }
}
```

### 4.1 模式匹配类型

| 模式类型 | 说明 | 示例 (x86) |
|---------|------|-----------|
| **函数序言** | 函数开头的标准指令序列 | `push ebp; mov ebp, esp` |
| **函数尾声** | 函数结尾的标准指令序列 | `leave; ret` |
| **库函数签名** | 已知库函数的指令特征 | `malloc`, `printf` 等 |

---

## 5. C++ 虚表 (Vtable) 分析

对于 C++ 程序，虚表中存储的条目都是成员函数地址。

```cpp
// src/bin2llvmir/optimizations/decoder/decoder_init.cpp:991
void Decoder::initVtables()
{
    std::vector<const common::Vtable*> vtable;
    
    // 收集 GCC 和 MSVC 风格的虚表
    for (auto& p : _image->getRtti().getVtablesGcc())
    {
        vtable.push_back(&p.second);
    }
    for (auto& p : _image->getRtti().getVtablesMsvc())
    {
        vtable.push_back(&p.second);
    }
    
    // 从虚表中提取函数指针
    for (auto* p : vtable)
    {
        auto& vt = *p;
        for (auto& item : vt.items)
        {
            // 虚表中的每个条目都是一个函数地址
            if (auto* jt = _jumpTargets.push(
                    item.functionAddress,
                    JumpTarget::eType::VTABLE,
                    _c2l->getBasicMode(),
                    Address::Undefined))
            {
                auto* nf = createFunction(jt->getAddress());
                // ...
            }
        }
    }
}
```

---

## 6. 函数拆分 (Function Splitting)

当一个新发现的函数地址位于现有函数中间时，需要拆分现有函数。

```cpp
// src/bin2llvmir/optimizations/decoder/ir_modifications.cpp:474
llvm::Function* Decoder::splitFunctionOn(common::Address addr)
{
    auto* bb = getBasicBlockContainingAddress(addr);
    if (bb == nullptr)
    {
        return nullptr;
    }
    
    LOG << "\t\t\t\t" << "S: splitFunctionOn @ " << addr << std::endl;
    
    return splitFunctionOn(addr, bb);
}
```

---

## 7. 跳转目标类型汇总

RetDec 定义了多种跳转目标类型来跟踪函数来源：

```cpp
// src/bin2llvmir/optimizations/decoder/jump_targets.cpp:106
enum class eType {
    CONTROL_FLOW_CALL_TARGET,       // Call 指令目标
    CONTROL_FLOW_RETURN_TARGET,     // 返回目标
    CONTROL_FLOW_BR_TRUE,           // 条件分支（真）
    CONTROL_FLOW_BR_FALSE,          // 条件分支（假）
    CONTROL_FLOW_SWITCH_CASE,       // Switch case
    CONFIG,                          // 配置文件指定
    ENTRY_POINT,                     // 入口点
    SELECTED_RANGE_START,            // 用户选择范围
    IMPORT,                          // 导入函数
    EXPORT,                          // 导出函数
    DEBUG,                           // 调试信息
    SYMBOL,                          // 符号表
    STATIC_CODE,                     // 静态代码检测
    VTABLE,                          // 虚表
    LEFTOVER                         // 剩余代码
};
```

---

## 8. 完整的函数识别流程

```
┌─────────────────────────────────────────────────────────────────────────┐
│  阶段 1: 元数据收集                                                        │
│  - initJumpTargetsEntryPoint()     - 入口点                               │
│  - initJumpTargetsSymbols()        - 符号表                               │
│  - initJumpTargetsImports()        - 导入表                               │
│  - initJumpTargetsExports()        - 导出表                               │
│  - initJumpTargetsDebug()          - 调试信息                             │
│  - initStaticCode()                - 静态模式匹配                          │
│  - initVtables()                   - 虚表分析                              │
└──────────────────────┬──────────────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  阶段 2: 解码主循环 (decode())                                             │
│  - 从跳转目标队列取地址                                                    │
│  - 反汇编指令                                                             │
│  - 检测 call/branch/return 指令                                           │
└──────────────────────┬──────────────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  阶段 3: 动态发现新函数                                                    │
│  - isCallFunctionCall()            - 检测调用                              │
│    → getOrCreateCallTarget()       - 获取/创建目标函数                      │
│      → getFunctionAtAddress()      - 检查是否已存在                         │
│      → splitFunctionOn()           - 拆分现有函数                          │
│      → createFunction()            - 创建新函数                            │
│  - isBranchFunctionCall()          - 检测分支                              │
│    → getOrCreateBranchTarget()     - 获取/创建分支目标                      │
└──────────────────────┬──────────────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  阶段 4: 迭代直到队列为空                                                  │
│  - 新函数加入跳转队列                                                       │
│  - 重复阶段 2-3                                                           │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 9. 关键函数速查表

| 函数 | 文件 | 行号 | 用途 |
|------|------|------|------|
| `createFunction()` | `decoder/functions.cpp` | 109 | 创建新函数 |
| `getFunctionAtAddress()` | `decoder/functions.cpp` | 48 | 检查地址是否已有函数 |
| `getOrCreateCallTarget()` | `decoder/ir_modifications.cpp` | 186 | 处理 call 指令目标 |
| `getOrCreateBranchTarget()` | `decoder/ir_modifications.cpp` | 237 | 处理分支指令目标 |
| `splitFunctionOn()` | `decoder/ir_modifications.cpp` | 474 | 在地址处拆分现有函数 |
| `decode()` | `decoder/decoder.cpp` | ~200 | 解码主循环 |
| `initJumpTargetsEntryPoint()` | `decoder/decoder_init.cpp` | 595 | 添加入口点函数 |
| `initJumpTargetsSymbols()` | `decoder/decoder_init.cpp` | 840 | 从符号表添加函数 |
| `initJumpTargetsImports()` | `decoder/decoder_init.cpp` | 666 | 从导入表添加函数 |
| `initJumpTargetsExports()` | `decoder/decoder_init.cpp` | 786 | 从导出表添加函数 |
| `initStaticCode()` | `decoder/decoder_init.cpp` | 933 | 静态代码检测 |
| `initVtables()` | `decoder/decoder_init.cpp` | 991 | 虚表函数检测 |

---

## 10. 总结

RetDec 通过以下方式确定某些地址是一个函数：

1. **文件元数据**（编译时信息）
   - 入口点、符号表、导入/导出表、调试信息

2. **Call 指令扫描**（运行时分析）
   - 被 `call` 指令调用的地址被视为函数

3. **分支跳转分析**
   - 跳转指令的目标可能是新函数

4. **模式匹配**（静态分析）
   - 函数序言/尾声模式识别

5. **C++ 虚表分析**
   - 虚表条目都是成员函数地址

6. **递归迭代**
   - 对新发现的函数重复分析过程

这些方法结合起来，使得 RetDec 能够在没有完整符号信息的情况下，有效地识别二进制代码中的函数边界。
