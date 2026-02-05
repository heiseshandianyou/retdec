# RetDec 逆向工程框架学习笔记

本索引整理了 RetDec 反编译器的核心组件与学习文档。

---

## 📚 文档列表

### 1. 架构概览
- **[RetDec 用户指南](./retdec-guide-zh.md)** - 整体架构介绍、使用方法和关键组件

### 2. 核心模块

#### 2.1 二进制加载与初始化
- **[二进制文件读取与初始化流程](./binary_loading.md)** - 从文件读取到内存镜像的完整流程
  - 文件格式检测 (PE/ELF/Mach-O/COFF)
  - 格式解析与内存加载
  - Providers 初始化架构
  - 函数识别与符号解析

#### 2.2 Capstone → LLVM IR 转换
- **[x86 指令翻译详细分析](./capstone2llvmir.md)** - x86 到 LLVM IR 的详细映射
  - 翻译器核心架构
  - 指令映射表分析 (1,343 条指令)
  - 寄存器建模方式
  - 指令翻译模式

- **[多架构支持概览](./capstone2llvmir_architectures.md)** - x86/ARM/MIPS/PowerPC/ARM64 支持
  - 各架构翻译器类结构
  - 寄存器映射差异
  - 实现覆盖率统计

### 3. LLVM IR 建模
- **[x86 架构 LLVM IR 建模分析](./x86_modeling.md)** - 数据流分析准备
  - 寄存器建模为全局变量
  - EFLAGS 条件码拆分
  - 内存建模为字节数组
  - LLVM Memory SSA 优化

### 4. 端到端流程
- **[二进制到 LLVM IR 转换流程](./二进制到LLVM_IR转换流程.md)** - 完整端到端流程
  - 反编译阶段概览
  - 指令选择与模式匹配
  - 代码生成与优化

---

## 🗂️ 代码结构速查

```
src/
├── bin2llvmir/              # 二进制到 LLVM IR 转换
│   ├── optimizations/decoder/   # 反汇编解码器
│   │   └── decoder.cpp          # 解码主循环
│   ├── providers/               # 数据提供者
│   │   ├── fileimage.cpp        # 文件镜像
│   │   ├── config.cpp           # 配置信息
│   │   ├── debugformat.cpp      # 调试信息
│   │   └── names.cpp            # 符号名称
│   └── utils/ir_modifier.cpp    # IR 修改工具
│
├── capstone2llvmir/         # Capstone → LLVM IR
│   ├── x86/x86_init.cpp         # x86 指令映射表
│   ├── x86/x86_instructions.cpp # x86 指令翻译
│   ├── arm/arm_init.cpp         # ARM 指令映射
│   └── ...
│
├── loader/                  # 二进制加载
│   ├── image_factory.cpp        # 镜像工厂
│   └── loader/
│       ├── pe/pe_image.cpp      # PE 加载
│       ├── elf/elf_image.cpp    # ELF 加载
│       └── macho/               # Mach-O 加载
│
├── fileformat/              # 文件格式解析
│   ├── format_factory.cpp       # 格式工厂
│   └── file_format/
│       ├── pe/pe_format.cpp     # PE 解析
│       ├── elf/elf_format.cpp   # ELF 解析
│       └── macho/               # Mach-O 解析
│
├── llvmir2hll/              # LLVM IR → 高级语言
│   └── ...
│
├── llvm-support/            # LLVM 工具支持
│   └── ...
│
├── cpdetect/                # 编译器检测
│   └── ...
│
├── yaracpp/                 # YARA 规则引擎
│   └── ...
│
└── common/                  # 公共定义
    ├── architecture.h         # 架构枚举
    └── types.h                # 基本类型
```

---

## 📊 关键数据统计

| 组件 | 统计 |
|------|------|
| **x86 指令支持** | 281 / 1,343 (21%) |
| **支持架构** | x86, x86_64, ARM, MIPS, PowerPC, ARM64 |
| **支持格式** | PE, ELF, Mach-O, COFF, Intel HEX, Raw |
| **总代码量** | ~50万行 C++ |

---

## 🔧 构建环境

- **CMake**: 4.2.1 (需设置 `CMAKE_POLICY_VERSION_MINIMUM=3.5`)
- **LLVM**: 17+ (关键依赖)
- **Capstone**: 5.x (反汇编引擎)
- **OpenSSL**: 3.x (加密支持)

**构建脚本:**
- `build.sh` - 完整重建
- `quick-build.sh` - 增量构建

---

## 🎯 学习路径建议

1. **入门** - 阅读 `retdec-guide-zh.md` 了解整体架构
2. **加载流程** - 阅读 `binary_loading.md` 理解文件如何被加载
3. **指令翻译** - 阅读 `capstone2llvmir.md` 和 `capstone2llvmir_architectures.md`
4. **IR 建模** - 阅读 `x86_modeling.md` 理解数据流分析基础
5. **端到端** - 阅读 `二进制到LLVM_IR转换流程.md` 了解完整流程

---

## 📝 作者

**Lacie** - 逆向工程学习者

---

*最后更新: 2026-02-05*
