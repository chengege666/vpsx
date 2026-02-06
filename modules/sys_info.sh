#!/bin/bash

# 系统信息查询模块
function system_info_query() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          系统信息查询${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo ""
    echo -e "${YELLOW}--- 操作系统信息 ---${NC}"
    OS_NAME="无法获取操作系统信息"
    if [ -f /etc/os-release ]; then
        OS_NAME=$(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | sed 's/"//g')
    elif type lsb_release >/dev/null 2>&1; then
        OS_NAME=$(lsb_release -d | cut -f2)
    fi
    echo "操作系统: $OS_NAME"
    echo "内核版本: $(uname -r)"
    echo "系统架构: $(uname -m)"
    GLIBC_VERSION=$(ldd --version 2>&1 | head -n 1 | awk '{print $NF}')
    if [ -z "$GLIBC_VERSION" ]; then
        echo "GLIBC 版本: N/A"
    else
        echo "GLIBC 版本: $GLIBC_VERSION"
    fi
    echo ""
    echo -e "${YELLOW}--- CPU 信息 ---${NC}"
    CPU_MODEL=$(lscpu | grep 'Model name' | sed 's/Model name: *//')
    [ -z "$CPU_MODEL" ] && CPU_MODEL=$(grep 'model name' /proc/cpuinfo | head -n 1 | cut -d':' -f2 | sed 's/^ //')
    echo "CPU 型号: $CPU_MODEL"
    echo "CPU 核心数: $(grep -c ^processor /proc/cpuinfo)"
    echo ""
    echo -e "${YELLOW}--- 内存信息 ---${NC}"
    free -h | grep -E 'Mem|Swap'
    echo ""
    echo -e "${YELLOW}--- 磁盘使用情况 ---${NC}"
    df -h / | grep -v Filesystem
    echo ""
    echo -e "${YELLOW}--- 网络信息 ---${NC}"
    echo "IP 地址: $(ip a | grep -E 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d'/' -f1 | head -n 1)"
    echo "BBR 拥塞控制: $(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')"
    QDISC_INFO=$(sysctl net.core.default_qdisc 2>/dev/null | awk '{print $3}')
    if [ -z "$QDISC_INFO" ]; then
        echo "队列规则: N/A"
    else
        echo "队列规则: $QDISC_INFO"
    fi
    echo ""
    echo -e "${YELLOW}--- 系统运行时间 ---${NC}"
    uptime | awk '{print $3,$4}' | sed 's/,//'
    echo ""
}
