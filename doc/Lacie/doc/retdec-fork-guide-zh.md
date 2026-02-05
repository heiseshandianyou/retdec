# RetDec 自定义分支维护指南

## 概述

由于 RetDec 官方目前处于**有限维护模式**，创建自己的 Fork 来维护自定义版本是一个非常好的选择。这样你可以：
- 合并社区的有用 PR
- 添加自己的修复和功能
- 保持项目的活跃度
- 定制特定需求的版本

---

## 创建 Fork 的步骤

### 1. 在 GitHub 上 Fork 仓库

访问 https://github.com/avast/retdec 并点击右上角的 **Fork** 按钮，将仓库复制到你的 GitHub 账户下。

### 2. 克隆你自己的 Fork

```bash
# 克隆你自己的 fork（替换 YOUR_USERNAME 为你的 GitHub 用户名）
git clone https://github.com/YOUR_USERNAME/retdec.git
cd retdec

# 添加官方仓库作为 upstream 远程
git remote add upstream https://github.com/avast/retdec.git

# 验证远程仓库
git remote -v
# 应该显示：
# origin    https://github.com/YOUR_USERNAME/retdec.git (fetch)
# origin    https://github.com/YOUR_USERNAME/retdec.git (push)
# upstream  https://github.com/avast/retdec.git (fetch)
# upstream  https://github.com/avast/retdec.git (push)
```

### 3. 保持与上游同步

```bash
# 获取上游更新
git fetch upstream

# 切换到 master 分支
git checkout master

# 合并上游更新
git merge upstream/master

# 推送到你的 fork
git push origin master
```

---

## 维护策略建议

### 方案一：定期同步官方更新

如果你希望保持与官方同步，同时添加自己的修改：

```bash
# 创建功能分支进行开发
git checkout -b my-feature-branch

# 进行修改并提交
git add .
git commit -m "添加新功能: xxx"

# 推送到你的 fork
git push origin my-feature-branch

# 定期同步官方更新
git checkout master
git pull upstream master
git push origin master

# 将 master 的更新合并到你的功能分支
git checkout my-feature-branch
git merge master
```

### 方案二：独立维护（硬分叉）

如果你决定完全独立维护，可以：

1. **重命名项目**（推荐避免混淆）
   - 修改 `README.md` 说明这是分支版本
   - 考虑更改项目名称（如 `retdec-community`）

2. **更新文档**
   - 添加维护者信息
   - 说明与官方版本的区别

3. **设置 CI/CD**
   - 配置 GitHub Actions 进行自动构建
   - 设置自动测试

---

## 推荐的维护工作流

### 创建开发分支

```bash
# 从 master 创建开发分支
git checkout -b develop

# 所有开发都在 develop 分支进行
# master 分支保持相对稳定
```

### 合并社区 PR

如果有人向官方仓库提交了有用的 PR 但未合并，你可以手动合并：

```bash
# 添加贡献者的远程仓库
git remote add contributor https://github.com/CONTRIBUTOR/retdec.git
git fetch contributor

# 查看并合并他们的分支
git checkout -b pr-branch contributor/feature-branch

# 测试后合并到 develop
git checkout develop
git merge pr-branch

# 推送
git push origin develop
```

### 版本管理

```bash
# 创建版本标签
git tag -a v5.1-custom -m "自定义版本 5.1"
git push origin v5.1-custom

# 或者使用语义化版本
git tag -a v5.0.1-community -m "社区维护版本 5.0.1"
git push origin v5.0.1-community
```

---

## 建议的改进方向

### 高优先级

1. **合并现有的有用 PR**
   - 查看官方仓库的未合并 PR
   - 选择修复了 bug 或添加了有用功能的 PR

2. **修复构建问题**
   - 更新依赖库到兼容版本
   - 修复新编译器的警告和错误

3. **现代化 CMake 配置**
   - 更新到 CMake 最新版本
   - 改进构建系统兼容性

### 中优先级

4. **添加测试覆盖**
   - 补充缺失的单元测试
   - 添加更多回归测试

5. **改进文档**
   - 添加 API 使用示例
   - 完善开发者文档

6. **性能优化**
   - 分析反编译性能瓶颈
   - 优化内存使用

### 低优先级

7. **新架构支持**
   - RISC-V
   - WebAssembly

8. **新功能**
   - 更好的 C++ 支持
   - 改进的类型恢复

---

## 社区协作建议

### 设置 GitHub 模板

创建以下文件来规范贡献流程：

```
.github/
├── ISSUE_TEMPLATE/
│   ├── bug_report.md
│   └── feature_request.md
├── PULL_REQUEST_TEMPLATE.md
└── CONTRIBUTING.md
```

### 启用 Discussions

在 GitHub 仓库设置中启用 Discussions 功能，方便社区交流。

### 创建 Discord/Slack 群组

建立实时通讯渠道，方便协作者沟通。

---

## 许可证注意事项

1. **保持许可证文件**
   - MIT 许可证要求保留版权声明
   - 不要删除原始作者信息

2. **添加你的版权声明**
   ```
   Copyright (c) 2017 Avast Software
   Copyright (c) 20XX YOUR_NAME  <- 添加你的
   ```

---

## 自动化脚本

### 同步脚本 (`sync-upstream.sh`)

```bash
#!/bin/bash
# 保存为 scripts/sync-upstream.sh

set -e

echo "=== 同步上游仓库 ==="

git fetch upstream
git checkout master
git merge upstream/master
git push origin master

echo "=== 同步完成 ==="
```

### 快速设置脚本 (`setup-fork.sh`)

```bash
#!/bin/bash
# 保存为 scripts/setup-fork.sh

UPSTREAM_URL="https://github.com/avast/retdec.git"

echo "=== 设置 RetDec Fork ==="

# 添加上游远程
git remote add upstream $UPSTREAM_URL
echo "已添加上游仓库: $UPSTREAM_URL"

# 获取上游分支
git fetch upstream

# 创建开发分支
git checkout -b develop

# 设置 upstream 追踪
git branch --set-upstream-to=upstream/master master

echo "=== 设置完成 ==="
echo "使用 'git pull upstream master' 同步上游更新"
```

---

## 示例：完整的日常维护流程

```bash
# 1. 开始工作前同步上游
cd retdec
git checkout master
git pull upstream master
git push origin master

# 2. 切换到开发分支并更新
git checkout develop
git merge master

# 3. 创建功能分支
git checkout -b feature/improve-arm-support

# 4. 进行修改...
# 编辑文件...

# 5. 提交更改
git add .
git commit -m "feat: 改进 ARM64 架构支持

- 修复了 xxx 指令的解码
- 优化了寄存器分配算法"

# 6. 推送到你的 fork
git push origin feature/improve-arm-support

# 7. 创建 PR 合并到 develop（如果有协作者）
# 或者自己合并
git checkout develop
git merge feature/improve-arm-support
git push origin develop

# 8. 删除功能分支
git branch -d feature/improve-arm-support
git push origin --delete feature/improve-arm-support

# 9. 定期将 develop 合并到 master 发布版本
git checkout master
git merge develop
git tag -a v5.0.1-community -m "社区版本 5.0.1"
git push origin master --tags
```

---

## 推荐的 Fork 命名

如果不想重命名项目，可以考虑在 README 中添加标识：

```markdown
# RetDec (社区维护版)

这是 RetDec 的社区维护分支，原始项目由 Avast 开发。

## 与官方版本的区别

- 合并了更多社区贡献的修复
- 定期更新依赖库
- 更快的 bug 修复响应
```

或者完全重命名：
- `retdec-community`
- `retdec-ng` (next generation)
- `retdec-continued`

---

## 结论

创建自己的 Fork 是**完全可行且推荐**的做法！由于官方维护有限，社区驱动的分支可以帮助保持项目的活力。关键是要：

1. ✅ 遵守 MIT 许可证要求
2. ✅ 保持与上游的同步（可选但推荐）
3. ✅ 建立清晰的贡献流程
4. ✅ 积极与社区互动

祝你的维护工作顺利！🚀
