#!/bin/bash

# RetDec 构建脚本 (CMake 4.0+ 兼容版本)

set -e  # 遇到错误立即退出

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"

echo "=========================================="
echo "RetDec 构建脚本"
echo "=========================================="

# 清理构建目录
echo "[1/4] 清理构建目录..."
if [ -d "${BUILD_DIR}" ]; then
    rm -rf "${BUILD_DIR}"/*
    echo "      已清理: ${BUILD_DIR}"
else
    mkdir -p "${BUILD_DIR}"
    echo "      已创建: ${BUILD_DIR}"
fi

# 进入构建目录
cd "${BUILD_DIR}"

# 设置 CMake 4.0+ 兼容环境变量
echo "[2/4] 设置 CMake 兼容环境变量..."
export CMAKE_POLICY_VERSION_MINIMUM=3.5
echo "      CMAKE_POLICY_VERSION_MINIMUM=3.5"

# 运行 CMake 配置
echo "[3/4] 运行 CMake 配置..."
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="${SCRIPT_DIR}/retdec-install"

echo "      CMake 配置完成"

# 编译
echo "[4/4] 开始编译..."
echo "      使用 $(nproc) 个并行任务"
make -j"$(nproc)"

echo ""
echo "=========================================="
echo "构建完成！"
echo "=========================================="
echo "安装目录: ${SCRIPT_DIR}/retdec-install"
echo ""
