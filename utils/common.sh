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
        elif command -v apk >/dev/null 2>&1; then
            apk update && apk add "$pkg"
        else
            echo -e "${RED}[错误]${NC} 未能识别包管理器，请手动安装 $pkg。"
            return 1
        fi
        
        # 安装命令执行成功即视为成功（部分包无可执行文件，如 tzdata，command -v 会误判失败）
        if [ $? -eq 0 ] || command -v "$pkg" >/dev/null 2>&1; then
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
    # BusyBox 的 hostname 不支持 -I (Alpine)，改用 ip 命令回退
    if [ -z "$ipv4" ]; then
        ipv4=$(ip -4 addr show 2>/dev/null | grep -oE 'inet [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | awk '{print $2}' | grep -vE '^(127\.|169\.254\.)' | head -n1)
    fi
    
    # 2. 获取 IPv6
    # 优先公网 IPv6
    ipv6=$(curl -6 -s --connect-timeout 1 ifconfig.me 2>/dev/null || curl -6 -s --connect-timeout 1 ipv6.icanhazip.com 2>/dev/null)
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

# Alpine 拦截辅助：Alpine (OpenRC) 下返回 0 并输出提示，用于拦截依赖 systemd 的功能
function alpine_block() {
    if grep -qi alpine /etc/os-release 2>/dev/null; then
        echo -e "${RED}此功能依赖 systemd，Alpine 系统暂不支持。${NC}"
        return 0
    fi
    return 1
}
