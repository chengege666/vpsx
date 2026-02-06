#!/bin/bash

# 导入颜色定义
source ./utils/color.sh
# 导入通用函数
source ./utils/common.sh

# 导入功能模块
source ./modules/sys_info.sh
source ./modules/sys_update.sh
source ./modules/base_tools.sh
source ./modules/sys_cleanup.sh
source ./modules/bbr.sh
source ./modules/docker.sh
source ./modules/sys_tools.sh
source ./modules/vps_test.sh
source ./modules/shortcut.sh
source ./modules/proxy_tools.sh
source ./modules/app_center.sh
source ./modules/self_manage.sh

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
    echo -e " ${GREEN}10.${NC}  一键配置启动快捷键（k）"
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
                ;;
            5)
                bbr_menu
                ;;
            6)
                docker_menu
                ;;
            7)
                sys_tools_menu
                ;;
            8)
                reboot_system
                ;;
            9)
                vps_test_menu
                ;;
            10)
                setup_shortcut
                ;;
            11)
                node_tools_menu
                ;;
            12)
                app_center_menu
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
                ;;
        esac
        echo -e "${YELLOW}按任意键返回主菜单...${NC}"
        read -n 1
    done
}

# 启动脚本
main
