#!/bin/bash

# 应用中心模块

# 应用中心菜单
function app_center_menu() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             应用中心菜单${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  1Panel新一代管理面板"
        echo -e " ${GREEN}2.${NC}  哪吒探针VPS监控面板"
        echo -e " ${GREEN}3.${NC}  TCP窗口调优"
        echo -e " ${GREEN}4.${NC}  磁盘空间分析"
        echo -e " ${GREEN}5.${NC}  BTOP系统监控工具"
        echo -e " ${GREEN}6.${NC}  一键更换软件源"
        echo -e " ${GREEN}7.${NC}  Komari管理"
        echo -e " ${GREEN}8.${NC}  PanSou网盘管理"
        echo -e " ${GREEN}9.${NC}  Watchtower容器自动更新"
        echo -e " ${GREEN}10.${NC} AdGuard Home安装（vps）"
        echo -e " ${GREEN}11.${NC} Nginx Proxy Manager管理"
        echo -e " ${GREEN}12.${NC} GitHub加速站"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回主菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-12): " app_choice

        case "$app_choice" in
            1) one_panel_management ;;
            2) nezha_probe_management ;;
            3) tcp_window_tuning ;;
            4) analyze_disk_space ;;
            5) btop_management ;;
            6) change_software_source ;;
            7) komari_management ;;
            8) pansou_management ;;
            9) watchtower_management ;;
            10) adguard_home_management ;;
            11) nginx_proxy_manager_management ;;
            12) github_proxy_management ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 2 ;;
        esac
    done
}

# 1Panel 管理菜单
function one_panel_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          1Panel新一代管理面板${NC}"
        if command -v 1pctl &> /dev/null; then
            echo -e "          状态: ${GREEN}已安装${NC}"
        else
            echo -e "          状态: ${RED}未安装${NC}"
        fi
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  安装/更新 1Panel"
        echo -e " ${GREEN}2.${NC}  启动 1Panel"
        echo -e " ${GREEN}3.${NC}  停止 1Panel"
        echo -e " ${GREEN}4.${NC}  重启 1Panel"
        echo -e " ${GREEN}5.${NC}  卸载 1Panel"
        echo -e " ${GREEN}6.${NC}  查看 1Panel 信息"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-6): " choice

        case $choice in
            1) install_update_one_panel ;;
            2) start_one_panel ;;
            3) stop_one_panel ;;
            4) restart_one_panel ;;
            5) uninstall_one_panel ;;
            6) view_one_panel_info ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入。${NC}" ;;
        esac
        read -p "按回车键继续..."
    done
}

function install_update_one_panel() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          安装/更新 1Panel${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if command -v 1pctl &> /dev/null; then
        echo "检测到 1Panel 已安装。"
        read -p "是否更新 1Panel？(y/N): " confirm_update
        if [[ "$confirm_update" =~ ^[yY]$ ]]; then
            echo -e "${BLUE}正在更新 1Panel...${NC}"
            1pctl update system
            echo -e "${GREEN}1Panel 更新完成。${NC}"
        else
            echo "取消更新。"
        fi
    else
        echo -e "${BLUE}正在安装 1Panel...${NC}"
        curl -sSL https://resource.1panel.pro/quick_start.sh -o quick_start.sh && bash quick_start.sh
        echo -e "${GREEN}1Panel 安装完成。${NC}"
    fi
}

function start_one_panel() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          启动 1Panel${NC}"
    echo -e "${CYAN}=========================================${NC}"
    if command -v 1pctl &> /dev/null; then
        echo -e "${BLUE}正在启动 1Panel 服务...${NC}"
        1pctl start
        echo -e "${GREEN}1Panel 启动命令已执行。请使用 '查看 1Panel 信息' 确认状态。${NC}"
    else
        echo -e "${RED}未检测到 1Panel 安装。请先安装 1Panel。${NC}"
    fi
}

function stop_one_panel() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          停止 1Panel${NC}"
    echo -e "${CYAN}=========================================${NC}"
    if command -v 1pctl &> /dev/null; then
        echo -e "${BLUE}正在停止 1Panel 服务...${NC}"
        1pctl stop
        echo -e "${GREEN}1Panel 停止命令已执行。请使用 '查看 1Panel 信息' 确认状态。${NC}"
    else
        echo -e "${RED}未检测到 1Panel 安装。${NC}"
    fi
}

function restart_one_panel() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          重启 1Panel${NC}"
    echo -e "${CYAN}=========================================${NC}"
    if command -v 1pctl &> /dev/null; then
        echo -e "${BLUE}正在重启 1Panel 服务...${NC}"
        1pctl restart
        echo -e "${GREEN}1Panel 重启命令已执行。请使用 '查看 1Panel 信息' 确认状态。${NC}"
    else
        echo -e "${RED}未检测到 1Panel 安装。${NC}"
    fi
}

function uninstall_one_panel() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          卸载 1Panel${NC}"
    echo -e "${CYAN}=========================================${NC}"
    if command -v 1pctl &> /dev/null; then
        read -p "确定要卸载 1Panel 吗？(y/N): " confirm_uninstall
        if [[ "$confirm_uninstall" =~ ^[yY]$ ]]; then
            echo -e "${BLUE}正在卸载 1Panel...${NC}"
            1pctl uninstall
            echo -e "${GREEN}1Panel 卸载完成。${NC}"
        else
            echo "取消卸载。"
        fi
    else
        echo -e "${RED}未检测到 1Panel 安装。${NC}"
    fi
}

function view_one_panel_info() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          查看 1Panel 信息${NC}"
    echo -e "${CYAN}=========================================${NC}"
    if command -v 1pctl &> /dev/null; then
        echo -e "${BLUE}1Panel 服务状态:${NC}"
        1pctl status
        echo -e "\n${BLUE}1Panel 用户信息:${NC}"
        1pctl user-info
    else
        echo -e "${RED}未检测到 1Panel 安装。${NC}"
    fi
}

# 哪吒探针管理菜单
function nezha_probe_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          哪吒探针VPS监控面板${NC}"
        if systemctl list-units --type=service --all | grep -q "nezha-agent"; then
            echo -e "          状态: ${GREEN}已安装${NC}"
        else
            echo -e "          状态: ${RED}未安装${NC}"
        fi
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  安装/更新哪吒探针 Agent"
        echo -e " ${GREEN}2.${NC}  卸载哪吒探针 Agent"
        echo -e " ${GREEN}3.${NC}  启动哪吒探针 Agent"
        echo -e " ${GREEN}4.${NC}  停止哪吒探针 Agent"
        echo -e " ${GREEN}5.${NC}  重启哪吒探针 Agent"
        echo -e " ${GREEN}6.${NC}  查看哪吒探针 Agent 状态"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择: " nezha_choice

        case "$nezha_choice" in
            1) install_update_nezha_agent ;;
            2) uninstall_nezha_agent ;;
            3) start_nezha_agent ;;
            4) stop_nezha_agent ;;
            5) restart_nezha_agent ;;
            6) view_nezha_agent_status ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; read -p "按回车键继续..." ;;
        esac
    done
}

# 哪吒探针功能实现
function install_update_nezha_agent() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        安装/更新哪吒探针 Agent${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if systemctl list-units --type=service --all | grep -q "nezha-agent"; then
        echo -e "检测到哪吒探针 Agent 服务已存在。"
        read -p "是否要更新哪吒探针 Agent？(y/N): " update_choice
        if [[ "$update_choice" =~ ^[yY]$ ]]; then
            echo -e "${BLUE}开始执行哪吒探针 Agent 安装/更新脚本...${NC}"
            curl -L https://raw.githubusercontent.com/nezhahq/scripts/refs/heads/main/install.sh -o nezha.sh && chmod +x nezha.sh && ./nezha.sh
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}哪吒探针 Agent 安装/更新脚本执行成功。${NC}"
            else
                echo -e "${RED}哪吒探针 Agent 安装/更新脚本执行失败。${NC}"
            fi
            rm -f nezha.sh # Clean up
        else
            echo "取消更新。"
        fi
    else
        echo -e "${BLUE}开始执行哪吒探针 Agent 安装/更新脚本...${NC}"
        curl -L https://raw.githubusercontent.com/nezhahq/scripts/refs/heads/main/install.sh -o nezha.sh && chmod +x nezha.sh && ./nezha.sh
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}哪吒探针 Agent 安装/更新脚本执行成功。${NC}"
        else
            echo -e "${RED}哪吒探针 Agent 安装/更新脚本执行失败。${NC}"
        fi
        rm -f nezha.sh # Clean up
    fi
    read -p "按回车键继续..."
}

# GitHub 加速站管理
function github_proxy_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             GitHub 加速站管理${NC}"
        
        if docker ps -a --format '{{.Names}}' | grep -q "^github-proxy$"; then
            echo -e "          状态: ${GREEN}已安装${NC}"
            # 获取映射端口
            local host_port=$(docker inspect github-proxy --format='{{(index (index .NetworkSettings.Ports "8080/tcp") 0).HostPort}}' 2>/dev/null)
            local public_ipv4=$(curl -4 -s --connect-timeout 5 ifconfig.me || curl -4 -s --connect-timeout 5 http://ipv4.icanhazip.com)
            local public_ipv6=$(curl -6 -s --connect-timeout 5 ifconfig.me || curl -6 -s --connect-timeout 5 http://ipv6.icanhazip.com)
            local local_ip=$(hostname -I | awk '{print $1}')
            
            echo -e "${CYAN}-----------------------------------------${NC}"
            [ -n "$public_ipv4" ] && echo -e "公网 IPv4 访问: ${YELLOW}http://${public_ipv4}:${host_port}${NC}"
            [ -n "$local_ip" ] && echo -e "内网 IP 访问:   ${YELLOW}http://${local_ip}:${host_port}${NC}"
            [ -n "$public_ipv6" ] && echo -e "公网 IPv6 访问: ${YELLOW}http://[${public_ipv6}]:${host_port}${NC}"
        else
            echo -e "          状态: ${RED}未安装${NC}"
        fi
        
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC} 安装 GitHub 加速站"
        echo -e " ${GREEN}2.${NC} 更新 GitHub 加速站"
        echo -e " ${GREEN}3.${NC} 卸载 GitHub 加速站"
        echo -e " ${GREEN}4.${NC} 启动/停止/重启管理"
        echo -e " ${GREEN}5.${NC} 查看容器日志 (排错)"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC} 返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-5): " github_choice

        case "$github_choice" in
            1) install_github_proxy ;;
            2) update_github_proxy ;;
            3) uninstall_github_proxy ;;
            4) manage_github_proxy_container ;;
            5) docker logs --tail 50 github-proxy; read -p "按回车键继续..." ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 1 ;;
        esac
    done
}

function install_github_proxy() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          安装 GitHub 加速站${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if docker ps -a --format '{{.Names}}' | grep -q "^github-proxy$"; then
        echo -e "${YELLOW}检测到 GitHub 加速站已安装。${NC}"
        read -p "是否重新安装？(y/N): " reinstall
        [[ ! "$reinstall" =~ ^[yY]$ ]] && return
        docker stop github-proxy &>/dev/null
        docker rm github-proxy &>/dev/null
    fi

    # 获取宿主机端口
    read -p "请输入宿主机映射端口 (默认 7210): " host_port
    host_port=${host_port:-7210}

    # 验证端口占用
    if command -v ss &> /dev/null; then
        if ss -tuln | grep -q ":${host_port} "; then
            echo -e "${RED}❌ 端口 ${host_port} 已被占用，请选择其他端口。${NC}"
            read -p "按回车键继续..."
            return
        fi
    fi

    echo -e "${BLUE}正在准备数据目录...${NC}"
    mkdir -p /opt/ghproxy/log/run
    mkdir -p /opt/ghproxy/log/caddy
    mkdir -p /opt/ghproxy/config

    echo -e "${BLUE}正在拉取镜像并创建容器...${NC}"
    docker run -d \
        --name="github-proxy" \
        --restart=always \
        -p ${host_port}:8080 \
        -v /opt/ghproxy/log/run:/data/ghproxy/log \
        -v /opt/ghproxy/log/caddy:/data/caddy/log \
        -v /opt/ghproxy/config:/data/ghproxy/config \
        wjqserver/ghproxy

    if [ $? -eq 0 ]; then
        local local_ip=$(hostname -I | awk '{print $1}')
        echo -e "${GREEN}GitHub 加速站安装成功！${NC}"
        echo -e "访问地址 (内网): ${YELLOW}http://${local_ip}:${host_port}${NC}"
    else
        echo -e "${RED}安装失败，请检查 Docker 日志。${NC}"
    fi
    read -p "按回车键继续..."
}

function update_github_proxy() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          更新 GitHub 加速站${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! docker ps -a --format '{{.Names}}' | grep -q "^github-proxy$"; then
        echo -e "${RED}未检测到 GitHub 加速站，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    # 获取当前映射端口
    local old_port=$(docker inspect github-proxy --format='{{(index (index .NetworkSettings.Ports "8080/tcp") 0).HostPort}}' 2>/dev/null)
    
    echo -e "${BLUE}正在拉取最新镜像...${NC}"
    docker pull wjqserver/ghproxy
    
    echo -e "${BLUE}正在重启容器...${NC}"
    docker stop github-proxy &>/dev/null
    docker rm github-proxy &>/dev/null
    
    docker run -d \
        --name="github-proxy" \
        --restart=always \
        -p ${old_port}:8080 \
        -v /opt/ghproxy/log/run:/data/ghproxy/log \
        -v /opt/ghproxy/log/caddy:/data/caddy/log \
        -v /opt/ghproxy/config:/data/ghproxy/config \
        wjqserver/ghproxy

    echo -e "${GREEN}更新完成！${NC}"
    read -p "按回车键继续..."
}

function uninstall_github_proxy() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}          卸载 GitHub 加速站${NC}"
    echo -e "${CYAN}=========================================${NC}"

    read -p "确定要卸载 GitHub 加速站吗？(y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        docker stop github-proxy &>/dev/null
        docker rm github-proxy &>/dev/null
        echo -e "${GREEN}卸载完成。${NC}"
    else
        echo "操作已取消。"
    fi
    read -p "按回车键继续..."
}

function manage_github_proxy_container() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}         GitHub 加速站生命周期管理${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! docker ps -a --format '{{.Names}}' | grep -q "^github-proxy$"; then
        echo -e "${RED}未检测到容器，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e " 1. 启动"
    echo -e " 2. 停止"
    echo -e " 3. 重启"
    echo -e " 0. 返回"
    read -p "请选择: " op
    case $op in
        1) docker start github-proxy ;;
        2) docker stop github-proxy ;;
        3) docker restart github-proxy ;;
    esac
}


function uninstall_nezha_agent() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        卸载哪吒探针 Agent${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if systemctl list-units --type=service --all | grep -q "nezha-agent"; then
        read -p "确定要卸载哪吒探针 Agent 吗？(y/N): " confirm_uninstall
        if [[ "$confirm_uninstall" =~ ^[yY]$ ]]; then
            echo -e "${BLUE}开始卸载哪吒探针 Agent...${NC}"
            curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o /tmp/nezha.sh && chmod +x /tmp/nezha.sh
            if [ $? -eq 0 ]; then
                /tmp/nezha.sh uninstall_agent
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}哪吒探针 Agent 卸载成功。${NC}"
                else
                    echo -e "${RED}哪吒探针 Agent 卸载失败。${NC}"
                fi
                rm /tmp/nezha.sh
            else
                echo -e "${RED}下载卸载脚本失败，请检查网络连接。${NC}"
            fi
        else
            echo "取消卸载。"
        fi
    else
        echo -e "${YELLOW}未检测到哪吒探针 Agent 服务，无需卸载。${NC}"
    fi
    read -p "按回车键继续..."
}

function start_nezha_agent() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        启动哪吒探针 Agent${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if systemctl list-units --type=service --all | grep -q "nezha-agent"; then
        echo -e "${BLUE}尝试启动哪吒探针 Agent...${NC}"
        systemctl start nezha-agent
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}哪吒探针 Agent 启动成功。${NC}"
        else
            echo -e "${RED}哪吒探针 Agent 启动失败，请检查服务状态。${NC}"
        fi
    else
        echo -e "${RED}未检测到哪吒探针 Agent 服务，请先安装。${NC}"
    fi
    read -p "按回车键继续..."
}

function stop_nezha_agent() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        停止哪吒探针 Agent${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if systemctl list-units --type=service --all | grep -q "nezha-agent"; then
        echo -e "${BLUE}尝试停止哪吒探针 Agent...${NC}"
        systemctl stop nezha-agent
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}哪吒探针 Agent 停止成功。${NC}"
        else
            echo -e "${RED}哪吒探针 Agent 停止失败，请检查服务状态。${NC}"
        fi
    else
        echo -e "${YELLOW}未检测到哪吒探针 Agent 服务，无需停止。${NC}"
    fi
    read -p "按回车键继续..."
}

function restart_nezha_agent() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        重启哪吒探针 Agent${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if systemctl list-units --type=service --all | grep -q "nezha-agent"; then
        echo -e "${BLUE}尝试重启哪吒探针 Agent...${NC}"
        systemctl restart nezha-agent
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}哪吒探针 Agent 重启成功。${NC}"
        else
            echo -e "${RED}哪吒探针 Agent 重启失败，请检查服务状态。${NC}"
        fi
    else
        echo -e "${RED}未检测到哪吒探针 Agent 服务，无法重启。${NC}"
    fi
    read -p "按回车键继续..."
}

function view_nezha_agent_status() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        查看哪吒探针 Agent 状态${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if systemctl list-units --type=service --all | grep -q "nezha-agent"; then
        echo -e "${BLUE}哪吒探针 Agent 服务状态:${NC}"
        systemctl status nezha-agent
    else
        echo -e "${RED}未检测到哪吒探针 Agent 服务。${NC}"
    fi
    read -p "按回车键继续..."
}

# TCP 窗口调优功能实现
function tcp_window_tuning() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             TCP 窗口调优${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  应用最佳调优配置 (针对高带宽延迟)"
        echo -e " ${GREEN}2.${NC}  查看当前 TCP 参数状态"
        echo -e " ${GREEN}3.${NC}  恢复系统默认配置 (备份还原)"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-3): " tcp_choice

        case "$tcp_choice" in
            1) apply_tcp_tuning ;;
            2) view_tcp_status ;;
            3) restore_tcp_defaults ;;
            0) break ;;
            *) echo -e "${RED}无效的选择！${NC}"; sleep 2 ;;
        esac
    done
}

function apply_tcp_tuning() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          应用 TCP 最佳调优配置${NC}"
    echo -e "${CYAN}=========================================${NC}"

    # 备份原配置
    if [ ! -f /etc/sysctl.conf.bak ]; then
        cp /etc/sysctl.conf /etc/sysctl.conf.bak
        echo -e "${BLUE}已创建系统配置备份: /etc/sysctl.conf.bak${NC}"
    fi

    echo -e "${BLUE}正在优化 TCP 窗口参数...${NC}"

    # 定义优化参数
    cat << EOF > /etc/sysctl.d/99-vpsx-tcp-tuning.conf
# TCP Window Tuning by VPSX
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_no_metrics_save = 1
net.core.netdev_max_backlog = 5000
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_fastopen = 3
EOF

    sysctl -p /etc/sysctl.d/99-vpsx-tcp-tuning.conf &> /dev/null
    sysctl --system &> /dev/null

    echo -e "${GREEN}TCP 优化配置已应用！${NC}"
    echo -e "${YELLOW}优化内容包括：rmem/wmem 扩大、窗口缩放开启、SACK 开启等。${NC}"
    read -p "按回车键继续..."
}

function view_tcp_status() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          当前 TCP 关键参数状态${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    echo -e "${BLUE}核心接收/发送窗口限制:${NC}"
    sysctl net.core.rmem_max net.core.wmem_max
    
    echo -e "\n${BLUE}TCP 读写缓冲区配置:${NC}"
    sysctl net.ipv4.tcp_rmem net.ipv4.tcp_wmem
    
    echo -e "\n${BLUE}其他关键特性:${NC}"
    sysctl net.ipv4.tcp_window_scaling net.ipv4.tcp_sack net.ipv4.tcp_fastopen
    
    echo -e "${CYAN}=========================================${NC}"
    read -p "按回车键继续..."
}

function restore_tcp_defaults() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          恢复 TCP 默认配置${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ -f /etc/sysctl.d/99-vpsx-tcp-tuning.conf ]; then
        rm -f /etc/sysctl.d/99-vpsx-tcp-tuning.conf
        sysctl --system &> /dev/null
        echo -e "${GREEN}已移除 VPSX 优化配置文件。${NC}"
    else
        echo -e "${YELLOW}未发现优化配置文件，系统可能处于默认状态。${NC}"
    fi

    if [ -f /etc/sysctl.conf.bak ]; then
        read -p "是否还原 /etc/sysctl.conf 备份？(y/N): " restore_bak
        if [[ "$restore_bak" =~ ^[yY]$ ]]; then
            cp /etc/sysctl.conf.bak /etc/sysctl.conf
            sysctl -p &> /dev/null
            echo -e "${GREEN}系统主配置文件已还原。${NC}"
        fi
    fi
    
    echo -e "${GREEN}TCP 参数已尝试恢复至默认。${NC}"
    read -p "按回车键继续..."
}

# 磁盘空间分析
function analyze_disk_space() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            磁盘空间分析${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${BLUE}正在分析磁盘空间使用情况...${NC}"
    echo ""
    df -h
    echo ""
    echo -e "${CYAN}=========================================${NC}"
    read -p "按回车键返回应用中心菜单..."
}

# BTOP 监控管理
function btop_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             BTOP 系统监控${NC}"
        if command -v btop &> /dev/null; then
            echo -e "          当前状态: ${GREEN}已安装${NC}"
        else
            echo -e "          当前状态: ${RED}未安装${NC}"
        fi
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${GREEN}1.${NC}  启动 btop 监控"
        echo -e " ${GREEN}2.${NC}  安装/更新 btop"
        echo -e " ${GREEN}3.${NC}  卸载 btop"
        echo -e " ${GREEN}4.${NC}  btop 配置说明"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回应用中心菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-4): " btop_choice

        case "$btop_choice" in
            1)
                if command -v btop &> /dev/null; then
                    btop
                else
                    echo -e "${RED}未检测到 btop，请先安装！${NC}"
                    sleep 2
                fi
                ;;
            2) install_update_btop ;;
            3) uninstall_btop ;;
            4) btop_help_info ;;
            0) break ;;
            *) echo -e "${RED}无效的选择！${NC}"; sleep 2 ;;
        esac
    done
}

function install_update_btop() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          安装/更新 BTOP${NC}"
    echo -e "${CYAN}=========================================${NC}"

    # 检查架构
    local arch=$(uname -m)
    local download_url=""

    case "$arch" in
        x86_64) download_url="https://github.com/aristocratos/btop/releases/latest/download/btop-x86_64-linux-musl.tbz" ;;
        aarch64) download_url="https://github.com/aristocratos/btop/releases/latest/download/btop-aarch64-linux-musl.tbz" ;;
        *)
            echo -e "${RED}不支持的架构: $arch${NC}"
            read -p "按回车键继续..."
            return
            ;;
    esac

    echo -e "${BLUE}正在从 GitHub 下载最新版 BTOP ($arch)...${NC}"
    
    # 创建临时目录
    local tmp_dir=$(mktemp -d)
    cd "$tmp_dir"

    if curl -L "$download_url" -o btop.tbz; then
        echo -e "${BLUE}正在解压并安装...${NC}"
        tar -xjf btop.tbz
        
        # BTOP 官方包解压后通常包含 install.sh 或直接是 binary
        if [ -f "install.sh" ]; then
            bash install.sh
        else
            # 手动安装逻辑
            mkdir -p /usr/local/bin
            cp ./bin/btop /usr/local/bin/btop
            chmod +x /usr/local/bin/btop
        fi

        if command -v btop &> /dev/null; then
            echo -e "${GREEN}BTOP 安装/更新成功！${NC}"
        else
            echo -e "${RED}安装失败，请检查系统权限或依赖。${NC}"
        fi
    else
        echo -e "${RED}下载失败，请检查网络连接。${NC}"
    fi

    # 清理
    rm -rf "$tmp_dir"
    cd - &> /dev/null
    read -p "按回车键继续..."
}

function uninstall_btop() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          卸载 BTOP${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! command -v btop &> /dev/null; then
        echo -e "${YELLOW}未发现 BTOP，无需卸载。${NC}"
        read -p "按回车键继续..."
        return
    fi

    read -p "确定要卸载 BTOP 吗？(y/N): " confirm_uninstall
    if [[ "$confirm_uninstall" =~ ^[yY]$ ]]; then
        echo -e "${BLUE}正在移除 BTOP 程序文件...${NC}"
        
        # 尝试使用官方卸载方式或手动移除
        if [ -f "/usr/local/bin/btop" ]; then
            rm -f /usr/local/bin/btop
            # 同时也尝试移除可能存在的配置目录
            rm -rf ~/.config/btop
            echo -e "${GREEN}BTOP 已成功卸载。${NC}"
        else
            # 如果是通过包管理器安装的
            if command -v apt &> /dev/null; then
                apt remove -y btop
            elif command -v yum &> /dev/null; then
                yum remove -y btop
            fi
            echo -e "${GREEN}卸载命令已执行。${NC}"
        fi
    else
        echo "取消卸载。"
    fi
    read -p "按回车键继续..."
}

function btop_help_info() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          BTOP 配置说明${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${YELLOW}BTOP 是一个现代化的系统资源监视器。${NC}"
    echo -e "1. 按 ${GREEN}m${NC} 切换统计视图。"
    echo -e "2. 按 ${GREEN}f${NC} 搜索进程。"
    echo -e "3. 按 ${GREEN}q${NC} 或 ${GREEN}Esc${NC} 退出监控。"
    echo -e "4. 支持鼠标操作和自定义配色。"
    echo -e "${CYAN}=========================================${NC}"
    read -p "按回车键继续..."
}

# 一键更换软件源
function change_software_source() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          一键更换软件源${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${BLUE}正在执行软件源更换脚本...${NC}"
    echo -e "此功能将帮助您快速更换系统软件源，提升软件下载速度"
    echo ""

    # 显示当前系统信息
    echo -e "${YELLOW}当前系统信息:${NC}"
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        echo "操作系统: $NAME $VERSION"
        echo "系统架构: $(uname -m)"
    else
        echo "操作系统: $(uname -s)"
        echo "系统架构: $(uname -m)"
    fi
    echo ""

    # 显示当前软件源信息
    if [ -f /etc/apt/sources.list ]; then
        echo -e "当前 APT 源数量: ${GREEN}$(grep -c "^deb " /etc/apt/sources.list 2>/dev/null || echo 0)${NC}"
    fi

    echo ""
    echo -e "${RED}⚠️  注意：${NC}更换软件源可能需要重启系统或重新登录才能生效"
    echo -e "${BLUE}📢  脚本来源:${NC} https://linuxmirrors.cn"
    echo ""

    read -p "是否继续执行软件源更换？(y/N): " confirm_change
    if [[ "$confirm_change" =~ ^[yY]$ ]]; then
        echo ""
        echo -e "${YELLOW}正在下载并执行软件源更换脚本...${NC}"
        echo -e "${CYAN}-----------------------------------------${NC}"

        # 执行软件源更换脚本
        bash <(curl -sSL https://linuxmirrors.cn/main.sh)

        if [ $? -eq 0 ]; then
            echo ""
            echo -e "${GREEN}✅ 软件源更换脚本执行完成！${NC}"
            echo -e "${YELLOW}建议执行以下命令使更改生效：${NC}"
            if command -v apt >/dev/null 2>&1; then
                echo -e "   ${CYAN}apt update${NC}"
            elif command -v yum >/dev/null 2>&1; then
                echo -e "   ${CYAN}yum makecache${NC}"
            elif command -v dnf >/dev/null 2>&1; then
                echo -e "   ${CYAN}dnf makecache${NC}"
            fi
        else
            echo ""
            echo -e "${RED}❌ 软件源更换脚本执行过程中出现错误。${NC}"
            echo "请检查网络连接或手动更换软件源。"
        fi
    else
        echo "已取消软件源更换操作。"
    fi

    echo ""
    read -p "按任意键返回应用中心菜单..."
}

# Komari 监控面板管理
function komari_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}         Komari 监控面板管理${NC}"
        if docker ps -a --format '{{.Names}}' | grep -q "^komari$"; then
            echo -e "          状态: ${GREEN}已部署${NC}"
        else
            echo -e "          状态: ${RED}未部署${NC}"
        fi
        echo -e "${CYAN}=========================================${NC}"
        echo -e "Komari 是一个现代化的服务器监控面板"
        echo -e "基于 Docker 容器部署，提供 Web 界面"
        echo ""
        echo -e "${YELLOW}当前配置信息：${NC}"
        echo -e "• Docker 镜像: ${BLUE}ghcr.io/komari-monitor/komari:latest${NC}"
        echo -e "• 容器端口: ${BLUE}8083${NC}"
        echo -e "• 数据目录: ${BLUE}/home/docker/komari${NC}"
        echo -e "• 默认账号: ${BLUE}admin / Z7aiE5jN8co7${NC} (建议首次登录后修改)"
        echo ""
        echo -e " ${GREEN}1.${NC} 安装 Docker 环境 (如未安装)"
        echo -e " ${GREEN}2.${NC} 部署 Komari 监控面板"
        echo -e " ${GREEN}3.${NC} 启动/停止/重启 Komari 容器"
        echo -e " ${GREEN}4.${NC} 查看 Komari 状态和日志"
        echo -e " ${GREEN}5.${NC} 修改 Komari 配置 (JSON 格式)"
        echo -e " ${GREEN}6.${NC} 卸载 Komari 监控面板"
        echo -e " ${GREEN}7.${NC} 访问 Komari Web 界面"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC} 返回应用中心菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择: " komari_choice

        case "$komari_choice" in
            1) install_docker_environment ;;
            2) deploy_komari_panel ;;
            3) manage_komari_container ;;
            4) view_komari_status_logs ;;
            5) modify_komari_config ;;
            6) uninstall_komari_panel ;;
            7) access_komari_web ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 2 ;;
        esac
    done
}

function install_docker_environment() {
    # 调用 modules/docker.sh 中的安装函数
    if command -v install_update_docker_env &> /dev/null; then
        install_update_docker_env
    else
        echo -e "${RED}错误: 找不到 Docker 安装模块。${NC}"
        read -p "按回车键继续..."
    fi
}

function deploy_komari_panel() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          部署 Komari 监控面板${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! command -v docker &> /dev/null; then
        echo -e "${RED}未检测到 Docker，请先执行选项 1 安装 Docker 环境。${NC}"
        read -p "按回车键继续..."
        return
    fi

    if docker ps -a --format '{{.Names}}' | grep -q "^komari$"; then
        echo -e "${YELLOW}检测到 Komari 容器已存在。${NC}"
        read -p "是否重新部署？(这可能导致数据丢失) (y/N): " redeploy_choice
        if [[ ! "$redeploy_choice" =~ ^[yY]$ ]]; then
            return
        fi
        echo -e "${BLUE}正在停止并移除旧容器...${NC}"
        docker stop komari &> /dev/null
        docker rm komari &> /dev/null
    fi

    echo -e "${BLUE}正在拉取最新镜像 ghcr.io/komari-monitor/komari:latest...${NC}"
    docker pull ghcr.io/komari-monitor/komari:latest

    # 获取宿主机端口
    read -p "请输入宿主机映射端口 (默认 8083): " host_port
    host_port=${host_port:-8083}

    # 验证端口占用
    if command -v netstat &> /dev/null; then
        if netstat -tuln | grep -q ":${host_port} "; then
            echo -e "${RED}❌ 端口 ${host_port} 已被占用，请选择其他端口。${NC}"
            read -p "按回车键继续..."
            return
        fi
    elif command -v ss &> /dev/null; then
        if ss -tuln | grep -q ":${host_port} "; then
            echo -e "${RED}❌ 端口 ${host_port} 已被占用，请选择其他端口。${NC}"
            read -p "按回车键继续..."
            return
        fi
    fi

    echo -e "${BLUE}正在创建并运行 Komari 容器 (端口: ${host_port})...${NC}"
    mkdir -p /home/docker/komari
    
    docker run -d \
        --name komari \
        --restart always \
        -p ${host_port}:25774 \
        -v /home/docker/komari:/app/data \
        ghcr.io/komari-monitor/komari:latest

    if [ $? -eq 0 ]; then
        local public_ipv4=$(curl -4 -s --connect-timeout 5 ifconfig.me || curl -4 -s --connect-timeout 5 http://ipv4.icanhazip.com)
        local public_ipv6=$(curl -6 -s --connect-timeout 5 ifconfig.me || curl -6 -s --connect-timeout 5 http://ipv6.icanhazip.com)
        
        echo -e "${GREEN}Komari 监控面板部署成功！${NC}"
        [ -n "$public_ipv4" ] && echo -e "IPv4 访问地址: ${CYAN}http://${public_ipv4}:${host_port}${NC}"
        [ -n "$public_ipv6" ] && echo -e "IPv6 访问地址: ${CYAN}http://[${public_ipv6}]:${host_port}${NC}"
        
        # 尝试从日志中获取默认密码
        sleep 2 # 等待容器启动并生成密码
        local log_pwd=$(docker logs komari 2>&1 | grep "Password:" | awk -F 'Password: ' '{print $2}' | awk '{print $1}')
        echo -e "默认账号: ${GREEN}admin${NC}"
        if [ -n "$log_pwd" ]; then
            echo -e "默认密码: ${GREEN}${log_pwd}${NC}"
        else
            echo -e "默认密码: ${YELLOW}请运行 'docker logs komari' 查看日志中的初始密码${NC}"
        fi
    else
        echo -e "${RED}Komari 部署失败，请检查 Docker 日志。${NC}"
    fi
    read -p "按回车键继续..."
}

function manage_komari_container() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}         Komari 容器生命周期管理${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! docker ps -a --format '{{.Names}}' | grep -q "^komari$"; then
        echo -e "${RED}未检测到 Komari 容器，请先部署。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e " ${GREEN}1.${NC} 启动 Komari"
    echo -e " ${GREEN}2.${NC} 停止 Komari"
    echo -e " ${GREEN}3.${NC} 重启 Komari"
    echo -e " ${RED}0.${NC} 返回"
    read -p "请选择: " manage_choice

    case "$manage_choice" in
        1)
            docker start komari
            echo -e "${GREEN}启动指令已发送。${NC}"
            ;;
        2)
            docker stop komari
            echo -e "${GREEN}停止指令已发送。${NC}"
            ;;
        3)
            docker restart komari
            echo -e "${GREEN}重启指令已发送。${NC}"
            ;;
        0) return ;;
        *) echo -e "${RED}无效选择。${NC}" ;;
    esac
    read -p "按回车键继续..."
}

function view_komari_status_logs() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}         Komari 状态和日志${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! docker ps -a --format '{{.Names}}' | grep -q "^komari$"; then
        echo -e "${RED}未检测到 Komari 容器。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}容器状态:${NC}"
    docker ps -f "name=komari" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    echo -e "\n${BLUE}最近 20 行日志:${NC}"
    docker logs --tail 20 komari
    
    echo -e "${CYAN}=========================================${NC}"
    read -p "按回车键继续..."
}

function modify_komari_config() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          修改 Komari 配置${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    local config_file="/home/docker/komari/config.json"
    
    if [ ! -f "$config_file" ]; then
        echo -e "${YELLOW}未发现配置文件 $config_file${NC}"
        echo -e "请确保 Komari 已经部署并运行过一次。"
        read -p "按回车键继续..."
        return
    fi

    echo -e "当前配置文件内容:"
    cat "$config_file"
    echo -e "\n${YELLOW}注意: 修改配置可能需要重启容器生效。${NC}"
    echo -e "1. 使用 vi 编辑配置"
    echo -e "2. 备份当前配置"
    echo -e "0. 返回"
    read -p "请选择: " config_choice

    case "$config_choice" in
        1)
            vi "$config_file"
            echo -e "${YELLOW}是否现在重启容器以应用配置？(y/N)${NC}"
            read -p "> " restart_now
            if [[ "$restart_now" =~ ^[yY]$ ]]; then
                docker restart komari
            fi
            ;;
        2)
            cp "$config_file" "${config_file}.bak_$(date +%Y%m%d_%H%M%S)"
            echo -e "${GREEN}备份已创建。${NC}"
            ;;
        0) return ;;
        *) echo -e "${RED}无效选择。${NC}" ;;
    esac
    read -p "按回车键继续..."
}

function uninstall_komari_panel() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          卸载 Komari 监控面板${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! docker ps -a --format '{{.Names}}' | grep -q "^komari$"; then
        echo -e "${YELLOW}未发现 Komari 容器。${NC}"
        read -p "按回车键继续..."
        return
    fi

    read -p "确定要移除 Komari 容器吗？(y/N): " confirm_rm
    if [[ "$confirm_rm" =~ ^[yY]$ ]]; then
        echo -e "${BLUE}正在停止并移除容器...${NC}"
        docker stop komari &> /dev/null
        docker rm komari &> /dev/null
        
        read -p "是否删除所有数据目录 (/home/docker/komari)？(y/N): " confirm_del_data
        if [[ "$confirm_del_data" =~ ^[yY]$ ]]; then
            rm -rf /home/docker/komari
            echo -e "${GREEN}数据目录已删除。${NC}"
        fi
        echo -e "${GREEN}Komari 容器已移除。${NC}"
    else
        echo "操作已取消。"
    fi
    read -p "按回车键继续..."
}

function access_komari_web() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          访问 Komari Web 界面${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! docker ps -a --format '{{.Names}}' | grep -q "^komari$"; then
        echo -e "${RED}❌ Komari 容器不存在，请先部署。${NC}"
        return
    fi
    
    # 获取映射端口
    local host_port=$(docker inspect komari --format='{{(index (index .NetworkSettings.Ports "25774/tcp") 0).HostPort}}' 2>/dev/null)
    host_port=${host_port:-25774}
    
    local public_ipv4=$(curl -4 -s --connect-timeout 5 ifconfig.me || curl -4 -s --connect-timeout 5 http://ipv4.icanhazip.com)
    local public_ipv6=$(curl -6 -s --connect-timeout 5 ifconfig.me || curl -6 -s --connect-timeout 5 http://ipv6.icanhazip.com)
    
    echo -e "您的 Komari 面板访问地址为："
    [ -n "$public_ipv4" ] && echo -e "IPv4 地址: ${YELLOW}http://${public_ipv4}:${host_port}${NC}"
    [ -n "$public_ipv6" ] && echo -e "IPv6 地址: ${YELLOW}http://[${public_ipv6}]:${host_port}${NC}"
    echo ""
    # 尝试从日志中获取默认密码
    local log_pwd=$(docker logs komari 2>&1 | grep "Password:" | awk -F 'Password: ' '{print $2}' | awk '{print $1}')
    echo -e "默认账号: ${GREEN}admin${NC}"
    if [ -n "$log_pwd" ]; then
        echo -e "默认密码: ${GREEN}${log_pwd}${NC}"
    else
        echo -e "默认密码: ${YELLOW}请运行 'docker logs komari' 查看日志中的初始密码${NC}"
    fi
    echo -e "${CYAN}=========================================${NC}"
    read -p "按回车键返回..."
}

# PanSou 网盘管理
function pansou_management() {
    while true; do
        clear
        echo -e "${CYAN}"
        echo "=========================================="
        echo "          PanSou 网盘管理菜单"
        echo "=========================================="
        echo -e "${NC}"
        
        # 检查Docker是否运行
        if ! docker info > /dev/null 2>&1; then
            echo -e "${RED}⚠️  Docker 服务未运行或未安装！${NC}"
            echo "请先确保Docker已安装并启动。"
            echo ""
        fi
        
        # 显示当前状态
        if docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -q "pansou"; then
            echo -e "${GREEN}✅ PanSou 容器状态：${NC}"
            docker ps -a --filter "name=pansou" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        else
            echo -e "${YELLOW}📭 PanSou 网盘未安装。${NC}"
        fi
        
        echo ""
        echo "1.  安装 PanSou 网盘 (Docker Run)"
        echo "2.  安装 PanSou 网盘 (Docker Compose - 推荐)"
        echo "3.  启动 PanSou 网盘"
        echo "4.  停止 PanSou 网盘"
        echo "5.  重启 PanSou 网盘"
        echo "6.  修改访问端口"
        echo "7.  查看实时日志"
        echo "8.  查看容器状态"
        echo "9.  卸载 PanSou 网盘"
        echo "10. 查询访问 Web 界面"
        echo "0.  返回上一级菜单"
        echo ""
        echo "=========================================="
        read -p "请输入你的选择 [0-10]: " choice
        
        case $choice in
            1) install_pansou_docker_run ;;
            2) install_pansou_docker_compose ;;
            3) start_pansou ;;
            4) stop_pansou ;;
            5) restart_pansou ;;
            6) change_pansou_port ;;
            7) view_pansou_logs ;;
            8) view_pansou_status ;;
            9) uninstall_pansou ;;
            10) access_pansou_web ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 1 ;;
        esac
        
        echo ""
        read -p "按 Enter 键继续..."
    done
}

# PanSou 占位子功能
function install_pansou_docker_run() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}       安装 PanSou (Docker Run)${NC}"
    echo -e "${CYAN}==========================================${NC}"
    
    # 检查容器是否已存在
    if docker ps -a --format '{{.Names}}' | grep -q "^pansou$"; then
        echo -e "${YELLOW}⚠️  PanSou 容器已存在。${NC}"
        read -p "是否删除现有容器并重新安装？(y/N): " reinstall
        if [[ ! "$reinstall" =~ ^[yY]$ ]]; then
            return
        fi
        docker stop pansou >/dev/null 2>&1
        docker rm pansou >/dev/null 2>&1
    fi
    
    # 获取端口设置
    read -p "请输入宿主机映射端口 (默认 80): " host_port
    host_port=${host_port:-80}
    
    # 验证端口是否被占用
    if netstat -tuln | grep -q ":${host_port} "; then
        echo -e "${RED}❌ 端口 ${host_port} 已被占用，请选择其他端口。${NC}"
        return
    fi
    
    echo "正在拉取镜像并启动容器..."
    if docker run -d --name pansou -p ${host_port}:80 ghcr.io/fish2018/pansou-web; then
        local public_ipv4=$(curl -4 -s --connect-timeout 5 ifconfig.me || curl -4 -s --connect-timeout 5 http://ipv4.icanhazip.com)
        local public_ipv6=$(curl -6 -s --connect-timeout 5 ifconfig.me || curl -6 -s --connect-timeout 5 http://ipv6.icanhazip.com)
        
        echo -e "${GREEN}✅ PanSou 安装成功！${NC}"
        [ -n "$public_ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${public_ipv4}:${host_port}${NC}"
        [ -n "$public_ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${public_ipv6}]:${host_port}${NC}"
    else
        echo -e "${RED}❌ 安装失败，请检查错误信息。${NC}"
    fi
}
function install_pansou_docker_compose() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}   安装 PanSou (Docker Compose)${NC}"
    echo -e "${CYAN}==========================================${NC}"
    
    # 检查是否已安装 Docker Compose
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        echo -e "${YELLOW}Docker Compose 未安装，尝试安装...${NC}"
        if command -v apt &> /dev/null; then
            apt update && apt install -y docker-compose
        elif command -v yum &> /dev/null; then
            yum install -y docker-compose
        else
            echo -e "${RED}无法自动安装 Docker Compose，请手动安装。${NC}"
            return
        fi
    fi
    
    # 兼容 docker compose (v2) 和 docker-compose (v1)
    local compose_cmd="docker-compose"
    if docker compose version &> /dev/null; then
        compose_cmd="docker compose"
    fi
    
    # 创建专用目录
    local pansou_dir="/opt/pansou"
    if [ ! -d "$pansou_dir" ]; then
        mkdir -p "$pansou_dir"
    fi
    cd "$pansou_dir"
    
    # 获取端口设置
    read -p "请输入宿主机映射端口 (默认 80): " host_port
    host_port=${host_port:-80}
    
    # 验证端口
    if netstat -tuln | grep -q ":${host_port} "; then
        echo -e "${RED}❌ 端口 ${host_port} 已被占用。${NC}"
        cd - > /dev/null
        return
    fi
    
    # 创建 docker-compose.yml
    cat > docker-compose.yml << EOF
version: '3.8'
services:
  pansou:
    image: ghcr.io/fish2018/pansou-web
    container_name: pansou
    restart: unless-stopped
    ports:
      - "${host_port}:80"
    volumes:
      - ./data:/app/data
EOF
    
    echo -e "${GREEN}✅ Docker Compose 配置文件已创建。${NC}"
    echo "文件位置: ${pansou_dir}/docker-compose.yml"
    
    # 启动服务
    echo "正在启动 PanSou 服务..."
    if $compose_cmd up -d; then
        local public_ipv4=$(curl -4 -s --connect-timeout 5 ifconfig.me || curl -4 -s --connect-timeout 5 http://ipv4.icanhazip.com)
        local public_ipv6=$(curl -6 -s --connect-timeout 5 ifconfig.me || curl -6 -s --connect-timeout 5 http://ipv6.icanhazip.com)
        
        echo -e "${GREEN}✅ PanSou 安装成功！${NC}"
        [ -n "$public_ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${public_ipv4}:${host_port}${NC}"
        [ -n "$public_ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${public_ipv6}]:${host_port}${NC}"
        echo -e "数据目录：${pansou_dir}/data"
    else
        echo -e "${RED}❌ 启动失败，请检查错误信息。${NC}"
    fi
    cd - > /dev/null
}
function start_pansou() {
    clear
    echo "正在启动 PanSou..."
    
    # 兼容 docker compose (v2) 和 docker-compose (v1)
    local compose_cmd="docker-compose"
    if docker compose version &> /dev/null; then
        compose_cmd="docker compose"
    fi

    if [ -f "/opt/pansou/docker-compose.yml" ]; then
        cd /opt/pansou && $compose_cmd start
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ 启动成功！(Docker Compose)${NC}"
        else
            echo -e "${RED}❌ 启动失败。${NC}"
        fi
        cd - > /dev/null
    else
        if docker start pansou 2>/dev/null; then
            echo -e "${GREEN}✅ 启动成功！(Docker Run)${NC}"
        else
            echo -e "${RED}❌ 启动失败，容器可能不存在。${NC}"
        fi
    fi
}
function stop_pansou() {
    clear
    echo "正在停止 PanSou..."
    
    # 兼容 docker compose (v2) 和 docker-compose (v1)
    local compose_cmd="docker-compose"
    if docker compose version &> /dev/null; then
        compose_cmd="docker compose"
    fi

    if [ -f "/opt/pansou/docker-compose.yml" ]; then
        cd /opt/pansou && $compose_cmd stop
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ 停止成功！(Docker Compose)${NC}"
        else
            echo -e "${RED}❌ 停止失败。${NC}"
        fi
        cd - > /dev/null
    else
        if docker stop pansou 2>/dev/null; then
            echo -e "${GREEN}✅ 停止成功！(Docker Run)${NC}"
        else
            echo -e "${RED}❌ 停止失败，容器可能不存在。${NC}"
        fi
    fi
}
function restart_pansou() {
    clear
    echo "正在重启 PanSou..."
    
    # 兼容 docker compose (v2) 和 docker-compose (v1)
    local compose_cmd="docker-compose"
    if docker compose version &> /dev/null; then
        compose_cmd="docker compose"
    fi

    if [ -f "/opt/pansou/docker-compose.yml" ]; then
        cd /opt/pansou && $compose_cmd restart
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ 重启成功！(Docker Compose)${NC}"
        else
            echo -e "${RED}❌ 重启失败。${NC}"
        fi
        cd - > /dev/null
    else
        if docker restart pansou 2>/dev/null; then
            echo -e "${GREEN}✅ 重启成功！(Docker Run)${NC}"
        else
            echo -e "${RED}❌ 重启失败，容器可能不存在。${NC}"
        fi
    fi
}
function change_pansou_port() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}         修改 PanSou 访问端口${NC}"
    echo -e "${CYAN}==========================================${NC}"
    
    # 检查容器是否存在
    if ! docker ps -a --format '{{.Names}}' | grep -q "^pansou$"; then
        echo -e "${RED}❌ PanSou 容器不存在，请先安装。${NC}"
        return
    fi
    
    # 兼容 docker compose (v2) 和 docker-compose (v1)
    local compose_cmd="docker-compose"
    if docker compose version &> /dev/null; then
        compose_cmd="docker compose"
    fi
    
    # 获取当前端口
    local current_port=$(docker inspect pansou --format='{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' 2>/dev/null || echo "80")
    echo -e "当前访问端口: ${YELLOW}${current_port}${NC}"
    
    # 获取新端口
    read -p "请输入新的宿主机端口: " new_port
    if [[ ! "$new_port" =~ ^[0-9]+$ ]] || [ "$new_port" -lt 1 ] || [ "$new_port" -gt 65535 ]; then
        echo -e "${RED}❌ 端口号无效。请输入 1-65535 之间的数字。${NC}"
        return
    fi
    
    # 检查端口占用
    if netstat -tuln | grep -q ":${new_port} "; then
        echo -e "${RED}❌ 端口 ${new_port} 已被占用，请选择其他端口。${NC}"
        return
    fi
    
    echo -e "${YELLOW}⚠️  正在修改端口，这将重启容器...${NC}"
    
    # 停止并删除现有容器
    docker stop pansou >/dev/null 2>&1
    docker rm pansou >/dev/null 2>&1
    
    # 判断安装方式并重新创建
    local method=""
    if [ -f "/opt/pansou/docker-compose.yml" ]; then
        # Docker Compose 方式：更新配置文件
        cd /opt/pansou
        sed -i "s/- \"[0-9]*:80\"/- \"${new_port}:80\"/" docker-compose.yml
        $compose_cmd up -d
        method="Docker Compose"
        cd - > /dev/null
    else
        # Docker Run 方式：重新运行
        docker run -d --name pansou -p ${new_port}:80 ghcr.io/fish2018/pansou-web
        method="Docker Run"
    fi
    
    if docker ps --format '{{.Names}}' | grep -q "^pansou$"; then
        local public_ipv4=$(curl -4 -s --connect-timeout 5 ifconfig.me || curl -4 -s --connect-timeout 5 http://ipv4.icanhazip.com)
        local public_ipv6=$(curl -6 -s --connect-timeout 5 ifconfig.me || curl -6 -s --connect-timeout 5 http://ipv6.icanhazip.com)
        
        echo -e "${GREEN}✅ 端口修改成功！${NC}"
        echo -e "安装方式: ${method}"
        [ -n "$public_ipv4" ] && echo -e "新 IPv4 访问地址: ${YELLOW}http://${public_ipv4}:${new_port}${NC}"
        [ -n "$public_ipv6" ] && echo -e "新 IPv6 访问地址: ${YELLOW}http://[${public_ipv6}]:${new_port}${NC}"
    else
        echo -e "${RED}❌ 端口修改失败，请检查错误信息。${NC}"
    fi
}
function view_pansou_logs() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}         PanSou 实时日志${NC}"
    echo -e "${CYAN}==========================================${NC}"
    echo "按 Ctrl+C 退出日志查看"
    echo ""
    
    # 兼容 docker compose (v2) 和 docker-compose (v1)
    local compose_cmd="docker-compose"
    if docker compose version &> /dev/null; then
        compose_cmd="docker compose"
    fi

    if [ -f "/opt/pansou/docker-compose.yml" ]; then
        cd /opt/pansou && $compose_cmd logs -f
        cd - > /dev/null
    else
        docker logs -f pansou
    fi
}

function view_pansou_status() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}         PanSou 容器状态${NC}"
    echo -e "${CYAN}==========================================${NC}"
    
    if docker ps -a --format '{{.Names}}' | grep -q "^pansou$"; then
        echo -e "${GREEN}✅ 容器详细信息：${NC}"
        docker inspect pansou --format='\
容器名称: {{.Name}}\n\
容器状态: {{.State.Status}}\n\
运行状态: {{.State.Running}}\n\
镜像: {{.Config.Image}}\n\
创建时间: {{.Created}}\n\
端口映射: {{range $p, $conf := .NetworkSettings.Ports}}{{$p}} -> {{(index $conf 0).HostPort}}{{end}}\n\
日志路径: {{.LogPath}}\n\
重启策略: {{.HostConfig.RestartPolicy.Name}}' | sed 's/^/\t/'
        
        echo ""
        echo -e "${YELLOW}资源使用情况：${NC}"
        docker stats pansou --no-stream
    else
        echo -e "${RED}❌ PanSou 容器不存在。${NC}"
    fi
}

function access_pansou_web() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${GREEN}         查询 PanSou Web 访问地址${NC}"
    echo -e "${CYAN}==========================================${NC}"
    
    if ! docker ps -a --format '{{.Names}}' | grep -q "^pansou$"; then
        echo -e "${RED}❌ PanSou 容器不存在，请先安装。${NC}"
        return
    fi
    
    # 获取映射端口
    local host_port=$(docker inspect pansou --format='{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' 2>/dev/null)
    
    if [ -z "$host_port" ]; then
        echo -e "${YELLOW}⚠️  未能获取到端口映射信息，请确认容器是否正常运行。${NC}"
        return
    fi
    
    local public_ipv4=$(curl -4 -s --connect-timeout 5 ifconfig.me || curl -4 -s --connect-timeout 5 http://ipv4.icanhazip.com)
    local public_ipv6=$(curl -6 -s --connect-timeout 5 ifconfig.me || curl -6 -s --connect-timeout 5 http://ipv6.icanhazip.com)
    
    echo -e "您的 PanSou 网盘访问地址为："
    [ -n "$public_ipv4" ] && echo -e "IPv4 地址: ${YELLOW}http://${public_ipv4}:${host_port}${NC}"
    [ -n "$public_ipv6" ] && echo -e "IPv6 地址: ${YELLOW}http://[${public_ipv6}]:${host_port}${NC}"
    echo ""
}

function uninstall_pansou() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}           卸载 PanSou${NC}"
    echo -e "${CYAN}==========================================${NC}"
    
    if ! docker ps -a --format '{{.Names}}' | grep -q "^pansou$"; then
        echo -e "${YELLOW}⚠️  PanSou 容器不存在。${NC}"
        return
    fi
    
    echo -e "${RED}⚠️  警告：此操作将删除 PanSou 容器及数据！${NC}"
    read -p "确定要卸载 PanSou 吗？(y/N): " confirm
    
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        echo "正在停止并删除容器..."
        docker stop pansou >/dev/null 2>&1
        docker rm pansou >/dev/null 2>&1
        
        # 如果是 Docker Compose 安装，提示删除目录
        if [ -f "/opt/pansou/docker-compose.yml" ]; then
            read -p "是否删除数据目录 /opt/pansou？(y/N): " delete_dir
            if [[ "$delete_dir" =~ ^[yY]$ ]]; then
                rm -rf /opt/pansou
                echo -e "${GREEN}✅ 已删除数据目录。${NC}"
            fi
        fi
        
        echo -e "${GREEN}✅ PanSou 卸载完成！${NC}"
    else
        echo -e "${YELLOW}卸载操作已取消。${NC}"
    fi
}

# Nginx Proxy Manager 管理菜单
function nginx_proxy_manager_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          Nginx Proxy Manager 管理${NC}"
        if [ -d "/opt/npm" ] && docker compose -f /opt/npm/docker-compose.yml ps &> /dev/null; then
            echo -e "          状态: ${GREEN}已安装${NC}"
        else
            echo -e "          状态: ${RED}未安装${NC}"
        fi
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  安装/更新 Nginx Proxy Manager"
        echo -e " ${GREEN}2.${NC}  启动 Nginx Proxy Manager"
        echo -e " ${GREEN}3.${NC}  停止 Nginx Proxy Manager"
        echo -e " ${GREEN}4.${NC}  重启 Nginx Proxy Manager"
        echo -e " ${GREEN}5.${NC}  卸载 Nginx Proxy Manager"
        echo -e " ${GREEN}6.${NC}  查看 Nginx Proxy Manager 状态"
        echo -e " ${GREEN}7.${NC}  查看 Nginx Proxy Manager 登录信息"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择: " npm_choice

        case "$npm_choice" in
            1) install_update_npm ;;
            2) start_npm ;;
            3) stop_npm ;;
            4) restart_npm ;;
            5) uninstall_npm ;;
            6) view_npm_status ;;
            7) view_npm_login_info ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 2 ;;
        esac
    done
}

function install_update_npm() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          安装/更新 Nginx Proxy Manager${NC}"
    echo -e "${CYAN}=========================================${NC}"

    # 检查并安装 Docker
    if ! command -v docker &> /dev/null; then
        echo -e "${YELLOW}未检测到 Docker，正在安装...${NC}"
        curl -fsSL https://get.docker.com | sh
        if [ $? -ne 0 ]; then
            echo -e "${RED}Docker 安装失败，请检查网络或手动安装。${NC}"
            read -p "按任意键继续..."
            return
        fi
        echo -e "${GREEN}Docker 安装成功。${NC}"
        systemctl start docker
        systemctl enable docker
    else
        echo -e "${GREEN}Docker 已安装。${NC}"
    fi

    # 检查并安装 Docker Compose 插件
    if ! docker compose version &> /dev/null; then
        echo -e "${YELLOW}未检测到 Docker Compose 插件，正在尝试安装...${NC}"
        if command -v apt &> /dev/null; then
            apt update && apt install -y docker-compose-plugin
        elif command -v yum &> /dev/null; then
            yum install -y docker-compose-plugin
        else
            echo -e "${RED}无法自动安装 Docker Compose 插件，请手动安装。${NC}"
            read -p "按任意键继续..."
            return
        fi
        
        if [ $? -ne 0 ]; then
            echo -e "${RED}Docker Compose 插件安装失败。${NC}"
            read -p "按任意键继续..."
            return
        fi
        echo -e "${GREEN}Docker Compose 插件安装成功。${NC}"
    else
        echo -e "${GREEN}Docker Compose 插件已安装。${NC}"
    fi

    # 检查 Nginx Proxy Manager 是否已安装
    if [ -d "/opt/npm" ] && [ -f "/opt/npm/docker-compose.yml" ]; then
        echo -e "${YELLOW}检测到 Nginx Proxy Manager 已安装。${NC}"
        read -p "是否要更新 Nginx Proxy Manager？ (y/n): " confirm_update
        if [[ "$confirm_update" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}正在更新 Nginx Proxy Manager...${NC}"
            cd /opt/npm
            docker compose pull
            docker compose up -d --remove-orphans
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Nginx Proxy Manager 更新成功！${NC}"
            else
                echo -e "${RED}Nginx Proxy Manager 更新失败，请检查日志。${NC}"
            fi
        else
            echo "已取消 Nginx Proxy Manager 更新。"
        fi
    else
        echo -e "${YELLOW}未检测到 Nginx Proxy Manager 安装。${NC}"
        read -p "是否要安装 Nginx Proxy Manager？ (y/n): " confirm_install
        if [[ "$confirm_install" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}正在安装 Nginx Proxy Manager...${NC}"
            mkdir -p /opt/npm
            cd /opt/npm

            cat <<EOF > docker-compose.yml
version: '3.8'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
EOF

            docker compose up -d
            if [ $? -eq 0 ]; then
                local public_ipv4=$(curl -4 -s --connect-timeout 5 ifconfig.me || curl -4 -s --connect-timeout 5 http://ipv4.icanhazip.com)
                local public_ipv6=$(curl -6 -s --connect-timeout 5 ifconfig.me || curl -6 -s --connect-timeout 5 http://ipv6.icanhazip.com)
                
                echo -e "${GREEN}Nginx Proxy Manager 安装成功！${NC}"
                echo -e "${CYAN}默认登录信息：${NC}"
                [ -n "$public_ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${public_ipv4}:81${NC}"
                [ -n "$public_ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${public_ipv6}]:81${NC}"
                echo -e "用户名: ${GREEN}admin@example.com${NC}"
                echo -e "密码: ${GREEN}changeme${NC}"
                echo -e "${RED}请尽快登录面板修改默认密码和邮箱！${NC}"
            else
                echo -e "${RED}Nginx Proxy Manager 安装失败，请检查网络或尝试手动安装。${NC}"
            fi
        else
            echo "已取消 Nginx Proxy Manager 安装。"
        fi
    fi
    read -p "按任意键继续..."
}

function start_npm() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          启动 Nginx Proxy Manager${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ -d "/opt/npm" ] && [ -f "/opt/npm/docker-compose.yml" ]; then
        echo -e "${BLUE}正在启动 Nginx Proxy Manager...${NC}"
        cd /opt/npm
        docker compose up -d
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Nginx Proxy Manager 启动成功！${NC}"
        else
            echo -e "${RED}Nginx Proxy Manager 启动失败，请检查日志。${NC}"
        fi
    else
        echo -e "${RED}未检测到 Nginx Proxy Manager 安装，请先安装。${NC}"
    fi
    read -p "按任意键继续..."
}

function stop_npm() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          停止 Nginx Proxy Manager${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ -d "/opt/npm" ] && [ -f "/opt/npm/docker-compose.yml" ]; then
        echo -e "${BLUE}正在停止 Nginx Proxy Manager...${NC}"
        cd /opt/npm
        docker compose down
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Nginx Proxy Manager 停止成功！${NC}"
        else
            echo -e "${RED}Nginx Proxy Manager 停止失败，请检查日志。${NC}"
        fi
    else
        echo -e "${RED}未检测到 Nginx Proxy Manager 安装。${NC}"
    fi
    read -p "按任意键继续..."
}

function restart_npm() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          重启 Nginx Proxy Manager${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ -d "/opt/npm" ] && [ -f "/opt/npm/docker-compose.yml" ]; then
        echo -e "${BLUE}正在重启 Nginx Proxy Manager...${NC}"
        cd /opt/npm
        docker compose restart
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Nginx Proxy Manager 重启成功！${NC}"
        else
            echo -e "${RED}Nginx Proxy Manager 重启失败，请检查日志。${NC}"
        fi
    else
        echo -e "${RED}未检测到 Nginx Proxy Manager 安装。${NC}"
    fi
    read -p "按任意键继续..."
}

function uninstall_npm() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          卸载 Nginx Proxy Manager${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ -d "/opt/npm" ]; then
        echo -e "${RED}⚠️  警告：此操作将删除所有配置和数据！${NC}"
        read -p "确定要卸载 Nginx Proxy Manager 吗？ (y/n): " confirm_uninstall
        if [[ "$confirm_uninstall" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}正在卸载 Nginx Proxy Manager...${NC}"
            cd /opt/npm
            docker compose down -v
            cd /
            rm -rf /opt/npm
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Nginx Proxy Manager 卸载成功！${NC}"
            else
                echo -e "${RED}Nginx Proxy Manager 卸载失败，请检查日志。${NC}"
            fi
        else
            echo "已取消 Nginx Proxy Manager 卸载。"
        fi
    else
        echo -e "${RED}未检测到 Nginx Proxy Manager 安装。${NC}"
    fi
    read -p "按任意键继续..."
}

function view_npm_status() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          查看 Nginx Proxy Manager 状态${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ -d "/opt/npm" ]; then
        echo -e "${BLUE}正在获取 Nginx Proxy Manager 状态...${NC}"
        cd /opt/npm
        docker compose ps
    else
        echo -e "${RED}未检测到 Nginx Proxy Manager 安装。${NC}"
    fi
    read -p "按任意键继续..."
}

function view_npm_login_info() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          查看 Nginx Proxy Manager 登录信息${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ -d "/opt/npm" ]; then
        local public_ipv4=$(curl -4 -s --connect-timeout 5 ifconfig.me || curl -4 -s --connect-timeout 5 http://ipv4.icanhazip.com)
        local public_ipv6=$(curl -6 -s --connect-timeout 5 ifconfig.me || curl -6 -s --connect-timeout 5 http://ipv6.icanhazip.com)
        
        echo -e "${GREEN}Nginx Proxy Manager 面板登录信息：${NC}"
        [ -n "$public_ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${public_ipv4}:81${NC}"
        [ -n "$public_ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${public_ipv6}]:81${NC}"
        echo -e "用户名: ${GREEN}admin@example.com${NC}"
        echo -e "密码: ${GREEN}changeme${NC}"
        echo -e "${RED}请注意：如果已修改过默认端口或密码，请使用您修改后的信息登录。${NC}"
    else
        echo -e "${RED}未检测到 Nginx Proxy Manager 安装。${NC}"
    fi
    read -p "按任意键继续..."
}

# AdGuard Home 管理菜单 (VPS)
function adguard_home_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}       AdGuard Home 管理 (VPS)${NC}"
        if [ -f "/opt/AdGuardHome/AdGuardHome" ]; then
            echo -e "       状态: ${GREEN}已安装${NC}"
        else
            echo -e "       状态: ${RED}未安装${NC}"
        fi
        echo -e "${CYAN}=========================================${NC}"
        echo "1. 安装 AdGuard Home"
        echo "2. 卸载 AdGuard Home"
        echo "3. 启动 AdGuard Home"
        echo "4. 停止 AdGuard Home"
        echo "5. 重启 AdGuard Home"
        echo "6. 更新 AdGuard Home"
        echo "7. 查看信息"
        echo "8. 查看状态"
        echo "0. 返回上级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择: " agh_choice

        case "$agh_choice" in
            1)
                echo -e "${BLUE}开始安装 AdGuard Home...${NC}"
                curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
                
                echo -e "${GREEN}安装完成，访问地址：${NC}"
                
                # 获取IPv4地址（优先内网，没有则尝试公网）
                local ipv4_address=""
                
                # 1. 尝试获取内网IPv4
                local_ips=$(hostname -I 2>/dev/null | awk '{print $1}')
                if [ -z "$local_ips" ]; then
                    local_ips=$(ip addr show 2>/dev/null | grep -E "inet (192\.168|10\.|172\.)" | awk '{print $2}' | cut -d/ -f1 | head -1)
                fi
                
                if [ -n "$local_ips" ]; then
                    ipv4_address="$local_ips"
                else
                    # 2. 尝试获取公网IPv4（确保是真正的IPv4）
                    local ipv4_candidates=(
                        "$(curl -4 -s --connect-timeout 3 ifconfig.me 2>/dev/null)"
                        "$(curl -4 -s --connect-timeout 3 ipv4.icanhazip.com 2>/dev/null)"
                        "$(curl -4 -s --connect-timeout 3 api.ipify.org 2>/dev/null)"
                    )
                    
                    for candidate in "${ipv4_candidates[@]}"; do
                        # 验证是否为有效的IPv4地址（不是IPv6）
                        if [[ -n "$candidate" && "$candidate" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                            ipv4_address="$candidate"
                            break
                        fi
                    done
                fi
                
                # 获取IPv6地址
                local ipv6_address=""
                local ipv6_candidates=(
                    "$(curl -6 -s --connect-timeout 3 ifconfig.me 2>/dev/null)"
                    "$(curl -6 -s --connect-timeout 3 ipv6.icanhazip.com 2>/dev/null)"
                    "$(curl -6 -s --connect-timeout 3 api6.ipify.org 2>/dev/null)"
                )
                
                for candidate in "${ipv6_candidates[@]}"; do
                    if [[ -n "$candidate" && "$candidate" =~ : ]]; then
                        ipv6_address="$candidate"
                        break
                    fi
                done
                
                # 显示管理地址
                if [ -n "$ipv4_address" ]; then
                    echo -e "• ${YELLOW}http://${ipv4_address}:3000${NC}"
                fi
                
                if [ -n "$ipv6_address" ]; then
                    echo -e "• ${YELLOW}http://[${ipv6_address}]:3000${NC}"
                fi
                
                if [ -z "$ipv4_address" ] && [ -z "$ipv6_address" ]; then
                    echo -e "${RED}未能获取IP地址，请手动检查网络配置。${NC}"
                fi
                
                read -p "按任意键继续..."
                ;;
            2)
                echo -e "${RED}开始卸载 AdGuard Home...${NC}"
                if [ -f "/opt/AdGuardHome/AdGuardHome" ]; then
                    /opt/AdGuardHome/AdGuardHome -s uninstall
                    rm -rf /opt/AdGuardHome
                    echo -e "${GREEN}卸载完成。${NC}"
                else
                    echo -e "${YELLOW}未检测到 AdGuard Home 安装。${NC}"
                fi
                read -p "按任意键继续..."
                ;;
            3)
                if [ -f "/opt/AdGuardHome/AdGuardHome" ]; then
                    /opt/AdGuardHome/AdGuardHome -s start
                    echo -e "${GREEN}启动命令已发送。${NC}"
                else
                    echo -e "${RED}未安装 AdGuard Home。${NC}"
                fi
                read -p "按任意键继续..."
                ;;
            4)
                if [ -f "/opt/AdGuardHome/AdGuardHome" ]; then
                    /opt/AdGuardHome/AdGuardHome -s stop
                    echo -e "${GREEN}停止命令已发送。${NC}"
                else
                    echo -e "${RED}未安装 AdGuard Home。${NC}"
                fi
                read -p "按任意键继续..."
                ;;
            5)
                if [ -f "/opt/AdGuardHome/AdGuardHome" ]; then
                    /opt/AdGuardHome/AdGuardHome -s restart
                    echo -e "${GREEN}重启命令已发送。${NC}"
                else
                    echo -e "${RED}未安装 AdGuard Home。${NC}"
                fi
                read -p "按任意键继续..."
                ;;
            6)
                echo -e "${BLUE}开始更新 AdGuard Home...${NC}"
                curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
                echo -e "${GREEN}更新完成。${NC}"
                read -p "按任意键继续..."
                ;;
            7)
                if [ -f "/opt/AdGuardHome/AdGuardHome" ]; then
                    echo -e "${CYAN}--- AdGuard Home 信息 ---${NC}"
                    /opt/AdGuardHome/AdGuardHome --version
                    
                    echo -e "\n${YELLOW}管理地址：${NC}"
                    
                    # 获取IPv4地址（优先内网）
                    local ipv4_address=""
                    local_ips=$(hostname -I 2>/dev/null | awk '{print $1}')
                    if [ -z "$local_ips" ]; then
                        local_ips=$(ip addr show 2>/dev/null | grep -E "inet (192\.168|10\.|172\.)" | awk '{print $2}' | cut -d/ -f1 | head -1)
                    fi
                    
                    if [ -n "$local_ips" ]; then
                        ipv4_address="$local_ips"
                        echo -e "• ${GREEN}http://${ipv4_address}:3000${NC}"
                    else
                        # 尝试获取公网IPv4
                        public_ipv4=$(curl -4 -s --connect-timeout 3 ifconfig.me 2>/dev/null)
                        if [[ -n "$public_ipv4" && "$public_ipv4" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                            echo -e "• ${GREEN}http://${public_ipv4}:3000${NC}"
                        fi
                    fi
                    
                    # 获取IPv6地址
                    public_ipv6=$(curl -6 -s --connect-timeout 3 ifconfig.me 2>/dev/null)
                    if [ -n "$public_ipv6" ]; then
                        echo -e "• ${GREEN}http://[${public_ipv6}]:3000${NC}"
                    fi
                    
                    echo ""
                    echo "安装目录: /opt/AdGuardHome"
                    echo "配置文件: /opt/AdGuardHome/AdGuardHome.yaml"
                else
                    echo -e "${YELLOW}未检测到 AdGuard Home 安装。${NC}"
                fi
                read -p "按任意键继续..."
                ;;
            8)
                if [ -f "/opt/AdGuardHome/AdGuardHome" ]; then
                    echo -e "${CYAN}--- AdGuard Home 状态 ---${NC}"
                    /opt/AdGuardHome/AdGuardHome -s status
                    
                    # 检查服务是否正在运行
                    if systemctl is-active --quiet AdGuardHome; then
                        echo -e "\n服务状态: ${GREEN}运行中${NC}"
                    else
                        echo -e "\n服务状态: ${RED}未运行${NC}"
                    fi
                else
                    echo -e "${RED}未安装 AdGuard Home。${NC}"
                fi
                read -p "按任意键继续..."
                ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; read -p "按任意键继续..." ;;
        esac
    done
}

# Watchtower 容器自动更新管理菜单
function watchtower_management() {
    while true; do
        clear
        echo -e "${CYAN}"
        echo "=========================================="
        echo "     Watchtower 容器自动更新管理"
        echo "=========================================="
        echo -e "${NC}"
        
        # 检查Docker状态
        if ! docker info > /dev/null 2>&1; then
            echo -e "${RED}⚠️  Docker 服务未运行或未安装！${NC}"
            echo "请先确保Docker已安装并启动。"
            echo ""
        fi
        
        # 显示Watchtower状态
        if docker ps -a --format "{{.Names}}" | grep -q "watchtower"; then
            echo -e "${GREEN}✅ Watchtower 容器状态：${NC}"
            docker ps -a --filter "name=watchtower" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
            
            # 显示监控的容器数量
            container_count=$(docker ps --format "{{.Names}}" | grep -v "watchtower" | wc -l)
            echo -e "\n📊 Watchtower 正在监控 ${YELLOW}${container_count}${NC} 个容器"
        else
            echo -e "${YELLOW}📭 Watchtower 未运行。${NC}"
        fi
        
        echo ""
        echo "1.  安装/部署 Watchtower"
        echo "2.  启动 Watchtower"
        echo "3.  停止 Watchtower"
        echo "4.  重启 Watchtower"
        echo "5.  配置更新选项"
        echo "6.  立即检查更新"
        echo "7.  查看监控的容器"
        echo "8.  查看实时日志"
        echo "9.  查看容器状态"
        echo "10. 卸载 Watchtower"
        echo "0.  返回上一级菜单"
        echo ""
        echo -e "${YELLOW}提示：${NC}Watchtower 默认每24小时自动检查更新"
        echo "=========================================="
        read -p "请输入你的选择 [0-10]: " choice
        
        case $choice in
            1) install_watchtower ;;
            2) start_watchtower ;;
            3) stop_watchtower ;;
            4) restart_watchtower ;;
            5) configure_watchtower ;;
            6) check_updates_now ;;
            7) view_monitored_containers ;;
            8) view_watchtower_logs ;;
            9) view_watchtower_status ;;
            10) uninstall_watchtower ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 1 ;;
        esac
        
        echo ""
        read -p "按 Enter 键继续..."
    done
}

function install_watchtower() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}          安装/部署 Watchtower${NC}"
    echo -e "${CYAN}==========================================${NC}"
    
    # 检查容器是否已存在
    if docker ps -a --format '{{.Names}}' | grep -q "^watchtower$"; then
        echo -e "${YELLOW}⚠️  Watchtower 容器已存在。${NC}"
        read -p "是否删除现有容器并重新安装？(y/N): " reinstall
        if [[ ! "$reinstall" =~ ^[yY]$ ]]; then
            return
        fi
        docker stop watchtower >/dev/null 2>&1
        docker rm watchtower >/dev/null 2>&1
    fi
    
    echo -e "${GREEN}选择安装配置模式：${NC}"
    echo "1. 基础模式（默认配置，每24小时检查更新）"
    echo "2. 自定义模式（手动配置参数）"
    echo "3. 只监控指定容器（白名单模式）"
    echo ""
    read -p "请选择模式 [1-3]: " mode
    
    case $mode in
        1)
            # 基础模式
            echo "正在安装 Watchtower（基础模式）..."
            if docker run -d \
                --name watchtower \
                --restart unless-stopped \
                -v /var/run/docker.sock:/var/run/docker.sock \
                containrrr/watchtower; then
                echo -e "${GREEN}✅ Watchtower 安装成功！${NC}"
                echo -e "配置：每24小时自动检查所有容器更新"
            else
                echo -e "${RED}❌ 安装失败，请检查错误信息。${NC}"
            fi
            ;;
        2)
            # 自定义模式
            echo ""
            echo -e "${YELLOW}自定义配置选项：${NC}"
            read -p "检查间隔（默认 24h，支持 30m、2h 等）: " interval
            interval=${interval:-"24h"}
            
            read -p "是否启用通知？(y/N): " enable_notifications
            notifications=""
            if [[ "$enable_notifications" =~ ^[yY]$ ]]; then
                read -p "通知类型（shoutrrr URL，如 slack://、discord://）: " notify_url
                if [ -n "$notify_url" ]; then
                    notifications="-e WATCHTOWER_NOTIFICATIONS=shoutrrr -e WATCHTOWER_NOTIFICATION_URL=${notify_url}"
                fi
            fi
            
            read -p "是否监控所有容器？(Y/n): " monitor_all
            monitor_all=${monitor_all:-"Y"}
            
            cmd="docker run -d --name watchtower --restart unless-stopped"
            cmd="$cmd -v /var/run/docker.sock:/var/run/docker.sock"
            
            if [ -n "$notifications" ]; then
                cmd="$cmd $notifications"
            fi
            
            if [[ "$monitor_all" =~ ^[yY]$ ]]; then
                cmd="$cmd containrrr/watchtower --interval ${interval}"
            else
                # 获取容器列表供选择
                echo ""
                echo -e "可监控的容器列表："
                docker ps --format "{{.Names}}" | grep -v "watchtower" | nl
                echo ""
                read -p "输入要监控的容器编号（多个用空格分隔）: " container_nums
                
                if [ -z "$container_nums" ]; then
                    echo -e "${RED}❌ 未选择任何容器。${NC}"
                    return
                fi
                
                containers=""
                for num in $container_nums; do
                    container_name=$(docker ps --format "{{.Names}}" | grep -v "watchtower" | sed -n "${num}p")
                    if [ -n "$container_name" ]; then
                        containers="$containers $container_name"
                    fi
                done
                
                cmd="$cmd containrrr/watchtower --interval ${interval} $containers"
            fi
            
            echo ""
            echo -e "${YELLOW}执行命令：${NC}"
            echo "$cmd"
            echo ""
            read -p "确认安装？(Y/n): " confirm
            if [[ ! "$confirm" =~ ^[nN]$ ]]; then
                eval $cmd
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}✅ Watchtower 安装成功！${NC}"
                else
                    echo -e "${RED}❌ 安装失败。${NC}"
                fi
            fi
            ;;
        3)
            # 白名单模式
            echo ""
            echo -e "${YELLOW}选择要监控的容器（白名单模式）：${NC}"
            echo "可监控的容器列表："
            docker ps --format "{{.Names}}" | grep -v "watchtower" | nl
            echo ""
            read -p "输入要监控的容器编号（多个用空格分隔）: " container_nums
            
            if [ -z "$container_nums" ]; then
                echo -e "${RED}❌ 未选择任何容器。${NC}"
                return
            fi
            
            containers=""
            for num in $container_nums; do
                container_name=$(docker ps --format "{{.Names}}" | grep -v "watchtower" | sed -n "${num}p")
                if [ -n "$container_name" ]; then
                    containers="$containers $container_name"
                fi
            done
            
            echo "正在安装 Watchtower（白名单模式）..."
            if docker run -d \
                --name watchtower \
                --restart unless-stopped \
                -v /var/run/docker.sock:/var/run/docker.sock \
                containrrr/watchtower \
                --interval 24h \
                $containers; then
                echo -e "${GREEN}✅ Watchtower 安装成功！${NC}"
                echo -e "监控容器：${containers}"
            else
                echo -e "${RED}❌ 安装失败，请检查错误信息。${NC}"
            fi
            ;;
        *)
            echo -e "${RED}❌ 无效选择。${NC}"
            ;;
    esac
}
function start_watchtower() {
    clear
    echo "正在启动 Watchtower..."
    
    if docker start watchtower 2>/dev/null; then
        echo -e "${GREEN}✅ Watchtower 启动成功！${NC}"
    else
        echo -e "${RED}❌ 启动失败，容器可能不存在。${NC}"
    fi
}

function stop_watchtower() {
    clear
    echo "正在停止 Watchtower..."
    
    if docker stop watchtower 2>/dev/null; then
        echo -e "${GREEN}✅ Watchtower 停止成功！${NC}"
    else
        echo -e "${RED}❌ 停止失败，容器可能不存在。${NC}"
    fi
}

function restart_watchtower() {
    clear
    echo "正在重启 Watchtower..."
    
    if docker restart watchtower 2>/dev/null; then
        echo -e "${GREEN}✅ Watchtower 重启成功！${NC}"
    else
        echo -e "${RED}❌ 重启失败，容器可能不存在。${NC}"
    fi
}
function configure_watchtower() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}          配置 Watchtower 选项${NC}"
    echo -e "${CYAN}==========================================${NC}"
    
    if ! docker ps -a --format '{{.Names}}' | grep -q "^watchtower$"; then
        echo -e "${RED}❌ Watchtower 容器不存在，请先安装。${NC}"
        return
    fi
    
    echo -e "${YELLOW}当前配置：${NC}"
    docker inspect watchtower --format='{{range .Config.Env}}{{println .}}{{end}}' | grep -E "WATCHTOWER_|TZ" || echo "使用默认配置"
    
    echo ""
    echo "1. 修改检查间隔"
    echo "2. 添加/修改通知设置"
    echo "3. 切换监控模式（全部/指定容器）"
    echo "4. 清理旧镜像（启用自动清理）"
    echo "0. 返回"
    echo ""
    read -p "请选择操作: " config_choice
    
    case $config_choice in
        1)
            read -p "新的检查间隔（如 24h、12h、30m）: " new_interval
            if [ -n "$new_interval" ]; then
                echo "停止并重新创建容器..."
                docker stop watchtower >/dev/null 2>&1
                docker rm watchtower >/dev/null 2>&1
                
                # 获取原有参数并重新创建
                docker run -d \
                    --name watchtower \
                    --restart unless-stopped \
                    -v /var/run/docker.sock:/var/run/docker.sock \
                    containrrr/watchtower \
                    --interval $new_interval
                
                echo -e "${GREEN}✅ 检查间隔已更新为 ${new_interval}${NC}"
            fi
            ;;
        2)
            echo -e "${YELLOW}通知配置示例：${NC}"
            echo "Slack: slack://token-a/token-b/token-c"
            echo "Discord: discord://token@webhook_id"
            echo ""
            read -p "请输入 shoutrrr URL（留空则禁用通知）: " notify_url
            
            docker stop watchtower >/dev/null 2>&1
            docker rm watchtower >/dev/null 2>&1
            
            if [ -z "$notify_url" ]; then
                # 无通知
                docker run -d \
                    --name watchtower \
                    --restart unless-stopped \
                    -v /var/run/docker.sock:/var/run/docker.sock \
                    containrrr/watchtower
                echo -e "${GREEN}✅ 已禁用通知${NC}"
            else
                # 带通知
                docker run -d \
                    --name watchtower \
                    --restart unless-stopped \
                    -v /var/run/docker.sock:/var/run/docker.sock \
                    -e WATCHTOWER_NOTIFICATIONS=shoutrrr \
                    -e WATCHTOWER_NOTIFICATION_URL="$notify_url" \
                    containrrr/watchtower
                echo -e "${GREEN}✅ 通知配置已更新${NC}"
            fi
            ;;
        3)
            echo ""
            echo "1. 监控所有容器"
            echo "2. 只监控指定容器"
            read -p "选择监控模式: " monitor_mode
            
            docker stop watchtower >/dev/null 2>&1
            docker rm watchtower >/dev/null 2>&1
            
            if [ "$monitor_mode" = "1" ]; then
                docker run -d \
                    --name watchtower \
                    --restart unless-stopped \
                    -v /var/run/docker.sock:/var/run/docker.sock \
                    containrrr/watchtower
                echo -e "${GREEN}✅ 已切换为监控所有容器${NC}"
            else
                echo "可监控的容器列表："
                docker ps --format "{{.Names}}" | grep -v "watchtower" | nl
                echo ""
                read -p "输入要监控的容器名称（多个用空格分隔）: " containers
                
                docker run -d \
                    --name watchtower \
                    --restart unless-stopped \
                    -v /var/run/docker.sock:/var/run/docker.sock \
                    containrrr/watchtower \
                    $containers
                echo -e "${GREEN}✅ 已设置为监控指定容器${NC}"
            fi
            ;;
        4)
            read -p "是否启用自动清理旧镜像？(y/N): " enable_cleanup
            if [[ "$enable_cleanup" =~ ^[yY]$ ]]; then
                docker stop watchtower >/dev/null 2>&1
                docker rm watchtower >/dev/null 2>&1
                
                docker run -d \
                    --name watchtower \
                    --restart unless-stopped \
                    -v /var/run/docker.sock:/var/run/docker.sock \
                    containrrr/watchtower \
                    --cleanup
                echo -e "${GREEN}✅ 已启用自动清理旧镜像${NC}"
            fi
            ;;
    esac
}
function check_updates_now() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}         立即检查容器更新${NC}"
    echo -e "${CYAN}==========================================${NC}"
    
    if ! docker ps --format '{{.Names}}' | grep -q "^watchtower$"; then
        echo -e "${RED}❌ Watchtower 未运行，请先启动。${NC}"
        return
    fi
    
    echo -e "${YELLOW}注意：这将触发一次立即更新检查${NC}"
    echo "更新过程可能需要几分钟，取决于容器数量 and 大小。"
    echo ""
    read -p "是否继续？(Y/n): " confirm
    
    if [[ ! "$confirm" =~ ^[nN]$ ]]; then
        echo "正在执行更新检查..."
        # 使用 --run-once 参数运行一次性检查
        docker run --rm \
            -v /var/run/docker.sock:/var/run/docker.sock \
            containrrr/watchtower \
            --run-once \
            --cleanup
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ 更新检查完成！${NC}"
        else
            echo -e "${YELLOW}⚠️  更新检查过程中可能出现错误，请查看日志。${NC}"
        fi
    fi
}

function view_monitored_containers() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}      Watchtower 监控的容器列表${NC}"
    echo -e "${CYAN}==========================================${NC}"
    
    if ! docker ps --format '{{.Names}}' | grep -q "^watchtower$"; then
        echo -e "${RED}❌ Watchtower 未运行。${NC}"
        return
    fi
    
    # 获取所有运行中的容器（排除watchtower自身）
    echo -e "${GREEN}📦 当前运行中的容器：${NC}"
    docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | grep -v "watchtower"
    
    echo ""
    echo -e "${YELLOW}提示：${NC}"
    echo "• Watchtower 默认监控所有运行中的容器"
    echo "• 如需排除容器，请使用环境变量或命令行参数配置"
}

function view_watchtower_logs() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}        Watchtower 实时日志${NC}"
    echo -e "${CYAN}==========================================${NC}"
    echo "按 Ctrl+C 退出日志查看"
    echo ""
    
    if docker ps --format '{{.Names}}' | grep -q "^watchtower$"; then
        docker logs -f watchtower
    else
        echo -e "${RED}❌ Watchtower 未运行。${NC}"
        read -p "按 Enter 键返回..."
    fi
}

function view_watchtower_status() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}        Watchtower 容器状态${NC}"
    echo -e "${CYAN}==========================================${NC}"
    
    if docker ps -a --format '{{.Names}}' | grep -q "^watchtower$"; then
        echo -e "${GREEN}✅ 容器详细信息：${NC}"
        docker inspect watchtower --format='\
容器名称: {{.Name}}\n\
容器状态: {{.State.Status}}\n\
运行状态: {{.State.Running}}\n\
镜像: {{.Config.Image}}\n\
创建时间: {{.Created}}\n\
重启策略: {{.HostConfig.RestartPolicy.Name}}\n\
环境变量: {{range .Config.Env}}{{println "  - " .}}{{end}}' | sed 's/^/\t/'
        
        echo ""
        echo -e "${YELLOW}最近日志（最后20行）：${NC}"
        docker logs --tail 20 watchtower 2>/dev/null || echo "暂无日志"
    else
        echo -e "${RED}❌ Watchtower 容器不存在。${NC}"
    fi
}

function uninstall_watchtower() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}           卸载 Watchtower${NC}"
    echo -e "${CYAN}==========================================${NC}"
    
    if ! docker ps -a --format '{{.Names}}' | grep -q "^watchtower$"; then
        echo -e "${YELLOW}⚠️  Watchtower 容器不存在。${NC}"
        return
    fi
    
    echo -e "${RED}⚠️  警告：此操作将删除 Watchtower 容器！${NC}"
    echo "注意：这不会影响其他容器，只是停止自动更新功能。"
    echo ""
    read -p "确定要卸载 Watchtower 吗？(y/N): " confirm
    
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        echo "正在停止并删除容器..."
        docker stop watchtower >/dev/null 2>&1
        docker rm watchtower >/dev/null 2>&1
        
        echo -e "${GREEN}✅ Watchtower 卸载完成！${NC}"
        echo -e "${YELLOW}提示：您的其他容器将不再自动更新。${NC}"
    else
        echo -e "${YELLOW}卸载操作已取消。${NC}"
    fi
}


