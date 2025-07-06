#!/bin/bash

# Claude Code 管理工具 - 精简版

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# 脚本目录
SCRIPT_DIR="$(dirname "$0")"
CURRENT_DIR=$(pwd)

# 显示logo
echo -e "${BLUE}🤖 Claude Code 管理工具${NC}"
echo -e "${CYAN}简化版 - 专注核心功能${NC}"
echo ""

# 显示菜单
echo -e "${YELLOW}选择操作：${NC}"
echo ""
echo -e "${GREEN}  1) 🚀 快速设置${NC} - 一键配置所有功能"
echo -e "${BLUE}  2) 📋 查看状态${NC} - 检查当前配置"
echo -e "${CYAN}  3) 🔄 重新配置${NC} - 更新现有配置"
echo -e "${RED}  0) 退出${NC}"
echo ""

read -p "请选择 (0-3): " choice
echo ""

case $choice in
    1)
        echo -e "${YELLOW}🚀 开始快速设置...${NC}"
        if bash "$SCRIPT_DIR/setup.sh"; then
            echo ""
            echo -e "${GREEN}✅ 快速设置完成！${NC}"
        else
            echo -e "${RED}❌ 设置失败${NC}"
        fi
        ;;
    2)
        echo -e "${BLUE}📋 检查配置状态...${NC}"
        echo ""
        
        # 检查Claude配置
        if [ -d ".claude" ]; then
            echo -e "${GREEN}✅ Claude配置: 已配置${NC}"
            if [ -f ".claude/ultrathink-task.md" ]; then
                echo -e "   • ultrathink-task: ✅"
            fi
            if [ -f ".claude/code-review.md" ]; then
                echo -e "   • code-review: ✅"
            fi
        else
            echo -e "${RED}❌ Claude配置: 未配置${NC}"
        fi
        
        echo ""
        
        # 检查MCP配置
        if [ -f ".mcp.json" ]; then
            echo -e "${GREEN}✅ MCP配置: 已配置${NC}"
            local server_count=$(grep -c '"[^"]*":' .mcp.json 2>/dev/null || echo "0")
            echo -e "   • 服务数量: $server_count"
        else
            echo -e "${RED}❌ MCP配置: 未配置${NC}"
        fi
        
        echo ""
        if [ ! -d ".claude" ] || [ ! -f ".mcp.json" ]; then
            echo -e "${CYAN}💡 建议运行快速设置${NC}"
        else
            echo -e "${GREEN}🎉 配置完整，可以开始使用！${NC}"
        fi
        ;;
    3)
        echo -e "${CYAN}🔄 重新配置...${NC}"
        if bash "$SCRIPT_DIR/setup.sh"; then
            echo ""
            echo -e "${GREEN}✅ 重新配置完成！${NC}"
        else
            echo -e "${RED}❌ 配置失败${NC}"
        fi
        ;;
    0)
        echo -e "${GREEN}👋 再见！${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}❌ 无效选择${NC}"
        ;;
esac