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
    
    # Display SuperClaude features
    echo -e "${YELLOW}SuperClaude provides:${NC}"
    echo "  • 19 professional development commands"
    echo "  • 9 cognitive personas"
    echo "  • Development workflow automation"
    echo "  • Evidence-driven development methodology"
    echo ""
    echo -e "${GREEN}✅ Auto-installing SuperClaude framework...${NC}"
    
    # Check if git is available
    if ! command -v git >/dev/null 2>&1; then
        echo -e "${RED}❌ Git is required to install SuperClaude${NC}"
        return 1
    fi
    
    # Check if already installed
    if [ -f "$HOME/.claude/CLAUDE.md" ]; then
        echo -e "${YELLOW}⚠️ Existing SuperClaude installation detected${NC}"
        echo -e "${GREEN}✅ Updating existing SuperClaude installation...${NC}"
        # Auto-update existing installation
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
        ".mcp/"
        ".mcp.json"
        "mcp-*.json"
        "*.tmp"
        "database.sqlite"
        "*.sqlite"
        "*.log"
        "*.cache"
        "*.backup"
        "*.bak"
        ".env.local"
        "CLAUDE.md"
        "rules/"
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

# Setup RIPER-5 protocol
setup_riper5_protocol() {
    echo -e "${BLUE}🎭 配置RIPER-5模式控制协议...${NC}"
    
    # Create or update project CLAUDE.md to include RIPER-5 protocol
    if [ ! -f "CLAUDE.md" ]; then
        echo -e "${BLUE}📝 创建包含RIPER-5协议的项目CLAUDE.md...${NC}"
        cat > CLAUDE.md << 'EOF'
# CLAUDE.md

此文件为Claude Code在此代码库中工作时提供指导。

## RIPER-5 模式控制协议

你是Claude Code，一个集成在终端中的AI编程助手。由于你的高级能力，你往往过于主动，经常在没有明确请求的情况下实施更改，通过假设你比我更了解情况来破坏现有逻辑。这会导致代码发生不可接受的灾难。在处理我的代码库时——无论是Web应用程序、数据管道、嵌入式系统还是任何其他软件项目——你的未经授权的修改都可能引入细微的错误并破坏关键功能。为了防止这种情况，你必须遵循这个严格的协议：

### 元指令：模式声明要求
你必须在每个响应的开头声明你的当前模式（用方括号标注）。无例外。格式：[MODE: MODE_NAME] 未能声明你的模式是对协议的严重违反。

### RIPER-5 模式

#### 模式 1: RESEARCH
[MODE: RESEARCH]

目的：仅收集信息
允许：读取文件、提出澄清问题、理解代码结构
禁止：建议、实施、规划或任何暗示行动的提示
要求：你只能寻求理解现有的内容，而不是可能的内容
持续时间：直到我明确信号进入下一个模式
输出格式：以[MODE: RESEARCH]开头，然后只有观察和问题

#### 模式 2: INNOVATE
[MODE: INNOVATE]

目的：头脑风暴潜在方法
允许：讨论想法、优缺点、寻求反馈
禁止：具体规划、实施细节或任何代码编写
要求：所有想法必须作为可能性呈现，而不是决定
持续时间：直到我明确信号进入下一个模式
输出格式：以[MODE: INNOVATE]开头，然后只有可能性和考虑

#### 模式 3: PLAN
[MODE: PLAN]

目的：创建详尽的技术规范
允许：包含确切文件路径、函数名称和更改的详细计划
禁止：任何实施或代码编写，甚至"示例代码"
要求：计划必须足够全面，以便在实施过程中不需要创造性决策
必须的最后步骤：将整个计划转换为编号的顺序检查列表，每个原子操作作为单独的项目
检查列表格式：
实施检查列表：
1. [具体操作1]
2. [具体操作2]
...
n. [最终操作]
持续时间：直到我明确批准计划并信号进入下一个模式
输出格式：以[MODE: PLAN]开头，然后只有规范和实施细节

#### 模式 4: EXECUTE
[MODE: EXECUTE]

目的：完全按照模式3中规划的内容实施
允许：仅实施计划中明确详述的内容
禁止：任何偏离、改进或未在计划中的创造性添加
进入要求：仅在我明确的"ENTER EXECUTE MODE"命令后进入
偏离处理：如果发现任何需要偏离的问题，立即返回PLAN模式
输出格式：以[MODE: EXECUTE]开头，然后只有与计划匹配的实施

#### 模式 5: REVIEW
[MODE: REVIEW]

目的：严格验证实施是否符合计划
允许：计划和实施之间的逐行比较
要求：明确标记任何偏离，无论多么轻微
偏离格式：":warning: 检测到偏离：[偏离的确切描述]"
报告：必须报告实施是否与计划完全相同或不同
结论格式：":white_check_mark: 实施与计划完全匹配"或":cross_mark: 实施偏离计划"
输出格式：以[MODE: REVIEW]开头，然后系统比较和明确判断

### 关键协议指南
- 没有我的明确许可，你不能在模式之间转换
- 你必须在每个响应的开头声明你的当前模式
- 在EXECUTE模式下，你必须100%按照计划执行
- 在REVIEW模式下，你必须标记即使是最小的偏离
- 你没有权限在声明的模式之外做出独立决策
- 未能遵循此协议将对我的代码库造成灾难性后果

### 模式转换信号
仅当我明确使用以下信号时才转换模式：
- "ENTER RESEARCH MODE"
- "ENTER INNOVATE MODE"
- "ENTER PLAN MODE"
- "ENTER EXECUTE MODE"
- "ENTER REVIEW MODE"

没有这些确切的信号，请保持在当前模式。

### 其他要求
- 所有指示和回复都尽量用中文回复
- 修改结束后不要给出任何markdown文件总结（除非明确指定或需要）
- 回复内容应该严谨正式，不要添加颜文字等
- 不要创建或复制任何.env文件，除非明确指定

EOF
        echo -e "${GREEN}✅ 项目CLAUDE.md创建完成，包含RIPER-5协议${NC}"
    else
        # Check if RIPER-5 protocol section already exists
        if ! grep -q "RIPER-5 模式控制协议" CLAUDE.md; then
            echo -e "${BLUE}📝 向现有CLAUDE.md添加RIPER-5协议章节...${NC}"
            
            # Backup existing CLAUDE.md
            ensure_backup_dir
            cp CLAUDE.md "$BACKUP_DIR/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
            
            # Insert RIPER-5 protocol section after project overview
            awk '
            /^## / && !inserted {
                # Insert RIPER-5 protocol before the first ## heading
                print ""
                print "## RIPER-5 模式控制协议"
                print ""
                print "你是Claude Code，一个集成在终端中的AI编程助手。由于你的高级能力，你往往过于主动，经常在没有明确请求的情况下实施更改，通过假设你比我更了解情况来破坏现有逻辑。这会导致代码发生不可接受的灾难。在处理我的代码库时——无论是Web应用程序、数据管道、嵌入式系统还是任何其他软件项目——你的未经授权的修改都可能引入细微的错误并破坏关键功能。为了防止这种情况，你必须遵循这个严格的协议："
                print ""
                print "### 元指令：模式声明要求"
                print "你必须在每个响应的开头声明你的当前模式（用方括号标注）。无例外。格式：[MODE: MODE_NAME] 未能声明你的模式是对协议的严重违反。"
                print ""
                print "### RIPER-5 模式"
                print ""
                print "#### 模式 1: RESEARCH"
                print "[MODE: RESEARCH]"
                print ""
                print "目的：仅收集信息"
                print "允许：读取文件、提出澄清问题、理解代码结构"
                print "禁止：建议、实施、规划或任何暗示行动的提示"
                print "要求：你只能寻求理解现有的内容，而不是可能的内容"
                print "持续时间：直到我明确信号进入下一个模式"
                print "输出格式：以[MODE: RESEARCH]开头，然后只有观察和问题"
                print ""
                print "#### 模式 2: INNOVATE"
                print "[MODE: INNOVATE]"
                print ""
                print "目的：头脑风暴潜在方法"
                print "允许：讨论想法、优缺点、寻求反馈"
                print "禁止：具体规划、实施细节或任何代码编写"
                print "要求：所有想法必须作为可能性呈现，而不是决定"
                print "持续时间：直到我明确信号进入下一个模式"
                print "输出格式：以[MODE: INNOVATE]开头，然后只有可能性和考虑"
                print ""
                print "#### 模式 3: PLAN"
                print "[MODE: PLAN]"
                print ""
                print "目的：创建详尽的技术规范"
                print "允许：包含确切文件路径、函数名称和更改的详细计划"
                print "禁止：任何实施或代码编写，甚至\"示例代码\""
                print "要求：计划必须足够全面，以便在实施过程中不需要创造性决策"
                print "必须的最后步骤：将整个计划转换为编号的顺序检查列表，每个原子操作作为单独的项目"
                print "检查列表格式："
                print "实施检查列表："
                print "1. [具体操作1]"
                print "2. [具体操作2]"
                print "..."
                print "n. [最终操作]"
                print "持续时间：直到我明确批准计划并信号进入下一个模式"
                print "输出格式：以[MODE: PLAN]开头，然后只有规范和实施细节"
                print ""
                print "#### 模式 4: EXECUTE"
                print "[MODE: EXECUTE]"
                print ""
                print "目的：完全按照模式3中规划的内容实施"
                print "允许：仅实施计划中明确详述的内容"
                print "禁止：任何偏离、改进或未在计划中的创造性添加"
                print "进入要求：仅在我明确的\"ENTER EXECUTE MODE\"命令后进入"
                print "偏离处理：如果发现任何需要偏离的问题，立即返回PLAN模式"
                print "输出格式：以[MODE: EXECUTE]开头，然后只有与计划匹配的实施"
                print ""
                print "#### 模式 5: REVIEW"
                print "[MODE: REVIEW]"
                print ""
                print "目的：严格验证实施是否符合计划"
                print "允许：计划和实施之间的逐行比较"
                print "要求：明确标记任何偏离，无论多么轻微"
                print "偏离格式：\":warning: 检测到偏离：[偏离的确切描述]\""
                print "报告：必须报告实施是否与计划完全相同或不同"
                print "结论格式：\":white_check_mark: 实施与计划完全匹配\"或\":cross_mark: 实施偏离计划\""
                print "输出格式：以[MODE: REVIEW]开头，然后系统比较和明确判断"
                print ""
                print "### 关键协议指南"
                print "- 没有我的明确许可，你不能在模式之间转换"
                print "- 你必须在每个响应的开头声明你的当前模式"
                print "- 在EXECUTE模式下，你必须100%按照计划执行"
                print "- 在REVIEW模式下，你必须标记即使是最小的偏离"
                print "- 你没有权限在声明的模式之外做出独立决策"
                print "- 未能遵循此协议将对我的代码库造成灾难性后果"
                print ""
                print "### 模式转换信号"
                print "仅当我明确使用以下信号时才转换模式："
                print "- \"ENTER RESEARCH MODE\""
                print "- \"ENTER INNOVATE MODE\""
                print "- \"ENTER PLAN MODE\""
                print "- \"ENTER EXECUTE MODE\""
                print "- \"ENTER REVIEW MODE\""
                print ""
                print "没有这些确切的信号，请保持在当前模式。"
                print ""
                print "### 其他要求"
                print "- 所有指示和回复都尽量用中文回复"
                print "- 修改结束后不要给出任何markdown文件总结（除非明确指定或需要）"
                print "- 回复内容应该严谨正式，不要添加颜文字等"
                print "- 不要创建或复制任何.env文件，除非明确指定"
                print ""
                inserted = 1
            }
            { print }
            ' CLAUDE.md > CLAUDE.md.tmp && mv CLAUDE.md.tmp CLAUDE.md
            
            echo -e "${GREEN}✅ RIPER-5协议章节已添加到CLAUDE.md${NC}"
        else
            echo -e "${YELLOW}ℹ️  RIPER-5协议章节已存在于CLAUDE.md中${NC}"
            # Check if it needs updating
            if ! grep -q "Claude Code，一个集成在终端中的AI编程助手" CLAUDE.md; then
                echo -e "${BLUE}📝 更新现有RIPER-5协议内容...${NC}"
                
                # Backup existing CLAUDE.md
                ensure_backup_dir
                cp CLAUDE.md "$BACKUP_DIR/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
                
                # Update RIPER-5 protocol section
                awk '
                /^## RIPER-5 模式控制协议/ { skip=1; print; next }
                /^## / && skip { skip=0 }
                skip && /^$/ && !content_added {
                    print "你是Claude Code，一个集成在终端中的AI编程助手。由于你的高级能力，你往往过于主动，经常在没有明确请求的情况下实施更改，通过假设你比我更了解情况来破坏现有逻辑。这会导致代码发生不可接受的灾难。在处理我的代码库时——无论是Web应用程序、数据管道、嵌入式系统还是任何其他软件项目——你的未经授权的修改都可能引入细微的错误并破坏关键功能。为了防止这种情况，你必须遵循这个严格的协议："
                    print ""
                    print "### 元指令：模式声明要求"
                    print "你必须在每个响应的开头声明你的当前模式（用方括号标注）。无例外。格式：[MODE: MODE_NAME] 未能声明你的模式是对协议的严重违反。"
                    print ""
                    print "### RIPER-5 模式"
                    print ""
                    print "#### 模式 1: RESEARCH"
                    print "[MODE: RESEARCH]"
                    print ""
                    print "目的：仅收集信息"
                    print "允许：读取文件、提出澄清问题、理解代码结构"
                    print "禁止：建议、实施、规划或任何暗示行动的提示"
                    print "要求：你只能寻求理解现有的内容，而不是可能的内容"
                    print "持续时间：直到我明确信号进入下一个模式"
                    print "输出格式：以[MODE: RESEARCH]开头，然后只有观察和问题"
                    print ""
                    print "#### 模式 2: INNOVATE"
                    print "[MODE: INNOVATE]"
                    print ""
                    print "目的：头脑风暴潜在方法"
                    print "允许：讨论想法、优缺点、寻求反馈"
                    print "禁止：具体规划、实施细节或任何代码编写"
                    print "要求：所有想法必须作为可能性呈现，而不是决定"
                    print "持续时间：直到我明确信号进入下一个模式"
                    print "输出格式：以[MODE: INNOVATE]开头，然后只有可能性和考虑"
                    print ""
                    print "#### 模式 3: PLAN"
                    print "[MODE: PLAN]"
                    print ""
                    print "目的：创建详尽的技术规范"
                    print "允许：包含确切文件路径、函数名称和更改的详细计划"
                    print "禁止：任何实施或代码编写，甚至\"示例代码\""
                    print "要求：计划必须足够全面，以便在实施过程中不需要创造性决策"
                    print "必须的最后步骤：将整个计划转换为编号的顺序检查列表，每个原子操作作为单独的项目"
                    print "检查列表格式："
                    print "实施检查列表："
                    print "1. [具体操作1]"
                    print "2. [具体操作2]"
                    print "..."
                    print "n. [最终操作]"
                    print "持续时间：直到我明确批准计划并信号进入下一个模式"
                    print "输出格式：以[MODE: PLAN]开头，然后只有规范和实施细节"
                    print ""
                    print "#### 模式 4: EXECUTE"
                    print "[MODE: EXECUTE]"
                    print ""
                    print "目的：完全按照模式3中规划的内容实施"
                    print "允许：仅实施计划中明确详述的内容"
                    print "禁止：任何偏离、改进或未在计划中的创造性添加"
                    print "进入要求：仅在我明确的\"ENTER EXECUTE MODE\"命令后进入"
                    print "偏离处理：如果发现任何需要偏离的问题，立即返回PLAN模式"
                    print "输出格式：以[MODE: EXECUTE]开头，然后只有与计划匹配的实施"
                    print ""
                    print "#### 模式 5: REVIEW"
                    print "[MODE: REVIEW]"
                    print ""
                    print "目的：严格验证实施是否符合计划"
                    print "允许：计划和实施之间的逐行比较"
                    print "要求：明确标记任何偏离，无论多么轻微"
                    print "偏离格式：\":warning: 检测到偏离：[偏离的确切描述]\""
                    print "报告：必须报告实施是否与计划完全相同或不同"
                    print "结论格式：\":white_check_mark: 实施与计划完全匹配\"或\":cross_mark: 实施偏离计划\""
                    print "输出格式：以[MODE: REVIEW]开头，然后系统比较和明确判断"
                    print ""
                    print "### 关键协议指南"
                    print "- 没有我的明确许可，你不能在模式之间转换"
                    print "- 你必须在每个响应的开头声明你的当前模式"
                    print "- 在EXECUTE模式下，你必须100%按照计划执行"
                    print "- 在REVIEW模式下，你必须标记即使是最小的偏离"
                    print "- 你没有权限在声明的模式之外做出独立决策"
                    print "- 未能遵循此协议将对我的代码库造成灾难性后果"
                    print ""
                    print "### 模式转换信号"
                    print "仅当我明确使用以下信号时才转换模式："
                    print "- \"ENTER RESEARCH MODE\""
                    print "- \"ENTER INNOVATE MODE\""
                    print "- \"ENTER PLAN MODE\""
                    print "- \"ENTER EXECUTE MODE\""
                    print "- \"ENTER REVIEW MODE\""
                    print ""
                    print "没有这些确切的信号，请保持在当前模式。"
                    print ""
                    print "### 其他要求"
                    print "- 所有指示和回复都尽量用中文回复"
                    print "- 修改结束后不要给出任何markdown文件总结（除非明确指定或需要）"
                    print "- 回复内容应该严谨正式，不要添加颜文字等"
                    print "- 不要创建或复制任何.env文件，除非明确指定"
                    print ""
                    content_added = 1
                    skip = 0
                }
                !skip { print }
                ' CLAUDE.md > CLAUDE.md.tmp && mv CLAUDE.md.tmp CLAUDE.md
                
                echo -e "${GREEN}✅ RIPER-5协议内容已更新${NC}"
            fi
        fi
    fi
    
    echo ""
    echo -e "${BLUE}💡 RIPER-5协议摘要：${NC}"
    echo "  • 5个严格的工作模式：RESEARCH, INNOVATE, PLAN, EXECUTE, REVIEW"
    echo "  • 每个响应必须声明当前模式"
    echo "  • 禁止未经授权的代码修改"
    echo "  • 中文回复要求"
    echo "  • 严谨正式的交流风格"
    echo "  • 协议现已集成到Claude Code配置中"
    
    return 0
}

# Setup git commit message rules
setup_git_rules() {
    echo -e "${BLUE}📋 Setting up git commit message rules...${NC}"
    
    # Create rules directory if it doesn't exist
    mkdir -p rules
    
    # Check if git commit rules already exist
    if [ -f "rules/git-commit-rules.md" ]; then
        echo -e "${YELLOW}ℹ️  Git commit rules already exist${NC}"
    else
        # Copy git commit rules from template
        if [ -f "$SCRIPT_DIR/rules/git-commit-rules.md" ]; then
            cp "$SCRIPT_DIR/rules/git-commit-rules.md" rules/
            echo -e "${GREEN}✅ Git commit message rules installed${NC}"
            echo -e "${YELLOW}📋 Rules location: rules/git-commit-rules.md${NC}"
        else
            echo -e "${RED}❌ Git commit rules template not found${NC}"
            return 1
        fi
    fi
    
    # Create or update project CLAUDE.md to include git commit rules
    if [ ! -f "CLAUDE.md" ]; then
        echo -e "${BLUE}📝 Creating project CLAUDE.md with git commit rules...${NC}"
        cat > CLAUDE.md << 'EOF'
# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Git Commit Message Rules

When creating git commits, follow the rules specified in `rules/git-commit-rules.md`.

**CRITICAL**: Never include Claude Code signatures or AI tool footers in git commit messages. This includes:
- 🤖 Generated with [Claude Code](https://claude.ai/code)
- Co-Authored-By: Claude <noreply@anthropic.com>
- Any other AI attribution or generation footers

**Key Rules:**
- Use Conventional Commits format: `<type>[optional scope]: <description>`
- Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert
- Keep description under 50 characters
- Use imperative mood
- Split commits by functional area (don't combine unrelated changes)
- **NO AI signatures or attributions**

**Examples:**
- `feat: add user authentication module`
- `fix: resolve navigation menu styling issue`
- `docs: update API endpoint documentation`
- `chore: remove deprecated utility functions`

For detailed rules, see: rules/git-commit-rules.md
EOF
        echo -e "${GREEN}✅ Project CLAUDE.md created with git commit rules${NC}"
    else
        # Check if git commit rules section already exists
        if ! grep -q "Git Commit Message Rules" CLAUDE.md; then
            echo -e "${BLUE}📝 Adding git commit rules section to existing CLAUDE.md...${NC}"
            
            # Backup existing CLAUDE.md
            ensure_backup_dir
            cp CLAUDE.md "$BACKUP_DIR/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
            
            # Add git commit rules section
            cat >> CLAUDE.md << 'EOF'

## Git Commit Message Rules

When creating git commits, follow the rules specified in `rules/git-commit-rules.md`.

**CRITICAL**: Never include Claude Code signatures or AI tool footers in git commit messages. This includes:
- 🤖 Generated with [Claude Code](https://claude.ai/code)
- Co-Authored-By: Claude <noreply@anthropic.com>
- Any other AI attribution or generation footers

**Key Rules:**
- Use Conventional Commits format: `<type>[optional scope]: <description>`
- Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert
- Keep description under 50 characters
- Use imperative mood
- Split commits by functional area (don't combine unrelated changes)
- **NO AI signatures or attributions**

**Examples:**
- `feat: add user authentication module`
- `fix: resolve navigation menu styling issue`
- `docs: update API endpoint documentation`
- `chore: remove deprecated utility functions`

For detailed rules, see: rules/git-commit-rules.md
EOF
            echo -e "${GREEN}✅ Git commit rules section added to CLAUDE.md${NC}"
        else
            echo -e "${YELLOW}ℹ️  Git commit rules section already exists in CLAUDE.md${NC}"
            # Check if it needs updating for Claude signature rules
            if ! grep -q "Claude Code signatures" CLAUDE.md; then
                echo -e "${BLUE}📝 Updating existing git commit rules with Claude signature prevention...${NC}"
                
                # Backup existing CLAUDE.md
                ensure_backup_dir
                cp CLAUDE.md "$BACKUP_DIR/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
                
                # Replace the existing git commit rules section
                # First, find and remove old section, then add updated one
                awk '
                /^## Git Commit Message Rules/ { skip=1 }
                /^## [^G]/ && skip { skip=0 }
                !skip { print }
                END {
                    if (skip) {
                        print ""
                        print "## Git Commit Message Rules"
                        print ""
                        print "When creating git commits, follow the rules specified in `rules/git-commit-rules.md`."
                        print ""
                        print "**CRITICAL**: Never include Claude Code signatures or AI tool footers in git commit messages. This includes:"
                        print "- 🤖 Generated with [Claude Code](https://claude.ai/code)"
                        print "- Co-Authored-By: Claude <noreply@anthropic.com>"
                        print "- Any other AI attribution or generation footers"
                        print ""
                        print "**Key Rules:**"
                        print "- Use Conventional Commits format: `<type>[optional scope]: <description>`"
                        print "- Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert"
                        print "- Keep description under 50 characters"
                        print "- Use imperative mood"
                        print "- Split commits by functional area (don'\''t combine unrelated changes)"
                        print "- **NO AI signatures or attributions**"
                        print ""
                        print "**Examples:**"
                        print "- `feat: add user authentication module`"
                        print "- `fix: resolve navigation menu styling issue`"
                        print "- `docs: update API endpoint documentation`"
                        print "- `chore: remove deprecated utility functions`"
                        print ""
                        print "For detailed rules, see: rules/git-commit-rules.md"
                    }
                }' CLAUDE.md > CLAUDE.md.tmp && mv CLAUDE.md.tmp CLAUDE.md
                
                echo -e "${GREEN}✅ Git commit rules updated with Claude signature prevention${NC}"
            fi
        fi
    fi
    
    echo ""
    echo -e "${BLUE}💡 Git commit rules summary:${NC}"
    echo "  • Use Conventional Commits format"
    echo "  • Split commits by functional area"
    echo "  • Keep descriptions concise"
    echo "  • NO Claude Code signatures or AI attributions"
    echo "  • NO AI-generated footers in commit messages"
    echo "  • Rules are now integrated into Claude Code configuration"
    
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
    
    if setup_riper5_protocol; then
        echo ""
    else
        # RIPER-5协议失败不影响整体成功
        echo -e "${YELLOW}⚠️ RIPER-5协议安装失败，但其他功能正常${NC}"
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
        echo "6. Test RIPER-5 protocol: use 'ENTER RESEARCH MODE' in Claude Code"
        echo ""
        echo -e "${BLUE}💡 RIPER-5 protocol features:${NC}"
        echo "• Strict 5-mode workflow: RESEARCH → INNOVATE → PLAN → EXECUTE → REVIEW"
        echo "• Mode declaration required in every Claude Code response"
        echo "• Chinese response preference"
        echo "• Prevents unauthorized code modifications"
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