#!/bin/bash

# Claude Code 提示词更新脚本
# 更新全局和项目中的提示词

set -e

echo "🔄 开始更新Claude提示词..."

# 定义路径
REPO_DIR="$HOME/claude-prompts-repo"
CLAUDE_GLOBAL_DIR="$HOME/.claude"

# 检查仓库
if [ ! -d "$REPO_DIR" ]; then
    echo "❌ 错误：找不到提示词仓库 $REPO_DIR"
    exit 1
fi

echo "📁 提示词仓库：$REPO_DIR"

# 如果是Git仓库，拉取最新更新
if [ -d "$REPO_DIR/.git" ]; then
    echo "🔄 拉取Git更新..."
    cd "$REPO_DIR"
    git pull origin main 2>/dev/null || echo "⚠️  Git拉取失败或不是Git仓库"
    cd - > /dev/null
fi

# 更新全局配置
echo "🌐 更新全局配置..."
if [ -d "$CLAUDE_GLOBAL_DIR" ]; then
    cp -r "$REPO_DIR/prompts/"* "$CLAUDE_GLOBAL_DIR/" 2>/dev/null || echo "⚠️  全局配置更新失败"
    echo "✅ 全局配置已更新"
else
    echo "⚠️  全局配置目录不存在，请先运行安装脚本"
fi

# 查找并更新所有项目中的Claude配置
echo "🔍 查找项目中的Claude配置..."
UPDATED_PROJECTS=0

# 在常见的项目目录中查找
for PROJECT_DIR in "$HOME/projects" "$HOME/workspace" "$HOME/dev" "$HOME/code" "$HOME"/*; do
    if [ -d "$PROJECT_DIR/.claude" ] && [ -d "$PROJECT_DIR" ]; then
        echo "📁 发现项目：$PROJECT_DIR"
        
        # 备份现有配置
        if [ -f "$PROJECT_DIR/.claude/settings.local.json" ]; then
            cp "$PROJECT_DIR/.claude/settings.local.json" "$PROJECT_DIR/.claude/settings.local.json.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
        fi
        
        # 更新提示词
        cp -r "$REPO_DIR/prompts/"* "$PROJECT_DIR/.claude/" 2>/dev/null || true
        
        # 更新项目指导文件的时间戳
        if [ -f "$PROJECT_DIR/.claude/project-guide.md" ]; then
            sed -i "s/同步时间：.*/同步时间：$(date)/" "$PROJECT_DIR/.claude/project-guide.md" 2>/dev/null || true
        fi
        
        UPDATED_PROJECTS=$((UPDATED_PROJECTS + 1))
        echo "✅ 已更新：$PROJECT_DIR"
    fi
done

echo ""
echo "📊 更新统计："
echo "- 已更新项目数量：$UPDATED_PROJECTS"
echo "- 可用提示词："
ls "$REPO_DIR/prompts/" 2>/dev/null | sed 's/^/  - /' || echo "  无"

echo ""
echo "✅ 更新完成！"
echo ""
echo "📖 使用说明："
echo "1. 在Claude Code中使用：/project:ultrathink-task <任务>"
echo "2. 手动同步项目：~/claude-prompts-repo/scripts/sync.sh"
echo "3. 查看所有提示词：ls ~/claude-prompts-repo/prompts/"
echo ""
echo "🎉 所有提示词已更新到最新版本！"
