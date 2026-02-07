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

# 检查 Docker 安装状态并显示版本
function check_docker_status() {
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}         检查 Docker 安装状态${NC}"
    echo -e "${CYAN}=========================================${NC}"
    if command -v docker >/dev/null 2>&1; then
        echo -e " Docker ${GREEN}已安装${NC}。版本信息:"
        docker --version | awk '{print $3}' | sed 's/,//'
    else
        echo -e " Docker ${RED}未安装${NC}。"
    fi
    echo -e "${CYAN}=========================================${NC}"
}

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
                if sudo sh get-docker.sh; then
                    rm get-docker.sh
                    sudo systemctl start docker
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
                if sudo sh get-docker.sh; then
                    rm get-docker.sh
                    
                    echo -e "${BLUE}正在启动 Docker 服务...${NC}"
                    sudo systemctl start docker
                    sudo systemctl enable docker
                    
                    if systemctl is-active --quiet docker; then
                        sudo usermod -aG docker $USER
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
        echo -e "${RED}Docker 环境配置存在异常，请检查服务状态。${NC}"
    fi
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
    while true;
    do
        clear
        list_docker_containers
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          Docker 容器管理${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC} 创建新的容器"
        echo -e " ${GREEN}2.${NC} 启动指定容器"
        echo -e " ${GREEN}3.${NC} 停止指定容器"
        echo -e " ${GREEN}4.${NC} 删除指定容器"
        echo -e " ${GREEN}5.${NC} 重启指定容器"
        echo -e " ${GREEN}6.${NC} 启动所有容器"
        echo -e " ${GREEN}7.${NC} 停止所有容器"
        echo -e " ${GREEN}8.${NC} 删除所有容器"
        echo -e " ${GREEN}9.${NC} 重启所有容器"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${GREEN}11.${NC} 进入指定容器        ${GREEN}12.${NC} 查看容器日志"
        echo -e " ${GREEN}13.${NC} 查看容器网络        ${GREEN}14.${NC} 查看容器占用"
        echo -e " ${GREEN}15.${NC} 开启容器端口访问    ${GREEN}16.${NC} 关闭容器端口访问"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC} 返回上一级选单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择: " choice


        case $choice in
            1) create_new_container ;;
            2) start_specified_container ;;
            3) stop_specified_container ;;
            4) remove_specified_container ;;
            5) restart_specified_container ;;
            6) start_all_containers ;;
            7) stop_all_containers ;;
            8) remove_all_containers ;;
            9) restart_all_containers ;;
            11) enter_specified_container ;;
            12) view_container_logs ;;
            13) view_container_network ;;
            14) view_container_usage ;;
            15) enable_container_port_access ;;
            16) disable_container_port_access ;;
            0) break ;;
            *) echo "无效的选择，请重新输入！" ; read -p "按任意键继续..." ;;
        esac
    done
}

function list_docker_containers() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        列出所有 Docker 容器${NC}"
    echo -e "${CYAN}=========================================${NC}"
    # 格式化输出：指定字段并设置固定宽度，实现整齐对齐
    if ! command -v docker &> /dev/null; then
        return
    fi
    docker ps -a --format "ID: {{.ID}} | 名称: {{.Names}} | 镜像: {{.Image}} | 状态: {{.Status}} | 端口: {{.Ports}} | 创建时间: {{.CreatedAt}}" | 
    awk -F '|' -v green="${GREEN}" -v nc="${NC}" '{
        # 调整各字段对齐（根据实际需求修改数字调整宽度）
        printf "%s%-12s%s | %-20s | %-25s | %-20s | %-30s | %-25s\n", 
        green, $1, nc, $2, $3, $4, $5, $6
    }'
    echo -e "${CYAN}=========================================${NC}"
}


function create_new_container() {
    clear
    echo "========================================="
    echo "        创建 Docker 容器"
    echo "========================================="
    read -p "请输入要使用的镜像名称 (例如: ubuntu:latest): " image_name
    if [ -z "$image_name" ]; then
        echo "镜像名称不能为空。"
        echo "========================================="
        read -p "按任意键继续..."
        return
    fi

    read -p "请输入容器名称 (可选): " container_name
    read -p "请输入端口映射 (例如: 80:80, 可选): " port_mapping
    read -p "请输入数据卷映射 (例如: /host/path:/container/path, 可选): " volume_mapping
    read -p "请输入网络名称 (可选): " network_name

    run_command="docker run -d"

    if [ -n "$container_name" ]; then
        run_command="$run_command --name $container_name"
    fi

    if [ -n "$port_mapping" ]; then
        run_command="$run_command -p $port_mapping"
    fi

    if [ -n "$volume_mapping" ]; then
        run_command="$run_command -v $volume_mapping"
    fi

    if [ -n "$network_name" ]; then
        run_command="$run_command --network $network_name"
    fi

    run_command="$run_command $image_name"

    echo "正在执行命令: $run_command"
    eval $run_command

    if [ $? -eq 0 ]; then
        echo "容器已成功创建。"
    else
        echo "创建容器失败。"
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function start_specified_container() {
    clear
    echo "========================================="
    echo "        启动 Docker 容器"
    echo "========================================="
    docker ps -a
    echo "-----------------------------------------"
    read -p "请输入要启动的容器名称或ID: " container_id
    if [ -z "$container_id" ]; then
        echo "容器名称或ID不能为空。"
    else
        docker start "$container_id"
        if [ $? -eq 0 ]; then
            echo "容器 '$container_id' 已成功启动。"
        else
            echo "启动容器 '$container_id' 失败。"
        fi
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function stop_specified_container() {
    clear
    echo "========================================="
    echo "        停止 Docker 容器"
    echo "========================================="
    docker ps -a
    echo "-----------------------------------------"
    read -p "请输入要停止的容器名称或ID: " container_id
    if [ -z "$container_id" ]; then
        echo "容器名称或ID不能为空。"
    else
        docker stop "$container_id"
        if [ $? -eq 0 ]; then
            echo "容器 '$container_id' 已成功停止。"
        else
            echo "停止容器 '$container_id' 失败。"
        fi
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function restart_specified_container() {
    clear
    echo "========================================="
    echo "        重启 Docker 容器"
    echo "========================================="
    docker ps -a
    echo "-----------------------------------------"
    read -p "请输入要重启的容器名称或ID: " container_id
    if [ -z "$container_id" ]; then
        echo "容器名称或ID不能为空。"
    else
        docker restart "$container_id"
        if [ $? -eq 0 ]; then
            echo "容器 '$container_id' 已成功重启。"
        else
            echo "重启容器 '$container_id' 失败。"
        fi
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function remove_specified_container() {
    clear
    echo "========================================="
    echo "        删除 Docker 容器"
    echo "========================================="
    docker ps -a
    echo "-----------------------------------------"
    read -p "请输入要删除的容器名称或ID: " container_id
    if [ -z "$container_id" ]; then
        echo "容器名称或ID不能为空。"
    else
        read -p "确定要删除容器 '$container_id' 吗？(y/N): " confirm_remove
        if [[ "$confirm_remove" =~ ^[yY]$ ]]; then
            docker rm "$container_id"
            if [ $? -eq 0 ]; then
                echo "容器 '$container_id' 已成功删除。"
            else
                echo "删除容器 '$container_id' 失败。"
            fi
        else
            echo "取消删除容器。"
        fi
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function start_all_containers() {
    clear
    echo "========================================="
    echo "        启动所有 Docker 容器"
    echo "========================================="
    docker start $(docker ps -a -q)
    echo "========================================="
    read -p "按任意键继续..."
}

function stop_all_containers() {
    clear
    echo "========================================="
    echo "        停止所有 Docker 容器"
    echo "========================================="
    docker stop $(docker ps -a -q)
    echo "========================================="
    read -p "按任意键继续..."
}

function remove_all_containers() {
    clear
    echo "========================================="
    echo "        删除所有 Docker 容器"
    echo "========================================="
    read -p "确定要删除所有容器吗？(y/N): " confirm_remove_all
    if [[ "$confirm_remove_all" =~ ^[yY]$ ]]; then
        docker rm $(docker ps -a -q)
        echo "所有容器已删除。"
    else
        echo "取消删除所有容器。"
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function restart_all_containers() {
    clear
    echo "========================================="
    echo "        重启所有 Docker 容器"
    echo "========================================="
    docker restart $(docker ps -a -q)
    echo "========================================="
    read -p "按任意键继续..."
}

function enter_specified_container() {
    clear
    echo "========================================="
    echo "        进入指定 Docker 容器"
    echo "========================================="
    docker ps -a
    echo "-----------------------------------------"
    read -p "请输入要进入的容器名称或 ID: " container_id
    if [ -z "$container_id" ]; then
        echo "容器名称或 ID 不能为空。"
        echo "========================================="
        read -p "按任意键继续..."
        return
    fi
    docker exec -it "$container_id" /bin/bash || docker exec -it "$container_id" sh
    echo "========================================="
    read -p "按任意键继续..."
}

function view_container_logs() {
    clear
    echo "========================================="
    echo "        查看容器日志"
    echo "========================================="
    docker ps -a
    echo "-----------------------------------------"
    read -p "请输入要查看日志的容器名称或 ID: " container_id
    if [ -z "$container_id" ]; then
        echo "容器名称或 ID 不能为空。"
        echo "========================================="
        read -p "按任意键继续..."
        return
    fi
    docker logs "$container_id"
    echo "========================================="
    read -p "按任意键继续..."
}

function view_container_network() {
    clear
    echo "========================================="
    echo "        查看容器网络"
    echo "========================================="
    docker ps -a
    echo "-----------------------------------------"
    read -p "请输入要查看网络的容器名称或 ID: " container_id
    if [ -z "$container_id" ]; then
        echo "容器名称或 ID 不能为空。"
        echo "========================================="
        read -p "按任意键继续..."
        return
    fi
    docker inspect --format='{{json .NetworkSettings.Networks}}' "$container_id" | jq .
    echo "========================================="
    read -p "按任意键继续..."
}

function view_container_usage() {
    clear
    echo "========================================="
    echo "        查看容器占用"
    echo "========================================="
    docker ps -a
    echo "-----------------------------------------"
    read -p "请输入要查看占用的容器名称或 ID: " container_id
    if [ -z "$container_id" ]; then
        echo "容器名称或 ID 不能为空。"
        echo "========================================="
        read -p "按任意键继续..."
        return
    fi
    docker stats --no-stream "$container_id"
    echo "========================================="
    read -p "按任意键继续..."
}

function enable_container_port_access() {
    clear
    echo "========================================="
    echo "        开启容器端口访问"
    echo "========================================="
    docker ps -a
    echo "-----------------------------------------"
    read -p "请输入容器名称或 ID: " container_id
    if [ -z "$container_id" ]; then
        echo "容器名称或 ID 不能为空。"
        echo "========================================="
        read -p "按任意键继续..."
        return
    fi
    read -p "请输入要开启的端口 (例如: 80): " port
    if [ -z "$port" ]; then
        echo "端口不能为空。"
        echo "========================================="
        read -p "按任意键继续..."
        return
    fi
    # This operation usually requires recreating the container with port mapping.
    # For simplicity, we'll just inform the user.
    echo "开启容器端口访问通常需要重新创建容器并进行端口映射。"
    echo "请考虑使用 '创建新的容器' 选项并设置端口映射。"
    echo "========================================="
    read -p "按任意键继续..."
}

function disable_container_port_access() {
    clear
    echo "========================================="
    echo "        关闭容器端口访问"
    echo "========================================="
    docker ps -a
    echo "-----------------------------------------"
    read -p "请输入容器名称或 ID: " container_id
    if [ -z "$container_id" ]; then
        echo "容器名称或 ID 不能为空。"
        echo "========================================="
        read -p "按任意键继续..."
        return
    fi
    read -p "请输入要关闭的端口 (例如: 80): " port
    if [ -z "$port" ]; then
        echo "端口不能为空。"
        echo "========================================="
        read -p "按任意键继续..."
        return
    fi
    # This operation usually requires recreating the container without port mapping.
    # For simplicity, we'll just inform the user.
    echo "关闭容器端口访问通常需要重新创建容器并移除端口映射。"
    echo "请考虑使用 '创建新的容器' 选项并移除端口映射。"
    echo "========================================="
    read -p "按任意键继续..."
}

function docker_image_management() {
    while true;
    do
        clear
        list_docker_images
        echo "========================================="
        echo "        Docker 镜像管理"
        echo "========================================="
        echo "2. 拉取镜像"
        echo "3. 删除镜像"
        echo "4. 清理悬空镜像"
        echo "0. 返回主菜单"
        echo "========================================="
        read -p "请选择操作: " choice

        case $choice in
            1) list_docker_images ;;
            2) pull_docker_image ;;
            3) remove_docker_image ;;
            4) clean_dangling_images ;;
            0) break ;;
            *) echo "无效选择，请重新输入。" ; read -p "按任意键继续..." ;;
        esac
    done
}

function list_docker_images() {
    clear
    echo "========================================="
    echo "        列出所有 Docker 镜像"
    echo "========================================="
    docker images -a
    echo "========================================="
}

function pull_docker_image() {
    clear
    echo "========================================="
    echo "        拉取 Docker 镜像"
    echo "========================================="
    read -p "请输入要拉取的镜像名称 (例如: ubuntu:latest): " image_name
    if [ -z "$image_name" ]; then
        echo "镜像名称不能为空。"
    else
        echo "正在拉取镜像 '$image_name' ..."
        docker pull "$image_name"
        if [ $? -eq 0 ]; then
            echo "镜像 '$image_name' 已成功拉取。"
        else
            echo "拉取镜像 '$image_name' 失败。"
        fi
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function remove_docker_image() {
    clear
    echo "========================================="
    echo "        删除 Docker 镜像"
    echo "========================================="
    docker images -a
    echo "-----------------------------------------"
    read -p "请输入要删除的镜像名称或ID: " image_id
    if [ -z "$image_id" ]; then
        echo "镜像名称或ID不能为空。"
    else
        read -p "确定要删除镜像 '$image_id' 吗？(y/N): " confirm_remove
        if [[ "$confirm_remove" =~ ^[Yy]$ ]]; then
            docker rmi "$image_id"
            if [ $? -eq 0 ]; then
                echo "镜像 '$image_id' 已成功删除。"
            else
                echo "删除镜像 '$image_id' 失败。"
            fi
        else
            echo "已取消删除操作。"
        fi
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function clean_dangling_images() {
    clear
    echo "========================================="
    echo "        清理悬空 Docker 镜像"
    echo "========================================="
    echo "正在清理悬空镜像..."
    docker image prune -f
    if [ $? -eq 0 ]; then
        echo "悬空镜像已成功清理。"
    else
        echo "清理悬空镜像失败。"
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function docker_network_management() {
    while true; do
        clear
        list_docker_networks
        echo "========================================="
        echo "        Docker 网络管理"
        echo "========================================="
        echo "2. 创建网络"
        echo "3. 删除网络"
        echo "4. 检查网络"
        echo "0. 返回主菜单"
        echo "========================================="
        read -p "请选择操作: " choice
        case $choice in
            1) list_docker_networks ;;
            2) create_docker_network ;;
            3) remove_docker_network ;;
            4) inspect_docker_network ;;
            0) break ;;
            *) echo "无效的选项，请重新输入。" ; read -p "按任意键继续..." ;;
        esac
    done
}

function list_docker_networks() {
    clear
    echo "========================================="
    echo "        列出所有 Docker 网络"
    echo "========================================="
    docker network ls
    echo "========================================="
}

function create_docker_network() {
    clear
    echo "========================================="
    echo "        创建 Docker 网络"
    echo "========================================="
    read -p "请输入要创建的网络名称: " network_name
    if [ -z "$network_name" ]; then
        echo "网络名称不能为空。"
    else
        read -p "请输入网络驱动 (例如: bridge, overlay, macvlan, 默认为 bridge): " network_driver
        if [ -z "$network_driver" ]; then
            network_driver="bridge"
        fi
        echo "正在创建网络 '$network_name' (驱动: '$network_driver') ..."
        docker network create -d "$network_driver" "$network_name"
        if [ $? -eq 0 ]; then
            echo "网络 '$network_name' 已成功创建。"
        else
            echo "创建网络 '$network_name' 失败。"
        fi
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function remove_docker_network() {
    clear
    echo "========================================="
    echo "        删除 Docker 网络"
    echo "========================================="
    docker network ls
    echo "-----------------------------------------"
    read -p "请输入要删除的网络名称或ID: " network_id
    if [ -z "$network_id" ]; then
        echo "网络名称或ID不能为空。"
    else
        read -p "确定要删除网络 '$network_id' 吗？(y/N): " confirm_remove
        if [[ "$confirm_remove" =~ ^[Yy]$ ]]; then
            docker network rm "$network_id"
            if [ $? -eq 0 ]; then
                echo "网络 '$network_id' 已成功删除。"
            else
                echo "删除网络 '$network_id' 失败。"
            fi
        else
            echo "已取消删除操作。"
        fi
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function inspect_docker_network() {
    clear
    echo "========================================="
    echo "        检查 Docker 网络"
    echo "========================================="
    docker network ls
    echo "-----------------------------------------"
    read -p "请输入要检查的网络名称或ID: " network_id
    if [ -z "$network_id" ]; then
        echo "网络名称或ID不能为空。"
    else
        echo "正在检查网络 '$network_id' ..."
        docker network inspect "$network_id"
        if [ $? -eq 0 ]; then
            echo "网络 '$network_id' 检查完成。"
        else
            echo "检查网络 '$network_id' 失败。"
        fi
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function docker_volume_management() {
    while true; do
        clear
        list_docker_volumes
        echo "========================================="
        echo "        Docker 数据卷管理"
        echo "========================================="
        echo "2. 创建数据卷"
        echo "3. 删除数据卷"
        echo "4. 检查数据卷"
        echo "0. 返回主菜单"
        echo "========================================="
        read -p "请选择操作: " choice
        case $choice in
            1) list_docker_volumes ;;
            2) create_docker_volume ;;
            3) remove_docker_volume ;;
            4) inspect_docker_volume ;;
            0) break ;;
            *) echo "无效的选项，请重新输入。" ; read -p "按任意键继续..." ;;
        esac
    done
}

function list_docker_volumes() {
    clear
    echo "========================================="
    echo "        列出所有 Docker 数据卷"
    echo "========================================="
    docker volume ls
    echo "========================================="
}

function create_docker_volume() {
    clear
    echo "========================================="
    echo "        创建 Docker 数据卷"
    echo "========================================="
    read -p "请输入要创建的数据卷名称: " volume_name
    if [ -z "$volume_name" ]; then
        echo "数据卷名称不能为空。"
    else
        echo "正在创建数据卷 '$volume_name' ..."
        docker volume create "$volume_name"
        if [ $? -eq 0 ]; then
            echo "数据卷 '$volume_name' 已成功创建。"
        else
            echo "创建数据卷 '$volume_name' 失败。"
        fi
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function remove_docker_volume() {
    clear
    echo "========================================="
    echo "        删除 Docker 数据卷"
    echo "========================================="
    docker volume ls
    echo "-----------------------------------------"
    read -p "请输入要删除的数据卷名称或ID: " volume_id
    if [ -z "$volume_id" ]; then
        echo "数据卷名称或ID不能为空。"
    else
        read -p "确定要删除数据卷 '$volume_id' 吗？(y/N): " confirm_remove
        if [[ "$confirm_remove" =~ ^[Yy]$ ]]; then
            docker volume rm "$volume_id"
            if [ $? -eq 0 ]; then
                echo "数据卷 '$volume_id' 已成功删除。"
            else
                echo "删除数据卷 '$volume_id' 失败。"
            fi
        else
            echo "已取消删除操作。"
        fi
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function inspect_docker_volume() {
    clear
    echo "========================================="
    echo "        检查 Docker 数据卷"
    echo "========================================="
    docker volume ls
    echo "-----------------------------------------"
    read -p "请输入要检查的数据卷名称或ID: " volume_id
    if [ -z "$volume_id" ]; then
        echo "数据卷名称或ID不能为空。"
    else
        docker volume inspect "$volume_id"
        if [ $? -eq 0 ]; then
            echo "数据卷 '$volume_id' 检查成功。"
        else
            echo "检查数据卷 '$volume_id' 失败。"
        fi
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function clean_docker_resources() {
    clear
    echo "========================================="
    echo "        清理无用的 Docker 资源"
    echo "========================================="
    echo "此操作将删除所有停止的容器、未使用的网络、悬空镜像以及所有未使用的构建缓存。"
    echo "如果您添加 --volumes 选项，还将删除所有未使用的本地卷。"
    echo ""
    read -p "确定要执行 Docker 系统清理操作吗？(y/N): " confirm_prune
    if [[ "$confirm_prune" =~ ^[Yy]$ ]]; then
        echo "正在执行 Docker 系统清理 (docker system prune --volumes)..."
        docker system prune --volumes -f
        if [ $? -eq 0 ]; then
            echo "Docker 资源清理完成。"
        else
            echo "Docker 资源清理失败。"
        fi
    else
        echo "已取消 Docker 系统清理操作。"
    fi
    echo "========================================="
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
        sudo mkdir -p $(dirname "$DAEMON_FILE")
        sudo touch "$DAEMON_FILE"
        echo "{}" | sudo tee "$DAEMON_FILE" > /dev/null
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
    sudo nano "$DAEMON_FILE"

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
        sudo mkdir -p $(dirname "$DAEMON_FILE")
        echo "{}" | sudo tee "$DAEMON_FILE" > /dev/null
        if [ $? -ne 0 ]; then
            echo "创建 daemon.json 文件失败。"
            read -p "按任意键继续..."
            return
        fi
    fi

    echo "正在配置 daemon.json 以启用 IPv6..."
    # 使用 jq 更新 daemon.json 文件
    sudo jq '. + {"ipv6": true, "fixed-cidr-v6": "2001:db8:1::/64"}' "$DAEMON_FILE" | sudo tee "$DAEMON_FILE" > /dev/null

    if [ $? -eq 0 ]; then
        echo "daemon.json 文件已更新，IPv6 已启用。"
        echo "正在重启 Docker 服务以应用更改..."
        sudo systemctl restart docker
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
    sudo jq 'del(.ipv6) | del(."fixed-cidr-v6")' "$DAEMON_FILE" | sudo tee "$DAEMON_FILE" > /dev/null

    if [ $? -eq 0 ]; then
        echo "daemon.json 文件已更新，IPv6 已禁用。"
        echo "正在重启 Docker 服务以应用更改..."
        sudo systemctl restart docker
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
        echo "========================================="
        echo "        备份/迁移/还原 Docker 环境"
        echo "========================================="
        echo "1. 备份 Docker 环境"
        echo "2. 迁移 Docker 环境 (待实现)"
        echo "3. 还原 Docker 环境 (待实现)"
        echo "0. 返回主菜单"
        echo "========================================="
        read -p "请选择操作: " choice

        case $choice in
            1) backup_docker_env ;;
            2) echo "迁移功能待实现，按任意键继续..."; read -p "" ;;
            3) echo "还原功能待实现，按任意键继续..."; read -p "" ;;
            0) break ;;
            *) echo "无效的选项，请重新输入。" ; read -p "按任意键继续..." ;;
        esac
    done
}

function backup_docker_env() {
    clear
    echo "========================================="
    echo "        备份 Docker 环境"
    echo "========================================="
    read -p "请输入备份文件名称 (例如: docker_backup_$(date +%Y%m%d).tar.gz): " backup_file
    if [ -z "$backup_file" ]; then
        backup_file="docker_backup_$(date +%Y%m%d).tar.gz"
    fi

    read -p "请输入备份保存路径 (例如: /opt/docker_backups, 默认为当前目录): " backup_path
    if [ -z "$backup_path" ]; then
        backup_path="."
    fi

    sudo mkdir -p "$backup_path"

    echo "正在备份 Docker 环境到 $backup_path/$backup_file ..."
    sudo tar -czvf "$backup_path/$backup_file" /var/lib/docker

    if [ $? -eq 0 ]; then
        echo "Docker 环境备份成功。"
    else
        echo "Docker 环境备份失败。"
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

function uninstall_docker() {
    clear
    echo "========================================="
    echo "        卸载 Docker 环境"
    echo "========================================="
    read -p "警告：这将彻底卸载 Docker 及其所有相关组件 (容器、镜像、数据卷)。确定要继续吗？(y/N): " confirm_uninstall
    if [[ "$confirm_uninstall" =~ ^[Yy]$ ]]; then
        echo "正在停止所有运行中的 Docker 容器..."
        docker stop $(docker ps -aq)

        echo "正在删除所有 Docker 容器..."
        docker rm $(docker ps -aq)

        echo "正在删除所有 Docker 镜像..."
        docker rmi -f $(docker images -aq)

        echo "正在删除所有 Docker 数据卷..."
        docker volume rm $(docker volume ls -q)

        echo "正在停止并禁用 Docker 服务..."
        sudo systemctl stop docker
        sudo systemctl disable docker

        echo "正在卸载 Docker 软件包..."
        if command -v apt >/dev/null 2>&1; then
            echo "检测到 Debian/Ubuntu 系统，使用 apt 进行卸载..."
            sudo apt purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo apt autoremove -y
        elif command -v yum >/dev/null 2>&1; then
            echo "检测到 CentOS/RHEL 系统，使用 yum 进行卸载..."
            sudo yum remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo yum autoremove -y
        elif command -v dnf >/dev/null 2>&1; then
            echo "检测到 Fedora/RHEL 8+ 系统，使用 dnf 进行卸载..."
            sudo dnf remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo dnf autoremove -y
        else
            echo "未检测到支持的包管理器 (apt, yum, dnf)。请手动卸载 Docker 软件包。"
        fi

        echo "正在删除 Docker 配置文件和目录..."
        sudo rm -rf /var/lib/docker
        sudo rm -rf /etc/docker
        sudo rm -rf /var/run/docker.sock

        echo "Docker 环境已成功卸载。"
    else
        echo "取消卸载 Docker 环境。"
    fi
    echo "========================================="
    read -p "按任意键继续..."
}

# Docker 管理菜单
function docker_menu() {
    while true; do
        clear
        check_docker_status
        echo -e " ${GREEN}1.${NC}  安装更新Docker环境"
        echo -e " ${GREEN}2.${NC}  查看Docker全局状态"
        echo -e " ${GREEN}3.${NC}  Docker容器管理"
        echo -e " ${GREEN}4.${NC}  Docker镜像管理"
        echo -e " ${GREEN}5.${NC}  Docker网络管理"
        echo -e " ${GREEN}6.${NC}  Docker卷管理"
        echo -e " ${GREEN}7.${NC}  清理无用的docker容器和镜像网络数据卷"
        echo -e " ${GREEN}8.${NC}  更换Docker源"
        echo -e " ${GREEN}9.${NC}  编辑daemon.json文件"
        echo -e " ${GREEN}11.${NC} 开启Docker-ipv6访问"
        echo -e " ${GREEN}12.${NC} 关闭Docker-ipv6访问"
        echo -e " ${GREEN}19.${NC} 备份/迁移/还原Docker环境"
        echo -e " ${GREEN}20.${NC} 卸载Docker环境"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回主菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择: " docker_choice

        case "$docker_choice" in
            1)
                install_update_docker_env
                ;;
            2)
                view_docker_global_status
                ;;
            3)
                docker_container_management
                ;;
            4)
                docker_image_management
                ;;
            5)
                docker_network_management
                ;;
            6)
                docker_volume_management
                ;;
            7)
                clean_docker_resources
                ;;
            8)
                change_docker_source
                ;;
            9)
                edit_daemon_json
                ;;
            11)
                enable_docker_ipv6
                ;;
            12)
                disable_docker_ipv6
                ;;
            19)
                backup_migrate_restore_docker
                ;;
            20)
                uninstall_docker
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
