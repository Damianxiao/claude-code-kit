#!/bin/bash

# Claude Code 提示词项目同步脚本
# 将全局提示词同步到当前项目

set -e

echo "🔄 开始同步Claude提示词到当前项目..."

# 定义路径
REPO_DIR="$HOME/claude-prompts-repo"
CURRENT_DIR=$(pwd)
PROJECT_CLAUDE_DIR="$CURRENT_DIR/.claude"

# 检查是否在项目根目录
if [ ! -f "package.json" ] && [ ! -f "go.mod" ] && [ ! -f "Cargo.toml" ] && [ ! -f "requirements.txt" ]; then
    echo "⚠️  警告：当前目录似乎不是项目根目录"
    echo "当前目录：$CURRENT_DIR"
    read -p "是否继续？(y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ 取消同步"
        exit 1
    fi
fi

# 检查提示词仓库
if [ ! -d "$REPO_DIR" ]; then
    echo "❌ 错误：找不到提示词仓库 $REPO_DIR"
    echo "请先运行安装脚本：~/claude-prompts-repo/scripts/install.sh"
    exit 1
fi

# 创建项目Claude目录
echo "📁 创建项目Claude配置目录..."
mkdir -p "$PROJECT_CLAUDE_DIR"

# 备份现有配置
if [ -f "$PROJECT_CLAUDE_DIR/settings.local.json" ]; then
    echo "💾 备份现有配置..."
    cp "$PROJECT_CLAUDE_DIR/settings.local.json" "$PROJECT_CLAUDE_DIR/settings.local.json.backup.$(date +%Y%m%d_%H%M%S)"
fi

# 复制提示词文件
echo "📋 同步提示词文件..."
cp -r "$REPO_DIR/prompts/"* "$PROJECT_CLAUDE_DIR/"

# 创建或更新项目特定的Claude配置
echo "⚙️  创建项目Claude配置..."

# 检测项目类型
PROJECT_TYPE="unknown"
if [ -f "package.json" ]; then
    if grep -q "react" package.json 2>/dev/null; then
        PROJECT_TYPE="react"
    elif grep -q "next" package.json 2>/dev/null; then
        PROJECT_TYPE="nextjs"
    elif grep -q "vue" package.json 2>/dev/null; then
        PROJECT_TYPE="vue"
    else
        PROJECT_TYPE="nodejs"
    fi
elif [ -f "go.mod" ]; then
    PROJECT_TYPE="go"
elif [ -f "Cargo.toml" ]; then
    PROJECT_TYPE="rust"
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    PROJECT_TYPE="python"
fi

echo "🔍 检测到项目类型：$PROJECT_TYPE"

# 创建项目特定的Claude指导文件
cat > "$PROJECT_CLAUDE_DIR/project-guide.md" << EOF
# Claude Code 项目指导

## 项目信息
- 项目类型：$PROJECT_TYPE
- 同步时间：$(date)
- 项目路径：$CURRENT_DIR

## 可用提示词
- \`/project:ultrathink-task\` - 超级思考模式
- \`/project:code-review\` - 代码审查

## 项目特定配置
根据检测到的项目类型($PROJECT_TYPE)，建议关注：

EOF

# 根据项目类型添加特定建议
case $PROJECT_TYPE in
    "react")
        cat >> "$PROJECT_CLAUDE_DIR/project-guide.md" << 'EOF'
### React 项目建议
- 使用函数组件和Hooks
- 遵循React最佳实践
- 注意性能优化（useMemo, useCallback）
- 确保组件可测试性
EOF
        ;;
    "go")
        cat >> "$PROJECT_CLAUDE_DIR/project-guide.md" << 'EOF'
### Go 项目建议
- 遵循Go代码规范
- 使用go fmt格式化代码
- 注意错误处理
- 编写单元测试
EOF
        ;;
    "nodejs")
        cat >> "$PROJECT_CLAUDE_DIR/project-guide.md" << 'EOF'
### Node.js 项目建议
- 使用现代JavaScript/TypeScript
- 注意异步编程最佳实践
- 确保错误处理完整
- 使用适当的包管理
EOF
        ;;
esac

# 创建快速使用脚本
cat > "$PROJECT_CLAUDE_DIR/quick-commands.sh" << 'EOF'
#!/bin/bash
# Claude Code 快速命令

echo "🤖 Claude Code 快速命令"
echo "========================"
echo "1. 超级思考模式："
echo "   /project:ultrathink-task <任务描述>"
echo ""
echo "2. 代码审查："
echo "   /project:code-review <文件路径>"
echo ""
echo "3. 查看项目指导："
echo "   cat .claude/project-guide.md"
echo ""
echo "4. 更新提示词："
echo "   ~/claude-prompts-repo/scripts/sync.sh"
EOF

chmod +x "$PROJECT_CLAUDE_DIR/quick-commands.sh"

echo "✅ 同步完成！"
echo ""
echo "📖 使用说明："
echo "1. 在Claude Code中使用：/project:ultrathink-task <任务>"
echo "2. 查看项目指导：cat .claude/project-guide.md"
echo "3. 快速命令帮助：.claude/quick-commands.sh"
echo ""
echo "📁 已同步的文件："
ls -la "$PROJECT_CLAUDE_DIR/"
echo ""
echo "🎉 项目已配置完成，可以开始使用Claude提示词了！"
