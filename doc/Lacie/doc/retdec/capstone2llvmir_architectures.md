# RetDec 多架构汇编到 LLVM IR 转换总结

本文档总结 RetDec 对多种处理器架构的汇编指令到 LLVM IR 的转换支持情况。

## 总体支持概览

| 架构 | 总指令数 | 已实现 | 未实现 | 实现率 | 成熟度 |
|------|---------|--------|--------|--------|--------|
| **x86/x64** | 1,343 | 281 | 1,062 | 20.9% | ⚠️ 部分 |
| **ARM (32位)** | 435 | 152 | 283 | 34.9% | ⚠️ 部分 |
| **ARM64** | 460 | 151 | 309 | 32.8% | ⚠️ 部分 |
| **MIPS** | 627 | 136 | 491 | 21.7% | ⚠️ 部分 |
| **PowerPC** | 1,191 | 270 | 921 | 22.7% | ⚠️ 部分 |

> **注意**：ARM64 (AArch64) 架构有完整的实现框架，但仍有约 67% 的指令尚未实现。

---

## 1. x86/x64 架构

### 文件位置
```
src/capstone2llvmir/x86/
├── x86.cpp                  # 转换函数实现 (~2,500 行)
├── x86_impl.h               # 类定义
└── x86_init.cpp             # 指令映射表 (1,343 条)
```

### 支持统计

| 类别 | 指令数 | 占比 | 关键指令 |
|------|--------|------|----------|
| **基础整数运算** | 48 | 17.1% | ADD, SUB, MUL, DIV, AND, OR, XOR |
| **控制流** | 48 | 17.1% | JMP, Jcc, CALL, RET, LOOP |
| **数据传输** | 45 | 16.0% | MOV, PUSH, POP, LEA, MOVSX |
| **FPU 浮点** | 52 | 18.5% | FADD, FSUB, FMUL, FLD, FST |
| **条件传送** | 32 | 11.4% | CMOVA, CMOVE, FCMOVcc |
| **字符串操作** | 24 | 8.5% | MOVS, LODS, STOS, SCAS |
| **位操作** | 16 | 5.7% | BT, BTC, BTR, BTS, BSF |
| **系统指令** | 16 | 5.7% | CPUID, RDTSC, NOP |

### 主要转换函数（按使用频率）

| 转换函数 | 覆盖指令数 | 说明 |
|----------|-----------|------|
| `translateNop` | 17 | NOP, UD2, BNDcl 等空操作 |
| `translateSetCc` | 16 | SETE, SETNE, SETG 等条件设置 |
| `translateJCc` | 16 | JE, JNE, JA, JB 等条件跳转 |
| `translateCMovCc` | 16 | CMOVA, CMOVE 等条件传送 |
| `translateFucomPop` | 13 | FCOM, FUCOM 浮点比较 |
| `translateFCMovCc` | 8 | FCMOVBE, FCMOVE 浮点条件传送 |
| `translateFloadConstant` | 7 | FLDZ, FLD1, FLDPI 等加载常量 |
| `translateMov` | 5 | MOV, MOVSX, MOVZX, MOVSXD |
| `translateAdd` | 2 | ADD, XADD |
| `translateSub` | 2 | SUB, CMP |

### 未支持指令类别

| 指令集 | 数量 | 示例 |
|--------|------|------|
| AVX/AVX2/AVX-512 | ~400+ | VADDPD, VMOVAPS, VPADDB |
| SSE/SSE2/SSE3/SSE4 | ~200+ | ADDPS, MOVAPS, SHUFPS |
| AES-NI | 6 | AESENC, AESDEC, AESIMC |
| SHA 扩展 | 7 | SHA1MSG1, SHA256MSG2 |
| BMI/BMI2 | ~20+ | ANDN, BEXTR, BZHI |

---

## 2. ARM (32位) 架构

### 文件位置
```
src/capstone2llvmir/arm/
├── arm.cpp                  # 转换函数实现
├── arm_impl.h               # 类定义
└── arm_init.cpp             # 指令映射表 (435 条)
```

### 支持统计

| 类别 | 指令数 | 占比 | 关键指令 |
|------|--------|------|----------|
| **伪汇编/未实现** | 67 | 44.1% | 复杂指令降级处理 |
| **内存加载** | 23 | 15.1% | LDR, LDRB, LDRH, LDM |
| **内存存储** | 12 | 7.9% | STR, STRB, STRH, STM |
| **算术运算** | 15 | 9.9% | ADD, SUB, ADC, SBC |
| **分支跳转** | 12 | 7.9% | B, BL, BX |
| **乘法运算** | 10 | 6.6% | MUL, MLA, UMULL, SMULL |
| **逻辑运算** | 8 | 5.3% | AND, ORR, EOR, BIC |
| **移位操作** | 5 | 3.3% | LSL, LSR, ASR, ROR |

### 主要转换函数

| 转换函数 | 覆盖指令数 | 说明 |
|----------|-----------|------|
| `translatePseudoAsmOp0FncOp1Op2` | 41 | 复杂伪汇编处理 |
| `translatePseudoAsmOp0FncOp1Op2Op3` | 17 | 三操作数伪汇编 |
| `translateLdr` | 13 | LDR 系列加载指令 |
| `translateLdmStm` | 10 | LDM/STM 批量加载存储 |
| `translatePseudoAsmOp0Op1FncOp0Op1Op2Op3` | 9 | 特殊格式伪汇编 |
| `translateStr` | 7 | STR 系列存储指令 |
| `translateShifts` | 5 | 移位指令统一处理 |

### ARM 特有机制

#### 条件执行
ARM 指令集支持每条指令的条件执行：
```cpp
// ARM 汇编: ADDEQ (相等时加)
if (conditionPassed(cpsr, EQ)) {
    translateAdd(i, arm, irb);
}
```

#### 批量加载/存储 (LDM/STM)
```cpp
// LDMIA R0!, {R1-R4}
// 从 R0 地址加载多个寄存器
for (int reg = 1; reg <= 4; reg++) {
    loadRegisterFromMemory(reg);
}
```

### 未支持指令类别

| 类别 | 示例 |
|------|------|
| SIMD (NEON) | VMOV, VADD, VMUL |
| 加密扩展 | AESD, AESE, AESIMC |
| 调试指令 | BKPT, DBG |
| 内存屏障 | DMB, DSB, ISB |
| 特权指令 | CPS, ERET, SRS |

---

## 3. MIPS 架构

### 文件位置
```
src/capstone2llvmir/mips/
├── mips.cpp                 # 转换函数实现
├── mips_impl.h              # 类定义
└── mips_init.cpp            # 指令映射表 (627 条)
```

### 支持统计

| 类别 | 指令数 | 占比 | 关键指令 |
|------|--------|------|----------|
| **伪汇编处理** | 17 | 12.5% | 复杂指令降级 |
| **内存加载** | 17 | 12.5% | LW, LH, LB, LUI |
| **条件分支** | 18 | 13.2% | BEQ, BNE, BLTZ, BGEZ |
| **算术运算** | 16 | 11.8% | ADD, SUB, ADDU, SUBU |
| **逻辑运算** | 12 | 8.8% | AND, OR, XOR, NOR |
| **移位操作** | 12 | 8.8% | SLL, SRL, SRA, ROTR |
| **无条件跳转** | 8 | 5.9% | J, JAL, JR, JALR |
| **比较指令** | 10 | 7.4% | SLT, SLTU, SEQ, SNE |

### 主要转换函数

| 转换函数 | 覆盖指令数 | 说明 |
|----------|-----------|------|
| `translatePseudoAsmOp0FncOp1` | 13 | 单操作数伪汇编 |
| `translateLoadMemory` | 10 | LW, LH, LB 等加载 |
| `translateCondBranchBinary` | 10 | 双操作数条件分支 |
| `translateCondBranchTernary` | 4 | 三操作数条件分支 |
| `translateBcondal` | 4 | 无条件分支 |
| `translateAdd` | 4 | ADD, ADDI, ADDU, ADDIU |
| `translateSrl` | 3 | SRL, SRLV |
| `translateSra` | 3 | SRA, SRAV |
| `translateSll` | 3 | SLL, SLLV |

### MIPS 特有机制

#### 分支延迟槽
```cpp
// MIPS 分支有延迟槽，需要特殊处理
// BEQ $t0, $t1, label
// 延迟槽指令（分支结果确定前执行）
translateCondBranch(...);
translateDelaySlotInstruction();  // 延迟槽
```

#### HI/LO 寄存器
```cpp
// MULT $t0, $t1  -> 结果写入 HI/LO
// MFHI $t2       -> 从 HI 读取
// MFLO $t3       -> 从 LO 读取
```

### 未支持指令类别

| 类别 | 示例 |
|------|------|
| DSP 扩展 | ADDQ, ADDQH, ABSQ_S |
| SIMD (MSA) | 未实现 |
| 特权指令 | ERET, MTC0, MFC0 |
| 缓存操作 | PREF, CACHE, SYNCI |

---

## 4. PowerPC 架构

### 文件位置
```
src/capstone2llvmir/powerpc/
├── powerpc.cpp              # 转换函数实现
├── powerpc_impl.h           # 类定义
└── powerpc_init.cpp         # 指令映射表 (1,191 条)
```

### 支持统计

| 类别 | 指令数 | 占比 | 关键指令 |
|------|--------|------|----------|
| **分支跳转** | 157 | 58.1% | B, BA, BL, BLR 等 |
| **比较指令** | 15 | 5.6% | CMP, CMPI, CMPW |
| **内存加载** | 20 | 7.4% | LW, LHZ, LBZ, LFS |
| **内存存储** | 12 | 4.4% | STW, STH, STB, STFS |
| **算术运算** | 18 | 6.7% | ADD, SUBF, MUL, DIV |
| **条件寄存器** | 16 | 5.9% | CRAND, CROR, CRXOR |
| **逻辑运算** | 12 | 4.4% | AND, OR, XOR, NAND |
| **扩展/旋转** | 10 | 3.7% | EXTS, SLW, SRW, RLW |

### 主要转换函数

| 转换函数 | 覆盖指令数 | 说明 |
|----------|-----------|------|
| `translateB` | 147 | 各种形式的 B 指令（分支） |
| `translateCmp` | 10 | CMP, CMPL 比较指令 |
| `translateLoadIndexed` | 8 | 带索引的加载 |
| `translateLoad` | 8 | 基础加载指令 |
| `translateCrModifTernary` | 8 | 条件寄存器三元操作 |
| `translateStoreIndexed` | 6 | 带索引的存储 |
| `translateStore` | 6 | 基础存储指令 |
| `translateSubfc` | 3 | 带进位减法 |
| `translateExtendSign` | 3 | 符号扩展 |
| `translateAdd` | 3 | ADD, ADDI, ADDIC |

### PowerPC 特有机制

#### 条件寄存器 (CR)
```cpp
// PowerPC 有 8 个条件寄存器字段 (CR0-CR7)
// 每个字段包含 LT, GT, EQ, SO 位
// cmpw cr1, r3, r4  -> 比较结果写入 CR1
```

#### 链接寄存器 (LR)
```cpp
// BL (Branch and Link) 将返回地址存入 LR
// BLR (Branch to Link Register) 用于函数返回
```

#### 计数寄存器 (CTR)
```cpp
// BDZ (Decrement CTR and Branch if Zero)
// 用于实现循环
for (int i = n; i > 0; i--) { ... }
```

### 未支持指令类别

| 类别 | 示例 |
|------|------|
| AltiVec/VMX 向量 | 未实现 |
| 浮点指令 | 部分支持 |
| 缓存管理 | DCBF, DCBST, DCBT |
| 原子操作 | LBAR, LHAR, LWAR |
| 特权指令 | MTSPR, MFSPR, TLBIE |

---

## 5. ARM64 (AArch64) 架构

### 文件位置
```
src/capstone2llvmir/arm64/
├── arm64.cpp                # 转换函数实现 (~3,000 行)
├── arm64_impl.h             # 类定义 (~260 行)
└── arm64_init.cpp           # 指令映射表 (460 条)
```

### 支持统计

| 类别 | 指令数 | 占比 | 关键指令 |
|------|--------|------|----------|
| **内存加载** | 45 | 29.8% | LDR, LDRB, LDRH, LDRSW, LDP |
| **内存存储** | 18 | 11.9% | STR, STRB, STRH, STP |
| **算术运算** | 25 | 16.6% | ADD, SUB, MUL, ADC, SBC |
| **逻辑运算** | 15 | 9.9% | AND, ORR, EOR, BIC |
| **移位操作** | 12 | 7.9% | LSL, LSR, ASR, ROR |
| **条件操作** | 15 | 9.9% | CSEL, CSET, CSINC, CSINV |
| **比较指令** | 8 | 5.3% | CMP, CMN, TST |
| **分支跳转** | 13 | 8.6% | B, BL, BR, BLR, RET |

### 主要转换函数

| 转换函数 | 覆盖指令数 | 说明 |
|----------|-----------|------|
| `translateLdr` | 27 | LDR 系列加载指令 |
| `translateStr` | 9 | STR 系列存储指令 |
| `translateMulOpl` | 6 | MUL, MNEG, SMULH, UMULH |
| `translateExtensions` | 6 | SXTB, SXTH, SXTW, UXTB, UXTH |
| `translateMov` | 5 | MOV, MOVZ, MOVN, MOVK |
| `translateLdp` | 5 | LDP (加载一对寄存器) |
| `translateAnd` | 5 | AND, ANDS, TST |
| `translateShifts` | 4 | LSL, LSR, ASR, ROR |
| `translateMul` | 4 | MUL, SMULL, UMULL |
| `translateSub` | 3 | SUB, SUBS, CMP |
| `translateFUnaryOp` | 3 | FNEG, FABS, FSQRT |
| `translateCondSelOp` | 3 | CSEL, CSINC, CSINV |
| `translateCondOp` | 3 | CSET, CSETM |
| `translateAdd` | 3 | ADD, ADDS, CMN |

### ARM64 特有机制

#### 寄存器设计
```cpp
// 31 个通用寄存器 (X0-X30 64位, W0-W30 32位)
// X30 也是链接寄存器 (LR)
// SP 是独立的栈指针
// XZR/WZR 是零寄存器
```

#### 条件选择指令 (取代条件执行)
```cpp
// ARM32: ADDEQ r0, r1, r2  (条件执行)
// ARM64: CSEL r0, r1, r2, EQ  (条件选择)
// 根据条件选择两个源操作数之一
```

#### 加载/存储对 (LDP/STP)
```cpp
// LDP x0, x1, [x2]      // 从 [x2] 加载两个 64 位值
// STP x0, x1, [x2]      // 存储两个 64 位值到 [x2]
// 用于函数序言/尾声保存/恢复寄存器
```

#### NEON 向量寄存器
```cpp
// 32 个 128 位向量寄存器 V0-V31
// 可作为 8/16/32/64/128 位访问
// 目前大部分 NEON 指令未实现
```

### 未支持指令类别

| 类别 | 示例 |
|------|------|
| **NEON 向量运算** | ~200+ 条 | ADD, MUL, FMA 等向量版本 |
| **加密扩展** | AESD, AESE, SHA1C, SHA256H |
| **CRC32** | CRC32B, CRC32H, CRC32W, CRC32X |
| **原子操作** | LDADD, LDCLR, LDSET, CAS |
| **内存屏障** | DMB, DSB, ISB |
| **系统指令** | MSR, MRS, SYS, DC, IC |
| **浮点运算** | 部分 FMUL, FDIV, FCMP 变体 |
| **条件分支** | CBZ, CBNZ, TBZ, TBNZ (部分实现) |

### ARM64 vs ARM32 主要差异

| 特性 | ARM32 | ARM64 |
|------|-------|-------|
| 条件执行 | 大多数指令支持 | 只有条件分支和选择指令 |
| 寄存器 | 16 个 32 位 | 31 个 64 位 + SP 独立 |
| 指令长度 | 32 位 (Thumb 16/32) | 固定 32 位 |
| 移位操作 | 作为指令修饰符 | 显式移位指令 |
| 异常返回 | 使用 SPSR 等 | 使用 ERET 指令 |
| PC 访问 | 可直接读写 PC | PC 不能直接访问 |

---

## 跨架构对比

### 支持程度对比

| 功能 | x86 | ARM | ARM64 | MIPS | PowerPC |
|------|-----|-----|-------|------|---------|
| 基础整数运算 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 控制流 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 内存访问 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 条件执行/选择 | ✅ | ✅ | ✅ | ⚠️ | ✅ |
| 浮点运算 | ⚠️ | ❌ | ⚠️ | ❌ | ⚠️ |
| SIMD 向量 | ❌ | ❌ | ❌ | ❌ | ❌ |
| 原子指令 | ❌ | ❌ | ❌ | ❌ | ❌ |
| 特权指令 | ❌ | ❌ | ❌ | ❌ | ❌ |

### 转换函数命名规范

| 架构 | 命名前缀 | 示例 |
|------|----------|------|
| x86 | `translate` + 操作名 | `translateAdd`, `translateMov` |
| ARM | `translate` + 操作名 | `translateLdr`, `translateB` |
| MIPS | `translate` + 操作名 | `translateAdd`, `translateLoadMemory` |
| PowerPC | `translate` + 操作名 | `translateB`, `translateLoad` |

### 指令 ID 前缀

| 架构 | Capstone 前缀 | 示例 |
|------|--------------|------|
| x86 | `X86_INS_` | `X86_INS_ADD` |
| ARM (32位) | `ARM_INS_` | `ARM_INS_LDR` |
| ARM64 (AArch64) | `ARM64_INS_` | `ARM64_INS_ADD` |
| MIPS | `MIPS_INS_` | `MIPS_INS_ADD` |
| PowerPC | `PPC_INS_` | `PPC_INS_ADD` |

---

## 开发建议

### 添加新架构支持

1. **创建目录结构**
```
src/capstone2llvmir/newarch/
├── newarch.cpp
├── newarch.h
├── newarch_impl.h
├── newarch_init.cpp
└── newarch_instructions.cpp  # 可选
```

2. **实现必要组件**
   - 寄存器定义 (`generateRegisters()`)
   - 指令映射表 (`_i2fm`)
   - 核心转换函数
   - 架构特有机制处理

3. **注册到主框架**
   - 在 `capstone2llvmir.cpp` 中添加创建函数
   - 更新 CMakeLists.txt

### 扩展现有架构

1. **添加单条指令支持**
   - 在 `xxx_init.cpp` 映射表中添加条目
   - 在 `xxx_impl.h` 中声明函数
   - 在 `xxx.cpp` 中实现转换逻辑

2. **测试验证**
   - 编写单元测试
   - 使用实际二进制文件测试
   - 对比 LLVM IR 输出

---

## 参考

- [Capstone Engine Documentation](https://www.capstone-engine.org/documentation.html)
- [RetDec 源码](https://github.com/avast/retdec/tree/master/src/capstone2llvmir)
- [x86 Instruction Reference](https://www.felixcloutier.com/x86/)
- [ARM Architecture Reference Manual](https://developer.arm.com/documentation/ddi0406/latest/)
- [MIPS Architecture Documentation](https://www.mips.com/products/architectures/)
- [PowerPC Architecture Book](https://openpowerfoundation.org/?resource_lib=powerpc-architecture-book-version-2-02)
