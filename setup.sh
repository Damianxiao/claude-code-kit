#!/bin/bash

# Claude Code 极简设置脚本
# 一键配置提示词和最全MCP服务

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 脚本目录
SCRIPT_DIR="$(dirname "$0")"
CURRENT_DIR=$(pwd)

echo -e "${BLUE}🚀 Claude Code 一键设置${NC}"
echo -e "${YELLOW}正在配置提示词、完整MCP服务和SuperClaude框架...${NC}"
echo ""

# 检测项目类型
detect_project() {
    if [ -f "package.json" ]; then
        echo "Node.js项目"
    elif [ -f "go.mod" ]; then
        echo "Go项目"
    elif [ -f "Cargo.toml" ]; then
        echo "Rust项目"
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        echo "Python项目"
    else
        echo "通用项目"
    fi
}

# 设置提示词
setup_prompts() {
    echo -e "${BLUE}📋 配置Claude提示词...${NC}"
    
    # 创建目录
    mkdir -p .claude/commands
    
    # 复制提示词文件
    if [ -d "$SCRIPT_DIR/prompts" ]; then
        cp "$SCRIPT_DIR/prompts/"* .claude/ 2>/dev/null || true
        cp "$SCRIPT_DIR/prompts/"* .claude/commands/ 2>/dev/null || true
        
        # 创建配置文件
        cat > .claude/settings.local.json << 'EOF'
{
  "permissions": {
    "allow": ["Bash(bash:*)"],
    "deny": []
  }
}
EOF
        
        echo -e "${GREEN}✅ 提示词配置完成${NC}"
        return 0
    else
        echo -e "${RED}❌ 找不到提示词文件${NC}"
        return 1
    fi
}

# 设置MCP服务
setup_mcp() {
    echo -e "${BLUE}🔧 配置完整MCP服务...${NC}"
    
    # 使用ultimate配置
    if [ -f "$SCRIPT_DIR/mcp-configs/ultimate.json" ]; then
        # 备份现有配置
        [ -f ".mcp.json" ] && cp .mcp.json ".mcp.json.backup.$(date +%Y%m%d_%H%M%S)"
        
        # 应用配置
        cp "$SCRIPT_DIR/mcp-configs/ultimate.json" .mcp.json
        
        # 调整路径
        if command -v sed >/dev/null 2>&1; then
            sed -i.tmp "s|/path/to/project|$CURRENT_DIR|g" .mcp.json && rm -f .mcp.json.tmp
        fi
        
        echo -e "${GREEN}✅ MCP服务配置完成${NC}"
        echo -e "${YELLOW}📋 已配置的服务：${NC}"
        echo "  • filesystem - 文件系统访问"
        echo "  • git - Git仓库操作"
        echo "  • context7 - 向量数据库"
        echo "  • sequential-thinking - 序列化思维"
        echo "  • fetch - HTTP请求"
        echo "  • browser-tools - 浏览器工具"
        echo "  • puppeteer - 浏览器自动化"
        echo "  • postgres - PostgreSQL数据库"
        echo "  • sqlite - SQLite数据库"
        echo "  • memory - 持久化内存"
        echo "  • brave-search - 智能搜索"
        echo "  • everything - 通用工具集"
        echo "  • magic - AI UI组件生成器"
        
        return 0
    else
        echo -e "${RED}❌ 找不到MCP配置文件${NC}"
        return 1
    fi
}

# 设置SuperClaude框架
setup_superclaude() {
    echo -e "${BLUE}🎭 配置SuperClaude开发框架...${NC}"
    
    # 询问是否安装SuperClaude
    echo -e "${YELLOW}SuperClaude提供：${NC}"
    echo "  • 19个专业开发命令"
    echo "  • 9个认知角色（personas）"
    echo "  • 开发工作流自动化"
    echo "  • 证据驱动的开发方法"
    echo ""
    
    read -p "是否安装SuperClaude框架？(Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${YELLOW}⏭️ 跳过SuperClaude安装${NC}"
        return 0
    fi
    
    # 检查git是否可用
    if ! command -v git >/dev/null 2>&1; then
        echo -e "${RED}❌ 需要git来安装SuperClaude${NC}"
        return 1
    fi
    
    # 检查是否已经安装
    if [ -f "$HOME/.claude/CLAUDE.md" ]; then
        echo -e "${YELLOW}⚠️ 检测到现有SuperClaude安装${NC}"
        read -p "是否重新安装？(y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}✅ 保持现有SuperClaude安装${NC}"
            return 0
        fi
    fi
    
    # 创建临时目录
    local temp_dir=$(mktemp -d)
    echo -e "${BLUE}📥 下载SuperClaude...${NC}"
    
    # 克隆仓库
    if git clone https://github.com/NomenAK/SuperClaude.git "$temp_dir/SuperClaude" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ 下载完成${NC}"
        
        # 运行安装脚本
        cd "$temp_dir/SuperClaude"
        if bash ./install.sh --force >/dev/null 2>&1; then
            echo -e "${GREEN}✅ SuperClaude安装完成${NC}"
            echo -e "${YELLOW}📋 已安装功能：${NC}"
            echo "  • /build, /test, /deploy - 开发命令"
            echo "  • /analyze, /review, /troubleshoot - 分析命令"
            echo "  • --persona-architect, --persona-security - 认知角色"
            echo "  • --think, --seq, --magic - 增强选项"
            
            # 清理临时目录
            cd "$CURRENT_DIR"
            rm -rf "$temp_dir"
            return 0
        else
            echo -e "${RED}❌ SuperClaude安装失败${NC}"
            cd "$CURRENT_DIR"
            rm -rf "$temp_dir"
            return 1
        fi
    else
        echo -e "${RED}❌ 下载SuperClaude失败${NC}"
        rm -rf "$temp_dir"
        return 1
    fi
}

# 创建项目指导
create_guide() {
    local project_type=$1
    local project_name=$(basename "$CURRENT_DIR")
    
    cat > .claude/guide.md << EOF
# $project_name - Claude Code 配置

## 项目信息
- 项目类型: $project_type
- 配置时间: $(date)

## 🤖 可用提示词
\`\`\`
/project:ultrathink-task <任务描述>
/project:code-review <代码>
\`\`\`

## 🎭 SuperClaude开发框架
\`\`\`
/build --react --magic --tdd          # AI组件开发
/analyze --architecture --seq         # 架构分析
/test --coverage --e2e --pup         # 自动化测试
/review --quality --persona-qa       # 质量审查
/deploy --env staging --plan         # 部署规划
\`\`\`

## 🔧 已配置MCP服务
- 文件系统、Git、数据库操作
- 浏览器自动化和HTTP请求
- AI增强功能（context7、sequential-thinking、magic）
- 搜索和通用工具

## 🚀 开始使用
重启Claude Code，然后尝试:
\`\`\`
/project:ultrathink-task 帮我分析这个项目的架构
/build --react --magic --persona-frontend
/analyze --code --think --persona-architect
\`\`\`

## 🔄 更新配置
\`\`\`bash
$SCRIPT_DIR/setup.sh
\`\`\`
EOF
    
    echo -e "${GREEN}✅ 项目指导已创建${NC}"
}

# 主函数
main() {
    # 检查是否在正确目录
    if [ ! -d "$SCRIPT_DIR/prompts" ] || [ ! -d "$SCRIPT_DIR/mcp-configs" ]; then
        echo -e "${RED}❌ 请在claude-code-prompt-sync目录中运行此脚本${NC}"
        exit 1
    fi
    
    # 检测项目
    local project_type=$(detect_project)
    echo -e "${BLUE}🔍 检测到: $project_type${NC}"
    echo ""
    
    # 执行设置
    local success=true
    
    if setup_prompts; then
        echo ""
    else
        success=false
    fi
    
    if setup_mcp; then
        echo ""
    else
        success=false
    fi
    
    if setup_superclaude; then
        echo ""
    else
        # SuperClaude失败不影响整体成功
        echo -e "${YELLOW}⚠️ SuperClaude安装失败，但其他功能正常${NC}"
        echo ""
    fi
    
    if [ "$success" = true ]; then
        create_guide "$project_type"
        echo ""
        echo -e "${GREEN}🎉 设置完成！${NC}"
        echo ""
        echo -e "${YELLOW}📖 接下来：${NC}"
        echo "1. 重启Claude Code"
        echo "2. 尝试 /project:ultrathink-task 命令"
        echo "3. 尝试 /build --react --magic --persona-frontend"
        echo "4. 查看指导: cat .claude/guide.md"
        echo ""
        echo -e "${BLUE}💡 环境变量设置（可选）：${NC}"
        echo "export POSTGRES_CONNECTION_STRING=\"postgresql://localhost:5432/mydb\""
        echo "export BRAVE_API_KEY=\"your-api-key\""
        echo "export MAGIC_API_KEY=\"your-magic-api-key\""
    else
        echo -e "${RED}❌ 设置失败，请检查错误信息${NC}"
        exit 1
    fi
}

# 如果直接运行脚本
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi