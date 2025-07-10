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
echo -e "${YELLOW}  4) ⚙️  MCP Config${NC} - Switch MCP configuration level"
echo -e "${RED}  0) Exit${NC}"
echo ""

read -p "Please select (0-4): " choice
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
    4)
        echo -e "${YELLOW}⚙️  MCP Configuration Selector${NC}"
        echo ""
        echo -e "${BLUE}Available MCP configuration levels:${NC}"
        echo ""
        echo -e "${GREEN}  1) CORE (Recommended)${NC} - 3 stable services"
        echo "     • filesystem, memory, everything"
        echo "     • Fixes 502 errors and connection issues"
        echo ""
        echo -e "${BLUE}  2) MINIMAL${NC} - 3 basic services"  
        echo "     • filesystem, memory, fetch"
        echo "     • Most reliable, fewest features"
        echo ""
        echo -e "${YELLOW}  3) STABLE${NC} - 6 reliable services"
        echo "     • + context7, sequential-thinking, everything"
        echo "     • Good balance of features and stability"
        echo ""
        echo -e "${RED}  4) FULL${NC} - 13 services (may cause issues)"
        echo "     • All services including git, database, browser"
        echo "     • Maximum features but potential connection problems"
        echo ""
        
        read -p "Select configuration level (1-4): " -n 1 -r
        echo ""
        echo ""
        
        case $REPLY in
            1)
                config_name="core"
                echo -e "${GREEN}Applying CORE configuration...${NC}"
                ;;
            2)
                config_name="minimal"
                echo -e "${BLUE}Applying MINIMAL configuration...${NC}"
                ;;
            3)
                config_name="stable"
                echo -e "${YELLOW}Applying STABLE configuration...${NC}"
                ;;
            4)
                config_name="ultimate"
                echo -e "${RED}Applying FULL configuration...${NC}"
                echo -e "${YELLOW}⚠️  Warning: This may cause connection issues${NC}"
                ;;
            *)
                echo -e "${RED}❌ Invalid selection${NC}"
                exit 1
                ;;
        esac
        
        # Apply selected configuration
        if [ -f "$SCRIPT_DIR/mcp-configs/${config_name}.json" ]; then
            # Backup existing
            if [ -f ".mcp.json" ]; then
                mkdir -p .claude/backups
                cp .mcp.json ".claude/backups/mcp.json.backup.$(date +%Y%m%d_%H%M%S)"
                echo -e "${YELLOW}📦 Backed up existing configuration${NC}"
            fi
            
            # Apply new configuration
            cp "$SCRIPT_DIR/mcp-configs/${config_name}.json" .mcp.json
            
            # Adjust paths
            if command -v sed >/dev/null 2>&1; then
                sed -i.tmp "s|/path/to/project|$CURRENT_DIR|g" .mcp.json && rm -f .mcp.json.tmp
            fi
            
            echo -e "${GREEN}✅ MCP configuration updated to ${config_name}${NC}"
            echo -e "${BLUE}💡 Restart Claude Code to apply changes${NC}"
        else
            echo -e "${RED}❌ Configuration file not found: ${config_name}.json${NC}"
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