# Indirect Call Preservation Test Suite

Test suite for validating RetDec's ability to preserve unresolved indirect calls in LLVM IR.

## Usage

```bash
# Build and run all tests
./test.sh all

# Build only (no RetDec needed)
./test.sh build

# Test single case
./test.sh test01_basic_reg
```

## Test Cases

| Test | Description | Pattern |
|------|-------------|---------|
| test01_basic_reg | Basic register-based indirect call | `call reg` |
| test02_memory_load | Call through memory load | `call [mem]` |
| test03_func_ptr_array | Array indexing | `call [base + idx * scale]` |
| test04_vtable_simulation | C-style vtable | `call [obj + offset]` |
| test05_struct_ptr | Function pointer in struct | `call [struct_ptr + offset]` |
| test06_multilevel | Multiple indirection | Complex address computation |
| test07_conditional | Runtime-selected pointers | Data-dependent targets |
| test08_loop | Indirect calls in loops | Repeated calls |
| test09_global | Global function pointers | Global memory access |
| test10_complex_math | Complex computed indices | Non-trivial computation |

## Expected Output

```
========================================
Running Tests
========================================
RetDec: /path/to/retdec-decompiler

----------------------------------------
Test: test01_basic_reg
----------------------------------------
  Binary indirect calls: 4
  Decompiling...
  Verifying...
  ✓ __pseudo_call found (2)
  ✓ retdec.call_type metadata (2)
  ✓ retdec.indirect_target metadata (2)
  ℹ Total calls: 15

  VERIFIED: Indirect calls preserved

========================================
Test Summary
========================================
Passed:  10
Failed:  0
Total:   10

All tests passed! ✓
```

## Verification Criteria

A test passes if the decompiled LLVM IR contains:

- ✓ `__pseudo_call` - Retained indirect call instructions
- ✓ `retdec.call_type` - Metadata marking indirect calls
- ✓ `retdec.indirect_target` - Metadata preserving target value

## Files

```
indirectcall/
├── test.sh              # Main test script
├── README.md            # This file
├── decompiler-config.json
├── testcases/           # C source files
│   ├── test01_basic_reg/main.c
│   └── ...
├── builds/              # Compiled binaries (generated)
└── output/              # RetDec output (generated)
```

## Implementation

The decoder modifications include:

- `preserveIndirectCalls()` - Identifies unresolved calls
- `isIndirectCallPseudo()` - Checks metadata markers
- `getIndirectCalls()` - Returns preserved calls
- `getIndirectCallTarget()` - Extracts target value

Resolution flow:
```
decode() → resolvePseudoCalls() → preserveIndirectCalls() → finalizePseudoCalls()
                                        ↑ NEW
```
