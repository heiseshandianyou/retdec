#!/bin/bash
# Memory Access Instructions Disassembly Test
# 测试只经过 decoder pass 后，内存访问指令的反汇编结果
#
# Usage: ./test.sh [all|build|analyze|clean]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILDS_DIR="$SCRIPT_DIR/builds"
OUTPUT_DIR="$SCRIPT_DIR/output"

# RetDec paths (adjust as needed)
RETDEC_ROOT="${RETDEC_ROOT:-$SCRIPT_DIR/../../../../build}"
RETDEC_BIN="$RETDEC_ROOT/src/retdec-decompiler/retdec-decompiler"
RETDEC_SHARE="$RETDEC_ROOT/share/retdec"

# Test binary name
TEST_NAME="test_memory_access"
SRC_FILE="$SCRIPT_DIR/${TEST_NAME}.c"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Compiler settings
CC=${CC:-gcc}
# 不含调试信息的编译选项
CFLAGS="-O0 -fno-inline -fno-optimize-sibling-calls -Wall"

print_header() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
}

print_section() {
    echo -e "${BLUE}$1${NC}"
    echo "----------------------------------------"
}

# Generate config file
generate_config() {
    local out_file="$1"
    cat > "$out_file" <<EOF
{
    "decompParams": {
        "verboseOut": true,
        "outputFormat": "plain",
        "keepAllFuncs": true,
        "outputLlFile": "$OUTPUT_DIR/${TEST_NAME}.ll",
        "ordinalNumDirectory": "$RETDEC_SHARE/support/ordinals/",
        "staticSignPaths": ["$RETDEC_SHARE/support/generic/yara_patterns/static-code/"],
        "llvmPasses" : [
            "retdec-provider-init",
            "retdec-decoder",
            "verify",
            "retdec-write-ll"
        ]
    }
}
EOF
}

# Build test binary
build_test() {
    print_header "Building Test Binary"
    echo "Compiler: $CC"
    echo "Flags: $CFLAGS (no debug info)"
    echo ""
    
    mkdir -p "$BUILDS_DIR"
    
    local binary="$BUILDS_DIR/${TEST_NAME}"
    local binary_stripped="$BUILDS_DIR/${TEST_NAME}_stripped"
    
    # 编译（不含调试信息）
    if $CC $CFLAGS -o "$binary" "$SRC_FILE" -lm 2>/dev/null; then
        echo -e "${GREEN}[OK]${NC} Compiled: $binary"
    else
        echo -e "${RED}[FAIL]${NC} Compilation failed"
        return 1
    fi
    
    # 创建 stripped 版本
    cp "$binary" "$binary_stripped"
    strip --strip-all "$binary_stripped" 2>/dev/null || true
    echo -e "${GREEN}[OK]${NC} Stripped: $binary_stripped"
    
    # 显示文件信息
    echo ""
    echo "File info:"
    ls -lh "$binary" "$binary_stripped"
    echo ""
    file "$binary_stripped"
    
    return 0
}

# Disassemble with objdump (Intel format)
analyze_objdump() {
    print_section "1. Objdump Disassembly Analysis (Intel Syntax)"
    
    local binary="$BUILDS_DIR/${TEST_NAME}_stripped"
    local asm_file="$OUTPUT_DIR/${TEST_NAME}_objdump.asm"
    
    echo "Binary: $binary"
    echo "Output: $asm_file"
    echo "Format: Intel"
    echo ""
    
    # 完整反汇编 (Intel 格式)
    objdump -d -M intel "$binary" > "$asm_file" 2>/dev/null
    
    # 统计各种内存访问指令
    echo "Memory Access Instructions Count:"
    echo "----------------------------------------"
    
    # x86/x64 内存访问指令模式 (Intel 格式)
    local mov_count=$(grep -cE "\bmov\b" "$asm_file" 2>/dev/null || echo "0")
    local movq_count=$(grep -cE "\bmovq\b" "$asm_file" 2>/dev/null || echo "0")
    local movl_count=$(grep -cE "\bmovl\b" "$asm_file" 2>/dev/null || echo "0")
    local lea_count=$(grep -cE "\blea\b" "$asm_file" 2>/dev/null || echo "0")
    local push_count=$(grep -cE "\bpush\b" "$asm_file" 2>/dev/null || echo "0")
    local pop_count=$(grep -cE "\bpop\b" "$asm_file" 2>/dev/null || echo "0")
    local call_count=$(grep -cE "\bcall\b" "$asm_file" 2>/dev/null || echo "0")
    local ret_count=$(grep -cE "\bret\b" "$asm_file" 2>/dev/null || echo "0")
    
    # 内存加载指令 (mov rax, [rbx])
    local load_count=$(grep -cE "mov\s+\w+,\s*\[" "$asm_file" 2>/dev/null || echo "0")
    # 内存存储指令 (mov [rbx], rax)
    local store_count=$(grep -cE "mov\s+\[.*\]," "$asm_file" 2>/dev/null || echo "0")
    
    printf "  mov instructions:      %4d\n" $mov_count
    printf "  movq instructions:     %4d\n" $movq_count
    printf "  movl instructions:     %4d\n" $movl_count
    printf "  lea instructions:      %4d (address calculation)\n" $lea_count
    printf "  push instructions:     %4d (stack store)\n" $push_count
    printf "  pop instructions:      %4d (stack load)\n" $pop_count
    printf "  call instructions:     %4d\n" $call_count
    printf "  ret instructions:      %4d\n" $ret_count
    printf "  load from memory:      ~%3d\n" $load_count
    printf "  store to memory:       ~%3d\n" $store_count
    
    echo ""
    echo -e "${GREEN}[OK]${NC} Objdump analysis saved to: $asm_file"
    
    # 提取一些示例内存访问指令
    echo ""
    echo "Sample Memory Access Instructions (first 10):"
    echo "----------------------------------------"
    grep -E "mov\s+\w+,\s*\[|mov\s+\[" "$asm_file" 2>/dev/null | head -10 || echo "  (no matches)"
}

# Run RetDec decoder only
analyze_retdec() {
    print_section "2. RetDec Decoder Analysis"
    
    local binary="$BUILDS_DIR/${TEST_NAME}_stripped"
    local out_dir="$OUTPUT_DIR"
    local config_file="$SCRIPT_DIR/decompiler-config.json"
    local ll_file="$out_dir/${TEST_NAME}.ll"
    
    # 检查 RetDec
    if [ ! -x "$RETDEC_BIN" ]; then
        echo -e "${RED}[FAIL]${NC} RetDec not found at: $RETDEC_BIN"
        echo "  Set RETDEC_ROOT environment variable or adjust path in script"
        return 1
    fi
    
    echo "RetDec: $RETDEC_BIN"
    echo "Binary: $binary"
    echo "Output: $ll_file"
    echo ""
    
    mkdir -p "$out_dir"
    
    # 生成配置文件（更新路径）
    if [ -f "$config_file" ]; then
        echo "Using existing config: $config_file"
        cp "$config_file" "$out_dir/config.json"
        
        # update paths in config
        sed -i "s|\"outputLlFile\": \"\"|\"outputLlFile\": \"$ll_file\"|g" "$out_dir/config.json"
        sed -i "s|\"ordinalNumDirectory\": \"\"|\"ordinalNumDirectory\": \"$RETDEC_SHARE/support/ordinals/\"|g" "$out_dir/config.json"
        sed -i "s|\"staticSignPaths\": \[\]|\"staticSignPaths\": [\"$RETDEC_SHARE/support/generic/yara_patterns/static-code/\"]|g" "$out_dir/config.json"
    else
        generate_config "$out_dir/config.json"
    fi
    
    # 运行 RetDec (仅 decoder pass)
    echo "Running retdec-decoder..."
    set +e
    "$RETDEC_BIN" --config "$out_dir/config.json" "$binary" 2>&1 | tee "$out_dir/retdec.log"
    retdec_status=${PIPESTATUS[0]}
    set -e
    if [ $retdec_status -ne 0 ]; then
        echo "WARNING: RetDec returned non-zero exit code (may still produce output)"
    fi
    
    # 检查输出文件
    if [ ! -f "$ll_file" ]; then
        # 尝试查找其他位置的 .ll 文件
        local found_ll=$(find "$out_dir" -name "*.ll" 2>/dev/null | head -1)
        if [ -n "$found_ll" ]; then
            echo ""
            echo -e "${YELLOW}[WARN]${NC} LLVM IR at unexpected location: $found_ll"
            ll_file="$found_ll"
        else
            echo -e "${RED}[FAIL]${NC} No LLVM IR file generated"
            return 1
        fi
    fi
    
    echo ""
    echo -e "${GREEN}[OK]${NC} LLVM IR generated: $ll_file"
    
    # 分析 LLVM IR 中的内存访问模式
    echo ""
    analyze_llvm_ir "$ll_file"
    
    return 0
}

# Analyze LLVM IR for memory access patterns
analyze_llvm_ir() {
    local ll_file="$1"
    
    print_section "3. LLVM IR Memory Access Analysis"
    
    echo "Analyzing: $ll_file"
    echo ""
    
    # 统计 LLVM IR 指令
    local load_count=$(grep -c "load " "$ll_file" 2>/dev/null || true)
    local store_count=$(grep -c "store " "$ll_file" 2>/dev/null || true)
    local gep_count=$(grep -c "getelementptr" "$ll_file" 2>/dev/null || true)
    local alloca_count=$(grep -c "alloca" "$ll_file" 2>/dev/null || true)
    local call_count=$(grep -c "call " "$ll_file" 2>/dev/null || true)
    local ptrtoint_count=$(grep -c "ptrtoint" "$ll_file" 2>/dev/null || true)
    local inttoptr_count=$(grep -c "inttoptr" "$ll_file" 2>/dev/null || true)
    local bitcast_count=$(grep -c "bitcast" "$ll_file" 2>/dev/null || true)
    
    echo "LLVM IR Memory-Related Instructions:"
    echo "----------------------------------------"
    printf "  load instructions:     %4d (memory read)\n" $load_count
    printf "  store instructions:    %4d (memory write)\n" $store_count
    printf "  getelementptr:         %4d (address calculation)\n" $gep_count
    printf "  alloca:                %4d (stack allocation)\n" $alloca_count
    printf "  call:                  %4d (function call)\n" $call_count
    printf "  ptrtoint:              %4d (pointer -> integer)\n" $ptrtoint_count
    printf "  inttoptr:              %4d (integer -> pointer)\n" $inttoptr_count
    printf "  bitcast:               %4d (type casting)\n" $bitcast_count
    
    # 检查特定的内存访问模式
    echo ""
    echo "Memory Access Patterns Detected:"
    echo "----------------------------------------"
    
    # 栈访问 (alloca + gep)
    if [ "$alloca_count" -gt 0 ]; then
        echo -e "  ${GREEN}[OK]${NC} Stack allocation detected ($alloca_count alloca)"
    fi
    
    # 全局变量访问
    if grep -q "@global" "$ll_file" 2>/dev/null; then
        local global_count=$(grep -c "@global" "$ll_file" 2>/dev/null || echo "0")
        echo -e "  ${GREEN}[OK]${NC} Global variable access ($global_count references)"
    fi
    
    # 堆访问 (malloc/calloc)
    if grep -qE "malloc|calloc|realloc" "$ll_file" 2>/dev/null; then
        local heap_count=$(grep -cE "malloc|calloc|realloc" "$ll_file" 2>/dev/null || echo "0")
        echo -e "  ${GREEN}[OK]${NC} Heap allocation detected ($heap_count calls)"
    fi
    
    # 函数指针加载
    if grep -q "load.*ptr.*ptr" "$ll_file" 2>/dev/null; then
        local funcptr_count=$(grep -c "load.*ptr.*ptr" "$ll_file" 2>/dev/null || echo "0")
        echo -e "  ${GREEN}[OK]${NC} Function pointer load detected"
    fi
    
    # 间接调用
    local indirect_call=$(grep -c "call.*ptr" "$ll_file" 2>/dev/null || true)
    if [ "$indirect_call" -gt 0 ]; then
        echo -e "  ${GREEN}[OK]${NC} Indirect call detected ($indirect_call)"
    fi
    
    # 伪调用检查
    local pseudo_count=$(grep -c "__pseudo" "$ll_file" 2>/dev/null || true)
    if [ "$pseudo_count" -gt 0 ]; then
        echo -e "  ${YELLOW}[INFO]${NC} Pseudo calls found: $pseudo_count"
    fi
    
    # 原始地址元数据
    local addr_metadata=$(grep -c "!insn_addr" "$ll_file" 2>/dev/null || true)
    echo -e "  ${GREEN}[OK]${NC} Instruction addresses preserved ($addr_metadata metadata)"
    
    # 保存分析结果摘要
    local summary_file="$OUTPUT_DIR/analysis_summary.txt"
    cat > "$summary_file" <<EOF
Memory Access Test Analysis Summary
====================================
Generated: $(date)

Binary: ${TEST_NAME}_stripped
LLVM IR: ${TEST_NAME}.ll

LLVM IR Statistics:
  load instructions:     $load_count
  store instructions:    $store_count
  getelementptr:         $gep_count
  alloca:                $alloca_count
  call:                  $call_count
  ptrtoint:              $ptrtoint_count
  inttoptr:              $inttoptr_count
  bitcast:               $bitcount_count

Patterns:
  Stack allocation:      $alloca_count alloca
  Indirect calls:        $indirect_call
  Pseudo calls:          $pseudo_count
  Address metadata:      $addr_metadata
EOF

    echo ""
    echo -e "${GREEN}[OK]${NC} Analysis summary saved to: $summary_file"
}

# Show comparison between objdump and RetDec output
show_comparison() {
    print_section "4. Comparison Summary"
    
    echo "Objdump (x86 Assembly) vs RetDec LLVM IR"
    echo "----------------------------------------"
    echo ""
    echo "Objdump -> RetDec Decoder Transformation:"
    echo "  mov r, [mem]      ->  %val = load type, ptr %addr"
    echo "  mov [mem], r      ->  store type %val, ptr %addr"
    echo "  lea r, [base+off] ->  %addr = getelementptr type, ptr %base, i64 off"
    echo "  push r            ->  store + stack pointer update"
    echo "  pop r             ->  load + stack pointer update"
    echo "  call [ptr]        ->  call type %fptr (indirect)"
    echo ""
    echo "Key Differences:"
    echo "  - Objdump: Architecture-specific (x86/x64)"
    echo "  - RetDec: Architecture-independent LLVM IR"
    echo "  - RetDec preserves memory semantics explicitly"
    echo "  - RetDec adds metadata (!insn_addr) for source mapping"
    
    # 列出输出文件
    echo ""
    echo "Output Files:"
    echo "----------------------------------------"
    ls -lh "$OUTPUT_DIR/" 2>/dev/null || echo "  (no output files)"
}

# Clean build artifacts
clean_all() {
    print_header "Cleaning Build Artifacts"
    
    if [ -d "$BUILDS_DIR" ]; then
        rm -rf "$BUILDS_DIR"
        echo -e "${GREEN}[OK]${NC} Removed: $BUILDS_DIR"
    fi
    
    if [ -d "$OUTPUT_DIR" ]; then
        rm -rf "$OUTPUT_DIR"
        echo -e "${GREEN}[OK]${NC} Removed: $OUTPUT_DIR"
    fi
    
    echo ""
    echo -e "${GREEN}Clean complete${NC}"
}

# Show help
show_help() {
    echo "Memory Access Instructions Disassembly Test"
    echo ""
    echo "Usage: $0 <command>"
    echo ""
    echo "Commands:"
    echo "  all       Build and run full analysis (default)"
    echo "  build     Build test binaries only"
    echo "  analyze   Run analysis on existing binaries"
    echo "  objdump   Run only objdump analysis"
    echo "  retdec    Run only RetDec analysis"
    echo "  clean     Remove all build artifacts"
    echo "  help      Show this help message"
    echo ""
    echo "Environment Variables:"
    echo "  CC           C compiler (default: gcc)"
    echo "  RETDEC_ROOT  RetDec build root (default: ../../../../build)"
    echo ""
    echo "Examples:"
    echo "  $0 all              # Full test"
    echo "  $0 build            # Just compile"
    echo "  $0 analyze          # Run analysis on existing binaries"
    echo "  CC=clang $0 all     # Use clang instead of gcc"
}

# Main
main() {
    local cmd="${1:-all}"
    
    case "$cmd" in
        -h|--help|help)
            show_help
            exit 0
            ;;
        clean)
            clean_all
            exit 0
            ;;
        build)
            build_test
            ;;
        objdump)
            mkdir -p "$OUTPUT_DIR"
            analyze_objdump
            ;;
        retdec)
            mkdir -p "$OUTPUT_DIR"
            analyze_retdec
            ;;
        analyze)
            if [ ! -f "$BUILDS_DIR/${TEST_NAME}_stripped" ]; then
                echo -e "${YELLOW}Binary not found, building first...${NC}"
                build_test || exit 1
            fi
            mkdir -p "$OUTPUT_DIR"
            analyze_objdump
            echo ""
            analyze_retdec
            echo ""
            show_comparison
            ;;
        all)
            build_test || exit 1
            echo ""
            analyze_objdump
            echo ""
            analyze_retdec || true  # 允许 RetDec 失败，继续显示比较
            echo ""
            show_comparison
            ;;
        *)
            echo -e "${RED}Unknown command: $cmd${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"
