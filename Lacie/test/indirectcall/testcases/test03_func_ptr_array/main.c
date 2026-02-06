/*
 * Test 03: Function Pointer Array with Index
 * Description: Complex array indexing to select function
 * Expected: call [base + index * scale] pattern
 */

#include <stdio.h>
#include <stdlib.h>

typedef void (*handler_t)(int);

void handler_0(int x) { printf("Handler 0: %d\n", x); }
void handler_1(int x) { printf("Handler 1: %d\n", x * 2); }
void handler_2(int x) { printf("Handler 2: %d\n", x * 3); }
void handler_3(int x) { printf("Handler 3: %d\n", x * 4); }
void handler_4(int x) { printf("Handler 4: %d\n", x * 5); }
void handler_5(int x) { printf("Handler 5: %d\n", x * 6); }
void handler_6(int x) { printf("Handler 6: %d\n", x * 7); }
void handler_7(int x) { printf("Handler 7: %d\n", x * 8); }

handler_t handlers[8] = {
    handler_0, handler_1, handler_2, handler_3,
    handler_4, handler_5, handler_6, handler_7
};

int main(void) {
    // Dynamic index selection
    volatile int idx = 3;
    
    handlers[idx](42);  // call [base + idx * 8]
    
    idx = rand() % 8;  // Random selection
    handlers[idx](100);  // Another indirect call
    
    return 0;
}
