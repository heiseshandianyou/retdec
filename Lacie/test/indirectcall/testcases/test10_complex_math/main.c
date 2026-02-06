/*
 * Test 10: Complex Computed Indirect Call
 * Description: Target computed through complex arithmetic
 * Expected: Non-trivial address computation before call
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef double (*math_func_t)(double);

double identity(double x) { return x; }
double square(double x) { return x * x; }
double cube(double x) { return x * x * x; }
double recip(double x) { return 1.0 / x; }
double neg(double x) { return -x; }
double abs_val(double x) { return x < 0 ? -x : x; }
double sigmoid(double x) { return 1.0 / (1.0 + exp(-x)); }
double relu(double x) { return x > 0 ? x : 0; }

math_func_t math_funcs[] = {
    identity, square, cube, recip, neg, abs_val, sigmoid, relu
};

const char* func_names[] = {
    "identity", "square", "cube", "recip", "neg", "abs", "sigmoid", "relu"
};

// Complex index computation
double apply_computed(int seed, double value) {
    // Complex formula to determine which function to call
    int idx = abs((seed * 7 + 13) % 8);  // Hash-like computation
    printf("Computed index for seed %d: %d (%s)\n", seed, idx, func_names[idx]);
    return math_funcs[idx](value);  // Indirect with computed target
}

double apply_formula(int a, int b, double value) {
    // Index depends on relationship between two values
    int idx;
    if (a > b) {
        idx = (a - b) % 4;
    } else if (a < b) {
        idx = 4 + (b - a) % 4;
    } else {
        idx = 0;  // identity
    }
    idx = idx & 7;  // Ensure valid
    printf("Formula index: %d (%s)\n", idx, func_names[idx]);
    return math_funcs[idx](value);
}

double apply_nested(int depth, double value) {
    // Recursive index computation
    int idx = depth % 8;
    if (depth > 0) {
        // Chain function calls
        double intermediate = apply_nested(depth - 1, value);
        return math_funcs[idx](intermediate);
    }
    return math_funcs[idx](value);
}

// Table lookup with computed offset
struct func_table {
    int base;
    math_func_t funcs[4];
};

struct func_table tables[] = {
    { 0, { identity, square, cube, recip } },
    { 4, { neg, abs_val, sigmoid, relu } }
};

double apply_table_lookup(int x, double value) {
    // Compute table and offset from x
    int table_idx = (x >> 2) & 1;  // High bits select table
    int func_offset = x & 3;       // Low bits select function
    
    math_func_t fn = tables[table_idx].funcs[func_offset];
    printf("Table %d, offset %d\n", table_idx, func_offset);
    return fn(value);
}

int main(void) {
    double test_val = 2.5;
    
    printf("=== Complex computed indices ===\n");
    for (int seed = 1; seed <= 5; seed++) {
        double result = apply_computed(seed, test_val);
        printf("Result: %f\n\n", result);
    }
    
    printf("=== Formula-based selection ===\n");
    apply_formula(10, 3, test_val);
    apply_formula(3, 10, test_val);
    apply_formula(5, 5, test_val);
    printf("\n");
    
    printf("=== Nested/chained calls ===\n");
    double nested_result = apply_nested(3, test_val);
    printf("Nested result: %f\n\n", nested_result);
    
    printf("=== Table lookup ===\n");
    for (int i = 0; i < 8; i++) {
        double r = apply_table_lookup(i, test_val);
        printf("Input %d -> %f\n\n", i, r);
    }
    
    return 0;
}
