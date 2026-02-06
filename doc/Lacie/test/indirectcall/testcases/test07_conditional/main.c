/*
 * Test 07: Conditional Indirect Call
 * Description: Function pointer selected based on runtime conditions
 * Expected: Multiple possible targets, data-dependent control flow
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef void (*action_t)(void);

void action_a(void) { printf("Action A executed\n"); }
void action_b(void) { printf("Action B executed\n"); }
void action_c(void) { printf("Action C executed\n"); }
void action_d(void) { printf("Action D executed\n"); }

action_t get_action(int condition) {
    if (condition < 0) {
        return action_a;
    } else if (condition == 0) {
        return action_b;
    } else if (condition < 10) {
        return action_c;
    } else {
        return action_d;
    }
}

action_t get_action_switch(int type) {
    switch (type % 4) {
        case 0: return action_a;
        case 1: return action_b;
        case 2: return action_c;
        default: return action_d;
    }
}

int main(void) {
    srand(time(NULL));
    
    // Conditional selection based on user input
    volatile int input = rand() % 20 - 5;  // Range: -5 to 14
    action_t fn = get_action(input);
    fn();  // Indirect call with conditionally selected target
    
    // Multiple conditional calls
    for (int i = 0; i < 3; i++) {
        action_t action = get_action_switch(rand());
        action();  // Different target each iteration
    }
    
    // Ternary operator selection
    action_t quick_pick = (input % 2 == 0) ? action_a : action_b;
    quick_pick();
    
    // Nested conditions
    action_t complex_pick = NULL;
    if (input > 0) {
        if (input > 5) {
            complex_pick = action_d;
        } else {
            complex_pick = action_c;
        }
    } else {
        complex_pick = (input < 0) ? action_a : action_b;
    }
    complex_pick();  // Call through complex conditional path
    
    return 0;
}
