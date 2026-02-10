/*
 * Test: Memory Access Instructions Disassembly
 * Description: 测试只经过 decoder pass 后，各种内存访问指令的反汇编结果
 * 
 * 这个测试用例涵盖了以下内存访问模式：
 * 1. 栈变量访问（局部变量读写）
 * 2. 全局变量访问
 * 3. 堆内存访问（malloc/free）
 * 4. 数组访问（常量索引和变量索引）
 * 5. 结构体成员访问
 * 6. 指针解引用（多级指针）
 * 7. 函数指针内存加载
 * 
 * 预期在 decoder pass 后生成：
 * - load/store 指令
 * - getelementptr (GEP) 地址计算
 * - 寄存器到寄存器的值传递
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ========== 全局变量定义 ========== */

// 简单全局变量
int global_int = 42;
char global_array[64] = {0};

// 全局指针变量
int *global_ptr = NULL;
void (*global_func_ptr)(void) = NULL;

// 结构体定义
typedef struct {
    int id;
    int value;
    char name[16];
} DataRecord;

// 全局结构体
DataRecord global_record = {1, 100, "global"};
DataRecord *global_record_ptr = NULL;

// 函数指针类型
typedef void (*callback_t)(int);
typedef int (*binary_op_t)(int, int);

/* ========== 辅助函数 ========== */

void dummy_callback(int x) {
    printf("callback: %d\n", x);
}

void another_callback(int x) {
    printf("another: %d\n", x);
}

int add_op(int a, int b) { return a + b; }
int sub_op(int a, int b) { return a - b; }

/* ========== 测试函数 ========== */

/*
 * Test 1: 栈变量基础访问
 * 测试局部变量的读写操作
 */
void test_stack_access(void) {
    // 基础类型栈变量
    int local_a = 10;           // 栈分配 + store
    int local_b = 20;           // 栈分配 + store
    int local_c;                // 未初始化栈变量
    
    // 栈变量读取和写入
    local_c = local_a + local_b;  // load + load + add + store
    local_a = local_c;            // load + store
    
    // 使用 volatile 防止优化
    volatile int vol_local = 100;
    vol_local = vol_local + 1;    // load + add + store
    
    printf("Stack: %d\n", local_c);
}

/*
 * Test 2: 全局变量访问
 * 测试全局变量的读写
 */
void test_global_access(void) {
    // 读取全局变量
    int temp = global_int;        // 从全局内存加载
    
    // 写入全局变量
    global_int = temp + 1;        // store 到全局内存
    
    // 全局数组访问
    global_array[0] = 'A';        // 常量索引数组访问
    global_array[temp % 16] = 'B'; // 变量索引数组访问
    
    char c = global_array[0];     // 从全局数组加载
    
    printf("Global: %d, %c\n", temp, c);
}

/*
 * Test 3: 堆内存访问
 * 测试 malloc/free 分配内存的访问
 */
void test_heap_access(void) {
    // 基础堆分配
    int *heap_int = (int *)malloc(sizeof(int));  // 堆分配
    *heap_int = 42;                               // 通过指针 store
    int val = *heap_int;                          // 通过指针 load
    
    // 堆数组
    int *heap_array = (int *)malloc(10 * sizeof(int));
    heap_array[0] = 0;           // 常量索引堆数组访问
    heap_array[5] = 50;          // 常量索引
    heap_array[val % 10] = 99;   // 变量索引
    
    // 堆上的结构体
    DataRecord *heap_record = (DataRecord *)malloc(sizeof(DataRecord));
    heap_record->id = 1;                    // 结构体字段访问
    heap_record->value = val;
    strcpy(heap_record->name, "heap");      // 数组字段访问
    
    int id = heap_record->id;               // 从结构体加载
    
    printf("Heap: %d, %d\n", val, id);
    
    // 释放内存
    free(heap_int);
    free(heap_array);
    free(heap_record);
}

/*
 * Test 4: 数组访问
 * 测试各种数组访问模式
 */
void test_array_access(void) {
    // 栈数组
    int stack_arr[16];
    int i = 5;
    
    // 常量索引
    stack_arr[0] = 100;
    stack_arr[15] = 200;
    
    // 变量索引
    stack_arr[i] = 300;
    stack_arr[i + 2] = 400;
    
    // 读取数组元素
    int a = stack_arr[0];
    int b = stack_arr[i];
    
    // 多维数组（模拟）
    int matrix[4][4];
    matrix[0][0] = 1;      // 多维数组访问
    matrix[i][i] = 2;
    int m = matrix[1][2];
    
    printf("Array: %d, %d, %d\n", a, b, m);
}

/*
 * Test 5: 结构体访问
 * 测试结构体成员的访问
 */
void test_struct_access(void) {
    // 栈上的结构体
    DataRecord local_record;
    
    // 结构体成员写入
    local_record.id = 10;
    local_record.value = 20;
    strcpy(local_record.name, "local");
    
    // 结构体成员读取
    int id = local_record.id;
    int val = local_record.value;
    char first_char = local_record.name[0];
    
    // 通过指针访问结构体
    DataRecord *ptr = &local_record;
    ptr->id = 30;                    // 指针解引用写入
    int new_id = ptr->id;            // 指针解引用读取
    
    // 全局结构体访问
    global_record.value = val;
    int gv = global_record.value;
    
    printf("Struct: %d, %d, %c, %d\n", id, val, first_char, gv);
}

/*
 * Test 6: 指针操作
 * 测试多级指针和解引用
 */
void test_pointer_ops(void) {
    int x = 10;
    int *p1 = &x;          // 一级指针
    int **p2 = &p1;        // 二级指针
    int ***p3 = &p2;       // 三级指针
    
    // 多级解引用
    *p1 = 20;              // 一级解引用 store
    **p2 = 30;             // 二级解引用 store
    ***p3 = 40;            // 三级解引用 store
    
    int a = *p1;           // 一级解引用 load
    int b = **p2;          // 二级解引用 load
    int c = ***p3;         // 三级解引用 load
    
    // 指针算术
    int arr[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    int *p = arr;
    p = p + 3;             // 指针加法
    int v1 = *p;           // 访问 arr[3]
    p = p - 1;             // 指针减法
    int v2 = *p;           // 访问 arr[2]
    
    printf("Pointer: %d, %d, %d, %d, %d\n", a, b, c, v1, v2);
}

/*
 * Test 7: 函数指针加载
 * 测试从内存加载函数指针
 */
void test_funcptr_load(void) {
    // 栈上的函数指针
    callback_t cb;
    binary_op_t op;
    
    // 直接赋值（地址获取）
    cb = dummy_callback;
    op = add_op;
    
    // 通过函数指针调用（会产生内存加载）
    cb(100);               // 从栈/寄存器加载函数指针
    int result = op(10, 20);
    
    // 函数指针数组
    callback_t callbacks[2] = {dummy_callback, another_callback};
    callbacks[0](1);       // 数组索引 + 函数指针加载
    callbacks[1](2);
    
    // 从全局加载函数指针
    global_func_ptr = dummy_callback;
    if (global_func_ptr) {
        global_func_ptr(); // 从全局内存加载函数指针
    }
    
    printf("FuncPtr: %d\n", result);
}

/*
 * Test 8: 复杂内存访问模式
 * 测试组合多种内存访问
 */
void test_complex_patterns(void) {
    // 结构体数组
    DataRecord records[3];
    for (int i = 0; i < 3; i++) {
        records[i].id = i;
        records[i].value = i * 10;
    }
    
    // 动态数据结构（链表节点）
    typedef struct Node {
        int data;
        struct Node *next;
    } Node;
    
    Node *head = (Node *)malloc(sizeof(Node));
    head->data = 0;
    head->next = (Node *)malloc(sizeof(Node));
    head->next->data = 1;
    head->next->next = NULL;
    
    // 遍历链表（多级指针访问）
    Node *curr = head;
    while (curr != NULL) {
        curr->data = curr->data + 1;  // load + add + store
        curr = curr->next;             // 加载下一个指针
    }
    
    // 清理
    free(head->next);
    free(head);
    
    printf("Complex: done\n");
}

/*
 * Test 9: 内存拷贝操作
 * 测试 memcpy 等内存操作
 */
void test_memory_copy(void) {
    char src[32] = "Hello, World!";
    char dst[32];
    
    // 手动拷贝
    for (int i = 0; i < 14; i++) {
        dst[i] = src[i];   // 逐个字符 load/store
    }
    
    // 库函数拷贝
    char buf2[32];
    memcpy(buf2, src, 14);  // 可能内联为多次 load/store
    
    printf("Copy: %s\n", dst);
}

/*
 * Test 10: 条件内存访问
 * 测试带条件分支的内存访问
 */
void test_conditional_access(int flag) {
    int a = 10, b = 20;
    int result;
    
    // 条件加载
    if (flag > 0) {
        result = a;        // 条件分支中的 load
    } else {
        result = b;        // 另一分支中的 load
    }
    
    // 条件存储
    int *ptr = NULL;
    if (flag != 0) {
        ptr = &a;
    } else {
        ptr = &b;
    }
    *ptr = 100;            // 可能指向 a 或 b 的 store
    
    printf("Conditional: %d\n", result);
}

/* ========== 主函数 ========== */

int main(int argc, char *argv[]) {
    printf("=== Memory Access Test ===\n");
    
    test_stack_access();
    test_global_access();
    test_heap_access();
    test_array_access();
    test_struct_access();
    test_pointer_ops();
    test_funcptr_load();
    test_complex_patterns();
    test_memory_copy();
    test_conditional_access(argc > 1 ? 1 : 0);
    
    printf("=== All tests completed ===\n");
    return 0;
}
