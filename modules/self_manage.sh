#!/bin/bash

# 脚本自我管理模块 (更新与卸载)

# 卸载脚本函数
function uninstall_script() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}           卸载 vpsx 脚本${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${YELLOW}警告：此操作将删除脚本文件及其配置的快捷键。${NC}"
    echo -e "${YELLOW}注意：此操作不会删除您通过脚本安装的应用（如 Docker、NPM 等）。${NC}"
    echo ""
    read -p "确定要卸载吗？(y/N): " confirm_uninstall
    
    if [[ "$confirm_uninstall" =~ ^[yY]$ ]]; then
        echo -e "${BLUE}正在执行卸载程序...${NC}"
        
        # 1. 删除快捷键 (k)
        echo -e "正在清理快捷键..."
        local shells=(".bashrc" ".zshrc")
        for shell_rc in "${shells[@]}"; do
            if [ -f "$HOME/$shell_rc" ]; then
                sed -i '/alias k=/d' "$HOME/$shell_rc"
            fi
        done
        
        # 2. 获取脚本所在目录并准备删除
        # 获取当前运行脚本所在的绝对路径目录
        local script_dir
        script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
        
        echo -e "正在删除脚本文件: ${YELLOW}$script_dir${NC}"
        
        # 创建一个临时卸载脚本，因为不能直接在运行中删除自己所在的目录
        local temp_uninstall="/tmp/vpsx_uninstall.sh"
        cat <<EOF > "$temp_uninstall"
#!/bin/bash
sleep 1
rm -rf "$script_dir"
echo -e "\033[0;32m✅ vpsx 脚本已成功卸载。\033[0m"
rm -- "\$0"
EOF
        chmod +x "$temp_uninstall"
        
        echo -e "${GREEN}卸载指令已就绪。脚本将在退出后完成清理。${NC}"
        echo -e "${CYAN}感谢您的使用，再见！${NC}"
        
        # 执行临时脚本并立即退出主程序
        nohup bash "$temp_uninstall" > /dev/null 2>&1 &
        exit 0
    else
        echo -e "${GREEN}已取消卸载操作。${NC}"
        sleep 2
    fi
}

# 脚本更新函数
function update_script() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            脚本更新${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo ""
    echo -e "${BLUE}正在从 GitHub 获取最新脚本...${NC}"
    
    # 自动获取当前主脚本路径，如果没有则使用默认路径
    local FIXED_PATH
    if [ -f "$HOME/vpsx.sh" ]; then
        FIXED_PATH="$HOME/vpsx.sh"
    elif [ -f "/root/vpsx.sh" ]; then
        FIXED_PATH="/root/vpsx.sh"
    else
        FIXED_PATH="/root/vpsx.sh"
    fi
     
    # 检查 wget 是否安装
    if ! command -v wget >/dev/null 2>&1; then
        echo -e "${YELLOW}未检测到 wget，正在尝试安装...${NC}"
        if command -v apt >/dev/null 2>&1; then
            apt update && apt install -y wget
        elif command -v yum >/dev/null 2>&1; then
            yum install -y wget
        else
            echo -e "${RED}无法安装 wget，请手动安装后重试。${NC}"
            read -p "按任意键返回主菜单..."
            return
        fi
    fi
 
    wget -O "$FIXED_PATH.tmp" "https://raw.githubusercontent.com/chengege666/vpsx/main/vpsx.sh"
    if [ $? -eq 0 ]; then
        mv "$FIXED_PATH.tmp" "$FIXED_PATH"
        chmod +x "$FIXED_PATH"
        echo -e "${GREEN}脚本更新成功！${NC}"
        echo -e "${BLUE}正在重新启动脚本...${NC}"
        sleep 2
        exec bash "$FIXED_PATH"
    else
        echo -e "${RED}脚本更新失败，请检查网络连接。${NC}"
        rm -f "$FIXED_PATH.tmp"
        read -p "按任意键返回主菜单..."
    fi
}
