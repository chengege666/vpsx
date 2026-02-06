#!/bin/bash

# 快捷键管理模块

# 配置启动快捷键
function setup_shortcut() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}       一键配置启动快捷键 ($ALIAS_NAME)${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    # 获取当前脚本的绝对路径
    local script_dir current_dir
    current_dir=$(pwd)
    
    # 多种方式尝试查找主脚本
    if [[ -f "./$SCRIPT_NAME" ]]; then
        # 当前目录
        SCRIPT_PATH="./$SCRIPT_NAME"
    elif [[ -f "../$SCRIPT_NAME" ]]; then
        # 上级目录
        SCRIPT_PATH="../$SCRIPT_NAME"
    else
        # 尝试通过模块路径推算
        script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
        SCRIPT_PATH="${script_dir}/$SCRIPT_NAME"
        
        # 如果还是找不到，让用户输入
        if [ ! -f "$SCRIPT_PATH" ]; then
            echo -e "${YELLOW}未能自动找到 $SCRIPT_NAME${NC}"
            echo -e "${BLUE}请手动输入 $SCRIPT_NAME 的完整路径：${NC}"
            read -r -p "路径: " user_path
            SCRIPT_PATH="${user_path/#~/$HOME}" # 处理 ~ 开头的路径
            
            if [ ! -f "$SCRIPT_PATH" ]; then
                echo -e "${RED}错误: 指定路径不存在或不是文件${NC}"
                read -p "按任意键继续..."
                return 1
            fi
        fi
    fi

    # 转换为绝对路径
    SCRIPT_PATH=$(realpath "$SCRIPT_PATH" 2>/dev/null || echo "$SCRIPT_PATH")
    
    echo -e "${GREEN}找到脚本: ${YELLOW}$SCRIPT_PATH${NC}"
    echo ""
    
    # 检测支持的 Shell 配置文件
    local rc_files=()
    local shells=()
    
    # 检查各种 Shell 配置文件
    if [[ -f "$HOME/.bashrc" ]]; then
        rc_files+=("$HOME/.bashrc")
        shells+=("bash")
    fi
    
    if [[ -f "$HOME/.zshrc" ]]; then
        rc_files+=("$HOME/.zshrc")
        shells+=("zsh")
    fi
    
    if [[ -f "$HOME/.bash_profile" ]]; then
        rc_files+=("$HOME/.bash_profile")
        shells+=("bash")
    fi
    
    if [[ -f "$HOME/.profile" ]]; then
        rc_files+=("$HOME/.profile")
        shells+=("bash/sh")
    fi
    
    if [[ ${#rc_files[@]} -eq 0 ]]; then
        echo -e "${RED}错误: 未找到任何 Shell 配置文件${NC}"
        echo -e "${YELLOW}请确保 ~/.bashrc 或 ~/.zshrc 存在${NC}"
        read -p "按任意键继续..."
        return 1
    fi
    
    # 显示检测到的配置文件
    echo -e "${CYAN}检测到的 Shell 配置文件:${NC}"
    for i in "${!rc_files[@]}"; do
        echo -e "  $((i+1)). ${YELLOW}${rc_files[$i]}${NC} (${shells[$i]})"
    done
    echo ""
    
    # 让用户选择配置文件
    local selected_rc
    if [[ ${#rc_files[@]} -eq 1 ]]; then
        selected_rc="${rc_files[0]}"
        echo -e "${GREEN}自动选择: ${YELLOW}$selected_rc${NC}"
    else
        echo -e "${CYAN}请选择要配置的 Shell 配置文件 (输入数字):${NC}"
        select rc_file in "${rc_files[@]}"; do
            if [[ -n "$rc_file" ]]; then
                selected_rc="$rc_file"
                break
            else
                echo -e "${RED}无效选择，请重试${NC}"
            fi
        done
    fi
    
    echo ""
    echo -e "正在为脚本配置快捷键 ${YELLOW}$ALIAS_NAME${NC} ..."
    echo -e "配置文件: ${YELLOW}$selected_rc${NC}"
    echo ""
    
    # 备份原配置文件
    local backup_file="$BACKUP_DIR/$(basename "$selected_rc").backup.$(date +%Y%m%d_%H%M%S)"
    cp "$selected_rc" "$backup_file"
    echo -e "${GREEN}已备份配置文件到: ${YELLOW}$backup_file${NC}"
    
    # 检查是否已经存在别名
    local existing_alias
    if grep -q "alias $ALIAS_NAME=" "$selected_rc"; then
        existing_alias=$(grep "alias $ALIAS_NAME=" "$selected_rc")
        echo -e "${YELLOW}发现已存在的快捷键配置:${NC}"
        echo -e "  ${existing_alias}"
        echo ""
        
        # 提供选项：覆盖、跳过、自定义新别名
        echo -e "${CYAN}请选择操作:${NC}"
        echo -e "  1. ${GREEN}覆盖${NC} - 删除旧的，使用新配置"
        echo -e "  2. ${YELLOW}跳过${NC} - 保留原有配置"
        echo -e "  3. ${BLUE}自定义${NC} - 使用不同的别名"
        echo -e "  4. ${RED}取消${NC} - 退出配置"
        echo ""
        
        local choice
        read -r -p "请选择 (1-4): " choice
        
        case $choice in
            1)
                # 删除旧的别名
                sed -i "/alias $ALIAS_NAME=/d" "$selected_rc"
                echo -e "${GREEN}已删除旧的快捷键配置${NC}"
                ;;
            2)
                echo -e "${YELLOW}跳过配置，保持原有快捷键${NC}"
                read -p "按任意键继续..."
                return 0
                ;;
            3)
                read -r -p "请输入新的别名 (默认: k): " new_alias
                new_alias=${new_alias:-k}
                ALIAS_NAME="$new_alias"
                
                # 如果新别名也存在，删除它
                if grep -q "alias $ALIAS_NAME=" "$selected_rc"; then
                    sed -i "/alias $ALIAS_NAME=/d" "$selected_rc"
                fi
                ;;
            4)
                echo -e "${YELLOW}取消配置${NC}"
                return 0
                ;;
            *)
                echo -e "${RED}无效选择，使用默认操作（覆盖）${NC}"
                sed -i "/alias $ALIAS_NAME=/d" "$selected_rc"
                ;;
        esac
    fi
    
    # 添加 alias - 使用函数形式，支持更多功能
    echo "" >> "$selected_rc"
    echo "# VPSX Script Shortcut - Added by setup_shortcut on $(date)" >> "$selected_rc"
    echo "alias $ALIAS_NAME='_vpsx_launch() { if [ -f \"$SCRIPT_PATH\" ]; then bash \"$SCRIPT_PATH\"; else echo \"错误: 脚本不存在，请重新运行设置\"; fi; }; _vpsx_launch'" >> "$selected_rc"
    
    # 同时添加一个快速状态检查的别名
    echo "alias ${ALIAS_NAME}status='echo \"脚本路径: $SCRIPT_PATH\"; echo \"最后修改: $(stat -c %y "$SCRIPT_PATH" 2>/dev/null || echo \"未知\")\"; ls -lah \"$SCRIPT_PATH\" 2>/dev/null || echo \"脚本不存在\"'" >> "$selected_rc"
    
    echo -e "${GREEN}配置成功！${NC}"
    echo ""
    
    # 显示配置信息
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo -e "${GREEN}快捷键配置完成！${NC}"
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo -e "主快捷键: ${YELLOW}$ALIAS_NAME${NC}    → 启动 VPSX 脚本"
    echo -e "状态检查: ${YELLOW}${ALIAS_NAME}status${NC} → 查看脚本信息"
    echo -e "配置文件: ${YELLOW}$selected_rc${NC}"
    echo -e "脚本路径: ${YELLOW}$SCRIPT_PATH${NC}"
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo ""
    
    # 尝试使配置生效
    echo -e "${BLUE}尝试应用新配置...${NC}"
    
    # 根据配置文件类型尝试 source
    case "$selected_rc" in
        *bashrc|*bash_profile)
            if [[ -n "$BASH_VERSION" ]]; then
                source "$selected_rc" 2>/dev/null && echo -e "${GREEN}Bash 配置已重新加载${NC}"
            fi
            ;;
        *zshrc)
            if [[ -n "$ZSH_VERSION" ]]; then
                source "$selected_rc" 2>/dev/null && echo -e "${GREEN}Zsh 配置已重新加载${NC}"
            fi
            ;;
    esac
    
    echo ""
    echo -e "${YELLOW}提示:${NC}"
    echo -e "1. 如果 '$ALIAS_NAME' 没有立即生效，请尝试:"
    echo -e "   ${BLUE}source $selected_rc${NC}"
    echo -e "   或重新连接 SSH 会话"
    echo -e "2. 使用 '${ALIAS_NAME}status' 检查脚本状态"
    echo -e "3. 备份文件保存在: ${YELLOW}$BACKUP_DIR${NC}"
    echo ""
    
    # 测试快捷键
    echo -e "${CYAN}测试快捷键...${NC}"
    echo -e "输入 ${YELLOW}$ALIAS_NAME${NC} 启动脚本"
    echo -e "输入 ${YELLOW}${ALIAS_NAME}status${NC} 查看脚本信息"
    echo ""
    
    read -p "按任意键完成配置..."
}

# 移除快捷键配置
function remove_shortcut() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}       移除快捷键配置${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    # 检查所有可能的配置文件
    local config_files=(
        "$HOME/.bashrc"
        "$HOME/.zshrc"
        "$HOME/.bash_profile"
        "$HOME/.profile"
    )
    
    local found=0
    
    for config_file in "${config_files[@]}"; do
        if [[ -f "$config_file" ]] && grep -q "alias $ALIAS_NAME=" "$config_file"; then
            found=1
            echo -e "${YELLOW}在 $config_file 中找到快捷键配置${NC}"
            
            # 显示当前的配置
            grep "alias $ALIAS_NAME=" "$config_file"
            echo ""
            
            read -r -p "是否从该文件中移除配置? (y/N): " confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                # 备份
                local backup_file="$BACKUP_DIR/$(basename "$config_file").remove.$(date +%Y%m%d_%H%M%S)"
                cp "$config_file" "$backup_file"
                
                # 移除配置
                sed -i "/alias $ALIAS_NAME=/d" "$config_file"
                sed -i "/alias ${ALIAS_NAME}status=/d" "$config_file"
                sed -i "/# VPSX Script Shortcut - Added by setup_shortcut/d" "$config_file"
                
                echo -e "${GREEN}已从 $config_file 中移除快捷键配置${NC}"
                echo -e "${YELLOW}备份文件: $backup_file${NC}"
            else
                echo -e "${YELLOW}跳过 $config_file${NC}"
            fi
            echo ""
        fi
    done
    
    if [[ $found -eq 0 ]]; then
        echo -e "${GREEN}未找到快捷键配置${NC}"
    fi
    
    read -p "按任意键继续..."
}

# 显示快捷键状态
function show_shortcut_status() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}       快捷键配置状态${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    echo -e "${BLUE}当前快捷键配置:${NC}"
    alias "$ALIAS_NAME" 2>/dev/null || echo -e "${YELLOW}快捷键 '$ALIAS_NAME' 未定义${NC}"
    alias "${ALIAS_NAME}status" 2>/dev/null || echo -e "${YELLOW}快捷键 '${ALIAS_NAME}status' 未定义${NC}"
    
    echo ""
    echo -e "${BLUE}配置文件检查:${NC}"
    
    local config_files=(
        "$HOME/.bashrc"
        "$HOME/.zshrc"
        "$HOME/.bash_profile"
        "$HOME/.profile"
    )
    
    for config_file in "${config_files[@]}"; do
        if [[ -f "$config_file" ]]; then
            echo -e "  ${YELLOW}$config_file:${NC}"
            if grep -q "alias $ALIAS_NAME=" "$config_file"; then
                echo -e "    ${GREEN}✓ 找到 '$ALIAS_NAME' 配置${NC}"
                grep "alias $ALIAS_NAME=" "$config_file"
            else
                echo -e "    ${RED}✗ 未找到 '$ALIAS_NAME' 配置${NC}"
            fi
        fi
    done
    
    echo ""
    echo -e "${BLUE}备份文件:${NC}"
    if [[ -d "$BACKUP_DIR" ]]; then
        ls -la "$BACKUP_DIR/" 2>/dev/null || echo -e "${YELLOW}备份目录为空${NC}"
    else
        echo -e "${YELLOW}备份目录不存在${NC}"
    fi
    
    echo ""
    read -p "按任意键继续..."
}

# 主菜单函数
function shortcut_menu() {
    while true; do
        clear
        echo -e "${CYAN}════════════════════════════════════════${NC}"
        echo -e "${GREEN}           快捷键管理菜单${NC}"
        echo -e "${CYAN}════════════════════════════════════════${NC}"
        echo -e "当前快捷键: ${YELLOW}$ALIAS_NAME${NC}"
        echo -e "${CYAN}════════════════════════════════════════${NC}"
        echo -e "  1. ${GREEN}配置快捷键${NC}"
        echo -e "  2. ${YELLOW}移除快捷键${NC}"
        echo -e "  3. ${BLUE}查看状态${NC}"
        echo -e "  4. ${MAGENTA}测试快捷键${NC}"
        echo -e "  5. ${RED}退出${NC}"
        echo -e "${CYAN}════════════════════════════════════════${NC}"
        
        read -r -p "请选择操作 (1-5): " choice
        
        case $choice in
            1)
                setup_shortcut
                ;;
            2)
                remove_shortcut
                ;;
            3)
                show_shortcut_status
                ;;
            4)
                clear
                echo -e "${CYAN}测试快捷键 '$ALIAS_NAME'...${NC}"
                echo ""
                if alias "$ALIAS_NAME" &>/dev/null; then
                    echo -e "${GREEN}快捷键 '$ALIAS_NAME' 已定义${NC}"
                    echo -e "执行: ${YELLOW}$ALIAS_NAME${NC}"
                    echo ""
                    # 这里可以实际执行，但为了安全只显示提示
                    echo -e "${BLUE}(实际执行已禁用，确保安全)${NC}"
                    echo -e "在终端中直接输入 '$ALIAS_NAME' 即可运行脚本"
                else
                    echo -e "${RED}快捷键 '$ALIAS_NAME' 未定义${NC}"
                    echo -e "请先运行配置快捷键功能"
                fi
                echo ""
                read -p "按任意键继续..."
                ;;
            5)
                echo -e "${GREEN}退出快捷键管理${NC}"
                break
                ;;
            *)
                echo -e "${RED}无效选择，请重试${NC}"
                sleep 1
                ;;
        esac
    done
}