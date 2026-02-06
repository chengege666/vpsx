#!/bin/bash

# 搭建节点工具模块

# 搭建节点工具菜单
function node_tools_menu() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}            搭建节点工具菜单${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  安装 3x-ui 面板 (推荐)"
        echo -e " ${GREEN}2.${NC}  安装 八合一脚本 (Mack-a)"
        echo -e " ${GREEN}3.${NC}  安装 Argo X (X-UI)"
        echo -e " ${GREEN}4.${NC}  Cloudflare Argo 隧道管理"
        echo -e " ${GREEN}5.${NC}  Hi Hysteria"
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
                echo -e "${BLUE}正在启动 Mack-a 八合一脚本...${NC}"
                wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
                read -p "按任意键继续..."
                ;;
            3)
                echo -e "${BLUE}正在启动 Argo X 脚本...${NC}"
                bash <(curl -s https://raw.githubusercontent.com/fscarmen/argox/main/argox.sh)
                read -p "按任意键继续..."
                ;;
            4)
                echo -e "${BLUE}正在启动 Cloudflare Argo 隧道管理脚本...${NC}"
                bash <(curl -L -s 'https://raw.githubusercontent.com/chengege666/cggargo/main/argo.sh')
                read -p "按任意键继续..."
                ;;
            5)
                echo -e "${BLUE}正在启动 Hi Hysteria 安装脚本...${NC}"
                # 注意：根据系统提醒，git.io 链接可能失效，但此处保留用户原始意图，若失效建议用户更换为项目原地址
                bash <(curl -fsSL https://git.io/hysteria.sh)
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
