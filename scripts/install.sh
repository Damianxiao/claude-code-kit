#!/bin/bash

# Claude Code 提示词全局安装脚本
# 用于将提示词安装到Claude Code的全局配置中

set -e

echo "🚀 开始安装Claude Code提示词..."

# 定义路径
REPO_DIR="$HOME/claude-prompts-repo"
CLAUDE_GLOBAL_DIR="$HOME/.claude"
VSCODE_CLAUDE_DIR="$HOME/.vscode/extensions"

# 检查仓库是否存在
if [ ! -d "$REPO_DIR" ]; then
    echo "❌ 错误：找不到提示词仓库目录 $REPO_DIR"
    echo "请先确保仓库已创建"
    exit 1
fi

echo "📁 检测到提示词仓库：$REPO_DIR"

# 创建Claude全局配置目录
echo "📂 创建Claude配置目录..."
mkdir -p "$CLAUDE_GLOBAL_DIR"

# 检查是否存在VSCode Claude扩展
echo "🔍 检查Claude Code扩展..."
CLAUDE_EXT_FOUND=false
if [ -d "$VSCODE_CLAUDE_DIR" ]; then
    CLAUDE_EXT=$(find "$VSCODE_CLAUDE_DIR" -name "*claude*" -type d 2>/dev/null | head -1)
    if [ -n "$CLAUDE_EXT" ]; then
        echo "✅ 找到Claude扩展：$CLAUDE_EXT"
        CLAUDE_EXT_FOUND=true
    fi
fi

# 复制提示词文件
echo "📋 复制提示词文件..."
cp -r "$REPO_DIR/prompts/"* "$CLAUDE_GLOBAL_DIR/"

# 创建自定义指令配置文件
echo "⚙️  创建自定义指令配置..."
cat > "$CLAUDE_GLOBAL_DIR/custom-instructions.json" << 'EOF'
{
  "instructions": [
    {
      "name": "ultrathink-task",
      "description": "超级思考模式 - 4个子代理协作",
      "file": "ultrathink-task.md",
      "usage": "/project:ultrathink-task <任务描述>"
    },
    {
      "name": "code-review",
      "description": "专业代码审查",
      "file": "code-review.md", 
      "usage": "/project:code-review <代码或文件>"
    }
  ]
}
EOF

# 创建快速访问脚本
echo "🔗 创建快速访问脚本..."
cat > "$HOME/.bashrc_claude" << 'EOF'
# Claude Code 提示词快捷命令
alias claude-sync="~/claude-prompts-repo/scripts/sync.sh"
alias claude-update="~/claude-prompts-repo/scripts/update.sh"
alias claude-prompts="cd ~/claude-prompts-repo && ls prompts/"

# 快速使用函数
claude-ultrathink() {
    echo "使用方法：在Claude Code中输入："
    echo "/project:ultrathink-task $*"
}

claude-review() {
    echo "使用方法：在Claude Code中输入："
    echo "/project:code-review $*"
}
EOF

# 添加到bashrc（如果还没有）
if ! grep -q "source ~/.bashrc_claude" ~/.bashrc 2>/dev/null; then
    echo "source ~/.bashrc_claude" >> ~/.bashrc
    echo "✅ 已添加快捷命令到 ~/.bashrc"
fi

# 创建项目同步模板
echo "📄 创建项目模板..."
mkdir -p "$CLAUDE_GLOBAL_DIR/templates"
cat > "$CLAUDE_GLOBAL_DIR/templates/project-claude.md" << 'EOF'
# Claude Code 项目配置

这个文件为Claude Code提供项目特定的指导。

## 项目概述
[在这里描述您的项目]

## 开发规范
- 代码风格：[例如：ESLint + Prettier]
- 测试框架：[例如：Jest + React Testing Library]
- 提交规范：[例如：Conventional Commits]

## 常用命令
```bash
# 开发服务器
npm start

# 构建
npm run build

# 测试
npm test
```

## 架构说明
[描述项目架构和关键组件]

## 注意事项
[特殊的开发注意事项]
EOF

echo "✅ 安装完成！"
echo ""
echo "📖 使用说明："
echo "1. 重新加载终端：source ~/.bashrc"
echo "2. 在Claude Code中使用：/project:ultrathink-task <任务>"
echo "3. 查看所有提示词：claude-prompts"
echo "4. 同步到项目：claude-sync"
echo ""
echo "🎉 现在您可以在任何项目中使用Claude提示词了！"
