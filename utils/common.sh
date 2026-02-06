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
