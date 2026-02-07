#!/bin/bash

# 系统信息查询功能 - 完整版本
function system_info_full() {
    clear
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${GREEN}               系统信息查询${NC}"
    echo -e "${CYAN}==============================================${NC}"
    echo ""
    
    # 1. 主机名
    echo -e "${YELLOW}--- 主机信息 ---${NC}"
    echo "主机名: $(hostname)"
    echo "系统时间: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "运行时长: $(uptime -p | sed 's/up //')"
    echo ""
    
    # 2. 系统版本信息
    echo -e "${YELLOW}--- 操作系统信息 ---${NC}"
    OS_NAME="无法获取"
    OS_VERSION="无法获取"
    
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        OS_NAME="$NAME"
        OS_VERSION="$VERSION"
    elif [ -f /etc/redhat-release ]; then
        OS_NAME=$(cat /etc/redhat-release)
        OS_VERSION=""
    elif [ -f /etc/centos-release ]; then
        OS_NAME=$(cat /etc/centos-release)
        OS_VERSION=""
    fi
    
    echo "系统版本: $OS_NAME $OS_VERSION"
    echo "Linux内核: $(uname -r)"
    echo ""
    
    # 3. CPU信息
    echo -e "${YELLOW}--- CPU信息 ---${NC}"
    CPU_ARCH=$(uname -m)
    echo "CPU架构: $CPU_ARCH"
    
    CPU_MODEL=$(lscpu | grep 'Model name' | awk -F': ' '{print $2}' | sed 's/^[ \t]*//')
    if [ -z "$CPU_MODEL" ]; then
        CPU_MODEL=$(grep -m1 'model name' /proc/cpuinfo | awk -F': ' '{print $2}')
    fi
    echo "CPU型号: $CPU_MODEL"
    
    CPU_CORES=$(nproc)
    echo "CPU核心数: $CPU_CORES"
    
    CPU_FREQ=$(lscpu | grep 'CPU MHz' | awk '{printf "%.2f GHz", $3/1000}')
    if [ -z "$CPU_FREQ" ]; then
        CPU_FREQ=$(grep -m1 'cpu MHz' /proc/cpuinfo | awk '{printf "%.2f GHz", $3/1000}')
    fi
    echo "CPU频率: $CPU_FREQ"
    
    # 使用top获取CPU使用率
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%.1f%%", $2 + $4}')
    echo "CPU占用: $CPU_USAGE"
    
    LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//')
    echo "系统负载: $LOAD_AVG"
    echo ""
    
    # 4. 内存信息
    echo -e "${YELLOW}--- 内存信息 ---${NC}"
    MEM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
    MEM_USED=$(free -h | grep Mem | awk '{print $3}')
    MEM_FREE=$(free -h | grep Mem | awk '{print $4}')
    MEM_USAGE_PERCENT=$(free | grep Mem | awk '{printf "%.1f%%", $3/$2*100}')
    
    echo "物理内存: $MEM_USED/$MEM_TOTAL ($MEM_USAGE_PERCENT)"
    echo "可用内存: $MEM_FREE"
    
    SWAP_TOTAL=$(free -h | grep Swap | awk '{print $2}')
    SWAP_USED=$(free -h | grep Swap | awk '{print $3}')
    SWAP_FREE=$(free -h | grep Swap | awk '{print $4}')
    if [ "$SWAP_TOTAL" != "0B" ] && [ "$SWAP_TOTAL" != "0" ]; then
        SWAP_USAGE_PERCENT=$(free | grep Swap | awk '{printf "%.1f%%", $3/$2*100}')
        echo "虚拟内存: $SWAP_USED/$SWAP_TOTAL ($SWAP_USAGE_PERCENT)"
    else
        echo "虚拟内存: 未启用"
    fi
    echo ""
    
    # 5. 磁盘信息
    echo -e "${YELLOW}--- 磁盘信息 ---${NC}"
    DISK_USAGE=$(df -h / | awk 'NR==2 {printf "%s/%s (%.1f%%)", $3, $2, $5}')
    echo "根分区占用: $DISK_USAGE"
    
    # 总磁盘使用情况
    DISK_TOTAL=$(df -h --total | grep total | awk '{print $2}')
    DISK_USED=$(df -h --total | grep total | awk '{print $3}')
    DISK_USAGE_PERCENT=$(df -h --total | grep total | awk '{print $5}')
    echo "总硬盘占用: $DISK_USED/$DISK_TOTAL ($DISK_USAGE_PERCENT)"
    echo ""
    
    # 6. 网络连接信息
    echo -e "${YELLOW}--- 网络连接 ---${NC}"
    TCP_CONNECTIONS=$(ss -t | grep -v State | wc -l)
    UDP_CONNECTIONS=$(ss -u | grep -v State | wc -l)
    echo "TCP连接数: $TCP_CONNECTIONS"
    echo "UDP连接数: $UDP_CONNECTIONS"
    echo ""
    
    # 7. 网络流量信息
    echo -e "${YELLOW}--- 网络流量 ---${NC}"
    # 获取网络接口
    NET_INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)
    if [ -n "$NET_INTERFACE" ]; then
        # 获取总接收和发送流量
        RX_BYTES=$(cat /sys/class/net/$NET_INTERFACE/statistics/rx_bytes 2>/dev/null)
        TX_BYTES=$(cat /sys/class/net/$NET_INTERFACE/statistics/tx_bytes 2>/dev/null)
        
        if [ -n "$RX_BYTES" ] && [ -n "$TX_BYTES" ]; then
            # 转换为易读格式
            RX_READABLE=$(echo $RX_BYTES | awk '
                function human(x) {
                    if (x<1000) {return x" B"}
                    else if (x<1000*1000) {return x/1000" KB"}
                    else if (x<1000*1000*1000) {return x/(1000*1000)" MB"}
                    else {return x/(1000*1000*1000)" GB"}
                }
                {print human($1)}')
            
            TX_READABLE=$(echo $TX_BYTES | awk '
                function human(x) {
                    if (x<1000) {return x" B"}
                    else if (x<1000*1000) {return x/1000" KB"}
                    else if (x<1000*1000*1000) {return x/(1000*1000)" MB"}
                    else {return x/(1000*1000*1000)" GB"}
                }
                {print human($1)}')
            
            echo "总接收流量: $RX_READABLE"
            echo "总发送流量: $TX_READABLE"
        else
            echo "总接收流量: 无法获取"
            echo "总发送流量: 无法获取"
        fi
    else
        echo "总接收流量: 无法获取"
        echo "总发送流量: 无法获取"
    fi
    echo ""
    
    # 8. 网络算法信息
    echo -e "${YELLOW}--- 网络配置 ---${NC}"
    TCP_CONGESTION=$(sysctl net.ipv4.tcp_congestion_control 2>/dev/null | awk '{print $3}')
    echo "TCP拥塞控制算法: ${TCP_CONGESTION:-默认}"
    
    # 检查是否启用了BBR
    if [ "$TCP_CONGESTION" = "bbr" ]; then
        echo "BBR状态: 已启用"
    else
        echo "BBR状态: 未启用"
    fi
    
    DEFAULT_QDISC=$(sysctl net.core.default_qdisc 2>/dev/null | awk '{print $3}')
    echo "队列规则: ${DEFAULT_QDISC:-fq_codel}"
    echo ""
    
    # 9. IP地址和DNS信息
    echo -e "${YELLOW}--- 网络地址 ---${NC}"
    
    # 获取公网IP
    PUBLIC_IP=$(curl -s --connect-timeout 3 ifconfig.me || curl -s --connect-timeout 3 ipinfo.io/ip || echo "无法获取")
    echo "公网IP地址: $PUBLIC_IP"
    
    # 获取内网IP
    LOCAL_IP=$(hostname -I | awk '{print $1}')
    echo "内网IP地址: $LOCAL_IP"
    
    # 获取DNS服务器
    if [ -f /etc/resolv.conf ]; then
        DNS_SERVERS=$(grep -E '^nameserver' /etc/resolv.conf | awk '{print $2}' | tr '\n' ' ')
        echo "DNS服务器: $DNS_SERVERS"
    else
        echo "DNS服务器: 无法获取"
    fi
    echo ""
    
    # 10. 地理位置信息（需要网络）
    echo -e "${YELLOW}--- 地理位置 ---${NC}"
    if [ "$PUBLIC_IP" != "无法获取" ] && [[ ! "$PUBLIC_IP" =~ ^(10\.|172\.(1[6-9]|2[0-9]|3[0-1])\.|192\.168\.) ]]; then
        LOCATION_INFO=$(curl -s --connect-timeout 3 "ipinfo.io/$PUBLIC_IP/json" 2>/dev/null)
        if [ -n "$LOCATION_INFO" ]; then
            COUNTRY=$(echo "$LOCATION_INFO" | grep '"country"' | cut -d'"' -f4)
            CITY=$(echo "$LOCATION_INFO" | grep '"city"' | cut -d'"' -f4)
            ORG=$(echo "$LOCATION_INFO" | grep '"org"' | cut -d'"' -f4)
            
            echo "地理位置: ${CITY:-未知}, ${COUNTRY:-未知}"
            if [ -n "$ORG" ]; then
                echo "运营商: $ORG"
            else
                echo "运营商: 未知"
            fi
        else
            echo "地理位置: 查询失败"
            echo "运营商: 未知"
        fi
    else
        echo "地理位置: 内网地址或无法获取"
        echo "运营商: 未知"
    fi
    echo ""
    
    # 11. 系统性能指标
    echo -e "${YELLOW}--- 系统性能 ---${NC}"
    echo "当前用户: $(whoami)"
    echo "登录用户数: $(who | wc -l)"
    echo "进程总数: $(ps -ef | wc -l)"
    
    # 显示系统负载详情
    echo "系统负载详情:"
    echo "  最近1分钟: $(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}')"
    echo "  最近5分钟: $(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $2}')"
    echo "  最近15分钟: $(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $3}')"
    echo ""
    
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${GREEN}           报告生成时间: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "${CYAN}==============================================${NC}"
    
    read -p "按回车键返回..."
}