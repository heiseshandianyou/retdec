/*
 * Test 05: Struct Pointer Indirect Call
 * Description: Function pointer embedded in struct
 * Expected: call [struct_ptr + offset] pattern
 */

#include <stdio.h>
#include <string.h>

typedef int (*compare_func_t)(const void*, const void*);
typedef void (*print_func_t)(const void*);

struct type_ops {
    const char* type_name;
    compare_func_t compare;
    print_func_t print;
    size_t size;
};

int compare_int(const void* a, const void* b) {
    int x = *(const int*)a;
    int y = *(const int*)b;
    return (x > y) - (x < y);
}

void print_int(const void* p) {
    printf("%d", *(const int*)p);
}

int compare_string(const void* a, const void* b) {
    return strcmp((const char*)a, (const char*)b);
}

void print_string(const void* p) {
    printf("\"%s\"", (const char*)p);
}

struct type_ops int_ops = { "int", compare_int, print_int, sizeof(int) };
struct type_ops string_ops = { "string", compare_string, print_string, 0 };

void process_items(void* items, int n, struct type_ops* ops) {
    printf("Processing %d items of type %s:\n", n, ops->type_name);
    
    for (int i = 0; i < n; i++) {
        printf("  Item %d: ", i);
        ops->print((char*)items + i * ops->size);  // Indirect call
        printf("\n");
    }
    
    // Compare adjacent items
    if (n >= 2) {
        int cmp = ops->compare(items, (char*)items + ops->size);  // Indirect call
        printf("First two items comparison: %d\n", cmp);
    }
}

int main(void) {
    int numbers[] = { 42, 17, 99, 3, 56 };
    const char* strings[] = { "apple", "banana", "cherry" };
    
    process_items(numbers, 5, &int_ops);       // Calls through ops->print, ops->compare
    process_items(strings, 3, &string_ops);    // Different function pointers
    
    return 0;
}
