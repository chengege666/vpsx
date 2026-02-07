#!/bin/bash

# 系统信息查询功能 - 完整版本
function system_info_query() {
    clear
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${GREEN}               系统信息查询${NC}"
    echo -e "${CYAN}==============================================${NC}"

    # 1. 基础信息
    echo -e "${YELLOW}[ 基础信息 ]${NC}"
    echo -e "${GREEN}主机名:${NC} ${SKYBLUE}$(hostname)${NC}"
    
    # 系统版本
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        OS_NAME="$PRETTY_NAME"
    else
        OS_NAME=$(cat /etc/issue | head -n1 | awk '{print $1,$2,$3}')
    fi
    echo -e "${GREEN}系统版本：${NC}${SKYBLUE}$OS_NAME${NC}"
    echo -e "${GREEN}Linux版本：${NC}${SKYBLUE}$(uname -sr)${NC}"
    echo -e "${GREEN}系统时间：${NC}${SKYBLUE}$(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "${GREEN}运行时长：${NC}${SKYBLUE}$(uptime -p | sed 's/up //')${NC}"
    echo ""

    # 2. CPU信息
    echo -e "${YELLOW}[ CPU信息 ]${NC}"
    echo -e "${GREEN}CPU架构:${NC} ${SKYBLUE}$(uname -m)${NC}"
    
    CPU_MODEL=$(lscpu | grep 'Model name' | awk -F': ' '{print $2}' | sed 's/^[ \t]*//')
    [ -z "$CPU_MODEL" ] && CPU_MODEL=$(grep -m1 'model name' /proc/cpuinfo | awk -F': ' '{print $2}')
    echo -e "${GREEN}CPU型号:${NC} ${SKYBLUE}$CPU_MODEL${NC}"
    
    echo -e "${GREEN}CPU核心数：${NC}${SKYBLUE}$(nproc)${NC}"
    
    CPU_FREQ=$(lscpu | grep -E "MHz" | head -n1 | awk -F: '{print $2}' | sed 's/[[:space:]]//g')
    if [ -n "$CPU_FREQ" ]; then
        CPU_FREQ=$(awk "BEGIN {printf \"%.2f GHz\", $CPU_FREQ/1000}")
    else
        CPU_FREQ=$(grep -m1 'cpu MHz' /proc/cpuinfo | awk -F: '{print $2}' | sed 's/[[:space:]]//g')
        if [ -n "$CPU_FREQ" ]; then
            CPU_FREQ=$(awk "BEGIN {printf \"%.2f GHz\", $CPU_FREQ/1000}")
        else
            CPU_FREQ="无法获取"
        fi
    fi
    echo -e "${GREEN}CPU频率：${NC}${SKYBLUE}$CPU_FREQ${NC}"
    
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%.1f%%", $2 + $4}')
    echo -e "${GREEN}CPU占用:${NC} ${SKYBLUE}$CPU_USAGE${NC}"
    
    LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//')
    echo -e "${GREEN}系统负载：${NC}${SKYBLUE}$LOAD_AVG${NC}"
    echo ""

    # 3. 内存与磁盘
    echo -e "${YELLOW}[ 存储信息 ]${NC}"
    MEM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
    MEM_USED=$(free -h | grep Mem | awk '{print $3}')
    MEM_USAGE_PERCENT=$(free | grep Mem | awk '{printf "%.1f%%", $3/$2*100}')
    echo -e "${GREEN}物理内存：${NC}${SKYBLUE}$MEM_USED / $MEM_TOTAL ($MEM_USAGE_PERCENT)${NC}"
    
    SWAP_TOTAL=$(free -h | grep Swap | awk '{print $2}')
    SWAP_USED=$(free -h | grep Swap | awk '{print $3}')
    if [ "$SWAP_TOTAL" != "0B" ] && [ "$SWAP_TOTAL" != "0" ] && [ -n "$SWAP_TOTAL" ]; then
        SWAP_USAGE_PERCENT=$(free | grep Swap | awk '{printf "%.1f%%", $3/$2*100}')
        echo -e "${GREEN}虚拟内存：${NC}${SKYBLUE}$SWAP_USED / $SWAP_TOTAL ($SWAP_USAGE_PERCENT)${NC}"
    else
        echo -e "${GREEN}虚拟内存：${NC}${SKYBLUE}未启用${NC}"
    fi
    
    DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
    DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
    DISK_USAGE_PERCENT=$(df -h / | awk 'NR==2 {print $5}')
    echo -e "${GREEN}硬盘占用：${NC}${SKYBLUE}$DISK_USED / $DISK_TOTAL ($DISK_USAGE_PERCENT)${NC}"
    echo ""

    # 4. 网络信息
    echo -e "${YELLOW}[ 网络信息 ]${NC}"
    
    # TCP | UDP 连接数
    TCP_CONN=$(ss -ant | grep ESTAB | wc -l)
    UDP_CONN=$(ss -au | wc -l)
    echo -e "${GREEN}TCP | UDP连接数:${NC} ${SKYBLUE}TCP: $TCP_CONN | UDP: $UDP_CONN${NC}"
    
    # 获取默认网卡流量
    NET_INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)
    if [ -n "$NET_INTERFACE" ]; then
        RX_BYTES=$(cat /sys/class/net/$NET_INTERFACE/statistics/rx_bytes 2>/dev/null)
        TX_BYTES=$(cat /sys/class/net/$NET_INTERFACE/statistics/tx_bytes 2>/dev/null)
        
        function format_bytes() {
            local b=$1
            if [ -z "$b" ] || [ "$b" -eq 0 ] 2>/dev/null; then echo "0 B"; return; fi
            awk -v bytes="$b" 'BEGIN {
                if (bytes < 1024) printf "%d B", bytes
                else if (bytes < 1048576) printf "%.2f KB", bytes/1024
                else if (bytes < 1073741824) printf "%.2f MB", bytes/1048576
                else printf "%.2f GB", bytes/1073741824
            }'
        }
        
        echo -e "${GREEN}总接收:${NC} ${SKYBLUE}$(format_bytes $RX_BYTES)${NC}"
        echo -e "${GREEN}总发送:${NC} ${SKYBLUE}$(format_bytes $TX_BYTES)${NC}"
    else
        echo -e "${GREEN}总接收:${NC} ${SKYBLUE}无法获取${NC}"
        echo -e "${GREEN}总发送:${NC} ${SKYBLUE}无法获取${NC}"
    fi
    
    TCP_CONGESTION=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')
    echo -e "${GREEN}网络算法：${NC}${SKYBLUE}$TCP_CONGESTION${NC}"
    
    DEFAULT_QDISC=$(sysctl net.core.default_qdisc | awk '{print $3}')
    echo -e "${GREEN}队列规则：${NC}${SKYBLUE}${DEFAULT_QDISC:-无法获取}${NC}"
    
    # 公网IP及地理位置 (ipinfo.io 一次请求获取多个信息)
    IP_INFO=$(curl -s --connect-timeout 5 ipinfo.io/json)
    if [ -n "$IP_INFO" ]; then
        IPV4=$(echo "$IP_INFO" | grep '"ip"' | cut -d'"' -f4)
        ISP=$(echo "$IP_INFO" | grep '"org"' | cut -d'"' -f4)
        CITY=$(echo "$IP_INFO" | grep '"city"' | cut -d'"' -f4)
        REGION=$(echo "$IP_INFO" | grep '"region"' | cut -d'"' -f4)
        COUNTRY=$(echo "$IP_INFO" | grep '"country"' | cut -d'"' -f4)
        
        echo -e "${GREEN}运营商：${NC}${SKYBLUE}$ISP${NC}"
        echo -e "${GREEN}IPV4地址：${NC}${SKYBLUE}$IPV4${NC}"
        
        # 尝试获取 IPV6
        IPV6=$(curl -6 -s --connect-timeout 3 ifconfig.me || curl -6 -s --connect-timeout 3 http://ipv6.icanhazip.com)
        [ -n "$IPV6" ] && echo -e "${GREEN}IPV6地址：${NC}${SKYBLUE}$IPV6${NC}"
        
        echo -e "${GREEN}地理位置:${NC} ${SKYBLUE}$CITY, $REGION, $COUNTRY${NC}"
    else
        echo -e "${GREEN}运营商：${NC}${SKYBLUE}无法获取${NC}"
        echo -e "${GREEN}IPV4地址：${NC}${SKYBLUE}$(curl -4 -s --connect-timeout 3 ifconfig.me || echo "无法获取")${NC}"
        echo -e "${GREEN}IPV6地址：${NC}${SKYBLUE}$(curl -6 -s --connect-timeout 3 ifconfig.me || echo "未分配/无法获取")${NC}"
        echo -e "${GREEN}地理位置:${NC} ${SKYBLUE}无法获取${NC}"
    fi
    
    DNS_ADDR=$(grep -E '^nameserver' /etc/resolv.conf | awk '{print $2}' | tr '\n' ' ')
    echo -e "${GREEN}DNS地址:${NC} ${SKYBLUE}${DNS_ADDR:-无法获取}${NC}"
    
    echo ""
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${GREEN}           报告生成时间: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "${CYAN}==============================================${NC}"
}