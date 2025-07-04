# Claude Code 提示词管理仓库

这个仓库用于管理和组织Claude Code的各种提示词，方便在不同项目间复用。

## 仓库结构

```
claude-prompts-repo/
├── prompts/                    # 核心提示词
│   ├── ultrathink-task.md     # 超级思考模式
│   ├── code-review.md         # 代码审查
│   ├── architecture-design.md # 架构设计
│   └── debugging.md           # 调试助手
├── templates/                  # 项目模板
│   ├── web3-project.md        # Web3项目模板
│   ├── react-project.md       # React项目模板
│   └── go-backend.md          # Go后端模板
├── scripts/                    # 管理脚本
│   ├── install.sh             # 安装脚本
│   ├── sync.sh                # 同步脚本
│   └── update.sh              # 更新脚本
└── README.md                   # 本文件
```

## 🚀 快速开始

### 1. 全局安装（只需一次）
```bash
~/claude-prompts-repo/scripts/install.sh
source ~/.bashrc
```

### 2. 跨项目使用

#### 🆕 新项目快速初始化
```bash
cd /path/to/your/new/project
~/claude-prompts-repo/scripts/init-project.sh -n my-project -t react
```

**支持的项目类型：**
- `react` - React应用
- `vue` - Vue应用
- `nodejs` - Node.js项目
- `go` - Go项目
- `python` - Python项目
- `rust` - Rust项目
- `java` - Java项目
- `php` - PHP项目

#### 📁 现有项目同步
```bash
cd /path/to/existing/project
~/claude-prompts-repo/scripts/sync.sh
```

#### 🔧 手动复制（不推荐）
```bash
# 复制特定提示词到项目
cp ~/claude-prompts-repo/prompts/ultrathink-task.md .claude/
```

## 使用方法

### Ultrathink Task 模式
在Claude Code中使用：
```
/project:ultrathink-task 创建一个用户认证系统
```

### 自定义指令设置
1. 在VSCode中打开Claude Code设置
2. 找到"Custom Instructions"或"Slash Commands"
3. 导入相应的提示词文件

## 提示词说明

### ultrathink-task.md
- **功能**：4个子代理协作的超级思考模式
- **适用**：复杂编程任务、架构设计、全栈开发
- **子代理**：架构、研究、编码、测试

### code-review.md
- **功能**：专业代码审查
- **适用**：代码质量检查、安全审计、性能优化

### architecture-design.md
- **功能**：系统架构设计
- **适用**：新项目规划、技术选型、扩展性设计

## 更新和维护

### 更新提示词
```bash
cd ~/claude-prompts-repo
git pull origin main
./scripts/update.sh
```

### 添加新提示词
1. 在`prompts/`目录创建新的`.md`文件
2. 按照现有格式编写提示词
3. 更新本README文件
4. 运行同步脚本

## 🔄 跨项目使用详解

### 工作流程

#### 方案一：新项目自动初始化（推荐）
```bash
# 1. 进入新项目目录
cd /path/to/new/project

# 2. 自动初始化（会检测项目类型）
~/claude-prompts-repo/scripts/init-project.sh

# 3. 或者手动指定项目类型
~/claude-prompts-repo/scripts/init-project.sh -n my-app -t react
```

**自动初始化会：**
- 🔍 自动检测项目类型（基于package.json、go.mod等）
- 📋 复制所有提示词文件到`.claude/`目录
- 📖 生成项目特定的指导文档
- ⚙️ 创建项目配置文件
- 🚀 提供快速命令脚本

#### 方案二：现有项目同步
```bash
# 1. 进入现有项目目录
cd /path/to/existing/project

# 2. 同步提示词（会备份现有配置）
~/claude-prompts-repo/scripts/sync.sh
```

### 使用场景示例

#### 场景1：创建新的React项目
```bash
# 创建项目
npx create-react-app my-app
cd my-app

# 初始化Claude提示词
~/claude-prompts-repo/scripts/init-project.sh -t react

# 在Claude Code中使用
# /project:ultrathink-task 创建一个用户登录组件
```

#### 场景2：Go微服务项目
```bash
# 创建Go项目
mkdir my-service && cd my-service
go mod init my-service

# 初始化Claude提示词
~/claude-prompts-repo/scripts/init-project.sh -t go

# 在Claude Code中使用
# /project:ultrathink-task 设计RESTful API架构
```

#### 场景3：多项目团队协作
```bash
# 团队成员A在项目A
cd /workspace/project-a
~/claude-prompts-repo/scripts/sync.sh

# 团队成员B在项目B
cd /workspace/project-b
~/claude-prompts-repo/scripts/sync.sh

# 所有人都能使用相同的提示词
```

## 📋 常用命令速查

### 管理命令
```bash
# 查看帮助
~/claude-prompts-repo/scripts/help.sh

# 全局安装
~/claude-prompts-repo/scripts/install.sh

# 新项目初始化
~/claude-prompts-repo/scripts/init-project.sh -n <项目名> -t <类型>

# 同步到当前项目
~/claude-prompts-repo/scripts/sync.sh

# 更新提示词
~/claude-prompts-repo/scripts/update.sh
```

### 项目内快速命令
```bash
# 查看项目指导
cat .claude/project-guide.md

# 查看快速命令
.claude/quick-start.sh

# 查看项目配置
cat .claude/project-config.json
```

## 🔧 故障排除

### 常见问题

**Q: 提示词不生效怎么办？**
```bash
# 1. 检查.claude目录是否存在
ls -la .claude/

# 2. 重新同步
~/claude-prompts-repo/scripts/sync.sh

# 3. 检查Claude Code是否识别到项目配置
```

**Q: 如何在新项目中快速设置？**
```bash
# 使用自动初始化脚本
~/claude-prompts-repo/scripts/init-project.sh
```

**Q: 如何自定义提示词？**
```bash
# 1. 编辑全局提示词
vim ~/claude-prompts-repo/prompts/ultrathink-task.md

# 2. 同步到项目
~/claude-prompts-repo/scripts/sync.sh

# 3. 或直接编辑项目提示词
vim .claude/ultrathink-task.md
```

**Q: 多个项目如何保持同步？**
```bash
# 在每个项目目录运行
~/claude-prompts-repo/scripts/sync.sh
```

## 🌍 环境兼容性

- ✅ VSCode + Claude Code
- ✅ Cursor IDE
- ✅ 其他支持Claude的IDE
- ✅ Linux/macOS/Windows
- ✅ 支持所有主流编程语言项目

## 贡献指南

1. Fork本仓库
2. 创建功能分支
3. 添加或修改提示词
4. 测试提示词效果
5. 提交Pull Request

## 许可证

MIT License - 自由使用和修改
