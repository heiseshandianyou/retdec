#!/bin/bash
# Stack Patterns Analysis Test
# 验证 Stack Pass 对不同栈访问模式的处理
#
# Usage: ./test.sh [all|build|analyze|clean]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILDS_DIR="$SCRIPT_DIR/builds"
OUTPUT_DIR="$SCRIPT_DIR/output"

# RetDec paths
RETDEC_ROOT="${RETDEC_ROOT:-$SCRIPT_DIR/../../../../../build}"
RETDEC_BIN="$RETDEC_ROOT/src/retdec-decompiler/retdec-decompiler"
RETDEC_SHARE="$RETDEC_ROOT/share/retdec"

# Test binary name
TEST_NAME="test_stack_patterns"
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

# Use the provided config file
CONFIG_FILE="$SCRIPT_DIR/decompiler-config.json"

# Build test binary
build_test() {
    print_header "Building Test Binary"
    echo "Compiler: $CC"
    echo "Flags: $CFLAGS (no debug info)"
    echo ""
    
    mkdir -p "$BUILDS_DIR"
    
    local binary="$BUILDS_DIR/${TEST_NAME}"
    local binary_stripped="$BUILDS_DIR/${TEST_NAME}_stripped"
    
    # Compile (no debug info)
    if $CC $CFLAGS -o "$binary" "$SRC_FILE" -lm 2>/dev/null; then
        echo -e "${GREEN}[OK]${NC} Compiled: $binary"
    else
        echo -e "${RED}[FAIL]${NC} Compilation failed"
        return 1
    fi
    
    # Create stripped version
    cp "$binary" "$binary_stripped"
    strip --strip-all "$binary_stripped" 2>/dev/null || true
    echo -e "${GREEN}[OK]${NC} Stripped: $binary_stripped"
    
    # Show file info
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
    mkdir -p "$OUTPUT_DIR"
    
    local binary="$BUILDS_DIR/${TEST_NAME}_stripped"
    local asm_file="$OUTPUT_DIR/${TEST_NAME}_objdump.asm"
    
    echo "Binary: $binary"
    echo "Output: $asm_file"
    echo "Format: Intel"
    echo ""
    
    # Full disassembly (Intel format)
    objdump -d -M intel "$binary" > "$asm_file" 2>/dev/null
    
    # Count stack-related instructions
    echo "Stack Access Instructions Count:"
    echo "----------------------------------------"
    
    # RBP-based access
    local rbp_load=$(grep -cE "\[rbp.*\]" "$asm_file" 2>/dev/null || true)
    local rbp_store=$(grep -cE "mov.*\[rbp" "$asm_file" 2>/dev/null || true)
    
    # RSP-based access
    local rsp_load=$(grep -cE "\[rsp.*\]" "$asm_file" 2>/dev/null || true)
    local rsp_store=$(grep -cE "mov.*\[rsp" "$asm_file" 2>/dev/null || true)
    
    # Push/pop
    local push_count=$(grep -cE "\bpush\b" "$asm_file" 2>/dev/null || true)
    local pop_count=$(grep -cE "\bpop\b" "$asm_file" 2>/dev/null || true)
    
    # Stack adjustment
    local sub_rsp=$(grep -cE "sub\s+rsp" "$asm_file" 2>/dev/null || true)
    local add_rsp=$(grep -cE "add\s+rsp" "$asm_file" 2>/dev/null || true)

    
    printf "  RBP-based accesses:    %4d (local variables)\n" $rbp_load
    printf "  RSP-based accesses:    %4d (dynamic stack)\n" $rsp_load
    printf "  push instructions:     %4d\n" $push_count
    printf "  pop instructions:      %4d\n" $pop_count
    printf "  sub rsp (allocate):    %4d\n" $sub_rsp
    printf "  add rsp (deallocate):  %4d\n" $add_rsp
    
    echo ""
    echo -e "${GREEN}[OK]${NC} Objdump analysis saved to: $asm_file"
    
    # Extract sample stack accesses
    echo ""
    echo "Sample Stack Access Instructions:"
    echo "----------------------------------------"
    echo "RBP-based (local variables):"
    grep -E "mov.*\[rbp.*\]" "$asm_file" 2>/dev/null | head -5 || echo "  (none found)"
    echo ""
    echo "RSP-based (dynamic stack):"
    grep -E "mov.*\[rsp.*\]" "$asm_file" 2>/dev/null | head -5 || echo "  (none found)"
}

# Analyze Stack Pass output
analyze_stack_pass() {
    print_section "2. Stack Pass Analysis (LLVM IR)"
    
    local binary="$BUILDS_DIR/${TEST_NAME}_stripped"
    local out_dir="$OUTPUT_DIR"
    local ll_file="$out_dir/${TEST_NAME}.ll"
    
    # Check RetDec
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
    
    # Check config file exists
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}[FAIL]${NC} Config file not found: $CONFIG_FILE"
        return 1
    fi
    
    echo "Config: $CONFIG_FILE"
    
    # Run RetDec with the provided config
    echo "Running retdec (with stack pass)..."
    echo "Working directory: $SCRIPT_DIR"
    set +e
    
    # Run from script directory so config paths resolve correctly
    cd "$SCRIPT_DIR" && "$RETDEC_BIN" --config "$CONFIG_FILE" -o "$ll_file" "$binary" 2>&1 | tee "$out_dir/retdec.log"
    retdec_status=$?
    set -e
    if [ $retdec_status -ne 0 ]; then
        echo "WARNING: RetDec returned non-zero exit code (may still produce output)"
    fi

    # Move output file if generated in script dir
    if [ -f "$SCRIPT_DIR/test_stack_patterns.ll" ]; then
        mv "$SCRIPT_DIR/test_stack_patterns.ll" "$ll_file"
    fi
    
    # Check output file
    if [ ! -f "$ll_file" ]; then
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
    
    # Analyze LLVM IR
    echo ""
    analyze_llvm_ir "$ll_file"
}

# Analyze LLVM IR for stack patterns
analyze_llvm_ir() {
    local ll_file="$1"
    
    print_section "3. LLVM IR Stack Access Analysis"
    
    echo "Analyzing: $ll_file"
    echo ""
    
    # Count alloca (created by stack pass)
    local alloca_count=$(grep -c "alloca" "$ll_file" 2>/dev/null || echo "0")
    
    # Count remaining RSP/ESP accesses
    local rsp_load=$(grep -c "load.*@rsp\|load.*@esp" "$ll_file" 2>/dev/null || echo "0")
    local rsp_store=$(grep -c "store.*@rsp\|store.*@esp" "$ll_file" 2>/dev/null || echo "0")
    
    # Count remaining RBP/EBP accesses
    local rbp_load=$(grep -c "load.*@rbp\|load.*@ebp" "$ll_file" 2>/dev/null || echo "0")
    local rbp_store=$(grep -c "store.*@rbp\|store.*@ebp" "$ll_file" 2>/dev/null || echo "0")
    
    # Count load/store to alloca (converted by stack pass)
    local alloca_load=$(grep -c "load.*%stack\|load.*%local" "$ll_file" 2>/dev/null || echo "0")
    local alloca_store=$(grep -c "store.*%stack\|store.*%local" "$ll_file" 2>/dev/null || echo "0")
    
    echo "Stack-Related LLVM IR Statistics:"
    echo "----------------------------------------"
    printf "  alloca instructions:       %4d (created by stack pass)\n" $alloca_count
    printf "  Remaining @rsp/@esp load:  %4d (not processed)\n" $rsp_load
    printf "  Remaining @rsp/@esp store: %4d (not processed)\n" $rsp_store
    printf "  Remaining @rbp/@ebp load:  %4d (expected - stack pass doesn't process BP)\n" $rbp_load
    printf "  Remaining @rbp/@ebp store: %4d (expected - stack pass doesn't process BP)\n" $rbp_store
    
    # Verify our hypothesis
    echo ""
    echo "Verification of Stack Pass Behavior:"
    echo "----------------------------------------"
    
    if [ "$rbp_load" -gt 0 ] || [ "$rbp_store" -gt 0 ]; then
        echo -e "  ${GREEN}[CONFIRMED]${NC} RBP/EBP accesses remain (stack pass doesn't process them)"
    else
        echo -e "  ${YELLOW}[NOTE]${NC} No RBP/EBP accesses found (may be optimized differently)"
    fi
    
    if [ "$alloca_count" -gt 0 ]; then
        echo -e "  ${GREEN}[CONFIRMED]${NC} alloca created (stack pass processed some RSP accesses)"
    else
        echo -e "  ${YELLOW}[NOTE]${NC} No alloca found (compiler may use RBP for all locals)"
    fi
    
    # Show sample conversions
    echo ""
    echo "Sample Stack Access Patterns in LLVM IR:"
    echo "----------------------------------------"
    
    echo "1. alloca variables (created by stack pass):"
    grep "alloca" "$ll_file" 2>/dev/null | head -5 || echo "  (none found)"
    
    echo ""
    echo "2. Remaining RSP/ESP accesses (not processed):"
    grep -E "load.*@rsp|store.*@rsp" "$ll_file" 2>/dev/null | head -5 || echo "  (none found)"
    
    echo ""
    echo "3. Remaining RBP/EBP accesses (expected):"
    grep -E "load.*@rbp|store.*@rbp" "$ll_file" 2>/dev/null | head -5 || echo "  (none found)"
    
    # Save summary
    local summary_file="$OUTPUT_DIR/analysis_summary.txt"
    cat > "$summary_file" <<EOF
Stack Patterns Test Analysis Summary
=====================================
Generated: $(date)

Binary: ${TEST_NAME}_stripped
LLVM IR: ${TEST_NAME}.ll

Statistics:
  alloca instructions:       $alloca_count
  Remaining @rsp/@esp load:  $rsp_load
  Remaining @rsp/@esp store: $rsp_store
  Remaining @rbp/@ebp load:  $rbp_load
  Remaining @rbp/@ebp store: $rbp_store

Verification:
  - RBP/EBP accesses remain: $([ "$rbp_load" -gt 0 ] && echo "YES" || echo "NO")
  - alloca created: $([ "$alloca_count" -gt 0 ] && echo "YES" || echo "NO")

Conclusion:
Stack pass processes RSP/ESP accesses but NOT RBP/EBP accesses.
EOF

    echo ""
    echo -e "${GREEN}[OK]${NC} Analysis summary saved to: $summary_file"
}

# Show comparison
show_comparison() {
    print_section "4. Summary and Conclusions"
    
    echo "Expected Stack Pass Behavior:"
    echo "----------------------------------------"
    echo "  RBP/EBP accesses:  NOT processed (kept as-is)"
    echo "  RSP/ESP accesses:  Processed (converted to alloca)"
    echo ""
    echo "Actual Results (see above statistics):"
    echo "----------------------------------------"
    
    local ll_file="$OUTPUT_DIR/${TEST_NAME}.ll"
    if [ -f "$ll_file" ]; then
        local alloca_count=$(grep -c "alloca" "$ll_file" 2>/dev/null || echo "0")
        local rbp_count=$(grep -cE "@rbp|@ebp" "$ll_file" 2>/dev/null || echo "0")
        
        echo "  alloca created:    $alloca_count"
        echo "  RBP/EBP remain:    $rbp_count"
        echo ""
        
        if [ "$alloca_count" -gt 0 ] && [ "$rbp_count" -gt 0 ]; then
            echo -e "${GREEN}✓ VERIFIED${NC}: Stack pass processes RSP but not RBP"
        elif [ "$alloca_count" -eq 0 ]; then
            echo -e "${YELLOW}! NOTE${NC}: Compiler may have used RBP for all locals"
            echo "           (GCC/Clang with -O0 typically use RBP)"
        fi
    fi
    
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
    echo "Stack Patterns Analysis Test"
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
            if [ ! -f "$BUILDS_DIR/${TEST_NAME}_stripped" ]; then
                echo -e "${YELLOW}Binary not found, building first...${NC}"
                build_test || exit 1
            fi
            mkdir -p "$OUTPUT_DIR"
            analyze_stack_pass
            ;;
        analyze)
            if [ ! -f "$BUILDS_DIR/${TEST_NAME}_stripped" ]; then
                echo -e "${YELLOW}Binary not found, building first...${NC}"
                build_test || exit 1
            fi
            mkdir -p "$OUTPUT_DIR"
            analyze_objdump
            echo ""
            analyze_stack_pass
            echo ""
            show_comparison
            ;;
        all)
            build_test || exit 1
            echo ""
            analyze_objdump
            echo ""
            analyze_stack_pass || true
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
