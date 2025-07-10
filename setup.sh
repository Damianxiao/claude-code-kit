#!/bin/bash

# Claude Code Kit - Ultimate Setup Script
# One-click configuration for prompts and premium MCP services

set -e

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$(dirname "$0")"
CURRENT_DIR=$(pwd)
BACKUP_DIR=".claude/backups"

echo -e "${BLUE}🚀 Claude Code Kit - Ultimate Setup${NC}"
echo -e "${YELLOW}Configuring prompts, complete MCP services, and SuperClaude framework...${NC}"
echo ""

# Detect project type
detect_project() {
    if [ -f "package.json" ]; then
        echo "Node.js Project"
    elif [ -f "go.mod" ]; then
        echo "Go Project"
    elif [ -f "Cargo.toml" ]; then
        echo "Rust Project"
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        echo "Python Project"
    else
        echo "Generic Project"
    fi
}

# Setup prompts
setup_prompts() {
    echo -e "${BLUE}📋 Configuring Claude prompts...${NC}"
    
    # Create directories
    mkdir -p .claude/commands
    
    # Copy prompt files
    if [ -d "$SCRIPT_DIR/prompts" ]; then
        cp "$SCRIPT_DIR/prompts/"* .claude/ 2>/dev/null || true
        cp "$SCRIPT_DIR/prompts/"* .claude/commands/ 2>/dev/null || true
        
        # Create configuration file
        cat > .claude/settings.local.json << 'EOF'
{
  "permissions": {
    "allow": ["Bash(bash:*)"],
    "deny": []
  }
}
EOF
        
        echo -e "${GREEN}✅ Prompts configuration completed${NC}"
        return 0
    else
        echo -e "${RED}❌ Prompt files not found${NC}"
        return 1
    fi
}

# Create backup directory if it doesn't exist
ensure_backup_dir() {
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo -e "${BLUE}📁 Created backup directory: $BACKUP_DIR${NC}"
    fi
}

# Setup MCP services
setup_mcp() {
    echo -e "${BLUE}🔧 Configuring stable MCP services (balanced configuration)...${NC}"
    
    # Use stable configuration by default for balance of features and reliability
    local config_file="$SCRIPT_DIR/mcp-configs/stable.json"
    
    if [ -f "$config_file" ]; then
        # Backup existing configuration
        if [ -f ".mcp.json" ]; then
            ensure_backup_dir
            cp .mcp.json "$BACKUP_DIR/mcp.json.backup.$(date +%Y%m%d_%H%M%S)"
            echo -e "${YELLOW}📦 Backed up existing MCP configuration${NC}"
        fi
        
        # Apply stable configuration
        cp "$config_file" .mcp.json
        
        # Adjust paths
        if command -v sed >/dev/null 2>&1; then
            sed -i.tmp "s|/path/to/project|$CURRENT_DIR|g" .mcp.json && rm -f .mcp.json.tmp
        fi
        
        echo -e "${GREEN}✅ Stable MCP services configuration completed${NC}"
        echo -e "${YELLOW}📋 Configured services (stable & reliable):${NC}"
        echo "  • filesystem - File system access"
        echo "  • memory - Persistent memory storage"
        echo "  • fetch - HTTP requests"
        echo "  • context7 - Vector database"
        echo "  • sequential-thinking - Sequential reasoning"
        echo "  • everything - Universal utility toolkit"
        echo ""
        echo -e "${BLUE}💡 This configuration balances features with reliability${NC}"
        echo -e "${BLUE}   Avoids problematic services (git, database, browser)${NC}"
        
        return 0
    else
        # Fallback to core if stable not found
        echo -e "${YELLOW}⚠️  Stable config not found, using core...${NC}"
        local core_config="$SCRIPT_DIR/mcp-configs/core.json"
        if [ -f "$core_config" ]; then
            cp "$core_config" .mcp.json
            if command -v sed >/dev/null 2>&1; then
                sed -i.tmp "s|/path/to/project|$CURRENT_DIR|g" .mcp.json && rm -f .mcp.json.tmp
            fi
            echo -e "${GREEN}✅ Core MCP services configuration completed${NC}"
            return 0
        else
            echo -e "${RED}❌ No MCP configuration files found${NC}"
            return 1
        fi
    fi
}

# Setup SuperClaude framework
setup_superclaude() {
    echo -e "${BLUE}🎭 Configuring SuperClaude development framework...${NC}"
    
    # Ask whether to install SuperClaude
    echo -e "${YELLOW}SuperClaude provides:${NC}"
    echo "  • 19 professional development commands"
    echo "  • 9 cognitive personas"
    echo "  • Development workflow automation"
    echo "  • Evidence-driven development methodology"
    echo ""
    
    read -p "Install SuperClaude framework? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${YELLOW}⏭️ Skipping SuperClaude installation${NC}"
        return 0
    fi
    
    # Check if git is available
    if ! command -v git >/dev/null 2>&1; then
        echo -e "${RED}❌ Git is required to install SuperClaude${NC}"
        return 1
    fi
    
    # Check if already installed
    if [ -f "$HOME/.claude/CLAUDE.md" ]; then
        echo -e "${YELLOW}⚠️ Existing SuperClaude installation detected${NC}"
        read -p "Reinstall? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}✅ Keeping existing SuperClaude installation${NC}"
            return 0
        fi
    fi
    
    # Create temporary directory
    local temp_dir=$(mktemp -d)
    echo -e "${BLUE}📥 Downloading SuperClaude...${NC}"
    
    # Clone repository
    if git clone https://github.com/NomenAK/SuperClaude.git "$temp_dir/SuperClaude" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Download completed${NC}"
        
        # Run installation script
        cd "$temp_dir/SuperClaude"
        if bash ./install.sh --force >/dev/null 2>&1; then
            echo -e "${GREEN}✅ SuperClaude installation completed${NC}"
            echo -e "${YELLOW}📋 Installed features:${NC}"
            echo "  • /build, /test, /deploy - Development commands"
            echo "  • /analyze, /review, /troubleshoot - Analysis commands"
            echo "  • --persona-architect, --persona-security - Cognitive personas"
            echo "  • --think, --seq, --magic - Enhancement options"
            
            # Clean up temporary directory
            cd "$CURRENT_DIR"
            rm -rf "$temp_dir"
            return 0
        else
            echo -e "${RED}❌ SuperClaude installation failed${NC}"
            cd "$CURRENT_DIR"
            rm -rf "$temp_dir"
            return 1
        fi
    else
        echo -e "${RED}❌ SuperClaude download failed${NC}"
        rm -rf "$temp_dir"
        return 1
    fi
}

# Create project guide
create_guide() {
    local project_type=$1
    local project_name=$(basename "$CURRENT_DIR")
    
    cat > .claude/guide.md << EOF
# $project_name - Claude Code Kit Configuration

## Project Information
- Project Type: $project_type
- Configuration Time: $(date)

## 🤖 Available Prompts
\`\`\`
/project:ultrathink-task <task description>
/project:code-review <code>
\`\`\`

## 🎭 SuperClaude Development Framework
\`\`\`
/build --react --magic --tdd          # AI component development
/analyze --architecture --seq         # Architecture analysis
/test --coverage --e2e --pup         # Automated testing
/review --quality --persona-qa       # Quality review
/deploy --env staging --plan         # Deployment planning
\`\`\`

## 🔧 Configured MCP Services
- File system, Git, database operations
- Browser automation and HTTP requests
- AI enhancement features (context7, sequential-thinking, magic)
- Search and universal tools

## 🚀 Getting Started
Restart Claude Code, then try:
\`\`\`
/project:ultrathink-task Analyze this project's architecture
/build --react --magic --persona-frontend
/analyze --code --think --persona-architect
\`\`\`

## 🔄 Update Configuration
\`\`\`bash
$SCRIPT_DIR/setup.sh
\`\`\`
EOF
    
    echo -e "${GREEN}✅ Project guide created${NC}"
}

# Update .gitignore to exclude generated files
update_gitignore() {
    echo -e "${BLUE}📝 Updating .gitignore...${NC}"
    
    # Define patterns to add
    local patterns=(
        "# Claude Code Kit - Generated Files"
        "claude-code-kit/"
        ".claude/"
        ".mcp.json"
        ".mcp.json.tmp"
        "database.sqlite"
        "*.sqlite"
    )
    
    # Check if .gitignore exists
    if [ ! -f ".gitignore" ]; then
        echo -e "${YELLOW}ℹ️ Creating .gitignore file...${NC}"
        touch .gitignore
    fi
    
    # Check if our patterns already exist
    if grep -q "# Claude Code Kit - Generated Files" .gitignore 2>/dev/null; then
        echo -e "${YELLOW}ℹ️ Claude Code Kit patterns already exist in .gitignore${NC}"
        return 0
    fi
    
    # Backup existing .gitignore
    if [ -s ".gitignore" ]; then
        ensure_backup_dir
        cp .gitignore "$BACKUP_DIR/gitignore.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${YELLOW}📦 Backed up existing .gitignore${NC}"
    fi
    
    # Add our patterns
    echo "" >> .gitignore
    for pattern in "${patterns[@]}"; do
        echo "$pattern" >> .gitignore
    done
    
    echo -e "${GREEN}✅ .gitignore updated successfully${NC}"
    echo -e "${YELLOW}📋 Added patterns to prevent committing generated files${NC}"
}

# Setup git commit message rules
setup_git_rules() {
    echo -e "${BLUE}📋 Setting up git commit message rules...${NC}"
    
    # Create rules directory if it doesn't exist
    mkdir -p rules
    
    # Check if git commit rules already exist
    if [ -f "rules/git-commit-rules.md" ]; then
        echo -e "${YELLOW}ℹ️  Git commit rules already exist${NC}"
        return 0
    fi
    
    # Copy git commit rules from template
    if [ -f "$SCRIPT_DIR/rules/git-commit-rules.md" ]; then
        cp "$SCRIPT_DIR/rules/git-commit-rules.md" rules/
        echo -e "${GREEN}✅ Git commit message rules installed${NC}"
        echo -e "${YELLOW}📋 Rules location: rules/git-commit-rules.md${NC}"
        echo ""
        echo -e "${BLUE}💡 Rules summary:${NC}"
        echo "  • Use concise English descriptions"
        echo "  • Start with action verbs (Add, Fix, Update, Remove)"
        echo "  • Keep messages under 50 characters"
        echo "  • No signatures or author names"
    else
        echo -e "${RED}❌ Git commit rules template not found${NC}"
        return 1
    fi
    
    return 0
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
        update_gitignore
        echo ""
        setup_git_rules
        echo ""
        echo -e "${GREEN}🎉 Setup completed!${NC}"
        echo ""
        echo -e "${YELLOW}📖 Next steps:${NC}"
        echo "1. Restart Claude Code"
        echo "2. Try /project:ultrathink-task command"
        echo "3. Try /build --react --magic --persona-frontend"
        echo "4. View guide: cat .claude/guide.md"
        echo "5. Check git commit rules: cat rules/git-commit-rules.md"
        echo ""
        echo -e "${BLUE}💡 Environment variable setup (optional):${NC}"
        echo "export POSTGRES_CONNECTION_STRING=\"postgresql://localhost:5432/mydb\""
        echo "export BRAVE_API_KEY=\"your-api-key\""
        echo "export MAGIC_API_KEY=\"your-magic-api-key\""
    else
        echo -e "${RED}❌ Setup failed, please check error messages${NC}"
        exit 1
    fi
}

# If running script directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi