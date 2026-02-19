#!/bin/bash

# ==========================================
# 模块定位：磁盘清理核心模块
# 职责：评估、安全清理、风险清理、报告
# 不负责：定时任务、服务重启
# ==========================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 全局配置
LOG_FILE="/var/log/vps_clean.log"
RETAIN_DAYS=7
DRY_RUN=false
FORCE=false
IS_INTERACTIVE=true
START_TIME=$(date +%s)

# 黑名单路径 (禁止直接删除这些目录本身)
BLACKLIST_PATHS=(
    "/" "/bin" "/boot" "/dev" "/etc" "/home" "/lib" "/lib64" 
    "/lost+found" "/media" "/mnt" "/opt" "/proc" "/root" 
    "/run" "/sbin" "/srv" "/sys" "/usr" "/var" "/var/lib" 
    "/var/log" "/var/tmp" "/tmp"
)

# 日志记录函数
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local log_entry="[$timestamp] [$level] $message"
    
    # 尝试创建日志目录
    if [ ! -d "$(dirname "$LOG_FILE")" ]; then
        mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null
    fi

    # 写入日志文件 (如果可写)
    if [ -w "$(dirname "$LOG_FILE")" ] || [ "$EUID" -eq 0 ]; then
        echo "$log_entry" >> "$LOG_FILE"
    fi
    
    # 输出到终端 (根据级别显示颜色)
    case "$level" in
        INFO) echo -e "${GREEN}[INFO] $message${NC}" ;;
        WARN) echo -e "${YELLOW}[WARN] $message${NC}" ;;
        ERROR) echo -e "${RED}[ERROR] $message${NC}" ;;
        DEBUG) echo -e "${BLUE}[DEBUG] $message${NC}" ;;
        *) echo "$message" ;;
    esac
}

# 统一删除函数
safe_delete() {
    local target="$1"
    
    # 1. 路径校验：是否为空或根目录
    if [ -z "$target" ] || [ "$target" == "/" ]; then
        log_message "ERROR" "尝试删除非法路径: $target"
        return 1
    fi

    # 2. 黑名单校验
    for path in "${BLACKLIST_PATHS[@]}"; do
        if [ "$target" == "$path" ]; then
            log_message "ERROR" "尝试删除系统关键路径: $target"
            return 1
        fi
    done

    # 3. 检查是否存在
    if [ ! -e "$target" ]; then
        return 0
    fi

    # 4. 获取文件大小 (用于日志)
    local size=$(du -sh "$target" 2>/dev/null | cut -f1)

    # 5. 执行删除或 Dry-run
    if [ "$DRY_RUN" = true ]; then
        log_message "INFO" "[Dry-Run] 模拟删除: $target (大小: $size)"
    else
        rm -rf "$target"
        if [ $? -eq 0 ]; then
            log_message "INFO" "已删除: $target (释放: $size)"
        else
            log_message "ERROR" "删除失败: $target"
        fi
    fi
}

# 文件用途推测函数 (保留辅助功能)
guess_file_type() {
    local file_path="$1"
    local file_name=$(basename "$file_path")
    local file_ext="${file_name##*.}"
    
    if [[ "$file_path" == *"/var/log"* ]] || [[ "$file_ext" == "log" ]]; then
        echo "日志文件"
    elif [[ "$file_path" == *"/tmp"* ]]; then
        echo "临时文件"
    elif [[ "$file_ext" =~ ^(gz|tar|zip|rar|7z|iso|xz|bz2)$ ]]; then
        echo "压缩包/镜像"
    elif [[ "$file_ext" =~ ^(bak|old|swp|tmp)$ ]]; then
        echo "备份/临时文件"
    elif [[ "$file_name" == "core"* ]]; then
        echo "崩溃转储文件"
    else
        echo "普通文件"
    fi
}

# 1. 磁盘信息采集函数
collect_disk_info() {
    local partition="/"
    if [ -n "$1" ]; then partition="$1"; fi
    
    echo -e "${CYAN}--- 磁盘信息 ---${NC}"
    df -h "$partition" | awk 'NR==2 {print "挂载点: " $6 ", 大小: " $2 ", 已用: " $3 ", 可用: " $4 ", 使用率: " $5}'
    
    echo -e "${CYAN}--- Inode 使用率 ---${NC}"
    df -i "$partition" | awk 'NR==2 {print "挂载点: " $6 ", Inode已用: " $3 ", Inode可用: " $4 ", Inode使用率: " $5}'
    
    echo -e "${CYAN}--- 关键目录占用 ---${NC}"
    du -sh /var/log 2>/dev/null | awk '{print "/var/log: " $1}'
    du -sh /tmp 2>/dev/null | awk '{print "/tmp: " $1}'
    if command -v docker >/dev/null 2>&1; then
        local docker_root=$(docker info 2>/dev/null | grep "Docker Root Dir" | awk '{print $4}')
        if [ -n "$docker_root" ]; then
             du -sh "$docker_root" 2>/dev/null | awk '{print "Docker (" $2 "): " $1}'
        fi
    fi
    echo "----------------"
}

# 2. 安全清理函数
cleanup_safe() {
    log_message "INFO" "开始执行安全清理 (保留天数: $RETAIN_DAYS)..."

    # 包管理器清理
    if [ -f /etc/debian_version ]; then
        if [ "$DRY_RUN" = true ]; then
            log_message "INFO" "[Dry-Run] apt clean / autoremove"
        else
            apt-get clean
            apt-get autoremove -y
            log_message "INFO" "执行 apt clean / autoremove 完成"
        fi
    elif [ -f /etc/redhat-release ]; then
        if [ "$DRY_RUN" = true ]; then
             log_message "INFO" "[Dry-Run] yum/dnf clean all"
        else
             if command -v dnf >/dev/null 2>&1; then dnf clean all; else yum clean all; fi
             log_message "INFO" "执行 yum/dnf clean all 完成"
        fi
    fi

    # Journalctl 清理
    if command -v journalctl >/dev/null 2>&1; then
        if [ "$DRY_RUN" = true ]; then
            log_message "INFO" "[Dry-Run] journalctl --vacuum-time=${RETAIN_DAYS}d"
        else
            journalctl --vacuum-time="${RETAIN_DAYS}d" >/dev/null 2>&1
            log_message "INFO" "执行 journalctl vacuum 完成"
        fi
    fi

    # /tmp 清理 (超过 RETAIN_DAYS 天)
    log_message "INFO" "扫描 /tmp 中超过 $RETAIN_DAYS 天的文件..."
    find /tmp -type f -mtime +"$RETAIN_DAYS" -print0 | while IFS= read -r -d '' file; do
        safe_delete "$file"
    done
    
    # 清理空目录
    find /tmp -type d -empty -delete 2>/dev/null

    # 用户缓存清理 (~/.cache)
    if [ -d "$HOME/.cache" ]; then
         log_message "INFO" "扫描 $HOME/.cache 中超过 30 天的缓存..."
         find "$HOME/.cache" -type f -mtime +30 -print0 | while IFS= read -r -d '' file; do
             safe_delete "$file"
         done
    fi
}

# 3. 日志清理函数
cleanup_logs() {
    log_message "INFO" "开始执行日志清理..."
    
    # 查找大于 100M 的日志文件
    local large_logs=$(find /var/log -type f -name "*.log" -size +100M 2>/dev/null)
    
    if [ -n "$large_logs" ]; then
        echo "$large_logs" | while read -r log_file; do
            if [ "$DRY_RUN" = true ]; then
                log_message "INFO" "[Dry-Run] 截断大日志文件: $log_file"
            else
                truncate -s 0 "$log_file"
                log_message "INFO" "已截断大日志文件: $log_file"
            fi
        done
    else
        log_message "INFO" "未发现大于 100M 的日志文件。"
    fi

    # 删除旧的压缩日志
    log_message "INFO" "扫描旧的压缩日志 (*.gz, *.old)..."
    find /var/log -type f \( -name "*.gz" -o -name "*.old" -o -name "*.[0-9]" \) -mtime +"$RETAIN_DAYS" -print0 | while IFS= read -r -d '' file; do
        safe_delete "$file"
    done
}

# 4. Docker 清理函数
cleanup_docker() {
    if ! command -v docker >/dev/null 2>&1; then
        log_message "WARN" "Docker 未安装，跳过 Docker 清理。"
        return
    fi

    log_message "INFO" "开始执行 Docker 清理..."

    if [ "$DRY_RUN" = true ]; then
        log_message "INFO" "[Dry-Run] docker system prune -a -f"
        log_message "INFO" "[Dry-Run] docker volume prune -f"
    else
        docker system prune -a -f
        docker volume prune -f
        log_message "INFO" "Docker 清理完成"
    fi
}

# 5. 专家模式函数 (大文件扫描)
cleanup_expert() {
    log_message "INFO" "进入专家模式 (大文件扫描)..."
    local min_size="500M"
    
    # 排除系统目录
    local exclude_paths=(-path "/proc" -o -path "/sys" -o -path "/dev" -o -path "/run" -o -path "/boot")
    
    echo -e "${BLUE}正在扫描全盘大于 $min_size 的文件 (可能需要较长时间)...${NC}"
    
    # 使用临时文件存储结果
    local scan_result="/tmp/expert_scan_$(date +%s).txt"
    
    find / -type d \( -path "/proc" -o -path "/sys" -o -path "/dev" -o -path "/run" -o -path "/boot" \) -prune -o -type f -size +"$min_size" -exec ls -lh {} \; 2>/dev/null | awk '{ print $5 "|" $9 }' | sort -hr -k1 | head -n 20 > "$scan_result"

    if [ ! -s "$scan_result" ]; then
        echo -e "${GREEN}未发现大于 $min_size 的文件。${NC}"
        rm -f "$scan_result"
        return
    fi

    echo -e "${CYAN}--- 大文件列表 ---${NC}"
    printf "%-5s %-10s %-15s %s\n" "序号" "大小" "用途" "路径"
    local i=1
    declare -a file_list
    while IFS='|' read -r size path; do
        local type_desc=$(guess_file_type "$path")
        printf "%-5s %-10s %-15s %s\n" "[$i]" "$size" "$type_desc" "$path"
        file_list[$i]="$path"
        ((i++))
    done < "$scan_result"
    rm -f "$scan_result"

    # 交互模式下的删除逻辑
    if [ "$IS_INTERACTIVE" = true ] && [ "$DRY_RUN" = false ]; then
        echo ""
        echo -e "${YELLOW}请输入要删除的文件序号 (空格分隔，直接回车跳过): ${NC}"
        read -r choices
        if [ -n "$choices" ]; then
            for idx in $choices; do
                if [[ "$idx" =~ ^[0-9]+$ ]] && [ -n "${file_list[$idx]}" ]; then
                    safe_delete "${file_list[$idx]}"
                fi
            done
        fi
    elif [ "$DRY_RUN" = true ]; then
        echo "[Dry-Run] 仅列出，不执行删除操作。"
    fi
}

# 系统清理入口函数
system_cleanup() {
    # 如果没有参数，显示交互菜单
    if [ $# -eq 0 ]; then
        IS_INTERACTIVE=true
        while true; do
            clear
            echo -e "${CYAN}==========================================${NC}"
            echo -e "${CYAN}              系统清理工具箱              ${NC}"
            echo -e "${CYAN}==========================================${NC}"
            echo -e " 1) ${GREEN}执行系统深度清理 (安全模式 + 日志)${NC}"
            echo -e " 2) ${GREEN}扫描磁盘大文件 (专家模式)${NC}"
            echo -e " 3) ${GREEN}Docker 清理${NC}"
            echo -e " 4) ${GREEN}查看磁盘信息${NC}"
            echo -e " 0) ${RED}返回上一级菜单${NC}"
            echo -e "${CYAN}==========================================${NC}"
            echo ""
            read -n 1 -s -r -p "请输入您的选择 [1/2/3/4/0]: " choice
            echo ""
            
            # 消耗掉可能存在的输入残留（如回车键）
            while read -r -t 0; do read -r -n 1; done

            case $choice in
                1)
                    collect_disk_info
                    cleanup_safe
                    cleanup_logs
                    collect_disk_info
                    ;;
                2)
                    cleanup_expert
                    ;;
                3)
                    cleanup_docker
                    ;;
                4)
                    collect_disk_info
                    ;;
                0)
                    return 0
                    ;;
                *)
                    echo -e "${RED}无效选项${NC}"
                    sleep 1
                    ;;
            esac
            
            echo ""
            # 清空缓冲区，防止之前的按键残留导致立即跳过
            while read -r -t 0; do read -r -n 1; done
            read -n 1 -s -r -p "按任意键继续..."
        done
        return 0
    fi

    # 参数解析
    IS_INTERACTIVE=false
    local do_info=false
    local do_safe=false
    local do_logs=false
    local do_docker=false
    local do_expert=false

    for arg in "$@"; do
        case $arg in
            --info) do_info=true ;;
            --safe) do_safe=true ;;
            --logs) do_logs=true ;;
            --docker) do_docker=true ;;
            --expert) do_expert=true ;;
            --dry-run) DRY_RUN=true ;;
            --force) FORCE=true ;;
            --retain-days=*) RETAIN_DAYS="${arg#*=}" ;;
            *) echo "未知参数: $arg"; return 1 ;;
        esac
    done
    
    # 记录开始时的磁盘状态
    local initial_usage=$(df -h / | awk 'NR==2 {print $5}')
    local initial_avail=$(df -h / | awk 'NR==2 {print $4}')

    # 执行逻辑
    if [ "$do_info" = true ]; then collect_disk_info; fi
    if [ "$do_safe" = true ]; then cleanup_safe; fi
    if [ "$do_logs" = true ]; then cleanup_logs; fi
    if [ "$do_docker" = true ]; then cleanup_docker; fi
    if [ "$do_expert" = true ]; then cleanup_expert; fi
    
    # 统计输出
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    local final_usage=$(df -h / | awk 'NR==2 {print $5}')
    local final_avail=$(df -h / | awk 'NR==2 {print $4}')
    
    echo ""
    echo "--- 执行报告 ---"
    echo "清理前使用率: $initial_usage (可用: $initial_avail)"
    echo "清理后使用率: $final_usage (可用: $final_avail)"
    echo "耗时: ${duration} 秒"
    if [ "$DRY_RUN" = true ]; then
        echo "模式: Dry-Run (未实际删除)"
    fi
}

# 如果脚本被直接执行，则调用 system_cleanup 并传递参数
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    system_cleanup "$@"
fi
