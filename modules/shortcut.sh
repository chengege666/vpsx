#!/bin/bash

# 快捷键管理模块

# 设置别名通用函数
function set_script_alias() {
    local alias_name=$1
    local script_path
    
    # 获取当前脚本的绝对路径
    script_path=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/vpsx.sh
    
    if [ ! -f "$script_path" ]; then
        echo -e "${RED}错误: 未能找到主脚本 vpsx.sh${NC}"
        echo -e "${YELLOW}检测到的路径为: $script_path${NC}"
        return 1
    fi

    echo -e "正在配置快捷键 ${YELLOW}${alias_name}${NC} ..."
    
    # 检查当前 Shell
    local current_shell=$(basename "$SHELL")
    local rc_file=""
    
    if [ "$current_shell" == "bash" ]; then
        rc_file="$HOME/.bashrc"
    elif [ "$current_shell" == "zsh" ]; then
        rc_file="$HOME/.zshrc"
    else
        rc_file="$HOME/.bashrc"
    fi

    # 检查是否已经存在该别名
    if grep -q "alias ${alias_name}=" "$rc_file"; then
        echo -e "${YELLOW}快捷键 '${alias_name}' 已存在，正在更新...${NC}"
        sed -i "/alias ${alias_name}=/d" "$rc_file"
    fi

    # 添加别名
    echo "alias ${alias_name}='bash $script_path'" >> "$rc_file"
    
    echo -e "${GREEN}配置成功！${NC}"
    echo -e "现在你可以在任何地方输入 ${YELLOW}${alias_name}${NC} 来启动此脚本了。"
    echo -e "${BLUE}提示：如果没有立即生效，请尝试重新连接 SSH 或执行 'source $rc_file'${NC}"
    return 0
}

# 快捷键管理菜单
function shortcut_menu() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          快捷键启动脚本管理${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo ""
        echo -e "  ${GREEN}1)${NC} 一键配置 ${YELLOW}K${NC} 为启动脚本命令"
        echo -e "  ${GREEN}2)${NC} 自定义快捷启动键"
        echo -e "  ${RED}3)${NC} 返回上级菜单"
        echo ""
        echo -e "${CYAN}=========================================${NC}"
        echo ""
        
        read -p "请选择操作 (1-3): " choice
        
        case $choice in
            1)
                set_script_alias "k"
                read -p "按任意键继续..."
                ;;
            2)
                read -p "请输入你想要设置的快捷键名称: " custom_key
                if [ -n "$custom_key" ]; then
                    set_script_alias "$custom_key"
                else
                    echo -e "${RED}错误：快捷键名称不能为空！${NC}"
                fi
                read -p "按任意键继续..."
                ;;
            3)
                return 0
                ;;
            *)
                echo -e "${RED}无效选择，请重试${NC}"
                sleep 1
                ;;
        esac
    done
}

