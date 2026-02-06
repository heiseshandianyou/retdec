# RetDec 二进制文件读取与初始化流程

本文档详细描述 RetDec 如何读取二进制文件、解析文件格式、加载到内存镜像，并初始化各种分析所需的 providers。

## 1. 整体流程概览

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         1. 文件格式检测与解析                               │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────────────┐  │
│  │ 输入文件路径 │ -> │ 格式自动检测 │ -> │ 创建对应 FileFormat 解析器   │  │
│  └─────────────┘    └─────────────┘    └─────────────────────────────┘  │
│                            (PE/ELF/Mach-O/COFF/Raw)                       │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         2. 内存镜像加载                                     │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────────┐  │
│  │ 基于 FileFormat  │ -> │ 创建 Image 加载器 │ -> │ 加载段/节到内存空间    │  │
│  │ 解析器数据        │    │ (PE/ELF/Mach-O)  │    │ 建立虚拟地址映射      │  │
│  └─────────────────┘    └─────────────────┘    └─────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         3. Providers 初始化                                 │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐  │
│  │ Config   │ │ FileImage│ │ DebugFmt │ │ Names    │ │ Demangler    │  │
│  │ Provider │ │ Provider │ │ Provider │ │ Provider │ │ Provider     │  │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────────┘  │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐                  │
│  │ ABI      │ │ LTI      │ │ AsmInsn  │ │ CallConv │                  │
│  │ Provider │ │ Provider │ │ Provider │ │ Provider │                  │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘                  │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         4. 反编译准备就绪                                    │
│  - 函数列表识别                                                          │
│  - 符号表解析                                                            │
│  - 导入/导出表处理                                                        │
│  - 调试信息加载 (PDB/DWARF)                                               │
│  - 字符串表提取                                                          │
│  - 资源表解析 (PE)                                                       │
│  - 重定位信息处理                                                        │
│  - 开始 LLVM IR 解码                                                     │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. 文件格式解析层 (FileFormat)

### 2.1 格式自动检测

```cpp
// src/fileformat/utils/format_detection.cpp
Format detectFileFormat(const std::string& filePath, bool isRaw);
```

**支持的文件格式：**

| 格式 | 枚举值 | 说明 |
|------|--------|------|
| PE | `Format::PE` | Windows 可执行文件 |
| ELF | `Format::ELF` | Linux/Unix 可执行文件 |
| Mach-O | `Format::MACHO` | macOS/iOS 可执行文件 |
| COFF | `Format::COFF` | 通用对象文件格式 |
| Intel HEX | `Format::INTEL_HEX` | 十六进制固件格式 |
| Raw Data | `Format::RAW_DATA` | 原始二进制数据 |

**检测方法：**
- 读取文件头魔数 (Magic Number)
- PE: `MZ` (0x4D5A)
- ELF: `\x7FELF` (0x7F454C46)
- Mach-O: `0xFEEDFACE` (32位) / `0xFEEDFACF` (64位)
- COFF: 根据目标机器类型判断

### 2.2 格式工厂 (Format Factory)

```cpp
// src/fileformat/format_factory.cpp
std::unique_ptr<FileFormat> createFileFormat(
    const std::string& filePath,
    const std::string& dllListFile,  // Windows DLL 列表
    bool isRaw,                       // 是否为原始二进制
    LoadFlags loadFlags               // 加载标志
);
```

**创建流程：**
1. 检测文件格式
2. 根据格式创建对应的解析器实例
3. 解析文件头、段表、符号表等基本信息

### 2.3 FileFormat 基类

```cpp
// include/retdec/fileformat/fileformat.h
class FileFormat {
public:
    // 基本信息
    virtual Format getFileFormat() const = 0;
    virtual bool isInValidState() const = 0;
    
    // 架构信息
    virtual Architecture getArchitecture() const;
    virtual Endianness getEndianness() const;
    virtual std::size_t getBytesPerWord() const;
    
    // 段/节信息
    virtual std::size_t getNumberOfSections() const;
    virtual std::size_t getNumberOfSegments() const;
    virtual const SecSeg* getSection(std::size_t index) const;
    virtual const SecSeg* getSegment(std::size_t index) const;
    
    // 符号表
    virtual const SymbolTable* getSymbolTable() const;
    virtual const SymbolTable* getDynamicSymbolTable() const;
    
    // 导入/导出表
    virtual const ImportTable* getImportTable() const;
    virtual const ExportTable* getExportTable() const;
    
    // 重定位表
    virtual const RelocationTable* getRelocationTable() const;
    
    // 调试信息
    virtual const DebugTable* getDebugTable() const;
    
    // 资源表 (PE)
    virtual const ResourceTable* getResourceTable() const;
    
    // 字符串提取
    void getStrings(std::set<String>& result, 
                    std::size_t minLength = DEFAULT_MIN_STRING_LENGTH);
};
```

### 2.4 各格式特有解析

#### PE 格式解析

```cpp
// src/fileformat/file_format/pe/pe_format.cpp
class PeFormat : public FileFormat {
private:
    PeLib::PeFileT* peFile;
    
public:
    // PE 特有信息
    PeLib::ImageLoader& getImageLoader();
    
    // 数据目录
    std::unique_ptr<ImportTable> importTable;
    std::unique_ptr<ExportTable> exportTable;
    std::unique_ptr<ResourceTable> resourceTable;
    std::unique_ptr<DelayImportTable> delayImportTable;
    
    // 安全信息
    std::unique_ptr<CertificateTable> certificateTable;
    
    // .NET 信息
    std::unique_ptr<ClrHeader> clrHeader;
    std::unique_ptr<MetadataHeader> metadataHeader;
};
```

**PE 特有数据结构：**
- DOS Header (`IMAGE_DOS_HEADER`)
- PE Header (`IMAGE_NT_HEADERS`)
- 数据目录 (导入表、导出表、资源表等)
- 节表 (`IMAGE_SECTION_HEADER`)

#### ELF 格式解析

```cpp
// src/fileformat/file_format/elf/elf_format.cpp
class ElfFormat : public FileFormat {
private:
    ELFIO::elfio* elfIo;
    
public:
    // ELF 特有
    std::unique_ptr<DynamicTable> dynamicTable;
    std::unique_ptr<ElfNotes> noteSections;
    std::unique_ptr<ElfCore> coreInfo;  // Core dump
    
    // 段信息
    std::vector<std::unique_ptr<Segment>> segments;
};
```

**ELF 特有数据结构：**
- ELF Header (`Elf64_Ehdr`)
- 程序头表 (Program Header Table - 段)
- 节头表 (Section Header Table - 节)
- 动态段 (Dynamic Segment)
- 符号表 (Symbol Table)
- 字符串表 (String Table)

### 2.5 格式工厂详解

#### 什么是格式工厂？

**格式工厂 (Format Factory)** 是 RetDec 中使用的设计模式，用于根据输入文件的类型自动创建对应的文件格式解析器。

```cpp
// src/fileformat/format_factory.cpp:29
std::unique_ptr<FileFormat> createFileFormat(
    const std::string &filePath,
    const std::string &dllListFile,
    bool isRaw,              // 关键参数：是否为裸二进制
    LoadFlags loadFlags
) {
    switch (detectFileFormat(filePath, isRaw))
    {
        case Format::PE:     return std::make_unique<PeFormat>(...);
        case Format::ELF:    return std::make_unique<ElfFormat>(...);
        case Format::COFF:   return std::make_unique<CoffFormat>(...);
        case Format::MACHO:  return std::make_unique<MachOFormat>(...);
        case Format::RAW_DATA: return std::make_unique<RawDataFormat>(...);
        default:             return nullptr;
    }
}
```

**设计思想：**
- 类似于现实世界中的工厂：根据订单（文件类型）生产对应的产品（解析器）
- 使用者不需要知道具体创建的是哪种解析器，只需要调用统一的接口
- 新增文件格式支持时，只需在工厂中添加新的 case 分支

### 2.6 isRaw 参数详解

#### 什么是 isRaw？

**`isRaw`** 是格式检测和创建函数的关键参数，表示**输入是否为原始二进制数据（裸二进制）**。

#### 标准可执行文件 vs 原始二进制

| 特性 | 标准可执行文件 | 原始二进制 (Raw Binary) |
|------|--------------|-----------------------|
| 文件头 | 有（PE/ELF/Mach-O 头） | 无 |
| 段表 | 有 | 无 |
| 符号表 | 可能有 | 无 |
| 入口点 | 从文件头读取 | 默认为 0 |
| 架构信息 | 从文件头读取 | 需手动指定 |
| 典型用途 | 普通程序 | 固件、引导扇区、内存转储 |

#### isRaw 的工作原理

```cpp
// src/fileformat/utils/format_detection.cpp:211
Format detectFileFormat(std::istream &inputStream, bool isRaw)
{
    // 如果标记为 Raw，直接返回 RAW_DATA 格式
    // 跳过所有文件头魔数检测逻辑
    if (isRaw)
    {
        return Format::RAW_DATA;
    }
    
    // 否则，尝试检测文件头魔数...
    // 检测 PE (MZ)、ELF (0x7FELF)、Mach-O (0xFEEDFACE) 等
    for(const auto &item : magicFormatMap)
    {
        if(hasSubstringOnPosition(magic, item.first.second, item.first.first))
        {
            return item.second;  // 返回检测到的格式
        }
    }
}
```

#### RawDataFormat 的特点

当 `isRaw = true` 时，RetDec 使用 `RawDataFormat` 解析器：

```cpp
// src/fileformat/file_format/raw_data/raw_data_format.cpp:56
void RawDataFormat::initStructures()
{
    fileFormat = Format::RAW_DATA;
    
    // 将整个文件视为一个代码段
    section = new Section;
    section->setName(".text");              // 默认段名
    section->setType(Section::Type::CODE);  // 标记为代码段
    section->setAddress(0);                  // 默认基地址为 0
    section->setSizeInFile(bytes.size());    // 文件大小 = 段大小
    sections.push_back(section);
}
```

#### 使用场景示例

**场景 1：分析标准可执行文件**
```bash
retdec-decompiler input.exe
# isRaw = false
# 检测文件头 -> 识别为 PE 格式 -> 使用 PeFormat 解析器
```

**场景 2：分析裸二进制（如固件）**
```bash
retdec-decompiler --raw --arch x86 --base 0x8000 firmware.bin
# isRaw = true
# 跳过文件头检测 -> 直接使用 RawDataFormat 解析器
# 需要手动指定架构和基地址
```

#### 为什么需要 isRaw？

1. **固件分析**：嵌入式设备的固件通常是裸二进制格式
2. **内存转储**：从内存中转储出的代码没有文件头
3. **引导扇区**：MBR、bootloader 等通常是裸二进制
4. **避免误判**：某些数据文件可能恰好包含 PE/ELF 的魔数字节

---

## 3. 内存镜像加载层 (Loader)

### 3.1 镜像是什么？

在 RetDec 中，**镜像 (Image)** 是将可执行文件加载到内存后的抽象表示。它模拟了操作系统加载器的行为，将磁盘上的文件格式（PE/ELF/Mach-O）转换为进程内存空间的模型。

#### 核心概念对比

| 概念 | 类比 | 说明 |
|------|------|------|
| **文件 (File)** | 硬盘上的程序文件 | 存储在磁盘上的静态数据 |
| **FileFormat** | 文件解析器 | 理解 PE/ELF 等文件格式的结构 |
| **镜像 (Image)** | 内存中的进程 | 模拟操作系统加载后的内存状态 |
| **段 (Segment)** | 内存页/区域 | 具有相同权限的连续内存块 |

#### 文件与内存的区别

```
磁盘上的 PE 文件                    内存中的进程镜像
┌─────────────────┐                ┌──────────────────────┐
│ DOS Header      │                │                      │
│ PE Header       │ ───加载───>    │  .text (代码段)       │
│ 段表 (Section   │   转换         │      0x401000        │
│   Table)        │                │  .data (数据段)       │
│ .text (代码)    │                │      0x402000        │
│ .data (数据)    │                │  .bss (未初始化数据)   │
│ .rdata (只读)   │                │      0x403000        │
│ ...             │                │                      │
└─────────────────┘                └──────────────────────┘
        ↓                                   ↓
   按文件组织                        按虚拟地址组织
   (偏移量 Offset)                  (虚拟地址 VA)
```

### 3.2 为什么需要镜像？

#### 原因 1：地址转换

文件使用**文件偏移量**（相对于文件开头的偏移），而程序运行时使用**虚拟地址**。Image 提供统一的虚拟地址访问接口：

```cpp
// PE 文件中：代码在文件偏移 0x400 处
// 内存中：代码在虚拟地址 0x401000 处

// Image 提供统一的虚拟地址访问
Image->getByte(0x401000);  // 直接通过虚拟地址访问
```

#### 原因 2：内存布局模拟

```cpp
// src/loader/loader/pe/pe_image.cpp:32
bool PeImage::load()
{
    // 从 PE 文件读取 ImageBase (首选加载地址)
    std::uint64_t imageBase;
    peFormat->getImageBaseAddress(imageBase);  // 例如：0x400000
    setBaseAddress(imageBase);
    
    // 将每个节（Section）转换为内存段（Segment）
    for (const auto& section : sections)
    {
        // 计算虚拟地址：VA = ImageBase + RVA
        std::uint64_t virtualAddress = section->getAddress();
        // ...
        
        // 创建 Segment 并加入 Image
        addSegment(section, virtualAddress, virtualSize);
    }
}
```

#### 原因 3：段权限管理

```cpp
// 代码段：可读、可执行
// 数据段：可读、可写
// 只读段：只读

// Image 为每个 Segment 维护权限信息
Segment->isReadable();
Segment->isWritable();
Segment->isExecutable();
```

#### 原因 4：BSS 段处理

```cpp
// BSS 段在文件中不占空间（只有大小信息）
// 但加载到内存后需要分配零初始化空间

// src/loader/loader/pe/pe_image.cpp:87
if (!section->isBss())
{
    // 从文件加载数据
    dataSource.reset(new SegmentDataSource(sectionContent));
}
// BSS 段：Segment 存在，但没有数据源（全零）
```

### 3.3 镜像的核心组件

#### Image 类

```cpp
// include/retdec/loader/loader/image.h
class Image {
public:
    // 按虚拟地址读取数据
    bool getByte(std::uint64_t address, std::uint64_t& res);
    bool getWord(std::uint64_t address, std::uint64_t& res);
    bool getXByte(std::uint64_t address, std::uint64_t x, std::uint64_t& res);
    
    // 段管理
    Segment* getSegmentFromAddress(std::uint64_t address);
    std::size_t getNumberOfSegments() const;
    
    // 基地址
    std::uint64_t getBaseAddress() const;
    
    // 数据源
    retdec::fileformat::FileFormat* getFileFormat();
};
```

#### Segment 类

```cpp
// include/retdec/loader/loader/segment.h
class Segment {
    const SecSeg* _secSeg;          // 关联的文件段/节
    std::uint64_t _address;         // 虚拟地址（如 0x401000）
    std::uint64_t _size;            // 内存大小
    std::unique_ptr<SegmentDataSource> _dataSource;  // 数据源
};
```

### 3.4 镜像的工作流程

```
┌─────────────────────────────────────────────────────────────┐
│  1. 文件解析 (FileFormat)                                     │
│  - 解析 PE/ELF/Mach-O 文件头                                  │
│  - 提取段表、符号表等信息                                      │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  2. 镜像加载 (Image::load())                                  │
│  - 读取 ImageBase / 基地址                                    │
│  - 将文件节(Section) → 内存段(Segment)                        │
│  - 计算虚拟地址：VA = ImageBase + RVA                         │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  3. 内存访问                                                  │
│  - Decoder 通过虚拟地址读取指令                                │
│  - 地址 0x401000 → 找到对应 Segment → 读取数据                │
└─────────────────────────────────────────────────────────────┘
```

### 3.5 不同格式的镜像实现

| 格式 | 镜像类 | 特殊处理 |
|------|--------|---------|
| PE | `PeImage` | 处理 DOS/PE 头、节表、BSS |
| ELF | `ElfImage` | 处理程序头表、节头表、重定位 |
| Mach-O | `MachOImage` | 处理 Load Commands |
| Raw | `RawDataImage` | 整个文件作为一个段 |

#### PE 镜像示例

```cpp
// src/loader/loader/pe/pe_image.cpp:32
bool PeImage::load()
{
    // PE 文件默认加载到 ImageBase（如 0x400000）
    peFormat->getImageBaseAddress(imageBase);  // 0x400000
    setBaseAddress(imageBase);
    
    // 每个节转换为 Segment
    // .text RVA=0x1000 -> VA=0x401000
    // .data RVA=0x2000 -> VA=0x402000
}
```

#### ELF 镜像示例

```cpp
// src/loader/loader/elf/elf_image.cpp:40
bool ElfImage::load()
{
    // ELF 可执行文件：按程序头表(PT_LOAD)加载
    // ELF 目标文件：模拟加载，按节组织
    if (getFileFormat()->isObjectFile())
        loadRelocatableFile();
    else
        loadExecutableFile();
    
    // 基地址由第一个 LOAD 段决定
    setBaseAddress(getSegments().front()->getAddress());
}
```

### 3.6 镜像 vs FileFormat

| 对比项 | FileFormat | Image |
|--------|-----------|-------|
| **职责** | 解析文件结构 | 提供内存视图 |
| **数据组织** | 按文件偏移 | 按虚拟地址 |
| **主要用途** | 读取文件元数据 | 运行时内存访问 |
| **典型操作** | 读取段表、符号表 | 按地址读取字节 |

**简单记忆：**
- **FileFormat** = 读懂文件格式
- **Image** = 把文件"装"进内存，准备运行

### 3.7 镜像工厂

```cpp
// src/loader/image_factory.cpp
std::unique_ptr<Image> createImage(
    const std::string& filePath, 
    bool isRaw
);

std::unique_ptr<Image> createImage(
    const std::shared_ptr<FileFormat>& fileFormat
);
```

### 3.8 Image 基类

```cpp
// include/retdec/loader/loader/image.h
class Image {
protected:
    std::shared_ptr<FileFormat> _fileFormat;
    std::vector<std::unique_ptr<Segment>> _segments;
    std::uint64_t _baseAddress;
    
public:
    // 基本信息
    FileFormat* getFileFormat() const;
    Endianness getEndianness() const;
    std::size_t getByteLength() const;
    std::size_t getWordLength() const;
    
    // 段管理
    std::size_t getNumberOfSegments() const;
    const std::vector<std::unique_ptr<Segment>>& getSegments() const;
    Segment* getSegment(std::size_t index) const;
    Segment* getSegmentFromAddress(std::uint64_t address) const;
    
    // 内存访问
    bool getXByte(std::uint64_t address, std::size_t x, std::uint64_t& res);
    bool getWord(std::uint64_t address, std::uint64_t& res);
    bool getFloat(std::uint64_t address, float& res);
    bool getDouble(std::uint64_t address, double& res);
    bool getNTBS(std::uint64_t address, std::string& res);  // Null-terminated string
    bool getNTWS(std::uint64_t address, unsigned wcharSize, std::vector<std::uint64_t>& res);
    
    // 地址转换
    bool getAddressFromOffset(std::uint64_t offset, std::uint64_t& address) const;
    bool getOffsetFromAddress(std::uint64_t address, std::uint64_t& offset) const;
    
    // 基地址
    std::uint64_t getBaseAddress() const;
    void setBaseAddress(std::uint64_t baseAddress);
};
```

### 3.9 段 (Segment) 结构

```cpp
// src/loader/loader/segment.h
class Segment {
private:
    const SecSeg* _secSeg;           // 关联的文件段/节
    std::uint64_t _address;          // 虚拟地址
    std::vector<std::uint8_t> _data; // 实际数据
    bool _dataSourceInitialized;
    
public:
    // 基本信息
    const SecSeg* getSecSeg() const;
    std::uint64_t getAddress() const;
    std::uint64_t getSize() const;
    std::uint64_t getEndAddress() const;
    
    // 数据访问
    const std::uint8_t* getData() const;
    std::size_t getDataSize() const;
    bool getBytes(std::uint64_t address, std::size_t size, std::vector<std::uint8_t>& res);
    bool getByte(std::uint64_t address, std::uint8_t& byte);
    
    // 检查地址是否在段内
    bool containsAddress(std::uint64_t address) const;
    bool containsOffset(std::uint64_t offset) const;
};
```

### 3.10 各格式镜像加载

#### PE 镜像加载

```cpp
// src/loader/loader/pe/pe_image.cpp
class PeImage : public Image {
public:
    bool load() override {
        // 1. 获取基地址
        _baseAddress = _fileFormat->getImageBase();
        
        // 2. 遍历所有节
        for (auto& section : peFormat->getSections()) {
            // 3. 创建段
            auto segment = std::make_unique<Segment>();
            
            // 4. 设置虚拟地址
            segment->setAddress(_baseAddress + section->getVirtualAddress());
            
            // 5. 加载数据 (处理对齐)
            if (section->getSizeOfRawData() > 0) {
                segment->loadData(section->getOffset(), section->getSizeOfRawData());
            }
            
            // 6. 处理 BSS 节 (初始化数据为0)
            if (section->isBss()) {
                segment->allocateBss(section->getVirtualSize());
            }
            
            _segments.push_back(std::move(segment));
        }
        
        return true;
    }
};
```

#### ELF 镜像加载

```cpp
// src/loader/loader/elf/elf_image.cpp
class ElfImage : public Image {
public:
    bool load() override {
        // 1. 确定基地址
        _baseAddress = elfFormat->getImageBase();
        if (_baseAddress == 0) {
            _baseAddress = 0x08048000;  // 默认加载地址 (32位)
        }
        
        // 2. 遍历程序头表 (段)
        for (const auto& seg : elfIo->segments) {
            if (seg->get_type() != PT_LOAD) continue;
            
            auto segment = std::make_unique<Segment>();
            
            // 3. 设置虚拟地址
            segment->setAddress(seg->get_virtual_address());
            
            // 4. 加载数据
            if (seg->get_file_size() > 0) {
                segment->loadData(seg->get_offset(), seg->get_file_size());
            }
            
            // 5. 处理 BSS (内存大小 > 文件大小)
            if (seg->get_memory_size() > seg->get_file_size()) {
                segment->allocateBss(seg->get_memory_size() - seg->get_file_size());
            }
            
            _segments.push_back(std::move(segment));
        }
        
        return true;
    }
};
```

---

## 4. 符号与调试信息

### 4.1 符号表 (Symbol Table)

```cpp
// src/fileformat/types/symbol_table/symbol.h
class Symbol {
public:
    enum class Type {
        UNDEFINED_SYM,  // 未定义符号 (外部引用)
        PRIVATE,        // 私有符号
        PUBLIC,         // 公共符号
        WEAK,           // 弱符号
        EXTERN,         // 外部符号
        ABSOLUTE_SYM,   // 绝对符号
        COMMON          // 通用符号
    };
    
    enum class UsageType {
        UNKNOWN,        // 未知
        FUNCTION,       // 函数
        OBJECT          // 数据对象
    };
    
private:
    std::string name;                    // 符号名
    std::string originalName;            // 原始名 (未修饰)
    unsigned long long address;          // 虚拟地址
    unsigned long long size;             // 大小
    Type type;                           // 符号类型
    UsageType usageType;                 // 使用类型
    unsigned long long linkToSection;    // 关联的节索引
    bool thumbSymbol;                    // THUMB 符号 (ARM)
    
public:
    // 判断方法
    bool isUndefined() const;
    bool isFunction() const;
    bool isObject() const;
    bool isPublic() const;
    bool isThumbSymbol() const;
    
    // 获取方法
    const std::string& getName() const;
    unsigned long long getAddress() const;
    bool getRealAddress(unsigned long long& addr) const;  // 处理 THUMB
    bool getSize(unsigned long long& size) const;
};
```

**符号来源：**
- PE: COFF 符号表、导出表
- ELF: `.symtab`、`.dynsym`
- Mach-O: 符号表、动态符号表

### 4.2 导入表 (Import Table)

```cpp
// src/fileformat/types/import_table/import.h
class Import {
private:
    std::string name;                    // 函数名
    std::uint64_t address;               // IAT 地址
    std::size_t libraryIndex;            // 库索引
    bool isOrdinal;                      // 是否按序号导入
    std::uint64_t ordinalNumber;         // 序号
    
public:
    const std::string& getName() const;
    std::uint64_t getAddress() const;
    std::size_t getLibraryIndex() const;
    bool isOrdinalImport() const;
};

class ImportTable {
private:
    std::vector<std::string> libraries;  // 库名列表
    std::vector<std::unique_ptr<Import>> imports;
    
public:
    std::size_t getNumberOfImports() const;
    const Import* getImport(std::size_t index) const;
    std::string getLibrary(std::size_t index) const;
};
```

**PE 导入描述：**
```cpp
// PE 导入表结构
struct IMAGE_IMPORT_DESCRIPTOR {
    DWORD OriginalFirstThunk;   // INT (Import Name Table)
    DWORD TimeDateStamp;
    DWORD ForwarderChain;
    DWORD Name;                 // 库名 RVA
    DWORD FirstThunk;           // IAT (Import Address Table)
};
```

### 4.3 导出表 (Export Table)

```cpp
// src/fileformat/types/export_table/export.h
class Export {
private:
    std::string name;                    // 函数名
    std::uint64_t address;               // 导出地址
    std::uint64_t ordinalNumber;         // 序号
    bool isForwarded;                    // 是否转发
    std::string forwardedLibrary;        // 转发目标库
    std::string forwardedFunction;       // 转发目标函数
    
public:
    const std::string& getName() const;
    std::uint64_t getAddress() const;
    std::uint64_t getOrdinalNumber() const;
    bool isForwardedExport() const;
};
```

### 4.4 调试信息

#### PDB (Program Database)

```cpp
// src/fileformat/types/pdb_info/pdb_info.cpp
class PdbInfo {
public:
    // 解析 PDB 文件
    bool parsePdbFile(const std::string& pdbFilePath);
    
    // 获取函数信息
    std::vector<PdbFunction> getFunctions() const;
    
    // 获取行号信息
    bool getLineInfo(uint64_t address, std::string& file, uint32_t& line);
    
    // 获取类型信息
    std::vector<PdbType> getTypes() const;
    
    // 获取全局变量
    std::vector<PdbSymbol> getGlobalVariables() const;
};
```

**PDB 内容：**
- 函数名和地址
- 源码文件名和行号映射
- 局部变量信息
- 类型定义 (结构体、类等)
- 全局变量

#### DWARF

```cpp
// ELF 中的调试信息
class DwarfInfo {
public:
    // 解析 .debug_info 节
    bool parseDebugInfo(const uint8_t* data, size_t size);
    
    // 获取编译单元列表
    std::vector<CompileUnit> getCompileUnits() const;
    
    // 获取函数 DIE (Debug Information Entry)
    FunctionDie getFunctionDie(uint64_t address) const;
    
    // 获取变量信息
    VariableInfo getVariableInfo(const Die& die) const;
};
```

---

## 5. Providers 初始化

### 5.1 Provider 架构

```cpp
// src/bin2llvmir/optimizations/provider_init/provider_init.cpp
bool ProviderInitialization::runOnModule(Module& m) {
    // 1. 清空所有 providers
    AbiProvider::clear();
    AsmInstruction::clear();
    ConfigProvider::clear();
    DebugFormatProvider::clear();
    DemanglerProvider::clear();
    FileImageProvider::clear();
    LtiProvider::clear();
    NamesProvider::clear();
    CallingConventionProvider::clear();
    
    // 2. 初始化 Config Provider
    Config* config = ConfigProvider::addConfig(&m, *_config);
    
    // 3. 初始化 FileImage Provider
    FileImage* image = FileImageProvider::addFileImage(&m, path, config);
    
    // 4. 初始化 DebugFormat Provider
    DebugFormat* debug = DebugFormatProvider::addDebugFormat(&m, path, config);
    
    // 5. 初始化 Demangler
    DemanglerProvider::addDemangler(&m, config);
    
    // 6. 初始化 Names Provider
    NamesProvider::addNames(&m, config);
    
    // 7. 初始化 ABI Provider
    AbiProvider::addAbi(&m, config);
    
    // 8. 初始化 LTI (Library Type Information)
    LtiProvider::addLti(&m, config);
    
    // 9. 初始化 Calling Convention
    CallingConventionProvider::addCallingConvention(&m, config, image);
    
    // 10. 初始化 AsmInstruction
    AsmInstruction::init(&m);
    
    // 11. 运行 YARA 检测 (加密常量等)
    detectCryptoPatterns(&m, config, image);
    
    return false;
}
```

### 5.2 FileImage Provider

```cpp
// src/bin2llvmir/providers/fileimage.cpp
class FileImage {
private:
    llvm::Module* _module;
    std::unique_ptr<retdec::loader::Image> _image;
    retdec::rtti_finder::RttiFinder _rtti;
    
public:
    // 获取内存镜像
    retdec::loader::Image* getImage() const;
    retdec::fileformat::FileFormat* getFileFormat() const;
    
    // 读取常量
    ConstantInt* getConstantInt(IntegerType* t, Address addr);
    Constant* getConstantFloat(Address addr);
    Constant* getConstantDouble(Address addr);
    Constant* getConstantCharPointer(Address addr);  // 字符串
    Constant* getConstant(Type* type, Address addr);
    
    // RTTI 信息
    const RttiFinder& getRtti() const;
    
    // 判断是否终止函数
    bool isImportTerminating(const Import* imp) const;
};
```

### 5.3 DebugFormat Provider

```cpp
// src/bin2llvmir/providers/debugformat.h
class DebugFormat {
public:
    // 获取函数名
    std::string getFunctionName(uint64_t address) const;
    
    // 获取变量名
    std::string getVariableName(uint64_t address) const;
    
    // 获取类型信息
    TypeInfo getType(uint64_t address) const;
    
    // 获取行号信息
    bool getLine(uint64_t address, std::string& file, uint32_t& line) const;
    
    // 获取函数范围
    bool getFunctionRange(uint64_t address, uint64_t& start, uint64_t& end) const;
};
```

### 5.4 Names Provider

```cpp
// src/bin2llvmir/providers/names.h
class NameContainer {
public:
    // 添加名称
    void addName(uint64_t address, const std::string& name);
    void addFunctionName(uint64_t address, const std::string& name);
    void addGlobalVariableName(uint64_t address, const std::string& name);
    
    // 获取名称
    std::string getName(uint64_t address) const;
    bool hasName(uint64_t address) const;
    
    // 从符号表加载
    void loadFromSymbolTable(const SymbolTable& symTab);
    void loadFromImportTable(const ImportTable& impTab);
    void loadFromExportTable(const ExportTable& expTab);
    void loadFromDebug(const DebugFormat& debug);
};
```

---

## 6. 函数识别流程

### 6.1 函数来源

```cpp
void initConfigFunctions(Config* config, FileImage* image) {
    auto& ff = image->getFileFormat();
    
    // 1. 从符号表获取函数
    if (auto* symTab = ff->getSymbolTable()) {
        for (const auto& sym : *symTab) {
            if (sym->isFunction() && !sym->isUndefined()) {
                config->addFunction(sym->getAddress(), sym->getName());
            }
        }
    }
    
    // 2. 从导出表获取函数
    if (auto* expTab = ff->getExportTable()) {
        for (const auto& exp : *expTab) {
            config->addFunction(exp->getAddress(), exp->getName());
        }
    }
    
    // 3. 从调试信息获取函数
    if (auto* debug = DebugFormatProvider::getDebugFormat()) {
        for (auto& func : debug->getFunctions()) {
            config->addFunction(func.address, func.name);
        }
    }
    
    // 4. 从导入表记录桩函数
    if (auto* impTab = ff->getImportTable()) {
        for (const auto& imp : *impTab) {
            config->addImportFunction(imp->getAddress(), 
                imp->getLibraryName(), imp->getName());
        }
    }
}
```

### 6.2 入口点识别

```cpp
void detectEntryPoint(Config* config, FileImage* image) {
    auto& ff = image->getFileFormat();
    
    // PE: AddressOfEntryPoint
    if (ff->isPe()) {
        auto ep = ff->getEntryPoint();
        config->setEntryPoint(ep);
        config->addFunction(ep, "entry_point");
    }
    
    // ELF: e_entry
    else if (ff->isElf()) {
        auto ep = ff->getEntryPoint();
        config->setEntryPoint(ep);
        config->addFunction(ep, "_start");
    }
    
    // Mach-O: entryoff
    else if (ff->isMacho()) {
        auto ep = ff->getEntryPoint();
        config->setEntryPoint(ep);
        config->addFunction(ep, "start");
    }
}
```

---

## 7. RTTI 信息处理

RetDec 有一个专门的模块 `rtti-finder` 用于处理 C++ RTTI（Run-Time Type Information）信息，支持 GCC/Clang 和 MSVC 两种格式。

### 7.1 RTTI 处理流程

```
┌─────────────────────────────────────────────────────────────────┐
│  1. 虚表发现 (vtable_finder.cpp)                                 │
│  - 扫描数据段寻找可能的虚表结构                                    │
│  - 特征：连续的有效代码指针                                        │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│  2. RTTI 解析                                                    │
│  - GCC: parseGccRtti()    → 解析 type_info 结构                 │
│  - MSVC: parseMsvcRtti()  → 解析 RTTI Complete Object Locator   │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│  3. 信息提取                                                     │
│  - 类名 (demangled)                                              │
│  - 继承关系 (基类信息)                                            │
│  - 虚函数地址列表                                                 │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│  4. 应用                                                         │
│  - 函数识别 (虚表中的函数指针)                                     │
│  - 类层次结构重建                                                 │
│  - 变量类型推断                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### 7.2 支持的 RTTI 格式

| 编译器 | 支持情况 | 主要结构 |
|--------|---------|---------|
| **GCC/Clang** | ✅ 完整支持 | `type_info`, `si_class_type_info`, `vmi_class_type_info` |
| **MSVC** | ✅ 完整支持 | `RTTITypeDescriptor`, `RTTIClassHierarchyDescriptor`, `RTTIBaseClassDescriptor` |

### 7.3 核心组件

#### RTTI Finder 入口

```cpp
// src/rtti-finder/rtti_finder.cpp
class RttiFinder {
public:
    // 查找 GCC/Clang RTTI
    void findGcc(const retdec::loader::Image* img);
    
    // 查找 MSVC RTTI
    void findMsvc(const retdec::loader::Image* img);
    
    // 获取解析后的虚表
    const VtablesGcc& getVtablesGcc() const;
    const VtablesMsvc& getVtablesMsvc() const;
    
    // 获取 RTTI 信息
    const RttiGcc& getRttiGcc() const;
    const RttiMsvc& getRttiMsvc() const;
};
```

#### GCC RTTI 解析

```cpp
// src/rtti-finder/rtti/rtti_gcc_parser.cpp
std::shared_ptr<ClassTypeInfo> parseGccRtti(
    const retdec::loader::Image* img,
    RttiGcc& rttis,
    Address rttiAddr,
    std::set<Address>& visited)
{
    // 读取 vptr (指向 type_info 虚表)
    std::uint64_t vptrAddr = 0;
    img->getWord(addr, vptrAddr);
    addr += wordSize;
    
    // 读取类型名称
    std::uint64_t nameAddr = 0;
    img->getWord(addr, nameAddr);
    std::string name;
    img->getNTBS(nameAddr, name);  // 读取 C 字符串
    
    // 解析基类信息
    // - SiClassTypeInfo: 单继承
    // - VmiClassTypeInfo: 多继承（虚拟内存继承）
}
```

#### MSVC RTTI 解析

```cpp
// src/rtti-finder/rtti/rtti_msvc_parser.cpp
RTTICompleteObjectLocator* parseMsvcRtti(
    const retdec::loader::Image* img,
    RttiMsvc& rttis,
    Address colAddr)
{
    // 解析 RTTI Complete Object Locator
    // 包含：signature, offset, cdOffset, 
    //       typeDescriptorAddr, classDescriptorAddr, objectBase
    
    // 解析 Type Descriptor → 获取类名
    // .?AVClassName@@ (decorated name)
    
    // 解析 Class Hierarchy Descriptor → 获取继承层次
}
```

### 7.4 虚表查找算法

```cpp
// src/rtti-finder/vtable/vtable_finder.cpp

void findPossibleVtables(
    const retdec::loader::Image* img,
    std::set<Address>& possibleVtables,
    bool gcc)
{
    for (auto& seg : img->getSegments())
    {
        // 只在数据段中查找
        if (!seg->getSecSeg()->isSomeData())
            continue;
        
        // 扫描段内所有可能的虚表
        // 特征：连续的有效代码指针
        while (addr + wordSz < end)
        {
            // GCC 虚表：第一个条目为 0（偏移量）
            // MSVC 虚表：直接开始函数指针
            
            if (img->isPointer(item1) && img->isPointer(item2))
            {
                possibleVtables.insert(item2);
            }
        }
    }
}

// 填充虚表条目
bool fillVtable(const retdec::loader::Image* img, 
                Address a, Vtable& vt)
{
    // 连续读取函数指针直到非指针或重复
    while (img->isPointer(a, &ptr))
    {
        // 验证指针指向代码段
        auto* seg = img->getSegmentFromAddress(ptr);
        if (!seg || !seg->getSecSeg()->isSomeCode())
            break;
        
        vt.items.emplace(VtableItem(a, ptr));
        a += bytesPerWord;
    }
}
```

### 7.5 RTTI 在反编译中的应用

#### A. 函数识别（通过虚表）

```cpp
// src/bin2llvmir/optimizations/decoder/decoder_init.cpp:991
void Decoder::initVtables()
{
    // 收集 GCC 和 MSVC 风格的虚表
    for (auto& p : _image->getRtti().getVtablesGcc())
        vtable.push_back(&p.second);
    for (auto& p : _image->getRtti().getVtablesMsvc())
        vtable.push_back(&p.second);
    
    // 从虚表中提取函数指针
    for (auto* p : vtable)
    {
        for (auto& item : vt.items)
        {
            // 虚表中的每个条目都是一个函数地址
            if (auto* jt = _jumpTargets.push(
                    item.functionAddress,
                    JumpTarget::eType::VTABLE))
            {
                auto* nf = createFunction(jt->getAddress());
            }
        }
    }
}
```

#### B. 类层次结构分析

```cpp
// src/bin2llvmir/optimizations/class_hierarchy/hierarchy.cpp
void ClassHierarchy::analyze()
{
    // 使用 RTTI 信息重建类继承关系
    // - 基类指针
    // - 多继承布局
    // - 虚继承关系
}
```

#### C. 类型推断

```cpp
// 通过虚表指针识别对象类型
void* obj = ...;
void** vptr = *(void***)obj;  // 读取虚表指针

// 查找对应的 RTTI 信息
auto* vtable = rttiFinder.getVtable((Address)vptr);
if (vtable && vtable->rtti)
{
    std::string className = vtable->rtti->name;
    // 现在知道 obj 是 className 类型
}
```

### 7.6 虚表数据结构示例

#### GCC 虚表结构
```
地址        内容                    说明
0x403000    0x00000000              (偏移量，GCC)
0x403004    0x402000    ─┐          RTTI 信息指针 → type_info
0x403008    0x401000    ─┼──>      虚函数 1 (method1)
0x40300C    0x401010    ─┤          虚函数 2 (method2)
0x403010    0x401020    ─┘          虚函数 3 (method3)
```

#### MSVC 虚表结构
```
地址        内容                    说明
0x403000    0x402000    ───>        RTTI Complete Object Locator
0x403004    0x401000               虚函数 1
0x403008    0x401010               虚函数 2
0x40300C    0x401020               虚函数 3
```

### 7.7 FileImage 中的 RTTI

```cpp
// src/bin2llvmir/providers/fileimage.cpp
class FileImage {
private:
    retdec::rtti_finder::RttiFinder _rtti;
    
public:
    void initRtti(Config* config)
    {
        if (config->getConfig().tools.isMsvc())
        {
            _rtti.findMsvc(getImage());
        }
        else
        {
            _rtti.findGcc(getImage());
        }
    }
    
    const RttiFinder& getRtti() const
    {
        return _rtti;
    }
};
```

### 7.8 限制与注意事项

| 限制 | 说明 |
|------|------|
| 编译选项 | 需要二进制文件包含完整的 RTTI 信息（编译时未使用 `-fno-rtti`） |
| 混淆代码 | 对于严重混淆或剥离的代码，RTTI 可能被破坏 |
| 虚表完整性 | 如果虚表被修改或部分损坏，解析可能失败 |

---

## 8. 数据提取

### 8.1 字符串提取

```cpp
// src/fileformat/types/strings/string.cpp
void FileFormat::getStrings(std::set<String>& result, std::size_t minLength) {
    // 扫描所有段/节的数据
    for (const auto& sec : getSections()) {
        if (sec->isCode()) continue;  // 跳过代码段
        
        const auto& data = sec->getBytes();
        std::size_t offset = 0;
        
        while (offset < data.size()) {
            // 寻找可打印字符序列
            std::size_t start = offset;
            while (offset < data.size() && isPrintable(data[offset])) {
                offset++;
            }
            
            if (offset - start >= minLength) {
                String str;
                str.setContent(std::string(data.begin() + start, data.begin() + offset));
                str.setAddress(sec->getAddress() + start);
                result.insert(str);
            }
            
            offset++;
        }
    }
}
```

### 8.2 资源提取 (PE)

```cpp
// src/fileformat/types/resource_table/resource_table.cpp
class ResourceTable {
public:
    // 遍历资源树
    void iterateResources(const std::function<void(const Resource&)>& callback);
    
    // 获取特定资源
    std::vector<Resource> getResourcesOfType(const std::string& type);
    
    // 常见资源类型
    static const char* RT_CURSOR = "CURSOR";
    static const char* RT_BITMAP = "BITMAP";
    static const char* RT_ICON = "ICON";
    static const char* RT_MENU = "MENU";
    static const char* RT_DIALOG = "DIALOG";
    static const char* RT_STRING = "STRING";
    static const char* RT_VERSION = "VERSION";
    static const char* RT_MANIFEST = "MANIFEST";
};
```

---

## 9. 初始化时序图

```
User
  │
  │ retdec-decompiler input.exe
  │
  ▼
┌──────────────────────┐
│  1. 创建 FileFormat   │
│     - detectFileFormat │
│     - PeFormat::ctor   │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│  2. 创建 Image        │
│     - createImage     │
│     - PeImage::load   │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│  3. ProviderInit      │
│     - Config          │
│     - FileImage       │
│     - DebugFormat     │
│     - Names           │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│  4. Decoder           │
│     - 读取函数列表     │
│     - 反汇编代码       │
│     - 生成 LLVM IR    │
└──────────┬───────────┘
           │
           ▼
        Output.ll
```


---

## 10. 参考文件

| 组件 | 关键文件 |
|------|----------|
| 格式检测 | `src/fileformat/utils/format_detection.cpp` |
| 格式工厂 | `src/fileformat/format_factory.cpp` |
| PE 解析 | `src/fileformat/file_format/pe/pe_format.cpp` |
| ELF 解析 | `src/fileformat/file_format/elf/elf_format.cpp` |
| 镜像工厂 | `src/loader/image_factory.cpp` |
| PE 加载 | `src/loader/loader/pe/pe_image.cpp` |
| ELF 加载 | `src/loader/loader/elf/elf_image.cpp` |
| Provider 初始化 | `src/bin2llvmir/optimizations/provider_init/provider_init.cpp` |
| FileImage Provider | `src/bin2llvmir/providers/fileimage.cpp` |
| 解码器 | `src/bin2llvmir/optimizations/decoder/decoder.cpp` |
| **RTTI Finder** | `src/rtti-finder/rtti_finder.cpp` |
| **GCC RTTI 解析** | `src/rtti-finder/rtti/rtti_gcc_parser.cpp` |
| **MSVC RTTI 解析** | `src/rtti-finder/rtti/rtti_msvc_parser.cpp` |
| **虚表查找** | `src/rtti-finder/vtable/vtable_finder.cpp` |
| 类层次分析 | `src/bin2llvmir/optimizations/class_hierarchy/hierarchy.cpp` |
| 虚表函数识别 | `src/bin2llvmir/optimizations/decoder/decoder_init.cpp` |
