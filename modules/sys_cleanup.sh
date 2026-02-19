#!/bin/bash

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

function system_cleanup() {
    # 检查 root 权限
    if [[ $EUID -ne 0 ]]; then
       echo -e "${RED}错误: 必须使用 root 权限运行此脚本。${NC}"
       exit 1
    fi

    clear
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}          系统深度清理工具 (增强版)        ${NC}"
    echo -e "${CYAN}==========================================${NC}"
    
    echo -e "${YELLOW}⚠️  警告：此操作将清理系统缓存、旧内核和残留配置。${NC}"
    read -p "是否继续执行系统清理？(y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then 
        echo -e "${YELLOW}已取消操作${NC}"
        return
    fi

    # 记录初始磁盘空间
    OLD_DISK_SPACE=$(df / | tail -1 | awk '{print $4}')

    if [ -f /etc/debian_version ]; then
        echo -e "${BLUE}[1/2] 检测到 Debian/Ubuntu 系统，开始深度清理...${NC}"
        
        # 1. 修复可能损坏的列表
        if [ -f /etc/apt/sources.list.d/docker.list ]; then
            mv /etc/apt/sources.list.d/docker.list /etc/apt/sources.list.d/docker.list.bak 2>/dev/null
        fi

        # 2. 包管理器深度清理
        echo -e "${YELLOW}-> 正在清理软件包和残留配置...${NC}"
        apt update -qq
        apt autoremove --purge -y  # 自动移除并删除配置文件
        apt clean -y
        apt autoclean -y
        
        # 清除已卸载但保留了配置文件的包 (状态为 rc 的包)
        RC_PACKAGES=$(dpkg -l | awk '/^rc/ {print $2}')
        if [ -n "$RC_PACKAGES" ]; then
            echo -e "${YELLOW}-> 清除残留配置文件: $RC_PACKAGES${NC}"
            apt purge -y $RC_PACKAGES
        fi

        # 使用 deborphan 清理孤立包
        if ! command -v deborphan >/dev/null 2>&1; then
            apt install -y deborphan -qq
        fi
        deborphan | xargs -r apt -y purge

        # 3. 旧内核清理 (保留当前内核)
        echo -e "${YELLOW}-> 正在清理旧内核...${NC}"
        CURRENT_KERNEL=$(uname -r | sed 's/-.*//')
        KERNEL_PKGS=$(dpkg -l | awk '/^ii  linux-(image|headers)-[^ ]+/ {print $2}' | grep -v "$CURRENT_KERNEL")
        if [ -n "$KERNEL_PKGS" ]; then
            apt purge -y $KERNEL_PKGS
        fi

        # 4. 日志清理 (极致压缩)
        echo -e "${YELLOW}-> 正在滚动并清理系统日志...${NC}"
        journalctl --rotate
        journalctl --vacuum-time=1d
        journalctl --vacuum-size=50M

    elif [ -f /etc/redhat-release ]; then
        echo -e "${BLUE}[1/2] 检测到 CentOS/RHEL 系统，开始深度清理...${NC}"
        
        if command -v dnf >/dev/null 2>&1; then
            dnf clean all
            dnf autoremove -y
        else
            yum clean all
            package-cleanup --oldkernels --count=1 -y
            package-cleanup --leaves -y
        fi
        
        journalctl --rotate
        journalctl --vacuum-time=1d
        journalctl --vacuum-size=50M
    fi

    # 通用清理步骤 (所有系统)
    echo -e "${BLUE}[2/2] 执行通用垃圾清理...${NC}"

    # 1. 临时文件清理 (安全清理：只删1天前的，不删 socket)
    echo -e "${YELLOW}-> 清理临时目录 (/tmp)...${NC}"
    find /tmp -type f -atime +1 -delete 2>/dev/null
    find /var/tmp -type f -atime +1 -delete 2>/dev/null

    # 2. 缓存清理
    echo -e "${YELLOW}-> 清理缩略图和浏览器缓存...${NC}"
    find /home /root -type d -name ".thumbnails" -exec rm -rf {}/* + 2>/dev/null
    find /home /root -type d -path "*/.cache/mozilla/*" -delete 2>/dev/null
    find /home /root -type d -path "*/.cache/google-chrome/*" -delete 2>/dev/null

    # 3. 崩溃报告清理
    rm -rf /var/crash/*
    rm -rf /var/lib/apport/crash/* 2>/dev/null

    # 4. 释放系统内存缓存 (Buffer/Cache)
    echo -e "${YELLOW}-> 释放系统内存缓存...${NC}"
    sync && echo 3 > /proc/sys/vm/drop_caches

    # 结果统计
    NEW_DISK_SPACE=$(df / | tail -1 | awk '{print $4}')
    FREED_SPACE=$(( (NEW_DISK_SPACE - OLD_DISK_SPACE) / 1024 ))

    echo ""
    echo -e "${GREEN}==========================================${NC}"
    echo -e "${GREEN}✅ 系统清理完成！${NC}"
    if [ "$FREED_SPACE" -gt 0 ]; then
        echo -e "${GREEN}本次大约释放了: ${FREED_SPACE} MB 磁盘空间${NC}"
    else
        echo -e "${GREEN}磁盘已处于较好状态。${NC}"
    fi
    df -h / | tail -1 | awk '{print "当前根分区可用空间: " $4}'
    echo -e "${GREEN}==========================================${NC}"
}
