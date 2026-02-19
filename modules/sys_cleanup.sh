#!/bin/bash

# =================================================================
# 系统深度清理助手 v2.0
# 支持: Debian/Ubuntu, CentOS/RHEL
# =================================================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # 重置颜色

# 权限检查
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}错误: 必须使用 root 权限运行此脚本。${NC}"
   exit 1
fi

# 系统类型检测
if [ -f /etc/debian_version ]; then
    OS="debian"
elif [ -f /etc/redhat-release ]; then
    OS="rhel"
else
    echo -e "${RED}不支持的系统类型！${NC}"
    exit 1
fi

# -----------------------------------------------------------------
# 功能模块 (Functions)
# -----------------------------------------------------------------

# 1. 软件包管理功能
clean_pkgs_cache() {
    echo -e "${BLUE}正在清理包管理器缓存...${NC}"
    if [ "$OS" == "debian" ]; then
        apt-get clean
        apt-get autoclean
    else
        yum clean all || dnf clean all
    fi
}

clean_pkgs_unused() {
    echo -e "${BLUE}正在移除孤立/不再需要的依赖包...${NC}"
    if [ "$OS" == "debian" ]; then
        apt-get autoremove -y
        if command -v deborphan >/dev/null 2>&1; then
            deborphan | xargs apt-get -y purge 2>/dev/null
        fi
    else
        if command -v dnf >/dev/null 2>&1; then
            dnf autoremove -y
        else
            package-cleanup --leaves -y 2>/dev/null
        fi
    fi
}

clean_old_kernels() {
    echo -e "${YELLOW}警告: 正在准备清理旧内核...${NC}"
    current_kernel=$(uname -r)
    if [ "$OS" == "debian" ]; then
        kernel_pkgs=$(dpkg-query -W -f='${Package}\n' 'linux-image-[0-9]*' 'linux-headers-[0-9]*' | grep -v "$current_kernel")
        [ -n "$kernel_pkgs" ] && echo "$kernel_pkgs" | xargs apt-get -y purge || echo "没有可清理的旧内核。"
    else
        if command -v dnf >/dev/null 2>&1; then
            dnf remove -y $(dnf repoquery --installonly --latest-limit=-1 -q) 2>/dev/null
        else
            package-cleanup --oldkernels --count=1 -y 2>/dev/null
        fi
    fi
}

# 2. 日志与报告功能
clean_logs_journal() {
    echo -e "${BLUE}正在压缩系统日志 (保留7天)...${NC}"
    journalctl --vacuum-time=7d 2>/dev/null
}

clean_logs_var() {
    echo -e "${BLUE}正在清理 /var/log 过期日志...${NC}"
    find /var/log -name "*.gz" -type f -mtime +7 -delete 2>/dev/null
    find /var/log -name "*.old" -type f -mtime +7 -delete 2>/dev/null
    find /var/log -name "*.[0-9]" -type f -mtime +7 -delete 2>/dev/null
    find /var/log -name "*.log" -type f -mtime +30 -delete 2>/dev/null
}

clean_reports() {
    echo -e "${BLUE}正在清理崩溃报告...${NC}"
    rm -rf /var/crash/*
    [ "$OS" == "debian" ] && rm -rf /var/lib/apport/crash/* || rm -rf /var/spool/abrt/*
}

# 3. 临时文件与缓存功能
clean_temp_dirs() {
    echo -e "${BLUE}正在清理临时文件夹...${NC}"
    rm -rf /tmp/* 2>/dev/null
    rm -rf /var/tmp/* 2>/dev/null
    find /tmp -type d -empty -delete 2>/dev/null
}

clean_user_cache() {
    echo -e "${BLUE}正在清理用户缩略图与浏览器缓存...${NC}"
    find /home /root -type d -name ".thumbnails" -exec rm -rf {}/* \; 2>/dev/null
    find /home /root -type d -name "mozilla" -exec rm -rf {}/.cache/mozilla/* \; 2>/dev/null
    find /home /root -type d -name "google-chrome" -exec rm -rf {}/.cache/google-chrome/* \; 2>/dev/null
}

drop_sys_memory() {
    echo -e "${YELLOW}正在释放系统内存缓存...${NC}"
    sync && echo 3 > /proc/sys/vm/drop_caches
}

# -----------------------------------------------------------------
# 二级菜单逻辑 (Sub-Menus)
# -----------------------------------------------------------------

menu_pkg() {
    while true; do
        echo -e "\n${CYAN}--- [1] 软件包管理清理 ---${NC}"
        echo "1.1) 清理包管理器缓存"
        echo "1.2) 移除孤立/不再需要的依赖包"
        echo "1.3) [慎用] 卸载旧内核"
        echo "1.4) 更新软件包列表索引"
        echo "0)   返回主菜单"
        read -p "请选择操作 [0-1.4]: " sub_opt
        case $sub_opt in
            1.1) clean_pkgs_cache ;;
            1.2) clean_pkgs_unused ;;
            1.3) clean_old_kernels ;;
            1.4) [ "$OS" == "debian" ] && apt-get update || yum makecache ;;
            0) break ;;
            *) echo -e "${RED}无效选项${NC}" ;;
        esac
    done
}

menu_log() {
    while true; do
        echo -e "\n${CYAN}--- [2] 日志与报告清理 ---${NC}"
        echo "2.1) 压缩/限制系统日志大小 (7天)"
        echo "2.2) 清理 /var/log 过期压缩日志"
        echo "2.3) 清理系统崩溃报告"
        echo "2.4) 截断(清空)当前活动日志"
        echo "0)   返回主菜单"
        read -p "请选择操作 [0-2.4]: " sub_opt
        case $sub_opt in
            2.1) clean_logs_journal ;;
            2.2) clean_logs_var ;;
            2.3) clean_reports ;;
            2.4) truncate -s 0 /var/log/*.log 2>/dev/null && echo "日志已截断" ;;
            0) break ;;
            *) echo -e "${RED}无效选项${NC}" ;;
        esac
    done
}

menu_temp() {
    while true; do
        echo -e "\n${CYAN}--- [3] 临时文件与缓存 ---${NC}"
        echo "3.1) 清理 /tmp 与 /var/tmp 临时文件夹"
        echo "3.2) 清理用户缩略图与浏览器缓存"
        echo "3.3) 清理磁盘备份后缀文件 (.bak/.swp)"
        echo "3.4) [高级] 释放系统内存缓存"
        echo "0)   返回主菜单"
        read -p "请选择操作 [0-3.4]: " sub_opt
        case $sub_opt in
            3.1) clean_temp_dirs ;;
            3.2) clean_user_cache ;;
            3.3) find /home /tmp -name "*.bak" -o -name "*.swp" -type f -delete 2>/dev/null ;;
            3.4) drop_sys_memory ;;
            0) break ;;
            *) echo -e "${RED}无效选项${NC}" ;;
        esac
    done
}

# 一键深度清理逻辑 (原脚本逻辑)
full_cleanup() {
    echo -e "${YELLOW}⚠️ 警告：即将执行全自动深度清理，将运行所有清理模块！${NC}"
    read -p "确认继续？(y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        clean_pkgs_cache
        clean_pkgs_unused
        clean_old_kernels
        clean_logs_journal
        clean_logs_var
        clean_reports
        clean_temp_dirs
        clean_user_cache
        drop_sys_memory
        echo -e "${GREEN}✅ 深度清理完成！${NC}"
        df -h / | tail -1 | awk '{print "当前根分区可用空间: " $4}'
    else
        echo -e "${BLUE}操作已取消。${NC}"
    fi
}

# -----------------------------------------------------------------
# 一级主菜单 (Main Menu)
# -----------------------------------------------------------------

main_menu() {
    while true; do
        clear
        echo -e "${CYAN}=========================================="
        echo "          Linux 系统清理助手 v2.0"
        echo -e "==========================================${NC}"
        echo -e "1) 📦 软件包管理清理 (Cache/Packages)"
        echo -e "2) 📝 日志与报告清理 (Logs/Reports)"
        echo -e "3) 🧹 临时文件与缓存 (Temp/Caches)"
        echo -e "4) 🚀 执行全自动深度清理 (一键清理)"
        echo -e "0) ↩️ 退出程序"
        echo -e "${CYAN}==========================================${NC}"
        read -p "请输入选项 [0-4]: " main_opt

        case $main_opt in
            1) menu_pkg ;;
            2) menu_log ;;
            3) menu_temp ;;
            4) full_cleanup; read -p "按回车键继续..." ;;
            0) echo -e "${GREEN}感谢使用，再见！${NC}"; exit 0 ;;
            *) echo -e "${RED}无效输入，请重新选择。${NC}"; sleep 1 ;;
        esac
    done
}
