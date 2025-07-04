#!/bin/bash

# Claude Code 新项目初始化脚本
# 用于在新项目中快速设置Claude提示词环境

set -e

echo "🚀 Claude Code 新项目初始化"
echo "============================"

# 定义路径
REPO_DIR="$HOME/claude-prompts-repo"
CURRENT_DIR=$(pwd)
PROJECT_CLAUDE_DIR="$CURRENT_DIR/.claude"

# 检查参数
PROJECT_NAME=""
PROJECT_TYPE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--name)
            PROJECT_NAME="$2"
            shift 2
            ;;
        -t|--type)
            PROJECT_TYPE="$2"
            shift 2
            ;;
        -h|--help)
            echo "用法: $0 [选项]"
            echo ""
            echo "选项:"
            echo "  -n, --name <项目名>     指定项目名称"
            echo "  -t, --type <项目类型>   指定项目类型 (react/vue/nodejs/go/python/rust)"
            echo "  -h, --help             显示帮助信息"
            echo ""
            echo "示例:"
            echo "  $0 -n my-app -t react"
            echo "  $0 --name my-backend --type go"
            exit 0
            ;;
        *)
            echo "未知参数: $1"
            echo "使用 -h 或 --help 查看帮助"
            exit 1
            ;;
    esac
done

# 如果没有指定项目名，尝试从目录名获取
if [ -z "$PROJECT_NAME" ]; then
    PROJECT_NAME=$(basename "$CURRENT_DIR")
    echo "📝 使用目录名作为项目名: $PROJECT_NAME"
fi

# 检查提示词仓库
if [ ! -d "$REPO_DIR" ]; then
    echo "❌ 错误：找不到提示词仓库 $REPO_DIR"
    echo "请先运行全局安装：~/claude-prompts-repo/scripts/install.sh"
    exit 1
fi

echo "📁 项目名称: $PROJECT_NAME"
echo "📂 项目路径: $CURRENT_DIR"

# 自动检测项目类型（如果未指定）
if [ -z "$PROJECT_TYPE" ]; then
    echo "🔍 自动检测项目类型..."
    
    if [ -f "package.json" ]; then
        if grep -q "react" package.json 2>/dev/null; then
            PROJECT_TYPE="react"
        elif grep -q "next" package.json 2>/dev/null; then
            PROJECT_TYPE="nextjs"
        elif grep -q "vue" package.json 2>/dev/null; then
            PROJECT_TYPE="vue"
        elif grep -q "express" package.json 2>/dev/null; then
            PROJECT_TYPE="express"
        else
            PROJECT_TYPE="nodejs"
        fi
    elif [ -f "go.mod" ]; then
        PROJECT_TYPE="go"
    elif [ -f "Cargo.toml" ]; then
        PROJECT_TYPE="rust"
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        PROJECT_TYPE="python"
    elif [ -f "composer.json" ]; then
        PROJECT_TYPE="php"
    elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
        PROJECT_TYPE="java"
    else
        PROJECT_TYPE="general"
    fi
fi

echo "🎯 项目类型: $PROJECT_TYPE"

# 创建项目Claude目录
echo "📁 创建项目Claude配置目录..."
mkdir -p "$PROJECT_CLAUDE_DIR"

# 复制核心提示词文件
echo "📋 复制提示词文件..."
if [ -d "$REPO_DIR/prompts" ]; then
    cp -r "$REPO_DIR/prompts/"* "$PROJECT_CLAUDE_DIR/" 2>/dev/null || {
        echo "⚠️  警告：无法从 $REPO_DIR/prompts 复制文件"
        echo "尝试从当前项目目录复制..."
        if [ -d "/home/damian/novacrafter/novacrafterlab-mainsite/claude-prompts-repo/prompts" ]; then
            cp -r "/home/damian/novacrafter/novacrafterlab-mainsite/claude-prompts-repo/prompts/"* "$PROJECT_CLAUDE_DIR/"
        else
            echo "❌ 找不到提示词文件"
            exit 1
        fi
    }
else
    echo "⚠️  警告：找不到提示词目录，尝试从当前项目目录复制..."
    if [ -d "/home/damian/novacrafter/novacrafterlab-mainsite/claude-prompts-repo/prompts" ]; then
        cp -r "/home/damian/novacrafter/novacrafterlab-mainsite/claude-prompts-repo/prompts/"* "$PROJECT_CLAUDE_DIR/"
    else
        echo "❌ 找不到提示词文件"
        exit 1
    fi
fi

# 创建项目特定的配置文件
echo "⚙️  创建项目配置..."
cat > "$PROJECT_CLAUDE_DIR/project-config.json" << EOF
{
  "project_name": "$PROJECT_NAME",
  "project_type": "$PROJECT_TYPE",
  "init_date": "$(date)",
  "claude_version": "1.0.0",
  "prompts_repo": "$REPO_DIR"
}
EOF

# 创建项目指导文件
echo "📖 创建项目指导文件..."
cat > "$PROJECT_CLAUDE_DIR/project-guide.md" << EOF
# $PROJECT_NAME - Claude Code 项目指导

## 项目信息
- **项目名称**: $PROJECT_NAME
- **项目类型**: $PROJECT_TYPE
- **初始化时间**: $(date)
- **项目路径**: $CURRENT_DIR

## 可用的Claude提示词

### 🧠 超级思考模式
\`\`\`
/project:ultrathink-task <任务描述>
\`\`\`
启动4个专业子代理协作分析复杂任务：
- 🏗️ 架构师代理：系统设计和架构分析
- 🔍 研究代理：技术调研和最佳实践
- 💻 编码代理：具体代码实现
- 🧪 测试代理：测试策略和质量保证

### 📝 代码审查
\`\`\`
/project:code-review <文件路径或代码>
\`\`\`
专业的代码审查，包括：
- 代码质量分析
- 安全性检查
- 性能优化建议
- 最佳实践建议

## 项目类型特定建议

EOF

# 根据项目类型添加特定建议
case $PROJECT_TYPE in
    "react")
        cat >> "$PROJECT_CLAUDE_DIR/project-guide.md" << 'EOF'
### React 项目最佳实践
- ✅ 使用函数组件和Hooks
- ✅ 遵循React最佳实践和设计模式
- ✅ 注意性能优化（useMemo, useCallback, React.memo）
- ✅ 确保组件的可测试性和可重用性
- ✅ 使用TypeScript提高代码质量
- ✅ 遵循组件命名和文件结构规范

### 推荐的开发工具
- ESLint + Prettier：代码格式化和质量检查
- React Testing Library：组件测试
- Storybook：组件文档和开发
EOF
        ;;
    "vue")
        cat >> "$PROJECT_CLAUDE_DIR/project-guide.md" << 'EOF'
### Vue 项目最佳实践
- ✅ 使用Composition API（Vue 3）
- ✅ 遵循Vue风格指南
- ✅ 合理使用响应式数据
- ✅ 组件化开发和复用
- ✅ 使用TypeScript增强类型安全

### 推荐的开发工具
- Vue DevTools：调试工具
- Vite：快速构建工具
- Vitest：单元测试框架
EOF
        ;;
    "go")
        cat >> "$PROJECT_CLAUDE_DIR/project-guide.md" << 'EOF'
### Go 项目最佳实践
- ✅ 遵循Go代码规范和惯例
- ✅ 使用go fmt自动格式化代码
- ✅ 重视错误处理，避免panic
- ✅ 编写全面的单元测试
- ✅ 使用接口提高代码的可测试性
- ✅ 注意并发安全和性能

### 推荐的开发工具
- golangci-lint：代码质量检查
- go test：单元测试
- pprof：性能分析
EOF
        ;;
    "python")
        cat >> "$PROJECT_CLAUDE_DIR/project-guide.md" << 'EOF'
### Python 项目最佳实践
- ✅ 遵循PEP 8代码风格
- ✅ 使用类型提示（Type Hints）
- ✅ 编写文档字符串（Docstrings）
- ✅ 使用虚拟环境管理依赖
- ✅ 编写单元测试和集成测试

### 推荐的开发工具
- Black：代码格式化
- pylint/flake8：代码质量检查
- pytest：测试框架
- mypy：静态类型检查
EOF
        ;;
    "nodejs")
        cat >> "$PROJECT_CLAUDE_DIR/project-guide.md" << 'EOF'
### Node.js 项目最佳实践
- ✅ 使用现代JavaScript/TypeScript
- ✅ 注意异步编程最佳实践
- ✅ 确保错误处理完整
- ✅ 使用适当的包管理工具
- ✅ 实施安全最佳实践

### 推荐的开发工具
- ESLint + Prettier：代码质量和格式化
- Jest：测试框架
- nodemon：开发时自动重启
EOF
        ;;
esac

# 创建快速命令脚本
echo "🔧 创建快速命令脚本..."
cat > "$PROJECT_CLAUDE_DIR/quick-start.sh" << 'EOF'
#!/bin/bash
# Claude Code 快速开始指南

echo "🤖 Claude Code 快速命令指南"
echo "============================="
echo ""
echo "💡 超级思考模式（复杂任务分析）："
echo "   /project:ultrathink-task 创建用户认证系统"
echo "   /project:ultrathink-task 优化数据库查询性能"
echo "   /project:ultrathink-task 设计微服务架构"
echo ""
echo "🔍 代码审查："
echo "   /project:code-review src/components/UserForm.jsx"
echo "   /project:code-review 'function calculateTotal() { ... }'"
echo ""
echo "📖 查看项目指导："
echo "   cat .claude/project-guide.md"
echo ""
echo "🔄 更新提示词："
echo "   ~/claude-prompts-repo/scripts/sync.sh"
echo ""
echo "📁 项目配置文件："
echo "   .claude/project-config.json"
echo "   .claude/project-guide.md"
EOF

chmod +x "$PROJECT_CLAUDE_DIR/quick-start.sh"

# 创建.gitignore条目建议
if [ -f ".gitignore" ]; then
    if ! grep -q ".claude" .gitignore 2>/dev/null; then
        echo ""
        echo "📝 建议添加到.gitignore："
        echo "# Claude Code配置（可选）"
        echo ".claude/project-config.json"
        echo ""
        read -p "是否自动添加到.gitignore？(y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "" >> .gitignore
            echo "# Claude Code配置" >> .gitignore
            echo ".claude/project-config.json" >> .gitignore
            echo "✅ 已添加到.gitignore"
        fi
    fi
fi

echo ""
echo "✅ 项目初始化完成！"
echo ""
echo "📖 使用说明："
echo "1. 查看快速指南：.claude/quick-start.sh"
echo "2. 查看项目指导：cat .claude/project-guide.md"
echo "3. 在Claude Code中使用：/project:ultrathink-task <任务>"
echo ""
echo "📁 已创建的文件："
ls -la "$PROJECT_CLAUDE_DIR/"
echo ""
echo "🎉 现在可以在Claude Code中使用强大的提示词功能了！"
