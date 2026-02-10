# RetDec Decoder 层 GEP (getelementptr) 指令生成分析

## 核心结论

**`src/capstone2llvmir/`（汇编 → LLVM IR 的 decoder 层）不产生 GEP (getelementptr) 指令。**

GEP 指令的处理在独立的后续模块中：
- `src/llvmir-emul/` - LLVM IR 模拟器（执行 GEP）
- `src/llvmir2hll/` - LLVM IR 到高级语言转换（解释 GEP）

---

## 架构层级关系

```
┌─────────────────────────────────────────────────────────────────┐
│  层级                    │ 目录                         │ GEP  │
├─────────────────────────────────────────────────────────────────┤
│  汇编 → LLVM IR (decoder) │ src/capstone2llvmir/         │ ❌  │
│  IR 优化                 │ src/bin2llvmir/optimizations/ │ ❌  │
│  IR 模拟执行             │ src/llvmir-emul/             │ 执行 │
│  IR → 高级语言           │ src/llvmir2hll/              │ 转换 │
└─────────────────────────────────────────────────────────────────┘
```

---

## capstone2llvmir 层内存访问实现

### 核心机制

`src/capstone2llvmir/` 处理内存访问时，使用以下 LLVM IR 指令组合：

1. **地址计算**: 使用 `CreateAdd`, `CreateMul` 等算术指令
2. **指针转换**: 使用 `CreateIntToPtr` 将整数地址转换为指针
3. **内存访问**: 使用 `CreateLoad` / `CreateStore` 进行读写

### 示例：x86 内存操作数处理

位于 `src/capstone2llvmir/x86/x86.cpp` 的 `loadOp()` 和 `storeOp()` 方法（第958-1121行）：

```cpp
// 地址计算模式: base + index * scale + displacement
auto* baseR = loadRegister(op.mem.base, irb);
auto* idxR = loadRegister(op.mem.index, irb);
if (idxR) {
    auto* scale = llvm::ConstantInt::get(idxR->getType(), op.mem.scale);
    idxR = irb.CreateMul(idxR, scale);
}

// 地址累加
llvm::Value* addr = nullptr;
if (baseR && disp == nullptr) addr = baseR;
else if (disp && baseR == nullptr) addr = disp;
else if (baseR && disp) {
    disp = irb.CreateSExtOrTrunc(disp, baseR->getType());
    addr = irb.CreateAdd(baseR, disp);
}
if (idxR && addr != idxR) {
    addr = irb.CreateAdd(addr, idxR);
}

// ❌ 不使用 GEP！使用 inttoptr + load/store
auto* pt = llvm::PointerType::get(t, getAddrSpace(op.mem.segment));
addr = irb.CreateIntToPtr(addr, pt);
return irb.CreateLoad(addr);
```

---

## 各架构产生内存访问的汇编指令

### x86/x86-64 架构 (`src/capstone2llvmir/x86/`)

**数据移动指令：**
| 指令 | 描述 |
|------|------|
| `MOV` | 内存读写 (mov eax, [ebx]; mov [ebx], eax) |
| `LEA` | 加载有效地址 (lea eax, [ebx+4]) |
| `PUSH`/`POP` | 栈操作 |
| `XCHG` | 交换指令 |

**字符串/内存操作指令：**
| 指令 | 描述 |
|------|------|
| `MOVS`/`MOVSB`/`MOVSW`/`MOVSD`/`MOVSQ` | 字符串移动 |
| `STOS`/`STOSB`/`STOSW`/`STOSD`/`STOSQ` | 存储字符串 |
| `LODS`/`LODSB`/`LODSW`/`LODSD`/`LODSQ` | 加载字符串 |
| `SCAS`/`CMPS` | 字符串比较/扫描 |

**FPU 指令：**
- `FLD`/`FST`/`FSTP` - 浮点加载/存储
- `FILD`/`FIST` - 整数加载/存储

**SSE/AVX 指令：**
- `MOVSS`/`MOVSD`/`MOVAPS`/`MOVUPS` 等 - 向量加载/存储

**访问模式示例：**
```asm
[base]                         ; 基址寻址
[base + disp]                  ; 基址+位移
[base + index*scale]           ; 基址+索引*比例
[base + index*scale + disp]    ; 完整寻址模式
[rip + disp]                   ; RIP相对寻址 (x64)
[fs:disp] / [gs:disp]          ; 段寄存器寻址
```

### ARM/ARM64 架构 (`src/capstone2llvmir/arm/`)

**加载/存储指令：**
| 指令 | 描述 |
|------|------|
| `LDR`/`STR` | 字加载/存储 |
| `LDRB`/`STRB` | 字节加载/存储 |
| `LDRH`/`STRH` | 半字加载/存储 |
| `LDRD`/`STRD` | 双字加载/存储 |
| `LDM`/`STM` | 多寄存器加载/存储 |
| `PUSH`/`POP` | 栈操作 |

**寻址模式：**
```asm
[Rn]                      ; 寄存器间接
[Rn, #offset]             ; 立即数偏移
[Rn, Rm]                  ; 寄存器偏移
[Rn, Rm, LSL #n]          ; 移位寄存器偏移
[Rn, #offset]!            ; 预变基
[Rn], #offset             ; 后变基
```

### MIPS 架构 (`src/capstone2llvmir/mips/`)

**加载指令：**
| 指令 | 描述 |
|------|------|
| `LB`/`LBU` | 加载字节（有符号/无符号）|
| `LH`/`LHU` | 加载半字 |
| `LW`/`LWU` | 加载字 |
| `LD` | 加载双字 |
| `LWC1`/`LDC1` | 加载浮点数到协处理器 |

**存储指令：**
| 指令 | 描述 |
|------|------|
| `SB` | 存储字节 |
| `SH` | 存储半字 |
| `SW` | 存储字 |
| `SD` | 存储双字 |
| `SWC1`/`SDC1` | 从协处理器存储浮点数 |

**寻址模式：**
```asm
offset(base)              ; 基址+偏移量 (16位有符号立即数)
```

### PowerPC 架构 (`src/capstone2llvmir/powerpc/`)

**加载指令：**
- `lbz`/`lbzu` - 加载字节并置零
- `lhz`/`lhzu` - 加载半字并置零
- `lwz`/`lwzu` - 加载字并置零
- `ld`/`ldu` - 加载双字
- `lfs`/`lfd` - 加载浮点单/双精度

**存储指令：**
- `stb`/`stbu` - 存储字节
- `sth`/`sthu` - 存储半字
- `stw`/`stwu` - 存储字
- `std`/`stdu` - 存储双字
- `stfs`/`stfd` - 存储浮点单/双精度

---

## capstone2llvmir 产生的 LLVM IR 模式

### 典型内存加载 IR

```llvm
; 汇编: mov eax, dword ptr [ebx + ecx*4 + 8]
; 文件: src/capstone2llvmir/x86/x86.cpp:976-1044

; 1. 加载寄存器
%ebx_val = load i32, i32* @ebx
%ecx_val = load i32, i32* @ecx

; 2. 计算索引（使用整数算术，非 GEP）
%scale = mul i32 %ecx_val, 4
%base_idx = add i32 %ebx_val, %scale
%addr = add i32 %base_idx, 8

; 3. 转换为指针并加载 (❌ 不使用 GEP!)
%ptr = inttoptr i32 %addr to i32*
%val = load i32, i32* %ptr

; 4. 存储结果
store i32 %val, i32* @eax
```

### 典型内存存储 IR

```llvm
; 汇编: mov dword ptr [ebp - 4], eax
; 文件: src/capstone2llvmir/x86/x86.cpp:1046-1121

; 1. 加载寄存器
%ebp_val = load i32, i32* @ebp
%eax_val = load i32, i32* @eax

; 2. 计算地址（使用整数算术）
%offset = sub i32 %ebp_val, 4

; 3. 转换为指针并存储 (❌ 不使用 GEP!)
%ptr = inttoptr i32 %offset to i32*
store i32 %eax_val, i32* %ptr
```

---

## 为什么 capstone2llvmir 层不使用 GEP

### 1. 底层内存模型

汇编指令面对的是**扁平的线性地址空间**，没有高级语言的类型概念（数组、结构体）。GEP 指令需要类型信息来计算偏移量。

### 2. 地址计算复杂性

x86 等架构的内存寻址模式（`base + index*scale + disp`）使用整数算术计算，与 GEP 的类型化索引计算方式不同。

### 3. 类型信息缺失

在 decoder 阶段，无法确定内存位置存储的数据类型，因此无法构建适当的 GEP 类型信息。

---

## GEP 指令在 RetDec 其他模块中的用途

### 1. LLVM IR 模拟器 (`src/llvmir-emul/`)
- `visitGetElementPtrInst()` - 模拟 GEP 指令执行 (第3017行)
- `executeGEPOperation()` - 计算 GEP 偏移量 (第899行)

### 2. IR 到高级语言转换 (`src/llvmir2hll/`)
- `visitGetElementPtrInst()` - 将 GEP 转换为数组索引或结构体成员访问 (第366行)
- `convertGetElementPtrToExpression()` - 转换 GEP 为高级语言表达式 (第641行)

### 3. 类型分析 (`src/bin2llvmir/optimizations/simple_types/`)
- 识别 GEP 指令用于类型传播分析（标记为 TODO）

### 4. 到达定义分析 (`src/bin2llvmir/analyses/reaching_definitions.cpp`)
- 处理 GEP 指令用于数据流分析 (第134行)

### 5. LLVM 工具函数 (`src/bin2llvmir/utils/llvm.cpp`)
- `skipCasts()` - 跳过 GEP 指令和常量表达式 (第31-64行)

---

## 关键文件位置汇总

### capstone2llvmir 层（❌ 不产生 GEP）
| 文件 | 功能 |
|------|------|
| `src/capstone2llvmir/x86/x86.cpp` | x86 内存操作实现（第958-1121行）|
| `src/capstone2llvmir/arm/arm.cpp` | ARM 内存操作实现（第379-620行）|
| `src/capstone2llvmir/mips/mips.cpp` | MIPS 内存操作实现（第309-500行）|
| `src/capstone2llvmir/powerpc/powerpc.cpp` | PowerPC 内存操作实现 |

### 其他模块（处理/识别 GEP）
| 文件 | 功能 |
|------|------|
| `src/llvmir2hll/llvm/llvmir2bir_converter/llvm_instruction_converter.cpp` | GEP 转高级语言（第366-678行）|
| `src/llvmir-emul/llvmir_emul.cpp` | GEP 模拟执行（第3017-3026行）|
| `src/bin2llvmir/utils/llvm.cpp` | GEP 指令跳过工具函数（第31-64行）|

---

## 总结

| 模块 | 目录 | 与 GEP 的关系 |
|------|------|---------------|
| **capstone2llvmir** | `src/capstone2llvmir/` | **❌ 不产生 GEP**，使用 `inttoptr` + `load`/`store` |
| bin2llvmir 优化 | `src/bin2llvmir/optimizations/` | ❌ 识别但不产生 GEP |
| IR 模拟器 | `src/llvmir-emul/` | ✅ **执行** GEP 指令 |
| IR → 高级语言 | `src/llvmir2hll/` | ✅ **转换** GEP 为数组/结构体访问 |

**最终结论：** 在 `src/capstone2llvmir/`（decoder 层），所有汇编内存访问指令（MOV, LDR, LW 等）都被转换为 `inttoptr` + `load`/`store` 的 IR 模式，**绝对不产生 GEP 指令**。GEP 的处理发生在完全独立的后续模块中。
