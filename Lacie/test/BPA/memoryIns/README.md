# Memory Access Instructions Disassembly Test

这个测试用例用于测试 **只经过 decoder pass** 后，各种内存访问指令是如何被反汇编成 LLVM IR 的。

## 测试目的

1. **对比分析**: 对比 objdump (x86 汇编) 和 RetDec decoder (LLVM IR) 对内存访问指令的表示
2. **验证转换**: 验证 decoder pass 正确将机器指令转换为 LLVM IR 的内存操作
3. **模式覆盖**: 涵盖多种内存访问模式（栈、堆、全局、数组、结构体等）

## 文件结构

```
memoryIns/
├── test_memory_access.c      # 测试用例源代码（包含10种内存访问模式）
├── test.sh                   # 测试脚本
├── decompiler-config.json    # RetDec 配置文件（仅 decoder pass）
├── builds/                   # 编译输出目录
│   ├── test_memory_access          # 带符号的二进制
│   └── test_memory_access_stripped # 剥离符号的二进制（用于测试）
└── output/                   # 分析结果目录
    ├── test_memory_access_objdump.asm   # objdump 反汇编结果
    ├── test_memory_access.ll            # RetDec 生成的 LLVM IR
    ├── config.json                      # 生成的配置
    ├── retdec.log                       # RetDec 运行日志
    └── analysis_summary.txt             # 分析摘要
```

## 内存访问模式覆盖

| 测试函数 | 描述 | 预期 LLVM IR |
|---------|------|-------------|
| `test_stack_access()` | 栈变量读写 | `alloca`, `load`, `store` |
| `test_global_access()` | 全局变量访问 | 全局 `@` 变量的 `load`/`store` |
| `test_heap_access()` | 堆内存分配访问 | `malloc` 调用 + 指针 `load`/`store` |
| `test_array_access()` | 数组访问 | `getelementptr` 索引计算 |
| `test_struct_access()` | 结构体成员访问 | GEP 字段偏移计算 |
| `test_pointer_ops()` | 多级指针解引用 | 多级 `load` 获取指针值 |
| `test_funcptr_load()` | 函数指针加载 | 函数地址 `load`, 间接 `call` |
| `test_complex_patterns()` | 复杂组合模式 | 链表遍历、结构体数组 |
| `test_memory_copy()` | 内存拷贝 | 批量 `load`/`store` 或 `memcpy` |
| `test_conditional_access()` | 条件内存访问 | `phi` 节点值合并 |

## 使用方法

### 1. 完整测试流程

```bash
./test.sh all
```

执行步骤：
1. 编译测试程序（无调试信息）
2. 剥离符号表
3. **objdump 反汇编分析 (Intel 语法)**
4. RetDec decoder 反汇编
5. LLVM IR 内存访问模式分析
6. 对比总结

### 2. 仅编译

```bash
./test.sh build
```

使用选项：`-O0 -fno-inline -fno-optimize-sibling-calls -Wall`（不含 `-g`）

### 3. 仅 objdump 分析

```bash
./test.sh objdump
```

分析内容 (Intel 语法)：
- `mov` 指令统计
- `lea` 地址计算指令
- `push`/`pop` 栈操作
- 内存加载/存储模式

**注意:** 默认使用 Intel 汇编语法格式（`mov rax, [rbx]` 而非 `mov (%rbx), %rax`）

### 4. 仅 RetDec 分析

```bash
./test.sh retdec
```

**注意**: 需要设置 RetDec 路径：
```bash
export RETDEC_ROOT=/path/to/retdec/build
./test.sh retdec
```

### 5. 清理构建文件

```bash
./test.sh clean
```

## Decoder Pass 转换示例

### x86 Intel 语法 → LLVM IR

| x86 Intel | LLVM IR |
|---------|---------|
| `mov rax, [rbx]` | `%val = load i64, ptr %rbx_ptr` |
| `mov [rbx], rax` | `store i64 %rax_val, ptr %rbx_ptr` |
| `lea rax, [rbx+8]` | `%addr = add i64 %rbx, 8` (无内存访问) |
| `push rax` | `store i64 %rax, ptr %rsp; sub rsp, 8` |
| `pop rax` | `add rsp, 8; load i64, ptr %rsp` |
| `call rax` | `call i64 %rax()` (indirect call) |
| `mov rax, [rbp-8]` | `%addr = add rbp, -8; load` |
| `mov [rbp-8], rax` | `%addr = add rbp, -8; store` |

**注意:** 本文档使用 Intel 语法（目标在左，源在右），与 AT&T 语法相反。

## 配置说明

`decompiler-config.json` 配置仅运行 decoder pass：

```json
{
    "decompParams": {
        "llvmPasses": [
            "retdec-provider-init",
            "retdec-decoder",      // ← 只到 decoder
            "verify",
            "retdec-write-ll"
        ]
    }
}
```

这样可以看到 **最原始的 LLVM IR 表示**，没有经过后续的优化 pass。

## 分析输出

### objdump 输出示例 (Intel 语法)

```
Memory Access Instructions Count:
  mov instructions:       281
  lea instructions:        39 (address calculation)
  push instructions:       25 (stack store)
  pop instructions:         4 (stack load)
  ...

Sample Memory Access Instructions:
  mov rax, [rip+0x2fd9]      ; RIP 相对寻址
  mov [rbp-4], edi           ; 栈帧存储
  mov eax, [rbp-4]           ; 栈帧加载
  lea rax, [rbx+8]           ; 地址计算
```

### RetDec LLVM IR 输出示例

```
LLVM IR Memory-Related Instructions:
  load instructions:       XX (memory read)
  store instructions:      XX (memory write)
  getelementptr:           XX (address calculation)
  alloca:                  XX (stack allocation)
  call:                    XX (function call)
```

## 环境变量

| 变量 | 默认值 | 说明 |
|-----|-------|------|
| `CC` | `gcc` | C 编译器 |
| `RETDEC_ROOT` | `../../../../build` | RetDec 构建目录 |

使用示例：
```bash
CC=clang RETDEC_ROOT=/opt/retdec/build ./test.sh all
```
