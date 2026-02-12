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
        echo -e " ${GREEN}3.${NC}  yabs性能测试"
        echo -e " ${GREEN}4.${NC}  流媒体测试（专用）"
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
            3)
                echo -e "${BLUE}正在运行：yabs性能测试...${NC}"
                echo -e "${YELLOW}注意：yabs测试可能需要较长时间，请耐心等待...${NC}"
                curl -sL https://yabs.sh | bash
                read -p "按回车键返回..."
                ;;
            4)
                echo -e "${BLUE}正在运行：流媒体测试（专用）...${NC}"
                bash <(curl -L -s https://github.com/1-stream/RegionRestrictionCheck/raw/main/check.sh)
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
