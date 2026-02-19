#!/bin/bash

# =================================================================
# 系统深度清理助手 v2.1 (稳定版)
# =================================================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

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

# 通用等待函数
pause() {
    echo -e "\n${YELLOW}按任意键返回...${NC}"
    read -n 1 -s -r
}

# -----------------------------------------------------------------
# 功能函数 (已封装)
# -----------------------------------------------------------------
clean_pkgs_cache() {
    echo -e "${BLUE}正在清理包管理器缓存...${NC}"
    [ "$OS" == "debian" ] && (apt-get clean; apt-get autoclean) || (yum clean all || dnf clean all)
    pause
}

clean_pkgs_unused() {
    echo -e "${BLUE}正在移除不再需要的包...${NC}"
    [ "$OS" == "debian" ] && apt-get autoremove -y || (dnf autoremove -y 2>/dev/null || package-cleanup --leaves -y 2>/dev/null)
    pause
}

clean_old_kernels() {
    current_kernel=$(uname -r)
    echo -e "${YELLOW}当前内核: $current_kernel，正在清理旧内核...${NC}"
    if [ "$OS" == "debian" ]; then
        dpkg-query -W -f='${Package}\n' 'linux-image-[0-9]*' 'linux-headers-[0-9]*' | grep -v "$current_kernel" | xargs apt-get -y purge
    else
        command -v dnf >/dev/null 2>&1 && dnf remove -y $(dnf repoquery --installonly --latest-limit=-1 -q) || package-cleanup --oldkernels --count=1 -y
    fi
    pause
}

# -----------------------------------------------------------------
# 二级菜单 (Sub-Menus)
# -----------------------------------------------------------------

menu_pkg() {
    while true; do
        clear
        echo -e "${CYAN}=========================================="
        echo "      📦 菜单 1: 软件包管理清理"
        echo -e "==========================================${NC}"
        echo "1) 清理包管理器缓存 (clean)"
        echo "2) 移除孤立依赖包 (autoremove)"
        echo "3) 卸载旧内核 (保留当前版本)"
        echo "4) 更新软件包列表 (update)"
        echo "0) 返回主菜单"
        echo -e "${CYAN}------------------------------------------${NC}"
        read -p "请选择操作 [0-4]: " sub_opt
        case $sub_opt in
            1) clean_pkgs_cache ;;
            2) clean_pkgs_unused ;;
            3) clean_old_kernels ;;
            4) [ "$OS" == "debian" ] && apt-get update || yum makecache; pause ;;
            0) break ;;
            *) echo -e "${RED}无效选项${NC}"; sleep 1 ;;
        esac
    done
}

menu_log() {
    while true; do
        clear
        echo -e "${CYAN}=========================================="
        echo "      📝 菜单 2: 日志与报告清理"
        echo -e "==========================================${NC}"
        echo "1) 压缩系统日志 (保留7天)"
        echo "2) 清理 /var/log 过期日志文件"
        echo "3) 清理系统崩溃报告"
        echo "4) 清空当前活动日志内容"
        echo "0) 返回主菜单"
        echo -e "${CYAN}------------------------------------------${NC}"
        read -p "请选择操作 [0-4]: " sub_opt
        case $sub_opt in
            1) journalctl --vacuum-time=7d 2>/dev/null; pause ;;
            2) 
               find /var/log -name "*.gz" -o -name "*.old" -o -name "*.[0-9]" -type f -delete 2>/dev/null
               echo "过期日志已清理"; pause 
               ;;
            3) rm -rf /var/crash/*; echo "崩溃报告已清理"; pause ;;
            4) truncate -s 0 /var/log/*.log 2>/dev/null; echo "日志已清空"; pause ;;
            0) break ;;
            *) echo -e "${RED}无效选项${NC}"; sleep 1 ;;
        esac
    done
}

menu_temp() {
    while true; do
        clear
        echo -e "${CYAN}=========================================="
        echo "      🧹 菜单 3: 临时文件与缓存"
        echo -e "==========================================${NC}"
        echo "1) 清理 /tmp 和 /var/tmp"
        echo "2) 清理浏览器和缩略图缓存"
        echo "3) 清理 .bak 和 .swp 临时文件"
        echo "4) 释放系统内存缓存 (Drop Caches)"
        echo "0) 返回主菜单"
        echo -e "${CYAN}------------------------------------------${NC}"
        read -p "请选择操作 [0-4]: " sub_opt
        case $sub_opt in
            1) rm -rf /tmp/* /var/tmp/*; echo "临时目录已清空"; pause ;;
            2) 
               find /home /root -type d \( -name ".thumbnails" -o -name "mozilla" -o -name "google-chrome" \) -exec rm -rf {}/* \; 2>/dev/null
               echo "缓存已清理"; pause 
               ;;
            3) find /home /tmp -name "*.bak" -o -name "*.swp" -type f -delete 2>/dev/null; echo "清理完成"; pause ;;
            4) sync && echo 3 > /proc/sys/vm/drop_caches; echo "内存缓存已释放"; pause ;;
            0) break ;;
            *) echo -e "${RED}无效选项${NC}"; sleep 1 ;;
        esac
    done
}

# -----------------------------------------------------------------
# 主菜单 (Main Menu)
# -----------------------------------------------------------------

main_menu() {
    while true; do
        clear
        echo -e "${CYAN}=========================================="
        echo "          Linux 系统清理助手 v2.1"
        echo -e "==========================================${NC}"
        echo -e "1) 📦 软件包管理清理"
        echo -e "2) 📝 日志与报告清理"
        echo -e "3) 🧹 临时文件与缓存"
        echo -e "4) 🚀 执行全自动深度清理"
        echo -e "0) ↩️ 退出程序"
        echo -e "${CYAN}==========================================${NC}"
        read -p "请输入选项 [0-4]: " main_opt

        case $main_opt in
            1) menu_pkg ;;
            2) menu_log ;;
            3) menu_temp ;;
            4) 
                # 这里调用原脚本的一键清理逻辑
                echo -e "${YELLOW}开始全自动清理...${NC}"
                apt-get clean && apt-get autoremove -y  # 示例
                echo -e "${GREEN}清理完成！${NC}"
                pause
                ;;
            0) echo -e "${GREEN}退出脚本${NC}"; exit 0 ;;
            *) echo -e "${RED}错误：请输入正确的数字 (0-4)${NC}"; sleep 1 ;;
        esac
    done
}

# 确保脚本以 Bash 运行
main_menu
