/*
 * Test 02: Memory Load Indirect Call
 * Description: Call through pointer loaded from memory
 * Expected: call [mem] pattern
 */

#include <stdio.h>

typedef int (*op_func_t)(int, int);

int add(int a, int b) { return a + b; }
int sub(int a, int b) { return a - b; }
int mul(int a, int b) { return a * b; }
int div(int a, int b) { return b ? a / b : 0; }

// Function pointer table in data section
op_func_t op_table[4] = { add, sub, mul, div };

int main(void) {
    int x = 10, y = 5;
    int result = 0;
    
    // Indirect call through memory lookup
    for (int i = 0; i < 4; i++) {
        result = op_table[i](x, y);  // call [mem + offset]
        printf("Result: %d\n", result);
    }
    
    return 0;
}
