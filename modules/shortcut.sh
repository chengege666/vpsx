#!/bin/bash

# 快捷键管理模块

# 配置启动快捷键
function setup_shortcut() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}       一键配置启动快捷键 (k)${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    # 获取当前脚本的绝对路径
    # 通过当前模块文件的位置推算主脚本 vpsx.sh 的位置
    local script_dir
    script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
    SCRIPT_PATH="${script_dir}/vpsx.sh"
    
    if [ ! -f "$SCRIPT_PATH" ]; then
        echo -e "${RED}错误: 未能找到主脚本 vpsx.sh${NC}"
        echo -e "${YELLOW}检测到的路径为: $SCRIPT_PATH${NC}"
        read -p "按任意键继续..."
        return
    fi

    echo -e "正在为脚本配置快捷键 ${YELLOW}k${NC} ..."
    
    # 检查当前 Shell
    CURRENT_SHELL=$(basename "$SHELL")
    RC_FILE=""
    
    if [ "$CURRENT_SHELL" == "bash" ]; then
        RC_FILE="$HOME/.bashrc"
    elif [ "$CURRENT_SHELL" == "zsh" ]; then
        RC_FILE="$HOME/.zshrc"
    else
        RC_FILE="$HOME/.bashrc"
    fi

    # 检查是否已经存在 alias
    if grep -q "alias k=" "$RC_FILE"; then
        echo -e "${YELLOW}快捷键 'k' 已存在，正在更新...${NC}"
        sed -i "/alias k=/d" "$RC_FILE"
    fi

    # 添加 alias
    # 使用绝对路径确保在任何目录下输入 k 都能启动
    echo "alias k='bash $SCRIPT_PATH'" >> "$RC_FILE"
    
    # 尝试使配置生效
    source "$RC_FILE" 2>/dev/null

    echo -e "${GREEN}配置成功！${NC}"
    echo -e "现在你可以在任何地方输入 ${YELLOW}k${NC} 来启动此脚本了。"
    echo -e "${BLUE}提示：如果 'k' 没有立即生效，请尝试重新连接 SSH 或执行 'source $RC_FILE'${NC}"
    echo ""
    read -p "按任意键继续..."
}
