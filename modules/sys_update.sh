#!/bin/bash

# 系统更新模块
function system_update() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            系统更新${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo ""
    echo -e "${YELLOW}开始检查并更新系统...${NC}"
    if command -v apt >/dev/null 2>&1; then
        echo -e "${BLUE}检测到 Debian/Ubuntu 系统，使用 apt 进行更新...${NC}"
        sudo apt update && sudo apt upgrade -y
    elif command -v yum >/dev/null 2>&1; then
        echo -e "${BLUE}检测到 CentOS/RHEL 系统，使用 yum 进行更新...${NC}"
        sudo yum update -y
    elif command -v dnf >/dev/null 2>&1; then
        echo -e "${BLUE}检测到 Fedora/RHEL 8+ 系统，使用 dnf 进行更新...${NC}"
        sudo dnf update -y
    else
        echo -e "${RED}未检测到支持的包管理器 (apt, yum, dnf)。请手动更新系统。${NC}"
    fi
    echo ""
    echo -e "${GREEN}系统更新完成。${NC}"
    echo ""
}
