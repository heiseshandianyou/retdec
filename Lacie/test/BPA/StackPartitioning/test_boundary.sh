#!/bin/bash
# BPA Boundary Collector Test Script
# Tests the read-only boundary collection pass

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_NAME="test_stack_patterns"
SRC_DIR="$SCRIPT_DIR/src"
BIN_DIR="$SCRIPT_DIR/bin"
OUT_DIR="$SCRIPT_DIR/output"

BINARY="$BIN_DIR/${TEST_NAME}_stripped"

# RetDec paths
RETDEC_ROOT="${RETDEC_ROOT:-/home/lacie/project/retdec1/retdec/build}"
RETDEC_BIN="$RETDEC_ROOT/src/retdec-decompiler/retdec-decompiler"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
}

# Check binary exists
if [ ! -f "$BINARY" ]; then
    echo -e "${YELLOW}Binary not found, building...${NC}"
    mkdir -p "$BIN_DIR"
    gcc -O0 -fno-inline -fno-optimize-sibling-calls -Wall "$SRC_DIR/${TEST_NAME}.c" -o "$BIN_DIR/${TEST_NAME}" 2>/dev/null
    strip "$BIN_DIR/${TEST_NAME}" -o "$BINARY"
fi

# Check RetDec
if [ ! -x "$RETDEC_BIN" ]; then
    echo -e "${RED}[FAIL]${NC} RetDec not found at: $RETDEC_BIN"
    exit 1
fi

print_header "BPA Boundary Collector Test"
echo "Binary: $BINARY"
echo "RetDec: $RETDEC_BIN"
echo ""

# Run boundary collection
echo -e "${BLUE}Running BPA Boundary Collection...${NC}"
echo ""

mkdir -p "$OUT_DIR"

# Generate assembly disassembly
echo -e "${BLUE}Generating assembly disassembly...${NC}"
objdump -d "$BINARY" > "$OUT_DIR/${TEST_NAME}.asm"

"$RETDEC_BIN" --config "$OUT_DIR/decompiler-config.json" -o "$OUT_DIR/output" "$BINARY" 2>&1 | tee "$OUT_DIR/boundary_report.txt"

echo ""
echo -e "${GREEN}[OK]${NC} Boundary collection complete"
echo ""
echo "Report saved to: $OUT_DIR/boundary_report.txt"
echo "Assembly saved to: $OUT_DIR/${TEST_NAME}.asm"
echo ""

# Extract summary
echo "Quick Summary:"
grep "Summary:" -A10 "$OUT_DIR/boundary_report.txt" 2>/dev/null || echo "See full report above"
