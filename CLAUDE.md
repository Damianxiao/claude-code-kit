# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Claude Code prompt management system (Claude Code 提示词管理仓库) designed to organize and reuse Claude Code prompts across different projects. The system provides a collection of specialized prompts and automated scripts for deployment across development environments.

## Key Commands

### 🚀 一键设置 (主要方式)
```bash
# 一键配置最全MCP服务和提示词
~/claude-code-prompt-sync/setup.sh
```

**特点**：
- 🎯 **零配置**：自动配置13个最强MCP服务
- ⚡ **极速**：30秒完成所有配置
- 🧠 **最强功能**：包含magic、context7、sequential-thinking等AI增强
- 🎭 **SuperClaude框架**：19个专业开发命令 + 9个认知角色
- 📱 **傻瓜式**：无需任何选择，直接获得最佳配置

### 🎛️ 管理工具 (可选)
```bash
# 状态检查和重新配置
~/claude-code-prompt-sync/manage.sh
```

**特点**：
- 📊 配置状态检查
- 🔄 重新配置功能
- 🎯 精简版管理界面

### Project Types Supported
- `react` - React applications
- `vue` - Vue applications  
- `nodejs` - Node.js projects
- `go` - Go projects
- `python` - Python projects
- `rust` - Rust projects
- `java` - Java projects
- `php` - PHP projects

## Core Architecture

### Directory Structure
- **`prompts/`** - Core prompt definitions (ultrathink-task.md, code-review.md)
- **`mcp-configs/`** - Ultimate MCP service configuration
- **`setup.sh`** - Main setup script
- **`manage.sh`** - Management tool

### Key Files
- **`setup.sh`** - 🥇 **Main script** - One-click setup for everything
- **`manage.sh`** - 🎛️ **Management tool** - Status check and reconfiguration
- **`ultimate.json`** - 🔧 **Complete MCP config** - All 13 premium services including magic

### Prompt System
- **Ultrathink Task** (`/project:ultrathink-task`) - 4-agent collaborative analysis (Architect, Research, Coder, Tester)
- **Code Review** (`/project:code-review`) - Professional code analysis and security audit

### MCP Configuration System
- **Auto-detection** - Automatically applies appropriate MCP configs based on project type
- **Pre-configured Templates** - Common, frontend, backend, fullstack, and enhanced configurations
- **Enhanced Services** - Includes context7, sequential-thinking, browser-tools, and advanced fetch
- **Centralized Management** - Single source of truth for MCP configurations across all projects

### SuperClaude Development Framework
- **19 Professional Commands** - Complete development lifecycle coverage
  - `/build`, `/test`, `/deploy` - Core development commands
  - `/analyze`, `/review`, `/troubleshoot` - Analysis and quality commands  
  - `/create`, `/refactor`, `/optimize` - Code generation and improvement
- **9 Cognitive Personas** - Specialized expert perspectives
  - `--persona-architect` - System architecture expert
  - `--persona-security` - Security and vulnerability specialist
  - `--persona-frontend` - UI/UX and frontend specialist
  - `--persona-backend` - Server and database expert
  - `--persona-qa` - Testing and quality assurance
  - `--persona-devops` - Deployment and infrastructure
- **Enhanced Options** - AI-powered development features
  - `--think` - Deep analytical thinking mode
  - `--seq` - Sequential reasoning process
  - `--magic` - AI component generation integration

## Development Workflow

### For New Projects
1. Navigate to project directory
2. Run `setup.sh` for complete configuration (prompts + MCP + SuperClaude)
3. Use available command systems:
   - `/project:ultrathink-task` and `/project:code-review` for core prompts
   - SuperClaude commands like `/build --react --magic --persona-frontend`
   - Full MCP service integration for enhanced capabilities

### For Existing Projects
1. Navigate to project directory  
2. Run `setup.sh` to apply complete configuration
3. Choose to install SuperClaude framework when prompted
4. Access generated guide at `.claude/guide.md` for project-specific commands

### Enhanced Development Commands
- **Quick Analysis**: `/project:ultrathink-task` + `/analyze --architecture --seq --persona-architect`
- **Code Quality**: `/project:code-review` + `/review --security --owasp --persona-security`
- **Component Development**: `/build --react --magic --tdd --persona-frontend`
- **Testing Automation**: `/test --coverage --e2e --pup --persona-qa`
- **Deployment Planning**: `/deploy --env staging --plan --persona-devops`

### Cross-Project Management
- Scripts automatically detect project types via package.json, go.mod, etc.
- Update script searches common directories (~/projects, ~/workspace, ~/dev, ~/code)
- Backup existing configurations before updates

## Important Notes

- The system creates `.claude/` directories in each project
- Automatically creates `.mcp.json` files with appropriate MCP service configurations
- Prompts are language-agnostic but provide type-specific guidance
- MCP configurations are automatically tailored to project types (frontend/backend/fullstack)
- All scripts include error handling and user confirmation prompts
- The system supports both standalone usage and git-based updates
- Enhanced MCP services include specialized tools like context7 and browser automation
- **SuperClaude Integration**: Optional framework providing 19 professional commands and 9 cognitive personas
- **Interactive Installation**: User can choose whether to install SuperClaude during setup
- **Evidence-Based Development**: SuperClaude promotes systematic, evidence-driven development methodology
- **Cross-Framework Compatibility**: Works with React, Vue, Node.js, Go, Python, Rust, Java, and PHP projects