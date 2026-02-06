/*
 * Test 09: Global Variable Indirect Call
 * Description: Indirect calls through global function pointers
 * Expected: Global memory access before call
 */

#include <stdio.h>
#include <stdlib.h>

// Global function pointers
typedef int (*math_op_t)(int, int);

typedef struct {
    math_op_t op;
    const char* name;
} op_entry_t;

int add(int a, int b) { return a + b; }
int sub(int a, int b) { return a - b; }
int mul(int a, int b) { return a * b; }
int div_op(int a, int b) { return b ? a / b : 0; }
int mod(int a, int b) { return b ? a % b : 0; }
int power(int a, int b) {
    int r = 1;
    while (b-- > 0) r *= a;
    return r;
}

// Global variables
op_entry_t g_current_op = { add, "add" };
math_op_t g_quick_op = add;
op_entry_t* g_op_ptr = NULL;
op_entry_t g_ops[] = {
    { add, "add" },
    { sub, "subtract" },
    { mul, "multiply" },
    { div_op, "divide" },
    { mod, "modulo" },
    { power, "power" }
};

int perform_operation(int a, int b) {
    // Global access -> indirect call
    printf("Using global operation: %s\n", g_current_op.name);
    return g_current_op.op(a, b);
}

int perform_quick_op(int a, int b) {
    // Direct global function pointer call
    return g_quick_op(a, b);
}

int perform_via_ptr(int a, int b) {
    // Indirect through global pointer
    if (g_op_ptr) {
        return g_op_ptr->op(a, b);
    }
    return 0;
}

void set_operation(int idx) {
    if (idx >= 0 && idx < 6) {
        g_current_op = g_ops[idx];  // Copy struct with function pointer
        g_quick_op = g_ops[idx].op;
        g_op_ptr = &g_ops[idx];
    }
}

int main(void) {
    int x = 12, y = 4;
    
    // Test with different global operations
    printf("=== Global struct operation ===\n");
    printf("Result: %d\n\n", perform_operation(x, y));
    
    set_operation(1);  // Change to subtract
    printf("After set_operation(1):\n");
    printf("Result: %d\n\n", perform_operation(x, y));
    
    printf("=== Global pointer operation ===\n");
    printf("Quick op result: %d\n\n", perform_quick_op(x, y));
    
    printf("=== Global ptr-to-ptr operation ===\n");
    printf("Via ptr result: %d\n\n", perform_via_ptr(x, y));
    
    // Multiple operations in loop using globals
    printf("=== Multiple operations ===\n");
    for (int i = 0; i < 6; i++) {
        set_operation(i);
        int result = perform_operation(x, y);
        printf("Op %d: %d %s %d = %d\n", i, x, g_current_op.name, y, result);
    }
    
    return 0;
}
