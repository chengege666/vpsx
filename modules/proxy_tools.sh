#!/bin/bash

# 搭建节点工具模块

# 搭建节点工具菜单
function node_tools_menu() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}            工具菜单${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  安装 3x-ui 面板 (启动x-ui)"
        echo -e " ${GREEN}2.${NC}  cgg-Argo 隧道管理"
        echo -e " ${GREEN}3.${NC}  s-ui（s-ui）"
        echo -e " ${GREEN}4.${NC}  PVE 工具箱"
        echo -e " ${GREEN}5.${NC}  PVE 镜像转换与部署"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回主菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-5): " node_choice

        case "$node_choice" in
            1)
                echo -e "${BLUE}正在启动 3x-ui 安装脚本...${NC}"
                bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
                read -p "按任意键继续..."
                ;;
            2)
                echo -e "${BLUE}正在启动 cgg-Argo 隧道管理脚本...${NC}"
                bash <(curl -L -s 'https://raw.githubusercontent.com/chengege666/cggargo/main/argo.sh')
                read -p "按任意键继续..."
                ;;
            3)
                echo -e "${BLUE}正在启动 s-ui 脚本...${NC}"
                bash <(curl -Ls https://raw.githubusercontent.com/alireza0/s-ui/master/install.sh)
                read -p "按任意键继续..."
                ;;
            4)
                echo -e "${BLUE}正在启动 PVE 工具箱脚本...${NC}"
                bash <(curl -fsSL lj.1231818.xyz/pve)
                read -p "按任意键继续..."
                ;;
            5)
                echo -e "${BLUE}正在启动 PVE 镜像转换与部署脚本...${NC}"
                bash <(curl -sL https://lj.1231818.xyz/pvezh)
                read -p "按任意键继续..."
                ;;
            0)
                break
                ;;
            *)
                echo -e "${RED}无效的选择，请重新输入！${NC}"
                read -p "按任意键继续..."
                ;;
        esac
    done
}
