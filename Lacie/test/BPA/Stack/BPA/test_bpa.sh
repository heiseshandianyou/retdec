#!/bin/bash
# BPA Stack Pass Test Script
# 对比原始 Stack Pass 和 BPA Stack Pass 的差异

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILDS_DIR="$SCRIPT_DIR/builds"
OUTPUT_DIR="$SCRIPT_DIR/output"

# RetDec paths
RETDEC_ROOT="${RETDEC_ROOT:-$SCRIPT_DIR/../../../../../build}"
RETDEC_BIN="$RETDEC_ROOT/src/retdec-decompiler/retdec-decompiler"

TEST_NAME="test_stack_patterns"
SRC_FILE="$SCRIPT_DIR/${TEST_NAME}.c"
BINARY="$BUILDS_DIR/${TEST_NAME}_stripped"

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

check_retdec() {
    if [ ! -x "$RETDEC_BIN" ]; then
        echo -e "${RED}[FAIL]${NC} RetDec not found at: $RETDEC_BIN"
        exit 1
    fi
}

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
    
    return 0
}

run_original_stack_pass() {
    print_header "1. Running Original Stack Pass (retdec-stack)"
    
    local out_dir="$OUTPUT_DIR/original"
    mkdir -p "$out_dir"
    
    cd "$SCRIPT_DIR"
    "$RETDEC_BIN" --config "$SCRIPT_DIR/decompiler-config.json" \
        -o "$out_dir/${TEST_NAME}.ll" "$BINARY" 2>&1 | tail -10
    
    if [ -f "$out_dir/${TEST_NAME}.ll" ]; then
        echo -e "${GREEN}[OK]${NC} Original pass output: $out_dir/${TEST_NAME}.ll"
        
        # Count allocas and RBP accesses
        local alloca_count=$(grep -c "alloca" "$out_dir/${TEST_NAME}.ll" || echo "0")
        local rbp_count=$(grep -cE "@rbp|@ebp" "$out_dir/${TEST_NAME}.ll" || echo "0")
        
        echo "  Statistics:"
        echo "    alloca count: $alloca_count"
        echo "    RBP accesses: $rbp_count"
    else
        echo -e "${RED}[FAIL]${NC} Original pass did not generate output"
    fi
}

run_bpa_stack_pass() {
    print_header "2. Running BPA Stack Pass (retdec-bpa-stack)"
    
    local out_dir="$OUTPUT_DIR/bpa"
    mkdir -p "$out_dir"
    
    cd "$SCRIPT_DIR"
    "$RETDEC_BIN" --config "$SCRIPT_DIR/decompiler-config-bpa.json" \
        -o "$out_dir/${TEST_NAME}_bpa.ll" "$BINARY" 2>&1 | tail -10
    
    if [ -f "$out_dir/${TEST_NAME}_bpa.ll" ]; then
        echo -e "${GREEN}[OK]${NC} BPA pass output: $out_dir/${TEST_NAME}_bpa.ll"
        
        # Count allocas and RBP accesses
        local alloca_count=$(grep -c "alloca" "$out_dir/${TEST_NAME}_bpa.ll" || echo "0")
        local rbp_count=$(grep -cE "@rbp|@ebp" "$out_dir/${TEST_NAME}_bpa.ll" || echo "0")
        
        echo "  Statistics:"
        echo "    alloca count: $alloca_count"
        echo "    RBP accesses: $rbp_count"
    else
        echo -e "${RED}[FAIL]${NC} BPA pass did not generate output"
    fi
}

compare_results() {
    print_header "3. Comparison"
    
    local orig_file="$OUTPUT_DIR/original/${TEST_NAME}.ll"
    local bpa_file="$OUTPUT_DIR/bpa/${TEST_NAME}_bpa.ll"
    
    if [ ! -f "$orig_file" ] || [ ! -f "$bpa_file" ]; then
        echo -e "${YELLOW}[WARN]${NC} Cannot compare - missing files"
        return
    fi
    
    echo "Original Stack Pass:"
    echo "  alloca: $(grep -c "alloca" "$orig_file" || echo "0")"
    echo "  @rbp/@ebp: $(grep -cE "@rbp|@ebp" "$orig_file" || echo "0")"
    echo ""
    echo "BPA Stack Pass:"
    echo "  alloca: $(grep -c "alloca" "$bpa_file" || echo "0")"
    echo "  @rbp/@ebp: $(grep -cE "@rbp|@ebp" "$bpa_file" || echo "0")"
    echo ""
    
    # Check if BPA pass handles more RBP accesses
    local orig_rbp=$(grep -cE "@rbp|@ebp" "$orig_file" || echo "0")
    local bpa_rbp=$(grep -cE "@rbp|@ebp" "$bpa_file" || echo "0")
    
    if [ "$bpa_rbp" -lt "$orig_rbp" ]; then
        echo -e "${GREEN}[SUCCESS]${NC} BPA pass converted more RBP accesses to alloca!"
    else
        echo -e "${YELLOW}[NOTE]${NC} RBP accesses: Original=$orig_rbp, BPA=$bpa_rbp"
    fi
}

# Main
check_retdec

if [ ! -f "$BINARY" ]; then
    build_test
fi

echo "Testing BPA Stack Pass..."
echo "Binary: $BINARY"
echo "RetDec: $RETDEC_BIN"
echo ""

run_original_stack_pass
echo ""
run_bpa_stack_pass
echo ""
compare_results
