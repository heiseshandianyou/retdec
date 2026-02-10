# x86 Intel 汇编内存操作到 LLVM IR 翻译对照表

本文档基于 `test_memory_access.c` 测试用例的 decoder pass 输出，总结不同 x86 **Intel 语法**汇编指令在 RetDec decoder 中如何被翻译成 LLVM IR。

**格式说明：**
- **Intel 语法**: `mov dst, src` (目标在前，源在后)，使用 `[]` 表示内存
- **AT&T 语法**: `mov src, %dst` (源在前，目标在后)，使用 `()` 表示内存

---

## 1. 概述

RetDec 的 decoder pass 将 x86/x64 机器码提升为 LLVM IR，核心特点：

- **寄存器建模**: 所有 x86 寄存器表示为 LLVM 全局变量 (`@rax`, `@rbx`, `@rsp`, `@rbp` 等)
- **内存访问统一化**: 所有内存操作转换为 `load`/`store` + 地址计算
- **标志位模拟**: 条件标志位 (`@zf`, `@sf`, `@cf`, `@of` 等) 被显式更新
- **PC 跟踪**: 每条指令前更新 `@_asm_program_counter` 记录原始地址

---

## 2. 指令翻译对照表

### 2.1 寄存器操作

| Intel 汇编 | LLVM IR 形式 | 说明 |
|-----------|--------------|------|
| `mov rax, rbx` | `%0 = load i64, i64* @rbx`<br>`store i64 %0, i64* @rax` | 寄存器间传送 |
| `xor eax, eax` | `%0 = xor i32 %eax_val, %eax_val`<br>`store i32 %0, i64* @rax` | 清零优化 |
| `mov rax, imm` | `store i64 IMM, i64* @rax` | 立即数加载 |

**示例:**
```asm
; Intel 语法
mov rbp, rsp
```
```llvm
; LLVM IR
%0 = load i64, i64* @rsp      ; 读取 rsp
store i64 %0, i64* @rbp       ; rbp = rsp
```

---

### 2.2 栈操作

| Intel 汇编 | LLVM IR 形式 | 说明 |
|-----------|--------------|------|
| `push reg` | `%sp = load i64, i64* @rsp`<br>`%sp2 = sub i64 %sp, 8`<br>`%ptr = inttoptr i64 %sp2 to i64*`<br>`%val = load i64, i64* @reg`<br>`store i64 %val, i64* %ptr`<br>`store i64 %sp2, i64* @rsp` | 压栈：减 rsp，存储值 |
| `pop reg` | `%sp = load i64, i64* @rsp`<br>`%ptr = inttoptr i64 %sp to i64*`<br>`%val = load i64, i64* %ptr`<br>`%sp2 = add i64 %sp, 8`<br>`store i64 %val, i64* @reg`<br>`store i64 %sp2, i64* @rsp` | 弹栈：读值，增 rsp |
| `push imm` | 类似 `push reg`，但值来自立即数 | 立即数压栈 |

**示例:**
```asm
; Intel 语法 - 函数序言
push rbp
mov rbp, rsp
sub rsp, 0x10
```
```llvm
; LLVM IR
; push rbp
%0 = load i64, i64* @rbp
%1 = load i64, i64* @rsp
%2 = sub i64 %1, 8
%3 = inttoptr i64 %2 to i64*
store i64 %0, i64* %3
store i64 %2, i64* @rsp

; mov rbp, rsp
%4 = load i64, i64* @rsp
store i64 %4, i64* @rbp

; sub rsp, 0x10 (分配 16 字节栈空间)
%5 = load i64, i64* @rsp
%6 = sub i64 %5, 16
; ... 更新标志位 ...
store i64 %6, i64* @rsp
```

---

### 2.3 栈局部变量访问

| Intel 汇编 | LLVM IR 形式 | 说明 |
|-----------|--------------|------|
| `mov reg, [rbp-off]` | `%bp = load i64, i64* @rbp`<br>`%addr = add i64 %bp, -off`<br>`%ptr = inttoptr i64 %addr to TYPE*`<br>`%val = load TYPE, TYPE* %ptr`<br>`store TYPE %val, i64* @reg` | 从栈加载 |
| `mov [rbp-off], reg` | `%bp = load i64, i64* @rbp`<br>`%addr = add i64 %bp, -off`<br>`%ptr = inttoptr i64 %addr to TYPE*`<br>`%val = load TYPE, i64* @reg`<br>`store TYPE %val, TYPE* %ptr` | 存储到栈 |

**示例:**
```asm
; Intel 语法
mov [rbp-4], edi            ; 存储参数到局部变量
mov eax, [rbp-4]            ; 读取局部变量
```
```llvm
; LLVM IR
; mov [rbp-4], edi
%21 = load i64, i64* @rdi
%22 = trunc i64 %21 to i32    ; edi 是 32位
%23 = load i64, i64* @rbp
%24 = add i64 %23, -4         ; rbp - 4
%25 = inttoptr i64 %24 to i32*
store i32 %22, i32* %25

; mov eax, [rbp-4]
%26 = load i64, i64* @rbp
%27 = add i64 %26, -4
%28 = inttoptr i64 %27 to i32*
%29 = load i32, i32* %28
%30 = zext i32 %29 to i64     ; 零扩展到 rax
store i64 %30, i64* @rax
```

---

### 2.4 地址计算 (LEA)

| Intel 汇编 | LLVM IR 形式 | 说明 |
|-----------|--------------|------|
| `lea dst, [base+off]` | `%base = load i64, i64* @base`<br>`%addr = add i64 %base, off`<br>`store i64 %addr, i64* @dst` | 只计算地址，不访问内存 |
| `lea dst, [rip+off]` | `store i64 CONST_ADDR, i64* @dst` | RIP 相对直接算常量 |

**关键区别:** `lea` 与 `mov` 不同，它**不访问内存**，只计算地址。

**示例:**
```asm
; Intel 语法
lea rax, [rbp-32]           ; 计算 &local_var
lea rdi, [rip+0x957]        ; 加载字符串地址 (RIP 相对)
```
```llvm
; LLVM IR
; lea rax, [rbp-32]
%0 = load i64, i64* @rbp
%1 = add i64 %0, -32
store i64 %1, i64* @rax       ; rax = 地址，不是 [rbp-32] 的值！

; lea rdi, [rip+0x957]
store i64 6774, i64* @rdi     ; 编译时常量地址
```

---

### 2.5 堆内存访问 (指针操作)

| Intel 汇编 | LLVM IR 形式 | 说明 |
|-----------|--------------|------|
| `mov dst, [reg]` | `%ptr_val = load i64, i64* @reg`<br>`%ptr = inttoptr i64 %ptr_val to TYPE*`<br>`%val = load TYPE, TYPE* %ptr`<br>`store TYPE %val, i64* @dst` | 指针解引用加载 |
| `mov [reg], src` | `%ptr_val = load i64, i64* @reg`<br>`%ptr = inttoptr i64 %ptr_val to TYPE*`<br>`%val = load TYPE, i64* @src`<br>`store TYPE %val, TYPE* %ptr` | 指针解引用存储 |
| `mov dst, [base+idx*scale+off]` | 复杂地址计算后 load | 数组索引访问 |

**示例 (malloc 结果访问):**
```asm
; Intel 语法
call malloc                 ; rax = malloc(size)
mov [rbp-8], rax            ; 保存指针到栈
mov rax, [rbp-8]            ; 读取指针
mov dword ptr [rax], 42     ; *ptr = 42
```
```llvm
; LLVM IR
; call malloc
%0 = call i64 @malloc()
store i64 %0, i64* @rax

; mov [rbp-8], rax  (保存指针到栈)
%1 = load i64, i64* @rax
%2 = load i64, i64* @rbp
%3 = add i64 %2, -8
%4 = inttoptr i64 %3 to i64*
store i64 %1, i64* %4

; mov rax, [rbp-8]  (读取指针)
%5 = load i64, i64* @rbp
%6 = add i64 %5, -8
%7 = inttoptr i64 %6 to i64*
%8 = load i64, i64* %7
store i64 %8, i64* @rax

; mov dword ptr [rax], 42  (*ptr = 42)
%9 = load i64, i64* @rax       ; 读取指针值
%10 = inttoptr i64 %9 to i32*  ; 转为 i32 指针
store i32 42, i32* %10         ; 存储
```

---

### 2.6 全局变量访问

| Intel 汇编 | LLVM IR 形式 | 说明 |
|-----------|--------------|------|
| `mov reg, [rip+off]` | `%addr = GLOBAL_VAR_PTR`<br>`%val = load TYPE, TYPE* %addr`<br>`store TYPE %val, i64* @reg` | RIP 相对全局访问 |
| `mov [rip+off], reg` | `%addr = GLOBAL_VAR_PTR`<br>`%val = load TYPE, i64* @reg`<br>`store TYPE %val, TYPE* %addr` | 存储到全局 |

在 LLVM IR 中，全局变量通常在开始时定义：
```llvm
@global_int = global i32 42
@global_array = global [64 x i8] zeroinitializer
```

---

### 2.7 函数调用

| Intel 汇编 | LLVM IR 形式 | 说明 |
|-----------|--------------|------|
| `call func` | `%ret = call TYPE @func(...)` | 直接调用 |
| `call reg` | `%fptr = load i64, i64* @reg`<br>`%ret = call TYPE %fptr(...)`<br>或<br>`call @__pseudo_call(i64 %fptr)` | 间接调用 |
| `ret` | `ret TYPE VAL` 或 `ret i64 undef` | 函数返回 |

**示例 - 直接调用:**
```asm
; Intel 语法
call printf
```
```llvm
; LLVM IR
%35 = call i64 @function_10d0()
store i64 %35, i64* @rax
```

**示例 - 间接调用 (函数指针):**
```asm
; Intel 语法
call rax
```
```llvm
; LLVM IR
%0 = load i64, i64* @rax
; 方式1: 如果 decoder 能解析目标
%1 = inttoptr i64 %0 to i64()*  
call i64 %1()

; 方式2: 如果无法解析，生成伪调用
call i64 @__pseudo_call(i64 %0)
```

---

### 2.8 条件分支与比较

| Intel 汇编 | LLVM IR 形式 | 说明 |
|-----------|--------------|------|
| `cmp a, b` | `%va = load TYPE, i64* @a`<br>`%vb = load TYPE, i64* @b`<br>`%sub = sub TYPE %vb, %va`<br>更新 @zf, @sf, @cf, @of | 比较并设置标志位 |
| `test a, a` | `%va = load TYPE, i64* @a`<br>`%and = and TYPE %va, %va`<br>更新 @zf, @sf, @pf | 测试零/符号 |
| `je/jne label` | `%zf = load i1, i1* @zf`<br>`br i1 %zf, label %then, label %else` | 条件跳转 |

**注意:** Intel 语法的 `cmp a, b` 实际计算 `b - a`，与 AT&T `cmp %a, %b` 相同。

**示例:**
```asm
; Intel 语法
cmp rax, rdi
je equal_label
```
```llvm
; LLVM IR
%0 = load i64, i64* @rax
%1 = load i64, i64* @rdi
%2 = sub i64 %1, %0          ; rdi - rax
; ... 更新 zf, sf, cf, of ...
%zf = icmp eq i64 %2, 0
store i1 %zf, i1* @zf

; je (跳转为零)
%zf_val = load i1, i1* @zf
br i1 %zf_val, label %dec_label_pc_equal, label %dec_label_pc_next
```

---

### 2.9 算术运算

| Intel 汇编 | LLVM IR 形式 | 说明 |
|-----------|--------------|------|
| `add dst, src` | `%d = load i64, i64* @dst`<br>`%s = load i64, i64* @src`<br>`%r = add i64 %d, %s`<br>更新标志位<br>`store i64 %r, i64* @dst` | 加法 |
| `sub dst, src` | 类似 add，但用 `sub` | 减法 (dst = dst - src) |
| `and/or/xor dst, src` | 类似，使用对应 LLVM 操作 | 位运算 |
| `inc/dec reg` | `%v = load i64, i64* @reg`<br>`%r = add/sub i64 %v, 1`<br>更新标志位 | 增减 |

**示例:**
```asm
; Intel 语法
add rsp, 8
```
```llvm
; LLVM IR
%0 = load i64, i64* @rsp
%1 = add i64 %0, 8
; ... 更新标志位 ...
store i64 %1, i64* @rsp
```

---

## 3. 内存访问模式总结

### 3.1 地址计算模式

所有内存访问都遵循以下模式：

```
[base + index*scale + displacement]
              ↓
%base = load i64, i64* @base_reg
%index = load i64, i64* @index_reg (if present)
%scaled = mul i64 %index, scale (if scale != 1)
%addr1 = add i64 %base, %scaled (if index)
%addr2 = add i64 %addr1, displacement (if displacement)
%ptr = inttoptr i64 %addr2 to TYPE*
```

### 3.2 Intel vs AT&T 语法对比

| 操作 | Intel 语法 | AT&T 语法 |
|-----|-----------|-----------|
| 寄存器传送 | `mov rax, rbx` | `mov %rbx, %rax` |
| 内存加载 | `mov rax, [rbx]` | `mov (%rbx), %rax` |
| 内存存储 | `mov [rbx], rax` | `mov %rax, (%rbx)` |
| 地址计算 | `lea rax, [rbx+8]` | `lea 8(%rbx), %rax` |
| 基址+偏移 | `mov rax, [rbp-8]` | `mov -8(%rbp), %rax` |
| 复杂寻址 | `mov rax, [rbx+rdi*4+16]` | `mov 16(%rbx,%rdi,4), %rax` |

### 3.3 数据类型处理

| x86 操作数 | LLVM 类型 | 处理 |
|-----------|----------|------|
| `byte` (8-bit) | `i8` | 直接映射 |
| `word` (16-bit) | `i16` | 直接映射 |
| `dword` (32-bit) | `i32` | 直接映射 |
| `qword` (64-bit) | `i64` | 直接映射 |
| 寄存器低位 (eax) | `trunc` / `zext` | 截断/扩展 |

**示例:**
```asm
mov [rbp-4], edi            ; edi 是 32位 (dword)
```
```llvm
%21 = load i64, i64* @rdi
%22 = trunc i64 %21 to i32   ; 截断到 32位
```

---

## 4. 特殊模式

### 4.1 函数序言 (Function Prologue)

**Intel 语法:**
```asm
push rbp
mov rbp, rsp
sub rsp, 0x20
```

**LLVM IR:**
```llvm
; push rbp
%0 = load i64, i64* @rbp
%1 = load i64, i64* @rsp
%2 = sub i64 %1, 8
%3 = inttoptr i64 %2 to i64*
store i64 %0, i64* %3
store i64 %2, i64* @rsp

; mov rbp, rsp
%4 = load i64, i64* @rsp
store i64 %4, i64* @rbp

; sub rsp, 0x20 (分配 32字节栈空间)
%5 = load i64, i64* @rsp
%6 = sub i64 %5, 32
; ... 标志位更新 ...
store i64 %6, i64* @rsp
```

### 4.2 函数尾声 (Function Epilogue)

**Intel 语法:**
```asm
leave                     ; mov rsp, rbp; pop rbp
ret
```
或
```asm
mov rsp, rbp
pop rbp
ret
```

**LLVM IR:**
```llvm
; mov rsp, rbp (leave 的第一部分)
%0 = load i64, i64* @rbp
store i64 %0, i64* @rsp

; pop rbp (leave 的第二部分)
%1 = load i64, i64* @rsp
%2 = inttoptr i64 %1 to i64*
%3 = load i64, i64* %2
%4 = add i64 %1, 8
store i64 %3, i64* @rbp
store i64 %4, i64* @rsp

; ret
ret i64 undef
```

### 4.3 数组索引访问

**Intel 语法:**
```asm
mov eax, [rbx+rdi*4]      ; 数组访问: base + index*4
mov [rbx+rdi*4], eax      ; 数组存储
```

**LLVM IR:**
```llvm
; mov eax, [rbx+rdi*4]
%base = load i64, i64* @rbx
%index = load i64, i64* @rdi
%scaled = mul i64 %index, 4
%addr = add i64 %base, %scaled
%ptr = inttoptr i64 %addr to i32*
%val = load i32, i32* %ptr
%ext = zext i32 %val to i64
store i64 %ext, i64* @rax
```

---

## 5. Decoder Pass 输出特征

### 5.1 特殊全局变量

```llvm
@_asm_program_counter = internal global i64 0   ; 程序计数器
@rax, @rbx, ... @r15                              ; 通用寄存器
@rsp, @rbp                                        ; 栈寄存器
@zf, @sf, @cf, @of, @pf, @af                      ; 条件标志位
@xmm0-@xmm31, @ymm0-@ymm31, @zmm0-@zmm31         ; SIMD 寄存器
```

### 5.2 指令地址元数据

每条原始指令前都有 PC 更新：
```llvm
store volatile i64 4600, i64* @_asm_program_counter  ; 0x11f8
%26 = load i64, i64* @rbp
...
```

### 5.3 基本块标签

```llvm
dec_label_pc_11f8:              ; 原始地址标签
  ...
dec_label_pc_1204:              ; 跳转目标
  ...
```

---

## 6. 调试技巧

### 6.1 生成 Intel 格式汇编

```bash
# 使用 objdump 生成 Intel 格式汇编
objdump -d -M intel binary > output.asm

# 对比 AT&T 格式
objdump -d binary > output_att.asm        # 默认 AT&T
objdump -d -M intel binary > output_intel.asm  # Intel
```

### 6.2 查找特定地址的 IR

```bash
grep "0xADDRESS" output.ll
# 例如: grep "0x11f8" test_memory_access.ll
```

### 6.3 统计指令类型

```bash
# 统计 load/store
grep -c "load " test_memory_access.ll
grep -c "store " test_memory_access.ll

# 统计函数调用
grep -c "call " test_memory_access.ll

# 查找间接调用
grep "call i64 %" test_memory_access.ll
```

### 6.4 对比汇编和 IR

1. 在 objdump (Intel 格式) 中找到目标地址
2. 在 .ll 文件中搜索该地址的十进制值
3. 对比两者语义

---

## 7. 总结

| 概念 | Intel x86 | LLVM IR (Decoder) |
|-----|-----------|-------------------|
| 寄存器 | `rax` | `@rax` (全局变量) |
| 内存读 | `mov rax, [rbx]` | `inttoptr` + `load` |
| 内存写 | `mov [rbx], rax` | `inttoptr` + `store` |
| 栈操作 | `push`/`pop` | `load/store` + `rsp` 调整 |
| 地址计算 | `lea rax, [rbx+8]` | `add` (无内存访问) |
| 函数调用 | `call` | `call` |
| 间接调用 | `call rax` | `call %rax` 或 `__pseudo_call` |
| 标志位 | 隐式 | 显式全局变量更新 |

### 核心转换公式 (Intel 语法)

```
x86 内存访问:
  mov rax, [base + offset]
  
LLVM IR:
  %base = load i64, i64* @base_reg
  %addr = add i64 %base, offset
  %ptr  = inttoptr i64 %addr to TYPE*
  %val  = load TYPE, TYPE* %ptr
  store TYPE %val, i64* @rax
```

### Intel vs AT&T 快速对照

```asm
; Intel              AT&T
mov rax, rbx         mov %rbx, %rax
mov rax, [rbx]       mov (%rbx), %rax
mov [rbx], rax       mov %rax, (%rbx)
lea rax, [rbx+8]     lea 8(%rbx), %rax
mov rax, [rbp-8]     mov -8(%rbp), %rax
```
