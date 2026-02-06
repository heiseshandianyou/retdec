# RetDec 中 YARA 模式匹配系统详解

## 目录

1. [概述](#概述)
2. [系统架构](#系统架构)
3. [签名生成流程](#签名生成流程)
4. [签名检测流程](#签名检测流程)
5. [核心组件详解](#核心组件详解)
6. [YARA 规则格式](#yara-规则格式)
7. [执行流程图](#执行流程图)
8. [配置与使用](#配置与使用)

---

## 概述

RetDec 使用 **YARA（Yet Another Recursive Acronym）** 风格的模式匹配技术来识别二进制文件中的已知函数签名。该系统主要用于：

- **静态库函数识别**：识别程序中静态链接的标准库函数（如 C 运行时库、MFC 等）
- **编译器检测辅助**：通过识别的函数推断使用的编译器和版本
- **反编译优化**：为已识别的函数提供准确的函数名和边界信息

### 为什么使用 YARA？

| 特性 | 优势 |
|------|------|
| 十六进制模式匹配 | 支持通配符，可处理地址重定位 |
| 高性能 | 基于 Aho-Corasick 算法的高效多模式匹配 |
| 元数据支持 | 可存储函数名、大小、引用关系等额外信息 |
| 规则编译 | 支持预编译规则，加速扫描过程 |

---

## 系统架构

### 整体架构图

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         RetDec YARA 模式匹配系统                         │
├─────────────────────────────────────────────────────────────────────────┤
│  签名生成阶段 (Build Time)                                               │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────────────────┐   │
│  │  静态库文件  │────▶│   bin2pat   │────▶│  原始模式文件 (.pat)     │   │
│  │  (.a/.lib)  │     │             │     │                         │   │
│  └─────────────┘     └─────────────┘     └─────────────────────────┘   │
│                                                    │                     │
│                                                    ▼                     │
│                                          ┌─────────────────────────┐   │
│                                          │        pat2yara         │   │
│                                          │   (模式优化与过滤)        │   │
│                                          └─────────────────────────┘   │
│                                                    │                     │
│                                                    ▼                     │
│                                          ┌─────────────────────────┐   │
│                                          │  YARA 规则文件 (.yara)   │   │
│                                          │  - 函数名元数据           │   │
│                                          │  - 十六进制模式           │   │
│                                          │  - 引用关系信息           │   │
│                                          └─────────────────────────┘   │
├─────────────────────────────────────────────────────────────────────────┤
│  签名检测阶段 (Runtime)                                                  │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                        stacofin (静态代码查找器)                  │   │
│  │  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────┐  │   │
│  │  │  YaraDetector │──▶│  libyara    │──▶│   模式匹配引擎       │  │   │
│  │  │             │    │             │    │  (Aho-Corasick)     │  │   │
│  │  └─────────────┘    └─────────────┘    └─────────────────────┘  │   │
│  │         │                                              │         │   │
│  │         ▼                                              ▼         │   │
│  │  ┌─────────────┐                              ┌─────────────┐   │   │
│  │  │ 签名选择逻辑 │                              │  匹配结果    │   │   │
│  │  │ (基于架构/   │                              │  - 函数地址  │   │   │
│  │  │  编译器版本) │                              │  - 函数大小  │   │   │
│  │  └─────────────┘                              │  - 函数名    │   │   │
│  │                                               └─────────────┘   │   │
│  │                                                      │           │   │
│  │                                                      ▼           │   │
│  │                                               ┌─────────────┐   │   │
│  │                                               │ 引用验证     │   │   │
│  │                                               │ (减少误报)   │   │   │
│  │                                               └─────────────┘   │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                    │                                     │
│                                    ▼                                     │
│                           ┌─────────────────┐                           │
│                           │  确认函数列表    │                           │
│                           │  (用于反编译)    │                           │
│                           └─────────────────┘                           │
└─────────────────────────────────────────────────────────────────────────┘
```

### 主要组件

| 组件 | 路径 | 功能描述 |
|------|------|----------|
| `bin2pat` | `src/bin2pat/` | 从目标文件提取原始函数模式 |
| `pat2yara` | `src/pat2yara/` | 将原始模式转换为 YARA 规则格式 |
| `yaracpp` | `src/yaracpp/` | C++ YARA 封装库，提供规则加载和扫描接口 |
| `stacofin` | `src/stacofin/` | 静态代码查找器，整合签名选择和验证 |
| `patterngen` | `src/patterngen/` | 模式生成库核心 |

---

## 签名生成流程

### 1. bin2pat - 模式提取

**输入**：静态库文件（`.a`、`.lib`）或目标文件（`.o`、`.obj`）

**处理流程**：

```cpp
// pattern_extractor.cpp 核心逻辑
bool PatternExtractor::processFile() {
    // 1. 读取符号表，识别函数符号
    for (const auto* func : filterSymbols()) {
        processSymbol(func);
    }
}

void PatternExtractor::processSymbol(const Symbol* symbol) {
    // 2. 获取函数所在的代码段
    const Section* section = inputFile->getSection(symbolSectionIndex);
    
    // 3. 提取函数的二进制数据
    std::vector<unsigned char> symbolData;
    section->getBytes(symbolData, offset, size);
    
    // 4. 分析重定位信息
    for (const auto* reloc : relocationTables) {
        // 标记重定位位置（这些字节在不同二进制中会变）
        pattern.addReference(reloc->getName(), relocOffset, mask);
    }
}
```

**关键技术点**：

- **重定位处理**：编译静态库时，函数内部的地址引用（如调用其他函数、访问全局数据）使用占位符。链接时这些会被替换为实际地址。签名生成时，这些位置需要标记为**通配符**。

- **多格式支持**：支持 ELF（Linux）、COFF（Windows）、Mach-O（macOS）格式的目标文件。

### 2. pat2yara - 模式转换与优化

**主要功能**：

```cpp
// processing.cpp - 规则过滤和优化
void filterRulesFromFile(...) {
    for (const auto& rule : file->getRules()) {
        // 1. 检查最小长度（避免太短的模式产生太多误报）
        if (getHexStringSize(hPattern) < options.minSize) {
            continue; // 跳过
        }
        
        // 2. 检查纯信息量（可变字节太多的模式不精确）
        if (getPureInformationSize(hPattern) < 4) {
            continue; // 跳过
        }
        
        // 3. 合并相同模式的函数（记录为 altNames）
        if (ruleRelations.hasEquals()) {
            collectNames(ruleRelations.getEquals());
        }
    }
}
```

**过滤条件**：

| 条件 | 默认值 | 说明 |
|------|--------|------|
| `--min-size` | - | 最小模式长度 |
| `--max-size` | 4096 | 最大模式长度（YARA 限制）|
| `--min-pure` | - | 最少固定字节数 |
| `--ignore-nops` | - | 忽略 NOP 序列 |

---

## 签名检测流程

### 1. 签名选择 (stacofin)

根据目标文件特征选择相关的签名文件：

```cpp
// stacofin.cpp - 签名选择逻辑
std::set<std::string> selectSignaturePaths(const Image& image, const Config& c) {
    // 1. 收集用户指定的签名
    for (auto& p : c.parameters.userStaticSignaturePaths) {
        getAllSignatureFiles(p, sigs);
    }
    
    // 2. 基于文件特征选择内置签名
    std::string archSize = std::to_string(image.getWordLength());  // "32" 或 "64"
    std::string format = image.isPe() ? "pe" : "elf";              // 文件格式
    std::string arch = getArchitectureString(c.architecture);      // "x86", "arm" 等
    
    // 3. 根据检测到的编译器选择特定版本签名
    if (c.tools.isMsvc()) {
        // 示例：x86-32-pe-vs-2015.yara
        selectSignaturesWithNames(allSigs, sigs, 
            {arch, archSize, format, "-vs-2015"});
    }
    else if (c.tools.isGcc()) {
        selectSignaturesWithNames(allSigs, sigs,
            {arch, archSize, format, "gcc-4.8.3"});
    }
    else if (c.tools.isDelphi()) {
        selectSignaturesWithNames(allSigs, sigs,
            {"pe", archSize, "delphi"});
    }
    
    return sigs;
}
```

### 2. YARA 扫描 (yaracpp)

```cpp
// yara_detector.cpp - YARA 扫描流程
bool YaraDetector::analyze(std::vector<std::uint8_t>& bytes, bool storeAllRules) {
    // 1. 编译规则（如果是文本格式）
    auto rules = getCompiledRules();
    
    // 2. 执行扫描
    yr_rules_scan_mem(rules, bytes.data(), bytes.size(), 0, 
                      yaraCallback, &settings, 0);
}

// 回调函数处理匹配结果
int YaraDetector::yaraCallback(YR_SCAN_CONTEXT* context, int message, 
                               void* messageData, void* userData) {
    if (message == CALLBACK_MSG_RULE_MATCHING) {
        auto* rule = static_cast<YR_RULE*>(messageData);
        
        // 提取规则元数据（函数名、大小等）
        yr_rule_metas_foreach(rule, meta) {
            if (meta->identifier == "name") {
                funcName = meta->string_value;
            }
            else if (meta->identifier == "size") {
                funcSize = meta->integer;
            }
            else if (meta->identifier == "refs") {
                references = meta->string_value;
            }
        }
        
        // 提取匹配位置
        yr_string_matches_foreach(context, string, match) {
            offset = match->base + match->offset;
        }
    }
}
```

### 3. 引用验证

为提高准确性，RetDec 会验证检测到的函数内部的引用关系：

```cpp
// stacofin.cpp - 引用验证
void Finder::solveReferences() {
    for (auto& detection : _allDetections) {
        for (auto& ref : detection.references) {
            // 获取引用地址处的实际值
            ref.target = getAddressFromRef(ref.address);
            
            // 检查该目标是否匹配已知的其他函数
            checkRef(ref);
        }
    }
}

// 根据引用验证结果确认或拒绝检测
void Finder::confirmAllRefsOk() {
    for (auto* func : _worklistDetections) {
        if (func->allRefsOk()) {
            // 所有引用都验证通过 → 确认
            confirmFunction(func);
        }
    }
}
```

---

## 核心组件详解

### 1. yaracpp - YARA C++ 封装

**类层次**：

```
YaraDetector
├── 规则管理
│   ├── addRuleFile()      # 加载 .yara 或 .yarac 文件
│   ├── addRules()         # 从字符串加载规则
│   └── getCompiledRules() # 获取编译后的规则
├── 扫描接口
│   ├── analyze(string)    # 扫描文件
│   └── analyze(bytes)     # 扫描内存缓冲区
└── 结果获取
    ├── getDetectedRules()   # 获取匹配的规则
    └── getUndetectedRules() # 获取未匹配的规则

YaraRule
├── getName()       # 规则名
├── getMetas()      # 元数据列表
└── getMatches()    # 匹配位置列表

YaraMeta
├── getId()         # 元数据标识
├── getStringValue() # 字符串值
└── getIntValue()   # 整数值

YaraMatch
├── getOffset()     # 文件偏移
└── getData()       # 匹配的数据
```

### 2. stacofin - 静态代码查找器

**Finder 类核心方法**：

```cpp
class Finder {
public:
    // 签名搜索
    void search(const Image& image, const std::string& yaraFile);
    void search(const Image& image, const std::set<std::string>& yaraFiles);
    void search(const Image& image, const Config& config);
    
    // 搜索并验证
    void searchAndConfirm(const Image& image, const Config& config);
    
    // 结果获取
    CoveredCode getCoveredCode();
    const DetectedFunctionsMultimap& getAllDetections() const;
    const DetectedFunctionsPtrMap& getConfirmedDetections() const;

private:
    // 验证方法
    void solveReferences();
    void confirmWithoutRefs();
    void confirmAllRefsOk();
    void confirmPartialRefsOk(float okShare);
    
    // 架构特定的引用解析
    Address getAddressFromRef_x86(Address ref);
    Address getAddressFromRef_mips(Address ref);
    Address getAddressFromRef_arm(Address ref);
    Address getAddressFromRef_ppc(Address ref);
};
```

### 3. patterngen - 模式生成

**SymbolPattern 类**：

```cpp
class SymbolPattern {
    // 数据
    bool isLittle;                    // 字节序
    std::size_t bitWidth;             // 字长（32/64）
    std::vector<uint8_t> data;        // 函数二进制数据
    std::vector<Reference> refs;      // 重定位引用
    
    // 元数据
    std::string symbolName;           // 符号名（如 "printf"）
    std::string ruleName;             // YARA 规则名
    std::vector<Meta> metas;          // 其他元数据

public:
    // 核心方法
    void addReference(const std::string& name, size_t offset, 
                      const std::vector<uint8_t>& mask);
    std::shared_ptr<HexString> getHexPattern() const;
    void printYaraRule(std::ostream& output) const;
    
private:
    // 字节模式生成（处理重定位通配符）
    void createBytePattern(uint8_t mask, uint8_t byte, 
                          YaraHexStringBuilder& builder);
};
```

---

## YARA 规则格式

### 生成的规则示例

```yara
rule x86_32_pe_vs2015_printf_0 {
    meta:
        // 基本信息
        name = "printf"
        size = 142
        bitWidth = 32
        endianness = "little"
        architecture = "x86"
        
        // 源代码信息
        source = "/path/to/msvcrt.lib"
        
        // 引用信息（偏移量 + 被引用的符号名）
        refs = "0014 _strlen 0032 __write 0056 _lock_file"
        
        // 替代名称（相同二进制但不同符号名的函数）
        altNames = "_printf __printf ___printf"
    
    strings:
        // $1 = 函数二进制模式
        // ?? 表示重定位字节（会因链接地址不同而变化）
        $1 = { 
            55                      // push ebp
            8B EC                   // mov ebp, esp
            81 EC ?? ?? ?? ??       // sub esp, 0x????????  (栈分配，地址可变)
            56                      // push esi
            57                      // push edi
            8B 45 08                // mov eax, [ebp+8]
            ...
            E8 ?? ?? ?? ??          // call _strlen        (相对地址，可变)
            ...
        }
    
    condition:
        $1
}
```

### 十六进制模式中的通配符

| 模式 | 含义 | 使用场景 |
|------|------|----------|
| `??` | 完整字节通配 | 4字节地址重定位 |
| `?X` | 高4位通配 | 部分重定位 |
| `X?` | 低4位通配 | 部分重定位 |
| `XX` | 固定字节 | 指令操作码 |

---

## 执行流程图

### 完整的反编译流程中 YARA 的位置

```
用户输入二进制文件
      │
      ▼
┌─────────────────┐
│   fileformat    │  ◄── 解析 PE/ELF/Mach-O 结构
│   (文件解析)     │
└─────────────────┘
      │
      ▼
┌─────────────────┐
│    loader       │  ◄── 加载段到内存映像
│   (加载器)       │
└─────────────────┘
      │
      ▼
┌─────────────────┐
│    cpdetect     │  ◄── 检测编译器和架构
│  (编译器检测)    │     (用于选择正确的签名集)
└─────────────────┘
      │
      ▼
┌─────────────────┐     ┌─────────────────┐
│    stacofin     │────▶│   YARA 签名库    │
│  (静态代码查找)  │     │  (.yara/.yarac) │
└─────────────────┘     └─────────────────┘
      │
      │  输出：检测到的函数列表
      │  {地址, 名称, 大小, 引用}
      ▼
┌─────────────────┐
│    bin2llvmir   │  ◄── LLVM IR 转换
│  (二进制提升)    │      使用识别的函数信息
└─────────────────┘
      │
      ▼
┌─────────────────┐
│   llvmir2hll    │  ◄── 生成高级语言代码
│  (反编译核心)    │      使用准确的函数名
└─────────────────┘
      │
      ▼
   输出源代码
```

### stacofin 内部详细流程

```
开始
  │
  ▼
┌─────────────────────┐
│ selectSignaturePaths │  ◄── 根据架构/编译器选择签名文件
└─────────────────────┘
  │
  ▼
┌─────────────────────┐
│ 加载 YARA 规则文件   │
│ (支持 .yara/.yarac) │
└─────────────────────┘
  │
  ▼
┌─────────────────────┐
│ YaraDetector::analyze│  ◄── 扫描二进制数据
└─────────────────────┘
  │
  ▼
┌─────────────────────┐
│ 解析匹配结果         │
│ - 提取函数名         │
│ - 提取函数大小       │
│ - 提取引用信息       │
└─────────────────────┘
  │
  ▼
┌─────────────────────┐
│ 收集导入表信息       │  ◄── 用于引用验证
└─────────────────────┘
  │
  ▼
┌─────────────────────┐
│ 初始化反汇编器       │  ◄── Capstone
│ (x86/ARM/MIPS/PPC)  │
└─────────────────────┘
  │
  ▼
┌─────────────────────┐
│ solveReferences()   │  ◄── 解析每个函数的内部引用
│ 计算引用目标地址     │
└─────────────────────┘
  │
  ▼
┌─────────────────────┐
│ checkRef()          │  ◄── 验证引用是否指向已知函数
└─────────────────────┘
  │
  ▼
┌─────────────────────┐
│ 确认函数             │
│ ├─ confirmAllRefsOk  │  ◄── 所有引用都验证通过
│ ├─ confirmPartialRefs│  ◄── 部分引用验证通过
│ └─ confirmWithoutRefs│  ◄── 无引用的简单函数
└─────────────────────┘
  │
  ▼
结束
```

---

## 配置与使用

### 签名文件位置

RetDec 默认签名存储在：

```
<retdec-install>/share/retdec/support/static-signatures/
├── x86-32-pe-vs-2003.yara
├── x86-32-pe-vs-2005.yara
├── ...
├── x86-64-pe-vs-2017.yara
├── x86-32-pe-mingw-4.7.3.yara
└── x86-32-elf-gcc-4.8.3.yara
```

### 命令行选项

```bash
# 使用 retdec-decompiler 时
retdec-decompiler \
    --static-signature-path /path/to/custom/signatures/ \
    input.exe

# 多个签名路径
retdec-decompiler \
    --static-signature-path /path/to/sig1/ \
    --static-signature-path /path/to/sig2/ \
    input.exe
```

### 生成自定义签名

```bash
# 1. 从静态库提取模式
bin2pat -o output.pat input.lib

# 2. 转换为 YARA 规则
pat2yara \
    --min-size 32 \
    --min-pure 16 \
    -o output.yara \
    output.pat

# 3. 使用生成的签名
retdec-decompiler --static-signature-path output.yara input.exe
```

---

## 总结

RetDec 的 YARA 模式匹配系统通过以下步骤实现高效的静态库函数识别：

1. **签名生成**：从静态库提取函数二进制模式，处理重定位信息生成通配符模式
2. **智能选择**：根据目标文件的架构、格式和检测到的编译器选择相关签名
3. **高效匹配**：使用 YARA 引擎进行快速多模式扫描
4. **引用验证**：通过验证函数内部引用的准确性减少误报
5. **结果应用**：将识别的函数信息用于反编译过程，提高输出代码质量

这种设计使得 RetDec 能够识别数千个标准库函数，为反编译后的代码提供准确的函数名和边界信息。
