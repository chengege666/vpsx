#!/bin/bash

# 系统信息查询功能 - 完整版本
function system_info_query() {
    clear
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${GREEN}               系统信息查询${NC}"
    echo -e "${CYAN}==============================================${NC}"

    # 1. 基础信息
    echo -e "${YELLOW}[ 基础信息 ]${NC}"
    echo -e "主机名: ${SKYBLUE}$(hostname)${NC}"
    
    # 系统版本
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        OS_NAME="$PRETTY_NAME"
    else
        OS_NAME=$(cat /etc/issue | head -n1 | awk '{print $1,$2,$3}')
    fi
    echo -e "系统版本：${SKYBLUE}$OS_NAME${NC}"
    echo -e "Linux版本：${SKYBLUE}$(uname -sr)${NC}"
    echo -e "系统时间：${SKYBLUE}$(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "运行时长：${SKYBLUE}$(uptime -p | sed 's/up //')${NC}"
    echo ""

    # 2. CPU信息
    echo -e "${YELLOW}[ CPU信息 ]${NC}"
    echo -e "CPU架构: ${SKYBLUE}$(uname -m)${NC}"
    
    CPU_MODEL=$(lscpu | grep 'Model name' | awk -F': ' '{print $2}' | sed 's/^[ \t]*//')
    [ -z "$CPU_MODEL" ] && CPU_MODEL=$(grep -m1 'model name' /proc/cpuinfo | awk -F': ' '{print $2}')
    echo -e "CPU型号: ${SKYBLUE}$CPU_MODEL${NC}"
    
    echo -e "CPU核心数：${SKYBLUE}$(nproc)${NC}"
    
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
    echo -e "CPU频率：${SKYBLUE}$CPU_FREQ${NC}"
    
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%.1f%%", $2 + $4}')
    echo -e "CPU占用: ${SKYBLUE}$CPU_USAGE${NC}"
    
    LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//')
    echo -e "系统负载：${SKYBLUE}$LOAD_AVG${NC}"
    echo ""

    # 3. 内存与磁盘
    echo -e "${YELLOW}[ 存储信息 ]${NC}"
    MEM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
    MEM_USED=$(free -h | grep Mem | awk '{print $3}')
    MEM_USAGE_PERCENT=$(free | grep Mem | awk '{printf "%.1f%%", $3/$2*100}')
    echo -e "物理内存：${SKYBLUE}$MEM_USED / $MEM_TOTAL ($MEM_USAGE_PERCENT)${NC}"
    
    SWAP_TOTAL=$(free -h | grep Swap | awk '{print $2}')
    SWAP_USED=$(free -h | grep Swap | awk '{print $3}')
    if [ "$SWAP_TOTAL" != "0B" ] && [ "$SWAP_TOTAL" != "0" ] && [ -n "$SWAP_TOTAL" ]; then
        SWAP_USAGE_PERCENT=$(free | grep Swap | awk '{printf "%.1f%%", $3/$2*100}')
        echo -e "虚拟内存：${SKYBLUE}$SWAP_USED / $SWAP_TOTAL ($SWAP_USAGE_PERCENT)${NC}"
    else
        echo -e "虚拟内存：${SKYBLUE}未启用${NC}"
    fi
    
    DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
    DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
    DISK_USAGE_PERCENT=$(df -h / | awk 'NR==2 {print $5}')
    echo -e "硬盘占用：${SKYBLUE}$DISK_USED / $DISK_TOTAL ($DISK_USAGE_PERCENT)${NC}"
    echo ""

    # 4. 网络信息
    echo -e "${YELLOW}[ 网络信息 ]${NC}"
    
    # TCP | UDP 连接数
    TCP_CONN=$(ss -ant | grep ESTAB | wc -l)
    UDP_CONN=$(ss -au | wc -l)
    echo -e "TCP | UDP连接数: ${SKYBLUE}TCP: $TCP_CONN | UDP: $UDP_CONN${NC}"
    
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
        
        echo -e "总接收: ${SKYBLUE}$(format_bytes $RX_BYTES)${NC}"
        echo -e "总发送: ${SKYBLUE}$(format_bytes $TX_BYTES)${NC}"
    else
        echo -e "总接收: ${SKYBLUE}无法获取${NC}"
        echo -e "总发送: ${SKYBLUE}无法获取${NC}"
    fi
    
    TCP_CONGESTION=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')
    echo -e "网络算法：${SKYBLUE}$TCP_CONGESTION${NC}"
    
    DEFAULT_QDISC=$(sysctl net.core.default_qdisc | awk '{print $3}')
    echo -e "队列规则：${SKYBLUE}${DEFAULT_QDISC:-无法获取}${NC}"
    
    # 公网IP及地理位置 (ipinfo.io 一次请求获取多个信息)
    IP_INFO=$(curl -s --connect-timeout 5 ipinfo.io/json)
    if [ -n "$IP_INFO" ]; then
        IPV4=$(echo "$IP_INFO" | grep '"ip"' | cut -d'"' -f4)
        ISP=$(echo "$IP_INFO" | grep '"org"' | cut -d'"' -f4)
        CITY=$(echo "$IP_INFO" | grep '"city"' | cut -d'"' -f4)
        REGION=$(echo "$IP_INFO" | grep '"region"' | cut -d'"' -f4)
        COUNTRY=$(echo "$IP_INFO" | grep '"country"' | cut -d'"' -f4)
        
        echo -e "运营商：${SKYBLUE}$ISP${NC}"
        echo -e "IPV4地址：${SKYBLUE}$IPV4${NC}"
        echo -e "地理位置: ${SKYBLUE}$CITY, $REGION, $COUNTRY${NC}"
    else
        echo -e "运营商：${SKYBLUE}无法获取${NC}"
        echo -e "IPV4地址：${SKYBLUE}$(curl -s --connect-timeout 3 ifconfig.me || echo "无法获取")${NC}"
        echo -e "地理位置: ${SKYBLUE}无法获取${NC}"
    fi
    
    DNS_ADDR=$(grep -E '^nameserver' /etc/resolv.conf | awk '{print $2}' | tr '\n' ' ')
    echo -e "DNS地址: ${SKYBLUE}${DNS_ADDR:-无法获取}${NC}"
    
    echo ""
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${GREEN}           报告生成时间: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "${CYAN}==============================================${NC}"
}