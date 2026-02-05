# RetDec 汇编指令到 LLVM IR 转换详解

## 概述

RetDec 使用 `capstone2llvmir` 库将二进制文件的汇编指令反编译为 LLVM IR。这个过程是反编译的核心步骤，将机器码转换为中间表示，以便后续进行控制流分析、数据流分析和高级语言生成。

## 核心架构

### 文件位置

```
src/capstone2llvmir/
├── capstone2llvmir.cpp          # 公共接口
├── capstone2llvmir_impl.cpp     # 通用实现
├── exceptions.cpp               # 异常处理
├── llvmir_utils.cpp             # LLVM IR 工具函数
├── x86/                         # x86/x64 架构支持
│   ├── x86.cpp                  # 转换函数实现
│   ├── x86_impl.h               # 类定义
│   └── x86_init.cpp             # 指令映射表
├── arm/                         # ARM 32位支持
├── arm64/                       # ARM 64位支持
├── mips/                        # MIPS 架构支持
└── powerpc/                     # PowerPC 架构支持
```

## 转换流程

```
┌─────────────────┐
│  二进制机器码    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Capstone 反汇编 │  ← 识别指令类型和操作数
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  查指令映射表    │  ← _i2fm 表
│  (x86_init.cpp) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  执行转换函数    │  ← 如 translateAdd()
│  (x86.cpp)      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   LLVM IR 输出   │
└─────────────────┘
```

## 指令映射表

### 位置

**文件**: `src/capstone2llvmir/x86/x86_init.cpp` (第 606 行起)

### 结构

```cpp
std::map<
    std::size_t,                                    // Capstone 指令 ID
    void (Capstone2LlvmIrTranslatorX86_impl::*)(    // 转换函数指针
        cs_insn* i,                                 // Capstone 指令结构
        cs_x86*,                                    // x86 特定信息
        llvm::IRBuilder<>&                          // LLVM IR 构建器
    )
> Capstone2LlvmIrTranslatorX86_impl::_i2fm
```

### 映射表示例

```cpp
{
    // 算术运算
    {X86_INS_ADD,   &Capstone2LlvmIrTranslatorX86_impl::translateAdd},
    {X86_INS_ADC,   &Capstone2LlvmIrTranslatorX86_impl::translateAdc},
    {X86_INS_SUB,   &Capstone2LlvmIrTranslatorX86_impl::translateSub},
    {X86_INS_MUL,   &Capstone2LlvmIrTranslatorX86_impl::translateMul},
    {X86_INS_IMUL,  &Capstone2LlvmIrTranslatorX86_impl::translateImul},
    {X86_INS_DIV,   &Capstone2LlvmIrTranslatorX86_impl::translateDiv},
    {X86_INS_IDIV,  &Capstone2LlvmIrTranslatorX86_impl::translateIdiv},
    {X86_INS_INC,   &Capstone2LlvmIrTranslatorX86_impl::translateInc},
    {X86_INS_DEC,   &Capstone2LlvmIrTranslatorX86_impl::translateDec},
    {X86_INS_NEG,   &Capstone2LlvmIrTranslatorX86_impl::translateNeg},
    
    // 逻辑运算
    {X86_INS_AND,   &Capstone2LlvmIrTranslatorX86_impl::translateAnd},
    {X86_INS_OR,    &Capstone2LlvmIrTranslatorX86_impl::translateOr},
    {X86_INS_XOR,   &Capstone2LlvmIrTranslatorX86_impl::translateXor},
    {X86_INS_NOT,   &Capstone2LlvmIrTranslatorX86_impl::translateNot},
    {X86_INS_TEST,  &Capstone2LlvmIrTranslatorX86_impl::translateAnd},
    
    // 移位运算
    {X86_INS_SHL,   &Capstone2LlvmIrTranslatorX86_impl::translateShiftLeft},
    {X86_INS_SHR,   &Capstone2LlvmIrTranslatorX86_impl::translateShiftRight},
    {X86_INS_SAL,   &Capstone2LlvmIrTranslatorX86_impl::translateShiftLeft},
    {X86_INS_SAR,   &Capstone2LlvmIrTranslatorX86_impl::translateShiftRight},
    {X86_INS_ROL,   &Capstone2LlvmIrTranslatorX86_impl::translateRol},
    {X86_INS_ROR,   &Capstone2LlvmIrTranslatorX86_impl::translateRor},
    {X86_INS_RCL,   &Capstone2LlvmIrTranslatorX86_impl::translateRcl},
    {X86_INS_RCR,   &Capstone2LlvmIrTranslatorX86_impl::translateRcr},
    
    // 数据传输
    {X86_INS_MOV,   &Capstone2LlvmIrTranslatorX86_impl::translateMov},
    {X86_INS_MOVZX, &Capstone2LlvmIrTranslatorX86_impl::translateMov},
    {X86_INS_MOVSX, &Capstone2LlvmIrTranslatorX86_impl::translateMov},
    {X86_INS_MOVSXD,&Capstone2LlvmIrTranslatorX86_impl::translateMov},
    {X86_INS_LEA,   &Capstone2LlvmIrTranslatorX86_impl::translateLea},
    {X86_INS_PUSH,  &Capstone2LlvmIrTranslatorX86_impl::translatePush},
    {X86_INS_POP,   &Capstone2LlvmIrTranslatorX86_impl::translatePop},
    
    // 控制流
    {X86_INS_JMP,   &Capstone2LlvmIrTranslatorX86_impl::translateJmp},
    {X86_INS_JE,    &Capstone2LlvmIrTranslatorX86_impl::translateJCc},
    {X86_INS_JNE,   &Capstone2LlvmIrTranslatorX86_impl::translateJCc},
    {X86_INS_JA,    &Capstone2LlvmIrTranslatorX86_impl::translateJCc},
    {X86_INS_JAE,   &Capstone2LlvmIrTranslatorX86_impl::translateJCc},
    {X86_INS_JB,    &Capstone2LlvmIrTranslatorX86_impl::translateJCc},
    {X86_INS_JBE,   &Capstone2LlvmIrTranslatorX86_impl::translateJCc},
    {X86_INS_JG,    &Capstone2LlvmIrTranslatorX86_impl::translateJCc},
    {X86_INS_JGE,   &Capstone2LlvmIrTranslatorX86_impl::translateJCc},
    {X86_INS_JL,    &Capstone2LlvmIrTranslatorX86_impl::translateJCc},
    {X86_INS_JLE,   &Capstone2LlvmIrTranslatorX86_impl::translateJCc},
    {X86_INS_CALL,  &Capstone2LlvmIrTranslatorX86_impl::translateCall},
    {X86_INS_RET,   &Capstone2LlvmIrTranslatorX86_impl::translateRet},
    
    // 条件传送
    {X86_INS_CMOVA, &Capstone2LlvmIrTranslatorX86_impl::translateCMovCc},
    {X86_INS_CMOVE, &Capstone2LlvmIrTranslatorX86_impl::translateCMovCc},
    {X86_INS_CMOVNE,&Capstone2LlvmIrTranslatorX86_impl::translateCMovCc},
    
    // 比较和设置
    {X86_INS_CMP,   &Capstone2LlvmIrTranslatorX86_impl::translateSub},
    {X86_INS_SETE,  &Capstone2LlvmIrTranslatorX86_impl::translateSetCc},
    {X86_INS_SETNE, &Capstone2LlvmIrTranslatorX86_impl::translateSetCc},
    
    // 字符串操作
    {X86_INS_MOVSB, &Capstone2LlvmIrTranslatorX86_impl::translateMoveString},
    {X86_INS_MOVSW, &Capstone2LlvmIrTranslatorX86_impl::translateMoveString},
    {X86_INS_MOVSD, &Capstone2LlvmIrTranslatorX86_impl::translateMoveString},
    {X86_INS_MOVSQ, &Capstone2LlvmIrTranslatorX86_impl::translateMoveString},
    {X86_INS_LODSB, &Capstone2LlvmIrTranslatorX86_impl::translateLoadString},
    {X86_INS_STOSB, &Capstone2LlvmIrTranslatorX86_impl::translateStoreString},
    
    // 位操作
    {X86_INS_BT,    &Capstone2LlvmIrTranslatorX86_impl::translateBt},
    {X86_INS_BTC,   &Capstone2LlvmIrTranslatorX86_impl::translateBtc},
    {X86_INS_BTR,   &Capstone2LlvmIrTranslatorX86_impl::translateBtr},
    {X86_INS_BTS,   &Capstone2LlvmIrTranslatorX86_impl::translateBts},
    {X86_INS_BSF,   &Capstone2LlvmIrTranslatorX86_impl::translateBsf},
    {X86_INS_BSR,   &Capstone2LlvmIrTranslatorX86_impl::translateBsf},
    {X86_INS_BSWAP, &Capstone2LlvmIrTranslatorX86_impl::translateBswap},
    
    // FPU 指令
    {X86_INS_FLD,   &Capstone2LlvmIrTranslatorX86_impl::translateFld},
    {X86_INS_FST,   &Capstone2LlvmIrTranslatorX86_impl::translateFst},
    {X86_INS_FSTP,  &Capstone2LlvmIrTranslatorX86_impl::translateFst},
    {X86_INS_FADD,  &Capstone2LlvmIrTranslatorX86_impl::translateFadd},
    {X86_INS_FSUB,  &Capstone2LlvmIrTranslatorX86_impl::translateFsub},
    {X86_INS_FMUL,  &Capstone2LlvmIrTranslatorX86_impl::translateFmul},
    {X86_INS_FDIV,  &Capstone2LlvmIrTranslatorX86_impl::translateFdiv},
    
    // 系统指令
    {X86_INS_CPUID, &Capstone2LlvmIrTranslatorX86_impl::translateCpuid},
    {X86_INS_RDTSC, &Capstone2LlvmIrTranslatorX86_impl::translateRdtsc},
    {X86_INS_NOP,   &Capstone2LlvmIrTranslatorX86_impl::translateNop},
    {X86_INS_UD2,   &Capstone2LlvmIrTranslatorX86_impl::translateNop},
}
```

### 未实现指令

映射表中 `nullptr` 表示该指令**尚未实现**：

```cpp
{X86_INS_VADDPD, nullptr},      // AVX 向量指令未实现
{X86_INS_AESENC, nullptr},      // AES 指令未实现
{X86_INS_MONITOR, nullptr},     // 监视指令未实现
```

未实现的指令会被降级为**伪汇编函数调用**。

## 转换函数实现

### 位置

**文件**: `src/capstone2llvmir/x86/x86.cpp`

### 典型转换函数示例

#### 1. ADD 指令转换

**x86 汇编:**
```asm
add eax, ebx
```

**转换函数:**
```cpp
void Capstone2LlvmIrTranslatorX86_impl::translateAdd(
    cs_insn* i,      // Capstone 指令信息
    cs_x86* xi,      // x86 特定详情
    llvm::IRBuilder<>& irb  // LLVM IR 构建器
) {
    // 1. 加载操作数
    std::vector<llvm::Value*> ops = loadOp(xi->operands, 2, irb);
    
    // 2. 生成加法 IR
    llvm::Value* result = irb.CreateAdd(ops[0], ops[1]);
    
    // 3. 存储结果到目的操作数
    storeOp(xi->operands[0], result, irb);
    
    // 4. 更新标志位
    storeRegisters(result, irb, {
        X86_REG_CF,   // 进位标志
        X86_REG_PF,   // 奇偶标志
        X86_REG_AF,   // 辅助进位
        X86_REG_ZF,   // 零标志
        X86_REG_SF,   // 符号标志
        X86_REG_OF    // 溢出标志
    });
}
```

**生成的 LLVM IR:**
```llvm
%eax.0 = add i32 %eax, %ebx
store i32 %eax.0, i32* @eax
```

#### 2. MOV 指令转换

**x86 汇编:**
```asm
mov eax, ebx
```

**转换函数:**
```cpp
void Capstone2LlvmIrTranslatorX86_impl::translateMov(
    cs_insn* i,
    cs_x86* xi,
    llvm::IRBuilder<>& irb
) {
    // 1. 加载源操作数
    llvm::Value* src = loadOp(xi->operands[1], irb);
    
    // 2. 直接存储到目的操作数
    // MOV 不修改标志位
    storeOp(xi->operands[0], src, irb);
}
```

**生成的 LLVM IR:**
```llvm
store i32 %ebx, i32* @eax
```

#### 3. JMP 指令转换

**x86 汇编:**
```asm
jmp 0x401000
```

**转换函数:**
```cpp
void Capstone2LlvmIrTranslatorX86_impl::translateJmp(
    cs_insn* i,
    cs_x86* xi,
    llvm::IRBuilder<>& irb
) {
    // 获取跳转目标
    llvm::Value* target = loadOp(xi->operands[0], irb);
    
    // 生成无条件分支
    irb.CreateBr(getBasicBlockAtAddress(target));
}
```

**生成的 LLVM IR:**
```llvm
br label %block_401000
```

#### 4. CALL 指令转换

**x86 汇编:**
```asm
call printf
```

**转换函数:**
```cpp
void Capstone2LlvmIrTranslatorX86_impl::translateCall(
    cs_insn* i,
    cs_x86* xi,
    llvm::IRBuilder<>& irb
) {
    // 1. 获取函数地址/符号
    llvm::Value* callee = loadOp(xi->operands[0], irb);
    
    // 2. 准备参数 (根据调用约定)
    std::vector<llvm::Value*> args = prepareCallArguments(irb);
    
    // 3. 生成函数调用 IR
    llvm::CallInst* call = irb.CreateCall(callee, args);
    
    // 4. 存储返回值 (如果有)
    storeRegister(X86_REG_EAX, call, irb);
}
```

**生成的 LLVM IR:**
```llvm
%eax = call i32 @printf(i8* %format, i32 %arg)
```

## 寄存器映射

### 虚拟寄存器创建

在 `x86.cpp` 中，所有 x86 寄存器都被映射为 LLVM 全局变量：

```cpp
void Capstone2LlvmIrTranslatorX86_impl::generateRegisters() {
    // 标志寄存器
    createRegister(X86_REG_CF, _regLt);   // 进位标志
    createRegister(X86_REG_PF, _regLt);   // 奇偶标志
    createRegister(X86_REG_ZF, _regLt);   // 零标志
    createRegister(X86_REG_SF, _regLt);   // 符号标志
    createRegister(X86_REG_OF, _regLt);   // 溢出标志
    
    // 通用寄存器 (32位模式示例)
    createRegister(X86_REG_EAX, i32);
    createRegister(X86_REG_EBX, i32);
    createRegister(X86_REG_ECX, i32);
    createRegister(X86_REG_EDX, i32);
    createRegister(X86_REG_ESI, i32);
    createRegister(X86_REG_EDI, i32);
    createRegister(X86_REG_EBP, i32);
    createRegister(X86_REG_ESP, i32);
    
    // 段寄存器
    createRegister(X86_REG_CS, i16);
    createRegister(X86_REG_DS, i16);
    createRegister(X86_REG_ES, i16);
    createRegister(X86_REG_FS, i16);
    createRegister(X86_REG_GS, i16);
    createRegister(X86_REG_SS, i16);
    
    // FPU 寄存器
    createRegister(X86_REG_ST0, fp80);
    // ... ST1-ST7
}
```

### 寄存器别名关系

子寄存器与父寄存器的关系在 `initializeRegistersParentMap()` 中定义：

```cpp
// 32位模式
{X86_REG_AH, X86_REG_AL, X86_REG_AX, X86_REG_EAX},
{X86_REG_CH, X86_REG_CL, X86_REG_CX, X86_REG_ECX},
// ...

// 64位模式
{X86_REG_AH, X86_REG_AL, X86_REG_AX, X86_REG_EAX, X86_REG_RAX},
{X86_REG_R8B, X86_REG_R8W, X86_REG_R8D, X86_REG_R8},
// ...
```

## 内存访问转换

### 寻址模式

x86 的复杂寻址模式被转换为 LLVM 的 `getelementptr` 指令：

**x86 汇编:**
```asm
mov eax, [ebx + ecx*4 + 8]
```

**生成的 LLVM IR:**
```llvm
%ptr = getelementptr i8, i8* %mem, i32 %ecx
%ptr_scaled = getelementptr i8, i8* %ptr, i32 %ecx
%ptr_offset = getelementptr i8, i8* %ptr_scaled, i32 8
%eax = load i32, i32* %ptr_offset
```

## 条件码处理

### EFLAGS 标志位

x86 的标志位被建模为独立的布尔变量：

```llvm
@cf = global i1 false  ; 进位标志
@pf = global i1 false  ; 奇偶标志
@zf = global i1 false  ; 零标志
@sf = global i1 false  ; 符号标志
@of = global i1 false  ; 溢出标志
```

### 条件跳转

条件跳转通过比较指令和分支指令实现：

**x86 汇编:**
```asm
cmp eax, ebx
je label_equal
```

**生成的 LLVM IR:**
```llvm
%cmp = icmp eq i32 %eax, %ebx
store i1 %cmp, i1* @zf
br i1 %cmp, label %label_equal, label %fallthrough
```

## 特殊指令处理

### 1. 字符串指令

`REP MOVSB` 等字符串指令被转换为循环结构：

```llvm
loop_header:
    %ecx_val = load i32, i32* @ecx
    %cond = icmp eq i32 %ecx_val, 0
    br i1 %cond, label %loop_end, label %loop_body

loop_body:
    ; 移动一个字节
    %src = load i8, i8* %esi
    store i8 %src, i8* %edi
    ; 更新指针和计数器
    br label %loop_header

loop_end:
```

### 2. FPU 指令

FPU 指令使用特殊的模拟函数：

```llvm
%x87_result = call x86_fp80 @__x87_fadd(x86_fp80 %st0, x86_fp80 %st1)
```

### 3. 系统指令

`CPUID`、`RDTSC` 等系统指令生成外部函数调用：

```llvm
%cpuid_result = call { i32, i32, i32, i32 } @__cpuid(i32 %eax)
```

## 扩展指令集支持状态

| 指令集 | 支持程度 | 说明 |
|--------|---------|------|
| x86 基础指令 | ✅ 完整 | 所有通用指令 |
| x87 FPU | ⚠️ 部分 | 基本运算支持 |
| MMX | ⚠️ 部分 | 部分指令实现 |
| SSE/SSE2 | ⚠️ 部分 | 部分指令实现 |
| AVX/AVX2 | ❌ 不支持 | 映射为 `nullptr` |
| AES-NI | ❌ 不支持 | 映射为 `nullptr` |
| BMI/BMI2 | ❌ 不支持 | 映射为 `nullptr` |

## 添加新指令支持

如需添加新指令支持，需要修改以下文件：

1. **`x86_init.cpp`**: 在 `_i2fm` 映射表中添加条目
2. **`x86_impl.h`**: 声明新的转换函数
3. **`x86.cpp`**: 实现转换函数

### 示例：添加新指令

```cpp
// 1. x86_init.cpp
{X86_INS_NEWINS, &Capstone2LlvmIrTranslatorX86_impl::translateNewins},

// 2. x86_impl.h
void translateNewins(cs_insn* i, cs_x86* xi, llvm::IRBuilder<>& irb);

// 3. x86.cpp
void Capstone2LlvmIrTranslatorX86_impl::translateNewins(
    cs_insn* i,
    cs_x86* xi,
    llvm::IRBuilder<>& irb
) {
    // 实现转换逻辑
    llvm::Value* op = loadOp(xi->operands[0], irb);
    // ... 生成 IR
}
```

## 参考文档

- [Capstone 文档](https://www.capstone-engine.org/documentation.html)
- [LLVM IR 参考](https://llvm.org/docs/LangRef.html)
- RetDec 源码: `src/capstone2llvmir/`
