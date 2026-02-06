/*
 * Test 04: Virtual Table Simulation (C-style)
 * Description: Simulates C++ vtable mechanism in C
 * Expected: call [obj + offset] pattern typical of OOP
 */

#include <stdio.h>
#include <stdlib.h>

// Base "class" with vtable
struct base_vtable {
    void (*speak)(void* self);
    int (*calculate)(void* self, int x);
};

struct base {
    struct base_vtable* vtable;
    int data;
};

// Derived "class" A
struct derived_a {
    struct base base;
    int extra_a;
};

void speak_a(void* self) {
    struct derived_a* obj = self;
    printf("Derived A speaks, data=%d\n", obj->base.data);
}

int calc_a(void* self, int x) {
    struct derived_a* obj = self;
    return obj->base.data + x + obj->extra_a;
}

struct base_vtable vtable_a = { speak_a, calc_a };

// Derived "class" B
struct derived_b {
    struct base base;
    float factor;
};

void speak_b(void* self) {
    struct derived_b* obj = self;
    printf("Derived B speaks, data=%d, factor=%f\n", obj->base.data, obj->factor);
}

int calc_b(void* self, int x) {
    struct derived_b* obj = self;
    return (int)(obj->base.data + x * obj->factor);
}

struct base_vtable vtable_b = { speak_b, calc_b };

int main(void) {
    struct derived_a obj_a = { { &vtable_a, 10 }, 5 };
    struct derived_b obj_b = { { &vtable_b, 20 }, 2.5f };
    
    struct base* objects[2] = { (struct base*)&obj_a, (struct base*)&obj_b };
    
    // Polymorphic calls through vtable
    for (int i = 0; i < 2; i++) {
        objects[i]->vtable->speak(objects[i]);  // Indirect call
        int result = objects[i]->vtable->calculate(objects[i], 100);  // Indirect call
        printf("Result: %d\n", result);
    }
    
    return 0;
}
