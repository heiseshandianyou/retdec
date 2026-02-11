# BPA Stack Boundary Collection Test

这个测试用于验证 **BPA (Bounded Path Analysis) 第一步**：收集栈变量边界候选值，包括**动态栈分配**的追踪。

## 测试目的

BPA 算法的第一步是收集所有相对于函数入口栈顶（"top"）的栈访问偏移，这些偏移值作为后续"栈切分"的边界候选。

**关键特性**：支持动态栈分配（VLA/alloca）的基地址追踪

## 输出示例

```
Function: function_1189
  Address: 0x0x1189
  Total stack accesses: 8
  Successfully processed: 8
  Unprocessed: 0
  
  Dynamic stack regions: 1
    Region 0: base=-16, size=unknown (Dynamic alloc at offset -16)
  
  Top-relative boundaries (candidates): [-20, -16, -12, -8]
  Static RSP-based offsets: [-12, -8] (4 accesses)
  Dynamic region accesses: 4
```

## 关键概念

### 1. 静态栈访问 vs 动态栈访问

```
静态栈访问（编译时已知大小）:
  sub rsp, 32          ; 分配 32 字节
  mov [rsp+8], eax     ; 访问 [top - 32 + 8] = [top - 24]
  
动态栈访问（运行时决定大小）:
  sub rsp, n           ; n 是变量（VLA）
  mov [rsp+0], ebx     ; 访问 [top - n + 0]
                       ; 基地址 = top - n（动态区域基址）
                       ; 相对偏移 = 0
```

### 2. 归一化偏移计算

| 访问类型 | 原始形式 | 基地址（相对于 top） | 相对偏移 | 归一化偏移 |
|---------|---------|-------------------|---------|-----------|
| 静态 RSP | `[rsp + 8]` | 0 | 8 | 8 |
| 静态 RBP | `[rbp - 12]` | -8 | -12 | -20 |
| 动态区域 | `[rsp + 4]` (在 region 0) | -16 | 4 | -12 |

### 3. 动态区域识别

动态栈区域通过以下模式识别：
- `sub rsp, X` 其中 X > 8（大于单个 push）
- 后续访问使用当前 RSP 作为基址

## 输出字段说明

| 字段 | 说明 |
|-----|------|
| `Dynamic stack regions` | 检测到的动态分配区域数量 |
| `Region X: base=...` | 动态区域基地址（相对于 top） |
| `Static RSP-based offsets` | 静态栈访问的偏移（编译时固定） |
| `Dynamic region accesses` | 属于动态区域的访问次数 |
| `Top-relative boundaries` | 所有归一化偏移的集合（用于后续栈切分） |

## BPA 算法的下一步

边界收集完成后，下一步是**栈切分（Stack Partitioning）**：

1. **静态区域**：按归一化偏移划分固定大小的栈变量
2. **动态区域**：为每个动态区域创建独立的内存块表示
3. **变量映射**：将访问映射到对应的栈变量/动态区域

## 技术细节

### 动态区域追踪算法

```
遍历函数指令:
  如果遇到 RSP 修改 (store to @rsp):
    如果修改量 > 8 字节:
      创建新的 DynamicStackRegion
      记录基地址 = 当前 RSP 偏移
  
  如果遇到栈访问:
    计算归一化偏移
    检查是否落在某个动态区域内
    如果是: 标记为 dynamic region access
    否则: 标记为 static access
```

### 边界候选值

所有归一化偏移（包括静态和动态）构成边界候选集合，用于后续的栈切分算法。
