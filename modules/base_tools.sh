#!/bin/bash

# 基础工具模块
function basic_tools_menu() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}            基础工具菜单${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC} 安装 htop"
        echo -e " ${GREEN}2.${NC} 安装 wget"
        echo -e " ${GREEN}3.${NC} 安装 curl"
        echo -e " ${GREEN}4.${NC} 安装 git"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC} 返回主菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择(0-4): " basic_tool_choice

        case "$basic_tool_choice" in
            1)
                install_package "htop"
                ;;
            2)
                install_package "wget"
                ;;
            3)
                install_package "curl"
                ;;
            4)
                install_package "git"
                ;;
            0)
                break
                ;;
            *)
                echo -e "${RED}无效的选择，请重新输入！${NC}"
                sleep 2
                ;;
        esac
    done
}
