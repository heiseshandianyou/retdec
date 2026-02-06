/*
 * Test 01: Basic Register Indirect Call
 * Description: Simple function pointer call through register
 * Expected: call [reg] pattern
 */

#include <stdio.h>

typedef void (*func_ptr_t)(void);

void target_func_a(void) {
    printf("A\n");
}

void target_func_b(void) {
    printf("B\n");
}

int main(void) {
    volatile func_ptr_t fp = target_func_a;  // volatile prevents optimization
    
    fp();  // Indirect call through register
    
    fp = target_func_b;
    fp();  // Another indirect call
    
    return 0;
}
