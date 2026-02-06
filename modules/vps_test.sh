#!/bin/bash

# VPS测试脚本模块

# VPS测试脚本菜单
function vps_test_menu() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             VPS测试脚本${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  网络质量体检脚本"
        echo -e " ${GREEN}2.${NC}  NodeQuality（沙箱测试）"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回主菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择: " vps_test_choice

        case "$vps_test_choice" in
            1)
                echo -e "${BLUE}正在运行：网络质量体检脚本...${NC}"
                bash <(curl -Ls https://Check.Place)
                read -p "按回车键返回..."
                ;;
            2)
                echo -e "${BLUE}正在运行：NodeQuality（沙箱测试）...${NC}"
                bash <(curl -sL https://run.NodeQuality.com)
                read -p "按回车键返回..."
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
