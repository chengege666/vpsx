#!/bin/bash

# 基础工具模块
function basic_tools_menu() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}            基础工具菜单${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC} 安装 htop"
        echo -e " ${GREEN}2.${NC} 安装 wget"
        echo -e " ${GREEN}3.${NC} 安装 curl"
        echo -e " ${GREEN}4.${NC} 安装 git"
        echo -e " ${GREEN}5.${NC} 安装 bzip2"
        echo -e " ${GREEN}6.${NC} 安装 sudo"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC} 返回主菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择(0-6): " basic_tool_choice

        case "$basic_tool_choice" in
            1)
                install_package "htop"
                ;;
            2)
                install_package "wget"
                ;;
            3)
                install_package "curl"
                ;;
            4)
                install_package "git"
                ;;
            5)
                install_bzip2
                ;;
            6)
                install_sudo
                ;;
            0)
                break
                ;;
            *)
                echo -e "${RED}无效的选择，请重新输入！${NC}"
                sleep 2
                ;;
        esac
    done
}

# 安装bzip2函数
function install_bzip2() {
    echo -e "${YELLOW}正在安装 bzip2...${NC}"
    echo "-----------------------------------------"
    
    # 检查是否已安装
    if command -v bzip2 &> /dev/null; then
        local bzip_version=$(bzip2 --version 2>/dev/null | head -n1 | awk '{print $2}' || echo "未知版本")
        echo -e "${GREEN}检测到 bzip2 已安装 (版本 $bzip_version)${NC}"
        echo -e "${CYAN}跳过安装...${NC}"
        sleep 2
        return 0
    fi
    
    # 根据系统类型安装
    if [[ "$package_manager" == "apt" ]]; then
        apt-get update && apt-get install -y bzip2
    elif [[ "$package_manager" == "yum" ]]; then
        yum install -y bzip2
    elif [[ "$package_manager" == "dnf" ]]; then
        dnf install -y bzip2
    elif [[ "$package_manager" == "pacman" ]]; then
        pacman -S --noconfirm bzip2
    elif [[ "$package_manager" == "zypper" ]]; then
        zypper install -y bzip2
    else
        echo -e "${RED}无法识别的包管理器，请手动安装 bzip2${NC}"
        return 1
    fi
    
    # 检查安装结果
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ bzip2 安装成功！${NC}"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e "${YELLOW}使用说明：${NC}"
        echo -e "  压缩文件: ${GREEN}bzip2 文件名${NC}"
        echo -e "  解压文件: ${GREEN}bunzip2 文件名.bz2${NC}"
        echo -e "  查看内容: ${GREEN}bzcat 文件名.bz2${NC}"
        echo -e "  保留原文件压缩: ${GREEN}bzip2 -k 文件名${NC}"
        echo -e "${CYAN}-----------------------------------------${NC}"
    else
        echo -e "${RED}✗ bzip2 安装失败！${NC}"
    fi
    
    read -p "按任意键返回菜单..." -n1 -s
    echo
}

# 安装sudo函数
function install_sudo() {
    echo -e "${YELLOW}正在安装 sudo...${NC}"
    echo "-----------------------------------------"
    
    # 检查是否已安装
    if command -v sudo &> /dev/null; then
        local sudo_version=$(sudo --version | head -n1 | awk '{print $3}' || echo "未知版本")
        echo -e "${GREEN}检测到 sudo 已安装 (版本 $sudo_version)${NC}"
        echo -e "${CYAN}跳过安装...${NC}"
        sleep 2
        return 0
    fi
    
    # 根据系统类型安装
    if [[ "$package_manager" == "apt" ]]; then
        apt-get update && apt-get install -y sudo
    elif [[ "$package_manager" == "yum" ]]; then
        yum install -y sudo
    elif [[ "$package_manager" == "dnf" ]]; then
        dnf install -y sudo
    elif [[ "$package_manager" == "pacman" ]]; then
        pacman -S --noconfirm sudo
    elif [[ "$package_manager" == "zypper" ]]; then
        zypper install -y sudo
    else
        echo -e "${RED}无法识别的包管理器，请手动安装 sudo${NC}"
        return 1
    fi
    
    # 检查安装结果
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ sudo 安装成功！${NC}"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e "${YELLOW}重要配置说明：${NC}"
        echo -e "1. ${GREEN}将用户添加到sudo组：${NC}"
        echo -e "   sudo usermod -aG sudo 用户名"
        echo -e ""
        echo -e "2. ${GREEN}编辑sudoers文件（推荐使用visudo）：${NC}"
        echo -e "   sudo visudo"
        echo -e ""
        echo -e "3. ${GREEN}常用sudoers配置示例：${NC}"
        echo -e "   # 允许wheel组用户无需密码使用sudo"
        echo -e "   %wheel ALL=(ALL) NOPASSWD: ALL"
        echo -e ""
        echo -e "   # 允许特定用户无需密码使用sudo"
        echo -e "   用户名 ALL=(ALL) NOPASSWD: ALL"
        echo -e ""
        echo -e "${RED}注意：配置完成后可能需要重新登录才能生效${NC}"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e "${YELLOW}基本使用：${NC}"
        echo -e "   ${GREEN}sudo 命令${NC} - 以root权限执行命令"
        echo -e "   ${GREEN}sudo -i${NC}    - 切换到root shell"
        echo -e "   ${GREEN}sudo -u 用户 命令${NC} - 以指定用户身份执行"
    else
        echo -e "${RED}✗ sudo 安装失败！${NC}"
    fi
    
    read -p "按任意键返回菜单..." -n1 -s
    echo
}

# 如果install_package函数在其他地方定义，确保已经定义
# 如果没有定义，可以添加一个简单的版本
if ! declare -f install_package >/dev/null; then
    function install_package() {
        local package_name="$1"
        echo -e "${YELLOW}正在安装 $package_name...${NC}"
        
        # 检查是否已安装
        if command -v "$package_name" &> /dev/null; then
            echo -e "${GREEN}检测到 $package_name 已安装，跳过安装...${NC}"
            sleep 2
            return 0
        fi
        
        # 根据系统类型安装
        if [[ "$package_manager" == "apt" ]]; then
            apt-get update && apt-get install -y "$package_name"
        elif [[ "$package_manager" == "yum" ]]; then
            yum install -y "$package_name"
        elif [[ "$package_manager" == "dnf" ]]; then
            dnf install -y "$package_name"
        elif [[ "$package_manager" == "pacman" ]]; then
            pacman -S --noconfirm "$package_name"
        elif [[ "$package_manager" == "zypper" ]]; then
            zypper install -y "$package_name"
        else
            echo -e "${RED}无法识别的包管理器，请手动安装 $package_name${NC}"
            return 1
        fi
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ $package_name 安装成功！${NC}"
        else
            echo -e "${RED}✗ $package_name 安装失败！${NC}"
        fi
        
        sleep 2
    }
fi

# 如果颜色变量未定义，定义它们
if [ -z "$CYAN" ]; then
    CYAN='\033[0;36m'
fi
if [ -z "$GREEN" ]; then
    GREEN='\033[0;32m'
fi
if [ -z "$YELLOW" ]; then
    YELLOW='\033[1;33m'
fi
if [ -z "$RED" ]; then
    RED='\033[0;31m'
fi
if [ -z "$NC" ]; then
    NC='\033[0m' # No Color
fi

# 设置包管理器变量（需要在调用basic_tools_menu之前设置）
if [ -z "$package_manager" ]; then
    if command -v apt-get &> /dev/null; then
        package_manager="apt"
    elif command -v yum &> /dev/null; then
        package_manager="yum"
    elif command -v dnf &> /dev/null; then
        package_manager="dnf"
    elif command -v pacman &> /dev/null; then
        package_manager="pacman"
    elif command -v zypper &> /dev/null; then
        package_manager="zypper"
    else
        package_manager="unknown"
    fi
fi