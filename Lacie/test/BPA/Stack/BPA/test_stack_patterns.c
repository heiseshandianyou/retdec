/*
 * Test: Stack Access Patterns Analysis
 * Description: 验证 Stack Pass 对不同栈访问模式的处理
 * 
 * 测试场景：
 * 1. 基于 RBP 的访问（局部变量）- 预期：不被 Stack Pass 处理
 * 2. 基于 RSP 的访问（push/pop）- 预期：被处理
 * 3. 动态 RSP 变化（多次 sub/add）- 预期：可能有问题
 * 4. 混合访问（RBP 和 RSP）- 对比处理结果
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <alloca.h>

/*
 * Test 1: 简单局部变量（基于 RBP）
 * 预期：Stack Pass 不处理（保持 [ebp-X] 形式）
 */
void test_rbp_locals(void) {
    int local_a = 10;      // [ebp-4]
    int local_b = 20;      // [ebp-8]
    int local_c;           // [ebp-12]
    
    local_c = local_a + local_b;  // 读取 [ebp-4], [ebp-8], 存储 [ebp-12]
    printf("RBP locals: %d\n", local_c);
}

/*
 * Test 2: 动态栈分配（基于 RSP）
 * 预期：Stack Pass 处理（转换为 alloca）
 */
void test_rsp_dynamic(int n) {
    // volatile 防止优化
    volatile int arr[10];  // 编译器可能用 RSP 访问
    
    for (int i = 0; i < 10; i++) {
        arr[i] = i * n;    // 可能生成 [rsp+X] 访问
    }
    
    int sum = 0;
    for (int i = 0; i < 10; i++) {
        sum += arr[i];     // 再次 [rsp+X] 访问
    }
    
    printf("RSP dynamic: %d\n", sum);
}

/*
 * Test 3: 复杂的 RSP 变化（多次 sub/add）
 * 预期：可能出现问题，同一位置可能有不同 offset
 */
void test_rsp_complex(int flag) {
    volatile int temp1, temp2, temp3;
    
    // 场景：RSP 多次变化，访问相同逻辑位置
    temp1 = 100;  // 某个 [rsp+X]
    
    if (flag > 0) {
        volatile int extra = flag;  // 额外的栈空间
        temp2 = temp1 + extra;      // RSP 已经变化
    } else {
        temp2 = temp1 - 10;
    }
    
    temp3 = temp2 * 2;  // RSP 再次变化
    
    printf("RSP complex: %d\n", temp3);
}

/*
 * Test 4: push/pop 序列（基于 RSP）
 * 预期：Stack Pass 应该能处理
 */
void test_push_pop(void) {
    volatile long saved_regs[4];
    
    // 模拟寄存器保存（编译器可能生成 push 或 [rsp+X]）
    saved_regs[0] = 1;
    saved_regs[1] = 2;
    saved_regs[2] = 3;
    saved_regs[3] = 4;
    
    long sum = saved_regs[0] + saved_regs[1] 
             + saved_regs[2] + saved_regs[3];
    
    printf("Push/pop: %ld\n", sum);
}

/*
 * Test 5: 变长数组（动态栈分配）
 * 预期：Stack Pass 可能无法处理（大小是变量）
 */
void test_vla(int n) {
    if (n <= 0 || n > 100) n = 10;
    
    // 变长数组 - 需要动态栈分配
    volatile int vla[n];
    
    for (int i = 0; i < n; i++) {
        vla[i] = i * i;
    }
    
    int sum = 0;
    for (int i = 0; i < n; i++) {
        sum += vla[i];
    }
    
    printf("VLA: %d\n", sum);
}

/*
 * Test 6: 嵌套调用（栈帧布局复杂）
 */
void helper(int x) {
    volatile int local = x * 2;  // [ebp-4] 或 [rsp+X]
    printf("Helper: %d\n", local);
}

void test_nested_calls(void) {
    int a = 10;  // 局部变量
    helper(a);
    helper(a + 5);
    printf("Nested: %d\n", a);
}

/*
 * Test 7: 强制产生 [rsp+offset] 相同但地址不同的情况
 * 
 * 关键场景：通过 inline asm 插入 push/pop 改变 RSP
 * 同时编译器继续使用 [rsp+offset] 访问局部变量
 * 
 * 期望汇编（概念）：
 *   mov [rsp+8], eax    ; 变量A，RSP=X 时访问 X+8
 *   push ebx            ; RSP = X-8
 *   mov [rsp+16], ecx   ; 变量B，RSP=X-8 时访问 (X-8)+16 = X+8
 *                       ; 和变量A是同一地址！但 offset 都是+8？不对
 *   
 *   修正场景：
 *   mov [rsp+8], eax    ; 变量A，offset=+8，地址=X+8
 *   push ebx            ; RSP = X-8  
 *   mov [rsp+8], ecx    ; 变量B，offset=+8，地址=(X-8)+8 = X
 *                       ; 同一 offset (+8)，不同地址！
 */
void test_rsp_alias_with_push(void) {
    // volatile 局部数组，编译器必须使用栈访问
    volatile int arr[4];
    
    // 初始化数组
    arr[0] = 1;  // [rsp+0] 或 [rbp-X]
    arr[1] = 2;  // [rsp+4]
    
    // 使用 inline asm 改变 RSP，但不告诉编译器
    // 同时保持 arr 的访问
    int temp;
    asm volatile(
        "push %%rax\n\t"          // RSP -= 8
        "movl $99, %[arr0]\n\t"  // 再次访问 arr[0]，此时 RSP 已经变了
        "pop %%rax"              // RSP += 8
        : [arr0] "=m" (arr[0])
        :
        : "rax", "memory"
    );
    
    // arr[0] 被修改了两次
    printf("RSP alias: %d\n", arr[0]);
}

/*
 * Test 8: 嵌套 alloca 作用域
 * 更复杂的场景，多层 alloca
 */
void test_nested_alloca(int n) {
    // 外层分配
    volatile int* outer = (volatile int*)alloca(sizeof(int) * n);
    outer[0] = 10;
    
    if (n > 5) {
        // 内层分配，RSP 进一步变化
        volatile int* inner = (volatile int*)alloca(sizeof(int) * 4);
        inner[0] = 20;
        inner[1] = outer[0];  // 访问 outer，需要计算 offset
        outer[1] = inner[0];  // 反向访问
        printf("Inner: %d\n", inner[1]);
    }
    
    printf("Outer: %d\n", outer[0]);
}

/* ========== 主函数 ========== */

int main(int argc, char *argv[]) {
    printf("=== Stack Patterns Test ===\n");
    
    test_rbp_locals();
    test_rsp_dynamic(argc > 1 ? argc : 5);
    test_rsp_complex(argc);
    test_push_pop();
    test_vla(argc);
    test_nested_calls();
    test_rsp_alias_with_push();   // 新增：RSP alias 测试
    test_nested_alloca(argc);     // 新增：嵌套 alloca 测试
    
    printf("=== All tests completed ===\n");
    return 0;
}
