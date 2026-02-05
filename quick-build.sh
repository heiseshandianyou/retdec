#!/bin/bash

# RetDec 快速增量构建脚本 (开发使用)
# 不清理 build 目录，只编译修改的文件

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"

echo "=========================================="
echo "RetDec 快速增量构建"
echo "=========================================="

# 检查 build 目录是否存在
if [ ! -d "${BUILD_DIR}" ]; then
    echo "错误: build 目录不存在，请先运行 ./build.sh 进行首次构建"
    exit 1
fi

cd "${BUILD_DIR}"

# 设置环境变量
export CMAKE_POLICY_VERSION_MINIMUM=3.5

# 如果 CMakeLists.txt 有修改，重新配置
if [ "${SCRIPT_DIR}/CMakeLists.txt" -nt "${BUILD_DIR}/CMakeCache.txt" ]; then
    echo "[1/2] CMakeLists.txt 有修改，重新配置..."
    cmake ..
else
    echo "[1/2] 跳过 CMake 配置 (无变更)"
fi

# 增量编译 - 只编译修改的文件
echo "[2/2] 增量编译 (只编译修改的文件)..."
echo "      使用 $(nproc) 个并行任务"
make -j"$(nproc)"

echo ""
echo "=========================================="
echo "增量构建完成！"
echo "=========================================="
