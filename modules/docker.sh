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
    local deps=("curl" "jq" "tar" "lsof" "ca-certificates")
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
    _docker_env_detect
    _docker_fix_deps
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        安装/更新 Docker 环境${NC}"
    echo -e "${CYAN}=========================================${NC}"

    # 检测并处理 Snap 版冲突
    if command -v snap >/dev/null 2>&1 && snap list | grep -q docker; then
        echo -e "${YELLOW}检测到冲突的 Snap 版 Docker，正在移除...${NC}"
        snap remove docker >/dev/null 2>&1
    fi

    local docker_install_choice
    if command -v docker >/dev/null 2>&1; then
        echo -e "${YELLOW}检测到 Docker 已安装。${NC}"
        echo -e " ${GREEN}1.${NC} 更新 Docker"
        echo -e " ${RED}0.${NC} 返回上级菜单"
        read -p "请输入选择(0-1): " docker_install_choice
    else
        echo -e "${YELLOW}检测到 Docker 未安装。${NC}"
        echo -e " ${GREEN}1.${NC} 安装 Docker"
        echo -e " ${RED}0.${NC} 返回上级菜单"
        read -p "请输入选择(0-1): " docker_install_choice
    fi

    [[ "$docker_install_choice" == "0" ]] && return

    if [[ "$docker_install_choice" == "1" ]]; then
        echo -e "${BLUE}开始安装/更新 Docker 环境...${NC}"
        
        # 判定镜像源
        local mirror_param=""
        $IS_CN && mirror_param="--mirror Aliyun"

        curl -fsSL https://get.docker.com -o get-docker.sh
        if sh get-docker.sh $mirror_param; then
            rm get-docker.sh
            systemctl enable --now docker
            echo -e "${GREEN}Docker 引擎部署成功。${NC}"
        else
            rm get-docker.sh
            echo -e "${RED}Docker 安装失败，请检查网络。${NC}"
            read -p "按任意键继续..."
            return
        fi

        # 动态安装 Docker Compose V2 (支持架构自适应)
        echo -e "${BLUE}正在配置 Docker Compose ($ARCH)...${NC}"
        local compose_url="https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$ARCH"
        $IS_CN && compose_url="https://ghproxy.com/$compose_url" # 国内使用加速
        
        mkdir -p /usr/local/lib/docker/cli-plugins
        if curl -SL "$compose_url" -o /usr/local/lib/docker/cli-plugins/docker-compose; then
            chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
            echo -e "${GREEN}Docker Compose 部署成功。${NC}"
        fi
    fi
    read -p "操作完成，按任意键继续..."
}

# 修复 Docker 启动时的 iptables/nft 冲突问题
function fix_docker_iptables() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}         Docker 启动故障深度修复${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    # 加载模块
    modprobe overlay && modprobe br_netfilter
    cat <<EOF > /etc/modules-load.d/docker-fix.conf
overlay
br_netfilter
EOF

    # 优化参数
    cat <<EOF > /etc/sysctl.d/docker-fix.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
    sysctl --system >/dev/null 2>&1

    # 强制切换 legacy 模式 (针对 Debian 11/12)
    if command -v update-alternatives >/dev/null 2>&1; then
        echo -e "${BLUE}正在切换 iptables 模式...${NC}"
        update-alternatives --set iptables /usr/sbin/iptables-legacy >/dev/null 2>&1
        update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy >/dev/null 2>&1
    fi
    
    systemctl restart docker
    if systemctl is-active --quiet docker; then
        echo -e "${GREEN}修复成功！Docker 已恢复运行。${NC}"
    else
        echo -e "${RED}修复失败，可能涉及内核组件缺失。${NC}"
    fi
    read -p "按任意键继续..."
}

# 重启 Docker 服务
function restart_docker_service() {
    echo -e "${BLUE}正在重启 Docker 服务...${NC}"
    systemctl restart docker && echo -e "${GREEN}Docker 服务重启成功。${NC}" || echo -e "${RED}重启失败！${NC}"
    sleep 1
}

# 停止 Docker 服务
function stop_docker_service() {
    read -p "确定要停止 Docker 服务吗？(y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        systemctl stop docker && echo -e "${GREEN}Docker 服务已成功停止。${NC}" || echo -e "${RED}停止失败！${NC}"
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
            1) docker start "$target_id" ;;
            2) docker stop "$target_id" ;;
            3) docker restart "$target_id" ;;
            4) docker rm -f "$target_id" ;;
            5) docker logs --tail 100 -f "$target_id" ;;
            6) docker exec -it "$target_id" /bin/bash || docker exec -it "$target_id" /bin/sh ;;
            *) echo -e "${RED}无效操作${NC}" ;;
        esac
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

    # 端口占用判定
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
    echo -e "${RED}${BOLD}正在执行 Docker 系统深度清理...${NC}"
    docker system prune -a --volumes -f
    echo -e "${GREEN}清理完成！${NC}"
    read -p "按任意键继续..."
}

# 更换镜像源
function change_docker_source() {
    echo -e "${BLUE}正在调用 LinuxMirrors 脚本更换源...${NC}"
    bash <(curl -sSL https://linuxmirrors.cn/main.sh)
    read -p "按任意键继续..."
}

# 编辑 daemon.json
function edit_daemon_json() {
    local daemon_file="/etc/docker/daemon.json"
    [[ ! -f "$daemon_file" ]] && mkdir -p /etc/docker && echo "{}" > "$daemon_file"
    nano "$daemon_file" || vi "$daemon_file"
    echo -e "${YELLOW}编辑完成，请记得重启 Docker 服务以生效。${NC}"
    read -p "按任意键继续..."
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
        
        # 状态检测
        local status_msg="${YELLOW}未启用${NC}"
        if jq -e '.ipv6 == true' "$daemon_file" >/dev/null 2>&1; then
            status_msg="${GREEN}已启用${NC}"
        fi
        echo -e "当前状态: $status_msg"
        echo -e "${CYAN}------------------------------------------------${NC}"
        
        echo -e "  ${GREEN}1.${NC} 开启 IPv6 访问"
        echo -e "  ${GREEN}2.${NC} 关闭 IPv6 访问"
        echo -e "  ${RED}0.${NC} 返回"
        echo -e "${CYAN}================================================${NC}"
        read -p "请选择操作: " ipv6_choice

        case $ipv6_choice in
            1)
                echo -e "${BLUE}正在配置 IPv6...${NC}"
                jq '. + {"ipv6": true, "fixed-cidr-v6": "2001:db8:1::/64"}' "$daemon_file" > "${daemon_file}.tmp" && mv "${daemon_file}.tmp" "$daemon_file"
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
                systemctl stop docker
                tar -czvf "docker_backup_$(date +%F).tar.gz" /var/lib/docker
                systemctl start docker
                echo -e "${GREEN}备份完成。${NC}"; sleep 2 ;;
            2) 
                read -p "输入备份包完整路径: " b_path
                [[ -f "$b_path" ]] && { systemctl stop docker; rm -rf /var/lib/docker/*; tar -xzvf "$b_path" -C /; systemctl start docker; echo -e "${GREEN}还原成功${NC}"; }
                sleep 2 ;;
            0) break ;;
        esac
    done
}

# 彻底卸载
function uninstall_docker() {
    read -p "警告：这将彻底删除所有镜像和容器！确定吗？(y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        docker ps -aq | xargs -r docker stop
        docker ps -aq | xargs -r docker rm
        systemctl stop docker
        if command -v apt-get >/dev/null 2>&1; then
            apt-get purge -y docker-ce docker-ce-cli containerd.io
            apt-get autoremove -y
        fi
        rm -rf /var/lib/docker /etc/docker
        echo -e "${GREEN}卸载完成。${NC}"
    fi
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
        echo -e "  ${GREEN}11.${NC} 编辑 daemon.json           ${GREEN}12.${NC} IPv6 访问控制"
        echo -e "  ${GREEN}13.${NC} 备份/迁移/还原             ${GREEN}14.${NC} 系统一键深度清理"
        echo ""
        echo -e "  ${CYAN}[ 系统操作 ]${NC}"
        echo -e "  ${RED}15.${NC} 彻底卸载 Docker 环境        ${RED}0.${NC} 返回上级菜单"
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
            11) edit_daemon_json ;;
            12) docker_ipv6_config ;;
            13) backup_migrate_restore_docker ;;
            14) clean_docker_resources ;;
            15) uninstall_docker ;;
            0) break ;;
            *) echo -e "${RED}无效输入${NC}"; sleep 1 ;;
        esac
    done
}