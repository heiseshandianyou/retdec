# RetDec x86 代码建模详解

本文档详细描述 RetDec 如何将 x86 汇编代码建模为 LLVM IR，特别关注数据流分析的建模细节。

## 1. 整体架构

```
┌─────────────────────────────────────────────────────────────────┐
│                         x86 汇编代码                              │
└──────────────────────┬──────────────────────────────────────────┘
                       │ Capstone 反汇编
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Capstone 中间表示                            │
│  - 指令 ID (cs_insn.id)                                          │
│  - 操作数数组 (cs_x86.operands[])                                │
│  - 隐式读写寄存器 (regs_read/regs_write)                         │
└──────────────────────┬──────────────────────────────────────────┘
                       │ RetDec 转换
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                         LLVM IR 建模                              │
│  - 寄存器 → 全局变量 (@eax, @ebx, @eflags)                        │
│  - 内存 → 全局变量 @mem + getelementptr                           │
│  - 指令 → LLVM IR 指令序列                                        │
│  - 控制流 → 伪函数调用 + BranchInst                               │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. 寄存器建模

### 2.1 寄存器作为全局变量

每个 x86 寄存器被建模为 LLVM 全局变量：

```llvm
; 通用寄存器 (32位模式示例)
@eax = global i32 0, align 4
@ebx = global i32 0, align 4
@ecx = global i32 0, align 4
@edx = global i32 0, align 4
@esi = global i32 0, align 4
@edi = global i32 0, align 4
@ebp = global i32 0, align 4
@esp = global i32 0, align 4

; 标志寄存器 (独立建模为布尔值)
@cf = global i1 false  ; 进位标志
@pf = global i1 false  ; 奇偶标志
@af = global i1 false  ; 辅助进位
@zf = global i1 false  ; 零标志
@sf = global i1 false  ; 符号标志
@of = global i1 false  ; 溢出标志
@df = global i1 false  ; 方向标志
@if = global i1 false  ; 中断使能

; 段寄存器
@cs = global i16 0
@ds = global i16 0
@es = global i16 0
@fs = global i16 0
@gs = global i16 0
@ss = global i16 0

; FPU 寄存器 (80位浮点)
@st0 = global x86_fp80 0xK00000000000000000000
@st1 = global x86_fp80 0xK00000000000000000000
; ... st2-st7

; XMM 寄存器 (128位向量)
@xmm0 = global i128 0
@xmm1 = global i128 0
; ... xmm2-xmm15
```

### 2.2 寄存器别名处理

x86 寄存器存在重叠关系（如 AL/AH/AX/EAX/RAX）。RetDec 通过 **父寄存器映射** 处理：

```cpp
// src/capstone2llvmir/x86/x86.cpp:661
// 32位模式下的寄存器层级
{X86_REG_AH, X86_REG_AL, X86_REG_AX, X86_REG_EAX},
{X86_REG_CH, X86_REG_CL, X86_REG_CX, X86_REG_ECX},
{X86_REG_DH, X86_REG_DL, X86_REG_DX, X86_REG_EDX},
{X86_REG_BH, X86_REG_BL, X86_REG_BX, X86_REG_EBX},
{X86_REG_SPL, X86_REG_SP, X86_REG_ESP},
// ...

// 64位模式下的扩展
{X86_REG_SPL, X86_REG_SP, X86_REG_ESP, X86_REG_RSP},
{X86_REG_R8B, X86_REG_R8W, X86_REG_R8D, X86_REG_R8},
// ...
```

**访问子寄存器的处理：**

```asm
; x86 汇编
mov al, bl
```

```llvm
; LLVM IR 建模
%ebx_val = load i32, i32* @ebx
%bl_val = trunc i32 %ebx_val to i8          ; 提取低8位
%eax_val = load i32, i32* @eax
%eax_new = and i32 %eax_val, 0xFFFFFF00     ; 清除 AL 位
%bl_ext = zext i8 %bl_val to i32
%eax_final = or i32 %eax_new, %bl_ext       ; 合并
store i32 %eax_final, i32* @eax
```

> 📍 **代码位置**: `src/capstone2llvmir/x86/x86.cpp:661` - `loadRegister()` 函数

### 2.3 寄存器访问接口

**loadRegister()** - 读取寄存器值：
```cpp
// src/capstone2llvmir/x86/x86.cpp:661
llvm::Value* loadRegister(uint32_t r, IRBuilder<>& irb, Type* dstType);

// 示例: loadRegister(X86_REG_EAX, irb)
// 生成: %val = load i32, i32* @eax
```

**storeRegister()** - 写入寄存器值：
```cpp
// src/capstone2llvmir/x86/x86.cpp:713
StoreInst* storeRegister(uint32_t r, Value* val, IRBuilder<>& irb);

// 示例: storeRegister(X86_REG_EAX, newVal, irb)
// 生成: store i32 %newVal, i32* @eax
```

---

## 3. 内存建模

### 3.1 全局内存空间

x86 内存被建模为单一全局字节数组：

```llvm
@mem = global [4294967296 x i8] zeroinitializer  ; 4GB 地址空间
```

**内存访问转换：**

```asm
; x86 汇编
mov eax, [0x1000]      ; 从地址 0x1000 读取 32 位
```

```llvm
; LLVM IR
%addr = getelementptr [4294967296 x i8], [4294967296 x i8]* @mem, i64 0, i64 4096
%ptr = bitcast i8* %addr to i32*
%eax = load i32, i32* %ptr
store i32 %eax, i32* @eax
```

> 📍 **代码位置**: `src/capstone2llvmir/x86/x86.cpp:958` - `loadOp()` 函数 (X86_OP_MEM 分支)

### 3.2 复杂寻址模式

x86 支持复杂寻址：`[base + index*scale + disp]`

```asm
mov eax, [ebx + ecx*4 + 8]
```

```llvm
; LLVM IR 生成过程
%ebx_val = load i32, i32* @ebx
%ecx_val = load i32, i32* @ecx
%scale = mul i32 %ecx_val, 4           ; index * scale
%base_index = add i32 %ebx_val, %scale ; base + index*scale
%final_addr = add i32 %base_index, 8   ; + displacement

; 符号扩展到 64 位用于 GEP
%addr_64 = zext i32 %final_addr to i64
%mem_ptr = getelementptr [4294967296 x i8], [4294967296 x i8]* @mem, i64 0, i64 %addr_64
%val_ptr = bitcast i8* %mem_ptr to i32*
%val = load i32, i32* %val_ptr
store i32 %val, i32* @eax
```

> 📍 **代码位置**: `src/capstone2llvmir/x86/x86.cpp:978-995` - loadOp() 中 mem.base/mem.index 处理

### 3.3 段地址空间（x86 特殊）

不同段寄存器使用不同的地址空间：

```llvm
; 默认数据段 (@ds)
@mem_ds = global [4294967296 x i8] ...

; 栈段 (@ss) - 用于 ESP/EBP 相关的内存访问
@mem_ss = global [4294967296 x i8] ...

; FS/GS 段（Windows/Linux TLS）
@mem_fs = global [4294967296 x i8] ...
@mem_gs = global [4294967296 x i8] ...
```

**段覆盖前缀处理：**
```asm
mov eax, fs:[0x30]     ; 访问 FS 段的 TLS 数据
```

```llvm
%addr = getelementptr [4294967296 x i8], [4294967296 x i8]* @mem_fs, i64 0, i64 48
%ptr = bitcast i8* %addr to i32*
%val = load i32, i32* %ptr
```

### 3.4 内存访问粒度

| x86 指令 | LLVM IR 操作 |
|----------|--------------|
| `mov al, [addr]` | `load i8` |
| `mov ax, [addr]` | `load i16` |
| `mov eax, [addr]` | `load i32` |
| `mov rax, [addr]` | `load i64` |
| `movups xmm0, [addr]` | `load i128` |

---

## 4. 标志位建模

### 4.1 EFLAGS 分解

x86 的 EFLAGS 寄存器被分解为独立的全局布尔变量：

```llvm
; 算术标志
@cf = global i1 false   ; Carry Flag (进位)
@pf = global i1 false   ; Parity Flag (奇偶)
@af = global i1 false   ; Auxiliary Carry (辅助进位)
@zf = global i1 false   ; Zero Flag (零)
@sf = global i1 false   ; Sign Flag (符号)
@of = global i1 false   ; Overflow Flag (溢出)

; 控制标志
@df = global i1 false   ; Direction Flag (方向)
@if = global i1 false   ; Interrupt Enable (中断使能)

; 系统标志
@tf = global i1 false   ; Trap Flag (陷阱)
@nt = global i1 false   ; Nested Task (嵌套任务)
@rf = global i1 false   ; Resume Flag (恢复)
@vm = global i1 false   ; Virtual 8086 Mode
@ac = global i1 false   ; Alignment Check (对齐检查)
@vif = global i1 false  ; Virtual Interrupt
@vip = global i1 false  ; Virtual Interrupt Pending
@id = global i1 false   ; ID Flag
```

### 4.2 标志位计算函数

**零标志 (ZF) 生成：**
```cpp
// src/capstone2llvmir/x86/x86.cpp:1312
Value* generateZeroFlag(Value* val, IRBuilder<>& irb) {
    // ZF = (val == 0)
    return irb.CreateICmpEQ(val, ConstantInt::get(val->getType(), 0));
}
```

**符号标志 (SF) 生成：**
```cpp
// src/capstone2llvmir/x86/x86.cpp:1320
Value* generateSignFlag(Value* val, IRBuilder<>& irb) {
    // SF = val的最高位
    unsigned bitWidth = val->getType()->getIntegerBitWidth();
    return irb.CreateTrunc(
        irb.CreateLShr(val, bitWidth - 1),
        Type::getInt1Ty(irb.getContext())
    );
}
```

**奇偶标志 (PF) 生成：**
```cpp
// src/capstone2llvmir/x86/x86.cpp:1335
Value* generateParityFlag(Value* val, IRBuilder<>& irb) {
    // PF = 低8位中1的个数为偶数
    Value* low8 = irb.CreateTrunc(val, Type::getInt8Ty(irb.getContext()));
    // 使用查找表或位运算计算奇偶性
    // ... 实现细节省略
}
```

### 4.3 标志位更新模式

```asm
add eax, ebx
```

```llvm
; 执行加法
%eax_old = load i32, i32* @eax
%ebx_val = load i32, i32* @ebx
%result = add i32 %eax_old, %ebx_val
store i32 %result, i32* @eax

; 更新所有标志位
%zf = icmp eq i32 %result, 0
store i1 %zf, i1* @zf

%sf = lshr i32 %result, 31
%sf_trunc = trunc i32 %sf to i1
store i1 %sf_trunc, i1* @sf

; CF: 无符号溢出检测
%cf = icmp ult i32 %result, %eax_old
store i1 %cf, i1* @cf

; OF: 有符号溢出检测
%of_xor1 = xor i32 %eax_old, %ebx_val
%of_xor2 = xor i32 %eax_old, %result
%of_and = and i32 %of_xor1, %of_xor2
%of = icmp slt i32 %of_and, 0
store i1 %of, i1* @of
```

> 📍 **代码位置**: `src/capstone2llvmir/x86/x86.cpp:1729` - `translateAdd()` 函数

---

## 5. 操作数类型处理

### 5.1 操作数分类

```cpp
// Capstone 定义的操作数类型
enum x86_op_type {
    X86_OP_INVALID = 0,    // 无效操作数
    X86_OP_REG,            // 寄存器
    X86_OP_IMM,            // 立即数
    X86_OP_MEM,            // 内存引用
};
```

### 5.2 loadOp() 函数

`loadOp()` 是数据流分析的核心入口，根据操作数类型分发处理：

```cpp
// src/capstone2llvmir/x86/x86.cpp:958
llvm::Value* loadOp(cs_x86_op& op, IRBuilder<>& irb, Type* ty, bool lea) {
    switch (op.type) {
        case X86_OP_REG:
            return loadRegister(op.reg, irb, ty);
            
        case X86_OP_IMM:
            return ConstantInt::get(ty ? ty : defaultType, op.imm);
            
        case X86_OP_MEM:
            if (lea) {
                // LEA 指令：只计算地址，不访问内存
                return calculateAddress(op.mem, irb);  // 隐式在 loadOp 中实现
            } else {
                // 普通内存访问
                Value* addr = calculateAddress(op.mem, irb);
                return loadMemory(addr, ty, irb);  // 隐式在 loadOp 中实现
            }
            
        default:
            throw GenericError("Invalid operand type");
    }
}
```

### 5.3 storeOp() 函数

```cpp
// src/capstone2llvmir/x86/x86.cpp:1046
Instruction* storeOp(cs_x86_op& op, Value* val, IRBuilder<>& irb) {
    switch (op.type) {
        case X86_OP_REG:
            return storeRegister(op.reg, val, irb);
            
        case X86_OP_MEM:
            Value* addr = calculateAddress(op.mem, irb);
            return storeMemory(addr, val, irb);
            
        default:
            throw GenericError("Cannot store to immediate");
    }
}
```

---

## 6. 数据流相关指令转换

### 6.1 数据传输指令

#### MOV (最基本的数据流)
```asm
mov eax, ebx
```

```llvm
%ebx_val = load i32, i32* @ebx
store i32 %ebx_val, i32* @eax
; 注意：MOV 不修改标志位
```

> 📍 **代码位置**: `src/capstone2llvmir/x86/x86.cpp:2520` - `translateMov()` 函数

#### MOVSX/MOVZX (带符号/零扩展)
```asm
movsx eax, bl   ; 8位到32位符号扩展
movzx eax, bl   ; 8位到32位零扩展
```

```llvm
; MOVSX
%bl_val = load i8, i8* @bl
%bl_ext = sext i8 %bl_val to i32
store i32 %bl_ext, i32* @eax

; MOVZX
%bl_val = load i8, i8* @bl
%bl_ext = zext i8 %bl_val to i32
store i32 %bl_ext, i32* @eax
```

> 📍 **代码位置**: `src/capstone2llvmir/x86/x86.cpp:2520` - `translateMov()` 函数 (MOVSX/MOVZX 分支)

#### XCHG (交换)
```asm
xchg eax, ebx
```

```llvm
%eax_val = load i32, i32* @eax
%ebx_val = load i32, i32* @ebx
store i32 %ebx_val, i32* @eax
store i32 %eax_val, i32* @ebx
```

> 📍 **代码位置**: `src/capstone2llvmir/x86/x86.cpp:2520` - `translateMov()` 函数 (XCHG 分支)

### 6.2 栈操作指令（数据流关键点）

#### PUSH
```asm
push eax
```

```llvm
; 1. 减小栈指针
%esp_old = load i32, i32* @esp
%esp_new = sub i32 %esp_old, 4
store i32 %esp_new, i32* @esp

; 2. 存储数据到栈顶
%addr = getelementptr [4294967296 x i8], [4294967296 x i8]* @mem_ss, i64 0, i64 %esp_new
%ptr = bitcast i8* %addr to i32*
%eax_val = load i32, i32* @eax
store i32 %eax_val, i32* %ptr
```

> 📍 **代码位置**: `src/capstone2llvmir/x86/x86.cpp:2891` - `translatePush()` 函数

#### POP
```asm
pop eax
```

```llvm
; 1. 从栈顶读取数据
%esp_old = load i32, i32* @esp
%addr = getelementptr [4294967296 x i8], [4294967296 x i8]* @mem_ss, i64 0, i64 %esp_old
%ptr = bitcast i8* %addr to i32*
%val = load i32, i32* %ptr
store i32 %val, i32* @eax

; 2. 增加栈指针
%esp_new = add i32 %esp_old, 4
store i32 %esp_new, i32* @esp
```

> 📍 **代码位置**: `src/capstone2llvmir/x86/x86.cpp:2746` - `translatePop()` 函数

#### LEA (加载有效地址)
```asm
lea eax, [ebx + ecx*4 + 8]
```

```llvm
; 只计算地址，不访问内存
%ebx_val = load i32, i32* @ebx
%ecx_val = load i32, i32* @ecx
%scaled = mul i32 %ecx_val, 4
%sum = add i32 %ebx_val, %scaled
%final = add i32 %sum, 8
store i32 %final, i32* @eax
```

> 📍 **代码位置**: `src/capstone2llvmir/x86/x86.cpp:2419` - `translateLea()` 函数

### 6.3 函数调用/返回（控制流与数据流交汇）

#### CALL
```asm
call 0x401000
```

```llvm
; 1. 保存返回地址到栈
%esp_old = load i32, i32* @esp
%esp_new = sub i32 %esp_old, 4
store i32 %esp_new, i32* @esp
%ret_addr = <next_instruction_address>
%addr = getelementptr [4294967296 x i8], [4294967296 x i8]* @mem_ss, i64 0, i64 %esp_new
%ptr = bitcast i8* %addr to i32*
store i32 %ret_addr, i32* %ptr

; 2. 生成伪调用函数（用于控制流分析）
call void @__x86_call(i32 4198400)  ; 0x401000

; 3. 跳转到目标（实际会被优化为调用）
br label %block_401000
```

> 📍 **代码位置**: `src/capstone2llvmir/x86/x86.cpp:2334` - `translateCall()` 函数

#### RET
```asm
ret
```

```llvm
; 1. 从栈顶读取返回地址
%esp_old = load i32, i32* @esp
%addr = getelementptr [4294967296 x i8], [4294967296 x i8]* @mem_ss, i64 0, i64 %esp_old
%ptr = bitcast i8* %addr to i32*
%ret_addr = load i32, i32* %ptr

; 2. 恢复栈指针
%esp_new = add i32 %esp_old, 4
store i32 %esp_new, i32* @esp

; 3. 生成伪返回函数调用
call void @__x86_return(i32 %ret_addr)

; 4. 间接跳转
br label %unknown_return_target  ; 实际会被分析器重定向
```

> 📍 **代码位置**: `src/capstone2llvmir/x86/x86.cpp:3030` - `translateRet()` 函数

### 6.4 字符串操作指令（循环数据流）

#### MOVSB (移动字符串字节)
```asm
rep movsb   ; 重复移动字节，直到 ECX = 0
```

```llvm
; 循环头部
br label %loop_header

loop_header:
    %ecx = load i32, i32* @ecx
    %cond = icmp eq i32 %ecx, 0
    br i1 %cond, label %loop_end, label %loop_body

loop_body:
    ; 1. 从源地址读取 (ESI)
    %esi = load i32, i32* @esi
    %src_addr = getelementptr [4294967296 x i8], [4294967296 x i8]* @mem, i64 0, i64 %esi
    %byte = load i8, i8* %src_addr
    
    ; 2. 写入目标地址 (EDI)
    %edi = load i32, i32* @edi
    %dst_addr = getelementptr [4294967296 x i8], [4294967296 x i8]* @mem_es, i64 0, i64 %edi
    store i8 %byte, i8* %dst_addr
    
    ; 3. 更新指针 (根据 DF 标志决定方向)
    %df = load i1, i1* @df
    %esi_new = select i1 %df, 
               i32 (sub i32 %esi, 1),   ; DF=1: 递减
               i32 (add i32 %esi, 1)    ; DF=0: 递增
    %edi_new = select i1 %df,
               i32 (sub i32 %edi, 1),
               i32 (add i32 %edi, 1)
    store i32 %esi_new, i32* @esi
    store i32 %edi_new, i32* @edi
    
    ; 4. 递减计数器
    %ecx_new = sub i32 %ecx, 1
    store i32 %ecx_new, i32* @ecx
    
    br label %loop_header

loop_end:
```

> 📍 **代码位置**: `src/capstone2llvmir/x86/x86.cpp:3755` - `translateMoveString()` 函数

---

## 7. 控制流建模（伪函数调用）

### 7.1 为什么使用伪函数

RetDec 使用 **伪函数调用** 来标记控制流转移，便于后续分析：

| 伪函数 | 用途 | 参数 |
|--------|------|------|
| `@__x86_call` | 函数调用 | 目标地址 |
| `@__x86_return` | 函数返回 | 返回地址（通常未知） |
| `@__x86_branch` | 无条件跳转 | 目标地址 |
| `@__x86_cond_branch` | 条件跳转 | 目标地址 |

### 7.2 条件分支建模

```asm
jz label_zero    ; 如果 ZF=1 则跳转
```

```llvm
; 1. 加载条件标志
%zf = load i1, i1* @zf

; 2. 生成条件分支伪调用
br i1 %zf, label %if_then, label %if_else

if_then:
    call void @__x86_cond_branch(i32 <label_zero_addr>)
    br label %label_zero

if_else:
    br label %fall_through

fall_through:
```

> 📍 **代码位置**: 条件分支在 `src/capstone2llvmir/x86/x86.cpp` 各条件跳转指令翻译函数中处理

---

## 8. 数据流分析建议

### 8.1 关键数据流模式

| 模式 | LLVM IR 特征 | 分析要点 |
|------|-------------|----------|
| 寄存器传播 | `load` → `store` | 追踪 @reg 全局变量 |
| 内存传播 | `gep` → `load`/`store` | 分析地址计算表达式 |
| 常量传播 | `store i32 42` | 直接提取常量值 |
| 栈帧访问 | `@mem_ss` + `@ebp`/`@esp` | 识别局部变量偏移 |
| 函数参数 | `@mem_ss` + 偏移 | 分析 CALL 前的 PUSH |
| 返回值 | `@eax` 在 RET 前 | 追踪 EAX 的最后赋值 |

### 8.2 别名分析考虑

**寄存器别名：**
- 写入 `@eax` 会影响 `@ax`, `@ah`, `@al`
- 需要维护寄存器重叠关系图
- 📍 **代码位置**: `src/capstone2llvmir/x86/x86.cpp:661` - `loadRegister()` 处理子寄存器

**内存别名：**
- 不同的地址计算可能指向同一位置
- 示例：`[ebp-4]` 和 `[esp+8]` 可能相同（取决于栈布局）

**段别名：**
- 某些架构中 DS 和 SS 可能重叠
- 需要段寄存器值分析

### 8.3 有用的 LLVM Pass

```cpp
// 1. 内存 SSA 构建
// 将内存操作转换为 SSA 形式，便于数据流分析

// 2. 全局值编号 (GVN)
// 识别相同计算，消除冗余

// 3. 死存储消除 (DSE)
// 移除不可见的内存写入

// 4. 循环信息
// 识别字符串操作等循环模式
```

---

## 9. 建模限制与注意事项

### 9.1 当前限制

| 限制 | 说明 | 影响 |
|------|------|------|
| 自修改代码 | 假设代码段只读 | 可能分析错误 |
| 内存别名 | 保守假设 | 可能过度近似 |
| 浮点精度 | x87 使用 80 位扩展精度 | 可能与硬件行为有差异 |
| 未定义行为 | 有符号溢出等 | 未完全建模 |

### 9.2 数据流分析时的注意事项

1. **标志位延迟**：某些指令（如 MOV）不修改标志位，需要追踪最后修改标志的指令

2. **隐式寄存器修改**：
   - CALL 修改 `@esp`（压入返回地址）
   - MUL 修改 `@edx:@eax`（64位结果）
   - DIV 使用 `@edx:@eax` 作为被除数

3. **内存顺序**：LLVM IR 的内存模型与 x86 的强内存模型不同，需要注意排序

4. **FPU 栈**：x87 FPU 使用栈结构（ST0-ST7），需要特殊处理

---

## 10. 核心函数速查表

| 函数 | 文件 | 行号 | 用途 |
|------|------|------|------|
| `loadRegister()` | x86.cpp | 661 | 读取寄存器值 |
| `storeRegister()` | x86.cpp | 713 | 写入寄存器值 |
| `loadOp()` | x86.cpp | 958 | 加载操作数（寄存器/立即数/内存） |
| `storeOp()` | x86.cpp | 1046 | 存储操作数到寄存器/内存 |
| `generateZeroFlag()` | x86.cpp | 1312 | 生成零标志位 |
| `generateSignFlag()` | x86.cpp | 1320 | 生成符号标志位 |
| `generateParityFlag()` | x86.cpp | 1335 | 生成奇偶标志位 |
| `translateAdd()` | x86.cpp | 1729 | ADD/ADC/SUB 等指令翻译 |
| `translateCall()` | x86.cpp | 2334 | CALL 指令翻译 |
| `translateLea()` | x86.cpp | 2419 | LEA 指令翻译 |
| `translateMov()` | x86.cpp | 2520 | MOV/MOVSX/MOVZX/XCHG 翻译 |
| `translatePop()` | x86.cpp | 2746 | POP 指令翻译 |
| `translatePush()` | x86.cpp | 2891 | PUSH 指令翻译 |
| `translateRet()` | x86.cpp | 3030 | RET 指令翻译 |
| `translateMoveString()` | x86.cpp | 3755 | MOVS/STOS/LODS 字符串指令翻译 |

---

## 11. 参考

- [RetDec 源码](https://github.com/avast/retdec/tree/master/src/capstone2llvmir/x86)
  - 核心实现: `src/capstone2llvmir/x86/x86.cpp`
  - 指令映射: `src/capstone2llvmir/x86/x86_init.cpp`
  - 头文件: `src/capstone2llvmir/x86/x86_impl.h`
- [Capstone x86 文档](https://www.capstone-engine.org/op_x86.html)
- [Intel 64 and IA-32 Architectures Software Developer's Manual](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)
- [LLVM Language Reference](https://llvm.org/docs/LangRef.html)
