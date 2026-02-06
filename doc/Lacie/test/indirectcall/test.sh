#!/bin/bash
# Indirect Call Preservation Test Suite
# Usage: ./test.sh [all|build|test_name]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILDS_DIR="$SCRIPT_DIR/builds"
OUTPUT_DIR="$SCRIPT_DIR/output"

# RetDec paths
RETDEC_ROOT="$SCRIPT_DIR/../../../../build"
RETDEC_BIN="$RETDEC_ROOT/src/retdec-decompiler/retdec-decompiler"
RETDEC_SHARE="$RETDEC_ROOT/share/retdec"

# Test cases
TESTCASES=(
    "test01_basic_reg"
    "test02_memory_load"
    "test03_func_ptr_array"
    "test04_vtable_simulation"
    "test05_struct_ptr"
    "test06_multilevel"
    "test07_conditional"
    "test08_loop"
    "test09_global"
    "test10_complex_math"
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Compiler settings
CC=${CC:-gcc}
CFLAGS="-O0 -fno-inline -fno-optimize-sibling-calls -g -Wall"

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

# Generate config file for a test case
generate_config() {
    local testname="$1"
    local out_file="$2"
    cat > "$out_file" <<EOF
{
    "decompParams": {
        "verboseOut": true,
        "outputFormat": "plain",
        "keepAllFuncs": true,
        "outputLlFile": "$OUTPUT_DIR/$testname/$testname.ll",
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

# Build single test case
build_test() {
    local testname="$1"
    local src_dir="$SCRIPT_DIR/testcases/$testname"
    local build_dir="$BUILDS_DIR/$testname"
    
    [ ! -d "$src_dir" ] && { echo -e "${RED}✗${NC} Source not found: $testname"; return 1; }
    
    mkdir -p "$build_dir"
    
    if $CC $CFLAGS -o "$build_dir/$testname" "$src_dir/main.c" -lm 2>/dev/null; then
        cp "$build_dir/$testname" "$build_dir/${testname}_stripped"
        strip "$build_dir/${testname}_stripped" 2>/dev/null || true
        echo -e "${GREEN}✓${NC} $testname"
        return 0
    else
        echo -e "${RED}✗${NC} $testname (compile failed)"
        return 1
    fi
}

# Build all tests
build_all() {
    print_header "Building Test Cases"
    echo "Compiler: $CC"
    echo ""
    
    local success=0 failed=0
    
    for testname in "${TESTCASES[@]}"; do
        if build_test "$testname"; then
            success=$((success + 1))
        else
            failed=$((failed + 1))
        fi
    done
    
    echo ""
    echo -e "Build: ${GREEN}$success${NC} passed, ${RED}$failed${NC} failed"
    echo ""
    [ $failed -eq 0 ]
}

# Verify indirect call preservation in LLVM IR
verify_ir() {
    local ll_file="$1"
    local found=0
    
    # Check for __pseudo_call
    local pseudo_count=$(grep -c "__pseudo_call" "$ll_file" 2>/dev/null || echo "0")
    if [ "$pseudo_count" -gt 0 ]; then
        echo -e "  ${GREEN}✓${NC} __pseudo_call found ($pseudo_count)"
        ((found++))
    fi
    
    # Check for retdec.call_type
    local call_type_count=$(grep -c "retdec.call_type" "$ll_file" 2>/dev/null || echo "0")
    if [ "$call_type_count" -gt 0 ]; then
        echo -e "  ${GREEN}✓${NC} retdec.call_type metadata ($call_type_count)"
        ((found++))
    fi
    
    # Check for retdec.indirect_target
    local target_count=$(grep -c "retdec.indirect_target" "$ll_file" 2>/dev/null || echo "0")
    if [ "$target_count" -gt 0 ]; then
        echo -e "  ${GREEN}✓${NC} retdec.indirect_target metadata ($target_count)"
        ((found++))
    fi
    
    # Total calls
    local total_calls=$(grep -c "call " "$ll_file" 2>/dev/null || echo "0")
    echo -e "  ${BLUE}ℹ${NC} Total calls: $total_calls"
    
    # Verdict
    echo ""
    if [ $found -ge 2 ]; then
        echo -e "  ${GREEN}VERIFIED${NC}: Indirect calls preserved"
        return 0
    elif [ $found -ge 1 ]; then
        echo -e "  ${YELLOW}PARTIAL${NC}: Some patterns found"
        return 0
    else
        echo -e "  ${RED}FAILED${NC}: No preservation detected"
        return 1
    fi
}

# Run single test
run_test() {
    local testname="$1"
    local binary="$BUILDS_DIR/$testname/${testname}_stripped"
    local out_dir="$OUTPUT_DIR/$testname"
    local config_file="$out_dir/config.json"
    local ll_file="$out_dir/$testname.ll"
    
    # Build if not exists
    if [ ! -f "$binary" ]; then
        echo -e "${YELLOW}Building $testname...${NC}"
        build_test "$testname" || return 1
    fi
    
    mkdir -p "$out_dir"
    
    # Generate config for this test
    generate_config "$testname" "$config_file"
    
    print_section "Test: $testname"
    
    # Assembly analysis
    local asm_count=$(objdump -d "$binary" 2>/dev/null | grep -cE "call\s+\*" || echo "0")
    echo "  Binary indirect calls: $asm_count"
    
    # Run RetDec with generated config
    echo "  Decompiling (decoder only)..."
    if ! "$RETDEC_BIN" --config "$config_file" "$binary" 2>&1 | tee "$out_dir/retdec.log" | tail -5; then
        echo -e "  ${RED}✗${NC} Decompilation failed"
        return 1
    fi
    
    # Check if output file was created
    if [ ! -f "$ll_file" ]; then
        echo -e "  ${YELLOW}⚠${NC} LLVM IR file not found at expected location"
        # Try to find it
        local found_ll=$(find "$out_dir" -name "*.ll" 2>/dev/null | head -1)
        if [ -n "$found_ll" ]; then
            echo "  Found: $found_ll"
            ll_file="$found_ll"
        else
            echo -e "  ${RED}✗${NC} No LLVM IR file found"
            return 1
        fi
    fi
    
    # Verify
    echo "  Verifying..."
    verify_ir "$ll_file"
}

# Run all tests
run_all() {
    if [ ! -x "$RETDEC_BIN" ]; then
        echo -e "${RED}ERROR: RetDec not found at $RETDEC_BIN${NC}"
        exit 1
    fi
    
    print_header "Running Tests"
    echo "RetDec: $RETDEC_BIN"
    echo ""
    
    local passed=0 failed=0
    
    for testname in "${TESTCASES[@]}"; do
        if run_test "$testname"; then
            passed=$((passed + 1))
        else
            failed=$((failed + 1))
        fi
        echo ""
    done
    
    print_header "Test Summary"
    printf "${GREEN}Passed:${NC}  %d\n" $passed
    printf "${RED}Failed:${NC}  %d\n" $failed
    printf "Total:   %d\n" ${#TESTCASES[@]}
    echo ""
    
    if [ $failed -eq 0 ]; then
        echo -e "${GREEN}All tests passed! ✓${NC}"
    else
        echo -e "${YELLOW}Some tests failed.${NC}"
    fi
}

# Show help
show_help() {
    echo "Indirect Call Preservation Test Suite"
    echo ""
    echo "Usage: $0 <command>"
    echo ""
    echo "Commands:"
    echo "  all           Build and run all tests (default)"
    echo "  build         Build test cases only"
    echo "  <test_name>   Run single test case"
    echo ""
    echo "Examples:"
    echo "  $0 all"
    echo "  $0 build"
    echo "  $0 test01_basic_reg"
    echo ""
    echo "Environment:"
    echo "  CC            C compiler (default: gcc)"
    echo ""
    echo "Test cases:"
    for t in "${TESTCASES[@]}"; do
        echo "  $t"
    done
}

# Main
main() {
    local cmd="${1:-all}"
    
    # Show help if explicitly requested
    if [ "$cmd" = "-h" ] || [ "$cmd" = "--help" ]; then
        show_help
        exit 0
    fi
    
    case "$cmd" in
        all)
            build_all && run_all
            ;;
        build)
            build_all
            ;;
        test*)
            run_test "$cmd"
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
