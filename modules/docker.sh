#!/bin/bash

# Docker 管理模块

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
fi

# 检查 Docker 安装状态并显示版本与诊断
function check_docker_status() {
    local docker_command_found=false
    local docker_service_active=false
    local docker_version=""
    local docker_is_functional=false

    # 1. 检查 'docker' 命令是否存在
    if command -v docker >/dev/null 2>&1; then
        docker_command_found=true
        docker_version=$(docker --version 2>/dev/null | awk '{print $3}' | sed 's/,//')
        if [ -n "$docker_version" ]; then
            docker_is_functional=true
        fi
    fi

    # 2. 检查 Docker 服务状态
    if command -v systemctl >/dev/null 2>&1; then
        if systemctl is-active --quiet docker >/dev/null 2>&1; then
            docker_service_active=true
        fi
    else
        if pgrep dockerd >/dev/null 2>&1; then
            docker_service_active=true
        fi
    fi

    echo -e "${CYAN}================================================${NC}"
    echo -e "               ${GREEN}Docker 运行状态诊断${NC}"
    echo -e "${CYAN}================================================${NC}"

    if $docker_is_functional && $docker_service_active; then
        echo -e " ● Docker 服务: [ ${GREEN}运行中${NC} ] (v${docker_version})"
        # 显示简单的统计
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
            echo -e " ● 建议操作: 尝试执行菜单中的 [ ${YELLOW}10. Docker 启动故障修复${NC} ]"
        fi
    fi
    echo -e "${CYAN}================================================${NC}"
}



# --- 核心逻辑开始 ---


# 安装/更新 Docker 环境 (包含 Docker Compose)
function install_update_docker_env() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        安装/更新 Docker 环境${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if command -v docker >/dev/null 2>&1; then
        echo -e "${YELLOW}检测到 Docker 已安装。${NC}"
        echo -e " ${GREEN}1.${NC} 更新 Docker"
        echo -e " ${RED}0.${NC} 返回上级菜单"
        read -p "请输入你的选择(0-1): " docker_install_choice
        case "$docker_install_choice" in
            1)
                echo -e "${BLUE}开始更新 Docker...${NC}"
                curl -fsSL https://get.docker.com -o get-docker.sh
                if sh get-docker.sh; then
                    rm get-docker.sh
                    systemctl start docker
                    if systemctl is-active --quiet docker; then
                        echo -e "${GREEN}Docker 更新并启动成功。${NC}"
                    else
                        echo -e "${RED}Docker 更新成功，但服务启动失败。${NC}"
                        echo -e "${YELLOW}请尝试运行: systemctl status docker 查看原因。${NC}"
                    fi
                else
                    rm get-docker.sh
                    echo -e "${RED}Docker 更新失败，请检查网络或系统日志。${NC}"
                    read -p "按任意键继续..."
                    return
                fi
                ;;
            0)
                return
                ;;
            *)
                echo -e "${RED}无效的选择，请重新输入！${NC}"
                sleep 2
                return
                ;;
        esac
    else
        echo -e "${YELLOW}检测到 Docker 未安装。${NC}"
        echo -e " ${GREEN}1.${NC} 安装 Docker"
        echo -e " ${RED}0.${NC} 返回上级菜单"
        read -p "请输入你的选择(0-1): " docker_install_choice
        case "$docker_install_choice" in
            1)
                echo -e "${BLUE}开始安装 Docker...${NC}"
                curl -fsSL https://get.docker.com -o get-docker.sh
                if sh get-docker.sh; then
                    rm get-docker.sh
                    
                    echo -e "${BLUE}正在启动 Docker 服务...${NC}"
                    systemctl start docker
                    systemctl enable docker
                    
                    if systemctl is-active --quiet docker; then
                        usermod -aG docker $USER
                        echo -e "${GREEN}Docker 安装并启动成功。${NC}"
                    else
                        echo -e "${RED}Docker 安装脚本执行成功，但服务启动失败。${NC}"
                        echo -e "${YELLOW}常见原因: 内核版本过低、缺少依赖或存储驱动问题。${NC}"
                        echo -e "${YELLOW}请运行: journalctl -u docker -n 20 查看错误日志。${NC}"
                        read -p "按任意键继续..."
                        return
                    fi
                else
                    rm get-docker.sh
                    echo -e "${RED}Docker 安装失败，请检查网络或系统日志。${NC}"
                    read -p "按任意键继续..."
                    return
                fi
                ;;
            0)
                return
                ;;
            *)
                echo -e "${RED}无效的选择，请重新输入！${NC}"
                sleep 2
                return
                ;;
        esac
    fi

    # 检查并安装 Docker Compose
    if ! docker compose version >/dev/null 2>&1; then
        echo -e "${YELLOW}未检测到 Docker Compose V2，正在安装...${NC}"
        DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
        mkdir -p $DOCKER_CONFIG/cli-plugins
        curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
        chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
        echo -e "${GREEN}Docker Compose 安装完成。${NC}"
    else
        echo -e "${GREEN}Docker Compose 已安装。${NC}"
    fi

    if systemctl is-active --quiet docker; then
        echo -e "${GREEN}Docker 及 Docker Compose 环境已准备就绪。${NC}"
    else
        echo -e "${RED}Docker 环境配置存在异常，服务未正常启动。${NC}"
        echo -e "${YELLOW}提示: 如果报错涉及 'iptables' 或 'nft', 请尝试运行菜单中的 'Docker 启动故障修复'。${NC}"
    fi
    read -p "按任意键继续..."
}

# 修复 Docker 启动时的 iptables/nft 冲突问题
function fix_docker_iptables() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}         Docker 启动故障深度修复${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${YELLOW}正在执行深度诊断与修复...${NC}"
    echo ""
    
    # 1. 加载必要的内核模块
    echo -e "${BLUE}[1/3] 正在加载内核模块 (overlay, br_netfilter)...${NC}"
    modprobe overlay
    modprobe br_netfilter
    
    # 永久写入模块配置
    cat <<EOF | tee /etc/modules-load.d/docker.conf > /dev/null
overlay
br_netfilter
EOF

    # 2. 优化系统网络参数
    echo -e "${BLUE}[2/3] 正在优化内核网络参数...${NC}"
    cat <<EOF | tee /etc/sysctl.d/docker.conf > /dev/null
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
    sysctl --system >/dev/null 2>&1

    # 3. 强制切换 iptables 模式
    echo -e "${BLUE}[3/3] 正在强制切换 iptables 至 legacy 模式...${NC}"
    if command -v update-alternatives >/dev/null 2>&1; then
        update-alternatives --set iptables /usr/sbin/iptables-legacy >/dev/null 2>&1
        update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy >/dev/null 2>&1
    else
        echo -e "${YELLOW}警告: 找不到 update-alternatives，尝试手动软链接...${NC}"
        ln -sf /usr/sbin/iptables-legacy /usr/sbin/iptables
        ln -sf /usr/sbin/ip6tables-legacy /usr/sbin/ip6tables
    fi
    
    echo -e "${BLUE}正在清理残留规则并重启 Docker...${NC}"
    systemctl stop docker >/dev/null 2>&1
  systemctl restart docker
    
    if systemctl is-active --quiet docker; then
        echo -e "${GREEN}修复成功！Docker 服务已正常运行。${NC}"
    else
        echo -e "${RED}修复失败。Docker 仍无法启动。${NC}"
        echo -e "${YELLOW}最后尝试: 请检查是否安装了过期的防火墙插件，或尝试重启服务器。${NC}"
    fi
    echo -e "${CYAN}=========================================${NC}"
    read -p "按任意键继续..."
}


function view_docker_global_status() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        查看 Docker 全局状态${NC}"
    echo -e "${CYAN}=========================================${NC}"

    if ! systemctl is-active --quiet docker; then
        echo -e "${RED}错误: Docker 服务未运行。请先启动 Docker 服务。${NC}"
        read -p "按任意键继续..."
        return
    fi

    echo -e "${BLUE}Docker 状态: 运行中${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}Docker 概况:${NC}"
    if command -v jq >/dev/null 2>&1; then
        docker info --format '{{json .}}' | jq -r '"版本: \(.ServerVersion)\n内核版本: \(.KernelVersion)\n操作系统: \(.OperatingSystem)\n架构: \(.Architecture)\nCPU: \(.NCPU)\n内存: \((.MemTotal / 1024 / 1024 / 1024 * 100 | round / 100)) GB"'
    else
        docker info | grep -E "Server Version|Kernel Version|Operating System|Architecture|CPUs|Total Memory"
    fi
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${YELLOW}统计信息:${NC}"
    echo "  正在运行的容器: $(docker ps -q | wc -l)"
    echo "  所有容器: $(docker ps -aq | wc -l)"
    echo "  镜像数量: $(docker images -q | wc -l)"
    echo "  网络数量: $(docker network ls -q | wc -l)"
    echo "  卷数量: $(docker volume ls -q | wc -l)"
    echo -e "${CYAN}-----------------------------------------${NC}"
    read -p "按任意键继续..."
}


function docker_container_management() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}错误: 未检测到 Docker，请先安装 Docker。${NC}"
        read -p "按任意键继续..."
        return
    fi
    while true; do
        clear
        echo -e "${CYAN}================================================${NC}"
        echo -e "               ${GREEN}Docker 容器管理${NC}"
        echo -e "${CYAN}================================================${NC}"
        
        # 获取容器列表并存入数组
        local containers=()
        local i=1
        
        # 格式化输出容器列表
        printf "${YELLOW}%-5s %-12s %-20s %-15s %-20s${NC}\n" "序号" "容器ID" "名称" "状态" "端口映射"
        echo -e "${CYAN}------------------------------------------------${NC}"
        
        while read -r line; do
            if [ -n "$line" ]; then
                containers+=("$line")
                local id=$(echo "$line" | awk '{print $1}')
                local name=$(echo "$line" | awk '{print $2}')
                local status=$(echo "$line" | awk '{print $3}')
                local ports=$(echo "$line" | awk -F'|' '{print $2}')
                
                local status_color="${NC}"
                [[ "$status" == "Up" ]] && status_color="${GREEN}" || status_color="${RED}"
                
                printf "[%2d]  %-12s %-20s ${status_color}%-15s${NC} %-20s\n" "$i" "$id" "$name" "$status" "$ports"
                ((i++))
            fi
        done < <(docker ps -a --format "{{.ID}} {{.Names}} {{.Status}} |{{.Ports}}" | sed 's/About //g; s/ago//g')

        if [ ${#containers[@]} -eq 0 ]; then
            echo -e "${YELLOW}当前没有容器${NC}"
        fi

        echo -e "${CYAN}------------------------------------------------${NC}"
        echo -e " ${GREEN}1.${NC} 启动    ${GREEN}2.${NC} 停止    ${GREEN}3.${NC} 重启    ${GREEN}4.${NC} 删除"
        echo -e " ${GREEN}5.${NC} 日志    ${GREEN}6.${NC} 终端    ${GREEN}7.${NC} 详情    ${GREEN}8.${NC} 创建"
        echo -e " ${GREEN}9.${NC} 批量操作 (启动/停止/删除)"
        echo -e " ${RED}0.${NC} 返回"
        echo -e "${CYAN}================================================${NC}"
        read -p "请选择操作 [1-9]: " op_choice
        [[ "$op_choice" == "0" ]] && break
        [[ "$op_choice" == "8" ]] && { create_new_container; continue; }

        if [ ${#containers[@]} -eq 0 ] && [[ "$op_choice" =~ ^[12345679]$ ]]; then
            echo -e "${RED}没有可操作的容器！${NC}"; sleep 1; continue
        fi

        if [[ "$op_choice" == "9" ]]; then
            read -p "请输入操作 (start/stop/rm): " batch_op
            read -p "请输入序号 (如 1 2 3 或 all): " idx_list
            local target_ids=""
            if [[ "$idx_list" == "all" ]]; then
                target_ids=$(docker ps -aq)
            else
                for idx in $idx_list; do
                    local real_idx=$((idx-1))
                    if [ -n "${containers[$real_idx]}" ]; then
                        target_ids+="$(echo "${containers[$real_idx]}" | awk '{print $1}') "
                    fi
                done
            fi
            if [ -n "$target_ids" ]; then
                echo -e "${BLUE}正在执行批量操作 $batch_op...${NC}"
                docker $batch_op $target_ids
                echo -e "${GREEN}操作完成！${NC}"; sleep 1
            fi
            continue
        fi

        read -p "请输入容器序号: " container_idx
        local real_idx=$((container_idx-1))
        if [ -z "${containers[$real_idx]}" ]; then
            echo -e "${RED}无效的序号！${NC}"; sleep 1; continue
        fi
        
        local target_id=$(echo "${containers[$real_idx]}" | awk '{print $1}')
        local target_name=$(echo "${containers[$real_idx]}" | awk '{print $2}')

        case $op_choice in
            1) docker start "$target_id" && echo -e "${GREEN}$target_name 已启动${NC}" ;;
            2) docker stop "$target_id" && echo -e "${GREEN}$target_name 已停止${NC}" ;;
            3) docker restart "$target_id" && echo -e "${GREEN}$target_name 已重启${NC}" ;;
            4) 
                read -p "确定要删除容器 $target_name 吗? (y/N): " confirm
                [[ "$confirm" =~ ^[Yy]$ ]] && docker rm -f "$target_id" && echo -e "${GREEN}$target_name 已删除${NC}"
                ;;
            5) docker logs --tail 100 -f "$target_id" ;;
            6) docker exec -it "$target_id" /bin/bash || docker exec -it "$target_id" /bin/sh || docker exec -it "$target_id" sh ;;
            7) docker inspect "$target_id" | less ;;
            *) echo -e "${RED}无效操作！${NC}" ;;
        esac
        [[ "$op_choice" != "5" && "$op_choice" != "6" && "$op_choice" != "7" ]] && sleep 1
    done
}

# 创建新容器
function create_new_container() {
    clear
    echo -e "${CYAN}================================================${NC}"
    echo -e "               ${GREEN}创建新容器${NC}"
    echo -e "${CYAN}================================================${NC}"
    
    read -p "请输入容器名称: " name
    read -p "请输入镜像名称 (如 nginx:latest): " image
    read -p "请输入端口映射 (如 8080:80, 留空跳过): " ports
    read -p "请输入挂载卷 (如 /host/path:/container/path, 留空跳过): " volumes
    read -p "请输入环境变量 (如 KEY=VALUE, 多个用空格, 留空跳过): " envs
    read -p "是否后台运行? (Y/n): " detach
    
    local cmd="docker run"
    [[ ! "$detach" =~ ^[Nn]$ ]] && cmd+=" -d"
    [[ -n "$name" ]] && cmd+=" --name $name"
    [[ -n "$ports" ]] && cmd+=" -p $ports"
    [[ -n "$volumes" ]] && cmd+=" -v $volumes"
    if [[ -n "$envs" ]]; then
        for e in $envs; do
            cmd+=" -e $e"
        done
    fi
    cmd+=" $image"
    
    echo -e "${BLUE}执行命令: $cmd${NC}"
    eval $cmd
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}容器创建成功！${NC}"
    else
        echo -e "${RED}容器创建失败！${NC}"
    fi
    read -p "按任意键继续..."
}

function docker_image_management() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}错误: 未检测到 Docker，请先安装 Docker。${NC}"
        read -p "按任意键继续..."
        return
    fi
    while true; do
        clear
        echo -e "${CYAN}================================================${NC}"
        echo -e "               ${GREEN}Docker 镜像管理${NC}"
        echo -e "${CYAN}================================================${NC}"
        
        # 获取镜像列表
        local images=()
        local i=1
        
        printf "${YELLOW}%-5s %-30s %-15s %-10s${NC}\n" "序号" "镜像仓库:标签" "镜像ID" "占用大小"
        echo -e "${CYAN}------------------------------------------------${NC}"
        
        while read -r line; do
            if [ -n "$line" ]; then
                images+=("$line")
                local repo=$(echo "$line" | awk '{print $1}')
                local tag=$(echo "$line" | awk '{print $2}')
                local id=$(echo "$line" | awk '{print $3}')
                local size=$(echo "$line" | awk '{print $4}')
                
                printf "[%2d]  %-30s %-15s %-10s\n" "$i" "$repo:$tag" "$id" "$size"
                ((i++))
            fi
        done < <(docker images --format "{{.Repository}} {{.Tag}} {{.ID}} {{.Size}}")

        if [ ${#images[@]} -eq 0 ]; then
            echo -e "${YELLOW}当前没有本地镜像${NC}"
        fi

        echo -e "${CYAN}------------------------------------------------${NC}"
        echo -e " ${GREEN}1.${NC} 拉取镜像  ${GREEN}2.${NC} 删除镜像  ${GREEN}3.${NC} 清理悬空  ${GREEN}4.${NC} 清空所有"
        echo -e " ${RED}0.${NC} 返回"
        echo -e "${CYAN}================================================${NC}"
        read -p "请选择操作 [0-4]: " img_choice
        [[ "$img_choice" == "0" ]] && break

        case $img_choice in
            1)
                read -p "请输入镜像名称 (如 nginx:latest): " img_name
                if [ -n "$img_name" ]; then
                    echo -e "${BLUE}正在拉取镜像 $img_name...${NC}"
                    docker pull "$img_name"
                fi
                ;;
            2)
                if [ ${#images[@]} -eq 0 ]; then
                    echo -e "${RED}没有可删除的镜像！${NC}"; sleep 1; continue
                fi
                read -p "请输入要删除的镜像序号 (支持多个, 如 1 2): " idx_list
                for idx in $idx_list; do
                    local real_idx=$((idx-1))
                    if [ -n "${images[$real_idx]}" ]; then
                        local target_id=$(echo "${images[$real_idx]}" | awk '{print $3}')
                        docker rmi -f "$target_id" && echo -e "${GREEN}序号 $idx 已删除${NC}"
                    fi
                done
                ;;
            3)
                echo -e "${BLUE}正在清理悬空镜像...${NC}"
                docker image prune -f
                ;;
            4)
                read -p "确定要清空所有镜像吗？(y/N): " confirm
                if [[ "$confirm" =~ ^[Yy]$ ]]; then
                    echo -e "${BLUE}正在清空所有镜像...${NC}"
                    docker rmi $(docker images -q) -f
                fi
                ;;
            *) echo -e "${RED}无效操作！${NC}" ;;
        esac
        sleep 1
    done
}















function docker_network_management() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}错误: 未检测到 Docker，请先安装 Docker。${NC}"
        read -p "按任意键继续..."
        return
    fi
    while true; do
        clear
        echo -e "${CYAN}================================================${NC}"
        echo -e "               ${GREEN}Docker 网络管理${NC}"
        echo -e "${CYAN}================================================${NC}"

        local networks=()
        local i=1
        printf "${YELLOW}%-5s %-25s %-15s %-10s${NC}\n" "序号" "网络名称" "驱动" "范围"
        echo -e "${CYAN}------------------------------------------------${NC}"

        while read -r line; do
            if [ -n "$line" ]; then
                networks+=("$line")
                local name=$(echo "$line" | awk '{print $1}')
                local driver=$(echo "$line" | awk '{print $2}')
                local scope=$(echo "$line" | awk '{print $3}')
                
                printf "[%2d]  %-25s %-15s %-10s\n" "$i" "$name" "$driver" "$scope"
                ((i++))
            fi
        done < <(docker network ls --format "{{.Name}} {{.Driver}} {{.Scope}}")

        if [ ${#networks[@]} -eq 0 ]; then
            echo -e "${YELLOW}当前没有自定义网络${NC}"
        fi

        echo -e "${CYAN}------------------------------------------------${NC}"
        echo -e " ${GREEN}1.${NC} 创建网络    ${GREEN}2.${NC} 删除网络    ${GREEN}3.${NC} 查看详情"
        echo -e " ${GREEN}4.${NC} 批量删除"
        echo -e " ${RED}0.${NC} 返回"
        echo -e "${CYAN}================================================${NC}"
        read -p "请选择操作 [0-4]: " net_choice
        [[ "$net_choice" == "0" ]] && break
        
        case $net_choice in
            1)
                read -p "请输入网络名称: " net_name
                if [ -n "$net_name" ]; then
                    docker network create "$net_name" && echo -e "${GREEN}网络 $net_name 创建成功${NC}"
                fi
                ;;
            2)
                read -p "请输入要删除的网络序号: " idx
                local real_idx=$((idx-1))
                if [ -n "${networks[$real_idx]}" ]; then
                    local target_name=$(echo "${networks[$real_idx]}" | awk '{print $1}')
                    docker network rm "$target_name" && echo -e "${GREEN}网络 $target_name 已删除${NC}"
                fi
                ;;
            3)
                read -p "请输入序号: " idx
                local real_idx=$((idx-1))
                if [ -n "${networks[$real_idx]}" ]; then
                    local target_name=$(echo "${networks[$real_idx]}" | awk '{print $1}')
                    docker network inspect "$target_name" | less
                fi
                ;;
            4)
                read -p "请输入要批量删除的网络序号 (如 1 2 3): " idx_list
                for idx in $idx_list; do
                    local real_idx=$((idx-1))
                    if [ -n "${networks[$real_idx]}" ]; then
                        local target_name=$(echo "${networks[$real_idx]}" | awk '{print $1}')
                        docker network rm "$target_name" && echo -e "${GREEN}网络 $target_name 已删除${NC}"
                    fi
                done
                ;;
            *) echo -e "${RED}无效选择！${NC}" ;;
        esac
        [[ "$net_choice" != "3" ]] && sleep 1
    done
}

function docker_volume_management() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}错误: 未检测到 Docker，请先安装 Docker。${NC}"
        read -p "按任意键继续..."
        return
    fi
    while true; do
        clear
        echo -e "${CYAN}================================================${NC}"
        echo -e "               ${GREEN}Docker 数据卷管理${NC}"
        echo -e "${CYAN}================================================${NC}"

        local volumes=()
        local i=1
        printf "${YELLOW}%-5s %-35s %-15s${NC}\n" "序号" "数据卷名称" "驱动"
        echo -e "${CYAN}------------------------------------------------${NC}"

        while read -r line; do
            if [ -n "$line" ]; then
                volumes+=("$line")
                local name=$(echo "$line" | awk '{print $1}')
                local driver=$(echo "$line" | awk '{print $2}')
                
                printf "[%2d]  %-35s %-15s\n" "$i" "$name" "$driver"
                ((i++))
            fi
        done < <(docker volume ls --format "{{.Name}} {{.Driver}}")

        if [ ${#volumes[@]} -eq 0 ]; then
            echo -e "${YELLOW}当前没有数据卷${NC}"
        fi

        echo -e "${CYAN}------------------------------------------------${NC}"
        echo -e " ${GREEN}1.${NC} 创建数据卷  ${GREEN}2.${NC} 删除数据卷  ${GREEN}3.${NC} 查看详情"
        echo -e " ${GREEN}4.${NC} 批量删除"
        echo -e " ${RED}0.${NC} 返回"
        echo -e "${CYAN}================================================${NC}"
        read -p "请选择操作 [0-4]: " vol_choice
        [[ "$vol_choice" == "0" ]] && break
        
        case $vol_choice in
            1)
                read -p "请输入数据卷名称: " vol_name
                if [ -n "$vol_name" ]; then
                    docker volume create "$vol_name" && echo -e "${GREEN}数据卷 $vol_name 创建成功${NC}"
                fi
                ;;
            2)
                read -p "请输入要删除的数据卷序号: " idx
                local real_idx=$((idx-1))
                if [ -n "${volumes[$real_idx]}" ]; then
                    local target_name=$(echo "${volumes[$real_idx]}" | awk '{print $1}')
                    docker volume rm "$target_name" && echo -e "${GREEN}数据卷 $target_name 已删除${NC}"
                fi
                ;;
            3)
                read -p "请输入序号: " idx
                local real_idx=$((idx-1))
                if [ -n "${volumes[$real_idx]}" ]; then
                    local target_name=$(echo "${volumes[$real_idx]}" | awk '{print $1}')
                    docker volume inspect "$target_name" | less
                fi
                ;;
            4)
                read -p "请输入要批量删除的数据卷序号 (如 1 2 3): " idx_list
                for idx in $idx_list; do
                    local real_idx=$((idx-1))
                    if [ -n "${volumes[$real_idx]}" ]; then
                        local target_name=$(echo "${volumes[$real_idx]}" | awk '{print $1}')
                        docker volume rm "$target_name" && echo -e "${GREEN}数据卷 $target_name 已删除${NC}"
                    fi
                done
                ;;
            *) echo -e "${RED}无效选择！${NC}" ;;
        esac
        [[ "$vol_choice" != "3" ]] && sleep 1
    done
}



function clean_docker_resources() {
    clear
    echo -e "${CYAN}================================================${NC}"
    echo -e "               ${GREEN}Docker 系统深度清理${NC}"
    echo -e "${CYAN}================================================${NC}"
    echo -e "${YELLOW}此操作将永久删除以下资源:${NC}"
    echo -e " 1. 所有已停止的容器 (Stopped Containers)"
    echo -e " 2. 所有未使用的网络 (Unused Networks)"
    echo -e " 3. 所有悬空镜像 (Dangling Images)"
    echo -e " 4. 所有未使用的构建缓存 (Build Cache)"
    echo -e " 5. ${RED}所有未使用的本地卷 (Unused Volumes)${NC}"
    echo ""
    echo -e "${BOLD}注意: 正在运行的容器所使用的资源不会被删除。${NC}"
    echo -e "${CYAN}------------------------------------------------${NC}"
    read -p "确定要执行深度清理吗？(y/N): " confirm_prune
    if [[ "$confirm_prune" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}正在执行清理中，请稍候...${NC}"
        # 使用 docker system prune 并清理 volumes
        local result=$(docker system prune --volumes -f 2>&1)
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Docker 资源清理完成！${NC}"
            # 提取释放的空间信息
            local space=$(echo "$result" | grep "Total reclaimed space" | awk -F': ' '{print $2}')
            [ -n "$space" ] && echo -e "${CYAN}本次清理共释放空间: ${GREEN}$space${NC}"
        else
            echo -e "${RED}Docker 资源清理过程中出现错误。${NC}"
            echo -e "${RED}错误详情: $result${NC}"
        fi
    else
        echo -e "${YELLOW}已取消清理操作。${NC}"
    fi
    echo -e "${CYAN}================================================${NC}"
    read -p "按任意键继续..."
}

function change_docker_source() {
    clear
    echo "========================================="
    echo "          更换 Docker 源"
    echo "========================================="
    echo "正在执行更换 Docker 源脚本..."
    bash <(curl -sSL https://linuxmirrors.cn/main.sh)
    if [ $? -eq 0 ]; then
        echo "Docker 源更换脚本执行成功。"
    else
        echo "Docker 源更换脚本执行失败。"
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function edit_daemon_json() {
    clear
    echo "========================================="
    echo "        编辑 Docker daemon.json"
    echo "========================================="
    echo "daemon.json 文件通常位于 /etc/docker/daemon.json"
    echo "如果文件不存在，将为您创建。"
    echo ""

    DAEMON_FILE="/etc/docker/daemon.json"

    if [ ! -f "$DAEMON_FILE" ]; then
        echo "daemon.json 文件不存在，正在创建..."
        mkdir -p $(dirname "$DAEMON_FILE")
        touch "$DAEMON_FILE"
        echo "{}" | tee "$DAEMON_FILE" > /dev/null
        if [ $? -eq 0 ]; then
            echo "daemon.json 文件创建成功。"
        else
            echo "创建 daemon.json 文件失败。"
            read -p "按任意键继续..."
            return
        fi
    fi

    echo "正在使用 nano 编辑器打开 daemon.json 文件..."
    echo "编辑完成后，请按 Ctrl+X，然后按 Y 保存，最后按 Enter 退出。"
    echo ""
    nano "$DAEMON_FILE"

    if [ $? -eq 0 ]; then
        echo "daemon.json 文件编辑完成。建议重启 Docker 服务以应用更改。"
        echo "您可以使用 'systemctl restart docker' 命令重启 Docker 服务。"
    else
        echo "编辑 daemon.json 文件失败或被取消。"
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function enable_docker_ipv6() {
    clear
    echo "========================================="
    echo "        开启 Docker IPv6 访问"
    echo "========================================="

    DAEMON_FILE="/etc/docker/daemon.json"

    # 检查 jq 是否安装
    if ! command -v jq >/dev/null 2>&1; then
        echo "错误: jq 未安装。请先安装 jq (例如: sudo apt install jq 或 sudo yum install jq)。"
        read -p "按任意键继续..."
        return
    fi

    # 确保 daemon.json 文件存在
    if [ ! -f "$DAEMON_FILE" ]; then
        echo "daemon.json 文件不存在，正在创建..."
       mkdir -p $(dirname "$DAEMON_FILE")
    echo "{}" | tee "$DAEMON_FILE" > /dev/null
        if [ $? -ne 0 ]; then
            echo "创建 daemon.json 文件失败。"
            read -p "按任意键继续..."
            return
        fi
    fi

    echo "正在配置 daemon.json 以启用 IPv6..."
    # 使用 jq 更新 daemon.json 文件
    IPV6_CONFIG='{"fixed_cidr_v6": "2001:db8:1::/64"}' # Default IPv6 CIDR
    jq --argjson ipv6_config "$IPV6_CONFIG" '. + {ipv6: true, fixed-cidr-v6: $ipv6_config.fixed_cidr_v6, enable-ipv6: true}' "$DAEMON_FILE" > /tmp/daemon.json.tmp
    mv /tmp/daemon.json.tmp "$DAEMON_FILE"

    if [ $? -eq 0 ]; then
        echo "daemon.json 文件已更新，IPv6 已启用。"
        echo "正在重启 Docker 服务以应用更改..."
        systemctl restart docker
        if [ $? -eq 0 ]; then
            echo "Docker 服务重启成功。IPv6 访问已开启。"
        else
            echo "Docker 服务重启失败。请手动检查 Docker 状态。"
        fi
    else
        echo "更新 daemon.json 文件失败。"
    fi

    echo "========================================="
    read -p "按任意键继续..."
}

function disable_docker_ipv6() {
    clear
    echo "========================================="
    echo "        关闭 Docker IPv6 访问"
    echo "========================================="

    DAEMON_FILE="/etc/docker/daemon.json"

    # 检查 jq 是否安装
    if ! command -v jq >/dev/null 2>&1; then
        echo "错误: jq 未安装。请先安装 jq (例如: sudo apt install jq 或 sudo yum install jq)。"
        read -p "按任意键继续..."
        return
    fi

    # 确保 daemon.json 文件存在
    if [ ! -f "$DAEMON_FILE" ]; then
        echo "daemon.json 文件不存在，无需关闭 IPv6。"
        read -p "按任意键继续..."
        return
    fi

    echo "正在配置 daemon.json 以禁用 IPv6..."
    # 使用 jq 更新 daemon.json 文件，移除 ipv6 和 fixed-cidr-v6 配置
    jq 'del(.ipv6) | del(."fixed-cidr-v6") | del(."enable-ipv6")' "$DAEMON_FILE" > /tmp/daemon.json.tmp
    mv /tmp/daemon.json.tmp "$DAEMON_FILE"

    if [ $? -eq 0 ]; then
        echo "daemon.json 文件已更新，IPv6 已禁用。"
        echo "正在重启 Docker 服务以应用更改..."
        systemctl restart docker
        if [ $? -eq 0 ]; then
            echo "Docker 服务重启成功。IPv6 访问已关闭。"
        else
            echo "Docker 服务重启失败。请手动检查 Docker 状态。"
        fi
    else
        echo "更新 daemon.json 文件失败。"
    fi

    echo "========================================="
    read -p "按任意键继续..."
}

function backup_migrate_restore_docker() {
    while true; do
        clear
        echo -e "${CYAN}================================================${NC}"
        echo -e "         ${GREEN}Docker 备份 / 迁移 / 还原${NC}"
        echo -e "${CYAN}================================================${NC}"
        echo -e "  ${GREEN}1.${NC} 备份 Docker 环境 (完整数据包)"
        echo -e "  ${GREEN}2.${NC} 还原 Docker 环境 (从备份包)"
        echo -e "  ${GREEN}3.${NC} 迁移 Docker 环境 (待开发)"
        echo -e "${CYAN}------------------------------------------------${NC}"
        echo -e "  ${RED}0.${NC} 返回主菜单"
        echo -e "${CYAN}================================================${NC}"
        read -p "请选择操作 [0-3]: " choice

        case $choice in
            1) backup_docker_env ;;
            2) restore_docker_env ;;
            3) echo -e "${YELLOW}迁移功能目前尚在开发中...${NC}"; sleep 2 ;;
            0) break ;;
            *) echo -e "${RED}无效选择！${NC}"; sleep 1 ;;
        esac
    done
}

function backup_docker_env() {
    clear
    echo -e "${CYAN}================================================${NC}"
    echo -e "               ${GREEN}备份 Docker 环境${NC}"
    echo -e "${CYAN}================================================${NC}"
    echo -e "${YELLOW}注意: 该操作将备份 /var/lib/docker 目录，可能耗时较长。${NC}"
    echo -e "${YELLOW}建议先停止所有运行中的容器以保证数据一致性。${NC}"
    echo -e "${CYAN}------------------------------------------------${NC}"
    
    local default_name="docker_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    read -p "请输入备份文件名 [默认: $default_name]: " backup_file
    [ -z "$backup_file" ] && backup_file="$default_name"

    read -p "请输入备份保存路径 [默认: 当前目录]: " backup_path
    [ -z "$backup_path" ] && backup_path="."

    mkdir -p "$backup_path"
    
    echo -e "${BLUE}正在停止 Docker 服务以进行备份...${NC}"
    systemctl stop docker
    
    echo -e "${BLUE}正在打包 Docker 数据，请耐心等待...${NC}"
    if tar -czvf "$backup_path/$backup_file" /var/lib/docker >/dev/null 2>&1; then
        echo -e "${GREEN}备份成功！${NC}"
        echo -e "${CYAN}备份文件已保存至: ${YELLOW}$backup_path/$backup_file${NC}"
        echo -e "${CYAN}文件大小: ${GREEN}$(du -h "$backup_path/$backup_file" | awk '{print $1}')${NC}"
    else
        echo -e "${RED}备份失败！请检查磁盘空间或权限。${NC}"
    fi
    
    echo -e "${BLUE}正在重新启动 Docker 服务...${NC}"
    systemctl start docker
    
    echo -e "${CYAN}================================================${NC}"
    read -p "按任意键继续..."
}

function restore_docker_env() {
    clear
    echo -e "${CYAN}================================================${NC}"
    echo -e "               ${GREEN}还原 Docker 环境${NC}"
    echo -e "${CYAN}================================================${NC}"
    echo -e "${RED}警告: 还原操作将覆盖当前所有 Docker 数据！${NC}"
    echo -e "${RED}请务必确认您已备份当前数据。${NC}"
    echo -e "${CYAN}------------------------------------------------${NC}"
    
    read -p "请输入备份文件的完整路径: " backup_full_path
    if [ ! -f "$backup_full_path" ]; then
        echo -e "${RED}错误: 文件 $backup_full_path 不存在！${NC}"
        read -p "按任意键继续..."
        return
    fi

    read -p "确定要开始还原吗？此操作不可逆！(y/N): " confirm_restore
    if [[ "$confirm_restore" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}正在停止 Docker 服务...${NC}"
        systemctl stop docker
        
        echo -e "${BLUE}正在清理旧数据...${NC}"
        rm -rf /var/lib/docker/*
        
        echo -e "${BLUE}正在解压备份文件...${NC}"
        if tar -xzvf "$backup_full_path" -C / >/dev/null 2>&1; then
            echo -e "${GREEN}还原成功！${NC}"
        else
            echo -e "${RED}还原失败！请检查备份文件是否损坏。${NC}"
        fi
        
        echo -e "${BLUE}正在重新启动 Docker 服务...${NC}"
        systemctl start docker
    else
        echo -e "${YELLOW}已取消还原操作。${NC}"
    fi
    
    echo -e "${CYAN}================================================${NC}"
    read -p "按任意键继续..."
}

function uninstall_docker() {
    clear
    echo -e "${CYAN}================================================${NC}"
    echo -e "               ${RED}${BOLD}卸载 Docker 环境${NC}"
    echo -e "${CYAN}================================================${NC}"
    echo -e "${RED}警告: 这将彻底卸载 Docker 及其所有相关组件！${NC}"
    echo -e "包括: ${YELLOW}所有容器、镜像、网络、数据卷以及配置文件${NC}"
    echo -e "${CYAN}------------------------------------------------${NC}"
    read -p "危险操作！确定要继续吗？(y/N): " confirm_uninstall
    if [[ "$confirm_uninstall" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}[1/7] 正在停止并删除所有容器...${NC}"
        docker ps -aq | xargs -r docker stop >/dev/null 2>&1
        docker ps -aq | xargs -r docker rm >/dev/null 2>&1

        echo -e "${BLUE}[2/7] 正在删除所有镜像...${NC}"
        docker images -aq | xargs -r docker rmi -f >/dev/null 2>&1

        echo -e "${BLUE}[3/7] 正在删除所有网络和数据卷...${NC}"
        docker network ls -q | xargs -r docker network rm >/dev/null 2>&1
        docker volume ls -q | xargs -r docker volume rm >/dev/null 2>&1

        echo -e "${BLUE}[4/7] 正在停止并禁用 Docker 服务...${NC}"
        systemctl stop docker >/dev/null 2>&1
        systemctl disable docker >/dev/null 2>&1

        echo -e "${BLUE}[5/7] 正在卸载 Docker 软件包...${NC}"
        if command -v apt >/dev/null 2>&1; then
            apt purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >/dev/null 2>&1
            apt autoremove -y >/dev/null 2>&1
        elif command -v yum >/dev/null 2>&1; then
            yum remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >/dev/null 2>&1
            yum autoremove -y >/dev/null 2>&1
        elif command -v dnf >/dev/null 2>&1; then
            dnf remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >/dev/null 2>&1
            dnf autoremove -y >/dev/null 2>&1
        fi

        echo -e "${BLUE}[6/7] 正在清理残留文件和目录...${NC}"
        rm -rf /var/lib/docker
        rm -rf /etc/docker
        rm -rf /var/run/docker.sock
        rm -rf /usr/local/bin/docker-compose

        echo -e "${BLUE}[7/7] 最终检查...${NC}"
        if ! command -v docker &> /dev/null; then
            echo -e "${GREEN}Docker 环境已成功彻底卸载！${NC}"
        else
            echo -e "${YELLOW}卸载完成，但检测到部分残留，请手动检查。${NC}"
        fi
    else
        echo -e "${YELLOW}已取消卸载操作。${NC}"
    fi
    echo -e "${CYAN}================================================${NC}"
    read -p "按任意键继续..."
}

function docker_ipv6_management() {
    while true; do
        clear
        echo -e "${CYAN}================================================${NC}"
        echo -e "               ${GREEN}Docker IPv6 访问控制${NC}"
        echo -e "${CYAN}================================================${NC}"
        echo -e "  ${GREEN}1.${NC} 开启 Docker IPv6 访问"
        echo -e "  ${GREEN}2.${NC} 关闭 Docker IPv6 访问"
        echo -e "  ${CYAN}------------------------------------------------${NC}"
        echo -e "  ${RED}0.${NC} 返回"
        echo -e "${CYAN}================================================${NC}"
        read -p "请选择操作 [0-2]: " ipv6_choice
        
        case "$ipv6_choice" in
            1) enable_docker_ipv6 ;;
            2) disable_docker_ipv6 ;;
            0) break ;;
            *) echo -e "${RED}无效选择！${NC}"; sleep 1 ;;
        esac
    done
}

# Docker 管理菜单
function docker_menu() {
    while true; do
        clear
        # 调用状态检查显示顶部简报
        check_docker_status
        
        echo -e "  ${CYAN}[ 基础维护 ]${NC}"
        echo -e "  ${GREEN}1.${NC}  安装/更新 Docker 环境     ${GREEN}2.${NC}  查看 Docker 全局状态"
        echo -e "  ${GREEN}3.${NC}  更换 Docker 国内镜像源    ${GREEN}4.${NC}  Docker 启动故障修复"
        echo ""
        echo -e "  ${CYAN}[ 资源管理 ]${NC}"
        echo -e "  ${GREEN}5.${NC}  容器管理 (交互式)         ${GREEN}6.${NC}  镜像管理 (交互式)"
        echo -e "  ${GREEN}7.${NC}  网络管理 (交互式)         ${GREEN}8.${NC}  数据卷管理 (交互式)"
        echo ""
        echo -e "  ${CYAN}[ 高级配置 ]${NC}"
        echo -e "  ${GREEN}9.${NC}  编辑 daemon.json          ${GREEN}10.${NC} IPv6 访问控制"
        echo -e "  ${GREEN}11.${NC} 备份/迁移/还原            ${GREEN}12.${NC} 系统一键深度清理"
        echo ""
        echo -e "  ${CYAN}[ 系统操作 ]${NC}"
        echo -e "  ${RED}20.${NC} 彻底卸载 Docker 环境      ${RED}0.${NC} 返回主菜单"
        echo -e "${CYAN}================================================${NC}"
        read -p "请输入操作代码: " docker_choice

        case "$docker_choice" in
            1) install_update_docker_env ;;
            2) view_docker_global_status ;;
            3) change_docker_source ;;
            4) fix_docker_iptables ;;
            5) docker_container_management ;;
            6) docker_image_management ;;
            7) docker_network_management ;;
            8) docker_volume_management ;;
            9) edit_daemon_json ;;
            10) docker_ipv6_management ;;
            11) backup_migrate_restore_docker ;;
            12) clean_docker_resources ;;
            20) uninstall_docker ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; sleep 1 ;;
        esac
    done
}
