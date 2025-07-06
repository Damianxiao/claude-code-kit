#!/bin/bash

# Claude Code Kit - Management Tool (Streamlined Version)

set -e

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$(dirname "$0")"
CURRENT_DIR=$(pwd)

# Display logo
echo -e "${BLUE}🤖 Claude Code Kit - Management Tool${NC}"
echo -e "${CYAN}Streamlined Version - Focus on Core Features${NC}"
echo ""

# Display menu
echo -e "${YELLOW}Select operation:${NC}"
echo ""
echo -e "${GREEN}  1) 🚀 Quick Setup${NC} - One-click configuration of all features"
echo -e "${BLUE}  2) 📋 Check Status${NC} - Check current configuration"
echo -e "${CYAN}  3) 🔄 Reconfigure${NC} - Update existing configuration"
echo -e "${RED}  0) Exit${NC}"
echo ""

read -p "Please select (0-3): " choice
echo ""

case $choice in
    1)
        echo -e "${YELLOW}🚀 Starting quick setup...${NC}"
        if bash "$SCRIPT_DIR/setup.sh"; then
            echo ""
            echo -e "${GREEN}✅ Quick setup completed!${NC}"
        else
            echo -e "${RED}❌ Setup failed${NC}"
        fi
        ;;
    2)
        echo -e "${BLUE}📋 Checking configuration status...${NC}"
        echo ""
        
        # Check Claude configuration
        if [ -d ".claude" ]; then
            echo -e "${GREEN}✅ Claude configuration: Configured${NC}"
            if [ -f ".claude/ultrathink-task.md" ]; then
                echo -e "   • ultrathink-task: ✅"
            fi
            if [ -f ".claude/code-review.md" ]; then
                echo -e "   • code-review: ✅"
            fi
        else
            echo -e "${RED}❌ Claude configuration: Not configured${NC}"
        fi
        
        echo ""
        
        # Check MCP configuration
        if [ -f ".mcp.json" ]; then
            echo -e "${GREEN}✅ MCP configuration: Configured${NC}"
            local server_count=$(grep -c '"[^"]*":' .mcp.json 2>/dev/null || echo "0")
            echo -e "   • Service count: $server_count"
        else
            echo -e "${RED}❌ MCP configuration: Not configured${NC}"
        fi
        
        echo ""
        if [ ! -d ".claude" ] || [ ! -f ".mcp.json" ]; then
            echo -e "${CYAN}💡 Recommend running quick setup${NC}"
        else
            echo -e "${GREEN}🎉 Configuration complete, ready to use!${NC}"
        fi
        ;;
    3)
        echo -e "${CYAN}🔄 Reconfiguring...${NC}"
        if bash "$SCRIPT_DIR/setup.sh"; then
            echo ""
            echo -e "${GREEN}✅ Reconfiguration completed!${NC}"
        else
            echo -e "${RED}❌ Configuration failed${NC}"
        fi
        ;;
    0)
        echo -e "${GREEN}👋 Goodbye!${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}❌ Invalid selection${NC}"
        ;;
esac