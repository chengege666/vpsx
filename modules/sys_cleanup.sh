#!/bin/bash

# 定义颜色变量（确保脚本中已存在，若无则取消注释）
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[0;33m'
# BLUE='\033[0;34m'
# CYAN='\033[0;36m'
# NC='\033[0m'

function system_cleanup() {
    while true; do
        clear
        echo -e "${CYAN}==========================================${NC}"
        echo -e "${CYAN}              系统清理工具箱              ${NC}"
        echo -e "${CYAN}==========================================${NC}"
        echo -e " 1) ${GREEN}执行系统深度清理 (完整模式)${NC}"
        echo -e " 2) ${RED}返回上一级菜单${NC}"
        echo -e "${CYAN}==========================================${NC}"
        echo ""
        read -p "请输入您的选择 [1-2]: " sub_choice

        case $sub_choice in
            1)
                # --- 开始执行原有的完整逻辑 ---
                clear
                echo -e "${CYAN}"
                echo "=========================================="
                echo "              系统清理功能        "
                echo "=========================================="
                echo -e "${NC}"
                
                echo -e "${YELLOW}⚠️ 警告：系统清理操作将删除不必要的文件，请谨慎操作！${NC}"
                echo ""
                read -p "是否继续执行系统清理？(y/n): " confirm
                if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then 
                    echo -e "${YELLOW}已取消系统清理操作${NC}"
                    sleep 1
                    continue
                fi

                # 创建备份时间戳
                BACKUP_DIR="/tmp/system_clean_backup_$(date +%Y%m%d_%H%M%S)"
                mkdir -p "$BACKUP_DIR"
                
                if [ -f /etc/debian_version ]; then
                    echo -e "${BLUE}检测到 Debian/Ubuntu 系统${NC}"
                    echo -e "${YELLOW}开始深度清理系统...${NC}"
                    echo ""
                    
                    # 1. 清理包管理器缓存
                    echo -e "${BLUE}[步骤1/8] 清理APT缓存和旧包...${NC}"
                    if [ -f /etc/apt/sources.list.d/docker.list ]; then
                        mv /etc/apt/sources.list.d/docker.list /etc/apt/sources.list.d/docker.list.bak
                        echo -e "${YELLOW}已备份并移除可能损坏的 docker.list${NC}"
                    fi
                    apt clean
                    apt autoclean
                    apt autoremove -y
                    
                    if ! command -v deborphan >/dev/null 2>&1; then
                        echo -e "${YELLOW}安装 deborphan 以清理孤立软件包...${NC}"
                        apt update && apt install -y deborphan
                    fi
                    if command -v deborphan >/dev/null 2>&1; then
                        echo -e "${YELLOW}清理孤立软件包...${NC}"
                        deborphan | xargs apt -y purge 2>/dev/null
                    fi
                    
                    # 2. 清理旧内核
                    echo -e "${BLUE}[步骤2/8] 清理旧内核...${NC}"
                    local current_kernel=$(uname -r)
                    local kernel_pkgs=$(dpkg-query -W -f='${Package}\n' 'linux-image-[0-9]*' 'linux-headers-[0-9]*' | grep -v "$current_kernel")
                    
                    if [ -n "$kernel_pkgs" ]; then
                        echo -e "${YELLOW}发现旧内核包，准备清理...${NC}"
                        echo "$kernel_pkgs" | xargs apt-get -y purge
                    else
                        echo -e "${GREEN}未发现需要清理的旧内核。${NC}"
                    fi
                    
                    # 3. 清理日志文件
                    echo -e "${BLUE}[步骤3/8] 清理日志文件...${NC}"
                    journalctl --vacuum-time=7d 2>/dev/null
                    find /var/log -name "*.log" -type f -mtime +30 -delete 2>/dev/null
                    find /var/log -name "*.gz" -type f -mtime +7 -delete 2>/dev/null
                    find /var/log -name "*.old" -type f -mtime +7 -delete 2>/dev/null
                    find /var/log -name "*.[0-9]" -type f -mtime +7 -delete 2>/dev/null
                    truncate -s 0 /var/log/*.log 2>/dev/null
                    
                    # 4. 清理临时文件
                    echo -e "${BLUE}[步骤4/8] 清理临时文件...${NC}"
                    rm -rf /tmp/*
                    rm -rf /var/tmp/*
                    rm -rf /var/cache/apt/archives/*
                    rm -rf /var/cache/debconf/*
                    
                    # 5. 清理缩略图缓存
                    echo -e "${BLUE}[步骤5/8] 清理缩略图缓存...${NC}"
                    find /home -type f -name ".thumbnails" -exec rm -rf {} + 2>/dev/null
                    find /root -type f -name ".thumbnails" -exec rm -rf {} + 2>/dev/null
                    
                    # 6. 清理浏览器缓存
                    echo -e "${BLUE}[步骤6/8] 清理浏览器缓存...${NC}"
                    find /home -type d -name "mozilla" -prune -exec rm -rf {}/.cache/mozilla/* 2>/dev/null \;
                    find /home -type d -name "google-chrome" -prune -exec rm -rf {}/.cache/google-chrome/* 2>/dev/null \;
                    find /root -type d -name "mozilla" -prune -exec rm -rf {}/.cache/mozilla/* 2>/dev/null \;
                    find /root -type d -name "google-chrome" -prune -exec rm -rf {}/.cache/google-chrome/* 2>/dev/null \;
                    
                    # 7. 清理崩溃报告
                    echo -e "${BLUE}[步骤7/8] 清理崩溃报告...${NC}"
                    rm -rf /var/crash/*
                    find /var/lib/apport/crash -type f -delete 2>/dev/null
                    
                    # 8. 清理软件包列表缓存
                    echo -e "${BLUE}[步骤8/8] 清理软件包列表缓存...${NC}"
                    rm -rf /var/lib/apt/lists/*
                    apt update
                    
                elif [ -f /etc/redhat-release ]; then
                    echo -e "${BLUE}检测到 CentOS/RHEL 系统${NC}"
                    echo -e "${YELLOW}开始深度清理系统...${NC}"
                    echo ""
                    
                    # 1. 清理YUM/DNF缓存
                    echo -e "${BLUE}[步骤1/8] 清理YUM/DNF缓存...${NC}"
                    if command -v dnf >/dev/null 2>&1; then
                        dnf clean all
                        dnf autoremove -y
                    else
                        yum clean all
                        package-cleanup --oldkernels --count=1 -y 2>/dev/null
                        package-cleanup --leaves -y 2>/dev/null
                    fi
                    
                    # 2. 清理旧内核
                    echo -e "${BLUE}[步骤2/8] 清理旧内核...${NC}"
                    if command -v dnf >/dev/null 2>&1; then
                        dnf remove -y $(dnf repoquery --installonly --latest-limit=-1 -q) 2>/dev/null
                    else
                        package-cleanup --oldkernels --count=1 -y 2>/dev/null
                    fi
                    
                    # 3. 清理日志文件
                    echo -e "${BLUE}[步骤3/8] 清理日志文件...${NC}"
                    journalctl --vacuum-time=7d 2>/dev/null
                    find /var/log -name "*.log" -type f -mtime +30 -delete 2>/dev/null
                    find /var/log -name "*.gz" -type f -mtime +7 -delete 2>/dev/null
                    find /var/log -name "*.[0-9]" -type f -mtime +7 -delete 2>/dev/null
                    truncate -s 0 /var/log/*.log 2>/dev/null
                    
                    # 4. 清理临时文件
                    echo -e "${BLUE}[步骤4/8] 清理临时文件...${NC}"
                    rm -rf /tmp/*
                    rm -rf /var/tmp/*
                    rm -rf /var/cache/yum/*
                    rm -rf /var/cache/dnf/*
                    
                    # 5. 清理缩略图缓存
                    echo -e "${BLUE}[步骤5/8] 清理缩略图缓存...${NC}"
                    find /home -type f -name ".thumbnails" -exec rm -rf {} + 2>/dev/null
                    find /root -type f -name ".thumbnails" -exec rm -rf {} + 2>/dev/null
                    
                    # 6. 清理浏览器缓存
                    echo -e "${BLUE}[步骤6/8] 清理浏览器缓存...${NC}"
                    find /home -type d -name "google-chrome" -prune -exec rm -rf {}/.cache/google-chrome/* 2>/dev/null \;
                    find /home -type d -name "mozilla" -prune -exec rm -rf {}/.cache/mozilla/* 2>/dev/null \;
                    find /root -type d -name "google-chrome" -prune -exec rm -rf {}/.cache/google-chrome/* 2>/dev/null \;
                    find /root -type d -name "mozilla" -prune -exec rm -rf {}/.cache/mozilla/* 2>/dev/null \;
                    
                    # 7. 清理崩溃报告
                    echo -e "${BLUE}[步骤7/8] 清理崩溃报告...${NC}"
                    rm -rf /var/crash/*
                    find /var/spool/abrt -type f -delete 2>/dev/null
                    
                    # 8. 清理系统缓存
                    echo -e "${BLUE}[步骤8/8] 清理系统缓存...${NC}"
                    sync
                    echo 3 > /proc/sys/vm/drop_caches 2>/dev/null
                    
                else
                    echo -e "${RED}不支持的系统类型！${NC}"
                    sleep 2
                    continue
                fi
                
                # 通用清理步骤
                echo -e "${BLUE}[通用步骤] 执行通用清理...${NC}"
                find /tmp -name "*.tmp" -type f -delete 2>/dev/null
                find /tmp -name "*.swp" -type f -delete 2>/dev/null
                find /home -name "*.bak" -type f -mtime +30 -delete 2>/dev/null
                find /tmp -type d -empty -delete 2>/dev/null
                find /var/tmp -type d -empty -delete 2>/dev/null
                
                # 显示清理结果
                echo ""
                echo -e "${GREEN}✅ 系统深度清理完成！${NC}"
                echo -e "${YELLOW}释放后的磁盘空间：${NC}"
                df -h / | tail -1 | awk '{print "根分区可用空间: " $4}'
                
                # 清理备份记录
                rm -rf "$BACKUP_DIR"
                
                echo ""
                read -p "按回车键返回清理菜单..."
                # --- 原逻辑结束 ---
                ;;
            2)
                # 返回主菜单（即退出当前函数循环）
                return
                ;;
            *)
                echo -e "${RED}无效选项，请重新输入！${NC}"
                sleep 1
                ;;
        esac
    done
}
