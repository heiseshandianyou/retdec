# RetDec 伪调用（Pseudo Call）转换为真实调用的详细流程

## 目录

1. [概述](#概述)
2. [代码位置](#代码位置)
3. [阶段一：生成伪调用（capstone2llvmir）](#阶段一生成伪调用capstone2llvmir)
4. [阶段二：初次解码转换（Decoder）](#阶段二初次解码转换decoder)
5. [核心转换函数：transformToCall](#核心转换函数transformtocall)
6. [阶段三：重新解析未确定的调用](#阶段三重新解析未确定的调用)
7. [阶段四：最终清理](#阶段四最终清理)
8. [获取/创建调用目标的完整逻辑](#获取创建调用目标的完整逻辑)
9. [完整流程图](#完整流程图)
10. [关键设计要点](#关键设计要点)

---

## 概述

在 RetDec 中，函数调用的处理采用**两阶段设计模式**：

1. **第一阶段（capstone2llvmir）**：将汇编 `call` 指令转换为对 `_callFunction` 伪函数的调用，而不是直接调用目标函数
2. **第二阶段（Decoder）**：在后续分析中解析调用目标地址，将伪调用转换为对真实函数的调用

这种设计的优势：
- **延迟绑定**：允许处理间接调用和前向引用（目标函数尚未解码）
- **灵活解析**：初次解码时无法确定的调用，可在后续阶段重新解析
- **统一处理**：所有控制流指令（Call/Return/Branch）采用统一的伪函数机制

---

## 代码位置

| 阶段 | 文件路径 | 关键函数/类 |
|------|---------|------------|
| 生成伪调用 | `src/capstone2llvmir/capstone2llvmir_impl.cpp` | `generateCallFunctionCall()` |
| x86 Call 翻译 | `src/capstone2llvmir/x86/x86.cpp` | `translateCall()` |
| 初次转换 | `src/bin2llvmir/optimizations/decoder/decoder.cpp` | `getJumpTargetsFromInstruction()` |
| IR 转换 | `src/bin2llvmir/optimizations/decoder/ir_modifications.cpp` | `transformToCall()` |
| 重新解析 | `src/bin2llvmir/optimizations/decoder/decoder.cpp` | `resolvePseudoCalls()` |
| 最终清理 | `src/bin2llvmir/optimizations/decoder/decoder.cpp` | `finalizePseudoCalls()` |
| 目标获取 | `src/bin2llvmir/optimizations/decoder/ir_modifications.cpp` | `getOrCreateCallTarget()` |

---

## 阶段一：生成伪调用（capstone2llvmir）

### 1.1 创建伪函数

在初始化时，创建一个名为 `_callFunction` 的特殊函数：

```cpp
// src/capstone2llvmir/capstone2llvmir_impl.cpp:800-811

void Capstone2LlvmIrTranslator_impl::generateCallFunction()
{
    // 创建函数类型: void (int<arch_bit_size>)
    // 参数为目标地址（如 i32 表示 32 位地址）
    auto* ft = llvm::FunctionType::get(
        llvm::Type::getVoidTy(_module->getContext()),
        {llvm::Type::getIntNTy(_module->getContext(), getArchBitSize())},
        false);
    
    _callFunction = llvm::Function::Create(
        ft,
        llvm::GlobalValue::LinkageTypes::ExternalLinkage,
        "",  // 空名称，内部使用
        _module);
}
```

### 1.2 生成伪调用指令

当翻译 `call` 指令时，生成对 `_callFunction` 的调用：

```cpp
// src/capstone2llvmir/capstone2llvmir_impl.cpp:814-822

llvm::CallInst* Capstone2LlvmIrTranslator_impl::generateCallFunctionCall(
        llvm::IRBuilder<>& irb,
        llvm::Value* t)  // t = 调用目标地址值
{
    auto* a1t = _callFunction->arg_begin()->getType();
    t = irb.CreateSExtOrTrunc(t, a1t);  // 类型转换
    
    // 生成: call void @_callFunction(i32 %target_addr)
    _branchGenerated = irb.CreateCall(_callFunction, {t});
    return _branchGenerated;
}
```

### 1.3 x86 架构的 Call 指令翻译

以 x86 为例，展示完整的 `call` 指令翻译过程：

```cpp
// src/capstone2llvmir/x86/x86.cpp (translateCall)

void Capstone2LlvmIrTranslatorX86_impl::translateCall(
        cs_insn* i,       // Capstone 指令
        cs_x86* xi,       // x86 指令详情
        llvm::IRBuilder<>& irb)
{
    // 1. 获取当前 PC（返回地址）
    auto* pc = getCurrentPc(i);
    
    // 2. 获取栈指针寄存器
    auto* sp = loadRegister(getStackPointerRegister(), irb);
    
    // 3. 计算新栈指针 (ESP -= 4 或 RSP -= 8)
    auto* ci = llvm::ConstantInt::get(sp->getType(), getArchByteSize());
    auto* sub = irb.CreateSub(sp, ci);
    
    // 4. 将返回地址压入栈
    auto* pt = llvm::PointerType::get(pc->getType(), 0);
    auto* addr = irb.CreateIntToPtr(sub, pt);
    irb.CreateStore(pc, addr);  // [ESP] = 返回地址
    storeRegister(getStackPointerRegister(), sub, irb);  // 更新 ESP

    // 5. 加载调用目标操作数
    op0 = loadOpUnary(xi, irb);  // 解析 call 的操作数
    
    // 6. 生成伪调用
    generateCallFunctionCall(irb, op0);
}
```

**生成的 LLVM IR 示例**：

```llvm
; 原始汇编: call 0x401000

; 1. 保存返回地址
%esp.1 = sub i32 %esp, 4
%addr.ptr = inttoptr i32 %esp.1 to i32*
store i32 %pc, i32* %addr.ptr
store i32 %esp.1, i32* @ESP

; 2. 伪调用（目标地址 0x401000）
call void @_callFunction(i32 4198400)  ; 0x401000 = 4198400
```

---

## 阶段二：初次解码转换（Decoder）

在 `Decoder::decode()` 中，解码每条指令后，检查是否为伪调用并尝试转换。

### 2.1 主处理逻辑

```cpp
// src/bin2llvmir/optimizations/decoder/decoder.cpp:477-575

bool Decoder::getJumpTargetsFromInstruction(
        common::Address addr,
        capstone2llvmir::Capstone2LlvmIrTranslator::TranslationResultOne& tr,
        std::size_t& rangeSize)
{
    llvm::CallInst*& pCall = tr.branchCall;  // 获取伪调用指令
    auto nextAddr = addr + tr.size;

    // ========== 识别函数调用 ==========
    if (_c2l->isCallFunctionCall(pCall))
    {
        // 计算调用目标地址
        auto t = getJumpTarget(addr, pCall, pCall->getArgOperand(0));
        
        // 检查特殊情况
        if (t == nextAddr)  // call $+5 (获取 PC 的技巧)
            return false;
        if (addr < t && t < nextAddr)  // 调用到当前指令中间
            return false;

        if (t || (t == 0 && AsmInstruction(_module, 0)))
        {
            // 确定目标模式（ARM/Thumb 切换）
            auto m = determineMode(tr.capstoneInsn, t);
            
            // 获取或创建目标函数/基本块
            getOrCreateCallTarget(t, tFnc, tBb);

            // ========== 转换为真实调用 ==========
            if (tFnc)  // 目标是一个函数
            {
                transformToCall(pCall, tFnc);
            }
            else if (tBb && tBb->getParent() == pCall->getFunction() 
                    && tBb->getPrevNode())
            {
                // 目标是当前函数内的基本块 → 转换为跳转
                transformToBranch(pCall, tBb);
                _jumpTargets.push(t, JumpTarget::eType::CONTROL_FLOW_BR_TRUE, m, addr);
                return true;  // 结束当前基本块
            }
            else
            {
                // 无法立即转换，稍后处理
                return false;
            }

            // 添加目标到解码队列
            _jumpTargets.push(t, JumpTarget::eType::CONTROL_FLOW_CALL_TARGET, 
                             determineMode(tr.capstoneInsn, t), addr);
            
            // 如果目标是终止函数（如 exit），当前基本块结束
            if (tFnc && _terminatingFncs.count(tFnc))
            {
                auto* ui = new llvm::UnreachableInst(_module->getContext());
                ReplaceInstWithInst(&*_irb->GetInsertPoint(), ui);
                _irb->SetInsertPoint(ui);
                return true;
            }
        }
    }
    // ... 处理 Return/Branch/CondBranch
}
```

### 2.2 判断伪调用类型

使用 `capstone2llvmir` 提供的接口判断调用类型：

```cpp
// 检查是否为 _callFunction 调用
if (_c2l->isCallFunctionCall(pCall)) { ... }

// 检查是否为 _returnFunction 调用
else if (_c2l->isReturnFunctionCall(pCall)) { ... }

// 检查是否为 _branchFunction 调用
else if (_c2l->isBranchFunctionCall(pCall)) { ... }

// 检查是否为 _condBranchFunction 调用
else if (_c2l->isCondBranchFunctionCall(pCall)) { ... }
```

---

## 核心转换函数：transformToCall

这是将伪调用转换为真实调用的核心函数。

### 3.1 函数实现

```cpp
// src/bin2llvmir/optimizations/decoder/ir_modifications.cpp:14-30

llvm::CallInst* Decoder::transformToCall(
        llvm::CallInst* pseudo,      // 伪调用指令
        llvm::Function* callee)      // 目标函数
{
    // 1. 创建真实调用指令，插入到伪调用之后
    auto* c = CallInst::Create(callee);
    c->insertAfter(pseudo);
    
    // 2. 处理返回值（ABI 相关）
    if (auto* retObj = getCallReturnObject())
    {
        // 如有必要，进行类型转换
        auto* cc = cast<Instruction>(
            IrModifier::convertValueToTypeAfter(c, retObj->getValueType(), c));
        
        // 将返回值存储到 ABI 规定的寄存器
        auto* s = new StoreInst(cc, retObj);
        s->insertAfter(cc);
    }
    
    return c;
}
```

### 3.2 返回值处理（ABI）

根据目标架构选择正确的返回值寄存器：

```cpp
// src/bin2llvmir/optimizations/decoder/ir_modifications.cpp:149-178

llvm::GlobalVariable* Decoder::getCallReturnObject()
{
    if (_config->getConfig().architecture.isX86_32()) {
        return _abi->getRegister(X86_REG_EAX);  // EAX: 32 位返回值
    }
    else if (_config->getConfig().architecture.isX86_64()) {
        return _abi->getRegister(X86_REG_RAX);  // RAX: 64 位返回值
    }
    else if (_config->getConfig().architecture.isMipsOrPic32()) {
        return _abi->getRegister(MIPS_REG_V0);  // $v0: MIPS 返回值
    }
    else if (_config->getConfig().architecture.isPpc()) {
        return _abi->getRegister(PPC_REG_R3);   // R3: PowerPC 返回值
    }
    else if (_config->getConfig().architecture.isArm32OrThumb()) {
        return _abi->getRegister(ARM_REG_R0);   // R0: ARM 返回值
    }
    else if (_config->getConfig().architecture.isArm64()) {
        return _abi->getRegister(ARM64_REG_X0); // X0: ARM64 返回值
    }
    
    assert(false);
    return nullptr;
}
```

### 3.3 条件调用转换

对于条件调用（如 ARM 的 `BLcc` 指令）：

```cpp
// src/bin2llvmir/optimizations/decoder/ir_modifications.cpp:32-54

llvm::CallInst* Decoder::transformToCondCall(
        llvm::CallInst* pseudo,
        llvm::Value* cond,           // 条件值
        llvm::Function* callee,
        llvm::BasicBlock* falseBb)   // 条件为假时的跳转目标
{
    auto* oldBb = pseudo->getParent();
    auto* newBb = oldBb->splitBasicBlock(pseudo);
    
    // 创建条件分支
    auto* oldTerm = oldBb->getTerminator();
    BranchInst::Create(newBb, falseBb, cond, oldTerm);
    oldTerm->eraseFromParent();
    
    // 新基本块调用函数后跳转到 falseBb
    auto* newTerm = newBb->getTerminator();
    BranchInst::Create(falseBb, newTerm);
    newTerm->eraseFromParent();
    
    // 在 newBb 中插入调用
    auto* c = CallInst::Create(callee);
    c->insertAfter(pseudo);
    
    return c;
}
```

---

## 阶段三：重新解析未确定的调用

### 3.1 为什么需要重新解析

在初次解码阶段（`getJumpTargetsFromInstruction`），某些调用目标可能无法立即确定：
- **间接调用**：目标地址通过寄存器或内存计算得出
- **前向引用**：目标函数尚未被解码（地址未知）
- **复杂表达式**：目标地址需要常量传播才能确定

```cpp
// 示例：间接调用（初次解码时无法确定目标）
call [eax]        ; eax 的值在静态分析时未知
call [0x405000]   ; 内存中的值可能是动态写入的
```

### 3.2 `resolvePseudoCalls()` 详解

`resolvePseudoCalls()` 在主要解码完成后，**第二次遍历**所有伪调用，尝试解析那些初次未确定的目标。

#### 核心逻辑

```cpp
// src/bin2llvmir/optimizations/decoder/decoder.cpp:1474-1529

void Decoder::resolvePseudoCalls()
{
    // TODO: 理想情况下应该实现不动点算法，反复解析直到稳定
    // - 相同结果 -> 保持现状
    // - 无结果 -> 撤销转换
    // - 新结果 -> 重新转换
    // 但这实现复杂，涉及撤销操作和状态管理

    for (llvm::Function& f : *_module)
    for (llvm::BasicBlock& b : f)
    for (auto i = b.begin(), e = b.end(); i != e;)
    {
        // 1. 查找伪调用指令
        llvm::CallInst* pseudo = llvm::dyn_cast<llvm::CallInst>(&*i);
        ++i;
        if (pseudo == nullptr) continue;
        
        // 2. 只处理控制流相关的伪调用
        if (!_c2l->isCallFunctionCall(pseudo) &&
            !_c2l->isReturnFunctionCall(pseudo) &&
            !_c2l->isBranchFunctionCall(pseudo) &&
            !_c2l->isCondBranchFunctionCall(pseudo))
        {
            continue;
        }
        
        // 3. 获取伪调用后的第一条真实指令
        // 在初次解码时，如果目标已确定，会生成：
        //   call @_callFunction(addr)  <- 伪调用
        //   call @real_function()      <- 真实调用（real）
        //   store i32 %ret, i32* @EAX   <- 返回值存储
        llvm::Instruction* real = pseudo->getNextNode();
        if (real == nullptr) continue;
        ++i;
        
        // 4. 处理 Call 类型的伪调用
        if (_c2l->isCallFunctionCall(pseudo)
                && llvm::isa<llvm::CallInst>(real))
        {
            // 重新计算目标地址
            // getJumpTarget 会尝试常量传播、查找已解码的函数等
            Address t = getJumpTarget(
                    AsmInstruction::getInstructionAddress(real),
                    pseudo,
                    pseudo->getArgOperand(0));

            // 5. 如果仍无法解析，删除之前生成的调用
            if (t.isUndefined())
            {
                ++i;
                // 删除返回值存储指令（StoreInst）
                auto* st = llvm::cast<llvm::StoreInst>(*real->user_begin());
                st->eraseFromParent();
                // 删除真实调用指令
                real->eraseFromParent();
                // 注意：伪调用本身在 finalizePseudoCalls() 中删除
            }
        }
    }
}
```

#### 关键步骤说明

| 步骤 | 代码 | 说明 |
|------|------|------|
| 1 | `dyn_cast<llvm::CallInst>(&*i)` | 遍历所有指令，查找调用指令 |
| 2 | `isCallFunctionCall(pseudo)` | 判断是否为我们生成的伪调用 |
| 3 | `pseudo->getNextNode()` | 获取伪调用后的第一条指令 |
| 4 | `getJumpTarget(...)` | **核心：重新计算调用目标地址** |
| 5 | `st->eraseFromParent()` | 如果仍无法解析，清理生成的指令 |

### 3.3 `getJumpTarget()` 解析逻辑

`getJumpTarget()` 尝试通过多种方式确定调用目标：

```cpp
// 伪代码示意
Address Decoder::getJumpTarget(Address from, CallInst* pseudo, Value* targetVal)
{
    // 1. 常量直接解析
    if (auto* ci = dyn_cast<ConstantInt>(targetVal)) {
        return ci->getZExtValue();
    }
    
    // 2. 查找已解码的函数
    for (auto& f : module->functions()) {
        if (f.getAddress() == computedAddr) {
            return f.getAddress();
        }
    }
    
    // 3. 常量传播（尝试计算表达式的值）
    // 例如：%addr = add i32 0x401000, 16 -> 0x401010
    
    // 4. 如果仍无法确定，返回 Undefined
    return Address::Undefined;
}
```

### 3.4 两种处理结果

```
初次解码时目标未确定
        │
        ▼
┌─────────────────────────────┐
│ resolvePseudoCalls() 重新解析 │
└─────────────────────────────┘
        │
   ┌────┴────┐
   ▼         ▼
能确定目标   仍无法确定
   │         │
   ▼         ▼
保持转换    删除生成的调用
（有效）    （无效转换回滚）
```

### 3.5 为什么不是不动点算法

代码注释中提到：

```cpp
// TODO: fix point algorithm that tries to re-solve all solved and unsolved
// pseudo calls?
// - the same result -> ok, nothing
// - no result -> revert transformation
// - new result -> new transformation
// This will not be easy. Can fixpoint even be reached? Reverts, etc. are
// hard and ugly.
```

**不动点算法的难点**：
1. **循环依赖**：A 调用 B，B 调用 A，解析结果可能震荡
2. **状态管理**：撤销之前的转换涉及大量 IR 修改
3. **收敛性**：无法保证一定能达到稳定状态
4. **复杂度**：实现代价高，收益有限

当前实现采用**单次重解析**，在简单场景下已经足够有效。

### 3.6 与 `finalizePseudoCalls()` 的关系

| 函数 | 调用时机 | 作用 |
|------|---------|------|
| `resolvePseudoCalls()` | 主要解码完成后 | 重解析未确定的调用，删除无效转换 |
| `finalizePseudoCalls()` | `resolvePseudoCalls()` 之后 | 删除所有剩余的伪调用及其 setup 代码 |

**注意**：`resolvePseudoCalls()` 删除的是之前生成的**真实调用**（无效时），而 `finalizePseudoCalls()` 删除的是**伪调用本身**（无论是否有效）。

---

## 阶段四：最终清理

`finalizePseudoCalls()` 删除所有剩余的伪调用及其相关设置指令。

```cpp
// src/bin2llvmir/optimizations/decoder/decoder.cpp:1531-1637

void Decoder::finalizePseudoCalls()
{
    for (auto& f : *_module)
    for (auto& b : f)
    for (auto i = b.begin(), e = b.end(); i != e;)
    {
        auto* pseudo = llvm::dyn_cast<llvm::CallInst>(&*i);
        ++i;
        if (pseudo == nullptr) continue;
        
        // 判断伪调用类型
        bool icf = _c2l->isCallFunctionCall(pseudo);      // 调用
        bool irf = _c2l->isReturnFunctionCall(pseudo);    // 返回
        bool ibf = _c2l->isBranchFunctionCall(pseudo);    // 无条件跳转
        bool icbf = _c2l->isCondBranchFunctionCall(pseudo); // 条件跳转
        
        if (!icf && !irf && !ibf && !icbf) continue;
        
        // 获取前一个指令，准备向后遍历
        llvm::Instruction* it = pseudo->getPrevNode();
        
        // 删除伪调用本身
        pseudo->eraseFromParent();
        
        // 向后遍历，删除相关的 setup 指令
        bool mipsFirstAsmInstr = true;
        while (it)
        {
            // 遇到 ASM 指令映射，停止（MIPS 除外）
            if (AsmInstruction::isLlvmToAsmInstruction(it))
            {
                if (_config->getConfig().architecture.isMipsOrPic32()
                        && mipsFirstAsmInstr)
                    mipsFirstAsmInstr = false;
                else
                    break;
            }
            
            auto* i = it;
            it = it->getPrevNode();
            
            // x86: 删除返回地址存储到栈的指令
            if (_config->getConfig().architecture.isX86() && (icf || irf))
            if (auto* st = llvm::dyn_cast<llvm::StoreInst>(i))
            {
                if (_abi->isStackPointerRegister(st->getPointerOperand()) ||
                    llvm::isa<llvm::ConstantInt>(st->getValueOperand()))
                {
                    st->eraseFromParent();
                    i = nullptr;
                }
            }
            
            // MIPS: 删除返回地址存储到 $ra 的指令
            if (_config->getConfig().architecture.isMipsOrPic32() && icf)
            if (auto* st = llvm::dyn_cast<llvm::StoreInst>(i))
            {
                if (_abi->isRegister(st->getPointerOperand(), MIPS_REG_RA))
                {
                    st->eraseFromParent();
                    i = nullptr;
                }
            }
            
            // ARM: 删除返回地址存储到 LR 的指令
            if (_config->getConfig().architecture.isArm32OrThumb() && icf)
            if (auto* st = llvm::dyn_cast<llvm::StoreInst>(i))
            {
                if (_abi->isRegister(st->getPointerOperand(), ARM_REG_LR))
                {
                    st->eraseFromParent();
                    i = nullptr;
                }
            }
            
            // PowerPC: 删除返回地址存储到 LR 的指令
            if (_config->getConfig().architecture.isPpc() && icf)
            if (auto* st = llvm::dyn_cast<llvm::StoreInst>(i))
            {
                if (_abi->isRegister(st->getPointerOperand(), PPC_REG_LR))
                {
                    st->eraseFromParent();
                    i = nullptr;
                }
            }
            
            // 删除其他无用指令
            if (i && !i->getType()->isVoidTy() && i->use_empty())
            {
                i->eraseFromParent();
            }
        }
    }
}
```

---

## 获取/创建调用目标的完整逻辑

`getOrCreateCallTarget()` 负责根据地址获取或创建目标函数/基本块。

```cpp
// src/bin2llvmir/optimizations/decoder/ir_modifications.cpp:186-232

void Decoder::getOrCreateCallTarget(
        common::Address addr,
        llvm::Function*& tFnc,
        llvm::BasicBlock*& tBb)
{
    tBb = nullptr;
    tFnc = nullptr;
    
    // 1. 检查是否已有函数在该地址
    if (auto* f = getFunctionAtAddress(addr))
    {
        tFnc = f;
        tBb = tFnc->empty() ? nullptr : &tFnc->front();
        LOG << "\t\t\t\t" << "F: getFunctionAtAddress() @ " << addr << std::endl;
    }
    // 2. 尝试在该地址拆分现有函数
    else if (auto* f = splitFunctionOn(addr))
    {
        tFnc = f;
        tBb = tFnc->empty() ? nullptr : &tFnc->front();
        LOG << "\t\t\t\t" << "F: splitFunctionOn() @ " << addr << std::endl;
    }
    // 3. 检查是否已有基本块
    else if (auto* bb = getBasicBlockAtAddress(addr))
    {
        tBb = bb;
        LOG << "\t\t\t\t" << "F: getBasicBlockAtAddress() @ " << addr << std::endl;
    }
    // 4. 如果目标在现有基本块内，不拆分（避免复杂情况）
    else if (getBasicBlockContainingAddress(addr))
    {
        LOG << "\t\t\t\t" << "F: getBasicBlockContainingAddress() @ " << addr << std::endl;
    }
    // 5. 如果目标在现有函数内，创建新基本块
    else if (getFunctionContainingAddress(addr))
    {
        auto* bb = getBasicBlockBeforeAddress(addr);
        assert(bb);
        tBb = createBasicBlock(addr, bb->getParent(), bb);
        LOG << "\t\t\t\t" << "F: getBasicBlockBeforeAddress() @ " << addr << std::endl;
    }
    // 6. 创建新函数
    else
    {
        tFnc = createFunction(addr);
        tBb = tFnc && !tFnc->empty() ? &tFnc->front() : nullptr;
        LOG << "\t\t\t\t" << "F: createFunction() @ " << addr << std::endl;
    }
}
```

---

## 完整流程图

```
原始汇编指令: call 0x401000
              │
              ▼
┌─────────────────────────────────────────────┐
│ 阶段1: capstone2llvmir                      │
│                                             │
│ translateCall():                            │
│   1. %esp.1 = sub i32 %esp, 4               │
│   2. store i32 %pc, i32* %esp.ptr           │
│   3. call void @_callFunction(i32 4198400)  │
│      ↑ 伪调用，参数为目标地址 0x401000       │
└─────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│ 阶段2: Decoder::decode()                    │
│                                             │
│ getJumpTargetsFromInstruction():            │
│   │                                         │
│   ├── 是 _callFunction 调用? ──► 是         │
│   │                                         │
│   ├── 计算目标地址: 0x401000                  │
│   │   (通过 getJumpTarget() 解析操作数)     │
│   │                                         │
│   ├── getOrCreateCallTarget(0x401000):      │
│   │      ├── 查找现有函数? 否               │
│   │      ├── 拆分现有函数? 否               │
│   │      └── createFunction(0x401000)       │
│   │          返回: Function* @func_401000   │
│   │                                         │
│   ▼                                         │
│ transformToCall(pseudo, @func_401000):      │
│   ├── 创建: call @func_401000()             │
│   ├── 插入到伪调用之后                      │
│   └── 处理返回值到 EAX                      │
│                                             │
│ 结果:                                       │
│   call void @_callFunction(i32 4198400)     │
│   call void @func_401000()                  │
│   store i32 %retval, i32* @EAX              │
└─────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│ 阶段3: resolvePseudoCalls()                 │
│                                             │
│ 重新检查未解析的调用:                        │
│   - 如果目标仍未知，删除生成的真实调用      │
│   - 如果目标已确定，保持转换                │
└─────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│ 阶段4: finalizePseudoCalls()                │
│                                             │
│ 清理所有伪调用:                              │
│   1. 删除 call @_callFunction(...)          │
│   2. 删除栈操作指令 (ESP 更新)              │
│   3. 删除其他 setup 代码                    │
│                                             │
│ 最终 IR:                                    │
│   call void @func_401000()                  │
│   store i32 %retval, i32* @EAX              │
└─────────────────────────────────────────────┘
```

---

## 关键设计要点

### 1. 两阶段设计模式

| 阶段 | 职责 | 优势 |
|------|------|------|
| 阶段1（capstone2llvmir） | 生成统一格式的伪调用 | 架构无关、简化指令翻译 |
| 阶段2（Decoder） | 解析目标并转换 | 支持延迟绑定、前向引用 |

### 2. 延迟解析机制

- **初次解码**：能立即确定目标的调用直接转换
- **重新解析**：`resolvePseudoCalls()` 处理间接调用等复杂情况
- **最终清理**：`finalizePseudoCalls()` 确保删除所有伪调用

### 3. 架构特定的 ABI 处理

```cpp
// x86: EAX 用于返回值，栈保存返回地址
// MIPS: $v0 用于返回值，$ra 保存返回地址
// ARM: R0 用于返回值，LR 保存返回地址
```

### 4. 函数拆分策略

`splitFunctionOn()` 允许在调用目标处拆分现有函数，支持以下情况：
- 多个入口点的函数
- 被调用的中间代码位置
- 递归调用优化

### 5. 指令清理的精细控制

`finalizePseudoCalls()` 不仅删除伪调用，还清理：
- 返回地址存储指令（架构特定）
- 无用的类型转换
- 其他 setup 代码

### 6. 与 YARA 签名的集成

如果通过 YARA 签名识别了静态库函数：

```cpp
if (auto* detectedFnc = _config->getStaticallyLinkedFunction(addr)) {
    callee->setName(detectedFnc->getName());
    // 使用识别的函数名和参数信息
}
```

---

## 总结

RetDec 的伪调用转换机制是一个精心设计的**延迟绑定系统**，通过以下步骤实现可靠的函数调用反编译：

1. **生成阶段**：创建架构无关的伪调用占位符
2. **解析阶段**：在控制流分析后确定调用目标
3. **转换阶段**：生成符合 ABI 的真实函数调用
4. **清理阶段**：删除所有临时指令

这种设计使得 RetDec 能够正确处理：
- 直接调用和间接调用
- 前向引用（目标函数尚未解码）
- 函数指针和虚函数调用
- 复杂控制流（如 ARM 的 Thumb 模式切换）
