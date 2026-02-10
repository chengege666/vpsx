#!/bin/bash

# 基础工具模块 - 包含安装和卸载菜单
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
        echo -e " ${GREEN}5.${NC} 安装 unzip"
        echo -e " ${GREEN}6.${NC} 安装 bzip2"
        echo -e " ${GREEN}7.${NC} 安装 sudo"
        echo -e " ${GREEN}8.${NC} 卸载工具菜单"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC} 返回主菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择(0-8): " basic_tool_choice

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
                install_package "unzip"
                ;;
            6)
                install_bzip2
                ;;
            7)
                install_sudo
                ;;
            8)
                uninstall_tools_menu
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

# 工具卸载菜单
function uninstall_tools_menu() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${RED}            工具卸载菜单${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${YELLOW}请选择要卸载的工具：${NC}"
        echo ""
        
        # 显示工具状态
        if command -v htop &> /dev/null; then
            echo -e " ${GREEN}1.${NC} 卸载 htop ${GREEN}✓ 已安装${NC}"
        else
            echo -e " ${GRAY}1.${NC} 卸载 htop ${RED}✗ 未安装${NC}"
        fi
        
        if command -v wget &> /dev/null; then
            echo -e " ${GREEN}2.${NC} 卸载 wget ${GREEN}✓ 已安装${NC}"
        else
            echo -e " ${GRAY}2.${NC} 卸载 wget ${RED}✗ 未安装${NC}"
        fi
        
        if command -v curl &> /dev/null; then
            echo -e " ${GREEN}3.${NC} 卸载 curl ${GREEN}✓ 已安装${NC}"
        else
            echo -e " ${GRAY}3.${NC} 卸载 curl ${RED}✗ 未安装${NC}"
        fi
        
        if command -v git &> /dev/null; then
            echo -e " ${GREEN}4.${NC} 卸载 git ${GREEN}✓ 已安装${NC}"
        else
            echo -e " ${GRAY}4.${NC} 卸载 git ${RED}✗ 未安装${NC}"
        fi

        if command -v unzip &> /dev/null; then
            echo -e " ${GREEN}5.${NC} 卸载 unzip ${GREEN}✓ 已安装${NC}"
        else
            echo -e " ${GRAY}5.${NC} 卸载 unzip ${RED}✗ 未安装${NC}"
        fi
        
        if command -v bzip2 &> /dev/null; then
            echo -e " ${GREEN}6.${NC} 卸载 bzip2 ${GREEN}✓ 已安装${NC}"
        else
            echo -e " ${GRAY}6.${NC} 卸载 bzip2 ${RED}✗ 未安装${NC}"
        fi
        
        if command -v sudo &> /dev/null; then
            echo -e " ${GREEN}7.${NC} 卸载 sudo ${GREEN}✓ 已安装${NC}"
        else
            echo -e " ${GRAY}7.${NC} 卸载 sudo ${RED}✗ 未安装${NC}"
        fi
        
        echo -e " ${GREEN}8.${NC} 批量卸载"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC} 返回上一级"  
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择(0-8): " uninstall_choice  

        case "$uninstall_choice" in
            1)
                uninstall_htop
                ;;
            2)
                uninstall_wget
                ;;
            3)
                uninstall_curl
                ;;
            4)
                uninstall_git
                ;;
            5)
                uninstall_package "unzip"
                ;;
            6)
                uninstall_bzip2
                ;;
            7)
                uninstall_sudo
                ;;
            8)
                batch_uninstall
                ;;
            0)  # 修改这里：8改为0
                break
                ;;
            *)
                echo -e "${RED}无效的选择，请重新输入！${NC}"
                sleep 2
                ;;
        esac
    done
}

# 卸载htop函数
function uninstall_htop() {
    # 检查是否已安装
    if ! command -v htop &> /dev/null; then
        echo -e "${YELLOW}检测到 htop 未安装，无需卸载。${NC}"
        read -p "按任意键返回..." -n1 -s
        echo
        return 0
    fi
    
    # 获取htop信息
    local htop_version=$(htop --version 2>/dev/null | head -n1 | awk '{print $2}' || echo "未知版本")
    
    # 显示确认菜单
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}            卸载确认${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${YELLOW}您确定要卸载 htop 吗？${NC}"
    echo ""
    echo -e "${GREEN}工具信息：${NC}"
    echo -e "名称: ${CYAN}htop${NC}"
    echo -e "版本: ${CYAN}$htop_version${NC}"
    echo -e "描述: ${CYAN}交互式系统进程查看器${NC}"
    echo ""
    echo -e "${RED}警告：卸载后相关配置将被删除！${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e " ${GREEN}1.${NC} 确认卸载"
    echo -e " ${RED}2.${NC} 返回工具卸载菜单"
    echo -e "${CYAN}=========================================${NC}"
    read -p "请选择(1-2): " confirm_choice

    case "$confirm_choice" in
        1)
            echo -e "${YELLOW}正在卸载 htop...${NC}"
            if [[ "$package_manager" == "apt" ]]; then
                apt-get remove -y htop
                apt-get autoremove -y
            elif [[ "$package_manager" == "yum" ]]; then
                yum remove -y htop
            elif [[ "$package_manager" == "dnf" ]]; then
                dnf remove -y htop
            elif [[ "$package_manager" == "pacman" ]]; then
                pacman -R --noconfirm htop
            elif [[ "$package_manager" == "zypper" ]]; then
                zypper remove -y htop
            fi
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ htop 已成功卸载！${NC}"
            else
                echo -e "${RED}✗ htop 卸载失败！${NC}"
            fi
            ;;
        2)
            echo -e "${YELLOW}卸载操作已取消。${NC}"
            ;;
        *)
            echo -e "${RED}无效的选择，操作已取消。${NC}"
            ;;
    esac
    
    read -p "按任意键返回工具卸载菜单..." -n1 -s
    echo
}

# 卸载wget函数
function uninstall_wget() {
    # 检查是否已安装
    if ! command -v wget &> /dev/null; then
        echo -e "${YELLOW}检测到 wget 未安装，无需卸载。${NC}"
        read -p "按任意键返回..." -n1 -s
        echo
        return 0
    fi
    
    # 获取wget信息
    local wget_version=$(wget --version 2>/dev/null | head -n1 | awk '{print $3}' || echo "未知版本")
    
    # 显示确认菜单
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}            卸载确认${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${YELLOW}您确定要卸载 wget 吗？${NC}"
    echo ""
    echo -e "${GREEN}工具信息：${NC}"
    echo -e "名称: ${CYAN}wget${NC}"
    echo -e "版本: ${CYAN}$wget_version${NC}"
    echo -e "描述: ${CYAN}命令行下载工具${NC}"
    echo ""
    echo -e "${RED}⚠️ 依赖警告：${NC}"
    echo -e "${YELLOW}以下工具可能依赖 wget：${NC}"
    echo -e "• curl（可选）"
    echo -e "• git（可选）"
    echo ""
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e " ${GREEN}1.${NC} 确认卸载（忽略依赖警告）"
    echo -e " ${RED}2.${NC} 返回工具卸载菜单"
    echo -e "${CYAN}=========================================${NC}"
    read -p "请选择(1-2): " confirm_choice

    case "$confirm_choice" in
        1)
            echo -e "${YELLOW}正在卸载 wget...${NC}"
            if [[ "$package_manager" == "apt" ]]; then
                apt-get remove -y wget
                apt-get autoremove -y
            elif [[ "$package_manager" == "yum" ]]; then
                yum remove -y wget
            elif [[ "$package_manager" == "dnf" ]]; then
                dnf remove -y wget
            elif [[ "$package_manager" == "pacman" ]]; then
                pacman -R --noconfirm wget
            elif [[ "$package_manager" == "zypper" ]]; then
                zypper remove -y wget
            fi
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ wget 已成功卸载！${NC}"
                echo -e "${YELLOW}注意：依赖 wget 的工具可能功能受限。${NC}"
            else
                echo -e "${RED}✗ wget 卸载失败！${NC}"
            fi
            ;;
        2)
            echo -e "${YELLOW}卸载操作已取消。${NC}"
            ;;
        *)
            echo -e "${RED}无效的选择，操作已取消。${NC}"
            ;;
    esac
    
    read -p "按任意键返回工具卸载菜单..." -n1 -s
    echo
}

# 卸载curl函数
function uninstall_curl() {
    # 检查是否已安装
    if ! command -v curl &> /dev/null; then
        echo -e "${YELLOW}检测到 curl 未安装，无需卸载。${NC}"
        read -p "按任意键返回..." -n1 -s
        echo
        return 0
    fi
    
    # 获取curl信息
    local curl_version=$(curl --version 2>/dev/null | head -n1 | awk '{print $2}' || echo "未知版本")
    
    # 显示确认菜单
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}            卸载确认${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${YELLOW}您确定要卸载 curl 吗？${NC}"
    echo ""
    echo -e "${GREEN}工具信息：${NC}"
    echo -e "名称: ${CYAN}curl${NC}"
    echo -e "版本: ${CYAN}$curl_version${NC}"
    echo -e "描述: ${CYAN}数据传输工具${NC}"
    echo ""
    echo -e "${RED}警告：卸载后相关配置将被删除！${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e " ${GREEN}1.${NC} 确认卸载"
    echo -e " ${RED}2.${NC} 返回工具卸载菜单"
    echo -e "${CYAN}=========================================${NC}"
    read -p "请选择(1-2): " confirm_choice

    case "$confirm_choice" in
        1)
            echo -e "${YELLOW}正在卸载 curl...${NC}"
            if [[ "$package_manager" == "apt" ]]; then
                apt-get remove -y curl
                apt-get autoremove -y
            elif [[ "$package_manager" == "yum" ]]; then
                yum remove -y curl
            elif [[ "$package_manager" == "dnf" ]]; then
                dnf remove -y curl
            elif [[ "$package_manager" == "pacman" ]]; then
                pacman -R --noconfirm curl
            elif [[ "$package_manager" == "zypper" ]]; then
                zypper remove -y curl
            fi
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ curl 已成功卸载！${NC}"
            else
                echo -e "${RED}✗ curl 卸载失败！${NC}"
            fi
            ;;
        2)
            echo -e "${YELLOW}卸载操作已取消。${NC}"
            ;;
        *)
            echo -e "${RED}无效的选择，操作已取消。${NC}"
            ;;
    esac
    
    read -p "按任意键返回工具卸载菜单..." -n1 -s
    echo
}

# 卸载git函数
function uninstall_git() {
    # 检查是否已安装
    if ! command -v git &> /dev/null; then
        echo -e "${YELLOW}检测到 git 未安装，无需卸载。${NC}"
        read -p "按任意键返回..." -n1 -s
        echo
        return 0
    fi
    
    # 获取git信息
    local git_version=$(git --version 2>/dev/null | awk '{print $3}' || echo "未知版本")
    
    # 显示确认菜单
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}            卸载确认${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${YELLOW}您确定要卸载 git 吗？${NC}"
    echo ""
    echo -e "${GREEN}工具信息：${NC}"
    echo -e "名称: ${CYAN}git${NC}"
    echo -e "版本: ${CYAN}$git_version${NC}"
    echo -e "描述: ${CYAN}分布式版本控制系统${NC}"
    echo ""
    echo -e "${RED}警告：卸载后所有git配置将被删除！${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e " ${GREEN}1.${NC} 确认卸载"
    echo -e " ${RED}2.${NC} 返回工具卸载菜单"
    echo -e "${CYAN}=========================================${NC}"
    read -p "请选择(1-2): " confirm_choice

    case "$confirm_choice" in
        1)
            echo -e "${YELLOW}正在卸载 git...${NC}"
            if [[ "$package_manager" == "apt" ]]; then
                apt-get remove -y git
                apt-get autoremove -y
            elif [[ "$package_manager" == "yum" ]]; then
                yum remove -y git
            elif [[ "$package_manager" == "dnf" ]]; then
                dnf remove -y git
            elif [[ "$package_manager" == "pacman" ]]; then
                pacman -R --noconfirm git
            elif [[ "$package_manager" == "zypper" ]]; then
                zypper remove -y git
            fi
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ git 已成功卸载！${NC}"
                echo -e "${YELLOW}注意：git配置文件和本地仓库不会被删除。${NC}"
            else
                echo -e "${RED}✗ git 卸载失败！${NC}"
            fi
            ;;
        2)
            echo -e "${YELLOW}卸载操作已取消。${NC}"
            ;;
        *)
            echo -e "${RED}无效的选择，操作已取消。${NC}"
            ;;
    esac
    
    read -p "按任意键返回工具卸载菜单..." -n1 -s
    echo
}

# 卸载bzip2函数
function uninstall_bzip2() {
    # 检查是否已安装
    if ! command -v bzip2 &> /dev/null; then
        echo -e "${YELLOW}检测到 bzip2 未安装，无需卸载。${NC}"
        read -p "按任意键返回..." -n1 -s
        echo
        return 0
    fi
    
    # 获取bzip2信息
    local bzip_version=$(bzip2 --version 2>/dev/null | head -n1 | awk '{print $2}' || echo "未知版本")
    
    # 显示确认菜单
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}            卸载确认${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${YELLOW}您确定要卸载 bzip2 吗？${NC}"
    echo ""
    echo -e "${GREEN}工具信息：${NC}"
    echo -e "名称: ${CYAN}bzip2${NC}"
    echo -e "版本: ${CYAN}$bzip_version${NC}"
    echo -e "描述: ${CYAN}块排序文件压缩器${NC}"
    echo ""
    echo -e "${RED}警告：卸载后无法解压.bz2文件！${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e " ${GREEN}1.${NC} 确认卸载"
    echo -e " ${RED}2.${NC} 返回工具卸载菜单"
    echo -e "${CYAN}=========================================${NC}"
    read -p "请选择(1-2): " confirm_choice

    case "$confirm_choice" in
        1)
            echo -e "${YELLOW}正在卸载 bzip2...${NC}"
            if [[ "$package_manager" == "apt" ]]; then
                apt-get remove -y bzip2
                apt-get autoremove -y
            elif [[ "$package_manager" == "yum" ]]; then
                yum remove -y bzip2
            elif [[ "$package_manager" == "dnf" ]]; then
                dnf remove -y bzip2
            elif [[ "$package_manager" == "pacman" ]]; then
                pacman -R --noconfirm bzip2
            elif [[ "$package_manager" == "zypper" ]]; then
                zypper remove -y bzip2
            fi
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ bzip2 已成功卸载！${NC}"
            else
                echo -e "${RED}✗ bzip2 卸载失败！${NC}"
            fi
            ;;
        2)
            echo -e "${YELLOW}卸载操作已取消。${NC}"
            ;;
        *)
            echo -e "${RED}无效的选择，操作已取消。${NC}"
            ;;
    esac
    
    read -p "按任意键返回工具卸载菜单..." -n1 -s
    echo
}

# 卸载sudo函数（高危操作）
function uninstall_sudo() {
    # 检查是否已安装
    if ! command -v sudo &> /dev/null; then
        echo -e "${YELLOW}检测到 sudo 未安装，无需卸载。${NC}"
        read -p "按任意键返回..." -n1 -s
        echo
        return 0
    fi
    
    # 获取sudo信息
    local sudo_version=$(sudo --version 2>/dev/null | head -n1 | awk '{print $3}' || echo "未知版本")
    
    # 显示高危警告菜单
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}          ⚠️ 高危操作警告${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${YELLOW}您确定要卸载 sudo 吗？${NC}"
    echo ""
    echo -e "${GREEN}工具信息：${NC}"
    echo -e "名称: ${CYAN}sudo${NC}"
    echo -e "版本: ${CYAN}$sudo_version${NC}"
    echo -e "描述: ${CYAN}系统权限管理工具${NC}"
    echo ""
    echo -e "${RED}⚠️ ⚠️ ⚠️ 严重警告：${NC}"
    echo -e "${YELLOW}卸载 sudo 将导致：${NC}"
    echo -e "• 失去管理员权限"
    echo -e "• 无法执行需要root权限的命令"
    echo -e "• 系统管理工具失效"
    echo -e "• 可能无法重新安装sudo"
    echo ""
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e "${RED}请输入 \"CONFIRM-SUDO-UNINSTALL\" 确认卸载${NC}"
    echo -e "${YELLOW}或按回车键取消：${NC}"
    echo -e "${CYAN}=========================================${NC}"
    read -p "输入确认代码: " confirm_code

    if [[ "$confirm_code" == "CONFIRM-SUDO-UNINSTALL" ]]; then
        echo -e "${YELLOW}正在卸载 sudo...${NC}"
        if [[ "$package_manager" == "apt" ]]; then
            apt-get remove -y sudo
            apt-get autoremove -y
        elif [[ "$package_manager" == "yum" ]]; then
            yum remove -y sudo
        elif [[ "$package_manager" == "dnf" ]]; then
            dnf remove -y sudo
        elif [[ "$package_manager" == "pacman" ]]; then
            pacman -R --noconfirm sudo
        elif [[ "$package_manager" == "zypper" ]]; then
            zypper remove -y sudo
        fi
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ sudo 已卸载！${NC}"
            echo -e "${RED}⚠️ 警告：sudo已卸载，您现在只能使用root账户。${NC}"
        else
            echo -e "${RED}✗ sudo 卸载失败！${NC}"
        fi
    else
        echo -e "${YELLOW}卸载操作已取消。${NC}"
    fi
    
    read -p "按任意键返回工具卸载菜单..." -n1 -s
    echo
}

# 批量卸载函数
function batch_uninstall() {
    local selected_tools=()
    local tool_names=("htop" "wget" "curl" "git" "unzip" "bzip2" "sudo")
    local tool_descriptions=(
        "交互式系统进程查看器"
        "命令行下载工具"
        "数据传输工具"
        "分布式版本控制系统"
        "压缩包解压工具"
        "块排序文件压缩器"
        "系统权限管理工具"
    )
    
    # 创建选择数组
    local selections=()
    for tool in "${tool_names[@]}"; do
        if command -v "$tool" &> /dev/null; then
            selections+=("0") # 0表示未选中，1表示选中
        else
            selections+=("-") # -表示未安装，不可选
        fi
    done
    
    # 批量选择菜单
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${RED}           批量卸载选择${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${YELLOW}请选择要卸载的工具（空格键选择/取消）：${NC}"
        echo ""
        
        for i in "${!tool_names[@]}"; do
            local tool_name="${tool_names[$i]}"
            local status="${selections[$i]}"
            local desc="${tool_descriptions[$i]}"
            
            if [[ "$status" == "-" ]]; then
                echo -e " [${GRAY}-${NC}] ${GRAY}$(($i+1)). $tool_name - $desc ${RED}✗ 未安装${NC}"
            elif [[ "$status" == "1" ]]; then
                echo -e " [${GREEN}✓${NC}] ${GREEN}$(($i+1)). $tool_name - $desc ${GREEN}✓ 已选择${NC}"
            else
                echo -e " [ ] ${CYAN}$(($i+1)). $tool_name - $desc ${GREEN}✓ 已安装${NC}"
            fi
        done
        
        echo ""
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${GREEN}空格键${NC}: 选择/取消选择"
        echo -e " ${GREEN}回车键${NC}: 确认选择"
        echo -e " ${RED}q${NC}: 返回工具卸载菜单"
        echo -e "${CYAN}=========================================${NC}"
        
        # 获取已选择的工具
        selected_tools=()
        local selected_count=0
        for i in "${!selections[@]}"; do
            if [[ "${selections[$i]}" == "1" ]]; then
                selected_tools+=("${tool_names[$i]}")
                ((selected_count++))
            fi
        done
        
        if [[ $selected_count -gt 0 ]]; then
            echo -e "${YELLOW}已选择: ${selected_tools[*]}${NC}"
        fi
        
        # 读取按键
        read -rsn1 key
        
        case "$key" in
            " ")
                # 处理空格键选择
                echo -e -n "\033[1A\033[2K" # 清除上一行
                read -p "请选择编号(1-7): " -n1 index
                echo
                
                local idx=$((index-1))
                if [[ $idx -ge 0 && $idx -lt ${#tool_names[@]} && "${selections[$idx]}" != "-" ]]; then
                    if [[ "${selections[$idx]}" == "0" ]]; then
                        selections[$idx]="1"
                    elif [[ "${selections[$idx]}" == "1" ]]; then
                        selections[$idx]="0"
                    fi
                else
                    echo -e "${RED}无效的选择！${NC}"
                    sleep 1
                fi
                ;;
            "")
                # 回车键确认选择
                if [[ $selected_count -eq 0 ]]; then
                    echo -e "${YELLOW}请至少选择一个工具！${NC}"
                    sleep 1
                    continue
                fi
                break
                ;;
            "q"|"Q")
                echo -e "${YELLOW}返回工具卸载菜单...${NC}"
                sleep 1
                return
                ;;
        esac
    done
    
    # 确认批量卸载
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}           批量卸载确认${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${YELLOW}您确定要批量卸载以下工具吗？${NC}"
    echo ""
    
    for tool in "${selected_tools[@]}"; do
        echo -e " • ${CYAN}$tool${NC}"
    done
    
    echo ""
    echo -e "${RED}警告：这将永久删除这些工具及其配置！${NC}"
    echo -e "${CYAN}-----------------------------------------${NC}"
    echo -e " ${GREEN}1.${NC} 确认批量卸载"
    echo -e " ${RED}2.${NC} 重新选择"
    echo -e " ${RED}3.${NC} 取消"
    echo -e "${CYAN}=========================================${NC}"
    read -p "请选择(1-3): " confirm_choice

    case "$confirm_choice" in
        1)
            local success_count=0
            local fail_count=0
            
            echo -e "${YELLOW}开始批量卸载...${NC}"
            echo ""
            
            for tool in "${selected_tools[@]}"; do
                echo -e "${YELLOW}[卸载 $tool]${NC}"
                
                # 根据包管理器卸载
                case "$package_manager" in
                    apt)
                        apt-get remove -y "$tool"
                        ;;
                    yum)
                        yum remove -y "$tool"
                        ;;
                    dnf)
                        dnf remove -y "$tool"
                        ;;
                    pacman)
                        pacman -R --noconfirm "$tool"
                        ;;
                    zypper)
                        zypper remove -y "$tool"
                        ;;
                esac
                
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}  ✓ $tool 卸载成功${NC}"
                    ((success_count++))
                else
                    echo -e "${RED}  ✗ $tool 卸载失败${NC}"
                    ((fail_count++))
                fi
                echo ""
            done
            
            # 清理残留
            if [[ "$package_manager" == "apt" ]]; then
                apt-get autoremove -y
            fi
            
            echo -e "${CYAN}-----------------------------------------${NC}"
            echo -e "${GREEN}批量卸载完成！${NC}"
            echo -e "成功: ${GREEN}$success_count${NC} 个"
            echo -e "失败: ${RED}$fail_count${NC} 个"
            ;;
        2)
            batch_uninstall
            return
            ;;
        3)
            echo -e "${YELLOW}批量卸载已取消。${NC}"
            ;;
        *)
            echo -e "${RED}无效的选择，操作已取消。${NC}"
            ;;
    esac
    
    read -p "按任意键返回工具卸载菜单..." -n1 -s
    echo
}

# 安装bzip2函数（保持不变）
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

# 安装sudo函数（保持不变）
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

# 通用安装函数（如果未定义）
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

# 颜色变量定义
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
if [ -z "$GRAY" ]; then
    GRAY='\033[0;90m'
fi
if [ -z "$NC" ]; then
    NC='\033[0m' # No Color
fi

# 设置包管理器变量
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