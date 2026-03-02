#!/bin/bash

# 应用中心模块

# 应用中心菜单
function app_center_menu() {
    while true; do
        clear
        echo -e "${CYAN}================================================================${NC}"
        echo -e "${GREEN}                        应用中心菜单${NC}"
        echo -e "${CYAN}================================================================${NC}"
        echo -e " ${GREEN}1.${NC}  1Panel新一代管理面板            ${GREEN}2.${NC}  哪吒探针VPS监控面板"
        echo -e " ${GREEN}3.${NC}  TCP窗口调优                     ${GREEN}4.${NC}  磁盘空间分析"
        echo -e " ${GREEN}5.${NC}  BTOP系统监控工具                ${GREEN}6.${NC}  一键更换软件源"
        echo -e " ${GREEN}7.${NC}  Komari管理                      ${GREEN}8.${NC}  PanSou网盘管理"
        echo -e " ${GREEN}9.${NC}  Watchtower容器自动更新          ${GREEN}10.${NC} AdGuard Home安装（vps）"
        echo -e " ${GREEN}11.${NC} Nginx Proxy Manager管理         ${GREEN}12.${NC} GitHub加速站"
        echo -e " ${GREEN}13.${NC} MoonTV流媒体应用管理            ${GREEN}14.${NC} LibreTV流媒体应用管理"
        echo -e " ${GREEN}15.${NC} FRP内网穿透管理                 ${GREEN}16.${NC} 雷池WAF安全防护系统"
        echo -e " ${GREEN}17.${NC} AkileCloud专用脚本              ${GREEN}18.${NC} VScode 网页版 (code-server)"
        echo -e " ${GREEN}19.${NC} Lucky (大神级 DDNS/反代/SSL)    ${GREEN}20.${NC} Docker 镜像加速站一站式管理"
        echo -e " ${GREEN}21.${NC} 小雅alist 管理                  ${GREEN}22.${NC} Open WebUI 管理"
        echo -e " ${GREEN}23.${NC} LibreSpeed 测速工具             ${GREEN}24.${NC} MAME 街机模拟器"
        echo -e " ${GREEN}25.${NC} MyIP 工具箱 (IP/网络工具)       ${GREEN}26.${NC} IT-Tools (万能工具箱)"
        echo -e " ${GREEN}27.${NC} Uptime Kuma (站点监控)          ${GREEN}28.${NC} 功能待定"
        echo -e "${CYAN}----------------------------------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回主菜单"
        echo -e "${CYAN}================================================================${NC}"
        read -p "请输入你的选择 (0-28) : " app_choice

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
            16) safeline_waf_management ;;
            17) akilecloud_management ;;
            18) vscode_management ;;
            19) lucky_management ;;
            20) docker_proxy_management ;;
            21) xiaoya_alist_management ;;
            22) open_webui_management ;;
            23) librespeed_management ;;
            24) mame_management ;;
            25) myip_management ;;
            26) it_tools_management ;;
            27) uptime_kuma_management ;;
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
        
        local status_text="${RED}未安装${NC}"
        local actual_port=""
        
        if command -v 1pctl &> /dev/null; then
            status_text="${GREEN}已安装${NC}"
            
            # 尝试获取实际端口信息
            actual_port="17001"
            
            # 方法1: 从 1Panel 配置文件中读取端口
            if [ -f "/opt/1panel/conf/app.conf" ]; then
                local config_port=$(grep "^server.port" /opt/1panel/conf/app.conf 2>/dev/null | cut -d'=' -f2)
                if [ -n "$config_port" ] && [ "$config_port" -gt 0 ] 2>/dev/null; then
                    actual_port="$config_port"
                fi
            fi
            
            # 方法2: 从 1pctl 输出中提取端口信息
            local user_info=$(1pctl user-info 2>/dev/null)
            if echo "$user_info" | grep -q "面板地址:"; then
                local panel_url=$(echo "$user_info" | grep "面板地址:" | sed 's/面板地址://' | tr -d ' ')
                if [[ "$panel_url" =~ :([0-9]+)/ ]]; then
                    actual_port="${BASH_REMATCH[1]}"
                fi
            fi
        fi
        
        echo -e "          状态: ${status_text}"
        if [ -n "$actual_port" ] && [ "$actual_port" != "17001" ]; then
            IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
            echo -e "${CYAN}-----------------------------------------${NC}"
            [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${actual_port}${NC}"
            [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${actual_port}${NC}"
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

# 哪吒探针 (Agent) 管理模块 - 官方脚本重构版
function nezha_probe_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          哪吒探针 (Agent) 管理${NC}"
        
        # 状态检测逻辑
        local status_text="${RED}未安装${NC}"
        if [ -f "/etc/systemd/system/nezha-agent.service" ]; then
            if systemctl is-active --quiet nezha-agent; then
                status_text="${GREEN}运行中 (Systemd)${NC}"
            else
                status_text="${YELLOW}已停止 (Systemd)${NC}"
            fi
        fi

        echo -e "          状态: ${status_text}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  安装/更新 Agent (官方脚本)"
        echo -e " ${GREEN}2.${NC}  启动 Agent"
        echo -e " ${GREEN}3.${NC}  停止 Agent"
        echo -e " ${GREEN}4.${NC}  重启 Agent"
        echo -e " ${GREEN}5.${NC}  查看服务详细状态"
        echo -e " ${GREEN}6.${NC}  查看实时日志"
        echo -e " ${GREEN}7.${NC}  卸载 Agent"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-7): " nezha_choice

        case "$nezha_choice" in
            1) install_nezha_official ;;
            2) sudo systemctl start nezha-agent && echo -e "${GREEN}启动指令已发送${NC}" || echo -e "${RED}启动失败${NC}"; sleep 1 ;;
            3) sudo systemctl stop nezha-agent && echo -e "${YELLOW}停止指令已发送${NC}" || echo -e "${RED}停止失败${NC}"; sleep 1 ;;
            4) sudo systemctl restart nezha-agent && echo -e "${GREEN}重启指令已发送${NC}" || echo -e "${RED}重启失败${NC}"; sleep 1 ;;
            5) clear; systemctl status nezha-agent; 
                echo -e "\n${CYAN}-----------------------------------------${NC}";
                echo -e "${BLUE}连接信息:${NC}";
                echo -e "哪吒探针是监控代理，需要连接到哪吒面板服务器";
                echo -e "请登录您的哪吒面板查看监控数据";
                read -p "按回车键继续..." ;;
            6) clear; echo -e "${BLUE}正在查看实时日志 (按 Ctrl+C 退出):${NC}"; journalctl -u nezha-agent -n 50 -f ;;
            7) uninstall_nezha_official ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 1 ;;
        esac
    done
}

# 调用官方脚本进行安装/管理
function run_nezha_script() {
    local cmd_param=$1
    echo -e "${BLUE}正在连接 GitHub 获取官方脚本...${NC}"
    # 下载脚本
    curl -L https://raw.githubusercontent.com/nezhahq/scripts/refs/heads/main/install.sh -o nezha_script.sh && chmod +x nezha_script.sh
    
    if [ $? -eq 0 ]; then
        if [ -n "$cmd_param" ]; then
            sudo ./nezha_script.sh "$cmd_param"
        else
            sudo ./nezha_script.sh
        fi
        rm -f nezha_script.sh
    else
        echo -e "${RED}❌ 脚本下载失败，请检查网络（尝试使用代理或检查 GitHub 访问）${NC}"
        read -p "按回车键继续..."
    fi
}

function install_nezha_official() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        安装/更新哪吒探针 Agent${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${YELLOW}提示：进入脚本后请选择 '安装监控 Agent'。${NC}"
    echo -e "${YELLOW}你需要准备好面板域名和密钥 (Secret)。${NC}"
    echo ""
    read -p "确认开始？(y/n): " confirm
    [[ "$confirm" =~ ^[yY]$ ]] && run_nezha_script
}

function uninstall_nezha_official() {
    clear
    echo -e "${RED}=========================================${NC}"
    echo -e "${RED}             卸载哪吒探针 Agent${NC}"
    echo -e "${RED}=========================================${NC}"
    read -p "确定要卸载吗？此操作不可逆 (y/n): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        run_nezha_script "uninstall_agent"
        echo -e "${GREEN}卸载流程已完成。${NC}"
        sleep 1
    fi
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
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}            磁盘空间分析${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${BLUE}系统磁盘概况：${NC}"
        df -h
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${GREEN}1.${NC}  查看根目录各文件夹大小"
        echo -e " ${GREEN}2.${NC}  查找系统最大的 20 个文件 (支持删除)"
        echo -e " ${GREEN}3.${NC}  使用 ncdu 进行交互式分析 (推荐)"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回应用中心菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-3): " disk_choice

        case "$disk_choice" in
            1)
                echo -e "${BLUE}正在分析根目录各文件夹大小，请稍候...${NC}"
                # 排除一些虚拟文件系统目录以加快速度并避免错误
                du -h --max-depth=1 --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/run / 2>/dev/null | sort -hr
                echo -e "${CYAN}-----------------------------------------${NC}"
                read -p "按回车键继续..."
                ;;
            2)
                echo -e "${BLUE}正在查找系统最大的 20 个文件，这可能需要一点时间...${NC}"
                # 查找系统最大的20个文件，排除虚拟文件系统
                # 使用当前目录下的临时文件，避免 /tmp 不存在的问题
                temp_file="./disk_analysis_temp_$(date +%s).txt"
                find / -type f -not -path "/proc/*" -not -path "/sys/*" -not -path "/dev/*" -not -path "/run/*" -not -path "/boot/*" -exec du -h {} + 2>/dev/null | sort -hr | head -n 20 > "$temp_file"
                
                if [ ! -s "$temp_file" ]; then
                    echo -e "${YELLOW}未找到文件。${NC}"
                else
                    echo -e "${CYAN}-----------------------------------------${NC}"
                    echo -e "序号\t大小\t状态\t\t文件路径"
                    i=1
                    declare -A file_map
                    while read -r size path; do
                        # 检查文件是否被进程占用
                        if command -v lsof &> /dev/null; then
                            usage_check=$(lsof "$path" 2>/dev/null | tail -n +2)
                        else
                            # 如果没有 lsof，尝试用 fuser
                            if command -v fuser &> /dev/null; then
                                usage_check=$(fuser "$path" 2>/dev/null)
                            else
                                usage_check=""
                            fi
                        fi

                        if [ -n "$usage_check" ]; then
                            status="${RED}[占用中]${NC}"
                            desc="(建议不要删除)"
                        elif [[ "$path" == *".log"* ]]; then
                            status="${GREEN}[日志]${NC}  "
                            desc="(通常可删)"
                        elif [[ "$path" == *".tmp"* || "$path" == *"/tmp/"* ]]; then
                            status="${GREEN}[临时]${NC}  "
                            desc="(通常可删)"
                        elif [[ "$path" == *".gz"* || "$path" == *".zip"* || "$path" == *".tar"* || "$path" == *".iso"* ]]; then
                            status="${YELLOW}[压缩包]${NC}"
                            desc="(确认内容后可删)"
                        elif [[ "$path" == *"/swap"* || "$path" == *"swapfile"* ]]; then
                            status="${RED}[交换区]${NC}"
                            desc="(系统文件，勿删)"
                        else
                            status="${BLUE}[文件]${NC}  "
                            desc=""
                        fi

                        echo -e " [${GREEN}$i${NC}]\t$size\t$status\t$path $desc"
                        file_map[$i]="$path"
                        ((i++))
                    done < "$temp_file"
                    
                    echo -e "${CYAN}-----------------------------------------${NC}"
                    read -p "请输入要删除的文件序号 (支持多选，空格分隔，输入 0 或回车不删除): " del_input
                    
                    # 将输入转换为数组
                    read -ra del_choices <<< "$del_input"
                    
                    files_to_delete=()
                    valid_files=()

                    for choice in "${del_choices[@]}"; do
                        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -gt 0 ] && [ "$choice" -lt "$i" ]; then
                             file_path="${file_map[$choice]}"
                             
                             # 再次检查占用情况，防止误删关键文件
                             is_locked=false
                             if command -v lsof &> /dev/null; then
                                 if lsof "$file_path" &>/dev/null; then is_locked=true; fi
                             elif command -v fuser &> /dev/null; then
                                 if fuser "$file_path" &>/dev/null; then is_locked=true; fi
                             fi

                             if [ "$is_locked" = true ]; then
                                 echo -e "${RED}警告：文件被占用，跳过: $file_path${NC}"
                             elif [[ "$file_path" == *"/swap"* || "$file_path" == *"swapfile"* ]]; then
                                 echo -e "${RED}警告：可能是系统 Swap 文件，跳过: $file_path${NC}"
                             else
                                 files_to_delete+=("$file_path")
                                 valid_files+=("$choice")
                             fi
                        elif [ "$choice" != "0" ]; then
                             echo -e "${YELLOW}忽略无效序号: $choice${NC}"
                        fi
                    done

                    if [ ${#files_to_delete[@]} -gt 0 ]; then
                        echo -e "${RED}即将删除以下 ${#files_to_delete[@]} 个文件:${NC}"
                        for file in "${files_to_delete[@]}"; do
                            echo -e "  - $file"
                        done
                        
                        read -p "确认全部删除吗？(y/n): " confirm
                        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                            for file in "${files_to_delete[@]}"; do
                                rm -f "$file"
                                if [ $? -eq 0 ]; then
                                    echo -e "${GREEN}删除成功: $file${NC}"
                                else
                                    echo -e "${RED}删除失败: $file${NC}"
                                fi
                            done
                        else
                            echo -e "${YELLOW}已取消删除。${NC}"
                        fi
                    elif [[ "$del_input" != "0" && -n "$del_input" ]]; then
                        echo -e "${YELLOW}未选择有效文件。${NC}"
                    fi
                fi
                rm -f "$temp_file"
                echo -e "${CYAN}-----------------------------------------${NC}"
                read -p "按回车键继续..."
                ;;
            3)
                if ! command -v ncdu &> /dev/null; then
                    echo -e "${YELLOW}未检测到 ncdu，正在安装...${NC}"
                    if [ -f /etc/debian_version ]; then
                        apt-get update && apt-get install -y ncdu
                    elif [ -f /etc/redhat-release ]; then
                        if ! rpm -qa | grep -q epel-release; then
                            yum install -y epel-release
                        fi
                        yum install -y ncdu
                    else
                        echo -e "${RED}不支持的系统，请手动安装 ncdu。${NC}"
                    fi
                fi
                
                if command -v ncdu &> /dev/null; then
                    ncdu /
                else
                    echo -e "${RED}ncdu 安装失败或不可用。${NC}"
                    read -p "按回车键继续..."
                fi
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
    
    # 检查 Docker Compose 是否可用
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        echo -e "${RED}❌ 错误: 未检测到 Docker Compose，请先安装。${NC}"
        return
    fi

    # 创建部署目录
    local deploy_dir="/opt/watchtower"
    mkdir -p "$deploy_dir"
    cd "$deploy_dir" || return

    # 检查容器是否已存在
    if docker ps -a --format '{{.Names}}' | grep -q "^watchtower$"; then
        echo -e "${YELLOW}⚠️  Watchtower 容器已存在。${NC}"
        read -p "是否停止并使用 Docker Compose 重新部署？(y/N): " reinstall
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
    
    local env_file=".env"
    local compose_file="docker-compose.yml"
    
    # 初始化环境变量文件
    echo "TZ=$(timedatectl | grep "Time zone" | awk '{print $3}' || echo "Asia/Shanghai")" > "$env_file"
    
    case $mode in
        1)
            # 基础模式
            echo "WATCHTOWER_POLL_INTERVAL=86400" >> "$env_file"
            local containers=""
            ;;
        2)
            # 自定义模式
            echo ""
            echo -e "${YELLOW}自定义配置选项：${NC}"
            read -p "检查间隔（默认 24h，支持 30m、2h 等）: " interval
            interval=${interval:-"24h"}
            # 转换为秒（Watchtower 环境变量支持秒或间隔）
            echo "WATCHTOWER_POLL_INTERVAL=${interval}" >> "$env_file"
            
            read -p "是否启用通知？(y/N): " enable_notifications
            if [[ "$enable_notifications" =~ ^[yY]$ ]]; then
                read -p "通知类型（shoutrrr URL，如 slack://、discord://）: " notify_url
                if [ -n "$notify_url" ]; then
                    echo "WATCHTOWER_NOTIFICATIONS=shoutrrr" >> "$env_file"
                    echo "WATCHTOWER_NOTIFICATION_URL=${notify_url}" >> "$env_file"
                fi
            fi
            
            read -p "是否监控所有容器？(Y/n): " monitor_all
            monitor_all=${monitor_all:-"Y"}
            
            local containers=""
            if [[ ! "$monitor_all" =~ ^[yY]$ ]]; then
                echo ""
                echo -e "可监控的容器列表："
                docker ps --format "{{.Names}}" | grep -v "watchtower" | nl
                echo ""
                read -p "输入要监控的容器编号（多个用空格分隔）: " container_nums
                
                if [ -n "$container_nums" ]; then
                    for num in $container_nums; do
                        local name=$(docker ps --format "{{.Names}}" | grep -v "watchtower" | sed -n "${num}p")
                        [ -n "$name" ] && containers="$containers $name"
                    done
                fi
            fi
            ;;
        3)
            # 白名单模式
            echo "WATCHTOWER_POLL_INTERVAL=86400" >> "$env_file"
            echo ""
            echo -e "可监控的容器列表："
            docker ps --format "{{.Names}}" | grep -v "watchtower" | nl
            echo ""
            read -p "输入要监控的容器编号（多个用空格分隔）: " container_nums
            
            local containers=""
            if [ -n "$container_nums" ]; then
                for num in $container_nums; do
                    local name=$(docker ps --format "{{.Names}}" | grep -v "watchtower" | sed -n "${num}p")
                    [ -n "$name" ] && containers="$containers $name"
                done
            fi
            ;;
        *)
            echo -e "${RED}❌ 无效选择。${NC}"
            return
            ;;
    esac

    # 生成 docker-compose.yml
    cat > "$compose_file" <<EOF
version: '3'
services:
  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    env_file: .env
EOF

    # 如果有指定容器，添加到 command
    if [ -n "$containers" ]; then
        echo "    command: $containers" >> "$compose_file"
    fi

    echo -e "${BLUE}正在使用 Docker Compose 部署 Watchtower...${NC}"
    if docker compose up -d || docker-compose up -d; then
        echo -e "${GREEN}✅ Watchtower 部署成功！${NC}"
        echo -e "部署目录: ${deploy_dir}"
    else
        echo -e "${RED}❌ 部署失败，请检查 Docker Compose 状态。${NC}"
    fi
}
function start_watchtower() {
    local deploy_dir="/opt/watchtower"
    if [ -d "$deploy_dir" ]; then
        cd "$deploy_dir" && (docker compose start || docker-compose start)
        echo -e "${GREEN}✅ Watchtower 已启动${NC}"
    else
        docker start watchtower 2>/dev/null && echo -e "${GREEN}✅ Watchtower 已启动${NC}"
    fi
}

function stop_watchtower() {
    local deploy_dir="/opt/watchtower"
    if [ -d "$deploy_dir" ]; then
        cd "$deploy_dir" && (docker compose stop || docker-compose stop)
        echo -e "${GREEN}✅ Watchtower 已停止${NC}"
    else
        docker stop watchtower 2>/dev/null && echo -e "${GREEN}✅ Watchtower 已停止${NC}"
    fi
}

function restart_watchtower() {
    local deploy_dir="/opt/watchtower"
    if [ -d "$deploy_dir" ]; then
        cd "$deploy_dir" && (docker compose restart || docker-compose restart)
        echo -e "${GREEN}✅ Watchtower 已重启${NC}"
    else
        docker restart watchtower 2>/dev/null && echo -e "${GREEN}✅ Watchtower 已重启${NC}"
    fi
}

function configure_watchtower() {
    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}          配置 Watchtower 选项${NC}"
    echo -e "${CYAN}==========================================${NC}"
    
    local deploy_dir="/opt/watchtower"
    local use_compose=false
    if [ -d "$deploy_dir" ] && [ -f "$deploy_dir/docker-compose.yml" ]; then
        use_compose=true
    fi

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
                if [ "$use_compose" = true ]; then
                    sed -i "s/WATCHTOWER_POLL_INTERVAL=.*/WATCHTOWER_POLL_INTERVAL=${new_interval}/" "$deploy_dir/.env"
                    cd "$deploy_dir" && (docker compose up -d || docker-compose up -d)
                else
                    echo "停止并重新创建容器..."
                    docker stop watchtower >/dev/null 2>&1
                    docker rm watchtower >/dev/null 2>&1
                    docker run -d --name watchtower --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --interval $new_interval
                fi
                echo -e "${GREEN}✅ 检查间隔已更新为 ${new_interval}${NC}"
            fi
            ;;
        2)
            echo -e "${YELLOW}通知配置示例：${NC}"
            echo "Slack: slack://token-a/token-b/token-c"
            echo "Discord: discord://token@webhook_id"
            echo ""
            read -p "请输入 shoutrrr URL（留空则禁用通知）: " notify_url
            
            if [ "$use_compose" = true ]; then
                if [ -z "$notify_url" ]; then
                    sed -i "/WATCHTOWER_NOTIFICATIONS/d" "$deploy_dir/.env"
                    sed -i "/WATCHTOWER_NOTIFICATION_URL/d" "$deploy_dir/.env"
                else
                    grep -q "WATCHTOWER_NOTIFICATIONS" "$deploy_dir/.env" && sed -i "s|WATCHTOWER_NOTIFICATIONS=.*|WATCHTOWER_NOTIFICATIONS=shoutrrr|" "$deploy_dir/.env" || echo "WATCHTOWER_NOTIFICATIONS=shoutrrr" >> "$deploy_dir/.env"
                    grep -q "WATCHTOWER_NOTIFICATION_URL" "$deploy_dir/.env" && sed -i "s|WATCHTOWER_NOTIFICATION_URL=.*|WATCHTOWER_NOTIFICATION_URL=${notify_url}|" "$deploy_dir/.env" || echo "WATCHTOWER_NOTIFICATION_URL=${notify_url}" >> "$deploy_dir/.env"
                fi
                cd "$deploy_dir" && (docker compose up -d || docker-compose up -d)
            else
                docker stop watchtower >/dev/null 2>&1
                docker rm watchtower >/dev/null 2>&1
                if [ -z "$notify_url" ]; then
                    docker run -d --name watchtower --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
                    echo -e "${GREEN}✅ 已禁用通知${NC}"
                else
                    docker run -d --name watchtower --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock -e WATCHTOWER_NOTIFICATIONS=shoutrrr -e WATCHTOWER_NOTIFICATION_URL="$notify_url" containrrr/watchtower
                    echo -e "${GREEN}✅ 通知配置已更新${NC}"
                fi
            fi
            ;;
        3)
            echo ""
            echo "1. 监控所有容器"
            echo "2. 只监控指定容器"
            read -p "选择监控模式: " monitor_mode
            
            if [ "$use_compose" = true ]; then
                if [ "$monitor_mode" = "1" ]; then
                    sed -i "/command:/d" "$deploy_dir/docker-compose.yml"
                else
                    echo "可监控的容器列表："
                    docker ps --format "{{.Names}}" | grep -v "watchtower" | nl
                    echo ""
                    read -p "输入要监控的容器名称（多个用空格分隔）: " containers
                    sed -i "/command:/d" "$deploy_dir/docker-compose.yml"
                    echo "    command: $containers" >> "$deploy_dir/docker-compose.yml"
                fi
                cd "$deploy_dir" && (docker compose up -d || docker-compose up -d)
            else
                docker stop watchtower >/dev/null 2>&1
                docker rm watchtower >/dev/null 2>&1
                if [ "$monitor_mode" = "1" ]; then
                    docker run -d --name watchtower --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
                    echo -e "${GREEN}✅ 已切换为监控所有容器${NC}"
                else
                    echo "可监控的容器列表："
                    docker ps --format "{{.Names}}" | grep -v "watchtower" | nl
                    echo ""
                    read -p "输入要监控的容器名称（多个用空格分隔）: " containers
                    docker run -d --name watchtower --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower $containers
                    echo -e "${GREEN}✅ 已设置为监控指定容器${NC}"
                fi
            fi
            ;;
        4)
            read -p "是否启用自动清理旧镜像？(y/N): " enable_cleanup
            if [[ "$enable_cleanup" =~ ^[yY]$ ]]; then
                if [ "$use_compose" = true ]; then
                    grep -q "WATCHTOWER_CLEANUP" "$deploy_dir/.env" && sed -i "s/WATCHTOWER_CLEANUP=.*/WATCHTOWER_CLEANUP=true/" "$deploy_dir/.env" || echo "WATCHTOWER_CLEANUP=true" >> "$deploy_dir/.env"
                    cd "$deploy_dir" && (docker compose up -d || docker-compose up -d)
                else
                    docker stop watchtower >/dev/null 2>&1
                    docker rm watchtower >/dev/null 2>&1
                    docker run -d --name watchtower --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --cleanup
                fi
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
        # 修复点：添加环境变量强制使用 1.44 版本的 API
        docker run --rm \
            -e DOCKER_API_VERSION=1.44 \
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
    
    # 检查容器是否存在
    if docker ps -a --format '{{.Names}}' | grep -q "^watchtower$"; then
        echo -e "${GREEN}✅ 容器详细信息：${NC}"
        
        # 修正后的格式化输出：直接使用换行，去掉多余的转义符
        docker inspect watchtower --format='
容器名称: {{.Name}}
容器状态: {{.State.Status}}
运行状态: {{.State.Running}}
镜像: {{.Config.Image}}
创建时间: {{.Created}}
重启策略: {{.HostConfig.RestartPolicy.Name}}
环境变量:
{{range .Config.Env}}  - {{.}}
{{end}}' | sed 's/^/\t/'
        
        echo ""
        echo -e "${YELLOW}最近日志（最后10行）：${NC}"
        echo -e "${CYAN}------------------------------------------${NC}"
        docker logs --tail 10 watchtower 2>/dev/null || echo "暂无日志"
        echo -e "${CYAN}------------------------------------------${NC}"
        
        # 增加一提示，解释为什么它看起来“没在动”
        echo -e "${BLUE}提示: Watchtower 正在后台按计划运行。${NC}"
        echo -e "${BLUE}当前检查间隔: 86400秒 (24小时)${NC}"
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
        local deploy_dir="/opt/watchtower"
        if [ -d "$deploy_dir" ]; then
            cd "$deploy_dir" && (docker compose down || docker-compose down) >/dev/null 2>&1
            rm -rf "$deploy_dir"
            echo -e "${GREEN}✅ 已清理部署目录: ${deploy_dir}${NC}"
        else
            docker stop watchtower >/dev/null 2>&1
            docker rm watchtower >/dev/null 2>&1
        fi
        
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
    docker pull ghcr.io/moontechlab/lunatv:latest
    docker pull apache/kvrocks

    echo -e "${BLUE}正在创建 Docker Compose 配置文件...${NC}"
    
    # 创建 docker-compose.yml - 修复版本和网络问题
    cat > /opt/moontv/docker-compose.yml << EOF
services:
  moontv-core:
    image: ghcr.io/moontechlab/lunatv:latest
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

function modify_moontv_config() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          修改 MoonTV 配置${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if [ ! -f "/opt/moontv/docker-compose.yml" ]; then
        echo -e "${RED}❌ MoonTV 未安装，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi
    
    # 获取当前配置
    local old_port=$(grep -E "[0-9]+:3000" /opt/moontv/docker-compose.yml | grep -oP "[0-9]+(?=:3000)" | head -1)
    old_port=${old_port:-3000}
    
    local old_username=$(grep -oP "USERNAME=\K[^ ]+" /opt/moontv/docker-compose.yml | head -1)
    old_username=${old_username:-admin}
    
    echo -e "${YELLOW}当前配置：${NC}"
    echo -e "端口：${GREEN}${old_port}${NC}"
    echo -e "用户名：${GREEN}${old_username}${NC}"
    echo -e "密码：${YELLOW}已隐藏${NC}"
    echo ""
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}提示：${NC}"
    echo "1. 直接回车表示保持当前配置不变"
    echo "2. 修改配置后将自动重启容器"
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo ""
    
    # 获取新端口
    read -p "请输入新的宿主机映射端口 [${old_port}]: " new_port
    new_port=${new_port:-$old_port}
    
    # 验证端口
    if [ "$new_port" != "$old_port" ]; then
        if command -v ss &> /dev/null; then
            if ss -tuln | grep -q ":${new_port} "; then
                echo -e "${RED}❌ 端口 ${new_port} 已被占用，请选择其他端口。${NC}"
                read -p "按回车键继续..."
                return
            fi
        fi
    fi
    
    # 获取新用户名
    read -p "请输入新的管理员用户名 [${old_username}]: " new_username
    new_username=${new_username:-$old_username}
    
    # 获取新密码
    echo ""
    read -sp "请输入新的管理员密码 (留空表示不变): " new_password
    echo ""
    
    if [ -n "$new_password" ]; then
        read -sp "请再次输入密码确认： " password_confirm
        echo ""
        
        if [ "$new_password" != "$password_confirm" ]; then
            echo -e "${RED}❌ 两次输入的密码不一致，配置已取消。${NC}"
            read -p "按回车键继续..."
            return
        fi
    else
        new_password=$(grep -oP "PASSWORD=\K[^ ]+" /opt/moontv/docker-compose.yml | head -1)
    fi
    
    # 获取站点名称
    local old_site_name=$(grep -oP "NEXT_PUBLIC_SITE_NAME=\K.+" /opt/moontv/docker-compose.yml | head -1 | tr -d '"')
    old_site_name=${old_site_name:-"LunaTV Enhanced"}
    read -p "请输入站点名称 [${old_site_name}]: " new_site_name
    new_site_name=${new_site_name:-$old_site_name}
    
    echo ""
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}配置确认：${NC}"
    echo -e "端口：${GREEN}${new_port}${NC}"
    echo -e "用户名：${GREEN}${new_username}${NC}"
    echo -e "站点名称：${GREEN}${new_site_name}${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo ""
    
    read -p "确认修改并重启容器？(y/N): " confirm_modify
    if [[ ! "$confirm_modify" =~ ^[yY]$ ]]; then
        echo "配置修改已取消。"
        read -p "按回车键继续..."
        return
    fi
    
    echo -e "${BLUE}正在更新配置...${NC}"
    
    # 备份原配置
    cp /opt/moontv/docker-compose.yml /opt/moontv/docker-compose.yml.bak
    
    # 创建新的 docker-compose.yml
    cat > /opt/moontv/docker-compose.yml << EOF
services:
  moontv-core:
    image: ghcr.io/moontechlab/lunatv:latest
    container_name: moontv-core
    restart: on-failure
    ports:
      - '${new_port}:3000'
    environment:
      - USERNAME=${new_username}
      - PASSWORD=${new_password}
      - NEXT_PUBLIC_STORAGE_TYPE=kvrocks
      - KVROCKS_URL=redis://moontv-kvrocks:6666
      - VIDEO_CACHE_DIR=/app/video-cache
      - NEXT_PUBLIC_SITE_NAME=${new_site_name}
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
    
    echo -e "${BLUE}正在重启容器使配置生效...${NC}"
    cd /opt/moontv
    
    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi
    
    $docker_compose_cmd up -d
    
    if [ $? -eq 0 ]; then
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        
        echo -e "${GREEN}✅ 配置修改成功！${NC}"
        echo ""
        echo -e "${CYAN}新的访问信息：${NC}"
        [ -n "$ipv4" ] && echo -e "IPv4 访问地址：${YELLOW}http://${ipv4}:${new_port}${NC}"
        [ -n "$ipv6" ] && echo -e "IPv6 访问地址：${YELLOW}http://[${ipv6}]:${new_port}${NC}"
        echo ""
        echo -e "${CYAN}新的登录凭据：${NC}"
        echo -e "用户名：${GREEN}${new_username}${NC}"
        echo -e "密码：${GREEN}${new_password}${NC}"
        echo ""
        echo -e "${YELLOW}提示：${NC}"
        echo "容器正在重启中，请稍等片刻后访问新地址"
    else
        echo -e "${RED}❌ 配置修改失败，已恢复备份配置。${NC}"
        cp /opt/moontv/docker-compose.yml.bak /opt/moontv/docker-compose.yml
    fi
    
    cd - > /dev/null
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
    local host_port=$(grep -E "[0-9]+:3000" /opt/moontv/docker-compose.yml | grep -oP "[0-9]+(?=:3000)" | head -1)
    host_port=${host_port:-3000}
    
    # 获取用户名
    local username=$(grep -oP "USERNAME=\K[^ ]+" /opt/moontv/docker-compose.yml | head -1)
    username=${username:-admin}
    
    IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
    
    echo -e "您的 MoonTV 访问地址为："
    [ -n "$ipv4" ] && echo -e "IPv4 地址：${YELLOW}http://${ipv4}:${host_port}${NC}"
    [ -n "$ipv6" ] && echo -e "IPv6 地址：${YELLOW}http://[${ipv6}]:${host_port}${NC}"
    echo ""
    echo -e "${CYAN}登录凭据：${NC}"
    echo -e "用户名：${GREEN}${username}${NC}"
    echo -e "密码：${YELLOW}(安装时设置，可在修改配置中查看)${NC}"
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
            if docker ps --format '{{.Names}}' | grep -q "^libretv$"; then
                echo -e "          状态: ${GREEN}运行中${NC}"
                
                # 获取映射端口和显示IP信息
                local host_port=$(docker inspect libretv --format='{{(index (index .NetworkSettings.Ports "8899/tcp") 0).HostPort}}' 2>/dev/null)
                host_port=${host_port:-8899}
                
                IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
                
                echo -e "${CYAN}-----------------------------------------${NC}"
                [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
                [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
            else
                echo -e "          状态: ${YELLOW}已停止${NC}"
            fi
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
            
            # 显示服务器IP信息
            IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
            
            echo -e "${CYAN}-----------------------------------------${NC}"
            echo -e "${BLUE}服务器IP信息:${NC}"
            [ -n "$ipv4" ] && echo -e "IPv4 地址: ${YELLOW}${ipv4}${NC}"
            [ -n "$ipv6" ] && echo -e "IPv6 地址: ${YELLOW}${ipv6}${NC}"
            echo -e "FRPS 默认端口: ${YELLOW}7000${NC}"
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

# =================================================================
# 雷池 WAF (Safeline) 管理模块
# =================================================================

function safeline_waf_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             雷池WAF安全防护系统${NC}"
        
        # 检查安装状态
        local safeline_dir="/data/safeline"
        local status_text="${RED}未安装${NC}"
        
        if [ -d "$safeline_dir" ] && [ -f "$safeline_dir/compose.yaml" ]; then
            # 改为直接检测管理容器是否在运行，更准确
            if docker ps --format '{{.Names}}' | grep -q "^safeline-mgt-api$"; then
                status_text="${GREEN}运行中${NC}"
                
                # 获取映射端口和显示IP信息
                local host_port=$(docker inspect safeline-mgt-api --format='{{(index (index .NetworkSettings.Ports "9443/tcp") 0).HostPort}}' 2>/dev/null)
                host_port=${host_port:-9443}
                
                IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
                
                echo -e "${CYAN}-----------------------------------------${NC}"
                [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
                [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
            else
                status_text="${YELLOW}已安装但未运行${NC}"
            fi
        fi
        
        echo -e "          状态: ${status_text}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  安装雷池 WAF (Docker Compose)"
        echo -e " ${GREEN}2.${NC}  启动雷池 WAF"
        echo -e " ${GREEN}3.${NC}  停止雷池 WAF"
        echo -e " ${GREEN}4.${NC}  重启雷池 WAF"
        echo -e " ${GREEN}5.${NC}  重置管理员密码"
        echo -e " ${GREEN}6.${NC}  查看运行状态"
        echo -e " ${GREEN}7.${NC}  升级雷池 WAF"
        echo -e " ${GREEN}8.${NC}  卸载雷池 WAF"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回上级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择: " sl_choice

        case "$sl_choice" in
            1) install_safeline ;;
            2) safeline_operation "start" ;;
            3) safeline_operation "stop" ;;
            4) safeline_operation "restart" ;;
            5) reset_safeline_password ;;
            6) view_safeline_status ;;
            7) upgrade_safeline ;;
            8) uninstall_safeline ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 2 ;;
        esac
    done
}

function install_safeline() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          安装雷池 WAF (Safeline)${NC}"
    echo -e "${CYAN}=========================================${NC}"

    # 1. 环境检测
    echo -n "正在检测 Docker 环境... "
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}未安装${NC}"
        echo -e "${YELLOW}请先在应用中心安装 Docker 环境。${NC}"
        read -p "按回车键返回..."
        return
    else
        echo -e "${GREEN}已安装${NC}"
    fi

    local safeline_dir="/data/safeline"
    echo -e "正在准备安装目录 ${safeline_dir} ..."
    
    # 2. 检查旧版本
    if [ -d "$safeline_dir" ]; then
        echo -e "${YELLOW}检测到目录已存在。${NC}"
        read -p "是否覆盖安装？(y/N): " confirm_overwrite
        if [[ ! "$confirm_overwrite" =~ ^[yY]$ ]]; then
            return
        fi
        # 尝试停止旧容器
        if [ -f "$safeline_dir/compose.yaml" ]; then
             docker compose -f "$safeline_dir/compose.yaml" down >/dev/null 2>&1
        fi
    fi
    mkdir -p "$safeline_dir"

    echo ""
    # 3. 端口配置
    read -p "请输入管理后台映射端口 (默认 9443): " mgt_port
    mgt_port=${mgt_port:-9443}

    # 简单端口检查
    if command -v ss &> /dev/null; then
        if ss -tuln | grep -q ":${mgt_port} "; then
            echo -e "${RED}❌ 端口 ${mgt_port} 已被占用，请选择其他端口。${NC}"
            read -p "按回车键返回..."
            return
        fi
    fi

    echo ""
    echo -e "${BLUE}正在下载官方 Docker Compose 配置...${NC}"
    if ! curl -fsSL "https://waf-ce.chaitin.cn/release/latest/compose.yaml" -o "${safeline_dir}/compose.yaml"; then
        echo -e "${RED}下载失败，请检查网络连接。${NC}"
        read -p "按回车键返回..."
        return
    fi

    echo -e "${BLUE}正在生成随机数据库密码...${NC}"
    local postgres_pwd=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 32)
    local redis_pwd=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 32)
    
    echo -e "${BLUE}正在检测系统架构并生成环境配置文件 (.env)...${NC}"
    
    # 检测是否为 ARM 架构
    local arch_suffix=""
    if [ "$(uname -m)" = "aarch64" ]; then
        arch_suffix="-arm64"
    fi

    cat > "${safeline_dir}/.env" <<EOF
SAFELINE_DIR=${safeline_dir}
IMAGE_TAG=latest
IMAGE_PREFIX=chaitin
ARCH_SUFFIX=${arch_suffix}
REGION=
MGT_PORT=${mgt_port}
MGT_PROXY=
POSTGRES_PASSWORD=${postgres_pwd}
REDIS_PASSWORD=${redis_pwd}
SUBNET_PREFIX=172.22.222
EOF

    echo ""
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}安装配置确认：${NC}"
    echo -e "安装目录: ${GREEN}${safeline_dir}${NC}"
    echo -e "管理端口: ${GREEN}${mgt_port}${NC}"
    echo -e "版本: ${GREEN}latest${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
    
    read -p "确认开始安装？(y/N): " confirm_install
    if [[ ! "$confirm_install" =~ ^[yY]$ ]]; then
        echo "安装已取消。"
        return
    fi

    echo ""
    echo -e "${BLUE}正在拉取镜像并启动容器...${NC}"
    cd "$safeline_dir"
    docker compose up -d

    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ 雷池 WAF 安装成功！${NC}"
        
        # === 新增/修改部分开始 ===
        echo -e "${BLUE}正在等待服务初始化以获取初始密码 (约需 15 秒)...${NC}"
        sleep 15  # 必须等待数据库和服务完全启动，否则获取密码会失败
        
        echo ""
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          初始登录凭证          ${NC}"
        echo -e "${CYAN}=========================================${NC}"
        # 执行容器内部命令重置并打印密码
        docker compose exec mgt-api reset-admin-password
        echo -e "${CYAN}=========================================${NC}"
        # === 新增/修改部分结束 ===

        echo ""
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        
        echo -e "${CYAN}访问信息：${NC}"
        [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${mgt_port}${NC}"
        [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${mgt_port}${NC}"
        echo -e "${CYAN}(雷池默认使用 HTTPS 协议)${NC}"
        echo ""
        echo -e "${YELLOW}⚠️  首次登录请使用浏览器访问，如遇证书警告请点击\"继续访问/高级\"${NC}"
    else
        echo -e "${RED}❌ 安装失败，请检查 Docker 日志。${NC}"
    fi
    read -p "按回车键继续..."
}

function safeline_operation() {
    local action=$1
    local safeline_dir="/data/safeline"
    
    if [ ! -d "$safeline_dir" ] || [ ! -f "$safeline_dir/compose.yaml" ]; then
        echo -e "${RED}未检测到雷池安装文件。${NC}"
        read -p "按回车键返回..."
        return
    fi
    
    cd "$safeline_dir"
    
    case "$action" in
        "start")
            echo -e "${BLUE}正在启动雷池 WAF...${NC}"
            docker compose up -d
            echo -e "${GREEN}启动命令已执行。${NC}"
            ;;
        "stop")
            echo -e "${BLUE}正在停止雷池 WAF...${NC}"
            docker compose stop
            echo -e "${GREEN}停止命令已执行。${NC}"
            ;;
        "restart")
            echo -e "${BLUE}正在重启雷池 WAF...${NC}"
            docker compose restart
            echo -e "${GREEN}重启命令已执行。${NC}"
            ;;
    esac
    read -p "按回车键继续..."
}

function reset_safeline_password() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          重置管理员密码${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    local safeline_dir="/data/safeline"
    if [ ! -d "$safeline_dir" ]; then
        echo -e "${RED}未安装雷池 WAF。${NC}"
        read -p "按回车键返回..."
        return
    fi

    # 检查容器是否运行
    if ! docker compose -f "$safeline_dir/compose.yaml" ps --services --filter "status=running" | grep -q "mgt-api"; then
        echo -e "${RED}雷池服务未运行，请先启动服务。${NC}"
        read -p "按回车键返回..."
        return
    fi

    echo -e "${BLUE}正在重置 admin 密码...${NC}"
    cd "$safeline_dir"
    
    # 执行重置命令
    docker compose exec mgt-api reset-admin-password
    
    echo ""
    echo -e "${GREEN}✅ 密码重置成功，请使用上方显示的密码登录。${NC}"
    read -p "按回车键继续..."
}

function view_safeline_status() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          雷池 WAF 运行状态${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    local safeline_dir="/data/safeline"
    if [ ! -d "$safeline_dir" ]; then
        echo -e "${RED}未安装雷池 WAF。${NC}"
        read -p "按回车键返回..."
        return
    fi

    cd "$safeline_dir"
    docker compose ps
    
    echo ""
    if [ -f ".env" ]; then
        local port=$(grep "MGT_PORT" .env | cut -d= -f2)
        echo -e "管理端口配置: ${GREEN}${port}${NC}"
    fi
    
    read -p "按回车键继续..."
}

function upgrade_safeline() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          升级雷池 WAF${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    local safeline_dir="/data/safeline"
    if [ ! -d "$safeline_dir" ]; then
        echo -e "${RED}未安装雷池 WAF。${NC}"
        read -p "按回车键返回..."
        return
    fi
    
    echo -e "${YELLOW}升级步骤：${NC}"
    echo "1. 更新 compose.yaml 配置文件"
    echo "2. 拉取最新镜像"
    echo "3. 重启服务"
    echo ""
    read -p "确认开始升级？(y/N): " confirm
    if [[ ! "$confirm" =~ ^[yY]$ ]]; then
        return
    fi

    cd "$safeline_dir"
    
    echo -e "${BLUE}正在下载最新配置文件...${NC}"
    if curl -fsSL "https://waf-ce.chaitin.cn/release/latest/compose.yaml" -o compose.yaml; then
        echo -e "${GREEN}配置文件更新成功。${NC}"
    else
        echo -e "${RED}配置文件下载失败。${NC}"
        read -p "按回车键返回..."
        return
    fi
    
    echo -e "${BLUE}正在拉取最新镜像...${NC}"
    docker compose pull
    
    echo -e "${BLUE}正在应用更新并重启...${NC}"
    docker compose up -d --remove-orphans
    
    echo -e "${GREEN}✅ 升级完成！${NC}"
    read -p "按回车键继续..."
}

function uninstall_safeline() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}          卸载雷池 WAF${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    local safeline_dir="/data/safeline"
    if [ ! -d "$safeline_dir" ]; then
        echo -e "${YELLOW}未检测到安装目录。${NC}"
        read -p "按回车键返回..."
        return
    fi
    
    echo -e "${RED}⚠️  警告：此操作将执行以下动作：${NC}"
    echo "1. 停止并删除雷池所有容器"
    echo "2. 删除 /data/safeline 目录（包含数据库数据、日志、配置）"
    echo "3. 删除相关的 Docker 网络"
    echo ""
    
    read -p "确定要卸载雷池 WAF 吗？(y/N): " confirm_uninstall
    if [[ ! "$confirm_uninstall" =~ ^[yY]$ ]]; then
        echo "卸载已取消。"
        read -p "按回车键返回..."
        return
    fi
    
    cd "$safeline_dir"
    echo -e "${BLUE}正在停止容器...${NC}"
    docker compose down
    
    echo -e "${BLUE}正在删除数据目录...${NC}"
    cd /
    rm -rf "$safeline_dir"
    
    echo -e "${GREEN}✅ 雷池 WAF 已完全卸载。${NC}"
    read -p "按回车键继续..."
}

# AkileCloud 专用脚本
function akilecloud_management() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          AkileCloud 专用脚本${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${BLUE}正在执行 AkileCloud 脚本...${NC}"
    wget -qO- https://raw.githubusercontent.com/akile-network/aktools/refs/heads/main/akdns.sh | bash
    read -p "按回车键继续..."
}

# VScode 网页版 (code-server) 管理模块

function vscode_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             VScode 网页版管理${NC}"
        
        # 状态检测逻辑
        local status_text="${RED}未安装${NC}"
        if docker ps -a --format '{{.Names}}' | grep -q "^vscode-server$"; then
            if docker ps --format '{{.Names}}' | grep -q "^vscode-server$"; then
                status_text="${GREEN}运行中${NC}"
                
                # 获取映射端口和显示IP信息
                local host_port=$(docker inspect vscode-server --format='{{(index (index .NetworkSettings.Ports "8080/tcp") 0).HostPort}}' 2>/dev/null)
                host_port=${host_port:-8080}
                
                IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
                
                echo -e "${CYAN}-----------------------------------------${NC}"
                [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
                [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
            else
                status_text="${YELLOW}已停止${NC}"
            fi
        fi

        echo -e "          状态: ${status_text}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC} 安装 VScode (code-server)"
        echo -e " ${GREEN}2.${NC} 启动 VScode"
        echo -e " ${GREEN}3.${NC} 停止 VScode"
        echo -e " ${GREEN}4.${NC} 重启 VScode"
        echo -e " ${GREEN}5.${NC} 修改登录密码"
        echo -e " ${GREEN}6.${NC} 查看访问信息与日志"
        echo -e " ${GREEN}7.${NC} 卸载 VScode"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC} 返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择: " vscode_choice

        case "$vscode_choice" in
            1) install_vscode ;;
            2) manage_vscode_container "start" ;;
            3) manage_vscode_container "stop" ;;
            4) manage_vscode_container "restart" ;;
            5) change_vscode_password ;;
            6) view_vscode_info ;;
            7) uninstall_vscode ;;
            0) break ;;
            *) echo -e "${RED}无效的选择！${NC}"; sleep 1 ;;
        esac
    done
}

function install_vscode() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          安装 VScode 网页版${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! command -v docker &> /dev/null; then
        echo -e "${RED}错误: 未检测到 Docker 环境。${NC}"
        read -p "按回车键继续..."
        return
    fi

    # 1. 配置端口
    read -p "请输入宿主机映射端口 (默认 8080): " host_port
    host_port=${host_port:-8080}

    # 2. 配置密码
    read -p "请输入登录密码 (留空则随机生成): " v_pass
    if [ -z "$v_pass" ]; then
        v_pass=$(date +%s | sha256sum | base64 | head -c 12)
    fi

    # 3. 配置工作目录
    read -p "是否映射本地工作目录？(y/N): " map_dir
    local workspace_dir="/root"
    if [[ "$map_dir" =~ ^[yY]$ ]]; then
        read -p "请输入要映射的本地绝对路径 (默认 /root): " custom_dir
        workspace_dir=${custom_dir:-/root}
    fi

    echo -e "${BLUE}正在准备配置文件...${NC}"
    local install_dir="/opt/vscode"
    mkdir -p "$install_dir"

    cat > "$install_dir/docker-compose.yml" <<EOF
services:
  vscode-server:
    image: codercom/code-server:latest
    container_name: vscode-server
    restart: always
    ports:
      - "${host_port}:8080"
    environment:
      - PASSWORD=${v_pass}
      - TZ=Asia/Shanghai
    volumes:
      - "${install_dir}/config:/home/coder/.config"
      - "${workspace_dir}:/home/coder/project"
    user: "$(id -u):$(id -g)"
EOF

    echo -e "${BLUE}正在启动容器...${NC}"
    cd "$install_dir" && docker compose up -d

    if [ $? -eq 0 ]; then
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        echo -e "${GREEN}✅ VScode 安装成功！${NC}"
        echo -e "访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
        echo -e "登录密码: ${GREEN}${v_pass}${NC}"
        echo -e "工作目录: ${BLUE}${workspace_dir}${NC}"
    else
        echo -e "${RED}❌ 启动失败，请检查 Docker 日志。${NC}"
    fi
    read -p "按回车键继续..."
}

function manage_vscode_container() {
    local action=$1
    echo -e "${BLUE}正在执行 ${action} 操作...${NC}"
    cd /opt/vscode && docker compose "$action"
    read -p "按回车键继续..."
}

function change_vscode_password() {
    if [ ! -f /opt/vscode/docker-compose.yml ]; then
        echo -e "${RED}未找到安装配置。${NC}"
        return
    fi
    read -p "请输入新密码: " new_pass
    if [ -n "$new_pass" ]; then
        sed -i "s/PASSWORD=.*/PASSWORD=${new_pass}/" /opt/vscode/docker-compose.yml
        echo -e "${BLUE}正在应用新密码并重启...${NC}"
        cd /opt/vscode && docker compose up -d
        echo -e "${GREEN}密码修改成功！${NC}"
    fi
    read -p "按回车键继续..."
}

function view_vscode_info() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          VScode 运行信息${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if [ -f /opt/vscode/docker-compose.yml ]; then
        local port=$(grep "ports:" -A 1 /opt/vscode/docker-compose.yml | grep -o "[0-9]*" | head -1)
        local pass=$(grep "PASSWORD=" /opt/vscode/docker-compose.yml | cut -d= -f2)
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        
        echo -e "访问地址: ${YELLOW}http://${ipv4}:${port}${NC}"
        echo -e "当前密码: ${GREEN}${pass}${NC}"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e "${BLUE}最近 10 行日志:${NC}"
        docker logs --tail 10 vscode-server
    else
        echo -e "${RED}未检测到安装信息。${NC}"
    fi
    read -p "按回车键继续..."
}

function uninstall_vscode() {
    read -p "确定要卸载 VScode 吗？数据目录将保留 (y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        cd /opt/vscode && docker compose down
        rm -rf /opt/vscode/docker-compose.yml
        echo -e "${GREEN}卸载完成。${NC}"
    fi
    read -p "按回车键继续..."
}


function lucky_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             Lucky 管理菜单${NC}"
        
        # 状态检测逻辑
        local status_text="${RED}未安装${NC}"
        local mode=""
        
        # 优先检测 Docker
        if command -v docker &> /dev/null && docker ps -a --format '{{.Names}}' | grep -q "^lucky$"; then
            if docker ps --format '{{.Names}}' | grep -q "^lucky$"; then
                status_text="${GREEN}运行中 (Docker)${NC}"
                
                # 获取映射端口和显示IP信息
                local host_port=$(docker inspect lucky --format='{{(index (index .NetworkSettings.Ports "16601/tcp") 0).HostPort}}' 2>/dev/null)
                host_port=${host_port:-16601}
                
                IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
                
                echo -e "${CYAN}-----------------------------------------${NC}"
                [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
                [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
            else
                status_text="${YELLOW}已停止 (Docker)${NC}"
            fi
            mode="docker"
        # 其次检测 Systemd
        elif systemctl list-units --full -all | grep -q "lucky.service"; then
            if systemctl is-active --quiet lucky; then
                status_text="${GREEN}运行中 (直接安装)${NC}"
                
                # 显示服务器IP信息
                IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
                
                echo -e "${CYAN}-----------------------------------------${NC}"
                echo -e "${BLUE}服务器IP信息:${NC}"
                [ -n "$ipv4" ] && echo -e "IPv4 地址: ${YELLOW}${ipv4}${NC}"
                [ -n "$ipv6" ] && echo -e "IPv6 地址: ${YELLOW}${ipv6}${NC}"
                echo -e "Lucky 默认端口: ${YELLOW}16601${NC}"
            else
                status_text="${YELLOW}已停止 (直接安装)${NC}"
            fi
            mode="systemd"
        fi

        echo -e "          状态: ${status_text}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e "Lucky 是一款集 DDNS、反向代理、SSL证书申请、WOL等"
        echo -e "于一体的超强大工具，资源占用极低。"
        echo ""
        echo -e " ${GREEN}1.${NC} 安装 Lucky (Docker 版)"
        echo -e " ${GREEN}2.${NC} 安装 Lucky (直接安装)"
        echo -e " ${GREEN}3.${NC} 启动 Lucky"
        echo -e " ${GREEN}4.${NC} 停止 Lucky"
        echo -e " ${GREEN}5.${NC} 重启 Lucky"
        echo -e " ${GREEN}6.${NC} 查看 Lucky 运行日志"
        echo -e " ${GREEN}7.${NC} 升级 Lucky 到最新版"
        echo -e " ${GREEN}8.${NC} 卸载 Lucky"
        echo -e " ${GREEN}9.${NC} 访问管理界面"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC} 返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-9): " lucky_choice

        case "$lucky_choice" in
            1) install_lucky_docker ;;
            2) install_lucky_direct ;;
            3) start_lucky "$mode" ;;
            4) stop_lucky "$mode" ;;
            5) restart_lucky "$mode" ;;
            6) view_lucky_log "$mode" ;;
            7) upgrade_lucky "$mode" ;;
            8) uninstall_lucky "$mode" ;;
            9) access_lucky_web "$mode" ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 1 ;;
        esac
    done
}

function install_lucky_docker() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}           安装 Lucky (Docker)${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! command -v docker &> /dev/null; then
        echo -e "${RED}错误: 未检测到 Docker 环境，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    if docker ps -a --format '{{.Names}}' | grep -q "^lucky$"; then
        echo -e "${YELLOW}检测到 Lucky (Docker) 已在运行中。${NC}"
        read -p "是否重新安装？(y/N): " reinstall
        [[ ! "$reinstall" =~ ^[yY]$ ]] && return
        docker stop lucky &>/dev/null
        docker rm lucky &>/dev/null
    fi
    
    # 检测直接安装版本是否存在
    if systemctl list-units --full -all | grep -q "lucky.service"; then
        echo -e "${RED}检测到 Lucky (直接安装) 存在。请先卸载直接安装版本以避免冲突。${NC}"
        read -p "按回车键继续..."
        return
    fi

    # 1. 配置管理端口
    read -p "请输入 Lucky 管理端口 (默认 16601): " host_port
    host_port=${host_port:-16601}

    # 2. 验证端口占用
    if command -v ss &> /dev/null; then
        if ss -tuln | grep -q ":${host_port} "; then
            echo -e "${RED}❌ 端口 ${host_port} 已被占用，请选择其他端口。${NC}"
            read -p "按回车键继续..."
            return
        fi
    fi

    echo -e "${BLUE}正在拉取镜像并启动容器...${NC}"
    
    mkdir -p /opt/lucky/conf

    # 强制拉取最新镜像，确保是最新版
    docker pull gdy666/lucky:v2

    docker run -d \
        --name lucky \
        --restart always \
        -p ${host_port}:16601 \
        -v /opt/lucky/conf:/config \
        gdy666/lucky:v2

    if [ $? -eq 0 ]; then
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        echo ""
        echo -e "${GREEN}✅ Lucky (Docker) 安装成功！${NC}"
        echo -e "管理地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
        echo -e "默认账号: ${GREEN}666${NC}"
        echo -e "默认密码: ${GREEN}666${NC}"
        echo -e "${RED}注意：请务必在首次登录后立即修改账号密码。${NC}"
    else
        echo -e "${RED}❌ 安装失败，请检查 Docker 日志。${NC}"
    fi
    read -p "按回车键继续..."
}

function install_lucky_direct() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}           安装 Lucky (直接安装)${NC}"
    echo -e "${CYAN}=========================================${NC}"

    # 检测是否已安装
    if systemctl list-units --full -all | grep -q "lucky.service"; then
        echo -e "${YELLOW}检测到 Lucky (直接安装) 已存在。${NC}"
        read -p "是否重新安装？(y/N): " reinstall
        [[ ! "$reinstall" =~ ^[yY]$ ]] && return
        systemctl stop lucky &>/dev/null
    fi

    # 检测 Docker 版本是否存在
    if command -v docker &> /dev/null && docker ps -a --format '{{.Names}}' | grep -q "^lucky$"; then
        echo -e "${RED}检测到 Lucky (Docker) 存在。请先卸载 Docker 版本以避免冲突。${NC}"
        read -p "按回车键继续..."
        return
    fi

    # 1. 获取最新版本
    echo -e "${BLUE}正在获取最新版本信息...${NC}"
    local latest_tag=$(curl -s https://api.github.com/repos/gdy666/lucky/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    if [ -z "$latest_tag" ]; then
        echo -e "${RED}获取版本信息失败，请检查网络连接。${NC}"
        read -p "按回车键继续..."
        return
    fi
    echo -e "最新版本: ${GREEN}${latest_tag}${NC}"

    # 1.1 配置管理端口
    read -p "请输入 Lucky 管理端口 (默认 16601): " host_port
    host_port=${host_port:-16601}

    # 1.2 验证端口占用
    if command -v ss &> /dev/null; then
        if ss -tuln | grep -q ":${host_port} "; then
            echo -e "${RED}❌ 端口 ${host_port} 已被占用，请选择其他端口。${NC}"
            read -p "按回车键继续..."
            return
        fi
    fi

    # 2. 检测系统架构
    local arch=$(uname -m)
    local lucky_arch=""
    case "$arch" in
        x86_64) lucky_arch="x86_64" ;;
        aarch64) lucky_arch="arm64" ;;
        armv7l) lucky_arch="armv7" ;;
        *) echo -e "${RED}不支持的架构: $arch${NC}"; read -p "按回车键继续..."; return ;;
    esac

    # 3. 下载并安装
    local version_number="${latest_tag#v}"
    # 尝试构建下载链接
    local download_url="https://github.com/gdy666/lucky/releases/download/${latest_tag}/lucky_${version_number}_Linux_${lucky_arch}.tar.gz"
    
    echo -e "${BLUE}正在下载 Lucky...${NC}"
    wget -O /tmp/lucky.tar.gz "$download_url"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}下载失败，尝试使用 jsdelivr 代理...${NC}"
        download_url="https://ghproxy.com/https://github.com/gdy666/lucky/releases/download/${latest_tag}/lucky_${version_number}_Linux_${lucky_arch}.tar.gz"
        wget -O /tmp/lucky.tar.gz "$download_url"
        if [ $? -ne 0 ]; then
             echo -e "${RED}下载失败。请检查网络。${NC}"
             read -p "按回车键继续..."
             return
        fi
    fi

    echo -e "${BLUE}正在解压并安装...${NC}"
    mkdir -p /tmp/lucky_install
    tar -xzf /tmp/lucky.tar.gz -C /tmp/lucky_install
    
    # 查找二进制文件
    local bin_path=$(find /tmp/lucky_install -name "lucky" -type f | head -n 1)
    if [ -z "$bin_path" ]; then
         echo -e "${RED}解压后未找到 lucky 二进制文件。${NC}"
         rm -rf /tmp/lucky.tar.gz /tmp/lucky_install
         read -p "按回车键继续..."
         return
    fi

    chmod +x "$bin_path"
    mv "$bin_path" /usr/local/bin/lucky
    rm -rf /tmp/lucky.tar.gz /tmp/lucky_install

    # 4. 创建配置目录
    mkdir -p /etc/lucky

    # 5. 创建系统服务
    cat > /etc/systemd/system/lucky.service <<EOF
[Unit]
Description=Lucky Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/lucky -c /etc/lucky/lucky.conf -p ${host_port}
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

    # 6. 启动服务
    systemctl daemon-reload
    systemctl enable lucky
    systemctl start lucky
    
    if systemctl is-active --quiet lucky; then
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        echo -e "${GREEN}✅ Lucky (直接安装) 安装成功！${NC}"
        echo -e "管理地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
        echo -e "默认账号: ${GREEN}666${NC}"
        echo -e "默认密码: ${GREEN}666${NC}"
        echo -e "${RED}注意：请务必在首次登录后立即修改账号密码。${NC}"
    else
        echo -e "${RED}❌ 安装后启动失败，请检查日志 'journalctl -u lucky'。${NC}"
    fi
    read -p "按回车键继续..."
}

function start_lucky() {
    local mode=$1
    if [ "$mode" == "docker" ]; then
        docker start lucky && echo -e "${GREEN}Docker 启动指令已发送${NC}" || echo -e "${RED}启动失败${NC}"
    elif [ "$mode" == "systemd" ]; then
        systemctl start lucky && echo -e "${GREEN}Systemd 启动指令已发送${NC}" || echo -e "${RED}启动失败${NC}"
    else
        echo -e "${RED}未检测到 Lucky 安装${NC}"
    fi
    sleep 1
}

function stop_lucky() {
    local mode=$1
    if [ "$mode" == "docker" ]; then
        docker stop lucky && echo -e "${YELLOW}Docker 停止指令已发送${NC}" || echo -e "${RED}停止失败${NC}"
    elif [ "$mode" == "systemd" ]; then
        systemctl stop lucky && echo -e "${YELLOW}Systemd 停止指令已发送${NC}" || echo -e "${RED}停止失败${NC}"
    else
        echo -e "${RED}未检测到 Lucky 安装${NC}"
    fi
    sleep 1
}

function restart_lucky() {
    local mode=$1
    if [ "$mode" == "docker" ]; then
        docker restart lucky && echo -e "${GREEN}Docker 重启指令已发送${NC}" || echo -e "${RED}重启失败${NC}"
    elif [ "$mode" == "systemd" ]; then
        systemctl restart lucky && echo -e "${GREEN}Systemd 重启指令已发送${NC}" || echo -e "${RED}重启失败${NC}"
    else
        echo -e "${RED}未检测到 Lucky 安装${NC}"
    fi
    sleep 1
}

function view_lucky_log() {
    local mode=$1
    if [ "$mode" == "docker" ]; then
        clear; echo -e "${BLUE}最近 50 行日志 (Ctrl+C 退出):${NC}"; docker logs --tail 50 -f lucky
    elif [ "$mode" == "systemd" ]; then
        clear; echo -e "${BLUE}最近 50 行日志 (Ctrl+C 退出):${NC}"; journalctl -u lucky -n 50 -f
    else
        echo -e "${RED}未检测到 Lucky 安装${NC}"; sleep 1
    fi
}

function upgrade_lucky() {
    local mode=$1
    if [ "$mode" == "docker" ]; then
        echo -e "${BLUE}正在升级 Lucky (Docker) 到最新版本...${NC}"
        docker pull gdy666/lucky:latest
        local current_port=$(docker inspect lucky --format='{{(index (index .NetworkSettings.Ports "16601/tcp") 0).HostPort}}' 2>/dev/null)
        current_port=${current_port:-16601}
        docker stop lucky && docker rm lucky
        docker run -d --name lucky --restart always -p ${current_port}:16601 -v /opt/lucky/conf:/config gdy666/lucky:latest
        echo -e "${GREEN}升级完成。${NC}"
    elif [ "$mode" == "systemd" ]; then
        echo -e "${BLUE}正在升级 Lucky (直接安装) 到最新版本...${NC}"
        install_lucky_direct # 复用安装逻辑进行升级
    else
        echo -e "${RED}未检测到 Lucky 安装${NC}"
    fi
    read -p "按回车键继续..."
}

function access_lucky_web() {
    local mode=$1
    clear
    local port=16601
    
    if [ "$mode" == "docker" ]; then
        port=$(docker inspect lucky --format='{{(index (index .NetworkSettings.Ports "16601/tcp") 0).HostPort}}' 2>/dev/null)
        port=${port:-16601}
    elif [ "$mode" == "systemd" ]; then
        # 尝试从服务文件中获取端口，如果获取失败则默认为 16601
        port=$(grep "ExecStart" /etc/systemd/system/lucky.service | grep -oP '\-p \K\d+' || echo "16601")
    else
        echo -e "${RED}Lucky 未安装。${NC}"
        read -p "按回车键继续..."
        return
    fi
    
    IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
    echo -e "${CYAN}Lucky 管理地址：${NC}"
    echo -e "IPv4 地址: ${YELLOW}http://${ipv4}:${port}${NC}"
    [ -n "$ipv6" ] && echo -e "IPv6 地址: ${YELLOW}http://[${ipv6}]:${port}${NC}"
    echo -e "默认凭据: ${GREEN}666 / 666${NC}"
    read -p "按回车键继续..."
}

function uninstall_lucky() {
    local mode=$1
    if [ "$mode" == "docker" ]; then
        read -p "确定要彻底删除 Lucky (Docker) 吗？配置数据目录 /opt/lucky 将被保留 (y/N): " confirm
        if [[ "$confirm" =~ ^[yY]$ ]]; then
            docker stop lucky &>/dev/null
            docker rm lucky &>/dev/null
            echo -e "${GREEN}Lucky 容器已成功移除。${NC}"
            read -p "是否同步删除配置目录 /opt/lucky？(y/N): " del_data
            if [[ "$del_data" =~ ^[yY]$ ]]; then
                rm -rf /opt/lucky
                echo -e "${GREEN}数据目录已清理。${NC}"
            fi
        fi
    elif [ "$mode" == "systemd" ]; then
        read -p "确定要彻底删除 Lucky (直接安装) 吗？配置目录 /etc/lucky 将被保留 (y/N): " confirm
        if [[ "$confirm" =~ ^[yY]$ ]]; then
            systemctl stop lucky
            systemctl disable lucky
            rm -f /etc/systemd/system/lucky.service
            systemctl daemon-reload
            rm -f /usr/local/bin/lucky
            echo -e "${GREEN}Lucky 服务及文件已移除。${NC}"
            read -p "是否同步删除配置目录 /etc/lucky？(y/N): " del_data
            if [[ "$del_data" =~ ^[yY]$ ]]; then
                rm -rf /etc/lucky
                echo -e "${GREEN}配置目录已清理。${NC}"
            fi
        fi
    else
        echo -e "${RED}未检测到 Lucky 安装${NC}"
    fi
    read -p "按回车键继续..."
}

# =================================================================
# Docker 镜像加速站一站式管理模块 (服务端部署 + 客户端配置)
# =================================================================

function docker_proxy_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          Docker 镜像加速一站式管理${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " 核心逻辑：利用境外 VPS 转发 Docker Hub 请求"
        echo ""
        echo -e " ${YELLOW}--- 服务端 (部署加速站) ---${NC}"
        echo -e " ${GREEN}1.${NC} 部署加速站服务端 (Registry 方案)"
        echo -e " ${GREEN}2.${NC} 查看加速站运行状态/日志"
        echo -e " ${GREEN}3.${NC} 卸载加速站服务端"
        echo ""
        echo -e " ${YELLOW}--- 客户端 (配置本地加速) ---${NC}"
        echo -e " ${GREEN}4.${NC} 设置本地 Docker 使用加速站"
        echo -e " ${GREEN}5.${NC} 恢复本地 Docker 默认设置"
        echo -e " ${GREEN}6.${NC} 查看本地加速生效状态"
        echo ""
        echo -e " ${RED}0.${NC} 返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入选择 (0-6): " dp_choice

        case "$dp_choice" in
            1) deploy_docker_proxy_server ;;
            2) view_docker_proxy_status ;;
            3) uninstall_docker_proxy_server ;;
            4) set_docker_client_mirror ;;
            5) restore_docker_client_default ;;
            6) check_docker_client_status ;;
            0) break ;;
            *) echo -e "${RED}无效选择！${NC}"; sleep 1 ;;
        esac
    done
}

# --- 服务端逻辑 (建议在境外 VPS 执行) ---
function deploy_docker_proxy_server() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          部署加速站服务端 (Registry)${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! command -v docker &> /dev/null; then
        echo -e "${RED}错误: 未检测到 Docker，请先安装 Docker。${NC}"
        read -p "按回车键继续..."
        return
    fi

    if docker ps -a --format '{{.Names}}' | grep -q "^registry$"; then
        echo -e "${YELLOW}检测到 registry 容器已存在。${NC}"
        read -p "是否删除并重新部署？(y/N): " reinstall
        if [[ "$reinstall" =~ ^[yY]$ ]]; then
            docker stop registry &>/dev/null
            docker rm registry &>/dev/null
        else
            return
        fi
    fi

    read -p "请输入服务端口 (默认 5000): " dp_port
    dp_port=${dp_port:-5000}

    # 验证端口占用
    if command -v ss &> /dev/null; then
        if ss -tuln | grep -q ":${dp_port} "; then
            echo -e "${RED}❌ 端口 ${dp_port} 已被占用，请选择其他端口。${NC}"
            read -p "按回车键继续..."
            return
        fi
    fi

    local data_dir="/home/docker/registry"
    mkdir -p "$data_dir"

    echo -e "${BLUE}正在启动 Registry 容器...${NC}"
    
    docker run -d \
     -p ${dp_port}:5000 \
     --name registry \
     -v ${data_dir}:/var/lib/registry \
     -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io \
     --restart always \
     registry:2

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ 服务端部署成功！${NC}"
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        echo -e "访问地址: ${YELLOW}http://${ipv4}:${dp_port}${NC}"
        echo -e "内网地址: ${YELLOW}http://127.0.0.1:${dp_port}${NC}"
    else
        echo -e "${RED}❌ 部署失败，请检查 Docker 日志。${NC}"
    fi
    read -p "按回车键继续..."
}

function uninstall_docker_proxy_server() {
    read -p "确定要卸载加速站服务端吗？(y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        docker stop registry &>/dev/null
        docker rm registry &>/dev/null
        echo -e "${GREEN}Registry 容器已卸载。${NC}"
        
        read -p "是否删除数据目录 /home/docker/registry？(y/N): " del_data
        if [[ "$del_data" =~ ^[yY]$ ]]; then
            rm -rf /home/docker/registry
            echo -e "${GREEN}数据目录已清理。${NC}"
        fi
    fi
    read -p "按回车键继续..."
}

function view_docker_proxy_status() {
    if docker ps -a --format '{{.Names}}' | grep -q "^registry$"; then
        docker ps -f name=registry
        echo -e "\n${BLUE}最近 10 行日志:${NC}"
        docker logs --tail 10 registry
    else
        echo -e "${RED}未检测到 Registry 容器。${NC}"
    fi
    read -p "按回车键继续..."
}

# --- 客户端逻辑 (在需要加速的机器执行) ---
function set_docker_client_mirror() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          配置本地加速 (客户端)${NC}"
    echo -e "${CYAN}=========================================${NC}"

    read -p "请输入加速站域名 (需带 https://, 如 https://docker.abc.com): " my_mirror
    if [ -z "$my_mirror" ]; then return; fi

    if [[ ! "$my_mirror" =~ ^https:// ]]; then
        my_mirror="https://$my_mirror"
    fi

    echo -e "${BLUE}正在配置 /etc/docker/daemon.json ...${NC}"
    [ -f /etc/docker/daemon.json ] && cp /etc/docker/daemon.json /etc/docker/daemon.json.bak

    cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["$my_mirror"]
}
EOF

    echo -e "${BLUE}正在重启 Docker 服务...${NC}"
    systemctl daemon-reload
    systemctl restart docker

    echo -e "${GREEN}✅ 本地加速配置完成！${NC}"
    check_docker_client_status
}

function restore_docker_client_default() {
    echo -e "${YELLOW}正在清理加速镜像配置...${NC}"
    if [ -f /etc/docker/daemon.json ]; then
        rm -f /etc/docker/daemon.json
        systemctl daemon-reload
        systemctl restart docker
        echo -e "${GREEN}已恢复默认设置并重启 Docker。${NC}"
    else
        echo -e "当前已是默认配置。"
    fi
    read -p "按回车键继续..."
}

function check_docker_client_status() {
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${BLUE}当前 Docker 生效的加速镜像:${NC}"
    docker info 2>/dev/null | grep -A 1 "Registry Mirrors"
    echo -e "${CYAN}-----------------------------------------${NC}"
    read -p "按回车键继续..."
}

# 小雅alist 管理菜单
function xiaoya_alist_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          小雅alist 应用管理${NC}"
        
        # 检查 Docker 是否运行
        if ! docker info > /dev/null 2>&1; then
            echo -e "${RED}⚠️  Docker 服务未运行或未安装！${NC}"
        else
            if docker ps -a --format '{{.Names}}' | grep -q "^xiaoya-alist$"; then
                if docker ps --format '{{.Names}}' | grep -q "^xiaoya-alist$"; then
                    echo -e "          状态: ${GREEN}运行中${NC}"
                    
                    # 获取映射端口和显示IP信息
                    local host_port=$(docker inspect xiaoya-alist --format='{{(index (index .NetworkSettings.Ports "5678/tcp") 0).HostPort}}' 2>/dev/null)
                    host_port=${host_port:-5678}
                    
                    IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
                    
                    echo -e "${CYAN}-----------------------------------------${NC}"
                    [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
                    [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
                else
                    echo -e "          状态: ${YELLOW}已停止${NC}"
                fi
            else
                echo -e "          状态: ${RED}未部署${NC}"
            fi
        fi

        echo -e "${CYAN}=========================================${NC}"
        echo "小雅alist 基于 Docker 容器部署，提供强大的文件索引与 Web 管理界面"
        echo "可用于快速搭建资源索引与在线播放入口"
        echo ""
        echo -e " ${GREEN}1.${NC}  安装 小雅alist (自定义配置)"
        echo -e " ${GREEN}2.${NC}  启动 小雅alist"
        echo -e " ${GREEN}3.${NC}  停止 小雅alist"
        echo -e " ${GREEN}4.${NC}  重启 小雅alist"
        echo -e " ${GREEN}5.${NC}  查看 小雅alist 状态和日志"
        echo -e " ${GREEN}6.${NC}  修改 小雅alist 配置"
        echo -e " ${GREEN}7.${NC}  卸载 小雅alist"
        echo -e " ${GREEN}8.${NC}  访问 小雅alist Web 界面"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回应用中心菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-8): " xiaoya_choice

        case "$xiaoya_choice" in
            1) install_xiaoya_alist ;;
            2) start_xiaoya_alist ;;
            3) stop_xiaoya_alist ;;
            4) restart_xiaoya_alist ;;
            5) view_xiaoya_alist_status_logs ;;
            6) modify_xiaoya_alist_config ;;
            7) uninstall_xiaoya_alist ;;
            8) access_xiaoya_alist_web ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 2 ;;
        esac
    done
}

# 安装 小雅alist
function install_xiaoya_alist() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}           安装 小雅alist 应用${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! command -v docker &> /dev/null; then
        echo -e "${RED}未检测到 Docker，请先安装 Docker 环境。${NC}"
        echo "您可以通过应用中心的 Komari 管理菜单安装 Docker。"
        read -p "按回车键继续..."
        return
    fi

    if docker ps -a --format '{{.Names}}' | grep -q "^xiaoya-alist$"; then
        echo -e "${YELLOW}检测到 小雅alist 容器已存在。${NC}"
        read -p "是否重新部署？(这将删除现有配置) (y/N): " redeploy_choice
        if [[ ! "$redeploy_choice" =~ ^[yY]$ ]]; then
            return
        fi
        echo -e "${BLUE}正在停止并移除旧容器...${NC}"
        docker stop xiaoya-alist &> /dev/null
        docker rm xiaoya-alist &> /dev/null
    fi

    echo -e "${YELLOW}正在配置 小雅alist 安装参数...${NC}"
    echo ""

    read -p "请输入宿主机映射端口 (默认 5244): " host_port
    host_port=${host_port:-5244}

    if command -v ss &> /dev/null; then
        if ss -tuln | grep -q ":${host_port} "; then
            echo -e "${RED}❌ 端口 ${host_port} 已被占用，请选择其他端口。${NC}"
            read -p "按回车键继续..."
            return
        fi
    fi

    while true; do
        read -sp "请输入管理员密码 (默认 admin): " admin_password
        echo ""
        admin_password=${admin_password:-admin}
        read -sp "请再次输入密码确认: " admin_password_confirm
        echo ""
        if [ "$admin_password" != "$admin_password_confirm" ]; then
            echo -e "${RED}两次输入的密码不一致，请重新输入。${NC}"
        else
            break
        fi
    done

    read -p "请输入时区 (默认 Asia/Shanghai): " tz
    tz=${tz:-Asia/Shanghai}

    read -p "请输入镜像版本 (默认 xhofe/alist:latest): " alist_image
    alist_image=${alist_image:-xhofe/alist:latest}


    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}安装配置确认：${NC}"
    echo -e "端口: ${GREEN}${host_port}${NC}"
    echo -e "密码: ${GREEN}********${NC}"
    echo -e "时区: ${GREEN}${tz}${NC}"
    echo -e "镜像: ${GREEN}${alist_image}${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"

    read -p "确认以上配置并开始安装？(y/N): " confirm_install
    if [[ ! "$confirm_install" =~ ^[yY]$ ]]; then
        echo "安装已取消。"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在准备安装目录...${NC}"
    mkdir -p /opt/xiaoya-alist

    echo -e "${BLUE}正在创建配置文件...${NC}"
    cat > /opt/xiaoya-alist/.env << EOF
HOST_PORT=${host_port}
ADMIN_PASSWORD=${admin_password}
TZ=${tz}
ALIST_IMAGE=${alist_image}
EOF

    cat > /opt/xiaoya-alist/docker-compose.yml << EOF
services:
  xiaoya-alist:
    image: \${ALIST_IMAGE}
    container_name: xiaoya-alist
    restart: unless-stopped
    ports:
      - "\${HOST_PORT}:5244"
    environment:
      - TZ=\${TZ}
      - ADMIN_PASSWORD=\${ADMIN_PASSWORD}
      - ALIST_ADMIN_PASSWORD=\${ADMIN_PASSWORD}
    volumes:
      - ./data:/data

EOF

    echo -e "${BLUE}正在启动 小雅alist 服务...${NC}"
    cd /opt/xiaoya-alist

    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi

    $docker_compose_cmd up -d

    if [ $? -eq 0 ]; then
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"

        echo -e "${GREEN}✅ 小雅alist 安装成功！${NC}"
        echo ""
        echo -e "${CYAN}访问信息：${NC}"
        [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
        [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
        echo ""
        echo -e "${CYAN}登录凭据：${NC}"
        echo -e "用户名: ${GREEN}admin${NC}"
        echo -e "密码: ${GREEN}${admin_password}${NC}"
        echo ""
        echo -e "${YELLOW}重要提示：${NC}"
        echo "1. 首次启动可能需要等待容器初始化"
        echo "2. 配置文件位置: /opt/xiaoya-alist"
    else
        echo -e "${RED}❌ 小雅alist 安装失败，请检查 Docker 服务与端口占用。${NC}"
        $docker_compose_cmd logs --tail 20
    fi

    read -p "按回车键继续..."
}

# 启动 小雅alist
function start_xiaoya_alist() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            启动 小雅alist${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/xiaoya-alist/docker-compose.yml" ]; then
        echo -e "${RED}未检测到 小雅alist 安装，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在启动 小雅alist 服务...${NC}"
    cd /opt/xiaoya-alist

    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi

    $docker_compose_cmd start

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ 小雅alist 启动成功！${NC}"
    else
        echo -e "${RED}❌ 启动失败，请检查日志。${NC}"
    fi

    read -p "按回车键继续..."
}

# 停止 小雅alist
function stop_xiaoya_alist() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            停止 小雅alist${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/xiaoya-alist/docker-compose.yml" ]; then
        echo -e "${RED}未检测到 小雅alist 安装，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在停止 小雅alist 服务...${NC}"
    cd /opt/xiaoya-alist

    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi

    $docker_compose_cmd stop

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ 小雅alist 已停止。${NC}"
    else
        echo -e "${RED}❌ 停止失败，请检查日志。${NC}"
    fi

    read -p "按回车键继续..."
}

# 重启 小雅alist
function restart_xiaoya_alist() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            重启 小雅alist${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/xiaoya-alist/docker-compose.yml" ]; then
        echo -e "${RED}未检测到 小雅alist 安装，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在重启 小雅alist 服务...${NC}"
    cd /opt/xiaoya-alist

    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi

    $docker_compose_cmd restart

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ 小雅alist 重启成功！${NC}"
    else
        echo -e "${RED}❌ 重启失败，请检查日志。${NC}"
    fi

    read -p "按回车键继续..."
}

# 查看 小雅alist 状态和日志
function view_xiaoya_alist_status_logs() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        小雅alist 状态与日志${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/xiaoya-alist/docker-compose.yml" ]; then
        echo -e "${RED}未检测到 小雅alist 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    cd /opt/xiaoya-alist

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

# 修改 小雅alist 配置
function modify_xiaoya_alist_config() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}           修改 小雅alist 配置${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/xiaoya-alist/.env" ]; then
        echo -e "${RED}未检测到 小雅alist 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    local current_port=$(grep -oP "^HOST_PORT=\K[0-9]+" /opt/xiaoya-alist/.env | head -1)
    local current_tz=$(grep -oP "^TZ=\K.*" /opt/xiaoya-alist/.env | head -1)
    local current_image=$(grep -oP "^ALIST_IMAGE=\K.*" /opt/xiaoya-alist/.env | head -1)

    echo -e "${YELLOW}当前配置信息：${NC}"
    echo -e "端口: ${GREEN}${current_port}${NC}"
    echo -e "时区: ${GREEN}${current_tz}${NC}"
    echo -e "镜像: ${GREEN}${current_image}${NC}"
    echo ""
    echo -e "${YELLOW}修改选项：${NC}"
    echo "1. 修改端口"
    echo "2. 重置管理员密码"
    echo "3. 修改镜像"
    echo "4. 修改时区"
    echo "5. 查看完整配置文件"
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

            if command -v ss &> /dev/null; then
                if ss -tuln | grep -q ":${new_port} "; then
                    echo -e "${RED}端口 ${new_port} 已被占用，请选择其他端口。${NC}"
                    read -p "按回车键继续..."
                    return
                fi
            fi

            cd /opt/xiaoya-alist
            if docker compose version &> /dev/null; then
                docker_compose_cmd="docker compose"
            else
                docker_compose_cmd="docker-compose"
            fi
            $docker_compose_cmd stop

            sed -i "s/^HOST_PORT=.*/HOST_PORT=${new_port}/" .env
            $docker_compose_cmd up -d

            IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
            echo -e "${GREEN}✅ 端口已修改为 ${new_port}${NC}"
            [ -n "$ipv4" ] && echo -e "新访问地址: ${YELLOW}http://${ipv4}:${new_port}${NC}"
            read -p "按回车键继续..."
            ;;
        2)
            while true; do
                read -sp "请输入新的管理员密码: " new_password
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

            cd /opt/xiaoya-alist
            if docker compose version &> /dev/null; then
                docker_compose_cmd="docker compose"
            else
                docker_compose_cmd="docker-compose"
            fi
            $docker_compose_cmd stop

            sed -i "s/^ADMIN_PASSWORD=.*/ADMIN_PASSWORD=${new_password}/" .env
            $docker_compose_cmd up -d

            echo -e "${GREEN}✅ 密码已更新${NC}"
            echo -e "新密码: ${GREEN}${new_password}${NC}"
            read -p "按回车键继续..."
            ;;
        3)
            read -p "请输入新的镜像 (如 xiaoyaliu/alist:latest): " new_image
            if [ -z "$new_image" ]; then
                echo -e "${RED}镜像不能为空。${NC}"
                read -p "按回车键继续..."
                return
            fi

            cd /opt/xiaoya-alist
            if docker compose version &> /dev/null; then
                docker_compose_cmd="docker compose"
            else
                docker_compose_cmd="docker-compose"
            fi
            $docker_compose_cmd stop

            sed -i "s/^ALIST_IMAGE=.*/ALIST_IMAGE=${new_image}/" .env
            $docker_compose_cmd up -d

            echo -e "${GREEN}✅ 镜像已更新为 ${new_image}${NC}"
            read -p "按回车键继续..."
            ;;
        4)
            read -p "请输入新的时区 (如 Asia/Shanghai): " new_tz
            if [ -z "$new_tz" ]; then
                echo -e "${RED}时区不能为空。${NC}"
                read -p "按回车键继续..."
                return
            fi

            cd /opt/xiaoya-alist
            if docker compose version &> /dev/null; then
                docker_compose_cmd="docker compose"
            else
                docker_compose_cmd="docker-compose"
            fi
            $docker_compose_cmd stop

            sed -i "s/^TZ=.*/TZ=${new_tz}/" .env
            $docker_compose_cmd up -d

            echo -e "${GREEN}✅ 时区已更新为 ${new_tz}${NC}"
            read -p "按回车键继续..."
            ;;
        5)
            echo -e "${BLUE}完整配置文件内容:${NC}"
            echo ""
            cat /opt/xiaoya-alist/.env
            echo ""
            read -p "按回车键继续..."
            return
            ;;
        0) return ;;
        *) echo -e "${RED}无效选择。${NC}"; read -p "按回车键继续..." ;;
    esac
}

# 卸载 小雅alist
function uninstall_xiaoya_alist() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}             卸载 小雅alist${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/xiaoya-alist/docker-compose.yml" ]; then
        echo -e "${YELLOW}未检测到 小雅alist 安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${RED}⚠️  警告：此操作将删除 小雅alist 容器及配置！${NC}"
    echo ""
    echo -e "将删除以下内容："
    echo "1. 小雅alist 容器 (xiaoya-alist)"
    echo "2. 配置文件目录 (/opt/xiaoya-alist)"
    echo ""

    read -p "确定要卸载 小雅alist 吗？(y/N): " confirm_uninstall
    if [[ ! "$confirm_uninstall" =~ ^[yY]$ ]]; then
        echo "卸载已取消。"
        read -p "按回车键继续..."
        return
    fi

    echo -e "${BLUE}正在停止并移除容器...${NC}"
    cd /opt/xiaoya-alist

    if docker compose version &> /dev/null; then
        docker_compose_cmd="docker compose"
    else
        docker_compose_cmd="docker-compose"
    fi

    $docker_compose_cmd down

    echo -e "${BLUE}正在清理安装目录...${NC}"
    cd / && rm -rf /opt/xiaoya-alist

    echo -e "${GREEN}✅ 小雅alist 卸载完成！${NC}"
    read -p "按回车键继续..."
}

# 访问 小雅alist Web 界面
function access_xiaoya_alist_web() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        访问 小雅alist Web 界面${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if [ ! -f "/opt/xiaoya-alist/.env" ]; then
        echo -e "${RED}❌ 小雅alist 未安装，请先安装。${NC}"
        read -p "按回车键继续..."
        return
    fi

    local host_port=$(grep -oP "^HOST_PORT=\K[0-9]+" /opt/xiaoya-alist/.env | head -1)
    host_port=${host_port:-5244}

    local container_status=$(docker inspect -f '{{.State.Status}}' xiaoya-alist 2>/dev/null || echo "未运行")
    local container_running=""
    if [ "$container_status" = "running" ]; then
        container_running="${GREEN}运行中${NC}"
    else
        container_running="${RED}未运行${NC}"
    fi

    IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"

    echo -e "当前容器状态: ${container_running}"
    echo ""
    echo -e "${CYAN}访问地址：${NC}"
    [ -n "$ipv4" ] && echo -e "IPv4 地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
    [ -n "$ipv6" ] && echo -e "IPv6 地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
    echo ""
    echo -e "${YELLOW}提示：默认用户名为 admin。若忘记密码，请在“修改配置”中重置。${NC}"
    read -p "按回车键返回..."
}

# Open WebUI 管理模块
function open_webui_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}            Open WebUI 管理${NC}"
        
        # 状态检测逻辑
        local status_text="${RED}未安装${NC}"
        local host_port=""
        
        if docker ps -a --format '{{.Names}}' | grep -q "^open-webui$"; then
            if docker inspect --format='{{.State.Status}}' open-webui 2>/dev/null | grep -q "running"; then
                status_text="${GREEN}运行中${NC}"
                host_port=$(docker inspect open-webui --format='{{(index (index .NetworkSettings.Ports "8080/tcp") 0).HostPort}}' 2>/dev/null)
            else
                status_text="${YELLOW}已停止${NC}"
            fi
        fi

        echo -e "          状态: ${status_text}"
        if [ -n "$host_port" ]; then
            IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
            echo -e "${CYAN}-----------------------------------------${NC}"
            [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
            [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
        fi
        
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  安装/更新 Open WebUI"
        echo -e " ${GREEN}2.${NC}  启动 Open WebUI"
        echo -e " ${GREEN}3.${NC}  停止 Open WebUI"
        echo -e " ${GREEN}4.${NC}  重启 Open WebUI"
        echo -e " ${GREEN}5.${NC}  查看容器状态"
        echo -e " ${GREEN}6.${NC}  查看容器日志"
        echo -e " ${GREEN}7.${NC}  卸载 Open WebUI"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-7): " webui_choice

        case "$webui_choice" in
            1) install_open_webui ;;
            2) start_open_webui ;;
            3) stop_open_webui ;;
            4) restart_open_webui ;;
            5) view_open_webui_status ;;
            6) docker logs --tail 50 open-webui; read -p "按回车键继续..." ;;
            7) uninstall_open_webui ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 1 ;;
        esac
    done
}

function install_open_webui() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          安装/更新 Open WebUI${NC}"
    echo -e "${CYAN}=========================================${NC}"

    # 检查Docker是否运行
    if ! docker info &>/dev/null; then
        echo -e "${RED}❌ Docker 服务未运行或不可用，请先启动Docker服务。${NC}"
        read -p "按回车键继续..."
        return
    fi

    # 检查磁盘空间
    echo -e "${BLUE}正在检查系统资源...${NC}"
    local available_space=$(df /var/lib/docker 2>/dev/null | awk 'NR==2 {print $4}')
    if [ -n "$available_space" ] && [ "$available_space" -lt 5000000 ]; then
        echo -e "${RED}❌ 磁盘空间不足！至少需要5GB可用空间。${NC}"
        echo -e "当前可用空间: $((available_space / 1024))MB"
        echo -e "${YELLOW}请清理磁盘空间或扩展存储后再试。${NC}"
        read -p "按回车键继续..."
        return
    fi

    if docker ps -a --format '{{.Names}}' | grep -q "^open-webui$"; then
        echo -e "${YELLOW}检测到 Open WebUI 已安装。${NC}"
        read -p "是否重新安装？(y/N): " reinstall
        [[ ! "$reinstall" =~ ^[yY]$ ]] && return
        docker stop open-webui &>/dev/null
        docker rm open-webui &>/dev/null
    fi

    # 获取宿主机端口
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

    echo -e "${BLUE}正在准备数据目录...${NC}"
    mkdir -p /opt/open-webui/data

    # 先拉取镜像，检查是否成功
    echo -e "${BLUE}正在拉取 Open WebUI 镜像...${NC}"
    if docker pull ghcr.io/open-webui/open-webui:main; then
        echo -e "${GREEN}镜像拉取成功！${NC}"
        
        echo -e "${BLUE}正在创建容器...${NC}"
        docker run -d \
            --name open-webui \
            --restart always \
            -p ${host_port}:8080 \
            -v /opt/open-webui/data:/app/backend/data \
            -e "WEBUI_AUTH=true" \
            -e "OLLAMA_BASE_URLS=http://host.docker.internal:11434" \
            ghcr.io/open-webui/open-webui:main

        if [ $? -eq 0 ]; then
            IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"

            echo -e "${GREEN}Open WebUI 安装成功！${NC}"
            echo -e "${YELLOW}默认用户名: admin${NC}"
            echo -e "${YELLOW}默认密码: admin123456${NC}"
            [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
            [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
            echo -e "${CYAN}-----------------------------------------${NC}"
            echo -e "${YELLOW}重要提示：首次登录后请立即修改默认密码！${NC}"
        else
            echo -e "${RED}容器创建失败，请检查 Docker 日志。${NC}"
        fi
    else
        echo -e "${RED}镜像拉取失败，请检查网络连接和磁盘空间。${NC}"
        echo -e "${YELLOW}可能的原因：${NC}"
        echo -e "  • 网络连接问题"
        echo -e "  • 磁盘空间不足（至少需要5GB）"
        echo -e "  • Docker服务异常"
    fi
    read -p "按回车键继续..."
}

function start_open_webui() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          启动 Open WebUI${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if docker ps -a --format '{{.Names}}' | grep -q "^open-webui$"; then
        echo -e "${BLUE}正在启动 Open WebUI...${NC}"
        docker start open-webui
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Open WebUI 启动成功！${NC}"
        else
            echo -e "${RED}启动失败，请检查容器状态。${NC}"
        fi
    else
        echo -e "${RED}未检测到 Open WebUI 容器，请先安装。${NC}"
    fi
    read -p "按回车键继续..."
}

function stop_open_webui() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          停止 Open WebUI${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if docker ps -a --format '{{.Names}}' | grep -q "^open-webui$"; then
        echo -e "${BLUE}正在停止 Open WebUI...${NC}"
        docker stop open-webui
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Open WebUI 已停止。${NC}"
        else
            echo -e "${RED}停止失败，请检查容器状态。${NC}"
        fi
    else
        echo -e "${RED}未检测到 Open WebUI 容器。${NC}"
    fi
    read -p "按回车键继续..."
}

function restart_open_webui() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          重启 Open WebUI${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if docker ps -a --format '{{.Names}}' | grep -q "^open-webui$"; then
        echo -e "${BLUE}正在重启 Open WebUI...${NC}"
        docker restart open-webui
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Open WebUI 重启成功！${NC}"
        else
            echo -e "${RED}重启失败，请检查容器状态。${NC}"
        fi
    else
        echo -e "${RED}未检测到 Open WebUI 容器，请先安装。${NC}"
    fi
    read -p "按回车键继续..."
}

function view_open_webui_status() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          Open WebUI 状态信息${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    if docker ps -a --format '{{.Names}}' | grep -q "^open-webui$"; then
        echo -e "${BLUE}容器状态:${NC}"
        docker ps -a --filter "name=open-webui" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        
        echo -e "\n${BLUE}容器详细信息:${NC}"
        docker inspect open-webui --format=''
        
        local host_port=$(docker inspect open-webui --format='{{(index (index .NetworkSettings.Ports "8080/tcp") 0).HostPort}}' 2>/dev/null)
        if [ -n "$host_port" ]; then
            IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
            echo -e "\n${BLUE}访问信息:${NC}"
            [ -n "$ipv4" ] && echo -e "IPv4 地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
            [ -n "$ipv6" ] && echo -e "IPv6 地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
        fi
    else
        echo -e "${RED}未检测到 Open WebUI 容器。${NC}"
    fi
    read -p "按回车键继续..."
}

function uninstall_open_webui() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}          卸载 Open WebUI${NC}"
    echo -e "${CYAN}=========================================${NC}"

    read -p "确定要卸载 Open WebUI 吗？此操作将删除所有数据 (y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        if docker ps -a --format '{{.Names}}' | grep -q "^open-webui$"; then
            docker stop open-webui &>/dev/null
            docker rm open-webui &>/dev/null
        fi
        
        if [ -d "/opt/open-webui" ]; then
            read -p "是否删除数据目录 /opt/open-webui？(y/N): " delete_data
            if [[ "$delete_data" =~ ^[yY]$ ]]; then
                rm -rf /opt/open-webui
                echo -e "${GREEN}数据目录已删除。${NC}"
            fi
        fi
        
        echo -e "${GREEN}Open WebUI 卸载完成。${NC}"
    else
        echo "操作已取消。"
    fi
    read -p "按回车键继续..."
}

# LibreSpeed 测速工具管理
function librespeed_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          LibreSpeed 测速工具${NC}"
        
        local status_text="${RED}未安装${NC}"
        local host_port=""
        
        if docker ps -a --format '{{.Names}}' | grep -q "^librespeed$"; then
            if docker inspect --format='{{.State.Status}}' librespeed 2>/dev/null | grep -q "running"; then
                status_text="${GREEN}运行中${NC}"
                host_port=$(docker inspect librespeed --format='{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' 2>/dev/null)
            else
                status_text="${YELLOW}已停止${NC}"
            fi
        fi

        echo -e "          状态: ${status_text}"
        if [ -n "$host_port" ]; then
            IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
            echo -e "${CYAN}-----------------------------------------${NC}"
            [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
            [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
        fi
        
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  安装/更新 LibreSpeed"
        echo -e " ${GREEN}2.${NC}  启动 LibreSpeed"
        echo -e " ${GREEN}3.${NC}  停止 LibreSpeed"
        echo -e " ${GREEN}4.${NC}  重启 LibreSpeed"
        echo -e " ${GREEN}5.${NC}  查看容器日志"
        echo -e " ${GREEN}6.${NC}  卸载 LibreSpeed"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-6): " ls_choice

        case "$ls_choice" in
            1) install_librespeed ;;
            2) start_librespeed ;;
            3) stop_librespeed ;;
            4) restart_librespeed ;;
            5) docker logs --tail 50 librespeed; read -p "按回车键继续..." ;;
            6) uninstall_librespeed ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 1 ;;
        esac
    done
}

function install_librespeed() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          安装/更新 LibreSpeed${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! docker info &>/dev/null; then
        echo -e "${RED}❌ Docker 服务未运行或不可用，请先启动Docker服务。${NC}"
        read -p "按回车键继续..."
        return
    fi

    # 创建部署目录
    deploy_dir="/opt/librespeed"
    mkdir -p "$deploy_dir"

    # 获取端口，默认8888
    read -p "请输入宿主机映射端口 (默认 8888): " host_port
    host_port=${host_port:-8888}

    # 检查端口占用
    if command -v ss &> /dev/null; then
        if ss -tuln | grep -q ":${host_port} "; then
            echo -e "${RED}❌ 端口 ${host_port} 已被占用，请选择其他端口。${NC}"
            read -p "按回车键继续..."
            return
        fi
    fi

    # 生成 docker-compose.yml 文件
    # 修复：使用 linuxserver/librespeed 镜像 (托管在Docker Hub，更稳定)
    cat > "$deploy_dir/docker-compose.yml" << EOF
version: '3'
services:
  librespeed:
    image: linuxserver/librespeed:latest
    container_name: librespeed
    restart: always
    ports:
      - "${host_port}:80"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      - TITLE=LibreSpeed
EOF

    echo -e "${BLUE}正在使用 Docker Compose 部署 LibreSpeed...${NC}"
    cd "$deploy_dir"
    
    # 停止并删除旧容器（如果有）
    if docker ps -a --format '{{.Names}}' | grep -q "^librespeed$"; then
        echo -e "${YELLOW}清理旧容器...${NC}"
        docker stop librespeed &>/dev/null
        docker rm librespeed &>/dev/null
    fi

    # 拉取并启动
    if command -v docker compose &> /dev/null; then
        docker compose pull && docker compose up -d
    elif command -v docker-compose &> /dev/null; then
        docker-compose pull && docker-compose up -d
    else
        echo -e "${RED}❌ 未检测到 docker-compose，无法部署。${NC}"
        return
    fi

    if [ $? -eq 0 ]; then
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        echo -e "${GREEN}LibreSpeed 安装成功！${NC}"
        echo -e "部署目录: ${YELLOW}$deploy_dir${NC}"
        echo -e "使用的镜像: ${GREEN}linuxserver/librespeed${NC}"
        [ -n "$ipv4" ] && echo -e "访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
        [ -n "$ipv6" ] && echo -e "访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
        echo ""
        echo -e "${RED}注意：如果无法访问，请务必检查服务器防火墙是否放行了端口 ${host_port}！${NC}"
    else
        echo -e "${RED}部署失败，请检查上方错误日志。${NC}"
    fi
    cd - > /dev/null
    read -p "按回车键继续..."
}

function start_librespeed() {
    deploy_dir="/opt/librespeed"
    if [ -d "$deploy_dir" ] && [ -f "$deploy_dir/docker-compose.yml" ]; then
        cd "$deploy_dir"
        if command -v docker compose &> /dev/null; then
            docker compose start && echo -e "${GREEN}已启动${NC}" || echo -e "${RED}启动失败${NC}"
        else
            docker-compose start && echo -e "${GREEN}已启动${NC}" || echo -e "${RED}启动失败${NC}"
        fi
        cd - > /dev/null
    else
        docker start librespeed && echo -e "${GREEN}已启动${NC}" || echo -e "${RED}启动失败${NC}"
    fi
    read -p "按回车键继续..."
}

function stop_librespeed() {
    deploy_dir="/opt/librespeed"
    if [ -d "$deploy_dir" ] && [ -f "$deploy_dir/docker-compose.yml" ]; then
        cd "$deploy_dir"
        if command -v docker compose &> /dev/null; then
            docker compose stop && echo -e "${GREEN}已停止${NC}" || echo -e "${RED}停止失败${NC}"
        else
            docker-compose stop && echo -e "${GREEN}已停止${NC}" || echo -e "${RED}停止失败${NC}"
        fi
        cd - > /dev/null
    else
        docker stop librespeed && echo -e "${GREEN}已停止${NC}" || echo -e "${RED}停止失败${NC}"
    fi
    read -p "按回车键继续..."
}

function restart_librespeed() {
    deploy_dir="/opt/librespeed"
    if [ -d "$deploy_dir" ] && [ -f "$deploy_dir/docker-compose.yml" ]; then
        cd "$deploy_dir"
        if command -v docker compose &> /dev/null; then
            docker compose restart && echo -e "${GREEN}已重启${NC}" || echo -e "${RED}重启失败${NC}"
        else
            docker-compose restart && echo -e "${GREEN}已重启${NC}" || echo -e "${RED}重启失败${NC}"
        fi
        cd - > /dev/null
    else
        docker restart librespeed && echo -e "${GREEN}已重启${NC}" || echo -e "${RED}重启失败${NC}"
    fi
    read -p "按回车键继续..."
}

function uninstall_librespeed() {
    read -p "确定要卸载 LibreSpeed 吗？(y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        deploy_dir="/opt/librespeed"
        if [ -d "$deploy_dir" ] && [ -f "$deploy_dir/docker-compose.yml" ]; then
            cd "$deploy_dir"
            if command -v docker compose &> /dev/null; then
                docker compose down
            else
                docker-compose down
            fi
            cd - > /dev/null
            rm -rf "$deploy_dir"
        else
            docker stop librespeed &>/dev/null
            docker rm librespeed &>/dev/null
        fi
        echo -e "${GREEN}LibreSpeed 已卸载。${NC}"
    fi
    read -p "按回车键继续..."
}

# MAME 街机模拟器管理 (适配 RomM 检测)
function mame_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          MAME 街机模拟器管理 (RomM)${NC}"
        
        # 检查 Docker 是否运行
        if ! docker info > /dev/null 2>&1; then
            echo -e "${RED}⚠️  Docker 服务未运行或未安装！${NC}"
        else
            # 修改后的状态检测逻辑：检测 romm 容器是否存在
            if docker ps -a --format '{{.Names}}' | grep -q "^romm$"; then
                if docker ps --format '{{.Names}}' | grep -q "^romm$"; then
                    echo -e "          状态: ${GREEN}运行中${NC}"
                    
                    # 获取映射端口和显示IP信息
                    local host_port=$(docker inspect romm --format='{{(index (index .NetworkSettings.Ports "8080/tcp") 0).HostPort}}' 2>/dev/null)
                    host_port=${host_port:-8080}
                    
                    IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
                    
                    echo -e "${CYAN}-----------------------------------------${NC}"
                    [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
                    [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
                else
                    echo -e "          状态: ${YELLOW}已停止${NC}"
                fi
            else
                echo -e "          状态: ${RED}未部署${NC}"
            fi
        fi
        
        echo -e "${CYAN}=========================================${NC}"
        echo "当前系统：RomM (内置 MAME 等多种模拟器)"
        echo "支持精美海报墙、网页内直接游玩、多平台管理"
        echo ""
        echo -e " ${GREEN}1.${NC}  安装/更新 模拟器"
        echo -e " ${GREEN}2.${NC}  启动 模拟器"
        echo -e " ${GREEN}3.${NC}  停止 模拟器"
        echo -e " ${GREEN}4.${NC}  重启 模拟器"
        echo -e " ${GREEN}5.${NC}  查看 运行状态和日志"
        echo -e " ${GREEN}6.${NC}  卸载 模拟器"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回应用中心菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-6): " mame_choice

        case "$mame_choice" in
            1) install_mame ;;
            2) start_mame ;;
            3) stop_mame ;;
            4) restart_mame ;;
            5) docker logs --tail 50 romm; read -p "按回车键继续..." ;;
            6) uninstall_mame ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 2 ;;
        esac
    done
}

# 安装 网页街机模拟器 (RomM 完整版架构：带独立数据库)
function install_mame() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}  安装/更新 网页街机模拟器 (RomM 完整全栈版)${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! docker info &>/dev/null; then
        echo -e "${RED}❌ Docker 服务未运行或不可用，请先启动Docker服务。${NC}"
        read -p "按回车键继续..."
        return
    fi

    # 1. 彻底清理之前残留的错误容器和配置文件 (解决你刚才遇到的无限重启问题)
    echo -e "${YELLOW}正在强制清理旧版本或错误的残留容器...${NC}"
    docker stop mame romm romm-redis romm-db &>/dev/null
    docker rm mame romm romm-redis romm-db &>/dev/null
    rm -f /opt/mame/docker-compose.yml

    # 2. 创建部署目录 (包含独立的数据库文件夹)
    deploy_dir="/opt/mame"
    mkdir -p "$deploy_dir/library/mame"
    mkdir -p "$deploy_dir/assets"
    mkdir -p "$deploy_dir/config"
    mkdir -p "$deploy_dir/redis"
    mkdir -p "$deploy_dir/db"

    echo ""
    read -p "请输入网页访问端口 (默认 8080): " host_port
    host_port=${host_port:-8080}

    if command -v ss &> /dev/null; then
        if ss -tuln | grep -q ":${host_port} "; then
            echo -e "${RED}❌ 端口 ${host_port} 已被占用，请选择其他端口。${NC}"
            read -p "按回车键继续..."
            return
        fi
    fi

    # 3. 自动生成随机的数据库密码和安全密钥 (避免被黑客扫描)
    local secret_key=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 32)
    local db_password=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 16)

    # 4. 生成包含 MariaDB 数据库的完整全栈 docker-compose.yml 
    cat > "$deploy_dir/docker-compose.yml" << EOF
services:
  romm:
    image: rommapp/romm:latest
    container_name: romm
    restart: unless-stopped
    environment:
      - ROMM_AUTH_SECRET_KEY=${secret_key}
      - DB_HOST=romm-db
      - DB_NAME=romm
      - DB_USER=romm
      - DB_PASSWD=${db_password}
      - IGDB_CLIENT_ID=
      - IGDB_CLIENT_SECRET=
    volumes:
      - ./library:/romm/library
      - ./assets:/romm/assets
      - ./config:/romm/config
    ports:
      - "${host_port}:8080"
    depends_on:
      - romm-db
      - romm-redis

  romm-db:
    image: mariadb:11.4
    container_name: romm-db
    restart: unless-stopped
    environment:
      - MARIADB_ROOT_PASSWORD=${db_password}_root
      - MARIADB_DATABASE=romm
      - MARIADB_USER=romm
      - MARIADB_PASSWORD=${db_password}
    volumes:
      - ./db:/var/lib/mysql

  romm-redis:
    image: redis:7-alpine
    container_name: romm-redis
    restart: unless-stopped
    volumes:
      - ./redis:/data
EOF

    echo -e "${BLUE}正在拉取 RomM 及其数据库镜像，这可能需要几分钟...${NC}"
    cd "$deploy_dir"
    
    if command -v docker compose &> /dev/null; then
        docker compose pull && docker compose up -d
    else
        docker-compose pull && docker-compose up -d
    fi

    if [ $? -eq 0 ]; then
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        echo ""
        echo -e "${GREEN}✅ 模拟器及全栈数据库安装成功！${NC}"
        echo -e "部署目录: ${YELLOW}$deploy_dir${NC}"
        echo -e "游戏 ROM 请放入: ${YELLOW}$deploy_dir/library/mame${NC}"
        echo -e "${CYAN}-----------------------------------------${NC}"
        
        # 自动抓取公网IP，防止你误用内网IP访问
        local public_ip=$(curl -s ifconfig.me || echo "你的公网IP")
        echo -e "🌐 局域网访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
        echo -e "🌐 公网访问地址:   ${YELLOW}http://${public_ip}:${host_port}${NC}"
        
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e "${RED}⚠️ 重要提示：${NC}"
        echo -e "1. ${YELLOW}千万别立刻打开！数据库需要时间初始化，请耐心等待 1 分钟后再打开网页！${NC}"
        echo -e "2. 首次打开网页时，需要你自行注册一个管理员账号密码。"
        echo -e "3. 请一定确保云服务器的【安全组】或系统【防火墙】中放行了 ${host_port} 端口！"
    else
        echo -e "${RED}部署失败，请检查 Docker Compose 配置和网络。${NC}"
    fi
    cd - > /dev/null
    read -p "按回车键继续..."
}

function start_mame() {
    deploy_dir="/opt/mame"
    if [ -d "$deploy_dir" ] && [ -f "$deploy_dir/docker-compose.yml" ]; then
        cd "$deploy_dir"
        if command -v docker compose &> /dev/null; then
            docker compose start && echo -e "${GREEN}已启动${NC}" || echo -e "${RED}启动失败${NC}"
        else
            docker-compose start && echo -e "${GREEN}已启动${NC}" || echo -e "${RED}启动失败${NC}"
        fi
        cd - > /dev/null
    else
        docker start mame && echo -e "${GREEN}已启动${NC}" || echo -e "${RED}启动失败${NC}"
    fi
    read -p "按回车键继续..."
}

function stop_mame() {
    deploy_dir="/opt/mame"
    if [ -d "$deploy_dir" ] && [ -f "$deploy_dir/docker-compose.yml" ]; then
        cd "$deploy_dir"
        if command -v docker compose &> /dev/null; then
            docker compose stop && echo -e "${GREEN}已停止${NC}" || echo -e "${RED}停止失败${NC}"
        else
            docker-compose stop && echo -e "${GREEN}已停止${NC}" || echo -e "${RED}停止失败${NC}"
        fi
        cd - > /dev/null
    else
        docker stop mame && echo -e "${GREEN}已停止${NC}" || echo -e "${RED}停止失败${NC}"
    fi
    read -p "按回车键继续..."
}

function restart_mame() {
    deploy_dir="/opt/mame"
    if [ -d "$deploy_dir" ] && [ -f "$deploy_dir/docker-compose.yml" ]; then
        cd "$deploy_dir"
        if command -v docker compose &> /dev/null; then
            docker compose restart && echo -e "${GREEN}已重启${NC}" || echo -e "${RED}重启失败${NC}"
        else
            docker-compose restart && echo -e "${GREEN}已重启${NC}" || echo -e "${RED}重启失败${NC}"
        fi
        cd - > /dev/null
    else
        docker restart mame && echo -e "${GREEN}已重启${NC}" || echo -e "${RED}重启失败${NC}"
    fi
    read -p "按回车键继续..."
}

function uninstall_mame() {
    read -p "确定要卸载 MAME 吗？(y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        deploy_dir="/opt/mame"
        if [ -d "$deploy_dir" ] && [ -f "$deploy_dir/docker-compose.yml" ]; then
            cd "$deploy_dir"
            if command -v docker compose &> /dev/null; then
                docker compose down
            else
                docker-compose down
            fi
            cd - > /dev/null
            rm -rf "$deploy_dir"
        else
            docker stop mame &>/dev/null
            docker rm mame &>/dev/null
        fi
        echo -e "${GREEN}MAME 已卸载。${NC}"
    fi
    read -p "按回车键继续..."
}

function myip_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             MyIP 工具箱管理${NC}"
        
        local status_text="${RED}未安装${NC}"
        local host_port=""
        
        if docker ps -a --format '{{.Names}}' | grep -q "^myip$"; then
            if docker inspect --format='{{.State.Status}}' myip 2>/dev/null | grep -q "running"; then
                status_text="${GREEN}运行中${NC}"
                host_port=$(docker inspect myip --format='{{(index (index .NetworkSettings.Ports "18966/tcp") 0).HostPort}}' 2>/dev/null)
            else
                status_text="${YELLOW}已停止${NC}"
            fi
        fi

        echo -e "          状态: ${status_text}"
        if [ -n "$host_port" ]; then
            IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
            echo -e "${CYAN}-----------------------------------------${NC}"
            [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
            [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
        fi
        
        echo -e "${CYAN}=========================================${NC}"
        echo -e "MyIP 是一个极其强大的 IP 工具箱，支持检查 IP 归属地、"
        echo -e "DNS 泄露、WebRTC 检测、网速测试、GFW 连通性等。"
        echo ""
        echo -e " ${GREEN}1.${NC}  安装/更新 MyIP"
        echo -e " ${GREEN}2.${NC}  启动 MyIP"
        echo -e " ${GREEN}3.${NC}  停止 MyIP"
        echo -e " ${GREEN}4.${NC}  重启 MyIP"
        echo -e " ${GREEN}5.${NC}  查看容器日志"
        echo -e " ${GREEN}6.${NC}  卸载 MyIP"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-6): " myip_choice

        case "$myip_choice" in
            1) install_myip ;;
            2) manage_myip_container "start" ;;
            3) manage_myip_container "stop" ;;
            4) manage_myip_container "restart" ;;
            5) docker logs --tail 50 myip; read -p "按回车键继续..." ;;
            6) uninstall_myip ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 1 ;;
        esac
    done
}

function install_myip() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          安装/更新 MyIP 工具箱${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! docker info &>/dev/null; then
        echo -e "${RED}❌ Docker 服务未运行或不可用。${NC}"
        read -p "按回车键继续..."
        return
    fi

    deploy_dir="/opt/myip"
    mkdir -p "$deploy_dir"

    read -p "请输入宿主机映射端口 (默认 18966): " host_port
    host_port=${host_port:-18966}

    # 端口占用检查
    if command -v ss &> /dev/null; then
        if ss -tuln | grep -q ":${host_port} "; then
            echo -e "${RED}❌ 端口 ${host_port} 已被占用，请选择其他端口。${NC}"
            read -p "按回车键继续..."
            return
        fi
    fi

    cat > "$deploy_dir/docker-compose.yml" << EOF
services:
  myip:
    image: jason5ng32/myip:latest
    container_name: myip
    restart: always
    ports:
      - "${host_port}:18966"
    environment:
      - TZ=Asia/Shanghai
EOF

    echo -e "${BLUE}正在部署 MyIP 容器...${NC}"
    cd "$deploy_dir"
    
    if docker ps -a --format '{{.Names}}' | grep -q "^myip$"; then
        docker stop myip &>/dev/null
        docker rm myip &>/dev/null
    fi

    if docker compose version &> /dev/null; then
        docker compose pull && docker compose up -d
    else
        docker-compose pull && docker-compose up -d
    fi

    if [ $? -eq 0 ]; then
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        echo -e "${GREEN}✅ MyIP 工具箱安装成功！${NC}"
        [ -n "$ipv4" ] && echo -e "访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
    else
        echo -e "${RED}❌ 部署失败，请检查 Docker 日志。${NC}"
    fi
    cd - > /dev/null
    read -p "按回车键继续..."
}

function manage_myip_container() {
    local action=$1
    local deploy_dir="/opt/myip"
    if [ -d "$deploy_dir" ] && [ -f "$deploy_dir/docker-compose.yml" ]; then
        cd "$deploy_dir"
        if docker compose version &> /dev/null; then
            docker compose "$action"
        else
            docker-compose "$action"
        fi
        echo -e "${GREEN}操作 ${action} 已完成。${NC}"
        cd - > /dev/null
    else
        echo -e "${RED}未检测到安装目录。${NC}"
    fi
    sleep 1
}

function uninstall_myip() {
    read -p "确定要卸载 MyIP 吗？(y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        deploy_dir="/opt/myip"
        if [ -d "$deploy_dir" ]; then
            cd "$deploy_dir"
            if docker compose version &> /dev/null; then
                docker compose down
            else
                docker-compose down
            fi
            cd - > /dev/null
            rm -rf "$deploy_dir"
            echo -e "${GREEN}MyIP 已彻底卸载。${NC}"
        else
            docker stop myip &>/dev/null
            docker rm myip &>/dev/null
            echo -e "${GREEN}容器已移除。${NC}"
        fi
    fi
    read -p "按回车键继续..."
}

# =================================================================
# IT-Tools 万能工具箱管理模块
# =================================================================

function it_tools_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             IT-Tools 管理${NC}"
        
        local status_text="${RED}未安装${NC}"
        local host_port=""
        
        # 状态检测
        if docker ps -a --format '{{.Names}}' | grep -q "^it-tools$"; then
            if docker inspect --format='{{.State.Status}}' it-tools 2>/dev/null | grep -q "running"; then
                status_text="${GREEN}运行中${NC}"
                # 获取映射端口
                host_port=$(docker inspect it-tools --format='{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' 2>/dev/null)
            else
                status_text="${YELLOW}已停止${NC}"
            fi
        fi

        echo -e "          状态: ${status_text}"
        if [ -n "$host_port" ]; then
            IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
            echo -e "${CYAN}-----------------------------------------${NC}"
            [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
            [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
        fi
        
        echo -e "${CYAN}=========================================${NC}"
        echo -e "IT-Tools 提供各种在线工具：加密、转换、"
        echo -e "生成器等，一个页面涵盖所有开发常用工具。"
        echo ""
        echo -e " ${GREEN}1.${NC} 安装/更新 IT-Tools"
        echo -e " ${GREEN}2.${NC} 启动 IT-Tools"
        echo -e " ${GREEN}3.${NC} 停止 IT-Tools"
        echo -e " ${GREEN}4.${NC} 重启 IT-Tools"
        echo -e " ${GREEN}5.${NC} 查看容器日志"
        echo -e " ${GREEN}6.${NC} 卸载 IT-Tools"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC} 返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-6): " it_choice

        case "$it_choice" in
            1) install_it_tools ;;
            2) manage_it_tools_container "start" ;;
            3) manage_it_tools_container "stop" ;;
            4) manage_it_tools_container "restart" ;;
            5) docker logs --tail 50 it-tools; read -p "按回车键继续..." ;;
            6) uninstall_it_tools ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 1 ;;
        esac
    done
}

function install_it_tools() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          安装/更新 IT-Tools${NC}"
    echo -e "${CYAN}=========================================${NC}"

    # 1. Docker 环境检查
    if ! docker info &>/dev/null; then
        echo -e "${RED}❌ Docker 服务未运行或未安装，请先安装 Docker。${NC}"
        read -p "按回车键继续..."
        return
    fi

    # 2. 准备目录
    local deploy_dir="/opt/it-tools"
    if ! mkdir -p "$deploy_dir" 2>/dev/null; then
        echo -e "${RED}❌ 无法创建目录 $deploy_dir，请检查 root 权限。${NC}"
        read -p "按回车键继续..."
        return
    fi

    # 3. 端口识别
    local default_port=8080
    if [ -f "$deploy_dir/docker-compose.yml" ]; then
        # 如果已安装，提取旧端口
        local exist_port=$(grep -oP '^\s+-\s+"\K[0-9]+(?=:80")' "$deploy_dir/docker-compose.yml" | head -1)
        default_port=${exist_port:-8080}
    fi

    read -p "请输入宿主机映射端口 (默认 $default_port): " host_port
    host_port=${host_port:-$default_port}

    # 端口占用检查（仅限新安装）
    if ! docker ps -a --format '{{.Names}}' | grep -q "^it-tools$"; then
        if command -v ss &> /dev/null; then
            if ss -tuln | grep -q ":${host_port} "; then
                echo -e "${RED}❌ 端口 ${host_port} 已被占用，请更换端口。${NC}"
                read -p "按回车键继续..."
                return
            fi
        fi
    fi

    # 4. 生成配置文件 (修正镜像名为全小写 corentinth)
    cat > "$deploy_dir/docker-compose.yml" << EOF
services:
  it-tools:
    image: corentinth/it-tools:latest
    container_name: it-tools
    restart: always
    ports:
      - "${host_port}:80"
EOF

    echo -e "${BLUE}正在拉取镜像并启动容器...${NC}"
    cd "$deploy_dir"
    
    # 清理可能存在的旧容器
    if docker ps -a --format '{{.Names}}' | grep -q "^it-tools$"; then
        docker stop it-tools &>/dev/null
        docker rm it-tools &>/dev/null
    fi

    # 执行部署
    if docker compose version &> /dev/null; then
        docker compose pull && docker compose up -d --remove-orphans
    else
        docker-compose pull && docker-compose up -d --remove-orphans
    fi

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ IT-Tools 安装/更新成功！${NC}"
        IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
        [ -n "$ipv4" ] && echo -e "访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
    else
        echo -e "${RED}❌ 部署失败，请检查网络或配置 Docker 加速站。${NC}"
    fi
    cd - > /dev/null
    read -p "按回车键继续..."
}

function manage_it_tools_container() {
    local action=$1
    local deploy_dir="/opt/it-tools"
    if [ -d "$deploy_dir" ] && [ -f "$deploy_dir/docker-compose.yml" ]; then
        cd "$deploy_dir"
        echo -e "${BLUE}正在对 IT-Tools 执行 ${action} 操作...${NC}"
        if docker compose version &> /dev/null; then 
            docker compose "$action"
        else 
            docker-compose "$action"
        fi
        echo -e "${GREEN}操作完成。${NC}"
        cd - > /dev/null
    else
        echo -e "${RED}❌ 未检测到安装目录，请先安装。${NC}"
    fi
    sleep 1
}

function uninstall_it_tools() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}           卸载 IT-Tools${NC}"
    echo -e "${CYAN}=========================================${NC}"

    read -p "确定要彻底删除 IT-Tools 吗？(y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        local deploy_dir="/opt/it-tools"
        if [ -d "$deploy_dir" ]; then
            cd "$deploy_dir"
            if docker compose version &> /dev/null; then docker compose down; else docker-compose down; fi
            cd - > /dev/null
            rm -rf "$deploy_dir"
            echo -e "${GREEN}✅ IT-Tools 已彻底卸载并清理文件。${NC}"
        else
            docker stop it-tools &>/dev/null
            docker rm it-tools &>/dev/null
            echo -e "${GREEN}容器已移除。${NC}"
        fi
    else
        echo -e "${YELLOW}已取消卸载。${NC}"
    fi
    read -p "按回车键继续..."
}

function uptime_kuma_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}           Uptime Kuma 管理${NC}"
        
        local status_text="${RED}未安装${NC}"
        local host_port=""
        
        # 状态检测
        if docker ps -a --format '{{.Names}}' | grep -q "^uptime-kuma$"; then
            if docker inspect --format='{{.State.Status}}' uptime-kuma 2>/dev/null | grep -q "running"; then
                status_text="${GREEN}运行中${NC}"
                host_port=$(docker inspect uptime-kuma --format='{{(index (index .NetworkSettings.Ports "3001/tcp") 0).HostPort}}' 2>/dev/null)
            else
                status_text="${YELLOW}已停止${NC}"
            fi
        fi

        echo -e "          状态: ${status_text}"
        if [ -n "$host_port" ]; then
            IFS='|' read -r ipv4 ipv6 <<< "$(get_access_ips)"
            echo -e "${CYAN}-----------------------------------------${NC}"
            [ -n "$ipv4" ] && echo -e "IPv4 访问地址: ${YELLOW}http://${ipv4}:${host_port}${NC}"
            [ -n "$ipv6" ] && echo -e "IPv6 访问地址: ${YELLOW}http://[${ipv6}]:${host_port}${NC}"
        fi
        
        echo -e "${CYAN}=========================================${NC}"
        echo -e "Uptime Kuma 是一个美观的自托管监控工具。"
        echo ""
        echo -e " ${GREEN}1.${NC} 安装/更新 Uptime Kuma"
        echo -e " ${GREEN}2.${NC} 启动 Uptime Kuma"
        echo -e " ${GREEN}3.${NC} 停止 Uptime Kuma"
        echo -e " ${GREEN}4.${NC} 重启 Uptime Kuma"
        echo -e " ${GREEN}5.${NC} 查看容器日志"
        echo -e " ${GREEN}6.${NC} 卸载 Uptime Kuma"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC} 返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-6): " kuma_choice

        case "$kuma_choice" in
            1) install_uptime_kuma ;;
            2) manage_kuma_container "start" ;;
            3) manage_kuma_container "stop" ;;
            4) manage_kuma_container "restart" ;;
            5) docker logs --tail 50 uptime-kuma; read -p "按回车键继续..." ;;
            6) uninstall_uptime_kuma ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 1 ;;
        esac
    done
}

# 安装/更新函数
function install_uptime_kuma() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}      安装/更新 Uptime Kuma ${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! docker info &>/dev/null; then
        echo -e "${RED}❌ Docker 服务未运行。${NC}"
        read -p "按回车键继续..."
        return
    fi

    local deploy_dir="/opt/uptime-kuma"
    mkdir -p "$deploy_dir/data"

    local default_port=3001
    if [ -f "$deploy_dir/docker-compose.yml" ]; then
        local exist_port=$(grep -oP '^\s+-\s+"\K[0-9]+(?=:3001")' "$deploy_dir/docker-compose.yml" | head -1)
        default_port=${exist_port:-3001}
    fi

    read -p "请输入宿主机映射端口 (默认 $default_port): " host_port
    host_port=${host_port:-$default_port}

    # 写入配置，指定镜像为 :2 以确保获取 2.1.3+
    cat > "$deploy_dir/docker-compose.yml" << EOF
services:
  uptime-kuma:
    image: louislam/uptime-kuma:2
    container_name: uptime-kuma
    restart: always
    volumes:
      - ./data:/app/data
    ports:
      - "${host_port}:3001"
EOF

    echo -e "${BLUE}正在拉取最新的 Uptime Kuma 2.x 镜像...${NC}"
    cd "$deploy_dir"
    
    if docker compose version &> /dev/null; then
        docker compose pull
        docker compose up -d --remove-orphans
    else
        docker-compose pull
        docker-compose up -d --remove-orphans
    fi

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Uptime Kuma 已成功安装/更新！${NC}"
    else
        echo -e "${RED}❌ 部署失败。${NC}"
    fi
    cd - > /dev/null
    read -p "按回车键继续..."
}

# 通用生命周期管理
function manage_kuma_container() {
    local action=$1
    local deploy_dir="/opt/uptime-kuma"
    if [ -d "$deploy_dir" ] && [ -f "$deploy_dir/docker-compose.yml" ]; then
        cd "$deploy_dir"
        if docker compose version &> /dev/null; then
            docker compose "$action"
        else
            docker-compose "$action"
        fi
        echo -e "${GREEN}操作 ${action} 已执行。${NC}"
        cd - > /dev/null
    else
        echo -e "${RED}未检测到安装目录。${NC}"
    fi
    sleep 1
}

# 卸载函数 (核心补全)
function uninstall_uptime_kuma() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}           卸载 Uptime Kuma${NC}"
    echo -e "${CYAN}=========================================${NC}"

    read -p "确定要彻底删除 Uptime Kuma 吗？(y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        local deploy_dir="/opt/uptime-kuma"
        
        if [ -d "$deploy_dir" ]; then
            echo -e "${BLUE}正在停止并移除容器...${NC}"
            cd "$deploy_dir"
            if docker compose version &> /dev/null; then
                docker compose down
            else
                docker-compose down
            fi
            cd - > /dev/null
            
            echo ""
            read -p "是否同步删除所有监控数据 (data 目录)？(y/N): " del_data
            if [[ "$del_data" =~ ^[yY]$ ]]; then
                rm -rf "$deploy_dir"
                echo -e "${GREEN}✅ 所有数据和配置文件已清理。${NC}"
            else
                rm -f "$deploy_dir/docker-compose.yml"
                echo -e "${YELLOW}已保留数据目录 (/opt/uptime-kuma/data)，仅移除容器。${NC}"
            fi
        else
            # 如果目录不在但容器在，强行尝试删除容器
            docker stop uptime-kuma &>/dev/null
            docker rm uptime-kuma &>/dev/null
            echo -e "${GREEN}容器已移除。${NC}"
        fi
        echo -e "${GREEN}卸载流程完成。${NC}"
    else
        echo -e "${YELLOW}已取消卸载操作。${NC}"
    fi
    read -p "按回车键继续..."
}