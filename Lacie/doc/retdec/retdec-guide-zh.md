# RetDec 反编译器项目指南

## 项目概述

**RetDec**（Retargetable Decompiler）是一个基于 LLVM 的可重定向机器码反编译器，由 Avast 软件公司开发并开源。

> **⚠️ 维护状态警告**
> 
> 该项目目前处于**有限维护模式**，由于资源不足：
> - 欢迎提交 Pull Request，会优先审查
> - Issue 可能会有长达一个季度的延迟响应
> - 仅进行基础项目维护
> - 只有非常有限的开发工作在进行

### 核心特性

- **多文件格式支持**：ELF、PE、Mach-O、COFF、AR（归档）、Intel HEX 和原始机器码
- **多架构支持**：
  - 32位：Intel x86、ARM、MIPS、PIC32、PowerPC
  - 64位：x86-64、ARM64（AArch64）
- **静态分析**：提供可执行文件的详细信息
- **编译器和加壳器检测**
- **加载和指令解码**
- **静态链接库代码移除**：基于签名
- **调试信息提取**：支持 DWARF、PDB
- **指令惯用语重建**
- **C++ 类层次结构检测与重建**（RTTI、虚表）
- **符号还原**（Demangling）：支持 GCC、MSVC、Borland
- **函数、类型和高级结构重建**
- **集成反汇编器**
- **多语言输出**：C 语言和类 Python 语言
- **图形生成**：调用图、控制流图和各种统计信息

---

## 文件结构

```
retdec/
├── cmake/                  # CMake 构建脚本
├── deps/                   # 第三方依赖库
│   ├── authenticode-parser/  # 签名解析
│   ├── capstone/            # 反汇编引擎
│   ├── eigen/               # 线性代数库
│   ├── elfio/               # ELF 文件处理
│   ├── googletest/          # 测试框架
│   ├── keystone/            # 汇编引擎
│   ├── llvm/                # LLVM 编译器基础设施
│   ├── rapidjson/           # JSON 解析
│   ├── stb/                 # 图像处理库
│   ├── tinyxml2/            # XML 解析
│   ├── tlsh/                # 局部敏感哈希
│   ├── whereami/            # 路径获取工具
│   ├── yara/                # 模式匹配引擎
│   └── yaramod/             # YARA 规则模块
├── doc/                    # 文档
│   └── doxygen/            # API 文档配置
├── include/retdec/         # 公共头文件
│   ├── ar-extractor/       # AR 归档提取器
│   ├── bin2llvmir/         # 二进制转 LLVM IR
│   ├── capstone2llvmir/    # Capstone 转 LLVM IR
│   ├── common/             # 通用工具
│   ├── config/             # 配置管理
│   ├── cpdetect/           # 编译器检测
│   ├── ctypes/             # C 类型系统
│   ├── ctypesparser/       # C 类型解析器
│   ├── debugformat/        # 调试格式处理
│   ├── demangler/          # 符号还原
│   ├── fileformat/         # 文件格式处理
│   ├── llvmir2hll/         # LLVM IR 转高级语言
│   ├── llvmir-emul/        # LLVM IR 模拟器
│   ├── loader/             # 二进制加载器
│   ├── macho-extractor/    # Mach-O 提取器
│   ├── patterngen/         # 模式生成
│   ├── pdbparser/          # PDB 解析器
│   ├── pelib/              # PE 库
│   ├── rtti-finder/        # RTTI 查找器
│   ├── serdes/             # 序列化/反序列化
│   ├── stacofin/           # 静态分析框架
│   ├── unpacker/           # 脱壳器
│   ├── utils/              # 工具函数
│   └── yaracpp/            # YARA C++ 接口
├── scripts/                # Python 脚本工具
│   ├── retdec-archive-decompiler.py  # 归档反编译
│   ├── retdec-fileinfo.py            # 文件信息获取
│   ├── retdec-signature-from-library-creator.py  # 签名创建
│   ├── retdec-tests-runner.py        # 测试运行器
│   ├── retdec-unpacker.py            # 脱壳工具
│   ├── retdec-utils.py               # 工具函数
│   └── type_extractor/               # 类型提取器
├── src/                    # 源代码
│   ├── ar-extractor/       # AR 归档提取器
│   ├── ar-extractortool/   # AR 提取工具
│   ├── bin2llvmir/         # 二进制到 LLVM IR 转换
│   ├── bin2pat/            # 二进制到模式
│   ├── capstone2llvmir/    # Capstone 到 LLVM IR
│   ├── capstone2llvmirtool/# Capstone 工具
│   ├── common/             # 通用代码
│   ├── config/             # 配置管理
│   ├── cpdetect/           # 编译器检测
│   ├── ctypes/             # C 类型
│   ├── ctypesparser/       # C 类型解析
│   ├── debugformat/        # 调试格式
│   ├── demangler/          # 符号还原库
│   ├── demanglertool/      # 符号还原工具
│   ├── fileformat/         # 文件格式处理
│   ├── fileinfo/           # 文件信息工具
│   ├── getsig/             # 签名获取
│   ├── idr2pat/            # IDR 到模式
│   ├── llvmir2hll/         # LLVM IR 到高级语言
│   ├── llvmir-emul/        # LLVM IR 模拟
│   ├── loader/             # 二进制加载器
│   ├── macho-extractor/    # Mach-O 提取器
│   ├── macho-extractortool/# Mach-O 提取工具
│   ├── pat2yara/           # 模式到 YARA
│   ├── patterngen/         # 模式生成
│   ├── pdbparser/          # PDB 解析
│   ├── pelib/              # PE 库
│   ├── retdec/             # 主库
│   ├── retdec-decompiler/  # 反编译器主程序
│   ├── retdectool/         # 工具库
│   ├── rtti-finder/        # RTTI 查找
│   ├── serdes/             # 序列化
│   ├── stacofin/           # 静态分析
│   ├── stacofintool/       # 静态分析工具
│   ├── unpacker/           # 脱壳器
│   ├── unpackertool/       # 脱壳工具
│   ├── utils/              # 工具函数
│   └── yaracpp/            # YARA C++ 接口
├── support/                # 支持文件
├── tests/                  # 测试代码
├── CMakeLists.txt          # 主 CMake 配置
├── CHANGELOG.md            # 更新日志
├── LICENSE                 # MIT 许可证
├── LICENSE-PELIB           # PeLib 许可证
├── LICENSE-THIRD-PARTY     # 第三方许可证
├── README.md               # 英文 readme
├── Dockerfile              # Docker 配置
└── Dockerfile.dev          # 开发 Docker 配置
```

---

## 使用方法

### 安装方式

有两种方式获取 RetDec：

1. **预编译包**（推荐）
   - 下载稳定版：[Releases 页面](https://github.com/avast/retdec/releases)
   - 或下载夜间构建版：[TeamCity 构建](https://retdec-tc.avast.com)

2. **从源码构建**（见下文构建说明）

安装后需要约 **5-6 GB** 磁盘空间。

### 基本使用

#### Linux/macOS/FreeBSD

```bash
# 基本反编译
$RETDEC_INSTALL_DIR/bin/retdec-decompiler <二进制文件>

# 查看帮助
$RETDEC_INSTALL_DIR/bin/retdec-decompiler --help
```

#### Windows

```cmd
# 基本反编译
%RETDEC_INSTALL_DIR%\bin\retdec-decompiler.exe <二进制文件>

# 查看帮助
%RETDEC_INSTALL_DIR%\bin\retdec-decompiler.exe --help
```

### 可选依赖

- **UPX**：[UPX 官网](https://upx.github.io/) - 用于预处理阶段的 UPX 脱壳
- **Graphviz**：[Graphviz 官网](http://www.graphviz.org/) - 用于生成调用图和控制流图

### 常用参数

```bash
# 基本反编译
retdec-decompiler test.exe

# 生成调试输出
retdec-decompiler --verbose test.exe

# 指定输出文件
retdec-decompiler -o output.c test.exe

# 生成调用图
retdec-decompiler --graph-format png test.exe
```

---

## 构建说明

### 系统要求

#### Linux

- C++17 支持的编译器（GCC >= 7）
- CMake >= 3.6
- Git
- OpenSSL >= 1.1.1
- Python >= 3.4
- autotools（autoconf、automake、libtool）
- pkg-config
- m4
- zlib

**Debian/Ubuntu 安装命令：**
```bash
sudo apt-get install build-essential cmake git openssl libssl-dev \
    python3 autoconf automake libtool pkg-config m4 zlib1g-dev \
    upx doxygen graphviz
```

**Fedora 安装命令：**
```bash
sudo dnf install gcc gcc-c++ cmake make git openssl openssl-devel \
    python3 autoconf automake libtool pkg-config m4 zlib-devel \
    upx doxygen graphviz
```

**Arch Linux 安装命令：**
```bash
sudo pacman --needed -S base-devel cmake git openssl python3 \
    autoconf automake libtool pkg-config m4 zlib upx doxygen graphviz
```

#### Windows

- Visual Studio 2017 15.7 或更高版本
- CMake >= 3.6
- Git
- OpenSSL >= 1.1.1
- Python >= 3.4

#### macOS

- macOS >= 10.15
- 完整的 Xcode 安装（包含命令行工具）
- CMake >= 3.6
- Git
- OpenSSL >= 1.1.1
- Python >= 3.4
- autotools

**Homebrew 安装命令：**
```bash
brew install cmake git openssl python3 autoconf automake libtool
```

### 构建步骤

#### Linux/macOS

```bash
# 克隆仓库
git clone https://github.com/avast/retdec
cd retdec

# 创建构建目录
mkdir build && cd build

# 配置（指定安装路径）
cmake .. -DCMAKE_INSTALL_PREFIX=<安装路径>

# 编译（N = 并行任务数，通常为核心数 + 1）
make -jN

# 安装
make install
```

#### Windows

```cmd
# 克隆仓库
git clone https://github.com/avast/retdec
cd retdec

# 创建构建目录
mkdir build && cd build

# 配置（32位或64位）
cmake .. -DCMAKE_INSTALL_PREFIX=<安装路径> -G"Visual Studio 15 2017"
cmake .. -DCMAKE_INSTALL_PREFIX=<安装路径> -G"Visual Studio 15 2017 Win64"

# 编译
cmake --build . --config Release -- -m
cmake --build . --config Release --target install
```

### CMake 配置选项

| 选项 | 说明 | 默认值 |
|------|------|--------|
| `-DCMAKE_INSTALL_PREFIX=<path>` | 安装路径 | - |
| `-DRETDEC_DOC=ON` | 构建 API 文档 | OFF |
| `-DRETDEC_TESTS=ON` | 构建测试 | OFF |
| `-DRETDEC_DEV_TOOLS=ON` | 构建开发工具 | OFF |
| `-DRETDEC_COMPILE_YARA=OFF` | 禁用 YARA 规则编译 | ON |
| `-DCMAKE_BUILD_TYPE=Debug` | 调试构建 | Release |
| `-DRETDEC_ENABLE_<component>=ON` | 启用特定组件 | 全部启用 |

---

## Docker 使用

### 构建镜像

```bash
# 从 master 分支构建
docker build -t retdec - < Dockerfile

# 从本地源码构建
docker build -t retdec:dev . -f Dockerfile.dev
```

### 运行容器

```bash
# 准备目录（如果 uid 不是 1000）
chmod 0777 /path/to/local/directory

# 运行反编译器
docker run --rm -v /path/to/local/directory:/destination \
    retdec retdec-decompiler /destination/二进制文件
```

---

## Python 脚本工具

RetDec 提供了多个 Python 辅助脚本：

| 脚本 | 用途 |
|------|------|
| `retdec-archive-decompiler.py` | 批量反编译归档文件 |
| `retdec-fileinfo.py` | 获取文件详细信息 |
| `retdec-signature-from-library-creator.py` | 从库创建签名 |
| `retdec-tests-runner.py` | 运行回归测试 |
| `retdec-unpacker.py` | 脱壳工具 |

---

## 相关项目

- [retdec-idaplugin](https://github.com/avast/retdec-idaplugin) - IDA Pro 插件
- [retdec-r2plugin](https://github.com/avast/retdec-r2plugin) - Radare2 插件
- [retdec-regression-tests-framework](https://github.com/avast/retdec-regression-tests-framework) - 回归测试框架
- [retdec-regression-tests](https://github.com/avast/retdec-regression-tests) - 回归测试套件
- [vim-syntax-retdecdsm](https://github.com/s3rvac/vim-syntax-retdecdsm) - Vim 语法高亮

---

## 许可证

- **RetDec**：MIT 许可证
- **PeLib**：zlib/libpng 许可证
- **第三方库**：见 `LICENSE-THIRD-PARTY` 文件

---

## 参考资料

- 官方网站：[retdec.com](https://retdec.com/)
- GitHub 仓库：[github.com/avast/retdec](https://github.com/avast/retdec)
- Wiki 文档：[GitHub Wiki](https://github.com/avast/retdec/wiki)
- 出版物：[retdec.com/publications](https://retdec.com/publications/)
- API 文档：[Doxygen 文档](https://retdec-tc.avast.com/repository/download/Retdec_DoxygenBuild/.lastSuccessful/build/doc/doxygen/html/index.html?guest=1)

### 演讲资料

- Botconf 2017：[幻灯片](https://retdec.com/static/publications/retdec-slides-botconf-2017.pdf) | [视频](https://www.youtube.com/watch?v=HHFvtt5b6yY)
- REcon Montreal 2018：[幻灯片](https://retdec.com/static/publications/retdec-slides-recon-2018.pdf)
