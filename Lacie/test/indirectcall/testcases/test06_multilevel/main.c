/*
 * Test 06: Multi-level Indirection
 * Description: Multiple levels of pointers to function pointers
 * Expected: Complex address computation before call
 */

#include <stdio.h>

typedef int (*op_func_t)(int);

int inc(int x) { return x + 1; }
int dec(int x) { return x - 1; }
int square(int x) { return x * x; }
int negate(int x) { return -x; }

// Level 1: function pointer
op_func_t ops[4] = { inc, dec, square, negate };

// Level 2: pointer to function pointer array
op_func_t (*ops_ptr)[4] = &ops;

// Level 3: pointer to function pointer (single level)
op_func_t* ops_ptr_ptr = ops;

// Indirection through struct
struct wrapper {
    op_func_t* func_array;
};

struct wrapper w = { ops };
struct wrapper* wp = &w;

int apply_via_ptr(int x, int idx) {
    // Single level: call [ptr]
    return (*ops_ptr)[idx](x);
}

int apply_via_ptr_ptr(int x, int idx) {
    // Double indirection - pointer to function pointer
    return ops_ptr_ptr[idx](x);
}

int apply_via_struct(int x, int idx) {
    // Through struct pointer
    return wp->func_array[idx](x);
}

int main(void) {
    int x = 5;
    
    printf("Direct: %d\n", ops[0](x));           // Direct array access
    printf("Via ptr: %d\n", apply_via_ptr(x, 1));        // Indirect through ptr
    printf("Via ptr-ptr: %d\n", apply_via_ptr_ptr(x, 2));  // Double indirect
    printf("Via struct: %d\n", apply_via_struct(x, 3));   // Through struct
    
    // Complex: computed indirection
    int choice = 2;
    op_func_t* p = *ops_ptr;
    op_func_t f = *(p + choice);
    printf("Computed: %d\n", f(x));  // Call through computed pointer
    
    return 0;
}
