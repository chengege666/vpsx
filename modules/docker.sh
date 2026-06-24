#!/bin/bash

# Docker 管理模块 (模块化增强版)

# 导入颜色定义
if [ -f "./utils/color.sh" ]; then
    source ./utils/color.sh
else
    # 回退定义，以防单独运行脚本
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    NC='\033[0m'
    BOLD='\033[1m'
fi

# --- 内部辅助函数 (不直接在菜单显示) ---

# 环境检测：架构、虚拟化、网络区域
function _docker_env_detect() {
    ARCH=$(uname -m)
    VIRT_TYPE=$(systemd-detect-virt 2>/dev/null || echo "unknown")
    # 心跳检测网络环境
    if curl -s --connect-timeout 2 https://www.google.com >/dev/null; then
        IS_CN=false
    else
        IS_CN=true
    fi
}

# 自动补齐基础依赖
function _docker_fix_deps() {
    local deps=("curl" "jq" "tar" "lsof" "iptables")
    local missing=()
    for dep in "${deps[@]}"; do
        command -v "$dep" >/dev/null 2>&1 || missing+=("$dep")
    done
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${BLUE}正在补齐基础依赖: ${missing[*]}...${NC}"
        if command -v apt-get >/dev/null 2>&1; then
            apt-get update -y >/dev/null 2>&1 && apt-get install -y "${missing[@]}" >/dev/null 2>&1
        elif command -v yum >/dev/null 2>&1; then
            yum install -y "${missing[@]}" >/dev/null 2>&1
        fi
    fi
}

# 系统环境自动调优与修复
function _docker_system_check_and_fix() {
    echo -e "${BLUE}正在进行系统环境预检与调优...${NC}"

    # 1. 关键内核模块检测与加载
    local modules=("overlay" "br_netfilter")
    for mod in "${modules[@]}"; do
        if ! lsmod | grep -q "$mod"; then
            # echo -e "  - 自动加载内核模块: ${mod}"
            modprobe "$mod" >/dev/null 2>&1
            # 持久化加载
            if [ -d /etc/modules-load.d ]; then
                echo "$mod" > "/etc/modules-load.d/docker-${mod}.conf"
            fi
        fi
    done

    # 2. 开启 IPv4 转发 (Docker 网络必需)
    if [ "$(sysctl -n net.ipv4.ip_forward 2>/dev/null)" != "1" ]; then
        # echo -e "  - 自动开启 IPv4 转发"
        echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-docker.conf
        sysctl --system >/dev/null 2>&1
    fi

    # 3. 低内存自动 Swap 补救 (防止 OOM)
    # 获取物理内存大小 (MB) - 兼容不同系统的 free 命令输出格式
    local mem_mb=$(free -m 2>/dev/null | awk 'NR==2 {print $2}')
    local swap_mb=$(free -m 2>/dev/null | awk 'NR==3 {print $2}')
    
    # 验证数值有效性
    if ! [[ "$mem_mb" =~ ^[0-9]+$ ]]; then
        mem_mb=$(cat /proc/meminfo 2>/dev/null | grep -i MemTotal | awk '{print $2}')
        [ -n "$mem_mb" ] && mem_mb=$((mem_mb / 1024))
    fi
    if ! [[ "$swap_mb" =~ ^[0-9]+$ ]]; then
        swap_mb=$(cat /proc/meminfo 2>/dev/null | grep -i SwapTotal | awk '{print $2}')
        [ -n "$swap_mb" ] && swap_mb=$((swap_mb / 1024))
    fi
    
    # 如果内存小于 1024MB 且无 Swap
    if [[ "$mem_mb" =~ ^[0-9]+$ ]] && [[ "$swap_mb" =~ ^[0-9]+$ ]] && [ "$mem_mb" -lt 1024 ] && [ "$swap_mb" -eq 0 ]; then
        echo -e "${YELLOW}  ! 检测到内存不足 1GB，正在创建 1GB 虚拟内存(Swap)以保障运行...${NC}"
        if ! [ -f /swapfile ]; then
            dd if=/dev/zero of=/swapfile bs=1M count=1024 status=none
            chmod 600 /swapfile
            mkswap /swapfile >/dev/null 2>&1
            swapon /swapfile >/dev/null 2>&1
            if ! grep -q "/swapfile" /etc/fstab; then
                echo '/swapfile none swap sw 0 0' >> /etc/fstab
            fi
            echo -e "${GREEN}  ✔ Swap 创建完成${NC}"
        fi
    fi
}

# --- 核心功能函数 ---

# 检查 Docker 安装状态并显示版本与诊断
function check_docker_status() {
    _docker_env_detect
    local docker_command_found=false
    local docker_service_active=false
    local docker_version=""
    local docker_is_functional=false

    if command -v docker >/dev/null 2>&1; then
        docker_command_found=true
        docker_version=$(docker --version 2>/dev/null | awk '{print $3}' | sed 's/,//')
        [[ -n "$docker_version" ]] && docker_is_functional=true
    fi

    if systemctl is-active --quiet docker >/dev/null 2>&1; then
        docker_service_active=true
    fi

    echo -e "${CYAN}================================================${NC}"
    echo -e "               ${GREEN}Docker 运行状态诊断${NC}"
    echo -e "${CYAN}================================================${NC}"
    echo -e " ● 硬件架构: ${BLUE}$ARCH${NC} | 虚拟化: ${BLUE}$VIRT_TYPE${NC}"

    if $docker_is_functional && $docker_service_active; then
        echo -e " ● Docker 服务: [ ${GREEN}运行中${NC} ] (v${docker_version})"
        local running_count=$(docker ps -q 2>/dev/null | wc -l)
        local image_count=$(docker images -q 2>/dev/null | wc -l)
        echo -e " ● 资源概况: ${BLUE}${running_count}${NC} 容器正在运行 | ${BLUE}${image_count}${NC} 本地镜像"
    elif $docker_is_functional && ! $docker_service_active; then
        echo -e " ● Docker 服务: [ ${YELLOW}已安装但未运行${NC} ]"
        echo -e " ● 故障定位: 服务未启动，建议执行 [ ${CYAN}systemctl start docker${NC} ]"
    else
        echo -e " ● Docker 服务: [ ${RED}未安装或环境异常${NC} ]"
        if $docker_command_found && ! $docker_is_functional; then
            echo -e " ● 故障定位: ${YELLOW}iptables 冲突或内核模块缺失${NC}"
        fi
    fi
    echo -e "${CYAN}================================================${NC}"
}

# 安装/更新 Docker 环境
function install_update_docker_env() {
    _docker_fix_deps
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        安装/更新 Docker 环境${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if command -v docker &> /dev/null; then
        echo -e "${YELLOW}检测到 Docker 已安装 (版本: $(docker --version 2>/dev/null | awk '{print $3}' | sed 's/,//'))${NC}"
        echo ""
        read -p "是否更新 Docker？(y/N): " confirm
    else
        echo -e "${YELLOW}检测到 Docker 未安装。${NC}"
        echo ""
        read -p "是否安装 Docker？(y/N): " confirm
    fi

    if [[ ! "$confirm" =~ ^[yY]$ ]]; then
        echo -e "${YELLOW}已取消${NC}"
        read -p "按回车键继续..."
        return
    fi

    # 检测并处理 Snap 版冲突
    if command -v snap &> /dev/null && snap list 2>/dev/null | grep -q docker; then
        echo -e "${YELLOW}检测到冲突的 Snap 版 Docker，正在移除...${NC}"
        snap remove docker &> /dev/null
    fi

    _docker_system_check_and_fix

    echo -e "${BLUE}正在从 Docker 官方仓库安装...${NC}"
    echo ""

    apt-get update -y && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    if command -v docker &> /dev/null; then
        systemctl enable --now docker &> /dev/null
        echo ""
        echo -e "${GREEN}Docker 安装/更新完成！${NC}"
    else
        echo ""
        echo -e "${RED}Docker 安装失败，请检查网络或系统环境。${NC}"
    fi
    read -p "按回车键继续..."
}

# 修复 Docker 启动时的 iptables/nft 冲突问题
function fix_docker_iptables() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}         Docker 启动故障深度修复${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker 未安装，请先安装 Docker。${NC}"
        read -p "按任意键继续..."
        return
    fi

    modprobe overlay 2>/dev/null || echo -e "${YELLOW}⚠️  overlay 模块加载失败（非必需）${NC}"
    modprobe br_netfilter 2>/dev/null || echo -e "${YELLOW}⚠️  br_netfilter 模块加载失败${NC}"

    cat <<EOF > /etc/modules-load.d/docker-fix.conf
overlay
br_netfilter
EOF

    cat <<EOF > /etc/sysctl.d/docker-fix.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
    sysctl --system >/dev/null 2>&1

    if command -v update-alternatives &> /dev/null && [ -f /usr/sbin/iptables-legacy ]; then
        echo -e "${BLUE}正在切换 iptables 模式为 legacy...${NC}"
        update-alternatives --set iptables /usr/sbin/iptables-legacy 2>/dev/null
        update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy 2>/dev/null
    fi

    systemctl restart docker
    if systemctl is-active --quiet docker; then
        echo -e "${GREEN}✅ 修复成功！Docker 已恢复运行。${NC}"
    else
        echo -e "${RED}❌ 修复失败，可能涉及内核组件缺失。${NC}"
    fi
    read -p "按任意键继续..."
}

# 重启 Docker 服务
function restart_docker_service() {
    if ! command -v docker &> /dev/null || ! command -v systemctl &> /dev/null; then
        echo -e "${RED}❌ Docker 未安装，无法重启。${NC}"
        sleep 1
        return
    fi
    echo -e "${BLUE}正在重启 Docker 服务...${NC}"
    systemctl restart docker && echo -e "${GREEN}Docker 服务重启成功。${NC}" || echo -e "${RED}重启失败！${NC}"
    sleep 1
}

# 停止 Docker 服务
function stop_docker_service() {
    if ! command -v docker &> /dev/null || ! command -v systemctl &> /dev/null; then
        echo -e "${RED}❌ Docker 未安装。${NC}"
        sleep 1
        return
    fi
    read -p "确定要停止 Docker 服务吗？(y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        systemctl stop docker && echo -e "${GREEN}Docker 服务已成功停止。${NC}" || echo -e "${RED}停止失败！${NC}"
    else
        echo -e "${YELLOW}已取消${NC}"
    fi
    sleep 1
}

# 查看 Docker 全局状态
function view_docker_global_status() {
    _docker_fix_deps # 确保 jq 存在
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        Docker 全局状态查看${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! systemctl is-active --quiet docker; then
        echo -e "${RED}错误: Docker 服务未运行。${NC}"; read -p "按任意键继续..."; return
    fi

    if command -v jq >/dev/null 2>&1; then
        docker info --format '{{json .}}' | jq -r '"版本: \(.ServerVersion)\n内核: \(.KernelVersion)\n系统: \(.OperatingSystem)\n架构: \(.Architecture)\nCPU: \(.NCPU)\n内存: \((.MemTotal/1024/1024/1024)) GB"'
    else
        docker info | grep -E "Server Version|Kernel Version|Operating System|Architecture|CPUs|Total Memory"
    fi
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}运行统计:${NC}"
    echo "  容器总数: $(docker ps -a -q | wc -l) (运行中: $(docker ps -q | wc -l))"
    echo "  本地镜像: $(docker images -q | wc -l)"
    read -p "按任意键继续..."
}

# 容器管理模块
function docker_container_management() {
    while true; do
        clear
        echo -e "${CYAN}================================================${NC}"
        echo -e "               ${GREEN}Docker 容器管理${NC}"
        echo -e "${CYAN}================================================${NC}"
        
        local containers=()
        local i=1
        printf "${YELLOW}%-5s %-12s %-20s %-15s${NC}\n" "序号" "容器ID" "名称" "状态"
        echo -e "${CYAN}------------------------------------------------${NC}"
        
        while read -r line; do
            if [ -n "$line" ]; then
                containers+=("$line")
                local id=$(echo "$line" | awk '{print $1}')
                local name=$(echo "$line" | awk '{print $2}')
                local status=$(echo "$line" | awk '{print $3}')
                local status_color="${NC}"
                [[ "$status" == "Up" ]] && status_color="${GREEN}" || status_color="${RED}"
                printf "[%2d]  %-12s %-20s ${status_color}%-15s${NC}\n" "$i" "$id" "$name" "$status"
                ((i++))
            fi
        done < <(docker ps -a --format "{{.ID}} {{.Names}} {{.Status}}" | sed 's/About //g; s/ago//g')

        [[ ${#containers[@]} -eq 0 ]] && echo -e "${YELLOW}当前没有容器${NC}"

        echo -e "${CYAN}------------------------------------------------${NC}"
        echo -e " ${GREEN}1.启动 2.停止 3.重启 4.删除 5.日志 6.终端 8.创建 0.返回${NC}"
        read -p "请选择操作 [1-8]: " op_choice
        [[ "$op_choice" == "0" ]] && break
        [[ "$op_choice" == "8" ]] && { create_new_container; continue; }

        read -p "请输入容器序号: " idx
        local target_id=$(echo "${containers[$((idx-1))]}" | awk '{print $1}')
        [[ -z "$target_id" ]] && { echo -e "${RED}序号无效${NC}"; sleep 1; continue; }

        case $op_choice in
            1) docker start "$target_id" && echo -e "${GREEN}容器已启动${NC}" ;;
            2) docker stop "$target_id" && echo -e "${GREEN}容器已停止${NC}" ;;
            3) docker restart "$target_id" && echo -e "${GREEN}容器已重启${NC}" ;;
            4) docker rm -f "$target_id" && echo -e "${GREEN}容器已删除${NC}" ;;
            5) echo -e "${BLUE}显示最近 50 行日志 (Ctrl+C 退出):${NC}"; docker logs --tail 50 -f "$target_id" ;;
            6) docker exec -it "$target_id" /bin/bash || docker exec -it "$target_id" /bin/sh ;;
            *) echo -e "${RED}无效操作${NC}" ;;
        esac
        sleep 1
    done
}

# 创建容器 (带端口占用检测)
function create_new_container() {
    clear
    echo -e "${CYAN}================================================${NC}"
    echo -e "          ${GREEN}通过 Docker Compose 创建容器${NC}"
    echo -e "${CYAN}================================================${NC}"
    
    read -p "请输入容器项目名称: " name
    read -p "请输入镜像名称 (如 nginx:latest): " image
    read -p "请输入映射端口 (如 8080): " h_port

    if [[ -z "$name" || -z "$image" || -z "$h_port" ]]; then
        echo -e "${RED}错误: 输入不能为空！${NC}"
        read -p "按任意键继续..."
        return
    fi

    if ! [[ "$h_port" =~ ^[0-9]+$ ]] || [ "$h_port" -lt 1 ] || [ "$h_port" -gt 65535 ]; then
        echo -e "${RED}错误: 端口号必须为 1-65535 的数字！${NC}"
        read -p "按任意键继续..."
        return
    fi

    name=$(echo "$name" | tr -cd 'a-zA-Z0-9_-')
    if [ -z "$name" ]; then
        echo -e "${RED}错误: 名称只能包含字母、数字、下划线和连字符！${NC}"
        read -p "按任意键继续..."
        return
    fi

    if lsof -i :"$h_port" >/dev/null 2>&1; then
        echo -e "${RED}错误: 宿主机端口 $h_port 已被占用！${NC}"
        lsof -i :"$h_port"
        read -p "按任意键继续..."
        return
    fi

    local base_dir="/opt/docker/$name"
    mkdir -p "$base_dir"
    cat <<EOF > "$base_dir/docker-compose.yml"
services:
  $name:
    image: $image
    container_name: $name
    restart: always
    ports:
      - "$h_port:${h_port#*:}"
EOF

    echo -e "${BLUE}正在通过 Docker Compose 启动...${NC}"
    cd "$base_dir" && docker compose up -d
    cd - >/dev/null
    read -p "创建完成，按任意键继续..."
}

# 深度清理资源
function clean_docker_resources() {
    clear
    echo -e "${RED}${BOLD}⚠️  此操作将删除：${NC}"
    echo -e "  - 所有已停止的容器"
    echo -e "  - 所有未被使用的镜像（含虚悬镜像）"
    echo -e "  - 所有未被使用的网络"
    echo -e "  - 所有未被使用的数据卷"
    echo ""
    read -p "确定要执行深度清理吗？(y/N): " confirm
    if [[ ! "$confirm" =~ ^[yY]$ ]]; then
        echo -e "${YELLOW}已取消${NC}"
        read -p "按任意键继续..."
        return
    fi
    echo -e "${BLUE}正在执行 Docker 系统深度清理...${NC}"
    docker system prune -a --volumes -f
    echo -e "${GREEN}清理完成！${NC}"
    read -p "按任意键继续..."
}

# 更换镜像源
function change_docker_source() {
    local daemon_file="/etc/docker/daemon.json"
    mkdir -p /etc/docker
    [[ ! -f "$daemon_file" ]] && echo "{}" > "$daemon_file"

    while true; do
        clear
        echo -e "${CYAN}================================================${NC}"
        echo -e "           ${GREEN}Docker 镜像源配置${NC}"
        echo -e "${CYAN}================================================${NC}"
        
        local current_registry=$(jq -r '.registry-mirrors // []' "$daemon_file" 2>/dev/null | head -c 100)
        if [[ "$current_registry" == "[]" ]]; then
            echo -e "当前状态: ${YELLOW}未配置镜像源${NC}"
        else
            echo -e "当前镜像源: ${GREEN}$current_registry${NC}"
        fi
        
        echo -e "${CYAN}------------------------------------------------${NC}"
        echo -e "  ${GREEN}1.${NC} 配置阿里云镜像源"
        echo -e "  ${GREEN}2.${NC} 配置腾讯云镜像源"
        echo -e "  ${GREEN}3.${NC} 调用 LinuxMirrors 脚本自动配置"
        echo -e "  ${GREEN}4.${NC} 查看/编辑 daemon.json"
        echo -e "  ${RED}0.${NC} 返回"
        echo -e "${CYAN}================================================${NC}"
        read -p "请选择操作: " source_choice

        case $source_choice in
            1)
                echo -e "${BLUE}正在配置阿里云镜像源...${NC}"
                jq '. + {"registry-mirrors": ["https://registry.cn-hangzhou.aliyuncs.com"]}' "$daemon_file" > "${daemon_file}.tmp" && mv "${daemon_file}.tmp" "$daemon_file"
                systemctl restart docker
                echo -e "${GREEN}配置成功！${NC}"
                read -p "按任意键继续..."
                ;;
            2)
                echo -e "${BLUE}正在配置腾讯云镜像源...${NC}"
                jq '. + {"registry-mirrors": ["https://mirror.ccs.tencentyun.com"]}' "$daemon_file" > "${daemon_file}.tmp" && mv "${daemon_file}.tmp" "$daemon_file"
                systemctl restart docker
                echo -e "${GREEN}配置成功！${NC}"
                read -p "按任意键继续..."
                ;;
            3)
                echo -e "${BLUE}正在调用 LinuxMirrors 脚本...${NC}"
                if curl -sSL --connect-timeout 10 https://linuxmirrors.cn/main.sh | bash; then
                    echo -e "${GREEN}配置成功！${NC}"
                else
                    echo -e "${RED}调用失败，网络连接问题！${NC}"
                    echo -e "${YELLOW}建议手动配置镜像源${NC}"
                fi
                read -p "按任意键继续..."
                ;;
            4)
                echo -e "${CYAN}当前 daemon.json 内容:${NC}"
                cat "$daemon_file"
                echo -e "${CYAN}------------------------------------------------${NC}"
                read -p "是否编辑该文件？(y/N): " edit_confirm
                if [[ "$edit_confirm" =~ ^[Yy]$ ]]; then
                    nano "$daemon_file" || vi "$daemon_file"
                    echo -e "${YELLOW}编辑完成，请重启 Docker 服务以生效。${NC}"
                fi
                read -p "按任意键继续..."
                ;;
            0) break ;;
            *) echo -e "${RED}无效输入${NC}"; sleep 1 ;;
        esac
    done
}

# IPv6 访问控制 (使用 jq 安全操作)
function docker_ipv6_config() {
    _docker_fix_deps
    local daemon_file="/etc/docker/daemon.json"
    mkdir -p /etc/docker
    [[ ! -f "$daemon_file" ]] && echo "{}" > "$daemon_file"

    while true; do
        clear
        echo -e "${CYAN}================================================${NC}"
        echo -e "           ${GREEN}Docker IPv6 访问控制${NC}"
        echo -e "${CYAN}================================================${NC}"

        if ! command -v docker &> /dev/null || ! systemctl is-active --quiet docker 2>/dev/null; then
            echo -e "${RED}❌ Docker 服务未运行，请先启动 Docker。${NC}"
            echo -e "${CYAN}================================================${NC}"
            echo -e "  ${RED}0.${NC} 返回"
            read -p "请选择操作: " ipv6_choice
            [[ "$ipv6_choice" == "0" ]] && break
            continue
        fi

        local status_msg="${YELLOW}未启用${NC}"
        if jq -e '.ipv6 == true' "$daemon_file" >/dev/null 2>&1; then
            status_msg="${GREEN}已启用${NC}"
        fi
        echo -e "当前状态: $status_msg"
        echo -e "${CYAN}------------------------------------------------${NC}"

        echo -e "  ${GREEN}1.${NC} 开启 IPv6 访问"
        echo -e "  ${GREEN}2.${NC} 关闭 IPv6 访问"
        echo -e "  ${GREEN}3.${NC} 查看当前 IPv6 配置"
        echo -e "  ${RED}0.${NC} 返回"
        echo -e "${CYAN}================================================${NC}"
        read -p "请选择操作: " ipv6_choice

        case $ipv6_choice in
            1)
                # 如果已启用 IPv6，读取已有 CIDR 避免 IP 段变化
                local existing_cidr=$(jq -r '."fixed-cidr-v6" // ""' "$daemon_file" 2>/dev/null)
                local fixed_cidr="$existing_cidr"

                if [ -z "$fixed_cidr" ]; then
                    # 生成随机 ULA 前缀
                    local rand_hex=$(date +%s | md5sum 2>/dev/null | head -c 8 || echo "")
                    [ -z "$rand_hex" ] && rand_hex=$(date +%N | sha256sum 2>/dev/null | head -c 8 || echo "deadbeef")
                    fixed_cidr="fd00:${rand_hex:0:4}:${rand_hex:4:4}::/64"
                fi

                echo -e "${BLUE}正在配置 IPv6，使用 CIDR: ${fixed_cidr}${NC}"
                jq ".ipv6 = true | .\"fixed-cidr-v6\" = \"$fixed_cidr\"" "$daemon_file" > "${daemon_file}.tmp" && mv "${daemon_file}.tmp" "$daemon_file"
                systemctl restart docker
                echo -e "${GREEN}IPv6 访问已开启。${NC}"
                read -p "按任意键继续..."
                ;;
            2)
                echo -e "${BLUE}正在关闭 IPv6...${NC}"
                jq 'del(.ipv6) | del(."fixed-cidr-v6")' "$daemon_file" > "${daemon_file}.tmp" && mv "${daemon_file}.tmp" "$daemon_file"
                systemctl restart docker
                echo -e "${YELLOW}IPv6 访问已关闭。${NC}"
                read -p "按任意键继续..."
                ;;
            3)
                echo -e "${CYAN}当前 daemon.json 内容:${NC}"
                cat "$daemon_file"
                read -p "按任意键继续..."
                ;;
            0) break ;;
            *) echo -e "${RED}无效输入${NC}"; sleep 1 ;;
        esac
    done
}

# 备份/还原模块
function backup_migrate_restore_docker() {
    while true; do
        clear
        echo -e "${CYAN}================================================${NC}"
        echo -e "         ${GREEN}Docker 备份 / 还原${NC}"
        echo -e "${CYAN}================================================${NC}"
        echo -e "  ${GREEN}1.${NC} 备份 /var/lib/docker (打包)"
        echo -e "  ${GREEN}2.${NC} 从备份包还原"
        echo -e "  ${RED}0.${NC} 返回"
        read -p "请选择操作: " choice
        case $choice in
            1) 
                local backup_dir="/opt/docker-backup"
                mkdir -p "$backup_dir"
                local backup_file="$backup_dir/docker_backup_$(date +%F_%H%M%S).tar.gz"
                systemctl stop docker
                tar -czvf "$backup_file" /var/lib/docker
                systemctl start docker
                echo -e "${GREEN}备份完成: $backup_file${NC}"; sleep 2 ;;
            2) 
                read -p "输入备份包完整路径: " b_path
                if [[ -f "$b_path" ]]; then
                    read -p "警告：还原将清空当前所有 Docker 数据！确定继续？(y/N): " confirm
                    if [[ "$confirm" =~ ^[Yy]$ ]]; then
                        systemctl stop docker
                        rm -rf /var/lib/docker/*
                        tar -xzvf "$b_path" -C /
                        systemctl start docker
                        echo -e "${GREEN}还原成功${NC}"
                    else
                        echo -e "${YELLOW}已取消还原操作${NC}"
                    fi
                else
                    echo -e "${RED}错误: 备份文件不存在！${NC}"
                fi
                sleep 2 ;;
            0) break ;;
        esac
    done
}

# 彻底卸载
function uninstall_docker() {
    read -p "⚠️  警告：此操作将彻底删除所有 Docker 镜像、容器、数据卷和配置！确定吗？(y/N): " confirm
    if [[ ! "$confirm" =~ ^[yY]$ ]]; then
        echo -e "${YELLOW}已取消${NC}"
        read -p "按任意键继续..."
        return
    fi

    # 停止并删除所有容器
    if command -v docker &> /dev/null; then
        docker ps -aq 2>/dev/null | while read -r cid; do
            [ -n "$cid" ] && docker stop "$cid" &> /dev/null && docker rm "$cid" &> /dev/null
        done
    fi

    # 停止 Docker 服务
    if command -v systemctl &> /dev/null; then
        systemctl stop docker &> /dev/null
        systemctl disable docker &> /dev/null
    fi

    # 卸载 Docker 包（支持 apt/yum/dnf）
    if command -v apt-get &> /dev/null; then
        apt-get purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-buildx-plugin &> /dev/null
        apt-get autoremove -y &> /dev/null
    elif command -v dnf &> /dev/null; then
        dnf remove -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-buildx-plugin &> /dev/null
    elif command -v yum &> /dev/null; then
        yum remove -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-buildx-plugin &> /dev/null
    fi

    # 删除数据、配置和 Compose 插件
    rm -rf /var/lib/docker /etc/docker /var/lib/containerd
    rm -f /usr/local/lib/docker/cli-plugins/docker-compose

    echo -e "${GREEN}Docker 已彻底卸载。${NC}"
    read -p "按任意键继续..."
}

# --- 镜像/网络/卷管理模块 ---

# 镜像管理模块
function docker_image_management() {
    while true; do
        clear
        echo -e "${CYAN}================================================${NC}"
        echo -e "               ${GREEN}Docker 镜像管理${NC}"
        echo -e "${CYAN}================================================${NC}"
        
        local images=()
        local i=1
        printf "${YELLOW}%-5s %-30s %-15s %-10s${NC}\n" "序号" "镜像名:标签" "镜像ID" "大小"
        echo -e "${CYAN}------------------------------------------------${NC}"
        
        if command -v docker >/dev/null 2>&1; then
            while read -r line; do
                if [ -n "$line" ]; then
                    images+=("$line")
                    local repo_tag=$(echo "$line" | awk '{print $1":"$2}')
                    local id=$(echo "$line" | awk '{print $3}')
                    local size=$(echo "$line" | awk '{print $4}')
                    printf "[%2d]  %-30s %-15s %-10s\n" "$i" "${repo_tag:0:30}" "$id" "$size"
                    ((i++))
                fi
            done < <(docker images --format "{{.Repository}} {{.Tag}} {{.ID}} {{.Size}}" | head -n 20)
        else
            echo -e "${RED}Docker 未运行或未安装${NC}"
        fi

        [[ ${#images[@]} -eq 0 ]] && echo -e "${YELLOW}当前没有镜像${NC}"

        echo -e "${CYAN}------------------------------------------------${NC}"
        echo -e " ${GREEN}1.拉取 2.删除 3.清理虚悬镜像 0.返回${NC}"
        read -p "请选择操作 [0-3]: " op_choice
        [[ "$op_choice" == "0" ]] && break

        case $op_choice in
            1) 
                read -p "请输入镜像名称 (如 nginx:latest): " img_name
                if [[ -n "$img_name" ]]; then
                    echo -e "${BLUE}正在拉取 $img_name ...${NC}"
                    docker pull "$img_name"
                fi
                read -p "按任意键继续..." ;;
            2) 
                read -p "请输入要删除的镜像序号: " idx
                if [[ "$idx" =~ ^[0-9]+$ ]] && [ "$idx" -ge 1 ] && [ "$idx" -le "${#images[@]}" ]; then
                    local target_id=$(echo "${images[$((idx-1))]}" | awk '{print $3}')
                    if [[ -n "$target_id" ]]; then
                        docker rmi "$target_id"
                    fi
                else
                    echo -e "${RED}序号无效${NC}"
                fi
                read -p "按任意键继续..." ;;
            3) 
                echo -e "${BLUE}正在清理虚悬镜像...${NC}"
                docker image prune -f
                read -p "按任意键继续..." ;;
            *) echo -e "${RED}无效操作${NC}"; sleep 1 ;;
        esac
    done
}

# 网络管理模块
function docker_network_management() {
    while true; do
        clear
        echo -e "${CYAN}================================================${NC}"
        echo -e "               ${GREEN}Docker 网络管理${NC}"
        echo -e "${CYAN}================================================${NC}"
        
        local networks=()
        local i=1
        printf "${YELLOW}%-5s %-15s %-20s %-10s${NC}\n" "序号" "网络ID" "名称" "驱动"
        echo -e "${CYAN}------------------------------------------------${NC}"
        
        if command -v docker >/dev/null 2>&1; then
             while read -r line; do
                if [ -n "$line" ]; then
                    networks+=("$line")
                    local id=$(echo "$line" | awk '{print $1}')
                    local name=$(echo "$line" | awk '{print $2}')
                    local driver=$(echo "$line" | awk '{print $3}')
                    printf "[%2d]  %-15s %-20s %-10s\n" "$i" "$id" "${name:0:20}" "$driver"
                    ((i++))
                fi
            done < <(docker network ls --format "{{.ID}} {{.Name}} {{.Driver}}")
        else
             echo -e "${RED}Docker 未运行或未安装${NC}"
        fi

        [[ ${#networks[@]} -eq 0 ]] && echo -e "${YELLOW}当前没有网络${NC}"

        echo -e "${CYAN}------------------------------------------------${NC}"
        echo -e " ${GREEN}1.创建 2.删除 3.清理未使用网络 0.返回${NC}"
        read -p "请选择操作 [0-3]: " op_choice
        [[ "$op_choice" == "0" ]] && break
        
        case $op_choice in
            1) 
                read -p "请输入网络名称: " net_name
                if [[ -n "$net_name" ]]; then
                    docker network create "$net_name"
                    echo -e "${GREEN}网络 $net_name 创建成功${NC}"
                fi
                read -p "按任意键继续..." ;;
            2) 
                read -p "请输入要删除的网络序号: " idx
                if [[ "$idx" =~ ^[0-9]+$ ]] && [ "$idx" -ge 1 ] && [ "$idx" -le "${#networks[@]}" ]; then
                    local target_id=$(echo "${networks[$((idx-1))]}" | awk '{print $1}')
                    if [[ -n "$target_id" ]]; then
                        docker network rm "$target_id"
                    fi
                else
                    echo -e "${RED}序号无效${NC}"
                fi
                read -p "按任意键继续..." ;;
            3) 
                echo -e "${BLUE}正在清理未使用网络...${NC}"
                docker network prune -f
                read -p "按任意键继续..." ;;
            *) echo -e "${RED}无效操作${NC}"; sleep 1 ;;
        esac
    done
}

# 卷管理模块
function docker_volume_management() {
    while true; do
        clear
        echo -e "${CYAN}================================================${NC}"
        echo -e "               ${GREEN}Docker 卷管理${NC}"
        echo -e "${CYAN}================================================${NC}"
        
        local volumes=()
        local i=1
        printf "${YELLOW}%-5s %-30s %-10s${NC}\n" "序号" "卷名称" "驱动"
        echo -e "${CYAN}------------------------------------------------${NC}"
        
        if command -v docker >/dev/null 2>&1; then
            while read -r line; do
                if [ -n "$line" ]; then
                    volumes+=("$line")
                    local name=$(echo "$line" | awk '{print $1}')
                    local driver=$(echo "$line" | awk '{print $2}')
                    printf "[%2d]  %-30s %-10s\n" "$i" "${name:0:30}" "$driver"
                    ((i++))
                fi
            done < <(docker volume ls --format "{{.Name}} {{.Driver}}")
        else
             echo -e "${RED}Docker 未运行或未安装${NC}"
        fi

        [[ ${#volumes[@]} -eq 0 ]] && echo -e "${YELLOW}当前没有卷${NC}"

        echo -e "${CYAN}------------------------------------------------${NC}"
        echo -e " ${GREEN}1.创建 2.删除 3.清理未使用卷 0.返回${NC}"
        read -p "请选择操作 [0-3]: " op_choice
        [[ "$op_choice" == "0" ]] && break
        
        case $op_choice in
            1) 
                read -p "请输入卷名称: " vol_name
                if [[ -n "$vol_name" ]]; then
                    docker volume create "$vol_name"
                    echo -e "${GREEN}卷 $vol_name 创建成功${NC}"
                fi
                read -p "按任意键继续..." ;;
            2) 
                read -p "请输入要删除的卷序号: " idx
                if [[ "$idx" =~ ^[0-9]+$ ]] && [ "$idx" -ge 1 ] && [ "$idx" -le "${#volumes[@]}" ]; then
                    local target_name=$(echo "${volumes[$((idx-1))]}" | awk '{print $1}')
                    if [[ -n "$target_name" ]]; then
                        docker volume rm "$target_name"
                    fi
                else
                    echo -e "${RED}序号无效${NC}"
                fi
                read -p "按任意键继续..." ;;
            3) 
                echo -e "${BLUE}正在清理未使用卷...${NC}"
                docker volume prune -f
                read -p "按任意键继续..." ;;
            *) echo -e "${RED}无效操作${NC}"; sleep 1 ;;
        esac
    done
}

# --- 菜单主入口 ---

function docker_menu() {
    while true; do
        clear
        check_docker_status
        echo -e "  ${CYAN}[ 基础维护 ]${NC}"
        echo -e "  ${GREEN}1.${NC} 安装/更新 Docker 环境       ${GREEN}2.${NC} 查看 Docker 全局状态"
        echo -e "  ${GREEN}3.${NC} 更换 Docker 国内镜像源      ${GREEN}4.${NC} Docker 启动故障修复"
        echo -e "  ${GREEN}5.${NC} 重启 Docker 服务            ${GREEN}6.${NC} 停止 Docker 服务"
        echo ""
        echo -e "  ${CYAN}[ 资源管理 ]${NC}"
        echo -e "  ${GREEN}7.${NC} 容器管理                    ${GREEN}8.${NC} 镜像管理"
        echo -e "  ${GREEN}9.${NC} 网络管理                    ${GREEN}10.${NC}卷管理"
        echo ""
        echo -e "  ${CYAN}[ 高级配置 ]${NC}"
        echo -e "  ${GREEN}11.${NC} IPv6 访问控制"
        echo -e "  ${GREEN}12.${NC} 备份/迁移/还原             ${GREEN}13.${NC} 系统一键深度清理"
        echo ""
        echo -e "  ${CYAN}[ 系统操作 ]${NC}"
        echo -e "  ${RED}14.${NC} 彻底卸载 Docker 环境        ${RED}0.${NC} 返回上级菜单"
        echo -e "${CYAN}================================================${NC}"
        read -p "请输入操作代码: " docker_choice

        case "$docker_choice" in
            1) install_update_docker_env ;;
            2) view_docker_global_status ;;
            3) change_docker_source ;;
            4) fix_docker_iptables ;;
            5) restart_docker_service ;;
            6) stop_docker_service ;;
            7) docker_container_management ;;
            8) docker_image_management ;;
            9) docker_network_management ;;
            10) docker_volume_management ;;
            11) docker_ipv6_config ;;
            12) backup_migrate_restore_docker ;;
            13) clean_docker_resources ;;
            14) uninstall_docker ;;
            0) break ;;
            *) echo -e "${RED}无效输入${NC}"; sleep 1 ;;
        esac
    done
}