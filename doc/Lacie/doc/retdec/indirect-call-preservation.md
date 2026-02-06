# RetDec 间接调用保留机制修改说明

## 修改概述

为了让后续指向分析（points-to analysis）能够处理间接调用，我们修改了 RetDec 的 decoder，使其保留那些无法在静态分析时确定目标的间接调用。

## 修改文件

| 文件 | 修改类型 | 说明 |
|------|---------|------|
| `include/retdec/bin2llvmir/optimizations/decoder/decoder.h` | 添加声明 | 5 个新成员函数 |
| `src/bin2llvmir/optimizations/decoder/decoder.cpp` | 修改实现 | 修改 2 处，添加约 150 行代码 |

## 详细修改

### 1. 头文件修改 (decoder.h)

在 `resolvePseudoCalls()` 和 `finalizePseudoCalls()` 声明之后，添加了以下函数声明：

```cpp
// Indirect call handling.
//
void preserveIndirectCalls();
void cleanupIndirectCallSetup(llvm::CallInst* pseudo);
bool isIndirectCallPseudo(llvm::CallInst* call) const;
std::vector<llvm::CallInst*> getIndirectCalls() const;
llvm::Value* getIndirectCallTarget(llvm::CallInst* call) const;
```

### 2. 实现文件修改 (decoder.cpp)

#### 2.1 修改 `resolvePseudoCalls()`

**原代码**（删除未解析的调用）：
```cpp
if (t.isUndefined())
{
    ++i;
    auto* st = llvm::cast<llvm::StoreInst>(*real->user_begin());
    st->eraseFromParent();
    real->eraseFromParent();
}
```

**新代码**（保留供后续处理）：
```cpp
if (t.isUndefined())
{
    ++i;
    // Indirect call target not resolved.
    // Leave it for preserveIndirectCalls() to handle.
    // Do not delete here - we want to keep the call for later analysis.
    LOG << "\t\t" << "Unresolved call @ " 
        << AsmInstruction::getInstructionAddress(real)
        << ", will preserve for points-to analysis" << std::endl;
}
```

#### 2.2 在调用序列中添加 `preserveIndirectCalls()`

**原顺序**：
```cpp
resolvePseudoCalls();
patternsRecognize();
finalizePseudoCalls();
```

**新顺序**：
```cpp
resolvePseudoCalls();
preserveIndirectCalls();  // 新增
patternsRecognize();
finalizePseudoCalls();
```

#### 2.3 修改 `finalizePseudoCalls()`

在删除伪调用之前，检查是否是间接调用：

```cpp
// Skip indirect calls - they are preserved for points-to analysis.
if (icf && isIndirectCallPseudo(pseudo))
{
    cleanupIndirectCallSetup(pseudo);
    continue;
}
```

#### 2.4 新增函数实现

在文件末尾添加了 5 个新函数的实现（约 150 行代码）。

## 新增函数详解

### `preserveIndirectCalls()`

遍历所有伪调用，对于未被解析为真实调用的 `call` 类型伪调用：

1. 添加元数据标记 `"retdec.call_type" = "indirect_call"`
2. 将目标操作数存入元数据 `"retdec.indirect_target"`
3. 保留伪调用及其操作数，供后续分析使用

### `isIndirectCallPseudo(CallInst*)`

检查一个调用指令是否是保留的间接调用伪调用，通过检查元数据标记。

### `cleanupIndirectCallSetup(CallInst*)`

清理间接调用的 setup 代码（如栈操作），但保留伪调用本身及其目标操作数。

### `getIndirectCalls()`

供后续指向分析使用，返回模块中所有保留的间接调用伪调用列表。

### `getIndirectCallTarget(CallInst*)`

供后续指向分析使用，获取间接调用的目标值（`Value*`）。

## 使用示例

### 在后续指向分析 Pass 中

```cpp
void PointsToAnalysis::runOnModule(llvm::Module& m)
{
    // 获取 decoder（通过配置或分析管理器）
    auto* decoder = getAnalysis<Decoder>();
    
    // 获取所有间接调用
    auto indirectCalls = decoder->getIndirectCalls();
    
    for (auto* call : indirectCalls)
    {
        // 获取目标值
        auto* targetVal = decoder->getIndirectCallTarget(call);
        
        // 进行指向分析
        auto pointsToSet = analyzePointsTo(targetVal);
        
        if (pointsToSet.empty())
        {
            LOG << "No targets found for indirect call" << std::endl;
            continue;
        }
        
        // 根据分析结果展开为直接调用
        // ...
    }
}
```

## LLVM IR 变化

### 修改前（间接调用被删除）

```llvm
; 伪调用（会被删除）
call void @_callFunction(i32 %eax)
; 无后续指令
```

### 修改后（间接调用被保留）

```llvm
; 带元数据标记的伪调用（被保留）
call void @_callFunction(i32 %eax), !retdec.call_type !0, !retdec.indirect_target !1

; !0 = !{!"indirect_call"}
; !1 = !{i32 %eax}
```

## 编译测试

```bash
cd /home/lacie/project/retdec1/retdec/build
make -j$(nproc) 2>&1 | head -50
```

## 注意事项

1. **向后兼容**：如果不使用指向分析，这些保留的间接调用在 `finalizePseudoCalls()` 中会被特殊处理，不会影响正常流程

2. **元数据开销**：使用 LLVM 元数据标记，开销极小，不影响优化

3. **日志输出**：可以通过日志查看保留了多少间接调用：
   ```
   preserveIndirectCalls():
       [+] Preserved indirect call @ 0x401234
       Total preserved: 5
   ```

## 未来扩展

可以进一步扩展此机制：

1. **全局变量提升**：将间接调用目标提升到全局变量，方便跨函数分析
2. **类型信息保留**：保留调用签名信息，用于类型匹配的指向分析
3. **动态插桩**：在保留的间接调用处插入插桩代码，用于动态分析
