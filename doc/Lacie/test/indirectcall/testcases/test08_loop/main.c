/*
 * Test 08: Loop-based Indirect Calls
 * Description: Indirect calls in various loop constructs
 * Expected: Pattern analysis through loop iterations
 */

#include <stdio.h>

typedef int (*step_func_t)(int);

int step_add(int x) { return x + 1; }
int step_sub(int x) { return x - 1; }
int step_double(int x) { return x * 2; }
int step_half(int x) { return x / 2; }

step_func_t steps[] = { step_add, step_sub, step_double, step_half };

int iterate_sequence(int start, int* pattern, int len) {
    int result = start;
    for (int i = 0; i < len; i++) {
        result = steps[pattern[i]](result);  // Indirect call in loop
        printf("Step %d: result = %d\n", i, result);
    }
    return result;
}

int nested_loops(int start) {
    int result = start;
    int pattern[] = { 0, 2, 1, 3 };  // add, double, sub, half
    
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            int idx = pattern[i * 2 + j];
            result = steps[idx](result);  // Indirect in nested loop
        }
    }
    return result;
}

void while_loop_demo(void) {
    int value = 1;
    int step = 0;
    
    while (value < 100) {
        value = steps[step % 4](value);  // Indirect in while loop
        printf("While step %d: %d\n", step, value);
        step++;
    }
}

void do_while_demo(void) {
    int count = 0;
    step_func_t operations[] = { step_add, step_add, step_double };
    
    do {
        count = operations[count % 3](count);  // Indirect in do-while
        printf("Do-while count: %d\n", count);
    } while (count < 10);
}

int main(void) {
    int pattern[] = { 0, 2, 1, 3, 0, 2 };
    
    printf("=== Sequence iteration ===\n");
    int final = iterate_sequence(5, pattern, 6);
    printf("Final result: %d\n\n", final);
    
    printf("=== Nested loops ===\n");
    printf("Nested result: %d\n\n", nested_loops(10));
    
    printf("=== While loop ===\n");
    while_loop_demo();
    printf("\n");
    
    printf("=== Do-while loop ===\n");
    do_while_demo();
    
    return 0;
}
