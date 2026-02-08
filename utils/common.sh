#!/bin/bash

# 通用安装函数
# 参数: $1 - 软件包名称
install_package() {
    local pkg=$1
    if command -v "$pkg" >/dev/null 2>&1; then
        echo -e "${GREEN}[已安装]${NC} $pkg 已经存在。"
    else
        echo -e "${YELLOW}[安装中]${NC} 正在安装 $pkg..."
        if command -v apt >/dev/null 2>&1; then
            sudo apt update && sudo apt install -y "$pkg"
        elif command -v yum >/dev/null 2>&1; then
            sudo yum install -y "$pkg"
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y "$pkg"
        else
            echo -e "${RED}[错误]${NC} 未能识别包管理器，请手动安装 $pkg。"
            return 1
        fi
        
        if command -v "$pkg" >/dev/null 2>&1; then
            echo -e "${GREEN}[成功]${NC} $pkg 安装完成。"
        else
            echo -e "${RED}[失败]${NC} $pkg 安装失败，请检查网络或包源。"
        fi
    fi
    sleep 1
}

# 获取访问 IP (优先公网 IPv4 -> 内网 IPv4, 优先公网 IPv6 -> 内网 IPv6)
function get_access_ips() {
    local ipv4=""
    local ipv6=""

    # 1. 获取 IPv4
    # 优先公网 IPv4
    ipv4=$(curl -4 -s --connect-timeout 2 ifconfig.me 2>/dev/null || curl -4 -s --connect-timeout 2 ipv4.icanhazip.com 2>/dev/null)
    # 严格校验 IPv4 格式，防止混入 IPv6
    if [[ ! "$ipv4" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        ipv4=""
    fi

    # 若公网获取失败，则获取内网 IPv4
    if [ -z "$ipv4" ]; then
        ipv4=$(hostname -I 2>/dev/null | tr ' ' '\n' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -n1)
    fi
    
    # 2. 获取 IPv6
    # 优先公网 IPv6
    ipv6=$(curl -6 -s --connect-timeout 2 ifconfig.me 2>/dev/null || curl -6 -s --connect-timeout 2 ipv6.icanhazip.com 2>/dev/null)
    # 校验 IPv6 格式 (简单检查是否包含冒号)
    if [[ ! "$ipv6" =~ : ]]; then
        ipv6=""
    fi

    # 若公网获取失败，则获取内网 IPv6 (全球单播地址 2000::/3)
    if [ -z "$ipv6" ]; then
        ipv6=$(ip -6 addr show 2>/dev/null | grep -E 'inet6 [23]' | awk '{print $2}' | cut -d/ -f1 | head -n1)
    fi
    
    echo "$ipv4|$ipv6"
}
