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

---

## 3. 内存镜像加载层 (Loader)

### 3.1 镜像工厂

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

### 3.2 Image 基类

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

### 3.3 段 (Segment) 结构

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

### 3.4 各格式镜像加载

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

## 7. 数据提取

### 7.1 字符串提取

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

### 7.2 资源提取 (PE)

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

## 8. 初始化时序图

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

## 9. 参考文件

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
