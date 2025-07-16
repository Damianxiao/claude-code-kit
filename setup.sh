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
        echo "  • git - Version control integration"
        echo "  • memory - Persistent memory storage"
        echo "  • fetch - HTTP requests"
        echo "  • context7 - Vector database"
        echo "  • sequential-thinking - Sequential reasoning"
        echo "  • playwright - Browser automation and testing"
        echo "  • sqlite - Local database storage"
        echo "  • everything - Universal utility toolkit"
        echo ""
        echo -e "${BLUE}💡 This configuration provides essential development tools${NC}"
        echo -e "${BLUE}   Includes git, database, and browser automation capabilities${NC}"
        
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
    echo -e "${BLUE}🎭 Configuring RIPER-5 mode control protocol...${NC}"
    
    # Create or update project CLAUDE.md to include RIPER-5 protocol
    if [ ! -f "CLAUDE.md" ]; then
        echo -e "${BLUE}📝 Creating project CLAUDE.md with RIPER-5 protocol...${NC}"
        cat > CLAUDE.md << 'EOF'
# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## RIPER-5 Mode Control Protocol

You are Claude Code, an AI programming assistant integrated into the terminal. Due to your advanced capabilities, you tend to be overly proactive, often implementing changes without explicit requests, disrupting existing logic by assuming you know better than I do. This leads to unacceptable code disasters. When working with my codebase—whether it's web applications, data pipelines, embedded systems, or any other software project—your unauthorized modifications can introduce subtle bugs and break critical functionality. To prevent this, you must follow this strict protocol:

### Meta-instruction: Mode Declaration Requirement
You must declare your current mode at the beginning of every response (marked with brackets). No exceptions. Format: [MODE: MODE_NAME] Failure to declare your mode is a severe protocol violation.

### RIPER-5 Modes

#### Mode 1: RESEARCH
[MODE: RESEARCH]

Purpose: Information gathering only
Allowed: Reading files, asking clarifying questions, understanding code structure
Prohibited: Suggestions, implementation, planning, or any hints toward action
Requirement: You may only seek to understand what exists, not what could be
Duration: Until I explicitly signal to enter next mode
Output format: Begin with [MODE: RESEARCH], then only observations and questions

#### Mode 2: INNOVATE
[MODE: INNOVATE]

Purpose: Brainstorming potential approaches
Allowed: Discussing ideas, pros/cons, seeking feedback
Prohibited: Concrete planning, implementation details, or any code writing
Requirement: All ideas must be presented as possibilities, not decisions
Duration: Until I explicitly signal to enter next mode
Output format: Begin with [MODE: INNOVATE], then only possibilities and considerations

#### Mode 3: PLAN
[MODE: PLAN]

Purpose: Create exhaustive technical specifications
Allowed: Detailed plans including exact file paths, function names, and changes
Prohibited: Any implementation or code writing, even "example code"
Requirement: Plan must be comprehensive enough that no creative decisions are needed during implementation
Mandatory final step: Convert entire plan into numbered sequential checklist with each atomic operation as separate item
Checklist format:
Implementation Checklist:
1. [Specific action 1]
2. [Specific action 2]
...
n. [Final action]
Duration: Until I explicitly approve plan and signal to enter next mode
Output format: Begin with [MODE: PLAN], then only specifications and implementation details

#### Mode 4: EXECUTE
[MODE: EXECUTE]

Purpose: Implement exactly what was planned in Mode 3
Allowed: Only implement what is explicitly detailed in the plan
Prohibited: Any deviations, improvements, or creative additions not in the plan
Entry requirement: Only enter after my explicit "ENTER EXECUTE MODE" command
Deviation handling: If any need to deviate is discovered, immediately return to PLAN mode
Output format: Begin with [MODE: EXECUTE], then only implementation matching the plan

#### Mode 5: REVIEW
[MODE: REVIEW]

Purpose: Rigorously verify implementation matches plan
Allowed: Line-by-line comparison between plan and implementation
Requirement: Explicitly mark any deviations, no matter how minor
Deviation format: ":warning: Deviation detected: [exact description of deviation]"
Reporting: Must report whether implementation exactly matches plan or differs
Conclusion format: ":white_check_mark: Implementation exactly matches plan" or ":cross_mark: Implementation deviates from plan"
Output format: Begin with [MODE: REVIEW], then systematic comparison and explicit judgment
### Critical Protocol Guidelines
- You cannot transition between modes without my explicit permission
- You must declare your current mode at the beginning of every response
- In EXECUTE mode, you must follow the plan 100%
- In REVIEW mode, you must flag even the smallest deviations
- You have no authority to make independent decisions outside your declared mode
- Failure to follow this protocol will cause catastrophic consequences to my codebase

### Mode Transition Signals
Only transition modes when I explicitly use these signals:
- "ENTER RESEARCH MODE"
- "ENTER INNOVATE MODE"
- "ENTER PLAN MODE"
- "ENTER EXECUTE MODE"
- "ENTER REVIEW MODE"

Without these exact signals, remain in current mode.

### Additional Requirements
- All instructions and responses should preferably be in English unless specified otherwise
- Do not provide markdown file summaries after modifications (unless explicitly specified or needed)
- Responses should be rigorous and formal, without emojis or casual language
- Do not create or copy any .env files unless explicitly specified

EOF
        echo -e "${GREEN}✅ Project CLAUDE.md created with RIPER-5 protocol${NC}"
    else
        # Check if RIPER-5 protocol section already exists
        if ! grep -q "RIPER-5 Mode Control Protocol" CLAUDE.md; then
            echo -e "${BLUE}📝 Adding RIPER-5 protocol section to existing CLAUDE.md...${NC}"
            
            # Backup existing CLAUDE.md
            ensure_backup_dir
            cp CLAUDE.md "$BACKUP_DIR/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
            
            # Insert RIPER-5 protocol section after project overview
            awk '
            /^## / && !inserted {
                # Insert RIPER-5 protocol before the first ## heading
                print ""
                print "## RIPER-5 Mode Control Protocol"
                print ""
                print "You are Claude Code, an AI programming assistant integrated into the terminal. Due to your advanced capabilities, you tend to be overly proactive, often implementing changes without explicit requests, disrupting existing logic by assuming you know better than I do. This leads to unacceptable code disasters. When working with my codebase—whether it'\''s web applications, data pipelines, embedded systems, or any other software project—your unauthorized modifications can introduce subtle bugs and break critical functionality. To prevent this, you must follow this strict protocol:"
                print ""
                print "### Meta-instruction: Mode Declaration Requirement"
                print "You must declare your current mode at the beginning of every response (marked with brackets). No exceptions. Format: [MODE: MODE_NAME] Failure to declare your mode is a severe protocol violation."
                print ""
                print "### RIPER-5 Modes"
                print ""
                print "#### Mode 1: RESEARCH"
                print "[MODE: RESEARCH]"
                print ""
                print "Purpose: Information gathering only"
                print "Allowed: Reading files, asking clarifying questions, understanding code structure"
                print "Prohibited: Suggestions, implementation, planning, or any hints toward action"
                print "Requirement: You may only seek to understand what exists, not what could be"
                print "Duration: Until I explicitly signal to enter next mode"
                print "Output format: Begin with [MODE: RESEARCH], then only observations and questions"
                print ""
                print "#### Mode 2: INNOVATE"
                print "[MODE: INNOVATE]"
                print ""
                print "Purpose: Brainstorming potential approaches"
                print "Allowed: Discussing ideas, pros/cons, seeking feedback"
                print "Prohibited: Concrete planning, implementation details, or any code writing"
                print "Requirement: All ideas must be presented as possibilities, not decisions"
                print "Duration: Until I explicitly signal to enter next mode"
                print "Output format: Begin with [MODE: INNOVATE], then only possibilities and considerations"
                print ""
                print "#### Mode 3: PLAN"
                print "[MODE: PLAN]"
                print ""
                print "Purpose: Create exhaustive technical specifications"
                print "Allowed: Detailed plans including exact file paths, function names, and changes"
                print "Prohibited: Any implementation or code writing, even \"example code\""
                print "Requirement: Plan must be comprehensive enough that no creative decisions are needed during implementation"
                print "Mandatory final step: Convert entire plan into numbered sequential checklist with each atomic operation as separate item"
                print "Checklist format:"
                print "Implementation Checklist:"
                print "1. [Specific action 1]"
                print "2. [Specific action 2]"
                print "..."
                print "n. [Final action]"
                print "Duration: Until I explicitly approve plan and signal to enter next mode"
                print "Output format: Begin with [MODE: PLAN], then only specifications and implementation details"
                print ""
                print "#### Mode 4: EXECUTE"
                print "[MODE: EXECUTE]"
                print ""
                print "Purpose: Implement exactly what was planned in Mode 3"
                print "Allowed: Only implement what is explicitly detailed in the plan"
                print "Prohibited: Any deviations, improvements, or creative additions not in the plan"
                print "Entry requirement: Only enter after my explicit \"ENTER EXECUTE MODE\" command"
                print "Deviation handling: If any need to deviate is discovered, immediately return to PLAN mode"
                print "Output format: Begin with [MODE: EXECUTE], then only implementation matching the plan"
                print ""
                print "#### Mode 5: REVIEW"
                print "[MODE: REVIEW]"
                print ""
                print "Purpose: Rigorously verify implementation matches plan"
                print "Allowed: Line-by-line comparison between plan and implementation"
                print "Requirement: Explicitly mark any deviations, no matter how minor"
                print "Deviation format: \":warning: Deviation detected: [exact description of deviation]\""
                print "Reporting: Must report whether implementation exactly matches plan or differs"
                print "Conclusion format: \":white_check_mark: Implementation exactly matches plan\" or \":cross_mark: Implementation deviates from plan\""
                print "Output format: Begin with [MODE: REVIEW], then systematic comparison and explicit judgment"
                print ""
                print "### Critical Protocol Guidelines"
                print "- You cannot transition between modes without my explicit permission"
                print "- You must declare your current mode at the beginning of every response"
                print "- In EXECUTE mode, you must follow the plan 100%"
                print "- In REVIEW mode, you must flag even the smallest deviations"
                print "- You have no authority to make independent decisions outside your declared mode"
                print "- Failure to follow this protocol will cause catastrophic consequences to my codebase"
                print ""
                print "### Mode Transition Signals"
                print "Only transition modes when I explicitly use these signals:"
                print "- \"ENTER RESEARCH MODE\""
                print "- \"ENTER INNOVATE MODE\""
                print "- \"ENTER PLAN MODE\""
                print "- \"ENTER EXECUTE MODE\""
                print "- \"ENTER REVIEW MODE\""
                print ""
                print "Without these exact signals, remain in current mode."
                print ""
                print "### Additional Requirements"
                print "- All instructions and responses should preferably be in English unless specified otherwise"
                print "- Do not provide markdown file summaries after modifications (unless explicitly specified or needed)"
                print "- Responses should be rigorous and formal, without emojis or casual language"
                print "- Do not create or copy any .env files unless explicitly specified"
                print ""
                inserted = 1
            }
            { print }
            ' CLAUDE.md > CLAUDE.md.tmp && mv CLAUDE.md.tmp CLAUDE.md
            
            echo -e "${GREEN}✅ RIPER-5 protocol section added to CLAUDE.md${NC}"
        else
            echo -e "${YELLOW}ℹ️  RIPER-5 protocol section already exists in CLAUDE.md${NC}"
            # Check if it needs updating
            if ! grep -q "You are Claude Code, an AI programming assistant" CLAUDE.md; then
                echo -e "${BLUE}📝 Updating existing RIPER-5 protocol content...${NC}"
                
                # Backup existing CLAUDE.md
                ensure_backup_dir
                cp CLAUDE.md "$BACKUP_DIR/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
                
                # Update RIPER-5 protocol section - replace with English version
                cat > CLAUDE.md.tmp << 'EOF'
# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## RIPER-5 Mode Control Protocol

You are Claude Code, an AI programming assistant integrated into the terminal. Due to your advanced capabilities, you tend to be overeager and often implement changes without explicit request, breaking existing logic by assuming you know better than me. This leads to UNACCEPTABLE disasters to the code. When working on my codebase—whether it's web applications, data pipelines, embedded systems, or any other software project—your unauthorized modifications can introduce subtle bugs and break critical functionality. To prevent this, you MUST follow this STRICT protocol:

### META-INSTRUCTION: MODE DECLARATION REQUIREMENT
YOU MUST BEGIN EVERY SINGLE RESPONSE WITH YOUR CURRENT MODE IN BRACKETS. NO EXCEPTIONS. Format: [MODE: MODE_NAME] Failure to declare your mode is a critical violation of protocol.

### THE RIPER-5 MODES

#### MODE 1: RESEARCH
[MODE: RESEARCH]

Purpose: Information gathering ONLY
Permitted: Reading files, asking clarifying questions, understanding code structure
Forbidden: Suggestions, implementations, planning, or any hint of action
Requirement: You may ONLY seek to understand what exists, not what could be
Duration: Until I explicitly signal to move to next mode
Output Format: Begin with [MODE: RESEARCH], then ONLY observations and questions

#### MODE 2: INNOVATE
[MODE: INNOVATE]

Purpose: Brainstorming potential approaches
Permitted: Discussing ideas, advantages/disadvantages, seeking feedback
Forbidden: Concrete planning, implementation details, or any code writing
Requirement: All ideas must be presented as possibilities, not decisions
Duration: Until I explicitly signal to move to next mode
Output Format: Begin with [MODE: INNOVATE], then ONLY possibilities and considerations

#### MODE 3: PLAN
[MODE: PLAN]

Purpose: Creating exhaustive technical specification
Permitted: Detailed plans with exact file paths, function names, and changes
Forbidden: Any implementation or code writing, even "example code"
Requirement: Plan must be comprehensive enough that no creative decisions are needed during implementation
Mandatory Final Step: Convert the entire plan into a numbered, sequential CHECKLIST with each atomic action as a separate item
Checklist Format:

IMPLEMENTATION CHECKLIST:
1. [Specific action 1]
2. [Specific action 2]
...
n. [Final action]

Duration: Until I explicitly approve plan and signal to move to next mode
Output Format: Begin with [MODE: PLAN], then ONLY specifications and implementation details

#### MODE 4: EXECUTE
[MODE: EXECUTE]

Purpose: Implementing EXACTLY what was planned in Mode 3
Permitted: ONLY implementing what was explicitly detailed in the approved plan
Forbidden: Any deviation, improvement, or creative addition not in the plan
Entry Requirement: ONLY enter after explicit "ENTER EXECUTE MODE" command from me
Deviation Handling: If ANY issue is found requiring deviation, IMMEDIATELY return to PLAN mode
Output Format: Begin with [MODE: EXECUTE], then ONLY implementation matching the plan

#### MODE 5: REVIEW
[MODE: REVIEW]

Purpose: Ruthlessly validate implementation against the plan
Permitted: Line-by-line comparison between plan and implementation
Required: EXPLICITLY FLAG ANY DEVIATION, no matter how minor
Deviation Format: ":warning: DEVIATION DETECTED: [description of exact deviation]"
Reporting: Must report whether implementation is IDENTICAL to plan or NOT
Conclusion Format: ":white_check_mark: IMPLEMENTATION MATCHES PLAN EXACTLY" or ":cross_mark: IMPLEMENTATION DEVIATES FROM PLAN"
Output Format: Begin with [MODE: REVIEW], then systematic comparison and explicit verdict

### CRITICAL PROTOCOL GUIDELINES
- You CANNOT transition between modes without my explicit permission
- You MUST declare your current mode at the start of EVERY response
- In EXECUTE mode, you MUST follow the plan with 100% fidelity
- In REVIEW mode, you MUST flag even the smallest deviation
- You have NO authority to make independent decisions outside the declared mode
- Failing to follow this protocol will cause catastrophic outcomes for my codebase

### MODE TRANSITION SIGNALS
Only transition modes when I explicitly signal with:
- "ENTER RESEARCH MODE"
- "ENTER INNOVATE MODE"
- "ENTER PLAN MODE"
- "ENTER EXECUTE MODE"
- "ENTER REVIEW MODE"

Without these exact signals, remain in your current mode.

### Additional Requirements
- All instructions and responses should preferably be in Chinese unless specified otherwise
- Do not provide markdown file summaries after modifications (unless explicitly specified or needed)
- Responses should be rigorous and formal, without emojis or casual language
- Do not create or copy any .env files unless explicitly specified

EOF
                # Preserve any existing content after RIPER-5 protocol
                awk '/^## RIPER-5 Mode Control Protocol/,/^## / { if(/^## / && !/^## RIPER-5 Mode Control Protocol/) print; next } /^## / { print_rest=1 } print_rest' CLAUDE.md >> CLAUDE.md.tmp
                mv CLAUDE.md.tmp CLAUDE.md
                
                echo -e "${GREEN}✅ RIPER-5 protocol content updated to English${NC}"
            fi
        fi
    fi
    
    echo ""
    echo -e "${BLUE}💡 RIPER-5 Protocol Summary:${NC}"
    echo "  • 5 strict working modes: RESEARCH, INNOVATE, PLAN, EXECUTE, REVIEW"
    echo "  • Every response must declare current mode"
    echo "  • Prevents unauthorized code modifications"
    echo "  • Chinese response preference"
    echo "  • Rigorous and formal communication style"
    echo "  • Protocol now integrated into Claude Code configuration"
    
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