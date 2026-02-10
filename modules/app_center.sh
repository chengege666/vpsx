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
        echo -e " ${GREEN}16.${NC} Nginx 重定向配置"
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
            16) nginx_redirect_manager ;;
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


function nginx_redirect_manager() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          Nginx 重定向配置管理${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo "提供各种 Nginx 重定向配置的一键生成和部署"
        echo ""
        
        # 检查 Nginx 状态
        if command -v nginx &> /dev/null; then
            nginx_status=$(systemctl is-active nginx 2>/dev/null || echo "unknown")
            if [ "$nginx_status" = "active" ]; then
                echo -e "Nginx 状态: ${GREEN}运行中${NC}"
            else
                echo -e "Nginx 状态: ${YELLOW}未运行${NC}"
            fi
        else
            echo -e "Nginx 状态: ${RED}未安装${NC}"
        fi
        
        echo ""
        echo -e "${YELLOW}可用的重定向类型：${NC}"
        echo "1.  HTTP -> HTTPS 强制重定向"
        echo "2.  www 与非 www 标准化"
        echo "3.  域名永久重定向 (301)"
        echo "4.  域名临时重定向 (302)"
        echo "5.  路径重定向 (URL Rewrite)"
        echo "6.  多域名重定向到主域名"
        echo "7.  旧网站迁移到新网站"
        echo "8.  移动设备重定向"
        echo "9.  国家/地区重定向"
        echo "10. 文件扩展名重定向"
        echo ""
        echo -e "${GREEN}管理功能：${NC}"
        echo "11. 查看当前重定向配置"
        echo "12. 备份 Nginx 配置"
        echo "13. 恢复 Nginx 配置"
        echo "14. 测试重定向规则"
        echo "15. 批量重定向生成器"
        echo ""
        echo -e "${CYAN}工具功能：${NC}"
        echo -e "${GREEN}16.${NC} 安装/更新 Nginx"
        echo "17. 查看 Nginx 错误日志"
        echo "18. 验证 Nginx 配置"
        echo "19. 重载 Nginx 配置"
        echo "20. Nginx 配置文件编辑器"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC} 返回应用中心菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-20): " redirect_choice

        case "$redirect_choice" in
            1) nginx_http_to_https ;;
            2) nginx_www_redirect ;;
            3) nginx_301_redirect ;;
            4) nginx_302_redirect ;;
            5) nginx_path_redirect ;;
            6) nginx_multi_domain_redirect ;;
            7) nginx_site_migration ;;
            8) nginx_mobile_redirect ;;
            9) nginx_geo_redirect ;;
            10) nginx_extension_redirect ;;
            11) view_nginx_redirects ;;
            12) backup_nginx_config ;;
            13) restore_nginx_config ;;
            14) test_redirect_rules ;;
            15) batch_redirect_generator ;;
            16) install_update_nginx ;;
            17) view_nginx_logs ;;
            18) verify_nginx_config ;;
            19) reload_nginx ;;
            20) edit_nginx_config ;;
            0) break ;;
            *) echo -e "${RED}无效的选择！${NC}"; sleep 2 ;;
        esac
    done
}

# =========================================
# 具体功能实现
# =========================================

# 1. HTTP -> HTTPS 强制重定向
function nginx_http_to_https() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}      HTTP 强制跳转到 HTTPS${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    echo -e "${YELLOW}此功能将为您的网站配置 HTTPS 强制重定向${NC}"
    echo ""
    
    read -p "请输入您的域名 (例如: example.com): " domain
    if [ -z "$domain" ]; then
        echo -e "${RED}域名不能为空${NC}"
        read -p "按回车键继续..."
        return
    fi
    
    # 检查域名是否已经配置了SSL
    echo -e "${BLUE}正在检查 SSL 证书...${NC}"
    
    # 确定Nginx配置目录
    local nginx_conf_dir="/etc/nginx"
    local sites_available="/etc/nginx/sites-available"
    local sites_enabled="/etc/nginx/sites-enabled"
    local conf_d="/etc/nginx/conf.d"
    
    local config_file=""
    
    # 查找域名配置文件
    if [ -d "$sites_available" ]; then
        config_file=$(find "$sites_available" -type f -name "*$domain*" | head -1)
        if [ -n "$config_file" ]; then
            echo -e "找到配置文件: ${GREEN}$config_file${NC}"
        fi
    fi
    
    if [ -z "$config_file" ] && [ -d "$conf_d" ]; then
        config_file=$(find "$conf_d" -type f -name "*$domain*" | head -1)
        if [ -n "$config_file" ]; then
            echo -e "找到配置文件: ${GREEN}$config_file${NC}"
        fi
    fi
    
    if [ -z "$config_file" ]; then
        read -p "未找到域名配置文件，是否创建新的配置文件？(y/N): " create_new
        if [[ ! "$create_new" =~ ^[yY]$ ]]; then
            return
        fi
        
        read -p "请输入配置文件名称 (默认: $domain): " config_name
        config_name=${config_name:-"$domain"}
        
        if [ -d "$sites_available" ]; then
            config_file="$sites_available/$config_name"
        else
            config_file="$conf_d/$config_name.conf"
        fi
    fi
    
    # 创建HTTP到HTTPS重定向配置
    local temp_file=$(mktemp)
    
    cat > "$temp_file" << EOF
# HTTP to HTTPS redirect for $domain
server {
    listen 80;
    listen [::]:80;
    server_name $domain www.$domain;
    
    # 记录访问日志
    access_log /var/log/nginx/${domain}_http_access.log;
    error_log /var/log/nginx/${domain}_http_error.log;
    
    # 永久重定向到HTTPS (301)
    return 301 https://\$host\$request_uri;
}

# HTTPS 配置
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name $domain www.$domain;
    
    # SSL证书配置（请根据实际情况修改）
    ssl_certificate /etc/ssl/certs/${domain}.crt;
    ssl_certificate_key /etc/ssl/private/${domain}.key;
    
    # SSL优化配置
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    
    # HSTS (可选，谨慎启用)
    # add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    
    # 记录访问日志
    access_log /var/log/nginx/${domain}_https_access.log;
    error_log /var/log/nginx/${domain}_https_error.log;
    
    # 网站根目录（请根据实际情况修改）
    root /var/www/$domain;
    index index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
    
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}生成的配置内容：${NC}"
    echo ""
    cat "$temp_file"
    echo ""
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "是否应用此配置？(y/N): " apply_config
    if [[ "$apply_config" =~ ^[yY]$ ]]; then
        # 备份原始配置
        backup_nginx_single_config "$config_file"
        
        # 写入新配置
        cp "$temp_file" "$config_file"
        chmod 644 "$config_file"
        
        # 启用站点（如果是sites-available结构）
        if [ -d "$sites_enabled" ] && [ -f "$sites_available/$config_name" ]; then
            ln -sf "$sites_available/$config_name" "$sites_enabled/$config_name" 2>/dev/null
        fi
        
        # 测试配置
        if verify_nginx_config_silent; then
            read -p "配置验证成功，是否立即重载 Nginx？(y/N): " reload_now
            if [[ "$reload_now" =~ ^[yY]$ ]]; then
                reload_nginx_silent
                echo -e "${GREEN}✅ HTTP到HTTPS重定向已启用！${NC}"
            else
                echo -e "${YELLOW}配置已保存但未重载，请手动重载Nginx生效${NC}"
            fi
        else
            echo -e "${RED}配置验证失败，已恢复备份${NC}"
            restore_nginx_single_config "$config_file"
        fi
    else
        echo "配置未应用。"
    fi
    
    rm -f "$temp_file"
    read -p "按回车键继续..."
}

# 2. www 与非 www 标准化
function nginx_www_redirect() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}      www 与非 www 域名标准化${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    echo -e "${YELLOW}请选择重定向方向：${NC}"
    echo "1. 将 www 重定向到非 www (推荐)"
    echo "2. 将非 www 重定向到 www"
    echo ""
    read -p "请选择 (1-2): " www_choice
    
    case "$www_choice" in
        1)
            redirect_from="www"
            redirect_to="non-www"
            ;;
        2)
            redirect_from="non-www"
            redirect_to="www"
            ;;
        *)
            echo -e "${RED}无效的选择${NC}"
            return
            ;;
    esac
    
    read -p "请输入您的域名 (例如: example.com): " domain
    if [ -z "$domain" ]; then
        echo -e "${RED}域名不能为空${NC}"
        return
    fi
    
    # 创建配置
    local temp_file=$(mktemp)
    
    if [ "$www_choice" = "1" ]; then
        # www -> non-www
        cat > "$temp_file" << EOF
# Redirect www to non-www for $domain
server {
    listen 80;
    listen [::]:80;
    server_name www.$domain;
    
    # 记录访问日志
    access_log /var/log/nginx/www_${domain}_redirect.log;
    
    # 永久重定向到非www (301)
    return 301 http://$domain\$request_uri;
}

server {
    listen 80;
    listen [::]:80;
    server_name $domain;
    
    # 主站点配置
    root /var/www/$domain;
    index index.html index.htm;
    
    # 日志配置
    access_log /var/log/nginx/${domain}_access.log;
    error_log /var/log/nginx/${domain}_error.log;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
    else
        # non-www -> www
        cat > "$temp_file" << EOF
# Redirect non-www to www for $domain
server {
    listen 80;
    listen [::]:80;
    server_name $domain;
    
    # 记录访问日志
    access_log /var/log/nginx/${domain}_redirect.log;
    
    # 永久重定向到www (301)
    return 301 http://www.$domain\$request_uri;
}

server {
    listen 80;
    listen [::]:80;
    server_name www.$domain;
    
    # 主站点配置
    root /var/www/$domain;
    index index.html index.htm;
    
    # 日志配置
    access_log /var/log/nginx/www_${domain}_access.log;
    error_log /var/log/nginx/www_${domain}_error.log;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
    fi
    
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}生成的配置内容：${NC}"
    echo ""
    cat "$temp_file"
    echo ""
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "是否保存此配置到文件？(y/N): " save_config
    if [[ "$save_config" =~ ^[yY]$ ]]; then
        local config_dir="/etc/nginx/conf.d"
        local config_file="$config_dir/www_redirect_$domain.conf"
        
        # 备份
        backup_nginx_single_config "$config_file"
        
        # 保存
        cp "$temp_file" "$config_file"
        chmod 644 "$config_file"
        
        echo -e "${GREEN}配置已保存到: $config_file${NC}"
        echo -e "${YELLOW}请手动将此配置包含到您的Nginx主配置中${NC}"
    fi
    
    rm -f "$temp_file"
    read -p "按回车键继续..."
}

# 3. 域名永久重定向 (301)
function nginx_301_redirect() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        域名永久重定向 (301)${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    echo -e "${YELLOW}配置永久重定向 (301)${NC}"
    echo ""
    
    read -p "请输入源域名 (旧域名): " from_domain
    read -p "请输入目标域名 (新域名): " to_domain
    read -p "是否保留路径？(Y/n): " keep_path
    keep_path=${keep_path:-"Y"}
    
    local temp_file=$(mktemp)
    
    cat > "$temp_file" << EOF
# 301 Permanent Redirect: $from_domain -> $to_domain
server {
    listen 80;
    listen [::]:80;
    server_name $from_domain www.$from_domain;
    
    # 访问日志
    access_log /var/log/nginx/${from_domain}_redirect.log;
    
    # 301 永久重定向
EOF
    
    if [[ "$keep_path" =~ ^[yY]$ ]]; then
        echo "    return 301 http://$to_domain\$request_uri;" >> "$temp_file"
    else
        echo "    return 301 http://$to_domain;" >> "$temp_file"
    fi
    
    cat >> "$temp_file" << EOF
}

# 可选: HTTPS 重定向配置
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name $from_domain www.$from_domain;
    
    # SSL证书（如果旧域名有证书）
    ssl_certificate /etc/ssl/certs/${from_domain}.crt;
    ssl_certificate_key /etc/ssl/private/${from_domain}.key;
    
    # 301 永久重定向到HTTPS版本
EOF
    
    if [[ "$keep_path" =~ ^[yY]$ ]]; then
        echo "    return 301 https://$to_domain\$request_uri;" >> "$temp_file"
    else
        echo "    return 301 https://$to_domain;" >> "$temp_file"
    fi
    
    echo "}" >> "$temp_file"
    
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}生成的配置内容：${NC}"
    echo ""
    cat "$temp_file"
    echo ""
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "是否应用此配置？(y/N): " apply_config
    if [[ "$apply_config" =~ ^[yY]$ ]]; then
        local config_file="/etc/nginx/conf.d/301_redirect_${from_domain//./_}.conf"
        
        # 备份
        backup_nginx_single_config "$config_file"
        
        # 保存
        cp "$temp_file" "$config_file"
        chmod 644 "$config_file"
        
        # 测试并重载
        if verify_nginx_config_silent; then
            read -p "配置验证成功，是否立即重载 Nginx？(y/N): " reload_now
            if [[ "$reload_now" =~ ^[yY]$ ]]; then
                reload_nginx_silent
                echo -e "${GREEN}✅ 301永久重定向已启用！${NC}"
                echo -e "${YELLOW}测试命令: curl -I http://$from_domain${NC}"
            fi
        else
            echo -e "${RED}配置验证失败${NC}"
        fi
    fi
    
    rm -f "$temp_file"
    read -p "按回车键继续..."
}

# 4. 域名临时重定向 (302)
function nginx_302_redirect() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        域名临时重定向 (302)${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    echo -e "${YELLOW}配置临时重定向 (302)，适用于临时维护或A/B测试${NC}"
    echo ""
    
    read -p "请输入源域名: " from_domain
    read -p "请输入目标域名: " to_domain
    read -p "请输入重定向原因 (可选): " reason
    read -p "是否保留查询参数？(Y/n): " keep_query
    keep_query=${keep_query:-"Y"}
    
    local temp_file=$(mktemp)
    
    cat > "$temp_file" << EOF
# 302 Temporary Redirect: $from_domain -> $to_domain
# 原因: ${reason:-"临时重定向"}
server {
    listen 80;
    listen [::]:80;
    server_name $from_domain www.$from_domain;
    
    # 添加重定向原因头部
    add_header X-Redirect-Reason "${reason:-"Temporary Redirect"}" always;
    
    # 访问日志
    access_log /var/log/nginx/${from_domain}_temp_redirect.log;
    
    # 302 临时重定向
EOF
    
    if [[ "$keep_query" =~ ^[yY]$ ]]; then
        echo "    return 302 http://$to_domain\$request_uri;" >> "$temp_file"
    else
        echo "    return 302 http://$to_domain;" >> "$temp_file"
    fi
    
    echo "}" >> "$temp_file"
    
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}生成的配置内容：${NC}"
    echo ""
    cat "$temp_file"
    echo ""
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "是否应用此配置？(y/N): " apply_config
    if [[ "$apply_config" =~ ^[yY]$ ]]; then
        local config_file="/etc/nginx/conf.d/302_redirect_${from_domain//./_}.conf"
        
        backup_nginx_single_config "$config_file"
        cp "$temp_file" "$config_file"
        chmod 644 "$config_file"
        
        if verify_nginx_config_silent; then
            read -p "配置验证成功，是否立即重载 Nginx？(y/N): " reload_now
            if [[ "$reload_now" =~ ^[yY]$ ]]; then
                reload_nginx_silent
                echo -e "${GREEN}✅ 302临时重定向已启用！${NC}"
                echo -e "${YELLOW}临时重定向将在浏览器中显示为302状态码${NC}"
            fi
        fi
    fi
    
    rm -f "$temp_file"
    read -p "按回车键继续..."
}

# 5. 路径重定向 (URL Rewrite)
function nginx_path_redirect() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        路径重定向 (URL Rewrite)${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    echo -e "${YELLOW}配置URL路径重定向，支持正则表达式${NC}"
    echo ""
    
    read -p "请输入域名: " domain
    read -p "请输入源路径 (例如: /old/path 或 ~ ^/users/(.*)$): " from_path
    read -p "请输入目标路径 (例如: /new/path 或 /profile/\$1): " to_path
    read -p "重定向类型 (1=301永久, 2=302临时, 默认1): " redirect_type
    redirect_type=${redirect_type:-"1"}
    
    local redirect_code="301"
    if [ "$redirect_type" = "2" ]; then
        redirect_code="302"
    fi
    
    local temp_file=$(mktemp)
    
    cat > "$temp_file" << EOF
# Path Redirect for $domain
# $from_path -> $to_path
server {
    listen 80;
    listen [::]:80;
    server_name $domain www.$domain;
    
    location $from_path {
        return $redirect_code $to_path;
    }
    
    # 或者使用 rewrite 指令
    # rewrite $from_path $to_path $redirect_code;
    
    # 主站点配置
    location / {
        # 您的常规配置
        root /var/www/$domain;
        index index.html index.htm;
        try_files \$uri \$uri/ =404;
    }
}
EOF
    
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}生成的配置内容：${NC}"
    echo ""
    cat "$temp_file"
    echo ""
    echo ""
    echo -e "${GREEN}高级示例：${NC}"
    echo "1. 重写规则: rewrite ^/old/(.*)$ /new/\$1 permanent;"
    echo "2. 重定向带参数: rewrite ^/product/([0-9]+)$ /item.php?id=\$1? last;"
    echo "3. 删除尾部斜杠: rewrite ^/(.*)/$ /\$1 permanent;"
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "是否保存此配置？(y/N): " save_config
    if [[ "$save_config" =~ ^[yY]$ ]]; then
        local config_file="/etc/nginx/conf.d/path_redirect_${domain//./_}.conf"
        
        backup_nginx_single_config "$config_file"
        cp "$temp_file" "$config_file"
        chmod 644 "$config_file"
        
        echo -e "${GREEN}配置已保存到: $config_file${NC}"
        echo -e "${YELLOW}请将此配置包含到您的域名配置中${NC}"
    fi
    
    rm -f "$temp_file"
    read -p "按回车键继续..."
}

# 6. 多域名重定向到主域名
function nginx_multi_domain_redirect() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}      多域名重定向到主域名${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    echo -e "${YELLOW}将多个域名重定向到一个主域名${NC}"
    echo ""
    
    read -p "请输入主域名 (目标域名): " main_domain
    echo ""
    echo -e "请输入多个源域名 (每行一个，输入空行结束):"
    echo -e "${CYAN}示例:${NC}"
    echo "old-domain1.com"
    echo "old-domain2.com"
    echo "www.old-domain3.com"
    echo ""
    
    local domains=()
    local i=1
    
    while true; do
        read -p "源域名 $i (留空结束): " input_domain
        if [ -z "$input_domain" ]; then
            break
        fi
        domains+=("$input_domain")
        i=$((i+1))
    done
    
    if [ ${#domains[@]} -eq 0 ]; then
        echo -e "${RED}未输入任何源域名${NC}"
        return
    fi
    
    read -p "重定向类型 (1=301永久, 2=302临时, 默认1): " redirect_type
    redirect_type=${redirect_type:-"1"}
    
    local redirect_code="301"
    if [ "$redirect_type" = "2" ]; then
        redirect_code="302"
    fi
    
    local temp_file=$(mktemp)
    
    # 生成服务器块
    cat > "$temp_file" << EOF
# Multi-domain redirect to $main_domain
# Generated on $(date)
EOF
    
    for domain in "${domains[@]}"; do
        cat >> "$temp_file" << EOF

server {
    listen 80;
    listen [::]:80;
    server_name $domain;
    
    # 访问日志
    access_log /var/log/nginx/redirect_${domain//./_}.log;
    
    # 重定向到主域名
    return $redirect_code http://$main_domain\$request_uri;
}
EOF
    done
    
    # 主域名配置（示例）
    cat >> "$temp_file" << EOF

# 主域名服务器配置 (示例)
server {
    listen 80;
    listen [::]:80;
    server_name $main_domain www.$main_domain;
    
    root /var/www/$main_domain;
    index index.html index.htm;
    
    access_log /var/log/nginx/${main_domain}_access.log;
    error_log /var/log/nginx/${main_domain}_error.log;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
    
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}生成的配置内容：${NC}"
    echo ""
    cat "$temp_file"
    echo ""
    echo -e "${GREEN}总共配置了 ${#domains[@]} 个域名的重定向${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "是否应用此配置？(y/N): " apply_config
    if [[ "$apply_config" =~ ^[yY]$ ]]; then
        local config_file="/etc/nginx/conf.d/multi_redirect_${main_domain//./_}.conf"
        
        backup_nginx_single_config "$config_file"
        cp "$temp_file" "$config_file"
        chmod 644 "$config_file"
        
        if verify_nginx_config_silent; then
            read -p "配置验证成功，是否立即重载 Nginx？(y/N): " reload_now
            if [[ "$reload_now" =~ ^[yY]$ ]]; then
                reload_nginx_silent
                echo -e "${GREEN}✅ 多域名重定向已启用！${NC}"
            fi
        fi
    fi
    
    rm -f "$temp_file"
    read -p "按回车键继续..."
}

# 7. 网站迁移重定向
function nginx_site_migration() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}         网站迁移重定向${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    echo -e "${YELLOW}为网站迁移创建全面的重定向规则${NC}"
    echo ""
    
    echo -e "请选择迁移类型："
    echo "1. 更换域名 (完整迁移)"
    echo "2. 更改URL结构"
    echo "3. 内容管理系统迁移 (如WordPress)"
    echo "4. 平台迁移 (如Discuz到新系统)"
    read -p "请选择 (1-4): " migration_type
    
    case "$migration_type" in
        1)
            echo -e "${BLUE}域名更换迁移${NC}"
            read -p "旧域名: " old_domain
            read -p "新域名: " new_domain
            read -p "是否保留URL路径结构？(Y/n): " keep_structure
            keep_structure=${keep_structure:-"Y"}
            
            local temp_file=$(mktemp)
            cat > "$temp_file" << EOF
# 域名迁移重定向: $old_domain -> $new_domain
server {
    listen 80;
    listen [::]:80;
    server_name $old_domain www.$old_domain;
    
    # 301 永久重定向
EOF
            if [[ "$keep_structure" =~ ^[yY]$ ]]; then
                echo "    return 301 http://$new_domain\$request_uri;" >> "$temp_file"
            else
                echo "    return 301 http://$new_domain;" >> "$temp_file"
            fi
            echo "}" >> "$temp_file"
            ;;
        2)
            echo -e "${BLUE}URL结构更改${NC}"
            read -p "域名: " domain
            echo -e "示例："
            echo "  /old-page.html -> /new-page.html"
            echo "  /category/old/ -> /new-category/"
            echo "  /article/(.*) -> /post/\$1"
            echo ""
            
            echo "请输入重定向规则（每行一条，格式: 旧路径 新路径）："
            echo "输入空行结束"
            
            local rules=()
            while true; do
                read -p "规则: " rule
                if [ -z "$rule" ]; then
                    break
                fi
                rules+=("$rule")
            done
            
            if [ ${#rules[@]} -eq 0 ]; then
                echo -e "${RED}未输入任何规则${NC}"
                return
            fi
            
            local temp_file=$(mktemp)
            cat > "$temp_file" << EOF
# URL结构迁移重定向
server {
    listen 80;
    listen [::]:80;
    server_name $domain www.$domain;
    
    # 重定向规则
EOF
            
            for rule in "${rules[@]}"; do
                read -r old_path new_path <<< "$rule"
                echo "    rewrite ^${old_path}$ ${new_path} permanent;" >> "$temp_file"
            done
            
            cat >> "$temp_file" << EOF
    
    # 主配置
    root /var/www/$domain;
    index index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
            ;;
        3)
            echo -e "${BLUE}WordPress 迁移重定向${NC}"
            read -p "旧网站域名: " old_domain
            read -p "新网站域名: " new_domain
            
            local temp_file=$(mktemp)
            cat > "$temp_file" << EOF
# WordPress 迁移重定向规则
server {
    listen 80;
    listen [::]:80;
    server_name $old_domain www.$old_domain;
    
    # WordPress 永久链接重定向
    rewrite ^/(.*)$ http://$new_domain/\$1 permanent;
    
    # 特定重定向示例
    rewrite ^/wp-content/uploads/(.*)$ http://$new_domain/wp-content/uploads/\$1 permanent;
    rewrite ^/feed/?$ http://$new_domain/feed permanent;
    rewrite ^/sitemap.xml$ http://$new_domain/sitemap.xml permanent;
}
EOF
            ;;
        4)
            echo -e "${BLUE}论坛系统迁移${NC}"
            read -p "旧网站域名: " old_domain
            read -p "新网站域名: " new_domain
            
            local temp_file=$(mktemp)
            cat > "$temp_file" << EOF
# 论坛系统迁移重定向
server {
    listen 80;
    listen [::]:80;
    server_name $old_domain www.$old_domain;
    
    # 论坛帖子重定向
    rewrite ^/thread-([0-9]+)-([0-9]+)-([0-9]+).html$ http://$new_domain/topic/\$1 permanent;
    rewrite ^/forum-([0-9]+)-([0-9]+).html$ http://$new_domain/category/\$1 permanent;
    rewrite ^/space-username-([^\.]+).html$ http://$new_domain/user/\$1 permanent;
    
    # 通用重定向
    rewrite ^/(.*)$ http://$new_domain/\$1 permanent;
}
EOF
            ;;
        *)
            echo -e "${RED}无效的选择${NC}"
            return
            ;;
    esac
    
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}生成的配置内容：${NC}"
    echo ""
    cat "$temp_file"
    echo ""
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "是否保存配置？(y/N): " save_config
    if [[ "$save_config" =~ ^[yY]$ ]]; then
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local config_file="/etc/nginx/conf.d/migration_${timestamp}.conf"
        
        backup_nginx_single_config "$config_file"
        cp "$temp_file" "$config_file"
        chmod 644 "$config_file"
        
        echo -e "${GREEN}配置已保存到: $config_file${NC}"
    fi
    
    rm -f "$temp_file"
    read -p "按回车键继续..."
}

# 8. 移动设备重定向
function nginx_mobile_redirect() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        移动设备重定向${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    echo -e "${YELLOW}为移动设备创建重定向规则${NC}"
    echo ""
    
    echo -e "请选择设备检测方式："
    echo "1. User-Agent 检测 (推荐)"
    echo "2. 移动子域名 (如 m.example.com)"
    echo "3. 移动专用路径 (如 example.com/mobile)"
    read -p "请选择 (1-3): " mobile_type
    
    read -p "请输入主域名: " domain
    
    local temp_file=$(mktemp)
    
    case "$mobile_type" in
        1)
            cat > "$temp_file" << EOF
# 移动设备重定向 - User-Agent检测
map \$http_user_agent \$is_mobile {
    default 0;
    
    # 移动设备 User-Agent 正则表达式
    ~*(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino) 1;
    ~*^(1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-) 1;
}

server {
    listen 80;
    listen [::]:80;
    server_name $domain www.$domain;
    
    # 移动设备重定向
    if (\$is_mobile = 1) {
        # 重定向到移动版本网站
        return 301 http://m.$domain\$request_uri;
        
        # 或者使用移动专用路径
        # rewrite ^ /mobile\$request_uri;
    }
    
    # 桌面版网站配置
    root /var/www/$domain;
    index index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}

# 移动版网站配置
server {
    listen 80;
    listen [::]:80;
    server_name m.$domain;
    
    # 移动版网站
    root /var/www/mobile.$domain;
    index index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
            ;;
        2)
            cat > "$temp_file" << EOF
# 移动子域名重定向
server {
    listen 80;
    listen [::]:80;
    server_name m.$domain;
    
    # 移动版网站
    root /var/www/mobile.$domain;
    index index.html index.htm;
    
    # 移动设备优化
    location / {
        try_files \$uri \$uri/ =404;
        
        # 添加移动设备优化的响应头
        add_header X-Mobile-Site "true" always;
    }
}

# 主网站重定向到移动版（可选）
server {
    listen 80;
    listen [::]:80;
    server_name $domain www.$domain;
    
    # 检测移动设备
    if (\$http_user_agent ~* '(android|iphone|ipod|ipad|mobile)') {
        return 301 http://m.$domain\$request_uri;
    }
    
    # 桌面版配置
    root /var/www/$domain;
    index index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
            ;;
        3)
            cat > "$temp_file" << EOF
# 移动路径重定向
server {
    listen 80;
    listen [::]:80;
    server_name $domain www.$domain;
    
    # 移动设备检测
    set \$mobile_rewrite do_not_perform;
    
    if (\$http_user_agent ~* "(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino") {
        set \$mobile_rewrite perform;
    }
    
    if (\$mobile_rewrite = perform) {
        # 重定向到移动路径
        rewrite ^ /mobile\$request_uri last;
    }
    
    # 桌面版配置
    location / {
        root /var/www/$domain;
        index index.html index.htm;
        try_files \$uri \$uri/ =404;
    }
    
    # 移动版配置
    location /mobile {
        alias /var/www/$domain/mobile;
        index index.html index.htm;
        
        try_files \$uri \$uri/ /mobile/index.html;
        
        # 防止循环重定向
        if (\$request_uri ~ "^/mobile/mobile") {
            rewrite ^/mobile/(.*) /\$1 permanent;
        }
    }
}
EOF
            ;;
        *)
            echo -e "${RED}无效的选择${NC}"
            return
            ;;
    esac
    
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}生成的配置内容：${NC}"
    echo ""
    cat "$temp_file"
    echo ""
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "是否保存配置？(y/N): " save_config
    if [[ "$save_config" =~ ^[yY]$ ]]; then
        local config_file="/etc/nginx/conf.d/mobile_redirect_${domain//./_}.conf"
        
        backup_nginx_single_config "$config_file")
        cp "$temp_file" "$config_file"
        chmod 644 "$config_file"
        
        echo -e "${GREEN}配置已保存到: $config_file${NC}"
    fi
    
    rm -f "$temp_file"
    read -p "按回车键继续..."
}

# 9. 国家/地区重定向
function nginx_geo_redirect() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        国家/地区重定向${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    echo -e "${YELLOW}根据访问者地理位置进行重定向${NC}"
    echo ""
    
    echo -e "此功能需要 GeoIP 数据库。是否安装？"
    echo "1. 安装 GeoIP2 数据库（推荐）"
    echo "2. 我已经有 GeoIP 数据库"
    echo "3. 仅生成配置，稍后手动安装数据库"
    read -p "请选择 (1-3): " geo_choice
    
    if [ "$geo_choice" = "1" ]; then
        install_geoip_database
    fi
    
    read -p "请输入主域名: " domain
    echo ""
    echo -e "请配置重定向规则（格式: 国家代码 目标域名）"
    echo -e "示例:"
    echo "  US  us.example.com"
    echo "  CN  cn.example.com"
    echo "  GB  uk.example.com"
    echo ""
    echo "输入空行结束"
    
    local geo_rules=()
    while true; do
        read -p "规则 (国家 域名): " rule
        if [ -z "$rule" ]; then
            break
        fi
        geo_rules+=("$rule")
    done
    
    if [ ${#geo_rules[@]} -eq 0 ]; then
        echo -e "${RED}未输入任何规则${NC}"
        return
    fi
    
    local temp_file=$(mktemp)
    
    # 生成 GeoIP 配置文件
    cat > "$temp_file" << EOF
# 国家/地区重定向配置
# 需要 GeoIP2 模块支持

# 加载 GeoIP2 模块
# load_module modules/ngx_http_geoip2_module.so;

# GeoIP2 数据库路径（请根据实际情况修改）
geoip2 /usr/share/GeoIP/GeoLite2-Country.mmdb {
    \$geoip2_country_code country iso_code;
}

# 国家代码映射
map \$geoip2_country_code \$country_redirect {
    default "";
EOF
    
    for rule in "${geo_rules[@]}"; do
        read -r country_code redirect_domain <<< "$rule"
        echo "    $country_code $redirect_domain;" >> "$temp_file"
    done
    
    cat >> "$temp_file" << EOF
}

server {
    listen 80;
    listen [::]:80;
    server_name $domain www.$domain;
    
    # 根据国家重定向
    if (\$country_redirect != "") {
        return 301 http://\$country_redirect\$request_uri;
    }
    
    # 默认网站配置
    root /var/www/$domain;
    index index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
    
    # 记录访问者国家信息
    location /geo-info {
        add_header Content-Type text/plain;
        return 200 "Country: \$geoip2_country_code\nIP: \$remote_addr\n";
    }
}
EOF
    
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}生成的配置内容：${NC}"
    echo ""
    cat "$temp_file"
    echo ""
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    echo -e "${YELLOW}安装说明：${NC}"
    echo "1. 安装 Nginx GeoIP2 模块："
    echo "   Ubuntu: sudo apt install libnginx-mod-http-geoip2"
    echo "   CentOS: sudo yum install nginx-mod-http-geoip2"
    echo ""
    echo "2. 下载 GeoIP2 数据库："
    echo "   sudo mkdir -p /usr/share/GeoIP"
    echo "   sudo wget -O /usr/share/GeoIP/GeoLite2-Country.mmdb https://raw.githubusercontent.com/P3TERX/GeoLite.mmdb/download/GeoLite2-Country.mmdb"
    echo ""
    
    read -p "是否保存配置？(y/N): " save_config
    if [[ "$save_config" =~ ^[yY]$ ]]; then
        local config_file="/etc/nginx/conf.d/geo_redirect_${domain//./_}.conf"
        
        backup_nginx_single_config "$config_file"
        cp "$temp_file" "$config_file"
        chmod 644 "$config_file"
        
        echo -e "${GREEN}配置已保存到: $config_file${NC}"
        echo -e "${YELLOW}请按照上述说明安装必要的模块和数据库${NC}"
    fi
    
    rm -f "$temp_file"
    read -p "按回车键继续..."
}

# 10. 文件扩展名重定向
function nginx_extension_redirect() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        文件扩展名重定向${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    echo -e "${YELLOW}重定向特定文件扩展名的请求${NC}"
    echo ""
    
    read -p "请输入域名: " domain
    
    echo -e "请选择重定向类型："
    echo "1. 旧扩展名重定向到新扩展名"
    echo "2. 删除扩展名重定向"
    echo "3. 添加扩展名重定向"
    echo "4. 阻止特定扩展名访问"
    read -p "请选择 (1-4): " ext_choice
    
    local temp_file=$(mktemp)
    
    case "$ext_choice" in
        1)
            echo -e "${BLUE}旧扩展名重定向到新扩展名${NC}"
            read -p "旧扩展名 (如: .htm): " old_ext
            read -p "新扩展名 (如: .html): " new_ext
            
            cat > "$temp_file" << EOF
# 文件扩展名重定向: $old_ext -> $new_ext
server {
    listen 80;
    listen [::]:80;
    server_name $domain www.$domain;
    
    # 重定向旧扩展名到新扩展名
    rewrite "^/(.*)\\.${old_ext#.}$" /\$1.$new_ext permanent;
    
    # 主配置
    root /var/www/$domain;
    index index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
            ;;
        2)
            echo -e "${BLUE}删除扩展名重定向${NC}"
            read -p "要删除的扩展名 (如: .php): " remove_ext
            
            cat > "$temp_file" << EOF
# 删除文件扩展名重定向
server {
    listen 80;
    listen [::]:80;
    server_name $domain www.$domain;
    
    # 删除扩展名重定向
    rewrite "^/(.*)\\.${remove_ext#.}$" /\$1 permanent;
    
    # 主配置
    root /var/www/$domain;
    index index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
            ;;
        3)
            echo -e "${BLUE}添加扩展名重定向${NC}"
            read -p "要添加的扩展名 (如: .html): " add_ext
            
            cat > "$temp_file" << EOF
# 添加文件扩展名重定向
server {
    listen 80;
    listen [::]:80;
    server_name $domain www.$domain;
    
    # 添加扩展名重定向
    rewrite "^/([^\.]+)$" /\$1.$add_ext permanent;
    
    # 主配置
    root /var/www/$domain;
    index index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
            ;;
        4)
            echo -e "${BLUE}阻止特定扩展名访问${NC}"
            read -p "要阻止的扩展名 (如: .exe,.dll): " block_exts
            
            cat > "$temp_file" << EOF
# 阻止特定文件扩展名访问
server {
    listen 80;
    listen [::]:80;
    server_name $domain www.$domain;
    
    # 阻止特定扩展名访问
    location ~* \\.(${block_exts//,/|})$ {
        deny all;
        return 403;
    }
    
    # 主配置
    root /var/www/$domain;
    index index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF
            ;;
        *)
            echo -e "${RED}无效的选择${NC}"
            return
            ;;
    esac
    
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}生成的配置内容：${NC}"
    echo ""
    cat "$temp_file"
    echo ""
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "是否保存配置？(y/N): " save_config
    if [[ "$save_config" =~ ^[yY]$ ]]; then
        local config_file="/etc/nginx/conf.d/extension_redirect_${domain//./_}.conf"
        
        backup_nginx_single_config "$config_file"
        cp "$temp_file" "$config_file"
        chmod 644 "$config_file"
        
        echo -e "${GREEN}配置已保存到: $config_file${NC}"
    fi
    
    rm -f "$temp_file"
    read -p "按回车键继续..."
}

# =========================================
# 管理功能实现
# =========================================

# 11. 查看当前重定向配置
function view_nginx_redirects() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}      查看当前 Nginx 重定向配置${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    local nginx_conf_dir="/etc/nginx"
    local conf_files=()
    
    echo -e "${YELLOW}正在扫描 Nginx 配置文件...${NC}"
    echo ""
    
    # 查找所有配置文件
    find "$nginx_conf_dir" -name "*.conf" -type f | while read -r conf_file; do
        echo -e "${BLUE}=== 文件: $conf_file ===${NC}"
        
        # 提取重定向相关配置
        local redirect_lines=$(grep -n -E "(return 30[12]|rewrite.*permanent|rewrite.*redirect)" "$conf_file" 2>/dev/null)
        
        if [ -n "$redirect_lines" ]; then
            echo "$redirect_lines" | while IFS= read -r line; do
                echo -e "  ${GREEN}第 ${line%%:*} 行: ${line#*:}${NC}"
            done
        else
            echo -e "  ${YELLOW}未找到重定向配置${NC}"
        fi
        
        echo ""
    done
    
    # 检查活跃的重定向规则
    echo -e "${CYAN}活跃的重定向规则：${NC}"
    echo ""
    
    # 查找 return 指令
    local active_returns=$(grep -r "return 30[12]" /etc/nginx/ 2>/dev/null | head -20)
    if [ -n "$active_returns" ]; then
        echo "$active_returns" | while IFS= read -r rule; do
            echo -e "  ${GREEN}$rule${NC}"
        done
    fi
    
    echo ""
    echo -e "${CYAN}重写规则：${NC}"
    echo ""
    
    # 查找 rewrite 指令
    local rewrite_rules=$(grep -r "rewrite.*permanent\|rewrite.*redirect" /etc/nginx/ 2>/dev/null | head -20)
    if [ -n "$rewrite_rules" ]; then
        echo "$rewrite_rules" | while IFS= read -r rule; do
            echo -e "  ${GREEN}$rule${NC}"
        done
    fi
    
    read -p "按回车键继续..."
}

# 12. 备份 Nginx 配置
function backup_nginx_config() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}      备份 Nginx 配置${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    local backup_dir="/etc/nginx/backups"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_path="$backup_dir/nginx_backup_$timestamp"
    
    echo -e "${YELLOW}正在备份 Nginx 配置...${NC}"
    echo ""
    
    # 创建备份目录
    mkdir -p "$backup_dir"
    mkdir -p "$backup_path"
    
    # 备份主要配置
    local config_files=(
        "/etc/nginx/nginx.conf"
        "/etc/nginx/conf.d/"
        "/etc/nginx/sites-available/"
        "/etc/nginx/sites-enabled/"
    )
    
    local total_files=0
    for item in "${config_files[@]}"; do
        if [ -e "$item" ]; then
            if [ -d "$item" ]; then
                echo -e "备份目录: ${GREEN}$item${NC}"
                cp -r "$item" "$backup_path/" 2>/dev/null
                total_files=$((total_files + $(find "$item" -type f | wc -l)))
            else
                echo -e "备份文件: ${GREEN}$item${NC}"
                cp "$item" "$backup_path/" 2>/dev/null
                total_files=$((total_files + 1))
            fi
        fi
    done
    
    # 创建备份信息文件
    cat > "$backup_path/backup_info.txt" << EOF
备份时间: $(date)
备份路径: $backup_path
文件数量: $total_files
Nginx 版本: $(nginx -v 2>&1 | cut -d'/' -f2)
系统信息: $(uname -a)
EOF
    
    # 压缩备份
    echo -e "\n${YELLOW}正在压缩备份文件...${NC}"
    tar -czf "$backup_path.tar.gz" -C "$backup_path" . 2>/dev/null
    rm -rf "$backup_path"
    
    # 显示备份信息
    local backup_size=$(du -h "$backup_path.tar.gz" | cut -f1)
    
    echo -e "${GREEN}✅ 备份完成！${NC}"
    echo ""
    echo -e "${CYAN}备份信息：${NC}"
    echo -e "备份文件: ${GREEN}$backup_path.tar.gz${NC}"
    echo -e "文件大小: ${GREEN}$backup_size${NC}"
    echo -e "备份时间: ${GREEN}$(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo ""
    echo -e "${YELLOW}备份内容：${NC}"
    tar -tzf "$backup_path.tar.gz" 2>/dev/null | head -20
    
    # 清理旧备份（保留最近10个）
    echo -e "\n${YELLOW}清理旧备份文件...${NC}"
    ls -t "$backup_dir"/*.tar.gz 2>/dev/null | tail -n +11 | xargs -r rm -f
    
    read -p "按回车键继续..."
}

# 13. 恢复 Nginx 配置
function restore_nginx_config() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}      恢复 Nginx 配置${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    local backup_dir="/etc/nginx/backups"
    
    if [ ! -d "$backup_dir" ]; then
        echo -e "${RED}备份目录不存在！${NC}"
        read -p "按回车键继续..."
        return
    fi
    
    # 列出可用备份
    local backups=($(ls -t "$backup_dir"/*.tar.gz 2>/dev/null))
    
    if [ ${#backups[@]} -eq 0 ]; then
        echo -e "${RED}没有找到备份文件！${NC}"
        read -p "按回车键继续..."
        return
    fi
    
    echo -e "${YELLOW}可用的备份文件：${NC}"
    echo ""
    
    for i in "${!backups[@]}"; do
        local backup_file="${backups[$i]}"
        local file_size=$(du -h "$backup_file" | cut -f1)
        local file_date=$(stat -c %y "$backup_file" 2>/dev/null | cut -d' ' -f1)
        
        echo -e "$((i+1)). ${GREEN}$(basename "$backup_file")${NC}"
        echo -e "   大小: $file_size, 日期: $file_date"
        
        # 显示备份信息
        if tar -tzf "$backup_file" 2>/dev/null | grep -q "backup_info.txt"; then
            echo -e "   信息:"
            tar -xzf "$backup_file" -O backup_info.txt 2>/dev/null | head -3 | sed 's/^/      /'
        fi
        echo ""
    done
    
    read -p "请选择要恢复的备份编号 (1-${#backups[@]}): " restore_choice
    
    if [ "$restore_choice" -lt 1 ] || [ "$restore_choice" -gt ${#backups[@]} ]; then
        echo -e "${RED}无效的选择！${NC}"
        return
    fi
    
    local selected_backup="${backups[$((restore_choice-1))]}"
    
    echo -e "\n${RED}⚠️  警告：这将覆盖当前的 Nginx 配置！${NC}"
    echo -e "选择的备份文件: ${GREEN}$(basename "$selected_backup")${NC}"
    read -p "确定要恢复吗？(y/N): " confirm_restore
    
    if [[ ! "$confirm_restore" =~ ^[yY]$ ]]; then
        echo "恢复已取消。"
        return
    fi
    
    # 创建当前配置的临时备份
    local temp_backup="/tmp/nginx_pre_restore_$(date +%s).tar.gz"
    echo -e "${YELLOW}创建临时备份...${NC}"
    tar -czf "$temp_backup" -C /etc/nginx nginx.conf conf.d sites-available sites-enabled 2>/dev/null
    
    # 停止 Nginx 服务
    echo -e "${YELLOW}停止 Nginx 服务...${NC}"
    systemctl stop nginx 2>/dev/null
    
    # 清空配置目录
    echo -e "${YELLOW}清理配置目录...${NC}"
    rm -rf /etc/nginx/conf.d/* 2>/dev/null
    rm -rf /etc/nginx/sites-available/* 2>/dev/null
    rm -rf /etc/nginx/sites-enabled/* 2>/dev/null
    
    # 恢复备份
    echo -e "${YELLOW}恢复配置...${NC}"
    tar -xzf "$selected_backup" -C /etc/nginx --strip-components=1 2>/dev/null
    
    # 验证配置
    echo -e "${YELLOW}验证配置...${NC}"
    if nginx -t 2>/dev/null; then
        echo -e "${GREEN}✅ 配置验证成功${NC}"
        
        # 启动 Nginx
        echo -e "${YELLOW}启动 Nginx 服务...${NC}"
        systemctl start nginx 2>/dev/null
        
        if systemctl is-active --quiet nginx; then
            echo -e "${GREEN}✅ Nginx 服务启动成功${NC}"
        else
            echo -e "${RED}❌ Nginx 服务启动失败${NC}"
            echo -e "${YELLOW}正在恢复之前的配置...${NC}"
            tar -xzf "$temp_backup" -C /etc/nginx --strip-components=1 2>/dev/null
            systemctl start nginx 2>/dev/null
        fi
    else
        echo -e "${RED}❌ 配置验证失败${NC}"
        echo -e "${YELLOW}正在恢复之前的配置...${NC}"
        tar -xzf "$temp_backup" -C /etc/nginx --strip-components=1 2>/dev/null
        systemctl start nginx 2>/dev/null
    fi
    
    # 清理临时文件
    rm -f "$temp_backup"
    
    echo -e "\n${GREEN}✅ 恢复完成！${NC}"
    read -p "按回车键继续..."
}

# 14. 测试重定向规则
function test_redirect_rules() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}      测试重定向规则${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    echo -e "${YELLOW}测试 Nginx 重定向规则${NC}"
    echo ""
    
    echo "请选择测试方式："
    echo "1. 使用 curl 测试单个 URL"
    echo "2. 批量测试 URL 列表"
    echo "3. 模拟不同 User-Agent"
    echo "4. 测试重定向链"
    read -p "请选择 (1-4): " test_method
    
    case "$test_method" in
        1)
            read -p "请输入要测试的 URL (例如: http://example.com/old): " test_url
            read -p "请输入预期的目标 URL (可选): " expected_url
            
            echo -e "\n${BLUE}测试结果：${NC}"
            
            # 使用 curl 测试
            local response=$(curl -sI "$test_url" 2>/dev/null)
            local status_code=$(echo "$response" | grep -i "HTTP/" | head -1 | awk '{print $2}')
            local location=$(echo "$response" | grep -i "location:" | head -1 | cut -d' ' -f2-)
            
            echo -e "请求 URL: ${GREEN}$test_url${NC}"
            echo -e "状态码: ${GREEN}$status_code${NC}"
            
            if [ -n "$location" ]; then
                echo -e "重定向到: ${GREEN}$location${NC}"
                
                if [ -n "$expected_url" ] && [ "$location" != "$expected_url" ]; then
                    echo -e "${RED}⚠️  警告: 重定向目标与预期不符${NC}"
                    echo -e "预期: $expected_url"
                    echo -e "实际: $location"
                fi
            else
                echo -e "${YELLOW}未发生重定向${NC}"
            fi
            
            # 显示响应头
            echo -e "\n${BLUE}完整响应头：${NC}"
            echo "$response"
            ;;
        2)
            echo -e "${BLUE}批量测试 URL 列表${NC}"
            echo "请将 URL 列表保存到文件（每行一个URL）"
            read -p "请输入文件路径: " url_file
            
            if [ ! -f "$url_file" ]; then
                echo -e "${RED}文件不存在！${NC}"
                return
            fi
            
            echo -e "\n${BLUE}测试结果：${NC}"
            echo "---------------------------------------------------"
            printf "%-40s %-10s %-30s\n" "URL" "状态码" "重定向目标"
            echo "---------------------------------------------------"
            
            while IFS= read -r test_url || [ -n "$test_url" ]; do
                [ -z "$test_url" ] && continue
                
                local response=$(curl -sI "$test_url" 2>/dev/null)
                local status_code=$(echo "$response" | grep -i "HTTP/" | head -1 | awk '{print $2}')
                local location=$(echo "$response" | grep -i "location:" | head -1 | cut -d' ' -f2- | tr -d '\r')
                
                # 截断长URL显示
                local display_url="$test_url"
                if [ ${#display_url} -gt 38 ]; then
                    display_url="${display_url:0:35}..."
                fi
                
                if [ ${#location} -gt 28 ]; then
                    location="${location:0:25}..."
                fi
                
                if [ -n "$status_code" ]; then
                    if [ "$status_code" = "301" ] || [ "$status_code" = "302" ]; then
                        printf "%-40s ${GREEN}%-10s${NC} %-30s\n" "$display_url" "$status_code" "$location"
                    else
                        printf "%-40s ${YELLOW}%-10s${NC} %-30s\n" "$display_url" "$status_code" "$location"
                    fi
                else
                    printf "%-40s ${RED}%-10s${NC} %-30s\n" "$display_url" "ERROR" "请求失败"
                fi
            done < "$url_file"
            ;;
        3)
            echo -e "${BLUE}模拟不同 User-Agent${NC}"
            read -p "请输入测试 URL: " test_url
            
            echo -e "\n${BLUE}测试结果：${NC}"
            
            # 定义不同的 User-Agent
            declare -A user_agents=(
                ["桌面 Chrome"]="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
                ["移动 iPhone"]="Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1"
                ["移动 Android"]="Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36"
                ["Google 爬虫"]="Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
                ["命令行工具"]="curl/7.68.0"
            )
            
            for agent_name in "${!user_agents[@]}"; do
                echo -e "\n${YELLOW}$agent_name：${NC}"
                
                local response=$(curl -sI -A "${user_agents[$agent_name]}" "$test_url" 2>/dev/null)
                local status_code=$(echo "$response" | grep -i "HTTP/" | head -1 | awk '{print $2}')
                local location=$(echo "$response" | grep -i "location:" | head -1 | cut -d' ' -f2-)
                
                echo -e "状态码: ${GREEN}$status_code${NC}"
                if [ -n "$location" ]; then
                    echo -e "重定向到: ${GREEN}$location${NC}"
                fi
            done
            ;;
        4)
            echo -e "${BLUE}测试重定向链${NC}"
            read -p "请输入起始 URL: " start_url
            read -p "最大重定向次数 (默认 5): " max_redirects
            max_redirects=${max_redirects:-5}
            
            echo -e "\n${BLUE}重定向链：${NC}"
            
            local current_url="$start_url"
            local redirect_count=0
            local visited_urls=()
            
            while [ "$redirect_count" -lt "$max_redirects" ]; do
                visited_urls+=("$current_url")
                
                echo -e "第 $((redirect_count+1)) 次请求: ${GREEN}$current_url${NC}"
                
                local response=$(curl -sI "$current_url" 2>/dev/null)
                local status_code=$(echo "$response" | grep -i "HTTP/" | head -1 | awk '{print $2}')
                local location=$(echo "$response" | grep -i "location:" | head -1 | cut -d' ' -f2- | tr -d '\r')
                
                echo -e "  状态码: ${GREEN}$status_code${NC}"
                
                if [ "$status_code" = "301" ] || [ "$status_code" = "302" ]; then
                    if [ -z "$location" ]; then
                        echo -e "${RED}  错误: 重定向状态码但没有 Location 头${NC}"
                        break
                    fi
                    
                    # 检查是否循环重定向
                    for visited in "${visited_urls[@]}"; do
                        if [ "$visited" = "$location" ]; then
                            echo -e "${RED}  检测到循环重定向！${NC}"
                            break 2
                        fi
                    done
                    
                    echo -e "  重定向到: ${GREEN}$location${NC}"
                    current_url="$location"
                    redirect_count=$((redirect_count+1))
                else
                    echo -e "${YELLOW}  重定向链结束${NC}"
                    break
                fi
                
                echo ""
            done
            
            if [ "$redirect_count" -ge "$max_redirects" ]; then
                echo -e "${RED}达到最大重定向次数限制${NC}"
            fi
            
            echo -e "\n${GREEN}总共发生 $redirect_count 次重定向${NC}"
            ;;
        *)
            echo -e "${RED}无效的选择${NC}"
            return
            ;;
    esac
    
    read -p "按回车键继续..."
}

# 15. 批量重定向生成器
function batch_redirect_generator() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}      批量重定向生成器${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    echo -e "${YELLOW}批量生成重定向规则${NC}"
    echo ""
    
    echo "请选择数据源："
    echo "1. 手动输入"
    echo "2. CSV 文件"
    echo "3. Excel 文件 (需要转换)"
    echo "4. 网站地图 (sitemap.xml)"
    echo "5. 旧网站日志"
    read -p "请选择 (1-5): " data_source
    
    case "$data_source" in
        1)
            echo -e "${BLUE}手动输入重定向规则${NC}"
            echo "格式: 旧URL 新URL [状态码]"
            echo "示例: /old-page.html /new-page.html 301"
            echo "输入空行结束"
            echo ""
            
            local rules_file=$(mktemp)
            echo "# 批量重定向规则" > "$rules_file"
            echo "# 生成时间: $(date)" >> "$rules_file"
            
            local rule_count=0
            while true; do
                read -p "规则 $((rule_count+1)): " rule
                if [ -z "$rule" ]; then
                    break
                fi
                echo "$rule" >> "$rules_file"
                rule_count=$((rule_count+1))
            done
            
            echo -e "\n${GREEN}总共输入了 $rule_count 条规则${NC}"
            process_batch_rules "$rules_file"
            ;;
        2)
            echo -e "${BLUE}从 CSV 文件导入${NC}"
            read -p "请输入 CSV 文件路径: " csv_file
            
            if [ ! -f "$csv_file" ]; then
                echo -e "${RED}文件不存在！${NC}"
                return
            fi
            
            # 显示前几行
            echo -e "\n${YELLOW}文件预览：${NC}"
            head -5 "$csv_file"
            
            read -p "请指定列号 (旧URL,新URL,状态码): " col_numbers
            process_csv_file "$csv_file" "$col_numbers"
            ;;
        3)
            echo -e "${BLUE}Excel 文件处理${NC}"
            echo -e "${YELLOW}注意: 需要安装 libreoffice 或使用在线转换工具${NC}"
            echo ""
            echo "1. 转换为 CSV"
            echo "2. 转换为 TXT"
            read -p "请选择: " excel_choice
            
            read -p "请输入 Excel 文件路径: " excel_file
            
            if [ ! -f "$excel_file" ]; then
                echo -e "${RED}文件不存在！${NC}"
                return
            fi
            
            if [ "$excel_choice" = "1" ]; then
                echo -e "${YELLOW}正在转换为 CSV...${NC}"
                local csv_output="${excel_file%.*}.csv"
                
                if command -v libreoffice &> /dev/null; then
                    libreoffice --headless --convert-to csv "$excel_file" --outdir "$(dirname "$excel_file")"
                    echo -e "${GREEN}转换完成: $csv_output${NC}"
                else
                    echo -e "${RED}未找到 libreoffice，请手动转换${NC}"
                    return
                fi
            fi
            ;;
        4)
            echo -e "${BLUE}从网站地图生成重定向规则${NC}"
            read -p "请输入 sitemap.xml URL: " sitemap_url
            
            echo -e "${YELLOW}正在下载网站地图...${NC}"
            local sitemap_content=$(curl -s "$sitemap_url" 2>/dev/null)
            
            if [ -z "$sitemap_content" ]; then
                echo -e "${RED}无法下载网站地图${NC}"
                return
            fi
            
            # 提取URL
            local urls=$(echo "$sitemap_content" | grep -o '<loc>[^<]*</loc>' | sed 's/<\/\?loc>//g')
            local url_count=$(echo "$urls" | wc -l)
            
            echo -e "找到 $url_count 个 URL"
            
            read -p "请输入旧域名前缀: " old_prefix
            read -p "请输入新域名前缀: " new_prefix
            
            generate_redirects_from_urls "$urls" "$old_prefix" "$new_prefix"
            ;;
        5)
            echo -e "${BLUE}从日志文件生成重定向规则${NC}"
            read -p "请输入日志文件路径: " log_file
            
            if [ ! -f "$log_file" ]; then
                echo -e "${RED}文件不存在！${NC}"
                return
            fi
            
            echo -e "${YELLOW}正在分析日志文件...${NC}"
            
            # 提取404错误的URL
            local not_found_urls=$(grep " 404 " "$log_file" | grep -o '"[^"]*"' | grep -o '/[^ ]*' | sort | uniq -c | sort -rn | head -20)
            
            echo -e "\n${BLUE}最常见的 404 URL：${NC}"
            echo "$not_found_urls"
            
            read -p "是否基于这些URL生成重定向规则？(y/N): " generate_from_logs
            
            if [[ "$generate_from_logs" =~ ^[yY]$ ]]; then
                generate_redirects_from_logs "$not_found_urls"
            fi
            ;;
        *)
            echo -e "${RED}无效的选择${NC}"
            return
            ;;
    esac
    
    read -p "按回车键继续..."
}

# =========================================
# 工具功能实现
# =========================================

# 16. 安装/更新 Nginx
function install_update_nginx() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}       安装/更新 Nginx${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    echo -e "${YELLOW}检测系统发行版...${NC}"
    
    # 检测发行版
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        local os_name=$ID
        local os_version=$VERSION_ID
    else
        os_name=$(uname -s)
    fi
    
    echo -e "操作系统: ${GREEN}$os_name $os_version${NC}"
    
    # 检查是否已安装 Nginx
    if command -v nginx &> /dev/null; then
        local current_version=$(nginx -v 2>&1 | cut -d'/' -f2)
        echo -e "当前 Nginx 版本: ${GREEN}$current_version${NC}"
        
        read -p "是否更新 Nginx？(y/N): " update_nginx
        if [[ ! "$update_nginx" =~ ^[yY]$ ]]; then
            echo "操作已取消。"
            return
        fi
    else
        echo -e "${YELLOW}未检测到 Nginx 安装${NC}"
        read -p "是否安装 Nginx？(y/N): " install_nginx
        if [[ ! "$install_nginx" =~ ^[yY]$ ]]; then
            echo "操作已取消。"
            return
        fi
    fi
    
    # 安装/更新 Nginx
    case "$os_name" in
        ubuntu|debian)
            echo -e "${BLUE}使用 apt 安装/更新 Nginx...${NC}"
            
            # 更新包列表
            apt update
            
            if command -v nginx &> /dev/null; then
                apt upgrade -y nginx
            else
                apt install -y nginx
            fi
            ;;
        centos|rhel|fedora|rocky|almalinux)
            echo -e "${BLUE}使用 yum/dnf 安装/更新 Nginx...${NC}"
            
            # 安装 EPEL 仓库
            if [ "$os_name" = "centos" ] || [ "$os_name" = "rhel" ]; then
                yum install -y epel-release
                yum update -y nginx
            elif command -v dnf &> /dev/null; then
                dnf install -y nginx
            else
                yum install -y nginx
            fi
            ;;
        *)
            echo -e "${RED}不支持的操作系统${NC}"
            echo "请手动安装 Nginx："
            echo "官方文档: https://nginx.org/en/linux_packages.html"
            return
            ;;
    esac
    
    # 检查安装结果
    if command -v nginx &> /dev/null; then
        local new_version=$(nginx -v 2>&1 | cut -d'/' -f2)
        echo -e "${GREEN}✅ Nginx 安装/更新成功！${NC}"
        echo -e "当前版本: ${GREEN}$new_version${NC}"
        
        # 启动并启用开机启动
        systemctl start nginx
        systemctl enable nginx
        
        # 显示状态
        echo -e "\n${BLUE}Nginx 服务状态：${NC}"
        systemctl status nginx --no-pager -l | head -20
    else
        echo -e "${RED}❌ Nginx 安装/更新失败${NC}"
    fi
    
    read -p "按回车键继续..."
}

# 17. 查看 Nginx 日志
function view_nginx_logs() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}       查看 Nginx 日志${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    echo -e "${YELLOW}选择日志类型：${NC}"
    echo "1. 错误日志 (error.log)"
    echo "2. 访问日志 (access.log)"
    echo "3. 特定虚拟主机日志"
    echo "4. 实时监控日志"
    echo "5. 搜索日志内容"
    echo "6. 分析日志统计"
    read -p "请选择 (1-6): " log_choice
    
    local log_dir="/var/log/nginx"
    
    case "$log_choice" in
        1)
            echo -e "${BLUE}错误日志：${NC}"
            echo ""
            
            # 查找错误日志
            local error_logs=$(find "$log_dir" -name "*error*.log" -type f 2>/dev/null)
            
            if [ -n "$error_logs" ]; then
                echo -e "${GREEN}找到错误日志文件：${NC}"
                echo "$error_logs" | nl
                echo ""
                
                read -p "选择日志文件编号 (默认 1): " log_num
                log_num=${log_num:-1}
                
                local selected_log=$(echo "$error_logs" | sed -n "${log_num}p")
                
                if [ -f "$selected_log" ]; then
                    echo -e "${YELLOW}最后 50 行错误日志：${NC}"
                    tail -50 "$selected_log"
                else
                    echo -e "${RED}文件不存在！${NC}"
                fi
            else
                echo -e "${RED}未找到错误日志${NC}"
            fi
            ;;
        2)
            echo -e "${BLUE}访问日志：${NC}"
            echo ""
            
            local access_logs=$(find "$log_dir" -name "*access*.log" -type f 2>/dev/null)
            
            if [ -n "$access_logs" ]; then
                echo -e "${GREEN}找到访问日志文件：${NC}"
                echo "$access_logs" | nl
                echo ""
                
                read -p "选择日志文件编号 (默认 1): " log_num
                log_num=${log_num:-1}
                
                local selected_log=$(echo "$access_logs" | sed -n "${log_num}p")
                
                if [ -f "$selected_log" ]; then
                    echo -e "${YELLOW}最后 20 条访问记录：${NC}"
                    tail -20 "$selected_log"
                fi
            else
                echo -e "${RED}未找到访问日志${NC}"
            fi
            ;;
        3)
            echo -e "${BLUE}虚拟主机日志${NC}"
            echo ""
            
            read -p "请输入域名: " domain
            
            local domain_logs=$(find "$log_dir" -name "*$domain*.log" -type f 2>/dev/null)
            
            if [ -n "$domain_logs" ]; then
                echo -e "${GREEN}找到的日志文件：${NC}"
                echo "$domain_logs"
                echo ""
                
                for log_file in $domain_logs; do
                    echo -e "${YELLOW}=== $(basename "$log_file") ===${NC}"
                    tail -10 "$log_file"
                    echo ""
                done
            else
                echo -e "${RED}未找到该域名的日志${NC}"
            fi
            ;;
        4)
            echo -e "${BLUE}实时监控日志${NC}"
            echo ""
            
            local log_files=$(find "$log_dir" -name "*.log" -type f 2>/dev/null | head -5)
            
            if [ -n "$log_files" ]; then
                echo -e "${GREEN}可监控的日志文件：${NC}"
                echo "$log_files" | nl
                echo ""
                
                read -p "选择日志文件编号: " log_num
                local selected_log=$(echo "$log_files" | sed -n "${log_num}p")
                
                if [ -f "$selected_log" ]; then
                    echo -e "${YELLOW}开始实时监控 (按 Ctrl+C 退出)...${NC}"
                    tail -f "$selected_log"
                fi
            fi
            ;;
        5)
            echo -e "${BLUE}搜索日志内容${NC}"
            echo ""
            
            read -p "请输入搜索关键词: " search_term
            read -p "搜索最近多少行的日志？(默认 1000): " lines
            lines=${lines:-1000}
            
            local all_logs=$(find "$log_dir" -name "*.log" -type f 2>/dev/null)
            
            echo -e "${YELLOW}搜索结果：${NC}"
            echo ""
            
            for log_file in $all_logs; do
                local matches=$(grep -n "$search_term" "$log_file" 2>/dev/null | tail -5)
                if [ -n "$matches" ]; then
                    echo -e "${GREEN}=== $(basename "$log_file") ===${NC}"
                    echo "$matches"
                    echo ""
                fi
            done
            ;;
        6)
            echo -e "${BLUE}日志统计分析${NC}"
            echo ""
            
            read -p "分析最近多少行的日志？(默认 10000): " lines
            lines=${lines:-10000}
            
            local access_log=$(find "$log_dir" -name "*access*.log" -type f 2>/dev/null | head -1)
            
            if [ -f "$access_log" ]; then
                echo -e "${YELLOW}正在分析日志: $(basename "$access_log")${NC}"
                echo ""
                
                # 统计状态码
                echo -e "${BLUE}HTTP 状态码统计：${NC}"
                tail -n "$lines" "$access_log" | awk '{print $9}' | sort | uniq -c | sort -rn
                echo ""
                
                # 统计访问最多的IP
                echo -e "${BLUE}访问最多的 IP 地址：${NC}"
                tail -n "$lines" "$access_log" | awk '{print $1}' | sort | uniq -c | sort -rn | head -10
                echo ""
                
                # 统计访问最多的URL
                echo -e "${BLUE}访问最多的 URL：${NC}"
                tail -n "$lines" "$access_log" | awk '{print $7}' | sort | uniq -c | sort -rn | head -10
                echo ""
                
                # 统计流量来源
                echo -e "${BLUE}流量来源统计：${NC}"
                tail -n "$lines" "$access_log" | awk -F'"' '{print $4}' | cut -d' ' -f2 | sort | uniq -c | sort -rn | head -10
            else
                echo -e "${RED}未找到访问日志${NC}"
            fi
            ;;
        *)
            echo -e "${RED}无效的选择${NC}"
            return
            ;;
    esac
    
    read -p "按回车键继续..."
}

# 18. 验证 Nginx 配置
function verify_nginx_config() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}       验证 Nginx 配置${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    echo -e "${YELLOW}正在验证 Nginx 配置...${NC}"
    echo ""
    
    # 执行配置测试
    if nginx -t 2>&1; then
        echo -e "\n${GREEN}✅ Nginx 配置验证成功！${NC}"
        
        # 显示配置文件路径
        echo -e "\n${BLUE}配置文件位置：${NC}"
        nginx -T 2>/dev/null | grep -E "^# configuration file" | head -10
    else
        echo -e "\n${RED}❌ Nginx 配置验证失败！${NC}"
        
        # 尝试显示错误详情
        echo -e "\n${YELLOW}错误详情：${NC}"
        nginx -t 2>&1 | tail -20
    fi
    
    read -p "按回车键继续..."
}

# 19. 重载 Nginx 配置
function reload_nginx() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}       重载 Nginx 配置${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    # 先验证配置
    echo -e "${YELLOW}正在验证配置...${NC}"
    if ! nginx -t 2>/dev/null; then
        echo -e "${RED}❌ 配置验证失败，无法重载${NC}"
        read -p "按回车键继续..."
        return
    fi
    
    echo -e "${GREEN}✅ 配置验证成功${NC}"
    echo ""
    
    echo -e "${YELLOW}请选择重载方式：${NC}"
    echo "1. 优雅重载 (reload)"
    echo "2. 强制重载 (reopen)"
    echo "3. 完全重启 (restart)"
    echo "4. 仅测试不重载"
    read -p "请选择 (1-4): " reload_type
    
    case "$reload_type" in
        1)
            echo -e "${BLUE}执行优雅重载...${NC}"
            systemctl reload nginx 2>/dev/null || nginx -s reload 2>/dev/null
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Nginx 优雅重载成功！${NC}"
            else
                echo -e "${RED}❌ 重载失败${NC}"
            fi
            ;;
        2)
            echo -e "${BLUE}执行强制重载...${NC}"
            systemctl kill -s HUP nginx 2>/dev/null || nginx -s reopen 2>/dev/null
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Nginx 强制重载成功！${NC}"
            else
                echo -e "${RED}❌ 重载失败${NC}"
            fi
            ;;
        3)
            echo -e "${BLUE}执行完全重启...${NC}"
            systemctl restart nginx 2>/dev/null
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Nginx 重启成功！${NC}"
            else
                echo -e "${RED}❌ 重启失败${NC}"
            fi
            ;;
        4)
            echo -e "${YELLOW}仅测试配置，不执行重载${NC}"
            echo -e "${GREEN}配置测试完成${NC}"
            ;;
        *)
            echo -e "${RED}无效的选择${NC}"
            ;;
    esac
    
    # 显示状态
    echo -e "\n${BLUE}Nginx 服务状态：${NC}"
    systemctl status nginx --no-pager -l | head -10
    
    read -p "按回车键继续..."
}

# 20. Nginx 配置文件编辑器
function edit_nginx_config() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}     Nginx 配置文件编辑器${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if ! check_nginx_installed; then
        return
    fi
    
    echo -e "${YELLOW}选择要编辑的配置文件：${NC}"
    echo ""
    
    # 显示配置文件列表
    local config_files=()
    config_files+=("/etc/nginx/nginx.conf (主配置文件)")
    
    if [ -d "/etc/nginx/conf.d" ]; then
        local confd_files=$(find /etc/nginx/conf.d -name "*.conf" -type f 2>/dev/null)
        for file in $confd_files; do
            config_files+=("$file")
        done
    fi
    
    if [ -d "/etc/nginx/sites-available" ]; then
        local sites_files=$(find /etc/nginx/sites-available -name "*" -type f 2>/dev/null)
        for file in $sites_files; do
            config_files+=("$file")
        done
    fi
    
    if [ -d "/etc/nginx/sites-enabled" ]; then
        local enabled_files=$(find /etc/nginx/sites-enabled -name "*" -type f 2>/dev/null)
        for file in $enabled_files; do
            config_files+=("$file (已启用)")
        done
    fi
    
    # 显示文件列表
    for i in "${!config_files[@]}"; do
        echo -e "$((i+1)). ${GREEN}${config_files[$i]}${NC}"
    done
    
    echo ""
    echo -e "0. 创建新配置文件"
    echo ""
    
    read -p "请选择文件编号 (0-${#config_files[@]}): " file_choice
    
    local selected_file=""
    
    if [ "$file_choice" = "0" ]; then
        read -p "请输入新文件名 (例如: my_site.conf): " new_file
        selected_file="/etc/nginx/conf.d/$new_file"
        
        # 创建模板
        cat > "$selected_file" << EOF
# Nginx 配置模板
# 创建时间: $(date)

server {
    listen 80;
    listen [::]:80;
    server_name example.com www.example.com;
    
    # 访问日志
    access_log /var/log/nginx/example_access.log;
    error_log /var/log/nginx/example_error.log;
    
    # 网站根目录
    root /var/www/example;
    index index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
    
    # 静态文件缓存
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
EOF
        
        echo -e "${GREEN}已创建配置文件: $selected_file${NC}"
    else
        local index=$((file_choice-1))
        if [ "$index" -ge 0 ] && [ "$index" -lt ${#config_files[@]} ]; then
            selected_file=$(echo "${config_files[$index]}" | awk '{print $1}')
        else
            echo -e "${RED}无效的选择${NC}"
            return
        fi
    fi
    
    if [ -n "$selected_file" ]; then
        echo -e "\n${YELLOW}正在编辑: $selected_file${NC}"
        echo ""
        
        # 显示文件内容
        echo -e "${BLUE}文件内容预览：${NC}"
        echo -e "${CYAN}-----------------------------------------${NC}"
        head -30 "$selected_file" 2>/dev/null || echo -e "${RED}文件为空或不存在${NC}"
        echo -e "${CYAN}-----------------------------------------${NC}"
        
        # 选择编辑器
        echo -e "\n${YELLOW}选择编辑器：${NC}"
        echo "1. nano (简单)"
        echo "2. vim (高级)"
        echo "3. 直接编辑 (使用系统默认编辑器)"
        read -p "请选择 (1-3): " editor_choice
        
        case "$editor_choice" in
            1)
                if command -v nano &> /dev/null; then
                    nano "$selected_file"
                else
                    echo -e "${RED}nano 未安装${NC}"
                    return
                fi
                ;;
            2)
                if command -v vim &> /dev/null; then
                    vim "$selected_file"
                else
                    echo -e "${RED}vim 未安装${NC}"
                    return
                fi
                ;;
            3)
                ${EDITOR:-vi} "$selected_file"
                ;;
            *)
                echo -e "${RED}无效的选择${NC}"
                return
                ;;
        esac
        
        # 编辑后验证
        echo -e "\n${YELLOW}验证配置文件...${NC}"
        if nginx -t 2>/dev/null; then
            echo -e "${GREEN}✅ 配置验证成功${NC}"
            
            read -p "是否立即重载 Nginx 使更改生效？(y/N): " reload_now
            if [[ "$reload_now" =~ ^[yY]$ ]]; then
                systemctl reload nginx 2>/dev/null
                echo -e "${GREEN}✅ 配置已重载${NC}"
            fi
        else
            echo -e "${RED}❌ 配置验证失败${NC}"
            echo -e "${YELLOW}错误信息：${NC}"
            nginx -t 2>&1 | tail -5
        fi
    fi
    
    read -p "按回车键继续..."
}

# =========================================
# 辅助函数
# =========================================

# 检查 Nginx 是否安装
function check_nginx_installed() {
    if ! command -v nginx &> /dev/null; then
        echo -e "${RED}Nginx 未安装！${NC}"
        echo -e "请使用菜单选项 16 安装 Nginx"
        read -p "按回车键继续..."
        return 1
    fi
    return 0
}

# 验证 Nginx 配置（静默模式）
function verify_nginx_config_silent() {
    nginx -t >/dev/null 2>&1
    return $?
}

# 重载 Nginx（静默模式）
function reload_nginx_silent() {
    systemctl reload nginx >/dev/null 2>&1 || nginx -s reload >/dev/null 2>&1
    return $?
}

# 备份单个配置文件
function backup_nginx_single_config() {
    local config_file="$1"
    local backup_dir="/etc/nginx/backups"
    
    if [ -f "$config_file" ]; then
        mkdir -p "$backup_dir"
        local backup_file="$backup_dir/$(basename "$config_file").backup.$(date +%Y%m%d_%H%M%S)"
        cp "$config_file" "$backup_file"
        echo -e "${GREEN}已备份: $backup_file${NC}"
    fi
}

# 恢复单个配置文件
function restore_nginx_single_config() {
    local config_file="$1"
    local backup_dir="/etc/nginx/backups"
    
    local latest_backup=$(find "$backup_dir" -name "$(basename "$config_file").backup.*" -type f 2>/dev/null | sort -r | head -1)
    
    if [ -f "$latest_backup" ]; then
        cp "$latest_backup" "$config_file"
        echo -e "${GREEN}已从备份恢复: $latest_backup${NC}"
        return 0
    else
        echo -e "${RED}未找到备份文件${NC}"
        return 1
    fi
}

# 安装 GeoIP 数据库
function install_geoip_database() {
    echo -e "${YELLOW}安装 GeoIP 数据库...${NC}"
    
    # 检测系统
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        local os_name=$ID
    else
        os_name=$(uname -s)
    fi
    
    case "$os_name" in
        ubuntu|debian)
            apt update
            apt install -y libmaxminddb0 libmaxminddb-dev mmdb-bin
            ;;
        centos|rhel|fedora|rocky|almalinux)
            if command -v dnf &> /dev/null; then
                dnf install -y libmaxminddb libmaxminddb-devel
            else
                yum install -y libmaxminddb libmaxminddb-devel
            fi
            ;;
    esac
    
    # 下载 GeoIP2 数据库
    echo -e "${YELLOW}下载 GeoIP2 数据库...${NC}"
    mkdir -p /usr/share/GeoIP
    wget -O /usr/share/GeoIP/GeoLite2-Country.mmdb https://raw.githubusercontent.com/P3TERX/GeoLite.mmdb/download/GeoLite2-Country.mmdb 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ GeoIP 数据库安装完成${NC}"
    else
        echo -e "${RED}❌ GeoIP 数据库下载失败${NC}"
    fi
}

# 处理批量规则
function process_batch_rules() {
    local rules_file="$1"
    
    echo -e "\n${YELLOW}处理批量规则...${NC}"
    
    # 读取规则文件
    local nginx_config=$(mktemp)
    
    echo "# 批量重定向规则" > "$nginx_config"
    echo "# 生成时间: $(date)" >> "$nginx_config"
    echo "" >> "$nginx_config"
    echo "server {" >> "$nginx_config"
    echo "    listen 80;" >> "$nginx_config"
    echo "    listen [::]:80;" >> "$nginx_config"
    echo "    server_name _;" >> "$nginx_config"
    echo "" >> "$nginx_config"
    
    # 处理每条规则
    while IFS= read -r rule || [ -n "$rule" ]; do
        # 跳过注释和空行
        [[ "$rule" =~ ^# ]] && continue
        [[ -z "$rule" ]] && continue
        
        # 解析规则
        read -r from_url to_url status_code <<< "$rule"
        status_code=${status_code:-"301"}
        
        # 生成 rewrite 规则
        echo "    rewrite ^${from_url}$ ${to_url} $status_code;" >> "$nginx_config"
    done < "$rules_file"
    
    echo "" >> "$nginx_config"
    echo "    # 默认配置" >> "$nginx_config"
    echo "    location / {" >> "$nginx_config"
    echo "        return 404;" >> "$nginx_config"
    echo "    }" >> "$nginx_config"
    echo "}" >> "$nginx_config"
    
    # 显示生成的配置
    echo -e "\n${BLUE}生成的 Nginx 配置：${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
    cat "$nginx_config"
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "是否保存此配置？(y/N): " save_config
    if [[ "$save_config" =~ ^[yY]$ ]]; then
        local output_file="/etc/nginx/conf.d/batch_redirects_$(date +%Y%m%d_%H%M%S).conf"
        cp "$nginx_config" "$output_file"
        chmod 644 "$output_file"
        echo -e "${GREEN}配置已保存到: $output_file${NC}"
    fi
    
    rm -f "$rules_file" "$nginx_config"
}

# 处理 CSV 文件
function process_csv_file() {
    local csv_file="$1"
    local col_numbers="$2"
    
    echo -e "${YELLOW}处理 CSV 文件...${NC}"
    
    # 解析列号
    IFS=',' read -r old_col new_col code_col <<< "$col_numbers"
    old_col=${old_col:-1}
    new_col=${new_col:-2}
    code_col=${code_col:-3}
    
    local nginx_config=$(mktemp)
    local rule_count=0
    
    echo "# 从 CSV 文件导入的重定向规则" > "$nginx_config"
    echo "# 生成时间: $(date)" >> "$nginx_config"
    echo "" >> "$nginx_config"
    echo "server {" >> "$nginx_config"
    echo "    listen 80;" >> "$nginx_config"
    echo "    listen [::]:80;" >> "$nginx_config"
    echo "    server_name _;" >> "$nginx_config"
    echo "" >> "$nginx_config"
    
    # 处理 CSV 文件
    while IFS= read -r line || [ -n "$line" ]; do
        # 跳过注释和空行
        [[ "$line" =~ ^# ]] && continue
        [[ -z "$line" ]] && continue
        
        # 解析 CSV 行（简单处理）
        IFS=',' read -ra fields <<< "$line"
        
        local from_url="${fields[$((old_col-1))]}"
        local to_url="${fields[$((new_col-1))]}"
        local status_code="${fields[$((code_col-1))]:-301}"
        
        # 清理字段
        from_url=$(echo "$from_url" | tr -d '"' | tr -d "'")
        to_url=$(echo "$to_url" | tr -d '"' | tr -d "'")
        
        if [ -n "$from_url" ] && [ -n "$to_url" ]; then
            echo "    rewrite ^${from_url}$ ${to_url} $status_code;" >> "$nginx_config"
            rule_count=$((rule_count+1))
        fi
    done < "$csv_file"
    
    if [ "$rule_count" -eq 0 ]; then
        echo -e "${RED}未找到有效的重定向规则${NC}"
        return
    fi
    
    echo "" >> "$nginx_config"
    echo "}" >> "$nginx_config"
    
    echo -e "\n${GREEN}成功解析了 $rule_count 条规则${NC}"
    
    # 显示生成的配置
    echo -e "\n${BLUE}生成的 Nginx 配置：${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
    head -50 "$nginx_config"
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "是否保存此配置？(y/N): " save_config
    if [[ "$save_config" =~ ^[yY]$ ]]; then
        local output_file="/etc/nginx/conf.d/csv_redirects_$(date +%Y%m%d_%H%M%S).conf"
        cp "$nginx_config" "$output_file"
        chmod 644 "$output_file"
        echo -e "${GREEN}配置已保存到: $output_file${NC}"
    fi
    
    rm -f "$nginx_config"
}

# 从 URL 列表生成重定向
function generate_redirects_from_urls() {
    local urls="$1"
    local old_prefix="$2"
    local new_prefix="$3"
    
    local nginx_config=$(mktemp)
    local rule_count=0
    
    echo "# 从 URL 列表生成的重定向规则" > "$nginx_config"
    echo "# 生成时间: $(date)" >> "$nginx_config"
    echo "# 旧前缀: $old_prefix" >> "$nginx_config"
    echo "# 新前缀: $new_prefix" >> "$nginx_config"
    echo "" >> "$nginx_config"
    
    # 为每个 URL 生成规则
    echo "$urls" | while IFS= read -r url; do
        if [ -n "$url" ]; then
            local new_url="${url/$old_prefix/$new_prefix}"
            
            if [ "$url" != "$new_url" ]; then
                echo "# $url" >> "$nginx_config"
                echo "rewrite ^${url}$ ${new_url} permanent;" >> "$nginx_config"
                rule_count=$((rule_count+1))
            fi
        fi
    done
    
    echo -e "${GREEN}成功生成了 $rule_count 条规则${NC}"
    
    # 显示生成的配置
    if [ "$rule_count" -gt 0 ]; then
        echo -e "\n${BLUE}生成的 Nginx 配置：${NC}"
        echo -e "${CYAN}-----------------------------------------${NC}"
        head -50 "$nginx_config"
        echo -e "${CYAN}-----------------------------------------${NC}"
        
        read -p "是否保存此配置？(y/N): " save_config
        if [[ "$save_config" =~ ^[yY]$ ]]; then
            local output_file="/etc/nginx/conf.d/url_redirects_$(date +%Y%m%d_%H%M%S).conf"
            cp "$nginx_config" "$output_file"
            chmod 644 "$output_file"
            echo -e "${GREEN}配置已保存到: $output_file${NC}"
        fi
    else
        echo -e "${YELLOW}未生成任何规则${NC}"
    fi
    
    rm -f "$nginx_config"
}

# 从日志生成重定向规则
function generate_redirects_from_logs() {
    local not_found_urls="$1"
    
    echo -e "\n${YELLOW}基于日志生成重定向规则...${NC}"
    
    local nginx_config=$(mktemp)
    local rule_count=0
    
    echo "# 从 404 日志生成的重定向规则" > "$nginx_config"
    echo "# 生成时间: $(date)" >> "$nginx_config"
    echo "" >> "$nginx_config"
    
    echo "$not_found_urls" | while IFS= read -r line; do
        local count=$(echo "$line" | awk '{print $1}')
        local url=$(echo "$line" | awk '{print $2}')
        
        if [ "$count" -gt 5 ]; then  # 只处理频繁出现的 404
            # 尝试猜测正确的 URL
            local suggested_url=$(suggest_correct_url "$url")
            
            if [ -n "$suggested_url" ]; then
                echo "# 404 次数: $count" >> "$nginx_config"
                echo "rewrite ^${url}$ ${suggested_url} permanent;" >> "$nginx_config"
                rule_count=$((rule_count+1))
            fi
        fi
    done
    
    if [ "$rule_count" -gt 0 ]; then
        echo -e "${GREEN}成功生成了 $rule_count 条规则${NC}"
        
        # 显示配置
        echo -e "\n${BLUE}生成的配置：${NC}"
        cat "$nginx_config"
        
        read -p "是否保存此配置？(y/N): " save_config
        if [[ "$save_config" =~ ^[yY]$ ]]; then
            local output_file="/etc/nginx/conf.d/log_redirects_$(date +%Y%m%d_%H%M%S).conf"
            cp "$nginx_config" "$output_file"
            chmod 644 "$output_file"
            echo -e "${GREEN}配置已保存到: $output_file${NC}"
        fi
    else
        echo -e "${YELLOW}未生成任何规则${NC}"
    fi
    
    rm -f "$nginx_config"
}

# 建议正确的 URL（简单实现）
function suggest_correct_url() {
    local url="$1"
    
    # 移除尾部斜杠
    url="${url%/}"
    
    # 检查可能的正确 URL
    local suggestions=()
    
    # 常见修正
    suggestions+=("${url}.html")
    suggestions+=("${url}/index.html")
    suggestions+=("${url}/index.php")
    
    # 如果 URL 包含数字 ID，可能是旧的固定链接
    if [[ "$url" =~ /[0-9]+$ ]]; then
        suggestions+=("/post/${url##*/}")
        suggestions+=("/article/${url##*/}")
    fi
    
    # 返回第一个建议
    echo "${suggestions[0]}"
}