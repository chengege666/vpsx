#!/bin/bash

# 获取脚本所在目录的绝对路径
BASE_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# 检查依赖目录是否存在
if [ ! -d "${BASE_PATH}/modules" ] || [ ! -d "${BASE_PATH}/utils" ]; then
    echo -e "\033[31m错误: 找不到 modules 或 utils 目录。\033[0m"
    echo -e "\033[33m请确保您下载了完整的项目文件夹，而不仅仅是 vpsx.sh 文件。\033[0m"
    echo -e "建议使用以下命令重新安装："
    echo -e "\033[32mgit clone https://github.com/chengege666/vpsx.git /root/vpsx\033[0m"
    exit 1
fi

# 导入颜色定义
source "${BASE_PATH}/utils/color.sh"
# 导入通用函数
source "${BASE_PATH}/utils/common.sh"

# 导入功能模块
source "${BASE_PATH}/modules/sys_info.sh"
source "${BASE_PATH}/modules/sys_update.sh"
source "${BASE_PATH}/modules/base_tools.sh"
source "${BASE_PATH}/modules/sys_cleanup.sh"
source "${BASE_PATH}/modules/bbr.sh"
source "${BASE_PATH}/modules/docker.sh"
source "${BASE_PATH}/modules/sys_tools.sh"
source "${BASE_PATH}/modules/vps_test.sh"
source "${BASE_PATH}/modules/shortcut.sh"
source "${BASE_PATH}/modules/proxy_tools.sh"
source "${BASE_PATH}/modules/app_center.sh"
source "${BASE_PATH}/modules/self_manage.sh"

# 主菜单函数
show_menu() {
    clear
    echo -e "${CYAN}================================================${NC}"
    echo -e "${GREEN}            vpsx 主菜单 v1.0            ${NC}"
    echo -e "${CYAN}================================================${NC}"
    echo -e " ${GREEN}1.${NC}   系统信息查询"
    echo -e " ${GREEN}2.${NC}   系统更新"
    echo -e " ${GREEN}3.${NC}   系统清理"
    echo -e " ${GREEN}4.${NC}   基础工具"
    echo -e " ${GREEN}5.${NC}   BBR管理"
    echo -e " ${GREEN}6.${NC}   Docker管理"
    echo -e " ${GREEN}7.${NC}   系统工具"
    echo -e " ${GREEN}8.${NC}   重启服务器"
    echo -e " ${GREEN}9.${NC}   VPS测试脚本"
    echo -e " ${GREEN}10.${NC}  一键配置启动快捷键"
    echo -e " ${GREEN}11.${NC}  搭建节点工具"
    echo -e " ${GREEN}12.${NC}  应用中心"
    echo -e "${CYAN}------------------------------------------------${NC}"
    echo -e " ${YELLOW}000.${NC} 脚本更新"
    echo -e " ${YELLOW}00.${NC}  卸载此脚本"
    echo -e " ${RED}0.${NC}   退出脚本"
    echo -e "${CYAN}================================================${NC}"
}

# 退出脚本函数
exit_script() {
    clear
    echo -e "${CYAN}================================================${NC}"
    echo -e "${GREEN}        感谢使用 vpsx 脚本，祝您生活愉快！${NC}"
    echo -e "${CYAN}================================================${NC}"
    exit 0
}

# 循环处理用户输入
main() {
    while true; do
        show_menu
        read -p "请输入选项: " choice
        case $choice in
            1)
                system_info_query
                ;;
            2)
                system_update
                ;;
            3)
                system_cleanup
                ;;
            4)
                basic_tools_menu
                continue
                ;;
            5)
                bbr_menu
                continue
                ;;
            6)
                docker_menu
                continue
                ;;
            7)
                sys_tools_menu
                continue
                ;;
            8)
                reboot_system
                ;;
            9)
                vps_test_menu
                continue
                ;;
            10)
                shortcut_menu
                continue
                ;;
            11)
                node_tools_menu
                continue
                ;;
            12)
                app_center_menu
                continue
                ;;
            000)
                update_script
                ;;
            00)
                uninstall_script
                ;;
            0)
                exit_script
                ;;
            *)
                echo -e "${RED}输入错误，请输入正确的数字选项！${NC}"
                sleep 2
                continue
                ;;
        esac
        echo -e "${YELLOW}按任意键返回主菜单...${NC}"
        read -n 1
    done
}

# 启动脚本
main
