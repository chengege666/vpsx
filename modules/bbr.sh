#!/bin/bash

# BBR 综合测速
function bbr_speed_test() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          BBR 综合测速${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo ""
    if ! command -v speedtest >/dev/null 2>&1 && ! command -v speedtest-cli >/dev/null 2>&1; then
        echo -e "${RED}未检测到 speedtest-cli。请先安装 speedtest-cli。${NC}"
        read -p "是否现在安装 speedtest-cli？(y/N): " install_confirm
        if [[ "$install_confirm" =~ ^[yY]$ ]]; then
            manage_speedtest_cli
        else
            echo "取消安装 speedtest-cli。"
        fi
    else
        echo -e "${YELLOW}正在进行 测速BBR，请稍候...${NC}"
        if command -v speedtest >/dev/null 2>&1; then
            speedtest
        else
            speedtest-cli
        fi
    fi
    echo ""
    read -p "按任意键返回..."
}

# BBR 内核安装/切换
function install_switch_bbr_kernel() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        BBR 内核安装/切换 (ylx2016 脚本)${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo ""
    echo -e "${YELLOW}正在下载并运行 ylx2016 的 BBR 内核安装/切换脚本...${NC}"
    echo "此脚本将提供交互式菜单，请根据提示进行操作。"
    echo ""
    wget -O tcpx.sh "https://github.com/ylx2016/Linux-NetSpeed/raw/master/tcpx.sh" && chmod +x tcpx.sh && ./tcpx.sh
    echo ""
    read -p "按任意键返回..."
}

# 查看系统 BBR 信息
function view_bbr_system_info() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          查看系统 BBR 信息${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo ""
    echo -e "${YELLOW}--- BBR 拥塞控制信息 ---${NC}"
    echo -e "当前拥塞控制算法: ${GREEN}$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')${NC}"
    echo -e "可用拥塞控制算法: ${BLUE}$(sysctl net.ipv4.tcp_available_congestion_control | awk -F'=' '{print $2}')${NC}"
    echo ""
    echo -e "${YELLOW}--- 队列规则信息 ---${NC}"
    QDISC_INFO=$(sysctl net.core.default_qdisc 2>/dev/null | awk '{print $3}')
    if [ -z "$QDISC_INFO" ]; then
        echo -e "当前队列规则: ${RED}N/A${NC}"
    else
        echo -e "当前队列规则: ${GREEN}$QDISC_INFO${NC}"
    fi
    echo ""
    read -p "按任意键返回..."
}

# speedtest-cli 测速依赖管理
function manage_speedtest_cli() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}    speedtest-cli 测速依赖 (安装/卸载)${NC}"
        echo -e "${CYAN}=========================================${NC}"
        if command -v speedtest >/dev/null 2>&1 || command -v speedtest-cli >/dev/null 2>&1; then
            echo -e "当前状态: ${GREEN}speedtest-cli 已安装${NC}"
        else
            echo -e "当前状态: ${RED}speedtest-cli 未安装${NC}"
        fi
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${GREEN}1.${NC} 安装 speedtest-cli"
        echo -e " ${GREEN}2.${NC} 卸载 speedtest-cli"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC} 返回 BBR 管理菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择(0-2): " speedtest_choice

        case "$speedtest_choice" in
            1)
                if command -v speedtest >/dev/null 2>&1 || command -v speedtest-cli >/dev/null 2>&1; then
                    echo -e "${YELLOW}speedtest-cli 已经安装。${NC}"
                else
                    echo -e "${BLUE}正在安装 speedtest-cli...${NC}"
                    install_package "speedtest-cli"
                fi
                read -p "按任意键继续..."
                ;;
            2)
                if ! command -v speedtest >/dev/null 2>&1 && ! command -v speedtest-cli >/dev/null 2>&1; then
                    echo -e "${YELLOW}speedtest-cli 未安装，无需卸载。${NC}"
                else
                    echo -e "${BLUE}正在卸载 speedtest-cli...${NC}"
                    if command -v apt >/dev/null 2>&1; then
                        sudo apt remove -y speedtest-cli
                    elif command -v yum >/dev/null 2>&1; then
                        sudo yum remove -y speedtest-cli
                    elif command -v dnf >/dev/null 2>&1; then
                        sudo dnf remove -y speedtest-cli
                    else
                        echo -e "${RED}未检测到支持的包管理器。请手动卸载。${NC}"
                    fi
                fi
                read -p "按任意键继续..."
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

# BBR 管理菜单
function bbr_menu() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}            BBR 管理菜单${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC} BBR 综合测速"
        echo -e " ${GREEN}2.${NC} 安装/切换 BBR 内核"
        echo -e " ${GREEN}3.${NC} 查看系统 BBR 信息"
        echo -e " ${GREEN}4.${NC} speedtest-cli 测速依赖 (安装/卸载)"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC} 返回主菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择(0-4): " bbr_choice

        case "$bbr_choice" in
            1)
                bbr_speed_test
                ;;
            2)
                install_switch_bbr_kernel
                ;;
            3)
                view_bbr_system_info
                ;;
            4)
                manage_speedtest_cli
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
