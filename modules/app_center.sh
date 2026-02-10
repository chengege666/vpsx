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
        echo -e " ${GREEN}13.${NC} MoonTV流媒体应用管理"
        echo -e " ${GREEN}14.${NC} LibreTV流媒体应用管理"
        echo -e " ${GREEN}15.${NC} FRP内网穿透管理"
        echo -e " ${GREEN}16.${NC} Nginx重定向功能"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回主菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-16): " app_choice

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
            13) moontv_management ;;
            14) libretv_management ;;
            15) frp_management ;;
            16) nginx_redirect_management ;;
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
            IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
            
            echo -e "${CYAN}-----------------------------------------${NC}"
            [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
            [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
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

    echo -e "${BLUE}正在拉取镜像并通过 Docker Compose 创建容器...${NC}"
    
    cat <<EOF > /opt/ghproxy/docker-compose.yml
services:
  github-proxy:
    image: wjqserver/ghproxy
    container_name: github-proxy
    restart: always
    ports:
      - "${host_port}:8080"
    volumes:
      - /opt/ghproxy/log/run:/data/ghproxy/log
      - /opt/ghproxy/log/caddy:/data/caddy/log
      - /opt/ghproxy/config:/data/ghproxy/config
EOF

    cd /opt/ghproxy && docker compose up -d
    local compose_status=$?
    cd - > /dev/null

    if [ $compose_status -eq 0 ]; then
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"

        echo -e "${GREEN}GitHub 加速站安装成功！${NC}"
        [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
        [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
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
    
    echo -e "${BLUE}正在更新镜像并重启服务...${NC}"
    cd /opt/ghproxy && docker compose pull && docker compose up -d
    local update_status=$?
    cd - > /dev/null

    if [ $update_status -eq 0 ]; then
        echo -e "${GREEN}更新完成！${NC}"
    else
        echo -e "${RED}更新失败，请检查网络或日志。${NC}"
    fi
    read -p "按回车键继续..."
}

function uninstall_github_proxy() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}          卸载 GitHub 加速站${NC}"
    echo -e "${CYAN}=========================================${NC}"

    read -p "确定要卸载 GitHub 加速站吗？(y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        if [ -f "/opt/ghproxy/docker-compose.yml" ]; then
            cd /opt/ghproxy && docker compose down
            cd - > /dev/null
            rm -rf /opt/ghproxy
        else
            docker stop github-proxy &>/dev/null
            docker rm github-proxy &>/dev/null
        fi
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
    
    local is_compose=false
    [ -f "/opt/ghproxy/docker-compose.yml" ] && is_compose=true

    case "$op" in
        1)
            echo -e "${BLUE}正在启动 GitHub 加速站...${NC}"
            if [ "$is_compose" = true ]; then
                cd /opt/ghproxy && docker compose start
                cd - > /dev/null
            else
                docker start github-proxy
            fi
            ;;
        2)
            echo -e "${BLUE}正在停止 GitHub 加速站...${NC}"
            if [ "$is_compose" = true ]; then
                cd /opt/ghproxy && docker compose stop
                cd - > /dev/null
            else
                docker stop github-proxy
            fi
            ;;
        3)
            echo -e "${BLUE}正在重启 GitHub 加速站...${NC}"
            if [ "$is_compose" = true ]; then
                cd /opt/ghproxy && docker compose restart
                cd - > /dev/null
            else
                docker restart github-proxy
            fi
            ;;
        0) return ;;
        *) echo -e "${RED}无效选择。${NC}" ;;
    esac

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}操作成功！${NC}"
    else
        echo -e "${RED}操作失败，请检查 Docker 日志。${NC}"
    fi
    read -p "按回车键继续..."
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

    echo -e "${BLUE}正在创建并通过 Docker Compose 部署 Komari 容器 (端口: ${host_port})...${NC}"
    mkdir -p /home/docker/komari
    
    cat <<EOF > /home/docker/komari/docker-compose.yml
services:
  komari:
    image: ghcr.io/komari-monitor/komari:latest
    container_name: komari
    restart: always
    ports:
      - "${host_port}:25774"
    volumes:
      - /home/docker/komari:/app/data
EOF

    cd /home/docker/komari && docker compose up -d
    local compose_status=$?
    cd - > /dev/null

    if [ $compose_status -eq 0 ]; then
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        
        echo -e "${GREEN}Komari 监控面板部署成功！${NC}"
        [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${CYAN}http://${ipv4}:${host_port}${NC}"
        [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${CYAN}http://[${ipv6}]:${host_port}${NC}"
        
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

    local is_compose=false
    [ -f "/home/docker/komari/docker-compose.yml" ] && is_compose=true

    case "$manage_choice" in
        1)
            echo -e "${BLUE}正在启动 Komari...${NC}"
            if [ "$is_compose" = true ]; then
                cd /home/docker/komari && docker compose start
                cd - > /dev/null
            else
                docker start komari
            fi
            echo -e "${GREEN}启动指令已发送。${NC}"
            ;;
        2)
            echo -e "${BLUE}正在停止 Komari...${NC}"
            if [ "$is_compose" = true ]; then
                cd /home/docker/komari && docker compose stop
                cd - > /dev/null
            else
                docker stop komari
            fi
            echo -e "${GREEN}停止指令已发送。${NC}"
            ;;
        3)
            echo -e "${BLUE}正在重启 Komari...${NC}"
            if [ "$is_compose" = true ]; then
                cd /home/docker/komari && docker compose restart
                cd - > /dev/null
            else
                docker restart komari
            fi
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
        if [ -f "/home/docker/komari/docker-compose.yml" ]; then
            cd /home/docker/komari && docker compose down
            cd - > /dev/null
        else
            docker stop komari &> /dev/null
            docker rm komari &> /dev/null
        fi
        
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
    
    IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
    
    echo -e "您的 Komari 面板访问地址为："
    [ -n "$ipv4" ] && echo -e "IPv4 地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
    [ -n "$ipv6" ] && echo -e "IPv6 地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
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

# Nginx 重定向功能管理
function nginx_redirect_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             Nginx 重定向管理${NC}"
        
        if command -v nginx &> /dev/null; then
            echo -e "          状态: ${GREEN}已安装${NC}"
            local nginx_status=$(systemctl is-active nginx)
            if [ "$nginx_status" == "active" ]; then
                echo -e "          服务: ${GREEN}运行中${NC}"
            else
                echo -e "          服务: ${RED}已停止${NC}"
            fi
        else
            echo -e "          状态: ${RED}未安装${NC}"
        fi
        
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  安装 Nginx"
        echo -e " ${GREEN}2.${NC}  添加重定向配置"
        echo -e " ${GREEN}3.${NC}  查看/删除重定向配置"
        echo -e " ${GREEN}4.${NC}  Nginx 服务管理"
        echo -e " ${GREEN}5.${NC}  卸载 Nginx"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回应用中心菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-5): " redirect_choice

        case "$redirect_choice" in
            1) install_nginx ;;
            2) add_nginx_redirect ;;
            3) list_delete_nginx_redirects ;;
            4) manage_nginx_service ;;
            5) uninstall_nginx ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 2 ;;
        esac
    done
}

# 安装 Nginx
function install_nginx() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}             安装 Nginx${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if command -v nginx &> /dev/null; then
        echo -e "${YELLOW}Nginx 已经安装。${NC}"
    else
        echo -e "${BLUE}正在安装 Nginx...${NC}"
        install_package nginx
        systemctl enable nginx
        systemctl start nginx
        echo -e "${GREEN}Nginx 安装完成并已启动。${NC}"
    fi
    read -p "按回车键继续..."
}

# 卸载 Nginx
function uninstall_nginx() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}             卸载 Nginx${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! command -v nginx &> /dev/null; then
        echo -e "${YELLOW}未检测到 Nginx 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi
    
    read -p "确定要卸载 Nginx 吗？(y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        echo -e "${BLUE}正在停止并卸载 Nginx...${NC}"
        systemctl stop nginx
        systemctl disable nginx
        if command -v apt &> /dev/null; then
            sudo apt purge -y nginx nginx-common nginx-full
            sudo apt autoremove -y
        elif command -v yum &> /dev/null; then
            sudo yum remove -y nginx
        fi
        rm -rf /etc/nginx
        echo -e "${GREEN}Nginx 卸载完成。${NC}"
    else
        echo "操作已取消。"
    fi
    read -p "按回车键继续..."
}

# 添加重定向配置
function add_nginx_redirect() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          添加 Nginx 重定向${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! command -v nginx &> /dev/null; then
        echo -e "${RED}错误: 请先安装 Nginx！${NC}"
        read -p "按回车键继续..."
        return
    fi

    read -p "请输入来源域名 (例如: a.com): " source_domain
    if [ -z "$source_domain" ]; then
        echo -e "${RED}域名不能为空。${NC}"
        read -p "按回车键继续..."
        return
    fi

    read -p "请输入目标 URL (例如: https://b.com): " target_url
    if [ -z "$target_url" ]; then
        echo -e "${RED}目标 URL 不能为空。${NC}"
        read -p "按回车键继续..."
        return
    fi

    # 检查目标 URL 是否以 http:// 或 https:// 开头
    if [[ ! "$target_url" =~ ^https?:// ]]; then
        echo -e "${YELLOW}警告: 目标 URL 建议以 http:// 或 https:// 开头。${NC}"
        read -p "是否继续？(y/N): " confirm_url
        [[ ! "$confirm_url" =~ ^[yY]$ ]] && return
    fi

    local config_file="/etc/nginx/conf.d/redirect_${source_domain}.conf"
    
    if [ -f "$config_file" ]; then
        echo -e "${YELLOW}该域名的重定向配置已存在。${NC}"
        read -p "是否覆盖？(y/N): " overwrite
        [[ ! "$overwrite" =~ ^[yY]$ ]] && return
    fi

    echo -e "${BLUE}正在生成配置文件...${NC}"
    cat > "$config_file" <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name $source_domain;
    return 301 $target_url\$request_uri;
}
EOF

    echo -e "${BLUE}正在测试 Nginx 配置...${NC}"
    if nginx -t; then
        echo -e "${BLUE}正在重载 Nginx...${NC}"
        systemctl reload nginx
        echo -e "${GREEN}✅ 重定向配置成功！${NC}"
        echo -e "来源: ${YELLOW}$source_domain${NC}"
        echo -e "目标: ${YELLOW}$target_url${NC}"
    else
        echo -e "${RED}❌ Nginx 配置测试失败，正在移除无效配置。${NC}"
        rm -f "$config_file"
    fi
    
    read -p "按回车键继续..."
}

# 查看/删除重定向配置
function list_delete_nginx_redirects() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          当前 Nginx 重定向列表${NC}"
        echo -e "${CYAN}=========================================${NC}"
        
        local configs=(/etc/nginx/conf.d/redirect_*.conf)
        if [ ! -e "${configs[0]}" ]; then
            echo -e "${YELLOW}暂无重定向配置。${NC}"
            echo -e "${CYAN}-----------------------------------------${NC}"
            echo -e " ${RED}0.${NC} 返回"
            read -p "请选择: " choice
            break
        fi

        local i=1
        declare -A config_map
        for config in "${configs[@]}"; do
            local domain=$(basename "$config" | sed 's/redirect_//;s/.conf//')
            local target=$(grep "return 301" "$config" | awk '{print $3}' | sed 's/;//;s/\$request_uri//')
            echo -e " ${GREEN}$i.${NC} $domain -> $target"
            config_map[$i]="$config"
            ((i++))
        done
        
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}请输入编号删除配置 (例如: 1)${NC}"
        echo -e " ${RED}0.${NC}       返回"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请选择: " choice
        
        if [ "$choice" == "0" ]; then
            break
        elif [[ "$choice" =~ ^[0-9]+$ ]]; then
            local target_config="${config_map[$choice]}"
            if [ -n "$target_config" ]; then
                read -p "确定要删除该配置吗？(y/N): " confirm_del
                if [[ "$confirm_del" =~ ^[yY]$ ]]; then
                    rm -f "$target_config"
                    systemctl reload nginx
                    echo -e "${GREEN}配置已删除。${NC}"
                    sleep 1
                fi
            else
                echo -e "${RED}无效的编号。${NC}"; sleep 1
            fi
        else
            echo -e "${RED}无效的选择。${NC}"; sleep 1
        fi
    done
}

# Nginx 服务管理
function manage_nginx_service() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             Nginx 服务管理${NC}"
        if command -v nginx &> /dev/null; then
            local nginx_status=$(systemctl is-active nginx)
            echo -e "          当前状态: ${nginx_status}${NC}"
        else
            echo -e "          状态: ${RED}未安装${NC}"
            read -p "按回车键继续..."
            return
        fi
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC} 启动 Nginx"
        echo -e " ${GREEN}2.${NC} 停止 Nginx"
        echo -e " ${GREEN}3.${NC} 重启 Nginx"
        echo -e " ${GREEN}4.${NC} 重载配置 (Reload)"
        echo -e " ${GREEN}5.${NC} 查看详细状态 (Status)"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC} 返回"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入选择: " svc_choice
        
        case "$svc_choice" in
            1) systemctl start nginx; echo -e "${GREEN}已尝试启动 Nginx。${NC}"; sleep 1 ;;
            2) systemctl stop nginx; echo -e "${GREEN}已尝试停止 Nginx。${NC}"; sleep 1 ;;
            3) systemctl restart nginx; echo -e "${GREEN}已尝试重启 Nginx。${NC}"; sleep 1 ;;
            4) systemctl reload nginx; echo -e "${GREEN}已重载配置。${NC}"; sleep 1 ;;
            5) systemctl status nginx; read -p "按回车键继续..." ;;
            0) break ;;
            *) echo -e "${RED}无效选择。${NC}"; sleep 1 ;;
        esac
    done
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
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        
        echo -e "${GREEN}✅ PanSou 安装成功！${NC}"
        [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
        [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
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
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        
        echo -e "${GREEN}✅ PanSou 安装成功！${NC}"
        [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
        [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
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
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        
        echo -e "${GREEN}✅ 端口修改成功！${NC}"
        echo -e "安装方式: ${method}"
        [ -n "$ipv4" ] && echo -e "新 IPv4 访问地址: ${YELLOW}http://${ipv4}:${new_port}${NC}"
        [ -n "$ipv6" ] && echo -e "新 IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${new_port}${NC}"
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
    
    IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
    
    echo -e "您的 PanSou 网盘访问地址为："
    [ -n "$ipv4" ] && echo -e "IPv4 地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
    [ -n "$ipv6" ] && echo -e "IPv6 地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
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
                IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
                
                echo -e "${GREEN}Nginx Proxy Manager 安装成功！${NC}"
                echo -e "${CYAN}默认登录信息：${NC}"
                [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:81${NC}"
                [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:81${NC}"
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
    echo -e "${GREEN}    查看 Nginx Proxy Manager 登录信息     ${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ -d "/opt/npm" ]; then
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        
        echo -e "${GREEN}Nginx Proxy Manager 面板登录信息：${NC}"
        [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:81${NC}"
        [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:81${NC}"
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
                
                IFS='|' read -r ipv4_address ipv6_address <<< "$(get_access_ips)"
                
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
                    
                    IFS='|' read -r ipv4_address ipv6_address <<< "$(get_access_ips)"
                    
                    [ -n "$ipv4_address" ] && echo -e "• ${GREEN}http://${ipv4_address}:3000${NC}"
                    [ -n "$ipv6_address" ] && echo -e "• ${GREEN}http://[${ipv6_address}]:3000${NC}"
                    
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

# 在 app_center.sh 文件中添加以下代码

# MoonTV 流媒体应用管理菜单
function moontv_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          MoonTV 流媒体应用管理${NC}"
        
        # 检查 Docker 是否运行
        if ! docker info > /dev/null 2>&1; then
            echo -e "${RED}⚠️  Docker 服务未运行或未安装！${NC}"
        else
            # 显示当前状态
            if docker ps -a --format '{{.Names}}' | grep -q "^moontv-core$"; then
                echo -e "          状态: ${GREEN}已部署${NC}"
            else
                echo -e "          状态: ${RED}未部署${NC}"
            fi
        fi
        
        echo -e "${CYAN}=========================================${NC}"
        echo "MoonTV (LunaTV) 是一个现代化的流媒体应用"
        echo "基于 Docker 容器部署，支持视频播放和管理"
        echo ""
        echo -e " ${GREEN}1.${NC}  安装 MoonTV (自定义配置)"
        echo -e " ${GREEN}2.${NC}  启动 MoonTV"
        echo -e " ${GREEN}3.${NC}  停止 MoonTV"
        echo -e " ${GREEN}4.${NC}  重启 MoonTV"
        echo -e " ${GREEN}5.${NC}  查看 MoonTV 状态和日志"
        echo -e " ${GREEN}6.${NC}  修改 MoonTV 配置"
        echo -e " ${GREEN}7.${NC}  卸载 MoonTV"
        echo -e " ${GREEN}8.${NC}  访问 MoonTV Web 界面"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回应用中心菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-8): " moontv_choice

        case "$moontv_choice" in
            1) install_moontv ;;
            2) start_moontv ;;
            3) stop_moontv ;;
            4) restart_moontv ;;
            5) view_moontv_status_logs ;;
            6) modify_moontv_config ;;
            7) uninstall_moontv ;;
            8) access_moontv_web ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 2 ;;
        esac
    done
}

# 安装 MoonTV (自定义配置)
function install_moontv() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}           安装 MoonTV 流媒体应用${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! command -v docker &> /dev/null; then
        echo -e "${RED}未检测到 Docker，请先安装 Docker 环境。${NC}"
        echo "您可以通过应用中心的 Komari 管理菜单安装 Docker。"
        read -p "按回车键继续..."
        return
    fi

    # 检查容器是否已存在
    if docker ps -a --format '{{.Names}}' | grep -q "^moontv-core$"; then
        echo -e "${YELLOW}检测到 MoonTV 容器已存在。${NC}"
        read -p "是否重新部署？(这将删除现有配置) (y/N): " redeploy_choice
        if [[ ! "$redeploy_choice" =~ ^[yY]$ ]]; then
            return
        fi
        echo -e "${BLUE}正在停止并移除旧容器...${NC}"
        docker stop moontv-core moontv-kvrocks &> /dev/null
        docker rm moontv-core moontv-kvrocks &> /dev/null
    fi

    echo -e "${YELLOW}正在配置 MoonTV 安装参数...${NC}"
    echo ""

    # 获取自定义端口
    read -p "请输入宿主机映射端口 (默认 3000): " host_port
    host_port=${host_port:-3000}
    
    # 验证端口占用
    if command -v ss &> /dev/null; then
        if ss -tuln | grep -q ":${host_port} "; then
            echo -e "${RED}❌ 端口 ${host_port} 已被占用，请选择其他端口。${NC}"
            read -p "按回车键继续..."
            return
        fi
    fi

    # 获取自定义用户名
    read -p "请输入管理员用户名 (默认 admin): " username
    username=${username:-admin}

    # 获取自定义密码
    while true; do
        read -sp "请输入管理员密码: " password
        echo ""
        if [ -z "$password" ]; then
            echo -e "${RED}密码不能为空，请重新输入。${NC}"
            continue
        fi
        
        read -sp "请再次输入密码确认: " password_confirm
        echo ""
        
        if [ "$password" != "$password_confirm" ]; then
            echo -e "${RED}两次输入的密码不一致，请重新输入。${NC}"
        else
            break
        fi
    done

    echo ""
    read -p "请输入站点基础URL (可选，留空则使用IP): " site_base
    read -p "请输入站点名称 (可选，默认 LunaTV Enhanced): " site_name
    site_name=${site_name:-"LunaTV Enhanced"}

    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}安装配置确认：${NC}"
    echo -e "端口: ${GREEN}${host_port}${NC}"
    echo -e "用户名: ${GREEN}${username}${NC}"
    echo -e "站点名称: ${GREEN}${site_name}${NC}"
    if [ -n "$site_base" ]; then
        echo -e "站点URL: ${GREEN}${site_base}${NC}"
    fi
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "确认以上配置并开始安装？(y/N): " confirm_install
    if [[ ! "$confirm_install" =~ ^[yY]$ ]]; then
        echo "安装已取消。"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在准备安装目录...${NC}"
    mkdir -p /opt/moontv
    
    echo -e "${BLUE}正在拉取镜像...${NC}"
    docker pull ghcr.io/szemeng76/lunatv:latest
    docker pull apache/kvrocks

    echo -e "${BLUE}正在创建 Docker Compose 配置文件...${NC}"
    
    # 创建 docker-compose.yml - 修复版本和网络问题
    cat > /opt/moontv/docker-compose.yml << EOF
services:
  moontv-core:
    image: ghcr.io/szemeng76/lunatv:latest
    container_name: moontv-core
    restart: on-failure
    ports:
      - '${host_port}:3000'
    environment:
      - USERNAME=${username}
      - PASSWORD=${password}
      - NEXT_PUBLIC_STORAGE_TYPE=kvrocks
      - KVROCKS_URL=redis://moontv-kvrocks:6666
      - VIDEO_CACHE_DIR=/app/video-cache
EOF

    # 添加可选的站点配置
    if [ -n "$site_base" ]; then
        echo "      - SITE_BASE=${site_base}" >> /opt/moontv/docker-compose.yml
    fi
    
    echo "      - NEXT_PUBLIC_SITE_NAME=${site_name}" >> /opt/moontv/docker-compose.yml
    
    # 继续写入剩余配置
    cat >> /opt/moontv/docker-compose.yml << EOF
    volumes:
      - video-cache:/app/video-cache
    depends_on:
      - moontv-kvrocks
    networks:
      moontv-network:
        aliases:
          - moontv-core

  moontv-kvrocks:
    image: apache/kvrocks
    container_name: moontv-kvrocks
    restart: unless-stopped
    volumes:
      - kvrocks-data:/var/lib/kvrocks
    networks:
      moontv-network:
        aliases:
          - moontv-kvrocks

networks:
  moontv-network:
    name: moontv-network
    driver: bridge

volumes:
  kvrocks-data:
    name: kvrocks-data
  video-cache:
    name: video-cache
EOF

    echo -e "${BLUE}正在检查并清理旧的网络...${NC}"
    # 检查并清理旧的网络
    if docker network ls | grep -q "moontv_moontv-network"; then
        echo "发现旧的网络，正在清理..."
        docker network rm moontv_moontv-network 2>/dev/null || true
    fi

    echo -e "${BLUE}正在启动 MoonTV 服务...${NC}"
    cd /opt/moontv
    
    # 使用兼容的 Docker Compose 命令
    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi
    
    $docker_compose_cmd up -d
    
    if [ $? -eq 0 ]; then
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        
        echo -e "${GREEN}✅ MoonTV 安装成功！${NC}"
        echo ""
        echo -e "${CYAN}访问信息：${NC}"
        [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
        [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
        echo ""
        echo -e "${CYAN}登录凭据：${NC}"
        echo -e "用户名: ${GREEN}${username}${NC}"
        echo -e "密码: ${GREEN}${password}${NC}"
        echo ""
        echo -e "${YELLOW}重要提示：${NC}"
        echo "1. 请妥善保管您的登录密码"
        echo "2. 首次访问可能需要等待几分钟容器完全启动"
        echo "3. 配置文件位置: /opt/moontv/docker-compose.yml"
        
        # 显示状态
        sleep 3
        echo ""
        echo -e "${BLUE}容器启动状态：${NC}"
        $docker_compose_cmd ps
    else
        echo -e "${RED}❌ MoonTV 安装失败，请检查以下内容：${NC}"
        echo "1. 检查 Docker 服务是否正常运行"
        echo "2. 检查端口 ${host_port} 是否被占用"
        echo "3. 查看详细错误日志:"
        $docker_compose_cmd logs --tail 20
    fi
    read -p "按回车键继续..."
}

# 同时需要修改其他函数中的 docker-compose 调用
# 修改 start_moontv, stop_moontv, restart_moontv, view_moontv_status_logs, uninstall_moontv 函数

function start_moontv() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            启动 MoonTV${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/moontv/docker-compose.yml" ]; then
        echo -e "${RED}未检测到 MoonTV 安装，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在启动 MoonTV 服务...${NC}"
    cd /opt/moontv
    
    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi
    
    $docker_compose_cmd start
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ MoonTV 启动成功！${NC}"
    else
        echo -e "${RED}❌ MoonTV 启动失败。${NC}"
    fi
    read -p "按回车键继续..."
}

function stop_moontv() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            停止 MoonTV${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/moontv/docker-compose.yml" ]; then
        echo -e "${RED}未检测到 MoonTV 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在停止 MoonTV 服务...${NC}"
    cd /opt/moontv
    
    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi
    
    $docker_compose_cmd stop
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ MoonTV 停止成功！${NC}"
    else
        echo -e "${RED}❌ MoonTV 停止失败。${NC}"
    fi
    read -p "按回车键继续..."
}

function restart_moontv() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            重启 MoonTV${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/moontv/docker-compose.yml" ]; then
        echo -e "${RED}未检测到 MoonTV 安装，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在重启 MoonTV 服务...${NC}"
    cd /opt/moontv
    
    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi
    
    $docker_compose_cmd restart
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ MoonTV 重启成功！${NC}"
    else
        echo -e "${RED}❌ MoonTV 重启失败。${NC}"
    fi
    read -p "按回车键继续..."
}

function view_moontv_status_logs() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          MoonTV 状态和日志${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/moontv/docker-compose.yml" ]; then
        echo -e "${RED}未检测到 MoonTV 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    cd /opt/moontv
    
    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi
    
    echo -e "${BLUE}容器状态:${NC}"
    $docker_compose_cmd ps
    
    echo -e "\n${BLUE}最近 20 行日志 (moontv-core):${NC}"
    $docker_compose_cmd logs --tail 20 moontv-core
    
    echo -e "${CYAN}=========================================${NC}"
    read -p "按回车键继续..."
}

function uninstall_moontv() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}             卸载 MoonTV${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/moontv/docker-compose.yml" ]; then
        echo -e "${YELLOW}未检测到 MoonTV 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${RED}⚠️  警告：此操作将删除 MoonTV 容器及数据！${NC}"
    echo ""
    echo -e "将删除以下内容："
    echo "1. MoonTV 容器 (moontv-core, moontv-kvrocks)"
    echo "2. Docker 网络 (moontv-network)"
    echo "3. 数据卷 (kvrocks-data, video-cache)"
    echo "4. 配置文件目录 (/opt/moontv)"
    echo ""
    
    read -p "确定要卸载 MoonTV 吗？(y/N): " confirm_uninstall
    if [[ ! "$confirm_uninstall" =~ ^[yY]$ ]]; then
        echo "卸载已取消。"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在停止并移除容器...${NC}"
    cd /opt/moontv
    
    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi
    
    $docker_compose_cmd down -v
    
    echo -e "${BLUE}正在清理网络...${NC}"
    # 尝试清理网络
    docker network rm moontv_moontv-network 2>/dev/null || true
    docker network rm moontv-network 2>/dev/null || true
    
    echo -e "${BLUE}正在清理安装目录...${NC}"
    cd / && rm -rf /opt/moontv
    
    echo -e "${GREEN}✅ MoonTV 卸载完成！${NC}"
    read -p "按回车键继续..."
}

function access_moontv_web() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        访问 MoonTV Web 界面${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if [ ! -f "/opt/moontv/docker-compose.yml" ]; then
        echo -e "${RED}❌ MoonTV 未安装，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi
    
    # 获取当前端口
    local host_port=$(grep -oP "ports:\s*-\s*'\K[0-9]+(?=:3000)" /opt/moontv/docker-compose.yml | head -1)
    host_port=${host_port:-3000}
    
    # 获取用户名
    local username=$(grep -oP "USERNAME=\K[^ ]+" /opt/moontv/docker-compose.yml | head -1)
    username=${username:-admin}
    
    IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
    
    echo -e "您的 MoonTV 访问地址为："
    [ -n "$ipv4" ] && echo -e "IPv4 地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
    [ -n "$ipv6" ] && echo -e "IPv6 地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
    echo ""
    echo -e "${CYAN}登录凭据：${NC}"
    echo -e "用户名: ${GREEN}${username}${NC}"
    echo -e "密码: ${YELLOW}(安装时设置，可在修改配置中查看)${NC}"
    echo ""
    echo -e "${YELLOW}提示：${NC}"
    echo "1. 如果忘记密码，可通过修改配置功能重置"
    echo "2. 首次访问可能需要等待容器完全启动"
    echo -e "${CYAN}=========================================${NC}"
    read -p "按回车键返回..."
}

# LibreTV 流媒体应用管理菜单
function libretv_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          LibreTV 流媒体应用管理${NC}"
        
        # 检查 Docker 是否运行
        if ! docker info > /dev/null 2>&1; then
            echo -e "${RED}⚠️  Docker 服务未运行或未安装！${NC}"
        else
            # 显示当前状态
            if docker ps -a --format '{{.Names}}' | grep -q "^libretv$"; then
                echo -e "          状态: ${GREEN}已部署${NC}"
            else
                echo -e "          状态: ${RED}未部署${NC}"
            fi
        fi
        
        echo -e "${CYAN}=========================================${NC}"
        echo "LibreTV 是一个轻量级的流媒体应用"
        echo "基于 Docker 容器部署，支持视频播放"
        echo ""
        echo -e " ${GREEN}1.${NC}  安装 LibreTV (自定义配置)"
        echo -e " ${GREEN}2.${NC}  启动 LibreTV"
        echo -e " ${GREEN}3.${NC}  停止 LibreTV"
        echo -e " ${GREEN}4.${NC}  重启 LibreTV"
        echo -e " ${GREEN}5.${NC}  查看 LibreTV 状态和日志"
        echo -e " ${GREEN}6.${NC}  修改 LibreTV 配置"
        echo -e " ${GREEN}7.${NC}  卸载 LibreTV"
        echo -e " ${GREEN}8.${NC}  访问 LibreTV Web 界面"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回应用中心菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-8): " libretv_choice

        case "$libretv_choice" in
            1) install_libretv ;;
            2) start_libretv ;;
            3) stop_libretv ;;
            4) restart_libretv ;;
            5) view_libretv_status_logs ;;
            6) modify_libretv_config ;;
            7) uninstall_libretv ;;
            8) access_libretv_web ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 2 ;;
        esac
    done
}

# 安装 LibreTV (自定义配置)
function install_libretv() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}           安装 LibreTV 流媒体应用${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! command -v docker &> /dev/null; then
        echo -e "${RED}未检测到 Docker，请先安装 Docker 环境。${NC}"
        echo "您可以通过应用中心的 Komari 管理菜单安装 Docker。"
        read -p "按回车键继续..."
        return
    fi

    # 检查容器是否已存在
    if docker ps -a --format '{{.Names}}' | grep -q "^libretv$"; then
        echo -e "${YELLOW}检测到 LibreTV 容器已存在。${NC}"
        read -p "是否重新部署？(这将删除现有配置) (y/N): " redeploy_choice
        if [[ ! "$redeploy_choice" =~ ^[yY]$ ]]; then
            return
        fi
        echo -e "${BLUE}正在停止并移除旧容器...${NC}"
        docker stop libretv &> /dev/null
        docker rm libretv &> /dev/null
    fi

    echo -e "${YELLOW}正在配置 LibreTV 安装参数...${NC}"
    echo ""

    # 获取自定义端口
    read -p "请输入宿主机映射端口 (默认 8899): " host_port
    host_port=${host_port:-8899}
    
    # 验证端口占用
    if command -v ss &> /dev/null; then
        if ss -tuln | grep -q ":${host_port} "; then
            echo -e "${RED}❌ 端口 ${host_port} 已被占用，请选择其他端口。${NC}"
            read -p "按回车键继续..."
            return
        fi
    fi

    # 获取自定义密码
    while true; do
        read -sp "请输入管理员密码 (默认 111111): " password
        echo ""
        password=${password:-111111}
        
        read -sp "请再次输入密码确认: " password_confirm
        echo ""
        
        if [ "$password" != "$password_confirm" ]; then
            echo -e "${RED}两次输入的密码不一致，请重新输入。${NC}"
        else
            break
        fi
    done

    echo ""
    read -p "是否启用自动更新？(y/N): " enable_auto_update
    auto_update="unless-stopped"
    if [[ "$enable_auto_update" =~ ^[yY]$ ]]; then
        echo -e "${GREEN}已启用自动更新${NC}"
    else
        auto_update="no"
        echo -e "${YELLOW}已禁用自动更新${NC}"
    fi

    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}安装配置确认：${NC}"
    echo -e "端口: ${GREEN}${host_port}${NC}"
    echo -e "密码: ${GREEN}********${NC}"
    echo -e "自动更新: ${GREEN}$([ "$auto_update" = "unless-stopped" ] && echo "是" || echo "否")${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "确认以上配置并开始安装？(y/N): " confirm_install
    if [[ ! "$confirm_install" =~ ^[yY]$ ]]; then
        echo "安装已取消。"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在准备安装目录...${NC}"
    mkdir -p /opt/libretv
    
    echo -e "${BLUE}正在拉取镜像...${NC}"
    docker pull bestzwei/libretv:latest

    echo -e "${BLUE}正在创建 Docker Compose 配置文件...${NC}"
    
    # 创建 docker-compose.yml
    cat > /opt/libretv/docker-compose.yml << EOF
services:
  libretv:
    image: bestzwei/libretv:latest
    container_name: libretv
    ports:
      - "${host_port}:8080"
    environment:
      - PASSWORD=${password}
    restart: ${auto_update}
EOF

    echo -e "${BLUE}正在启动 LibreTV 服务...${NC}"
    cd /opt/libretv
    
    # 使用兼容的 Docker Compose 命令
    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi
    
    $docker_compose_cmd up -d
    
    if [ $? -eq 0 ]; then
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        
        echo -e "${GREEN}✅ LibreTV 安装成功！${NC}"
        echo ""
        echo -e "${CYAN}访问信息：${NC}"
        [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
        [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
        echo ""
        echo -e "${CYAN}登录凭据：${NC}"
        echo -e "密码: ${GREEN}${password}${NC}"
        echo ""
        echo -e "${YELLOW}重要提示：${NC}"
        echo "1. 请妥善保管您的登录密码"
        echo "2. 首次访问可能需要等待容器完全启动"
        echo "3. 配置文件位置: /opt/libretv/docker-compose.yml"
        
        # 显示状态
        sleep 3
        echo ""
        echo -e "${BLUE}容器启动状态：${NC}"
        $docker_compose_cmd ps
    else
        echo -e "${RED}❌ LibreTV 安装失败，请检查以下内容：${NC}"
        echo "1. 检查 Docker 服务是否正常运行"
        echo "2. 检查端口 ${host_port} 是否被占用"
        echo "3. 查看详细错误日志:"
        $docker_compose_cmd logs --tail 20
    fi
    read -p "按回车键继续..."
}

# 启动 LibreTV
function start_libretv() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            启动 LibreTV${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/libretv/docker-compose.yml" ]; then
        echo -e "${RED}未检测到 LibreTV 安装，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在启动 LibreTV 服务...${NC}"
    cd /opt/libretv
    
    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi
    
    $docker_compose_cmd start
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ LibreTV 启动成功！${NC}"
    else
        echo -e "${RED}❌ LibreTV 启动失败。${NC}"
    fi
    read -p "按回车键继续..."
}

# 停止 LibreTV
function stop_libretv() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            停止 LibreTV${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/libretv/docker-compose.yml" ]; then
        echo -e "${RED}未检测到 LibreTV 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在停止 LibreTV 服务...${NC}"
    cd /opt/libretv
    
    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi
    
    $docker_compose_cmd stop
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ LibreTV 停止成功！${NC}"
    else
        echo -e "${RED}❌ LibreTV 停止失败。${NC}"
    fi
    read -p "按回车键继续..."
}

# 重启 LibreTV
function restart_libretv() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            重启 LibreTV${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/libretv/docker-compose.yml" ]; then
        echo -e "${RED}未检测到 LibreTV 安装，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在重启 LibreTV 服务...${NC}"
    cd /opt/libretv
    
    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi
    
    $docker_compose_cmd restart
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ LibreTV 重启成功！${NC}"
    else
        echo -e "${RED}❌ LibreTV 重启失败。${NC}"
    fi
    read -p "按回车键继续..."
}

# 查看 LibreTV 状态和日志
function view_libretv_status_logs() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          LibreTV 状态和日志${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/libretv/docker-compose.yml" ]; then
        echo -e "${RED}未检测到 LibreTV 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    cd /opt/libretv
    
    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi
    
    echo -e "${BLUE}容器状态:${NC}"
    $docker_compose_cmd ps
    
    echo -e "\n${BLUE}最近 30 行日志:${NC}"
    $docker_compose_cmd logs --tail 30
    
    echo -e "${CYAN}=========================================${NC}"
    read -p "按回车键继续..."
}

# 修改 LibreTV 配置
function modify_libretv_config() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}           修改 LibreTV 配置${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/libretv/docker-compose.yml" ]; then
        echo -e "${RED}未检测到 LibreTV 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${YELLOW}当前配置信息：${NC}"
    echo ""
    
    # 提取当前配置
    local current_port=$(grep -oP "ports:\s*-\s*\"\K[0-9]+(?=:8080)" /opt/libretv/docker-compose.yml | head -1)
    local current_restart=$(grep -oP "restart:\s*\K[^\s]+" /opt/libretv/docker-compose.yml | head -1)
    
    echo -e "当前端口: ${GREEN}${current_port}${NC}"
    echo -e "当前自动更新: ${GREEN}$([ "$current_restart" = "unless-stopped" ] && echo "启用" || echo "禁用")${NC}"
    
    echo ""
    echo -e "${YELLOW}修改选项：${NC}"
    echo "1. 修改端口"
    echo "2. 修改密码"
    echo "3. 切换自动更新状态"
    echo "4. 查看完整配置文件"
    echo "0. 返回"
    echo ""
    read -p "请选择操作: " config_choice

    case "$config_choice" in
        1)
            read -p "请输入新的宿主机端口: " new_port
            if [[ ! "$new_port" =~ ^[0-9]+$ ]] || [ "$new_port" -lt 1 ] || [ "$new_port" -gt 65535 ]; then
                echo -e "${RED}端口号无效。请输入 1-65535 之间的数字。${NC}"
                read -p "按回车键继续..."
                return
            fi
            
            # 验证端口占用
            if command -v ss &> /dev/null; then
                if ss -tuln | grep -q ":${new_port} "; then
                    echo -e "${RED}端口 ${new_port} 已被占用，请选择其他端口。${NC}"
                    read -p "按回车键继续..."
                    return
                fi
            fi
            
            # 停止容器
            cd /opt/libretv
            if docker compose version &> /dev/null; then
                docker_compose_cmd="docker compose"
            else
                docker_compose_cmd="docker-compose"
            fi
            $docker_compose_cmd stop
            
            # 更新配置文件
            sed -i "s/- \"${current_port}:8080\"/- \"${new_port}:8080\"/g" docker-compose.yml
            
            # 重新启动
            $docker_compose_cmd up -d
            
            IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
            
            echo -e "${GREEN}✅ 端口已修改为 ${new_port}${NC}"
            [ -n "$ipv4" ] && echo -e "新访问地址: ${YELLOW}http://${ipv4}:${new_port}${NC}"
            
            read -p "按回车键继续..."
            ;;
        2)
            while true; do
                read -sp "请输入新的密码: " new_password
                echo ""
                if [ -z "$new_password" ]; then
                    echo -e "${RED}密码不能为空，请重新输入。${NC}"
                    continue
                fi
                
                read -sp "请再次输入密码确认: " new_password_confirm
                echo ""
                
                if [ "$new_password" != "$new_password_confirm" ]; then
                    echo -e "${RED}两次输入的密码不一致，请重新输入。${NC}"
                else
                    break
                fi
            done
            
            # 停止容器
            cd /opt/libretv
            if docker compose version &> /dev/null; then
                docker_compose_cmd="docker compose"
            else
                docker_compose_cmd="docker-compose"
            fi
            $docker_compose_cmd stop
            
            # 更新配置文件
            sed -i "s/PASSWORD=.*/PASSWORD=${new_password}/g" docker-compose.yml
            
            # 重新启动
            $docker_compose_cmd up -d
            
            echo -e "${GREEN}✅ 密码已更新${NC}"
            echo -e "新密码: ${GREEN}${new_password}${NC}"
            
            read -p "按回车键继续..."
            ;;
        3)
            # 获取当前重启策略
            local new_restart="unless-stopped"
            if [ "$current_restart" = "unless-stopped" ]; then
                new_restart="no"
                echo -e "${YELLOW}当前已启用自动更新，将切换为禁用${NC}"
            else
                echo -e "${YELLOW}当前已禁用自动更新，将切换为启用${NC}"
            fi
            
            read -p "确认切换？(y/N): " confirm_switch
            if [[ ! "$confirm_switch" =~ ^[yY]$ ]]; then
                echo "操作已取消。"
                read -p "按回车键继续..."
                return
            fi
            
            # 停止容器
            cd /opt/libretv
            if docker compose version &> /dev/null; then
                docker_compose_cmd="docker compose"
            else
                docker_compose_cmd="docker-compose"
            fi
            $docker_compose_cmd stop
            
            # 更新配置文件
            sed -i "s/restart: ${current_restart}/restart: ${new_restart}/g" docker-compose.yml
            
            # 重新启动
            $docker_compose_cmd up -d
            
            echo -e "${GREEN}✅ 自动更新已${([ "$new_restart" = "unless-stopped" ] && echo "启用" || echo "禁用")}${NC}"
            
            read -p "按回车键继续..."
            ;;
        4)
            echo -e "${BLUE}完整配置文件内容:${NC}"
            echo ""
            cat /opt/libretv/docker-compose.yml
            echo ""
            read -p "按回车键继续..."
            return
            ;;
        0) return ;;
        *) echo -e "${RED}无效选择。${NC}"; read -p "按回车键继续..." ;;
    esac
}

# 卸载 LibreTV
function uninstall_libretv() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}             卸载 LibreTV${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/libretv/docker-compose.yml" ]; then
        echo -e "${YELLOW}未检测到 LibreTV 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${RED}⚠️  警告：此操作将删除 LibreTV 容器及配置！${NC}"
    echo ""
    echo -e "将删除以下内容："
    echo "1. LibreTV 容器 (libretv)"
    echo "2. 配置文件目录 (/opt/libretv)"
    echo ""
    
    read -p "确定要卸载 LibreTV 吗？(y/N): " confirm_uninstall
    if [[ ! "$confirm_uninstall" =~ ^[yY]$ ]]; then
        echo "卸载已取消。"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在停止并移除容器...${NC}"
    cd /opt/libretv
    
    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi
    
    $docker_compose_cmd down
    
    echo -e "${BLUE}正在清理安装目录...${NC}"
    cd / && rm -rf /opt/libretv
    
    echo -e "${GREEN}✅ LibreTV 卸载完成！${NC}"
    read -p "按回车键继续..."
}

# 访问 LibreTV Web 界面
function access_libretv_web() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        访问 LibreTV Web 界面${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if [ ! -f "/opt/libretv/docker-compose.yml" ]; then
        echo -e "${RED}❌ LibreTV 未安装，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi
    
    # 获取当前端口
    local host_port=$(grep -oP "ports:\s*-\s*\"\K[0-9]+(?=:8080)" /opt/libretv/docker-compose.yml | head -1)
    host_port=${host_port:-8899}
    
    # 检查容器状态
    local container_status=$(docker inspect -f '{{.State.Status}}' libretv 2>/dev/null || echo "未运行")
    local container_running=""
    if [ "$container_status" = "running" ]; then
        container_running="${GREEN}运行中${NC}"
        
        # 获取运行时间
        local start_time=$(docker inspect -f '{{.State.StartedAt}}' libretv 2>/dev/null)
        if [ -n "$start_time" ]; then
            local now=$(date +%s)
            local start=$(date -d "$start_time" +%s)
            local diff=$((now - start))
            local days=$((diff / 86400))
            local hours=$(((diff % 86400) / 3600))
            local minutes=$(((diff % 3600) / 60))
            local running_time=""
            [ $days -gt 0 ] && running_time="${days}天 "
            [ $hours -gt 0 ] && running_time="${running_time}${hours}小时 "
            running_time="${running_time}${minutes}分钟"
        fi
    else
        container_running="${RED}未运行${NC}"
    fi
    
    IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
    
    echo -e "您的 LibreTV 访问地址为："
    [ -n "$ipv4" ] && echo -e "IPv4 地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
    [ -n "$ipv6" ] && echo -e "IPv6 地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
    echo ""
    echo -e "${CYAN}容器状态：${NC}"
    echo -e "状态: ${container_running}"
    if [ -n "$running_time" ] && [ "$container_status" = "running" ]; then
        echo -e "已运行时间: ${GREEN}${running_time}${NC}"
    fi
    echo ""
    echo -e "${YELLOW}提示：${NC}"
    echo "1. 如果忘记密码，可通过修改配置功能重置"
    echo "2. 容器未运行时请先启动服务"
    echo -e "${CYAN}=========================================${NC}"
    read -p "按回车键返回..."
}

# FRP 内网穿透管理主菜单
function frp_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          FRP 内网穿透管理${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo "FRP 是一个高性能的反向代理应用，用于将内网服务暴露到公网"
        echo "支持 TCP/UDP/HTTP/HTTPS 等多种协议"
        echo ""
        echo -e "${YELLOW}当前状态：${NC}"
        
        # 检查 FRPS 状态
        if systemctl is-active --quiet frps 2>/dev/null; then
            echo -e "FRPS 服务端: ${GREEN}运行中${NC}"
        elif [ -f "/etc/systemd/system/frps.service" ] || [ -f "/etc/frp/frps.ini" ]; then
            echo -e "FRPS 服务端: ${YELLOW}已安装但未运行${NC}"
        else
            echo -e "FRPS 服务端: ${RED}未安装${NC}"
        fi
        
        # 检查 FRPC 状态
        if systemctl is-active --quiet frpc 2>/dev/null; then
            echo -e "FRPC 客户端: ${GREEN}运行中${NC}"
        elif [ -f "/etc/systemd/system/frpc.service" ] || [ -f "/etc/frp/frpc.ini" ]; then
            echo -e "FRPC 客户端: ${YELLOW}已安装但未运行${NC}"
        else
            echo -e "FRPC 客户端: ${RED}未安装${NC}"
        fi
        
        echo ""
        echo -e " ${GREEN}1.${NC}  FRPS 服务端管理（部署在公网VPS）"
        echo -e " ${GREEN}2.${NC}  FRPC 客户端管理（部署在内网设备）"
        echo -e " ${GREEN}3.${NC}  快速安装向导"
        echo -e " ${GREEN}4.${NC}  查看 FRP 版本和帮助"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回应用中心菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-4): " frp_choice

        case "$frp_choice" in
            1) frps_management ;;
            2) frpc_management ;;
            3) frp_quick_wizard ;;
            4) frp_info_help ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 2 ;;
        esac
    done
}

# FRPS 服务端管理菜单
function frps_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          FRPS 服务端管理${NC}"
        
        # 显示当前状态
        if systemctl is-active --quiet frps 2>/dev/null; then
            echo -e "          状态: ${GREEN}运行中${NC}"
        elif [ -f "/etc/systemd/system/frps.service" ]; then
            echo -e "          状态: ${YELLOW}已安装但未运行${NC}"
        else
            echo -e "          状态: ${RED}未安装${NC}"
        fi
        
        echo -e "${CYAN}=========================================${NC}"
        echo "FRPS 是 FRP 的服务端，运行在具有公网 IP 的服务器上"
        echo "用于接收来自内网客户端的连接请求"
        echo ""
        echo -e " ${GREEN}1.${NC}  安装/配置 FRPS 服务端"
        echo -e " ${GREEN}2.${NC}  启动 FRPS 服务端"
        echo -e " ${GREEN}3.${NC}  停止 FRPS 服务端"
        echo -e " ${GREEN}4.${NC}  重启 FRPS 服务端"
        echo -e " ${GREEN}5.${NC}  查看 FRPS 状态和日志"
        echo -e " ${GREEN}6.${NC}  修改 FRPS 配置"
        echo -e " ${GREEN}7.${NC}  卸载 FRPS 服务端"
        echo -e " ${GREEN}8.${NC}  查看 FRPS 仪表板信息"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-8): " frps_choice

        case "$frps_choice" in
            1) install_frps ;;
            2) start_frps ;;
            3) stop_frps ;;
            4) restart_frps ;;
            5) view_frps_status ;;
            6) modify_frps_config ;;
            7) uninstall_frps ;;
            8) view_frps_dashboard ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 2 ;;
        esac
    done
}

# FRPC 客户端管理菜单
function frpc_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          FRPC 客户端管理${NC}"
        
        # 显示当前状态
        if systemctl is-active --quiet frpc 2>/dev/null; then
            echo -e "          状态: ${GREEN}运行中${NC}"
        elif [ -f "/etc/systemd/system/frpc.service" ]; then
            echo -e "          状态: ${YELLOW}已安装但未运行${NC}"
        else
            echo -e "          状态: ${RED}未安装${NC}"
        fi
        
        echo -e "${CYAN}=========================================${NC}"
        echo "FRPC 是 FRP 的客户端，运行在内网设备上"
        echo "用于将内网服务暴露到公网服务器"
        echo ""
        echo -e " ${GREEN}1.${NC}  安装/配置 FRPC 客户端"
        echo -e " ${GREEN}2.${NC}  启动 FRPC 客户端"
        echo -e " ${GREEN}3.${NC}  停止 FRPC 客户端"
        echo -e " ${GREEN}4.${NC}  重启 FRPC 客户端"
        echo -e " ${GREEN}5.${NC}  查看 FRPC 状态和日志"
        echo -e " ${GREEN}6.${NC}  修改 FRPC 配置"
        echo -e " ${GREEN}7.${NC}  卸载 FRPC 客户端"
        echo -e " ${GREEN}8.${NC}  管理隧道配置"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-8): " frpc_choice

        case "$frpc_choice" in
            1) install_frpc ;;
            2) start_frpc ;;
            3) stop_frpc ;;
            4) restart_frpc ;;
            5) view_frpc_status ;;
            6) modify_frpc_config ;;
            7) uninstall_frpc ;;
            8) manage_tunnels ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 2 ;;
        esac
    done
}

# 安装/配置 FRPS 服务端
function install_frps() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          安装/配置 FRPS 服务端${NC}"
    echo -e "${CYAN}=========================================${NC}"

    # 检查是否已安装
    if [ -f "/etc/systemd/system/frps.service" ]; then
        echo -e "${YELLOW}检测到 FRPS 已安装。${NC}"
        read -p "是否重新安装？(这将覆盖现有配置) (y/N): " reinstall
        if [[ ! "$reinstall" =~ ^[yY]$ ]]; then
            return
        fi
    fi

    echo -e "${YELLOW}正在配置 FRPS 服务端...${NC}"
    echo ""

    # 获取 FRP 版本
    read -p "请输入 FRP 版本 (默认 v0.52.3，建议使用最新版): " frp_version
    frp_version=${frp_version:-"v0.52.3"}
    
    # 检测系统架构
    local arch=$(uname -m)
    case "$arch" in
        x86_64) arch="amd64" ;;
        aarch64) arch="arm64" ;;
        armv7l) arch="arm" ;;
        *) arch="amd64" ;;
    esac
    
    echo -e "检测到系统架构: ${GREEN}${arch}${NC}"
    
    # 获取基本配置
    read -p "请输入 FRPS 监听端口 (默认 7000): " bind_port
    bind_port=${bind_port:-7000}
    
    read -p "请输入 FRPS Dashboard 端口 (默认 7500): " dashboard_port
    dashboard_port=${dashboard_port:-7500}
    
    read -p "请输入 Dashboard 用户名 (默认 admin): " dashboard_user
    dashboard_user=${dashboard_user:-admin}
    
    while true; do
        read -sp "请输入 Dashboard 密码: " dashboard_pwd
        echo ""
        if [ -z "$dashboard_pwd" ]; then
            echo -e "${RED}密码不能为空，请重新输入。${NC}"
            continue
        fi
        
        read -sp "请再次输入密码确认: " dashboard_pwd_confirm
        echo ""
        
        if [ "$dashboard_pwd" != "$dashboard_pwd_confirm" ]; then
            echo -e "${RED}两次输入的密码不一致，请重新输入。${NC}"
        else
            break
        fi
    done
    
    read -p "请输入认证令牌 (可选，用于客户端连接认证): " token
    
    read -p "是否启用 HTTPS 支持？(y/N): " enable_https
    https_port=""
    if [[ "$enable_https" =~ ^[yY]$ ]]; then
        read -p "请输入 HTTPS 端口 (默认 7443): " https_port
        https_port=${https_port:-7443}
    fi
    
    read -p "是否启用 UDP 端口转发？(y/N): " enable_udp
    udp_port_range=""
    if [[ "$enable_udp" =~ ^[yY]$ ]]; then
        read -p "请输入 UDP 端口范围 (默认 7001-7500): " udp_port_range
        udp_port_range=${udp_port_range:-"7001-7500"}
    fi
    
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}安装配置确认：${NC}"
    echo -e "FRP 版本: ${GREEN}${frp_version}${NC}"
    echo -e "监听端口: ${GREEN}${bind_port}${NC}"
    echo -e "Dashboard 端口: ${GREEN}${dashboard_port}${NC}"
    echo -e "Dashboard 用户名: ${GREEN}${dashboard_user}${NC}"
    echo -e "Dashboard 密码: ${GREEN}********${NC}"
    if [ -n "$token" ]; then
        echo -e "认证令牌: ${GREEN}${token}${NC}"
    else
        echo -e "认证令牌: ${YELLOW}无${NC}"
    fi
    if [ -n "$https_port" ]; then
        echo -e "HTTPS 端口: ${GREEN}${https_port}${NC}"
    fi
    if [ -n "$udp_port_range" ]; then
        echo -e "UDP 端口范围: ${GREEN}${udp_port_range}${NC}"
    fi
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "确认以上配置并开始安装？(y/N): " confirm_install
    if [[ ! "$confirm_install" =~ ^[yY]$ ]]; then
        echo "安装已取消。"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}开始安装 FRPS 服务端...${NC}"
    
    # 创建安装目录
    mkdir -p /usr/local/frp
    cd /usr/local/frp
    
    # 下载 FRP
    echo "正在下载 FRP ${frp_version}..."
    local download_url="https://github.com/fatedier/frp/releases/download/${frp_version}/frp_${frp_version#v}_linux_${arch}.tar.gz"
    
    if ! curl -L -o frp.tar.gz "$download_url"; then
        echo -e "${RED}下载 FRP 失败，请检查网络连接或版本号。${NC}"
        read -p "按回车键继续..."
        return
    fi
    
    # 解压并安装
    echo "正在解压安装包..."
    tar -zxvf frp.tar.gz
    cd frp_${frp_version#v}_linux_${arch}
    
    # 复制二进制文件
    cp frps /usr/local/bin/
    chmod +x /usr/local/bin/frps
    
    # 创建配置文件目录
    mkdir -p /etc/frp
    
    # 生成配置文件
    echo "正在生成配置文件..."
    cat > /etc/frp/frps.ini << EOF
[common]
bind_port = ${bind_port}
bind_addr = 0.0.0.0

# Dashboard 配置
dashboard_port = ${dashboard_port}
dashboard_user = ${dashboard_user}
dashboard_pwd = ${dashboard_pwd}

# 认证令牌
EOF

    if [ -n "$token" ]; then
        echo "token = ${token}" >> /etc/frp/frps.ini
    fi
    
    if [ -n "$https_port" ]; then
        echo "vhost_https_port = ${https_port}" >> /etc/frp/frps.ini
    fi
    
    if [ -n "$udp_port_range" ]; then
        echo "udp_packet_size = 1500" >> /etc/frp/frps.ini
        # 这里简化处理，实际需要更复杂的 UDP 端口配置
    fi
    
    # 添加日志配置
    cat >> /etc/frp/frps.ini << EOF

# 日志配置
log_file = /var/log/frps.log
log_level = info
log_max_days = 3
EOF
    
    # 创建 systemd 服务文件
    echo "正在创建 systemd 服务..."
    cat > /etc/systemd/system/frps.service << EOF
[Unit]
Description=FRP Server (frps)
After=network.target

[Service]
Type=simple
User=root
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/frps -c /etc/frp/frps.ini
ExecReload=/usr/local/bin/frps reload -c /etc/frp/frps.ini

[Install]
WantedBy=multi-user.target
EOF
    
    # 创建日志文件
    touch /var/log/frps.log
    chmod 644 /var/log/frps.log
    
    # 重新加载 systemd
    systemctl daemon-reload
    
    # 启用并启动服务
    systemctl enable frps
    
    echo -e "${BLUE}正在启动 FRPS 服务...${NC}"
    systemctl start frps
    
    if systemctl is-active --quiet frps; then
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        
        echo -e "${GREEN}✅ FRPS 服务端安装成功！${NC}"
        echo ""
        echo -e "${CYAN}服务端配置信息：${NC}"
        echo -e "监听地址: ${GREEN}0.0.0.0:${bind_port}${NC}"
        [ -n "$ipv4" ] && echo -e "Dashboard 地址: ${YELLOW}http://${ipv4}:${dashboard_port}${NC}"
        [ -n "$ipv6" ] && echo -e "Dashboard 地址 (IPv6): ${YELLOW}http://[${ipv6}]:${dashboard_port}${NC}"
        echo -e "Dashboard 用户名: ${GREEN}${dashboard_user}${NC}"
        echo -e "Dashboard 密码: ${GREEN}${dashboard_pwd}${NC}"
        if [ -n "$token" ]; then
            echo -e "认证令牌: ${GREEN}${token}${NC}"
        fi
        echo ""
        echo -e "${CYAN}服务管理命令：${NC}"
        echo -e "启动: ${GREEN}systemctl start frps${NC}"
        echo -e "停止: ${GREEN}systemctl stop frps${NC}"
        echo -e "重启: ${GREEN}systemctl restart frps${NC}"
        echo -e "状态: ${GREEN}systemctl status frps${NC}"
        echo ""
        echo -e "${YELLOW}重要提示：${NC}"
        echo "1. 请确保防火墙已开放端口: ${bind_port}, ${dashboard_port}"
        echo "2. 配置文件位置: /etc/frp/frps.ini"
        echo "3. 日志文件位置: /var/log/frps.log"
        
        # 显示服务状态
        sleep 2
        echo ""
        echo -e "${BLUE}服务状态：${NC}"
        systemctl status frps --no-pager -l
    else
        echo -e "${RED}❌ FRPS 启动失败，请检查配置和日志。${NC}"
        echo "查看日志: journalctl -u frps -n 20"
    fi
    
    # 清理临时文件
    cd /usr/local/frp
    rm -rf frp_${frp_version#v}_linux_${arch} frp.tar.gz
    
    read -p "按回车键继续..."
}

# 启动 FRPS 服务端
function start_frps() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            启动 FRPS 服务端${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/etc/systemd/system/frps.service" ]; then
        echo -e "${RED}未检测到 FRPS 安装，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在启动 FRPS 服务...${NC}"
    systemctl start frps
    
    if systemctl is-active --quiet frps; then
        echo -e "${GREEN}✅ FRPS 启动成功！${NC}"
    else
        echo -e "${RED}❌ FRPS 启动失败。${NC}"
        echo "查看错误信息: systemctl status frps"
    fi
    read -p "按回车键继续..."
}

# 停止 FRPS 服务端
function stop_frps() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            停止 FRPS 服务端${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/etc/systemd/system/frps.service" ]; then
        echo -e "${RED}未检测到 FRPS 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在停止 FRPS 服务...${NC}"
    systemctl stop frps
    
    if ! systemctl is-active --quiet frps; then
        echo -e "${GREEN}✅ FRPS 停止成功！${NC}"
    else
        echo -e "${RED}❌ FRPS 停止失败。${NC}"
    fi
    read -p "按回车键继续..."
}

# 重启 FRPS 服务端
function restart_frps() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            重启 FRPS 服务端${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/etc/systemd/system/frps.service" ]; then
        echo -e "${RED}未检测到 FRPS 安装，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在重启 FRPS 服务...${NC}"
    systemctl restart frps
    
    if systemctl is-active --quiet frps; then
        echo -e "${GREEN}✅ FRPS 重启成功！${NC}"
    else
        echo -e "${RED}❌ FRPS 重启失败。${NC}"
    fi
    read -p "按回车键继续..."
}

# 查看 FRPS 状态和日志
function view_frps_status() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          FRPS 状态和日志${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/etc/systemd/system/frps.service" ]; then
        echo -e "${RED}未检测到 FRPS 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}服务状态：${NC}"
    systemctl status frps --no-pager
    
    echo -e "\n${BLUE}最近 50 行日志：${NC}"
    journalctl -u frps -n 50 --no-pager
    
    echo -e "${CYAN}=========================================${NC}"
    read -p "按回车键继续..."
}

# 修改 FRPS 配置
function modify_frps_config() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}           修改 FRPS 配置${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/etc/frp/frps.ini" ]; then
        echo -e "${RED}未检测到 FRPS 配置文件。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${YELLOW}当前配置信息：${NC}"
    echo ""
    
    # 显示当前配置摘要
    local bind_port=$(grep -oP 'bind_port\s*=\s*\K[0-9]+' /etc/frp/frps.ini 2>/dev/null | head -1)
    local dashboard_port=$(grep -oP 'dashboard_port\s*=\s*\K[0-9]+' /etc/frp/frps.ini 2>/dev/null | head -1)
    local dashboard_user=$(grep -oP 'dashboard_user\s*=\s*\K[^ ]+' /etc/frp/frps.ini 2>/dev/null | head -1)
    local token=$(grep -oP 'token\s*=\s*\K[^ ]+' /etc/frp/frps.ini 2>/dev/null | head -1)
    
    echo -e "监听端口: ${GREEN}${bind_port:-7000}${NC}"
    echo -e "Dashboard 端口: ${GREEN}${dashboard_port:-7500}${NC}"
    echo -e "Dashboard 用户名: ${GREEN}${dashboard_user:-admin}${NC}"
    if [ -n "$token" ]; then
        echo -e "认证令牌: ${GREEN}${token}${NC}"
    else
        echo -e "认证令牌: ${YELLOW}无${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}修改选项：${NC}"
    echo "1. 编辑配置文件 (手动修改)"
    echo "2. 修改 Dashboard 密码"
    echo "3. 修改监听端口"
    echo "4. 修改认证令牌"
    echo "5. 查看完整配置文件"
    echo "0. 返回"
    echo ""
    read -p "请选择操作: " config_choice

    case "$config_choice" in
        1)
            echo -e "${YELLOW}使用编辑器修改配置文件...${NC}"
            echo "保存后需要重启 FRPS 服务使更改生效。"
            read -p "按回车键继续..."
            
            # 使用 nano 或 vi 编辑
            if command -v nano &> /dev/null; then
                nano /etc/frp/frps.ini
            else
                vi /etc/frp/frps.ini
            fi
            
            read -p "是否现在重启 FRPS 服务使更改生效？(y/N): " restart_now
            if [[ "$restart_now" =~ ^[yY]$ ]]; then
                systemctl restart frps
                echo -e "${GREEN}FRPS 服务已重启。${NC}"
            fi
            ;;
        2)
            while true; do
                read -sp "请输入新的 Dashboard 密码: " new_pwd
                echo ""
                if [ -z "$new_pwd" ]; then
                    echo -e "${RED}密码不能为空，请重新输入。${NC}"
                    continue
                fi
                
                read -sp "请再次输入密码确认: " new_pwd_confirm
                echo ""
                
                if [ "$new_pwd" != "$new_pwd_confirm" ]; then
                    echo -e "${RED}两次输入的密码不一致，请重新输入。${NC}"
                else
                    break
                fi
            done
            
            # 停止服务
            systemctl stop frps
            
            # 更新配置文件
            if grep -q "dashboard_pwd" /etc/frp/frps.ini; then
                sed -i "s/^dashboard_pwd\s*=.*/dashboard_pwd = ${new_pwd}/" /etc/frp/frps.ini
            else
                # 如果没有该配置，找到 dashboard_user 行后插入
                sed -i "/dashboard_user/a dashboard_pwd = ${new_pwd}" /etc/frp/frps.ini
            fi
            
            # 重新启动
            systemctl start frps
            
            echo -e "${GREEN}✅ Dashboard 密码已更新${NC}"
            ;;
        3)
            read -p "请输入新的监听端口: " new_port
            if [[ ! "$new_port" =~ ^[0-9]+$ ]] || [ "$new_port" -lt 1 ] || [ "$new_port" -gt 65535 ]; then
                echo -e "${RED}端口号无效。请输入 1-65535 之间的数字。${NC}"
                read -p "按回车键继续..."
                return
            fi
            
            # 停止服务
            systemctl stop frps
            
            # 更新配置文件
            sed -i "s/^bind_port\s*=.*/bind_port = ${new_port}/" /etc/frp/frps.ini
            
            # 重新启动
            systemctl start frps
            
            echo -e "${GREEN}✅ 监听端口已修改为 ${new_port}${NC}"
            echo -e "${YELLOW}请确保防火墙已开放新端口 ${new_port}${NC}"
            ;;
        4)
            read -p "请输入新的认证令牌 (留空则删除令牌): " new_token
            
            # 停止服务
            systemctl stop frps
            
            if [ -z "$new_token" ]; then
                # 删除令牌配置
                sed -i '/^token\s*=.*/d' /etc/frp/frps.ini
                echo -e "${GREEN}✅ 认证令牌已删除${NC}"
            else
                # 更新或添加令牌
                if grep -q "^token\s*=" /etc/frp/frps.ini; then
                    sed -i "s/^token\s*=.*/token = ${new_token}/" /etc/frp/frps.ini
                else
                    # 在 common 段添加
                    sed -i "/^\[common\]/a token = ${new_token}" /etc/frp/frps.ini
                fi
                echo -e "${GREEN}✅ 认证令牌已更新${NC}"
            fi
            
            # 重新启动
            systemctl start frps
            ;;
        5)
            echo -e "${BLUE}完整配置文件内容:${NC}"
            echo ""
            cat /etc/frp/frps.ini
            echo ""
            read -p "按回车键继续..."
            return
            ;;
        0) return ;;
        *) echo -e "${RED}无效选择。${NC}" ;;
    esac
    
    read -p "按回车键继续..."
}

# 卸载 FRPS 服务端
function uninstall_frps() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}             卸载 FRPS${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/etc/systemd/system/frps.service" ]; then
        echo -e "${YELLOW}未检测到 FRPS 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${RED}⚠️  警告：此操作将删除 FRPS 服务及所有配置！${NC}"
    echo ""
    echo -e "将删除以下内容："
    echo "1. FRPS 二进制文件 (/usr/local/bin/frps)"
    echo "2. 配置文件 (/etc/frp/frps.ini)"
    echo "3. 日志文件 (/var/log/frps.log)"
    echo "4. systemd 服务文件"
    echo ""
    
    read -p "确定要卸载 FRPS 吗？(y/N): " confirm_uninstall
    if [[ ! "$confirm_uninstall" =~ ^[yY]$ ]]; then
        echo "卸载已取消。"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在停止服务...${NC}"
    systemctl stop frps
    systemctl disable frps
    
    echo -e "${BLUE}正在删除文件...${NC}"
    rm -f /usr/local/bin/frps
    rm -f /etc/frp/frps.ini
    rm -f /var/log/frps.log
    rm -f /etc/systemd/system/frps.service
    
    # 重新加载 systemd
    systemctl daemon-reload
    
    echo -e "${GREEN}✅ FRPS 卸载完成！${NC}"
    read -p "按回车键继续..."
}

# 查看 FRPS 仪表板信息
function view_frps_dashboard() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        FRPS 仪表板信息${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if [ ! -f "/etc/frp/frps.ini" ]; then
        echo -e "${RED}未检测到 FRPS 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi
    
    # 从配置文件读取信息
    local bind_port=$(grep -oP 'bind_port\s*=\s*\K[0-9]+' /etc/frp/frps.ini 2>/dev/null | head -1)
    local dashboard_port=$(grep -oP 'dashboard_port\s*=\s*\K[0-9]+' /etc/frp/frps.ini 2>/dev/null | head -1)
    local dashboard_user=$(grep -oP 'dashboard_user\s*=\s*\K[^ ]+' /etc/frp/frps.ini 2>/dev/null | head -1)
    
    IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
    
    echo -e "FRPS 仪表板访问信息："
    [ -n "$ipv4" ] && echo -e "地址: ${YELLOW}http://${ipv4}:${dashboard_port:-7500}${NC}"
    [ -n "$ipv6" ] && echo -e "地址 (IPv6): ${YELLOW}http://[${ipv6}]:${dashboard_port:-7500}${NC}"
    echo -e "用户名: ${GREEN}${dashboard_user:-admin}${NC}"
    echo -e "密码: ${YELLOW}(安装时设置，可在修改配置中查看)${NC}"
    
    # 尝试获取统计信息
    if systemctl is-active --quiet frps; then
        echo ""
        echo -e "${CYAN}服务状态：${NC}"
        
        # 获取运行时间
        local uptime=$(systemctl show frps --property=ActiveEnterTimestamp --value 2>/dev/null)
        if [ -n "$uptime" ]; then
            local now=$(date +%s)
            local start=$(date -d "$uptime" +%s 2>/dev/null || echo $now)
            local diff=$((now - start))
            local days=$((diff / 86400))
            local hours=$(((diff % 86400) / 3600))
            local minutes=$(((diff % 3600) / 60))
            
            echo -e "运行时间: ${GREEN}"
            [ $days -gt 0 ] && echo -n "${days}天 "
            [ $hours -gt 0 ] && echo -n "${hours}小时 "
            echo "${minutes}分钟${NC}"
        fi
        
        # 获取客户端连接数（简化版本，实际需要解析日志或使用API）
        echo -e "服务状态: ${GREEN}运行中${NC}"
        echo -e "监听端口: ${GREEN}${bind_port:-7000}${NC}"
    else
        echo -e "\n服务状态: ${RED}未运行${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}提示：${NC}"
    echo "1. 如果忘记密码，可通过修改配置功能重置"
    echo "2. 请确保防火墙已开放端口 ${dashboard_port:-7500}"
    echo -e "${CYAN}=========================================${NC}"
    read -p "按回车键返回..."
}

# 安装/配置 FRPC 客户端
function install_frpc() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          安装/配置 FRPC 客户端${NC}"
    echo -e "${CYAN}=========================================${NC}"

    # 检查是否已安装
    if [ -f "/etc/systemd/system/frpc.service" ]; then
        echo -e "${YELLOW}检测到 FRPC 已安装。${NC}"
        read -p "是否重新安装？(这将覆盖现有配置) (y/N): " reinstall
        if [[ ! "$reinstall" =~ ^[yY]$ ]]; then
            return
        fi
    fi

    echo -e "${YELLOW}请选择配置方式：${NC}"
    echo "1. 快速配置（使用默认模板）"
    echo "2. 手动配置（编辑配置文件）"
    echo "3. 隧道向导（逐步配置）"
    echo ""
    read -p "请选择 (1-3): " config_method

    case "$config_method" in
        1) quick_config_frpc ;;
        2) manual_config_frpc ;;
        3) tunnel_wizard_frpc ;;
        *) echo -e "${RED}无效的选择。${NC}"; return ;;
    esac
}

# 快速配置 FRPC
function quick_config_frpc() {
    echo -e "${BLUE}快速配置 FRPC 客户端...${NC}"
    
    read -p "请输入 FRPS 服务端地址 (IP或域名): " server_addr
    read -p "请输入 FRPS 服务端端口 (默认 7000): " server_port
    server_port=${server_port:-7000}
    
    read -p "请输入认证令牌 (如果服务端设置了): " token
    
    # 检测系统架构
    local arch=$(uname -m)
    case "$arch" in
        x86_64) arch="amd64" ;;
        aarch64) arch="arm64" ;;
        armv7l) arch="arm" ;;
        *) arch="amd64" ;;
    esac
    
    echo -e "检测到系统架构: ${GREEN}${arch}${NC}"
    
    # 获取 FRP 版本
    read -p "请输入 FRP 版本 (默认 v0.52.3): " frp_version
    frp_version=${frp_version:-"v0.52.3"}
    
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}安装配置确认：${NC}"
    echo -e "服务端地址: ${GREEN}${server_addr}${NC}"
    echo -e "服务端端口: ${GREEN}${server_port}${NC}"
    if [ -n "$token" ]; then
        echo -e "认证令牌: ${GREEN}${token}${NC}"
    else
        echo -e "认证令牌: ${YELLOW}无${NC}"
    fi
    echo -e "FRP 版本: ${GREEN}${frp_version}${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "确认以上配置并开始安装？(y/N): " confirm_install
    if [[ ! "$confirm_install" =~ ^[yY]$ ]]; then
        echo "安装已取消。"
        return
    fi

    # 执行安装
    install_frpc_binary "$frp_version" "$arch" "$server_addr" "$server_port" "$token"
}

# 隧道向导配置 FRPC
function tunnel_wizard_frpc() {
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          FRPC 隧道向导${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    read -p "请输入 FRPS 服务端地址（例如：your_vps_ip）: " server_addr
    read -p "请输入 FRPS 服务端端口（默认 7000）: " server_port
    server_port=${server_port:-7000}
    
    read -p "请输入令牌（如果服务端设置了）: " token
    
    local tunnels=()
    local tunnel_count=0
    
    while true; do
        echo ""
        echo -e "${YELLOW}隧道配置 #$((tunnel_count + 1))${NC}"
        echo ""
        echo "请选择隧道类型："
        echo "1. TCP端口映射"
        echo "2. HTTP/HTTPS网站代理"
        echo "3. SSH远程访问"
        echo "4. RDP远程桌面"
        echo "5. 其他TCP服务"
        echo "0. 完成配置"
        echo ""
        read -p "请选择 (0-5): " tunnel_type
        
        if [ "$tunnel_type" = "0" ]; then
            break
        fi
        
        if [ "$tunnel_type" -lt 1 ] || [ "$tunnel_type" -gt 5 ]; then
            echo -e "${RED}无效的选择。${NC}"
            continue
        fi
        
        # 获取隧道名称
        read -p "请输入隧道名称（英文，如：web, ssh, rdp）: " tunnel_name
        
        case "$tunnel_type" in
            1|3|4|5)  # TCP类型
                read -p "请输入本地服务IP（默认 127.0.0.1）: " local_ip
                local_ip=${local_ip:-127.0.0.1}
                
                read -p "请输入本地服务端口: " local_port
                read -p "请输入远程端口（在服务端监听的端口）: " remote_port
                
                tunnels+=("tcp:${tunnel_name}:${local_ip}:${local_port}:${remote_port}")
                ;;
            2)  # HTTP类型
                read -p "请输入本地服务IP（默认 127.0.0.1）: " local_ip
                local_ip=${local_ip:-127.0.0.1}
                
                read -p "请输入本地服务端口: " local_port
                read -p "请输入自定义子域名（可选，用于访问）: " subdomain
                read -p "请输入自定义域名（可选，留空使用子域名）: " custom_domain
                read -p "使用HTTPS？(y/N): " use_https
                
                local http_type="http"
                if [[ "$use_https" =~ ^[yY]$ ]]; then
                    http_type="https"
                fi
                
                tunnels+=("${http_type}:${tunnel_name}:${local_ip}:${local_port}:${subdomain}:${custom_domain}")
                ;;
        esac
        
        tunnel_count=$((tunnel_count + 1))
        
        if [ $tunnel_count -ge 10 ]; then
            echo -e "${YELLOW}已达到最大隧道数量限制 (10)。${NC}"
            break
        fi
    done
    
    if [ $tunnel_count -eq 0 ]; then
        echo -e "${RED}未配置任何隧道。${NC}"
        return
    fi
    
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}安装配置确认：${NC}"
    echo -e "服务端地址: ${GREEN}${server_addr}${NC}"
    echo -e "服务端端口: ${GREEN}${server_port}${NC}"
    if [ -n "$token" ]; then
        echo -e "认证令牌: ${GREEN}${token}${NC}"
    fi
    echo -e "隧道数量: ${GREEN}${tunnel_count}${NC}"
    echo ""
    
    for i in "${!tunnels[@]}"; do
        echo -e "隧道 $((i+1)): ${GREEN}${tunnels[$i]}${NC}"
    done
    
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "确认以上配置并开始安装？(y/N): " confirm_install
    if [[ ! "$confirm_install" =~ ^[yY]$ ]]; then
        echo "安装已取消。"
        return
    fi
    
    # 检测系统架构
    local arch=$(uname -m)
    case "$arch" in
        x86_64) arch="amd64" ;;
        aarch64) arch="arm64" ;;
        armv7l) arch="arm" ;;
        *) arch="amd64" ;;
    esac
    
    # 获取 FRP 版本
    read -p "请输入 FRP 版本 (默认 v0.52.3): " frp_version
    frp_version=${frp_version:-"v0.52.3"}
    
    # 执行安装
    install_frpc_with_tunnels "$frp_version" "$arch" "$server_addr" "$server_port" "$token" "${tunnels[@]}"
}

# 安装 FRPC 二进制文件和基本配置
function install_frpc_binary() {
    local frp_version="$1"
    local arch="$2"
    local server_addr="$3"
    local server_port="$4"
    local token="$5"
    
    echo -e "${BLUE}开始安装 FRPC 客户端...${NC}"
    
    # 创建安装目录
    mkdir -p /usr/local/frp
    cd /usr/local/frp
    
    # 下载 FRP
    echo "正在下载 FRP ${frp_version}..."
    local download_url="https://github.com/fatedier/frp/releases/download/${frp_version}/frp_${frp_version#v}_linux_${arch}.tar.gz"
    
    if ! curl -L -o frp.tar.gz "$download_url"; then
        echo -e "${RED}下载 FRP 失败，请检查网络连接或版本号。${NC}"
        read -p "按回车键继续..."
        return
    fi
    
    # 解压并安装
    echo "正在解压安装包..."
    tar -zxvf frp.tar.gz
    cd frp_${frp_version#v}_linux_${arch}
    
    # 复制二进制文件
    cp frpc /usr/local/bin/
    chmod +x /usr/local/bin/frpc
    
    # 创建配置文件目录
    mkdir -p /etc/frp
    
    # 生成基本配置文件
    echo "正在生成配置文件..."
    cat > /etc/frp/frpc.ini << EOF
[common]
server_addr = ${server_addr}
server_port = ${server_port}
EOF

    if [ -n "$token" ]; then
        echo "token = ${token}" >> /etc/frp/frpc.ini
    fi
    
    cat >> /etc/frp/frpc.ini << EOF

# 日志配置
log_file = /var/log/frpc.log
log_level = info
log_max_days = 3

# 管理配置
admin_addr = 127.0.0.1
admin_port = 7400
admin_user = admin
admin_pwd = admin
EOF
    
    # 创建 systemd 服务文件
    echo "正在创建 systemd 服务..."
    cat > /etc/systemd/system/frpc.service << EOF
[Unit]
Description=FRP Client (frpc)
After=network.target

[Service]
Type=simple
User=root
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/frpc -c /etc/frp/frpc.ini
ExecReload=/usr/local/bin/frpc reload -c /etc/frp/frpc.ini

[Install]
WantedBy=multi-user.target
EOF
    
    # 创建日志文件
    touch /var/log/frpc.log
    chmod 644 /var/log/frpc.log
    
    # 重新加载 systemd
    systemctl daemon-reload
    
    # 启用并启动服务
    systemctl enable frpc
    
    echo -e "${BLUE}正在启动 FRPC 服务...${NC}"
    systemctl start frpc
    
    if systemctl is-active --quiet frpc; then
        echo -e "${GREEN}✅ FRPC 客户端安装成功！${NC}"
        echo ""
        echo -e "${CYAN}客户端配置信息：${NC}"
        echo -e "服务端地址: ${GREEN}${server_addr}:${server_port}${NC}"
        if [ -n "$token" ]; then
            echo -e "认证令牌: ${GREEN}${token}${NC}"
        fi
        echo ""
        echo -e "${CYAN}服务管理命令：${NC}"
        echo -e "启动: ${GREEN}systemctl start frpc${NC}"
        echo -e "停止: ${GREEN}systemctl stop frpc${NC}"
        echo -e "重启: ${GREEN}systemctl restart frpc${NC}"
        echo -e "状态: ${GREEN}systemctl status frpc${NC}"
        echo ""
        echo -e "${YELLOW}重要提示：${NC}"
        echo "1. 请确保服务端地址和端口正确"
        echo "2. 配置文件位置: /etc/frp/frpc.ini"
        echo "3. 需要手动添加隧道配置后才能使用"
        echo "4. 本地管理地址: http://127.0.0.1:7400 (用户名/密码: admin/admin)"
        
        # 显示服务状态
        sleep 2
        echo ""
        echo -e "${BLUE}服务状态：${NC}"
        systemctl status frpc --no-pager -l
    else
        echo -e "${RED}❌ FRPC 启动失败，请检查配置和日志。${NC}"
        echo "查看日志: journalctl -u frpc -n 20"
    fi
    
    # 清理临时文件
    cd /usr/local/frp
    rm -rf frp_${frp_version#v}_linux_${arch} frp.tar.gz
    
    read -p "按回车键继续..."
}

# 安装 FRPC 并配置隧道
function install_frpc_with_tunnels() {
    local frp_version="$1"
    local arch="$2"
    local server_addr="$3"
    local server_port="$4"
    local token="$5"
    shift 5
    local tunnels=("$@")
    
    echo -e "${BLUE}开始安装 FRPC 客户端...${NC}"
    
    # 创建安装目录
    mkdir -p /usr/local/frp
    cd /usr/local/frp
    
    # 下载 FRP
    echo "正在下载 FRP ${frp_version}..."
    local download_url="https://github.com/fatedier/frp/releases/download/${frp_version}/frp_${frp_version#v}_linux_${arch}.tar.gz"
    
    if ! curl -L -o frp.tar.gz "$download_url"; then
        echo -e "${RED}下载 FRP 失败，请检查网络连接或版本号。${NC}"
        read -p "按回车键继续..."
        return
    fi
    
    # 解压并安装
    echo "正在解压安装包..."
    tar -zxvf frp.tar.gz
    cd frp_${frp_version#v}_linux_${arch}
    
    # 复制二进制文件
    cp frpc /usr/local/bin/
    chmod +x /usr/local/bin/frpc
    
    # 创建配置文件目录
    mkdir -p /etc/frp
    
    # 生成配置文件
    echo "正在生成配置文件..."
    cat > /etc/frp/frpc.ini << EOF
[common]
server_addr = ${server_addr}
server_port = ${server_port}
EOF

    if [ -n "$token" ]; then
        echo "token = ${token}" >> /etc/frp/frpc.ini
    fi
    
    cat >> /etc/frp/frpc.ini << EOF

# 日志配置
log_file = /var/log/frpc.log
log_level = info
log_max_days = 3

# 管理配置
admin_addr = 127.0.0.1
admin_port = 7400
admin_user = admin
admin_pwd = admin
EOF
    
    # 添加隧道配置
    local tunnel_index=0
    for tunnel in "${tunnels[@]}"; do
        tunnel_index=$((tunnel_index + 1))
        
        IFS=':' read -r tunnel_type tunnel_name local_ip local_port remote_port extra1 extra2 <<< "$tunnel"
        
        case "$tunnel_type" in
            tcp)
                cat >> /etc/frp/frpc.ini << EOF

# 隧道 ${tunnel_index}: ${tunnel_name}
[${tunnel_name}]
type = tcp
local_ip = ${local_ip}
local_port = ${local_port}
remote_port = ${remote_port}
EOF
                ;;
            http)
                cat >> /etc/frp/frpc.ini << EOF

# 隧道 ${tunnel_index}: ${tunnel_name}
[${tunnel_name}]
type = http
local_ip = ${local_ip}
local_port = ${local_port}
subdomain = ${remote_port}
EOF
                if [ -n "$extra2" ]; then
                    echo "custom_domains = ${extra2}" >> /etc/frp/frpc.ini
                fi
                ;;
            https)
                cat >> /etc/frp/frpc.ini << EOF

# 隧道 ${tunnel_index}: ${tunnel_name}
[${tunnel_name}]
type = https
local_ip = ${local_ip}
local_port = ${local_port}
subdomain = ${remote_port}
EOF
                if [ -n "$extra2" ]; then
                    echo "custom_domains = ${extra2}" >> /etc/frp/frpc.ini
                fi
                ;;
        esac
    done
    
    # 创建 systemd 服务文件
    echo "正在创建 systemd 服务..."
    cat > /etc/systemd/system/frpc.service << EOF
[Unit]
Description=FRP Client (frpc)
After=network.target

[Service]
Type=simple
User=root
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/frpc -c /etc/frp/frpc.ini
ExecReload=/usr/local/bin/frpc reload -c /etc/frp/frpc.ini

[Install]
WantedBy=multi-user.target
EOF
    
    # 创建日志文件
    touch /var/log/frpc.log
    chmod 644 /var/log/frpc.log
    
    # 重新加载 systemd
    systemctl daemon-reload
    
    # 启用并启动服务
    systemctl enable frpc
    
    echo -e "${BLUE}正在启动 FRPC 服务...${NC}"
    systemctl start frpc
    
    if systemctl is-active --quiet frpc; then
        echo -e "${GREEN}✅ FRPC 客户端安装成功！${NC}"
        echo ""
        echo -e "${CYAN}客户端配置信息：${NC}"
        echo -e "服务端地址: ${GREEN}${server_addr}:${server_port}${NC}"
        if [ -n "$token" ]; then
            echo -e "认证令牌: ${GREEN}${token}${NC}"
        fi
        echo -e "隧道数量: ${GREEN}${#tunnels[@]}${NC}"
        echo ""
        
        # 显示隧道信息
        echo -e "${CYAN}隧道配置：${NC}"
        for i in "${!tunnels[@]}"; do
            IFS=':' read -r tunnel_type tunnel_name local_ip local_port remote_port extra1 extra2 <<< "${tunnels[$i]}"
            echo -e "隧道 $((i+1)): ${GREEN}${tunnel_name}${NC}"
            case "$tunnel_type" in
                tcp)
                    echo -e "   类型: TCP, 本地: ${local_ip}:${local_port}, 远程端口: ${remote_port}"
                    ;;
                http)
                    echo -e "   类型: HTTP, 本地: ${local_ip}:${local_port}, 子域名: ${remote_port}"
                    if [ -n "$extra2" ]; then
                        echo -e "   自定义域名: ${extra2}"
                    fi
                    ;;
                https)
                    echo -e "   类型: HTTPS, 本地: ${local_ip}:${local_port}, 子域名: ${remote_port}"
                    if [ -n "$extra2" ]; then
                        echo -e "   自定义域名: ${extra2}"
                    fi
                    ;;
            esac
        done
        
        echo ""
        echo -e "${CYAN}服务管理命令：${NC}"
        echo -e "启动: ${GREEN}systemctl start frpc${NC}"
        echo -e "停止: ${GREEN}systemctl stop frpc${NC}"
        echo -e "重启: ${GREEN}systemctl restart frpc${NC}"
        echo -e "状态: ${GREEN}systemctl status frpc${NC}"
        
        # 显示服务状态
        sleep 2
        echo ""
        echo -e "${BLUE}服务状态：${NC}"
        systemctl status frpc --no-pager -l
    else
        echo -e "${RED}❌ FRPC 启动失败，请检查配置和日志。${NC}"
        echo "查看日志: journalctl -u frpc -n 20"
    fi
    
    # 清理临时文件
    cd /usr/local/frp
    rm -rf frp_${frp_version#v}_linux_${arch} frp.tar.gz
    
    read -p "按回车键继续..."
}

# 手动配置 FRPC
function manual_config_frpc() {
    echo -e "${BLUE}手动配置 FRPC 客户端...${NC}"
    echo "请手动编辑配置文件，完成后将自动安装。"
    echo ""
    
    # 检测系统架构
    local arch=$(uname -m)
    case "$arch" in
        x86_64) arch="amd64" ;;
        aarch64) arch="arm64" ;;
        armv7l) arch="arm" ;;
        *) arch="amd64" ;;
    esac
    
    # 获取 FRP 版本
    read -p "请输入 FRP 版本 (默认 v0.52.3): " frp_version
    frp_version=${frp_version:-"v0.52.3"}
    
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}安装配置确认：${NC}"
    echo -e "FRP 版本: ${GREEN}${frp_version}${NC}"
    echo -e "系统架构: ${GREEN}${arch}${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "确认并开始安装？(y/N): " confirm_install
    if [[ ! "$confirm_install" =~ ^[yY]$ ]]; then
        echo "安装已取消。"
        return
    fi
    
    # 下载并安装二进制文件
    echo -e "${BLUE}开始安装 FRPC 客户端...${NC}"
    
    # 创建安装目录
    mkdir -p /usr/local/frp
    cd /usr/local/frp
    
    # 下载 FRP
    echo "正在下载 FRP ${frp_version}..."
    local download_url="https://github.com/fatedier/frp/releases/download/${frp_version}/frp_${frp_version#v}_linux_${arch}.tar.gz"
    
    if ! curl -L -o frp.tar.gz "$download_url"; then
        echo -e "${RED}下载 FRP 失败，请检查网络连接或版本号。${NC}"
        read -p "按回车键继续..."
        return
    fi
    
    # 解压并安装
    echo "正在解压安装包..."
    tar -zxvf frp.tar.gz
    cd frp_${frp_version#v}_linux_${arch}
    
    # 复制二进制文件
    cp frpc /usr/local/bin/
    chmod +x /usr/local/bin/frpc
    
    # 创建配置文件目录
    mkdir -p /etc/frp
    
    # 询问是否使用现有配置文件
    if [ -f "/etc/frp/frpc.ini" ]; then
        read -p "检测到现有配置文件，是否使用？(y/N): " use_existing
        if [[ ! "$use_existing" =~ ^[yY]$ ]]; then
            # 创建新配置文件
            echo "请手动编辑配置文件 /etc/frp/frpc.ini"
            cat > /etc/frp/frpc.ini << EOF
[common]
server_addr = 127.0.0.1
server_port = 7000

# 日志配置
log_file = /var/log/frpc.log
log_level = info
log_max_days = 3

# 管理配置
admin_addr = 127.0.0.1
admin_port = 7400
admin_user = admin
admin_pwd = admin

# 在此添加隧道配置
# [ssh]
# type = tcp
# local_ip = 127.0.0.1
# local_port = 22
# remote_port = 2222
EOF
        fi
    else
        # 创建新配置文件
        echo "请手动编辑配置文件 /etc/frp/frpc.ini"
        cat > /etc/frp/frpc.ini << EOF
[common]
server_addr = 127.0.0.1
server_port = 7000

# 日志配置
log_file = /var/log/frpc.log
log_level = info
log_max_days = 3

# 管理配置
admin_addr = 127.0.0.1
admin_port = 7400
admin_user = admin
admin_pwd = admin

# 在此添加隧道配置
# [ssh]
# type = tcp
# local_ip = 127.0.0.1
# local_port = 22
# remote_port = 2222
EOF
    fi
    
    # 使用编辑器打开配置文件
    if command -v nano &> /dev/null; then
        nano /etc/frp/frpc.ini
    else
        vi /etc/frp/frpc.ini
    fi
    
    # 创建 systemd 服务文件
    echo "正在创建 systemd 服务..."
    cat > /etc/systemd/system/frpc.service << EOF
[Unit]
Description=FRP Client (frpc)
After=network.target

[Service]
Type=simple
User=root
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/frpc -c /etc/frp/frpc.ini
ExecReload=/usr/local/bin/frpc reload -c /etc/frp/frpc.ini

[Install]
WantedBy=multi-user.target
EOF
    
    # 创建日志文件
    touch /var/log/frpc.log
    chmod 644 /var/log/frpc.log
    
    # 重新加载 systemd
    systemctl daemon-reload
    
    # 启用并启动服务
    systemctl enable frpc
    
    echo -e "${BLUE}正在启动 FRPC 服务...${NC}"
    systemctl start frpc
    
    if systemctl is-active --quiet frpc; then
        echo -e "${GREEN}✅ FRPC 客户端安装成功！${NC}"
        echo ""
        echo -e "${CYAN}客户端配置信息：${NC}"
        echo -e "配置文件位置: ${GREEN}/etc/frp/frpc.ini${NC}"
        echo -e "日志文件位置: ${GREEN}/var/log/frpc.log${NC}"
        echo ""
        echo -e "${CYAN}服务管理命令：${NC}"
        echo -e "启动: ${GREEN}systemctl start frpc${NC}"
        echo -e "停止: ${GREEN}systemctl stop frpc${NC}"
        echo -e "重启: ${GREEN}systemctl restart frpc${NC}"
        echo -e "状态: ${GREEN}systemctl status frpc${NC}"
        echo ""
        echo -e "${YELLOW}重要提示：${NC}"
        echo "1. 请确保配置文件正确无误"
        echo "2. 本地管理地址: http://127.0.0.1:7400 (用户名/密码: admin/admin)"
        echo "3. 可在配置文件中添加更多隧道"
        
        # 显示服务状态
        sleep 2
        echo ""
        echo -e "${BLUE}服务状态：${NC}"
        systemctl status frpc --no-pager -l
    else
        echo -e "${RED}❌ FRPC 启动失败，请检查配置和日志。${NC}"
        echo "查看日志: journalctl -u frpc -n 20"
    fi
    
    # 清理临时文件
    cd /usr/local/frp
    rm -rf frp_${frp_version#v}_linux_${arch} frp.tar.gz
    
    read -p "按回车键继续..."
}

# 启动 FRPC 客户端
function start_frpc() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            启动 FRPC 客户端${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/etc/systemd/system/frpc.service" ]; then
        echo -e "${RED}未检测到 FRPC 安装，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在启动 FRPC 服务...${NC}"
    systemctl start frpc
    
    if systemctl is-active --quiet frpc; then
        echo -e "${GREEN}✅ FRPC 启动成功！${NC}"
    else
        echo -e "${RED}❌ FRPC 启动失败。${NC}"
        echo "查看错误信息: systemctl status frpc"
    fi
    read -p "按回车键继续..."
}

# 停止 FRPC 客户端
function stop_frpc() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            停止 FRPC 客户端${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/etc/systemd/system/frpc.service" ]; then
        echo -e "${RED}未检测到 FRPC 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在停止 FRPC 服务...${NC}"
    systemctl stop frpc
    
    if ! systemctl is-active --quiet frpc; then
        echo -e "${GREEN}✅ FRPC 停止成功！${NC}"
    else
        echo -e "${RED}❌ FRPC 停止失败。${NC}"
    fi
    read -p "按回车键继续..."
}

# 重启 FRPC 客户端
function restart_frpc() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            重启 FRPC 客户端${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/etc/systemd/system/frpc.service" ]; then
        echo -e "${RED}未检测到 FRPC 安装，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在重启 FRPC 服务...${NC}"
    systemctl restart frpc
    
    if systemctl is-active --quiet frpc; then
        echo -e "${GREEN}✅ FRPC 重启成功！${NC}"
    else
        echo -e "${RED}❌ FRPC 重启失败。${NC}"
    fi
    read -p "按回车键继续..."
}

# 查看 FRPC 状态和日志
function view_frpc_status() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          FRPC 状态和日志${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/etc/systemd/system/frpc.service" ]; then
        echo -e "${RED}未检测到 FRPC 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}服务状态：${NC}"
    systemctl status frpc --no-pager
    
    echo -e "\n${BLUE}最近 50 行日志：${NC}"
    journalctl -u frpc -n 50 --no-pager
    
    echo -e "${CYAN}=========================================${NC}"
    read -p "按回车键继续..."
}

# 修改 FRPC 配置
function modify_frpc_config() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}           修改 FRPC 配置${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/etc/frp/frpc.ini" ]; then
        echo -e "${RED}未检测到 FRPC 配置文件。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${YELLOW}当前配置信息：${NC}"
    echo ""
    
    # 显示基本配置
    local server_addr=$(grep -oP 'server_addr\s*=\s*\K[^ ]+' /etc/frp/frpc.ini 2>/dev/null | head -1)
    local server_port=$(grep -oP 'server_port\s*=\s*\K[0-9]+' /etc/frp/frpc.ini 2>/dev/null | head -1)
    local token=$(grep -oP 'token\s*=\s*\K[^ ]+' /etc/frp/frpc.ini 2>/dev/null | head -1)
    
    # 统计隧道数量
    local tunnel_count=$(grep -c '^\[' /etc/frp/frpc.ini 2>/dev/null || echo 0)
    tunnel_count=$((tunnel_count - 1))  # 减去 [common] 部分
    
    echo -e "服务端地址: ${GREEN}${server_addr:-127.0.0.1}${NC}"
    echo -e "服务端端口: ${GREEN}${server_port:-7000}${NC}"
    if [ -n "$token" ]; then
        echo -e "认证令牌: ${GREEN}${token}${NC}"
    else
        echo -e "认证令牌: ${YELLOW}无${NC}"
    fi
    echo -e "隧道数量: ${GREEN}${tunnel_count}${NC}"
    
    echo ""
    echo -e "${YELLOW}修改选项：${NC}"
    echo "1. 编辑配置文件 (手动修改)"
    echo "2. 修改服务端连接信息"
    echo "3. 添加新的隧道"
    echo "4. 编辑现有隧道"
    echo "5. 删除隧道"
    echo "6. 查看完整配置文件"
    echo "0. 返回"
    echo ""
    read -p "请选择操作: " config_choice

    case "$config_choice" in
        1)
            echo -e "${YELLOW}使用编辑器修改配置文件...${NC}"
            echo "保存后需要重启 FRPC 服务使更改生效。"
            read -p "按回车键继续..."
            
            # 使用 nano 或 vi 编辑
            if command -v nano &> /dev/null; then
                nano /etc/frp/frpc.ini
            else
                vi /etc/frp/frpc.ini
            fi
            
            read -p "是否现在重启 FRPC 服务使更改生效？(y/N): " restart_now
            if [[ "$restart_now" =~ ^[yY]$ ]]; then
                systemctl restart frpc
                echo -e "${GREEN}FRPC 服务已重启。${NC}"
            fi
            ;;
        2)
            read -p "请输入新的服务端地址: " new_server_addr
            read -p "请输入新的服务端端口: " new_server_port
            
            if [ -z "$new_server_addr" ] || [ -z "$new_server_port" ]; then
                echo -e "${RED}地址和端口不能为空。${NC}"
                read -p "按回车键继续..."
                return
            fi
            
            # 停止服务
            systemctl stop frpc
            
            # 更新配置文件
            sed -i "s/^server_addr\s*=.*/server_addr = ${new_server_addr}/" /etc/frp/frpc.ini
            sed -i "s/^server_port\s*=.*/server_port = ${new_server_port}/" /etc/frp/frpc.ini
            
            # 重新启动
            systemctl start frpc
            
            echo -e "${GREEN}✅ 服务端连接信息已更新${NC}"
            ;;
        3)
            echo -e "${BLUE}添加新隧道...${NC}"
            echo ""
            
            read -p "请输入隧道名称（英文，如：web, ssh）: " tunnel_name
            read -p "请输入隧道类型（tcp, http, https）: " tunnel_type
            read -p "请输入本地IP地址（默认 127.0.0.1）: " local_ip
            local_ip=${local_ip:-127.0.0.1}
            read -p "请输入本地端口: " local_port
            read -p "请输入远程端口（对于TCP类型）或子域名（对于HTTP/HTTPS类型）: " remote_value
            
            # 停止服务
            systemctl stop frpc
            
            # 添加隧道配置
            cat >> /etc/frp/frpc.ini << EOF

# 新增隧道: ${tunnel_name}
[${tunnel_name}]
type = ${tunnel_type}
local_ip = ${local_ip}
local_port = ${local_port}
EOF
            
            if [ "$tunnel_type" = "tcp" ]; then
                echo "remote_port = ${remote_value}" >> /etc/frp/frpc.ini
            elif [ "$tunnel_type" = "http" ] || [ "$tunnel_type" = "https" ]; then
                echo "subdomain = ${remote_value}" >> /etc/frp/frpc.ini
                read -p "请输入自定义域名（可选，留空跳过）: " custom_domain
                if [ -n "$custom_domain" ]; then
                    echo "custom_domains = ${custom_domain}" >> /etc/frp/frpc.ini
                fi
            fi
            
            # 重新启动
            systemctl start frpc
            
            echo -e "${GREEN}✅ 隧道 ${tunnel_name} 已添加${NC}"
            ;;
        4)
            echo -e "${BLUE}编辑现有隧道...${NC}"
            echo ""
            
            # 列出所有隧道
            local tunnels=($(grep -oP '^\K\[\w+\]' /etc/frp/frpc.ini 2>/dev/null | tr -d '[]' | grep -v common))
            
            if [ ${#tunnels[@]} -eq 0 ]; then
                echo -e "${YELLOW}没有找到隧道配置。${NC}"
                read -p "按回车键继续..."
                return
            fi
            
            echo "可用的隧道："
            for i in "${!tunnels[@]}"; do
                echo "$((i+1)). ${tunnels[$i]}"
            done
            
            read -p "请选择要编辑的隧道编号: " tunnel_num
            
            if [ "$tunnel_num" -lt 1 ] || [ "$tunnel_num" -gt ${#tunnels[@]} ]; then
                echo -e "${RED}无效的选择。${NC}"
                read -p "按回车键继续..."
                return
            fi
            
            local tunnel_name="${tunnels[$((tunnel_num-1))]}"
            
            echo -e "${YELLOW}隧道 ${tunnel_name} 的当前配置：${NC}"
            sed -n "/^\[${tunnel_name}\]/,/^\[/p" /etc/frp/frpc.ini | head -20
            
            echo ""
            echo "请手动编辑配置文件。"
            read -p "按回车键打开编辑器..."
            
            # 停止服务
            systemctl stop frpc
            
            # 使用编辑器打开
            if command -v nano &> /dev/null; then
                nano /etc/frp/frpc.ini
            else
                vi /etc/frp/frpc.ini
            fi
            
            # 重新启动
            systemctl start frpc
            
            echo -e "${GREEN}✅ 隧道 ${tunnel_name} 配置已更新${NC}"
            ;;
        5)
            echo -e "${BLUE}删除隧道...${NC}"
            echo ""
            
            # 列出所有隧道
            local tunnels=($(grep -oP '^\K\[\w+\]' /etc/frp/frpc.ini 2>/dev/null | tr -d '[]' | grep -v common))
            
            if [ ${#tunnels[@]} -eq 0 ]; then
                echo -e "${YELLOW}没有找到隧道配置。${NC}"
                read -p "按回车键继续..."
                return
            fi
            
            echo "可用的隧道："
            for i in "${!tunnels[@]}"; do
                echo "$((i+1)). ${tunnels[$i]}"
            done
            
            read -p "请选择要删除的隧道编号: " tunnel_num
            
            if [ "$tunnel_num" -lt 1 ] || [ "$tunnel_num" -gt ${#tunnels[@]} ]; then
                echo -e "${RED}无效的选择。${NC}"
                read -p "按回车键继续..."
                return
            fi
            
            local tunnel_name="${tunnels[$((tunnel_num-1))]}"
            
            read -p "确定要删除隧道 ${tunnel_name} 吗？(y/N): " confirm_delete
            if [[ ! "$confirm_delete" =~ ^[yY]$ ]]; then
                echo "删除已取消。"
                return
            fi
            
            # 停止服务
            systemctl stop frpc
            
            # 删除隧道配置
            # 找到隧道开始的行
            local start_line=$(grep -n "^\[${tunnel_name}\]" /etc/frp/frpc.ini | cut -d: -f1)
            
            if [ -n "$start_line" ]; then
                # 找到下一个隧道开始的行
                local next_line=$(sed -n "$((start_line+1)),$ p" /etc/frp/frpc.ini | grep -n '^\[' | head -1 | cut -d: -f1)
                
                if [ -n "$next_line" ]; then
                    # 删除从 start_line 到 (start_line + next_line - 2) 的行
                    sed -i "${start_line},$((start_line + next_line - 2))d" /etc/frp/frpc.ini
                else
                    # 删除从 start_line 到文件末尾的行
                    sed -i "${start_line},$ d" /etc/frp/frpc.ini
                fi
                
                # 删除可能的空行
                sed -i '${/^$/d;}' /etc/frp/frpc.ini
                
                echo -e "${GREEN}✅ 隧道 ${tunnel_name} 已删除${NC}"
            else
                echo -e "${RED}找不到隧道配置。${NC}"
            fi
            
            # 重新启动
            systemctl start frpc
            ;;
        6)
            echo -e "${BLUE}完整配置文件内容:${NC}"
            echo ""
            cat /etc/frp/frpc.ini
            echo ""
            read -p "按回车键继续..."
            return
            ;;
        0) return ;;
        *) echo -e "${RED}无效选择。${NC}" ;;
    esac
    
    read -p "按回车键继续..."
}

# 管理隧道配置
function manage_tunnels() {
    modify_frpc_config
}

# 卸载 FRPC 客户端
function uninstall_frpc() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}             卸载 FRPC${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/etc/systemd/system/frpc.service" ]; then
        echo -e "${YELLOW}未检测到 FRPC 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${RED}⚠️  警告：此操作将删除 FRPC 客户端及所有配置！${NC}"
    echo ""
    echo -e "将删除以下内容："
    echo "1. FRPC 二进制文件 (/usr/local/bin/frpc)"
    echo "2. 配置文件 (/etc/frp/frpc.ini)"
    echo "3. 日志文件 (/var/log/frpc.log)"
    echo "4. systemd 服务文件"
    echo ""
    
    read -p "确定要卸载 FRPC 吗？(y/N): " confirm_uninstall
    if [[ ! "$confirm_uninstall" =~ ^[yY]$ ]]; then
        echo "卸载已取消。"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在停止服务...${NC}"
    systemctl stop frpc
    systemctl disable frpc
    
    echo -e "${BLUE}正在删除文件...${NC}"
    rm -f /usr/local/bin/frpc
    rm -f /etc/frp/frpc.ini
    rm -f /var/log/frpc.log
    rm -f /etc/systemd/system/frpc.service
    
    # 重新加载 systemd
    systemctl daemon-reload
    
    echo -e "${GREEN}✅ FRPC 卸载完成！${NC}"
    read -p "按回车键继续..."
}

# FRP 快速安装向导
function frp_quick_wizard() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          FRP 快速安装向导${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    echo -e "请选择要安装的组件："
    echo "1. 仅安装 FRPS 服务端（公网服务器）"
    echo "2. 仅安装 FRPC 客户端（内网设备）"
    echo "3. 同时安装 FRPS 和 FRPC（测试环境）"
    echo "0. 返回"
    echo ""
    read -p "请选择 (0-3): " install_type
    
    case "$install_type" in
        1)
            echo -e "${BLUE}开始安装 FRPS 服务端...${NC}"
            # 使用默认配置快速安装
            quick_install_frps
            ;;
        2)
            echo -e "${BLUE}开始安装 FRPC 客户端...${NC}"
            # 使用默认配置快速安装
            quick_install_frpc
            ;;
        3)
            echo -e "${BLUE}开始同时安装 FRPS 和 FRPC...${NC}"
            # 安装 FRPS
            quick_install_frps
            
            echo ""
            echo -e "${BLUE}继续安装 FRPC...${NC}"
            # 安装 FRPC
            quick_install_frpc
            ;;
        0) return ;;
        *) echo -e "${RED}无效的选择。${NC}" ;;
    esac
    
    read -p "按回车键继续..."
}

# 快速安装 FRPS
function quick_install_frps() {
    # 检测系统架构
    local arch=$(uname -m)
    case "$arch" in
        x86_64) arch="amd64" ;;
        aarch64) arch="arm64" ;;
        armv7l) arch="arm" ;;
        *) arch="amd64" ;;
    esac
    
    # 使用默认版本
    local frp_version="v0.52.3"
    
    echo -e "${BLUE}使用默认配置安装 FRPS...${NC}"
    echo "版本: ${frp_version}"
    echo "架构: ${arch}"
    
    read -p "确认安装？(y/N): " confirm
    if [[ ! "$confirm" =~ ^[yY]$ ]]; then
        echo "安装已取消。"
        return
    fi
    
    # 调用安装函数，使用默认配置
    install_frps_binary "$frp_version" "$arch" "7000" "7500" "admin" "admin123" "my_token_123"
}

# 快速安装 FRPC
function quick_install_frpc() {
    # 检测系统架构
    local arch=$(uname -m)
    case "$arch" in
        x86_64) arch="amd64" ;;
        aarch64) arch="arm64" ;;
        armv7l) arch="arm" ;;
        *) arch="amd64" ;;
    esac
    
    # 使用默认版本
    local frp_version="v0.52.3"
    
    echo -e "${BLUE}使用默认配置安装 FRPC...${NC}"
    echo "版本: ${frp_version}"
    echo "架构: ${arch}"
    
    read -p "请输入 FRPS 服务端地址: " server_addr
    if [ -z "$server_addr" ]; then
        echo -e "${RED}服务端地址不能为空。${NC}"
        return
    fi
    
    read -p "确认安装？(y/N): " confirm
    if [[ ! "$confirm" =~ ^[yY]$ ]]; then
        echo "安装已取消。"
        return
    fi
    
    # 调用安装函数，使用默认配置
    install_frpc_binary "$frp_version" "$arch" "$server_addr" "7000" ""
}

# FRP 信息与帮助
function frp_info_help() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        FRP 版本信息和帮助${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    echo -e "${YELLOW}FRP (Fast Reverse Proxy) 简介：${NC}"
    echo "FRP 是一个高性能的反向代理应用，可以帮助您将内网服务暴露到公网"
    echo "支持 TCP、UDP、HTTP、HTTPS 等多种协议"
    echo ""
    
    echo -e "${YELLOW}版本信息：${NC}"
    echo "当前脚本版本: 1.0"
    echo "推荐 FRP 版本: v0.52.3"
    echo "官方网站: https://github.com/fatedier/frp"
    echo ""
    
    echo -e "${YELLOW}基本使用流程：${NC}"
    echo "1. 在公网服务器上安装 FRPS（服务端）"
    echo "2. 在内网设备上安装 FRPC（客户端）"
    echo "3. 配置 FRPC 连接到 FRPS"
    echo "4. 在 FRPC 上配置需要暴露的服务"
    echo "5. 通过 FRPS 的公网地址访问内网服务"
    echo ""
    
    echo -e "${YELLOW}常用端口：${NC}"
    echo "FRPS 默认监听端口: 7000"
    echo "FRPS Dashboard 端口: 7500"
    echo "FRPC 管理端口: 7400"
    echo ""
    
    echo -e "${YELLOW}配置文件位置：${NC}"
    echo "FRPS 配置文件: /etc/frp/frps.ini"
    echo "FRPC 配置文件: /etc/frp/frpc.ini"
    echo ""
    
    echo -e "${YELLOW}服务管理命令：${NC}"
    echo "启动服务: systemctl start frps/frpc"
    echo "停止服务: systemctl stop frps/frpc"
    echo "重启服务: systemctl restart frps/frpc"
    echo "查看状态: systemctl status frps/frpc"
    echo "查看日志: journalctl -u frps/frpc -f"
    echo ""
    
    echo -e "${YELLOW}防火墙配置：${NC}"
    echo "请确保防火墙已开放以下端口："
    echo "- FRPS 监听端口（默认 7000）"
    echo "- FRPS Dashboard 端口（默认 7500）"
    echo "- 需要暴露的服务端口"
    echo ""
    
    echo -e "${CYAN}=========================================${NC}"
    read -p "按回车键返回..."
}