#!/bin/bash

# 系统工具模块

# 系统工具菜单
function sys_tools_menu() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             系统工具菜单${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  高级防火墙管理"
        echo -e " ${GREEN}2.${NC}  修改登录密码"
        echo -e " ${GREEN}3.${NC}  修改SSH连接端口"
        echo -e " ${GREEN}4.${NC}  切换优先IPV4/IPV6"
        echo -e " ${GREEN}5.${NC}  修改主机名"
        echo -e " ${GREEN}6.${NC}  系统时区调整"
        echo -e " ${GREEN}7.${NC}  修改虚拟内存大小(Swap)"
        echo -e " ${GREEN}8.${NC}  内存加速清理（释放缓存）"
        echo -e " ${GREEN}9.${NC}  修改DNS服务器（手动/自动）"
        echo -e " ${GREEN}10.${NC} Fail2ban配置（SSH防护）"
        echo -e " ${GREEN}11.${NC} SSL证书管理（Let's Encrypt）"
        echo -e " ${GREEN}12.${NC} 进程管理工具（查看/终止）"
        echo -e " ${GREEN}13.${NC} 系统环境修复 (权限/磁盘/APT)"
        echo -e " ${GREEN}14.${NC} 配置中文语言支持 (Debian/Ubuntu)"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回主菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择: " sys_tools_choice

        case "$sys_tools_choice" in
            1)
                advanced_firewall_management
                ;;
            2)
                change_login_password
                ;;
            3)
                change_ssh_port
                ;;
            4)
                switch_ip_priority
                ;;
            5)
                change_hostname
                ;;
            6)
                adjust_system_timezone
                ;;
            7)
                change_swap_size
                ;;
            8)
                accelerate_memory_clean
                ;;
            9)
                modify_dns_server
                ;;
            10)
                fail2ban_management
                ;;
            11)
                ssl_certificate_management
                ;;
            12)
                process_management
                ;;
            13)
                system_environment_repair
                ;;
           14)
                configure_chinese_locale
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

# 高级防火墙管理
function advanced_firewall_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          高级防火墙管理${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  开放指定端口"
        echo -e " ${GREEN}2.${NC}  关闭指定端口"
        echo -e " ${GREEN}3.${NC}  开放所有端口"
        echo -e " ${GREEN}4.${NC}  关闭所有端口"
        echo -e " ${GREEN}5.${NC}  IP 白名单"
        echo -e " ${GREEN}6.${NC}  IP 黑名单"
        echo -e " ${GREEN}7.${NC}  清除指定IP"
        echo -e " ${GREEN}8.${NC}  查看已开放端口"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${GREEN}11.${NC} 允许 PING"
        echo -e " ${GREEN}12.${NC} 禁止 PING"
        echo -e " ${GREEN}13.${NC} 启动 DDOS 防御"
        echo -e " ${GREEN}14.${NC} 关闭 DDOS 防御"
        echo -e " ${GREEN}15.${NC} 阻止指定国家IP"
        echo -e " ${GREEN}16.${NC} 仅允许指定国家IP"
        echo -e " ${GREEN}17.${NC} 解除指定国家IP限制"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择: " firewall_choice

        case "$firewall_choice" in
            1) open_specified_port ;;
            2) close_specified_port ;;
            3) open_all_ports ;;
            4) close_all_ports ;;
            5) ip_whitelist ;;
            6) ip_blacklist ;;
            7) clear_specified_ip ;;
            8) view_port_occupancy_status ;;
            11) allow_ping ;;
            12) disable_ping ;;
            13) enable_ddos_protection ;;
            14) disable_ddos_protection ;;
            15) block_specified_country_ip ;;
            16) allow_only_specified_country_ip ;;
            17) unblock_specified_country_ip ;;
            0) break ;;
            *) echo -e "${RED}无效的选择，请重新输入！${NC}"; read -p "按任意键继续..." ;;
        esac
    done
}

# 防火墙子功能实现
function open_specified_port() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          开放指定端口${NC}"
    echo -e "${CYAN}=========================================${NC}"
    read -p "请输入要开放的端口号: " port
    if [ -z "$port" ]; then
        echo -e "${RED}端口号不能为空。${NC}"
    else
        if command -v ufw &> /dev/null; then
            ufw allow "$port"
            echo -e "${GREEN}UFW: 端口 $port 已开放。${NC}"
        elif command -v firewall-cmd &> /dev/null; then
            firewall-cmd --permanent --add-port="$port"/tcp
            firewall-cmd --permanent --add-port="$port"/udp
            firewall-cmd --reload
            echo -e "${GREEN}Firewalld: 端口 $port (TCP/UDP) 已开放。${NC}"
        else
            iptables -I INPUT -p tcp --dport "$port" -j ACCEPT
            iptables -I INPUT -p udp --dport "$port" -j ACCEPT
            echo -e "${GREEN}Iptables: 端口 $port 已开放。${NC}"
        fi
    fi
    read -p "按任意键继续..."
}

# Fail2ban 配置管理
function fail2ban_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             Fail2ban 配置管理${NC}"
        echo -e "${CYAN}=========================================${NC}"
        
        # 显示运行状态
        local status_text="${RED}未安装${NC}"
        local ssh_jail_status="${YELLOW}未知${NC}"
        
        if command -v fail2ban-client &> /dev/null; then
            if systemctl is-active --quiet fail2ban; then
                status_text="${GREEN}运行中${NC}"
            else
                status_text="${YELLOW}已停止${NC}"
            fi
            
            # 检查 SSH jail 是否启用
            if [ -f /etc/fail2ban/jail.local ]; then
                if grep -q "enabled = true" /etc/fail2ban/jail.local; then
                    ssh_jail_status="${GREEN}已启用${NC}"
                else
                    ssh_jail_status="${RED}已禁用${NC}"
                fi
            else
                ssh_jail_status="${YELLOW}未配置${NC}"
            fi
        fi
        
        echo -e "          服务状态: ${status_text}"
        echo -e "     SSH 防护状态: ${ssh_jail_status}"
        echo -e "${CYAN}-----------------------------------------${NC}"
        
        echo -e " ${GREEN}1.${NC}  安装 Fail2ban"
        echo -e " ${GREEN}2.${NC}  查看 Fail2ban 运行状态（按q退出）"
        echo -e " ${GREEN}3.${NC}  启用/禁用 SSH 暴力破解防护"
        echo -e " ${GREEN}4.${NC}  查看当前已封禁的 IP 列表"
        echo -e " ${GREEN}5.${NC}  手动解封指定 IP"
        echo -e " ${GREEN}6.${NC}  卸载 Fail2ban"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择: " f2b_choice

        case "$f2b_choice" in
            1)
                echo -e "${YELLOW}正在安装 Fail2ban...${NC}"
                if command -v apt &> /dev/null; then
                    apt update && apt install -y fail2ban
                elif command -v yum &> /dev/null; then
                    yum install -y epel-release
                    yum install -y fail2ban
                fi
                systemctl enable fail2ban
                systemctl start fail2ban
                echo -e "${GREEN}Fail2ban 安装并启动完成。${NC}"
                read -p "按任意键继续..."
                ;;
            2)
                systemctl status fail2ban
                read -p "按任意键继续..."
                ;;
            3)
                # 自动检测 SSH 日志路径和系统类型
                local log_path=""
                local backend="auto"
                
                if [ -f /var/log/auth.log ]; then
                    log_path="/var/log/auth.log"
                elif [ -f /var/log/secure ]; then
                    log_path="/var/log/secure"
                else
                    # 如果找不到传统日志文件，尝试使用 systemd 后端
                    backend="systemd"
                fi

                if [ -f /etc/fail2ban/jail.local ]; then
                    if grep -q "enabled = true" /etc/fail2ban/jail.local; then
                        sed -i 's/enabled = true/enabled = false/g' /etc/fail2ban/jail.local
                        echo -e "${YELLOW}SSH 防护已禁用。${NC}"
                    else
                        sed -i 's/enabled = false/enabled = true/g' /etc/fail2ban/jail.local
                        echo -e "${GREEN}SSH 防护已启用。${NC}"
                    fi
                else
                    # 自动化创建配置
                    echo -e "${BLUE}正在根据系统环境生成自动配置...${NC}"
                    cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
# 忽略本机 IP
ignoreip = 127.0.0.1/8 ::1

[sshd]
enabled = true
port = ssh
filter = sshd
$( [ "$backend" = "systemd" ] && echo "backend = systemd" || echo "logpath = $log_path" )
maxretry = 5
findtime = 600
bantime = 3600
EOF
                    echo -e "${GREEN}已自动适配系统环境并启用 SSH 防护。${NC}"
                    [ "$backend" = "systemd" ] && echo -e "${CYAN}检测到系统使用 systemd 日志，已自动切换后端。${NC}"
                fi
                systemctl restart fail2ban
                read -p "按任意键继续..."
                ;;
            4)
                echo -e "${GREEN}当前已封禁的 IP 列表:${NC}"
                fail2ban-client status sshd
                read -p "按任意键继续..."
                ;;
            5)
                read -p "请输入要解封的 IP: " unban_ip
                fail2ban-client set sshd unbanip "$unban_ip"
                echo -e "${GREEN}已尝试解封 IP: $unban_ip${NC}"
                read -p "按任意键继续..."
                ;;
            6)
                read -p "确定要卸载 Fail2ban 吗？(y/N): " confirm_uninstall
                if [[ "$confirm_uninstall" =~ ^[Yy]$ ]]; then
                    systemctl stop fail2ban
                    systemctl disable fail2ban
                    if command -v apt &> /dev/null; then
                        apt purge -y fail2ban
                    elif command -v yum &> /dev/null; then
                        yum remove -y fail2ban
                    fi
                    rm -rf /etc/fail2ban
                    echo -e "${GREEN}Fail2ban 已卸载。${NC}"
                fi
                read -p "按任意键继续..."
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

# SSL 证书管理 (acme.sh)
function ssl_certificate_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             SSL 证书管理 (acme.sh)${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  安装 acme.sh 脚本"
        echo -e " ${GREEN}2.${NC}  申请 SSL 证书 (HTTP 验证 - 需 80 端口)"
        echo -e " ${GREEN}3.${NC}  申请 SSL 证书 (DNS 验证 - 支持泛域名)"
        echo -e " ${GREEN}4.${NC}  查看已申请的证书列表"
        echo -e " ${GREEN}5.${NC}  手动续签现有证书"
        echo -e " ${GREEN}6.${NC}  卸载 acme.sh"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择: " ssl_choice

        case "$ssl_choice" in
            1)
                echo -e "${YELLOW}正在安装 acme.sh...${NC}"
                curl https://get.acme.sh | sh
                alias acme.sh=~/.acme.sh/acme.sh
                echo -e "${GREEN}acme.sh 安装完成。请重新连接 SSH 或运行 'source ~/.bashrc' 以使 alias 生效。${NC}"
                read -p "按任意键继续..."
                ;;
            2)
                read -p "请输入要申请证书的域名: " domain
                read -p "请输入网站根目录 (例如 /var/www/html): " web_root
                ~/.acme.sh/acme.sh --issue -d "$domain" --webroot "$web_root"
                read -p "按任意键继续..."
                ;;
            3)
                echo -e "${YELLOW}DNS 验证需要配置 API Key，请确保已设置环境变量。${NC}"
                read -p "请输入要申请证书的域名 (例如 *.example.com): " domain
                read -p "请输入 DNS 提供商 (例如 dns_cf, dns_ali): " dns_provider
                ~/.acme.sh/acme.sh --issue -d "$domain" --dns "$dns_provider"
                read -p "按任意键继续..."
                ;;
            4)
                ~/.acme.sh/acme.sh --list
                read -p "按任意键继续..."
                ;;
            5)
                read -p "请输入要续签的域名: " domain
                ~/.acme.sh/acme.sh --renew -d "$domain" --force
                read -p "按任意键继续..."
                ;;
            6)
                ~/.acme.sh/acme.sh --uninstall
                rm -rf ~/.acme.sh
                echo -e "${GREEN}acme.sh 已卸载。${NC}"
                read -p "按任意键继续..."
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

# 进程管理工具
function process_management() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}             进程管理工具）${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  实时进程监控 (输入q退出)"
        echo -e " ${GREEN}2.${NC}  查找并结束进程 (按名称/PID)"
        echo -e " ${GREEN}3.${NC}  系统服务管理 (systemd)"
        echo -e " ${GREEN}4.${NC}  查看网络端口占用情况"
        echo -e " ${GREEN}5.${NC}  进程树查看 (pstree)"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择: " proc_choice

        case "$proc_choice" in
            1)
                if command -v htop &> /dev/null; then
                    htop
                else
                    top
                fi
                ;;
            2)
                read -p "请输入要查找的进程名称或 PID: " search_term
                ps aux | grep -i "$search_term" | grep -v grep
                read -p "请输入要结束的 PID (输入 0 取消): " kill_pid
                if [ "$kill_pid" != "0" ]; then
                    kill -9 "$kill_pid"
                    echo -e "${GREEN}已尝试终止进程 $kill_pid${NC}"
                fi
                read -p "按任意键继续..."
                ;;
            3)
                read -p "请输入服务名称 (例如 nginx, fail2ban): " service_name
                echo -e "请选择操作: ${GREEN}1.启动 2.停止 3.重启 4.状态 5.启用自启 6.禁用自启${NC}"
                read -p "操作选择: " svc_op
                case "$svc_op" in
                    1) systemctl start "$service_name" ;;
                    2) systemctl stop "$service_name" ;;
                    3) systemctl restart "$service_name" ;;
                    4) systemctl status "$service_name" ;;
                    5) systemctl enable "$service_name" ;;
                    6) systemctl disable "$service_name" ;;
                esac
                read -p "按任意键继续..."
                ;;
            4)
                view_port_occupancy_status
                ;;
            5)
                if command -v pstree &> /dev/null; then
                    pstree -p
                else
                    echo -e "${RED}未安装 pstree，正在安装...${NC}"
                    apt install -y psmisc || yum install -y psmisc
                    pstree -p
                fi
                read -p "按任意键继续..."
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

# 系统环境修复 (进阶版)
function system_environment_repair() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}             系统环境深度修复工具${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    # 1. 诊断阶段：检查磁盘与 Inode
    echo -e "${BLUE}[1/7] 正在诊断磁盘空间与 Inode 使用率...${NC}"
    df -h / | grep -v "Filesystem"
    # 检查 Inode (很多时候磁盘有空间但文件数满了也会报错)
    inode_usage=$(df -i / | awk 'NR==2 {print $5}' | cut -d'%' -f1)
    if [ "$inode_usage" -gt 95 ]; then
        echo -e "${RED}⚠️ 警告: Inode 使用率过高 ($inode_usage%)，建议清理小文件！${NC}"
    fi
    echo ""

    # 2. 修复包管理器锁 (针对 Debian/Ubuntu)
    if command -v apt &> /dev/null; then
        echo -e "${BLUE}[2/7] 正在解除 APT 进程锁 (防止其他安装任务占用)...${NC}"
        rm -f /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock /var/cache/apt/archives/lock
        dpkg --configure -a
        echo -e "${GREEN}✅ 锁文件检查完成。${NC}"
    fi
    echo ""

    # 3. 修复损坏的依赖
    echo -e "${BLUE}[3/7] 正在尝试修复损坏的软件包依赖...${NC}"
    if command -v apt &> /dev/null; then
        apt-get install -f -y
    elif command -v yum &> /dev/null; then
        yum check
    fi
    echo -e "${GREEN}✅ 依赖关系审计完成。${NC}"
    echo ""

    # 4. 深度清理日志 (清理 1 天前的系统日志)
    echo -e "${BLUE}[4/7] 正在清理 systemd 日志以释放空间...${NC}"
    if command -v journalctl &> /dev/null; then
        journalctl --vacuum-time=1d
        echo -e "${GREEN}✅ 系统日志已压缩至最近24小时。${NC}"
    fi
    echo ""

    # 5. 时间同步 (防止 SSL/TLS 握手失败)
    echo -e "${BLUE}[5/7] 正在校准系统时间 (NTP 同步)...${NC}"
    if command -v timedatectl &> /dev/null; then
        timedatectl set-ntp true
        echo -e "${GREEN}✅ NTP 同步已启用，当前时间: $(date)${NC}"
    fi
    echo ""

    # 6. 权限修复 (关键目录)
    echo -e "${BLUE}[6/7] 正在修复标准目录权限...${NC}"
    [ -d /tmp ] && chmod 1777 /tmp && echo -e "${CYAN}- /tmp (1777) OK${NC}"
    [ -d /var/tmp ] && chmod 1777 /var/tmp && echo -e "${CYAN}- /var/tmp (1777) OK${NC}"
    echo ""

    # 7. 软件源同步
    echo -e "${BLUE}[7/7] 正在执行最终的仓库数据同步...${NC}"
    if command -v apt &> /dev/null; then
        apt-get update -y
    elif command -v yum &> /dev/null; then
        yum makecache
    fi

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ 系统环境修复成功！${NC}"
    else
        echo -e "${RED}❌ 软件源同步仍有异常，请检查网络连接。${NC}"
    fi
    
    echo -e "${CYAN}=========================================${NC}"
    read -p "修复流程结束，按任意键返回菜单..."
}

 # 系统时区调整
function adjust_system_timezone() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          系统时区调整${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "当前时区: ${YELLOW}$(timedatectl show --property=Timezone --value)${NC}"
    echo ""
    echo -e "请选择一个常用时区或手动输入:"
    echo -e " ${GREEN}1.${NC} Asia/Shanghai (亚洲/上海)"
    echo -e " ${GREEN}2.${NC} Asia/Tokyo (亚洲/东京)"
    echo -e " ${GREEN}3.${NC} America/New_York (美洲/纽约)"
    echo -e " ${GREEN}4.${NC} Europe/London (欧洲/伦敦)"
    echo -e " ${GREEN}5.${NC} 手动输入时区"
    echo -e " ${RED}0.${NC} 返回"
    read -p "请输入你的选择 (0-5): " choice

    new_timezone=""
    case $choice in
        1) new_timezone="Asia/Shanghai" ;;
        2) new_timezone="Asia/Tokyo" ;;
        3) new_timezone="America/New_York" ;;
        4) new_timezone="Europe/London" ;;
        5)
            read -p "请输入新的时区 (例如: Asia/Shanghai, America/New_York): " custom_timezone
            if [[ -z "$custom_timezone" ]]; then
                echo -e "${RED}时区不能为空。${NC}"
                read -p "按任意键继续..."
                return
            fi
            new_timezone="$custom_timezone"
            ;;
        0) return ;;
        *) echo -e "${RED}无效的选择，请重新输入。${NC}"; read -p "按任意键继续..." ; return ;;
    esac

    echo -e "${YELLOW}正在设置时区为 $new_timezone...${NC}"
    timedatectl set-timezone $new_timezone

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}时区已成功设置为 $new_timezone。${NC}"
    else
        echo -e "${RED}时区设置失败，请检查时区名称是否正确。${NC}"
    fi
    read -p "按任意键继续..."
}

# 修改虚拟内存大小(Swap)
function change_swap_size() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          修改虚拟内存大小(Swap)${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "当前Swap信息:"
    free -h | grep Swap
    echo ""
    read -p "请输入新的Swap大小 (单位MB, 例如: 2048): " new_swap_mb

    if [[ -z "$new_swap_mb" ]]; then
        echo -e "${RED}Swap大小不能为空。${NC}"
        read -p "按任意键继续..."
        return
    fi

    if ! [[ "$new_swap_mb" =~ ^[0-9]+$ ]] || (( new_swap_mb < 0 )); then
        echo -e "${RED}无效的Swap大小。请输入一个非负整数。${NC}"
        read -p "按任意键继续..."
        return
    fi

    echo -e "${YELLOW}正在禁用所有Swap...${NC}"
    swapoff -a

    echo -e "${YELLOW}正在删除旧的Swap文件...${NC}"
    rm -f /swapfile

    if (( new_swap_mb > 0 )); then
        echo -e "${YELLOW}正在创建新的Swap文件，大小为 ${new_swap_mb}MB...${NC}"
        fallocate -l ${new_swap_mb}M /swapfile
        chmod 600 /swapfile
        mkswap /swapfile
        swapon /swapfile

        # Make it persistent (Check if already exists)
        if ! grep -q "^/swapfile" /etc/fstab; then
            echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
            echo -e "${GREEN}Swap 已添加至 /etc/fstab 实现持久化。${NC}"
        else
            echo -e "${YELLOW}Swap 条目已存在于 /etc/fstab 中，跳过写入。${NC}"
        fi
        echo -e "${GREEN}新的Swap已成功创建并启用。${NC}"
    else
        # Remove from fstab if swap is set to 0
        sed -i '/swapfile/d' /etc/fstab
        echo -e "${GREEN}Swap已禁用。${NC}"
    fi

    echo ""
    echo -e "${GREEN}当前Swap信息:${NC}"
    free -h | grep Swap
    read -p "按任意键继续..."
}

# 内存加速清理
function accelerate_memory_clean() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            内存加速清理工具            ${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    # 显示当前内存状态
    echo -e "${GREEN}=== 当前内存状态 ===${NC}"
    free -h
    echo ""
    
    echo -e "${YELLOW}⚠️ 内存加速清理将释放缓存，可能会暂时影响性能${NC}"
    read -p "是否继续执行内存加速清理？(y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo -e "${YELLOW}已取消内存加速清理${NC}"
        read -p "按回车键返回菜单..."
        return
    fi
    
    echo -e "${BLUE}开始内存加速清理...${NC}"
    
    # 记录清理前内存状态
    MEM_BEFORE=$(free -m | awk 'NR==2{printf "Used: %sMB, Free: %sMB, Cached: %sMB", $3, $4, $6}')
    
    # 1. 同步数据到磁盘
    echo -e "${CYAN}[1/6] 同步数据到磁盘...${NC}"
    sync
    
    # 2. 清理页面缓存
    echo -e "${CYAN}[2/6] 清理页面缓存...${NC}"
    echo 1 > /proc/sys/vm/drop_caches 2>/dev/null
    
    # 3. 清理目录项和inode缓存
    echo -e "${CYAN}[3/6] 清理目录项和inode缓存...${NC}"
    echo 2 > /proc/sys/vm/drop_caches 2>/dev/null
    
    # 4. 清理所有缓存（页面缓存+目录项+inode）
    echo -e "${CYAN}[4/6] 清理所有缓存...${NC}"
    echo 3 > /proc/sys/vm/drop_caches 2>/dev/null
    
    # 5. 清理slab缓存
    echo -e "${CYAN}[5/6] 清理slab缓存...${NC}"
    if command -v slabtop >/dev/null 2>&1; then
        echo -e "${YELLOW}优化slab分配器...${NC}"
    fi
    
    # 6. 重置swap（增加安全检查，防止内存溢出导致失联）
    echo -e "${CYAN}[6/6] 优化swap空间...${NC}"
    # 获取当前内存和Swap信息 (MB)
    local mem_info=$(free -m)
    local ram_free=$(echo "$mem_info" | awk '/Mem:/ {print $4 + $6 + $7}') # Free + Buffers + Cached
    local swap_used=$(echo "$mem_info" | awk '/Swap:/ {print $3}')
    
    if [ "$swap_used" -gt 0 ]; then
        # 预留 100MB 缓冲空间
        local required_mem=$((swap_used + 100))
        echo -e "${YELLOW}检测到已使用 Swap: ${swap_used}MB, 可用物理内存(含缓存): ${ram_free}MB${NC}"
        
        if [ "$ram_free" -gt "$required_mem" ]; then
            echo -e "${YELLOW}内存充足，正在尝试优化 Swap...${NC}"
            # 异步执行，并设置超时，防止挂死
            if timeout 60s swapoff -a && swapon -a; then
                echo -e "${GREEN}✅ Swap 空间已优化${NC}"
            else
                echo -e "${RED}❌ Swap 优化失败或超时，已跳过${NC}"
                swapon -a 2>/dev/null # 确保 swap 重新开启
            fi
        else
            echo -e "${RED}⚠️ 物理内存不足以容纳 Swap 数据（缺口 $((required_mem - ram_free))MB），已跳过 Swap 优化以防失联${NC}"
        fi
    else
        echo -e "${GREEN}✅ Swap 使用正常，无需优化${NC}"
    fi
    
    # 显示清理结果
    echo ""
    echo -e "${GREEN}=== 内存加速清理完成 ===${NC}"
    echo -e "${BLUE}清理前: $MEM_BEFORE${NC}"
    
    MEM_AFTER=$(free -m | awk 'NR==2{printf "Used: %sMB, Free: %sMB, Cached: %sMB", $3, $4, $6}')
    echo -e "${BLUE}清理后: $MEM_AFTER${NC}"
    
    # 显示释放的内存
    FREE_BEFORE=$(echo "$MEM_BEFORE" | grep -o 'Free: [0-9]*' | cut -d' ' -f2)
    FREE_AFTER=$(echo "$MEM_AFTER" | grep -o 'Free: [0-9]*' | cut -d' ' -f2)
    if [ -n "$FREE_BEFORE" ] && [ -n "$FREE_AFTER" ]; then
        MEM_FREED=$((FREE_AFTER - FREE_BEFORE))
        if [ "$MEM_FREED" -gt 0 ]; then
            echo -e "${GREEN}✅ 成功释放内存: ${MEM_FREED}MB${NC}"
        else
            echo -e "${YELLOW}⚠️ 内存释放效果不明显，可能已处于优化状态${NC}"
        fi
    fi
    
    echo ""
    echo -e "${YELLOW}💡 提示：内存清理是临时性的，系统会根据需要重新建立缓存${NC}"
    
    read -p "按回车键返回菜单..."
}

# 修改DNS服务器（独裁模式：强制覆盖 + 锁定文件）
function modify_dns_server() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}           修改 DNS 服务器${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    # --- 1. 显示当前实际生效的 DNS ---
    echo -e "${YELLOW}当前 DNS 解析配置:${NC}"
    # 直接读取 resolv.conf，因为我们要对它进行手术
    if [ -f /etc/resolv.conf ]; then
        grep -v '^#' /etc/resolv.conf | grep "nameserver" | head -n 3
    else
        echo "文件不存在或无法读取"
    fi
    echo -e "${CYAN}-----------------------------------------${NC}"

    # --- 2. 快捷选择 ---
    echo -e "请选择强制使用的 DNS 方案:"
    echo -e " ${GREEN}1.${NC} Google DNS (8.8.8.8, 8.8.4.4)"
    echo -e " ${GREEN}2.${NC} Cloudflare DNS (1.1.1.1, 1.0.0.1)"
    echo -e " ${GREEN}3.${NC} 阿里/腾讯 DNS (223.5.5.5, 119.29.29.29)"
    echo -e " ${GREEN}4.${NC} 自定义 DNS"
    echo -e " ${RED}0.${NC} 返回"
    read -p "请输入你的选择 (0-4): " choice

    # --- 3. 定义执行逻辑 (暴力重写) ---
    set_dns_strict() {
        local d1=$1
        local d2=$2

        echo -e "${YELLOW}正在执行强制覆盖...${NC}"

        # 第一步：解锁文件 (如果是之前被锁定的)
        if command -v chattr &> /dev/null; then
            chattr -i /etc/resolv.conf 2>/dev/null
        fi

        # 第二步：彻底删除旧文件/软链接
        # 这一步断开了与 systemd-resolved 或 DHCP 的任何动态关联
        rm -f /etc/resolv.conf

        # 第三步：创建全新的静态文件
        echo -e "${BLUE}> 创建静态 /etc/resolv.conf 文件${NC}"
        touch /etc/resolv.conf
        
        echo "; Generated by SysTools Script - Strict Mode" > /etc/resolv.conf
        echo "nameserver $d1" >> /etc/resolv.conf
        if [[ -n "$d2" ]]; then
            echo "nameserver $d2" >> /etc/resolv.conf
        fi

        # 第四步：强制锁定文件
        # 加了 +i 属性后，连 root 都无法修改，DHCP/Systemd 更无法覆盖
        echo -e "${BLUE}> 锁定文件 (防止 DHCP/重启 还原)${NC}"
        if command -v chattr &> /dev/null; then
            chattr +i /etc/resolv.conf
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}文件已锁定 (chattr +i)。${NC}"
            else
                echo -e "${RED}警告: 锁定失败，这可能是因为文件系统不支持或权限不足。${NC}"
            fi
        else
            echo -e "${YELLOW}未找到 chattr 命令，跳过锁定步骤。${NC}"
        fi

        # 尝试让修改立即生效 (对于部分缓存服务)
        if command -v systemctl &> /dev/null; then
            # 如果有 nscd 缓存服务则重启，没有则忽略
            systemctl restart nscd 2>/dev/null
        fi

        echo -e "${GREEN}✅ DNS 修改完成！${NC}"
        
        # --- 4. 验证结果 ---
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e "${YELLOW}修改后的实际 DNS (即刻生效):${NC}"
        grep "nameserver" /etc/resolv.conf
        echo -e "${CYAN}-----------------------------------------${NC}"
    }

    # --- 执行 ---
    case $choice in
        1) set_dns_strict "8.8.8.8" "8.8.4.4" ;;
        2) set_dns_strict "1.1.1.1" "1.0.0.1" ;;
        3) set_dns_strict "223.5.5.5" "119.29.29.29" ;;
        4)
            read -p "主DNS: " c1
            read -p "备DNS: " c2
            [[ -n "$c1" ]] && set_dns_strict "$c1" "$c2" || echo -e "${RED}不能为空${NC}"
            ;;
        0) return ;;
        *) echo -e "${RED}无效选择${NC}" ;;
    esac
    
    read -p "按任意键继续..."
}

function close_specified_port() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          关闭指定端口${NC}"
    echo -e "${CYAN}=========================================${NC}"
    read -p "请输入要关闭的端口号: " port
    if [ -z "$port" ]; then
        echo -e "${RED}端口号不能为空。${NC}"
    else
        if command -v ufw &> /dev/null; then
            ufw delete allow "$port"
            echo -e "${GREEN}UFW: 端口 $port 已关闭。${NC}"
        elif command -v firewall-cmd &> /dev/null; then
            firewall-cmd --permanent --remove-port="$port"/tcp
            firewall-cmd --permanent --remove-port="$port"/udp
            firewall-cmd --reload
            echo -e "${GREEN}Firewalld: 端口 $port 已关闭。${NC}"
        else
            iptables -D INPUT -p tcp --dport "$port" -j ACCEPT
            iptables -D INPUT -p udp --dport "$port" -j ACCEPT
            echo -e "${GREEN}Iptables: 端口 $port 已从放行列表中移除。${NC}"
        fi
    fi
    read -p "按任意键继续..."
}
function open_all_ports() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          开放所有端口${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}警告：开放所有端口会降低服务器安全性！${NC}"
    read -p "确认要开放所有端口吗？(y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        if command -v ufw &> /dev/null; then
            ufw disable
            echo -e "${GREEN}UFW 已关闭，所有端口已开放。${NC}"
        elif command -v firewall-cmd &> /dev/null; then
            systemctl stop firewalld
            systemctl disable firewalld
            echo -e "${GREEN}Firewalld 已停止，所有端口已开放。${NC}"
        else
            iptables -P INPUT ACCEPT
            iptables -F
            echo -e "${GREEN}Iptables 规则已清空，默认策略设为 ACCEPT。${NC}"
        fi
    else
        echo -e "${YELLOW}操作已取消。${NC}"
    fi
    read -p "按任意键继续..."
}

function close_all_ports() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          关闭所有端口${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}警告：这将启用默认拒绝策略（仅保留 SSH 22 端口）${NC}"
    read -p "确认要关闭所有非常规端口吗？(y/N): " confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
        if command -v ufw &> /dev/null; then
            ufw default deny incoming
            ufw allow 22/tcp
            ufw --force enable
            echo -e "${GREEN}UFW 已启用默认拒绝，仅放行 22 端口。${NC}"
        elif command -v firewall-cmd &> /dev/null; then
            systemctl start firewalld
            systemctl enable firewalld
            # 默认 firewalld 只放行 ssh
            echo -e "${GREEN}Firewalld 已启用。${NC}"
        else
            iptables -P INPUT DROP
            iptables -A INPUT -p tcp --dport 22 -j ACCEPT
            iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
            echo -e "${GREEN}Iptables 已设置为默认 DROP，仅放行 22 端口。${NC}"
        fi
    else
        echo -e "${YELLOW}操作已取消。${NC}"
    fi
    read -p "按任意键继续..."
}

function ip_whitelist() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            IP 白名单${NC}"
    echo -e "${CYAN}=========================================${NC}"
    read -p "请输入要加入白名单的IP地址: " ip_address
    if [ -z "$ip_address" ]; then
        echo -e "${RED}IP地址不能为空。${NC}"
    else
        if command -v ufw &> /dev/null; then
            ufw allow from "$ip_address"
            echo -e "${GREEN}UFW: IP $ip_address 已加入白名单。${NC}"
        elif command -v firewall-cmd &> /dev/null; then
            firewall-cmd --permanent --add-source="$ip_address"
            firewall-cmd --reload
            echo -e "${GREEN}Firewalld: IP $ip_address 已加入白名单。${NC}"
        else
            iptables -I INPUT -s "$ip_address" -j ACCEPT
            echo -e "${GREEN}Iptables: IP $ip_address 已加入白名单。${NC}"
        fi
    fi
    read -p "按任意键继续..."
}

function ip_blacklist() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            IP 黑名单${NC}"
    echo -e "${CYAN}=========================================${NC}"
    read -p "请输入要加入黑名单的IP地址: " ip_address
    if [ -z "$ip_address" ]; then
        echo -e "${RED}IP地址不能为空。${NC}"
    else
        if command -v ufw &> /dev/null; then
            ufw deny from "$ip_address"
            echo -e "${GREEN}UFW: IP $ip_address 已加入黑名单。${NC}"
        elif command -v firewall-cmd &> /dev/null; then
            firewall-cmd --permanent --add-rich-rule="rule family='ipv4' source address='$ip_address' reject"
            firewall-cmd --reload
            echo -e "${GREEN}Firewalld: IP $ip_address 已加入黑名单。${NC}"
        else
            iptables -I INPUT -s "$ip_address" -j DROP
            echo -e "${GREEN}Iptables: IP $ip_address 已加入黑名单。${NC}"
        fi
    fi
    read -p "按任意键继续..."
}

function clear_specified_ip() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          清除指定IP${NC}"
    echo -e "${CYAN}=========================================${NC}"
    read -p "请输入要清除的IP地址: " ip_address
    if [ -z "$ip_address" ]; then
        echo -e "${RED}IP地址不能为空。${NC}"
    else
        if command -v ufw &> /dev/null; then
            ufw delete allow from "$ip_address"
            ufw delete deny from "$ip_address"
            echo -e "${GREEN}UFW: IP $ip_address 的所有规则已清除。${NC}"
        elif command -v firewall-cmd &> /dev/null; then
            firewall-cmd --permanent --remove-source="$ip_address"
            firewall-cmd --permanent --remove-rich-rule="rule family='ipv4' source address='$ip_address' reject"
            firewall-cmd --reload
            echo -e "${GREEN}Firewalld: IP $ip_address 的相关规则已清除。${NC}"
        else
            iptables -D INPUT -s "$ip_address" -j ACCEPT 2>/dev/null
            iptables -D INPUT -s "$ip_address" -j DROP 2>/dev/null
            echo -e "${GREEN}Iptables: IP $ip_address 的相关规则已尝试移除。${NC}"
        fi
    fi
    read -p "按任意键继续..."
}

function view_port_occupancy_status() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          查看已开放端口${NC}"
    echo -e "${CYAN}=========================================${NC}"
    if command -v ss &> /dev/null; then
        ss -tuln
    else
        netstat -tuln
    fi
    echo -e "${CYAN}-----------------------------------------${NC}"
    read -p "按任意键继续..."
}

function allow_ping() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            允许 PING${NC}"
    echo -e "${CYAN}=========================================${NC}"
    sysctl -w net.ipv4.icmp_echo_ignore_all=0
    # 同时确保防火墙没有拦截
    if command -v ufw &> /dev/null; then
        ufw allow icmp
    elif command -v firewall-cmd &> /dev/null; then
        firewall-cmd --permanent --add-protocol=icmp
        firewall-cmd --reload
    fi
    echo -e "${GREEN}PING 已允许。${NC}"
    read -p "按任意键继续..."
}

function disable_ping() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}            禁止 PING${NC}"
    echo -e "${CYAN}=========================================${NC}"
    sysctl -w net.ipv4.icmp_echo_ignore_all=1
    echo -e "${GREEN}PING 已禁止。${NC}"
    read -p "按任意键继续..."
}

function enable_ddos_protection() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          启动 DDOS 防御${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${YELLOW}正在应用基础 DDOS 防护规则 (iptables rate limiting)...${NC}"
    
    # 限制每秒建立的新连接数
    iptables -A INPUT -p tcp --syn -m limit --limit 1/s --limit-burst 3 -j ACCEPT
    iptables -A INPUT -p tcp --syn -j DROP
    
    # 限制单个 IP 的最大连接数 (防止 CC)
    iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 50 -j DROP
    iptables -A INPUT -p tcp --dport 443 -m connlimit --connlimit-above 50 -j DROP
    
    # 屏蔽无效数据包
    iptables -A INPUT -m state --state INVALID -j DROP
    
    echo -e "${GREEN}基础 DDOS 防御已启动。${NC}"
    read -p "按任意键继续..."
}

function disable_ddos_protection() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          关闭 DDOS 防御${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${YELLOW}正在清除 DDOS 防护规则...${NC}"
    
    # 这里比较粗暴，建议用户手动检查 iptables 规则
    iptables -D INPUT -p tcp --syn -m limit --limit 1/s --limit-burst 3 -j ACCEPT 2>/dev/null
    iptables -D INPUT -p tcp --syn -j DROP 2>/dev/null
    iptables -D INPUT -p tcp --dport 80 -m connlimit --connlimit-above 50 -j DROP 2>/dev/null
    iptables -D INPUT -p tcp --dport 443 -m connlimit --connlimit-above 50 -j DROP 2>/dev/null
    iptables -D INPUT -m state --state INVALID -j DROP 2>/dev/null
    
    echo -e "${GREEN}DDOS 防御规则已尝试清除。${NC}"
    read -p "按任意键继续..."
}

function block_specified_country_ip() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          阻止指定国家IP${NC}"
    echo -e "${CYAN}=========================================${NC}"
    read -p "请输入要阻止的国家代码 (例如: CN): " country_code
    if [ -z "$country_code" ]; then
        echo -e "${RED}国家代码不能为空。${NC}"
    else
        country_code=$(echo "$country_code" | tr '[:upper:]' '[:lower:]')
        echo -e "${YELLOW}正在获取 $country_code 的 IP 列表并配置 ipset (这可能需要一点时间)...${NC}"
        
        if ! command -v ipset &> /dev/null; then
            echo -e "${BLUE}正在安装 ipset...${NC}"
            apt update && apt install -y ipset || yum install -y ipset
        fi
        
        ipset create "block_$country_code" hash:net 2>/dev/null
        curl -s -o "/tmp/$country_code.zone" "http://www.ipdeny.com/ipblocks/data/countries/$country_code.zone"
        
        if [ -s "/tmp/$country_code.zone" ]; then
            while read -r line; do
                ipset add "block_$country_code" "$line" 2>/dev/null
            done < "/tmp/$country_code.zone"
            iptables -I INPUT -m set --match-set "block_$country_code" src -j DROP
            echo -e "${GREEN}已成功阻止来自 $country_code 的所有 IP。${NC}"
        else
            echo -e "${RED}获取 IP 列表失败，请检查国家代码或网络。${NC}"
        fi
    fi
    read -p "按任意键继续..."
}

function allow_only_specified_country_ip() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        仅允许指定国家IP${NC}"
    echo -e "${CYAN}=========================================${NC}"
    read -p "请输入要允许的国家代码 (例如: CN): " country_code
    if [ -z "$country_code" ]; then
        echo -e "${RED}国家代码不能为空。${NC}"
    else
        country_code=$(echo "$country_code" | tr '[:upper:]' '[:lower:]')
        echo -e "${RED}⚠️ 警告：正在配置白名单策略，这可能导致您断开连接！${NC}"
        echo -e "${YELLOW}请确保您的当前 IP 属于该国家。${NC}"
        read -p "确认继续吗？(y/N): " confirm
        if [[ "$confirm" =~ ^[yY]$ ]]; then
            if ! command -v ipset &> /dev/null; then
                echo -e "${BLUE}正在安装 ipset...${NC}"
                apt update && apt install -y ipset || yum install -y ipset
            fi
            ipset create "allow_$country_code" hash:net 2>/dev/null
            curl -s -o "/tmp/$country_code.zone" "http://www.ipdeny.com/ipblocks/data/countries/$country_code.zone"
            if [ -s "/tmp/$country_code.zone" ]; then
                while read -r line; do
                    ipset add "allow_$country_code" "$line" 2>/dev/null
                done < "/tmp/$country_code.zone"
                # 允许指定国家，拒绝其他（除了本地和已建立的连接）
                iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
                iptables -A INPUT -i lo -j ACCEPT
                iptables -A INPUT -m set --match-set "allow_$country_code" src -j ACCEPT
                iptables -P INPUT DROP
                echo -e "${GREEN}现在仅允许来自 $country_code 的 IP 访问。${NC}"
            else
                echo -e "${RED}获取 IP 列表失败。${NC}"
            fi
        fi
    fi
    read -p "按任意键继续..."
}

function unblock_specified_country_ip() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}        解除指定国家IP限制${NC}"
    echo -e "${CYAN}=========================================${NC}"
    read -p "请输入要解除限制的国家代码 (例如: CN): " country_code
    if [ -z "$country_code" ]; then
        echo -e "${RED}国家代码不能为空。${NC}"
    else
        country_code=$(echo "$country_code" | tr '[:upper:]' '[:lower:]')
        echo -e "${YELLOW}正在解除 $country_code 的限制并清理 ipset 规则...${NC}"
        
        iptables -D INPUT -m set --match-set "block_$country_code" src -j DROP 2>/dev/null
        iptables -D INPUT -m set --match-set "allow_$country_code" src -j ACCEPT 2>/dev/null
        iptables -P INPUT ACCEPT
        
        ipset destroy "block_$country_code" 2>/dev/null
        ipset destroy "allow_$country_code" 2>/dev/null
        
        echo -e "${GREEN}来自 $country_code 的所有 IP 限制已解除。${NC}"
    fi
    read -p "按任意键继续..."
}

# 重启服务器功能
function reboot_system() {
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${RED}            重启服务器${NC}"
    echo -e "${CYAN}=========================================${NC}"
    read -p "确定要现在重启服务器吗？(y/N): " confirm_reboot
    if [[ "$confirm_reboot" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}正在重启服务器...${NC}"
        reboot
    else
        echo -e "${GREEN}已取消重启操作。${NC}"
    fi
}

# 修改登录密码
function change_login_password() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          修改登录密码${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "正在修改当前用户 ($USER) 的密码..."
    passwd $USER
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}密码修改成功。${NC}"
    else
        echo -e "${RED}密码修改失败。${NC}"
    fi
    read -p "按任意键继续..."
}

# 修改SSH连接端口
function change_ssh_port() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          修改SSH连接端口${NC}"
    echo -e "${CYAN}=========================================${NC}"
    current_ssh_port=$(grep -E "^Port" /etc/ssh/sshd_config | awk '{print $2}')
    if [ -z "$current_ssh_port" ]; then
        current_ssh_port=22
    fi
    echo -e "当前SSH端口号: ${YELLOW}$current_ssh_port${NC}"
    read -p "请输入新的SSH端口号: " new_port

    if [[ -z "$new_port" ]]; then
        echo -e "${RED}端口号不能为空。${NC}"
        read -p "按任意键继续..."
        return
    fi

    if ! [[ "$new_port" =~ ^[0-9]+$ ]] || (( new_port < 1 )) || (( new_port > 65535 )); then
        echo -e "${RED}无效的端口号。请输入一个介于 1 到 65535 之间的数字。${NC}"
        read -p "按任意键继续..."
        return
    fi

    # 检查端口是否被占用
    if command -v ss >/dev/null 2>&1; then
        if ss -tuln | grep -q ":$new_port "; then
            echo -e "${RED}错误: 端口 $new_port 已被占用，请选择其他端口。${NC}"
            read -p "按任意键继续..."
            return
        fi
    elif command -v netstat >/dev/null 2>&1; then
        if netstat -tuln | grep -q ":$new_port "; then
            echo -e "${RED}错误: 端口 $new_port 已被占用，请选择其他端口。${NC}"
            read -p "按任意键继续..."
            return
        fi
    fi

    echo -e "${YELLOW}正在修改SSH配置文件...${NC}"
    sed -i "s/^#*Port .*/Port $new_port/g" /etc/ssh/sshd_config

    # 放行防火墙端口
    echo -e "${YELLOW}正在配置防火墙放行新端口 $new_port...${NC}"
    if command -v ufw >/dev/null 2>&1 && ufw status | grep -q "Status: active"; then
        ufw allow $new_port/tcp
    elif command -v firewall-cmd >/dev/null 2>&1 && systemctl is-active --quiet firewalld; then
        firewall-cmd --permanent --add-port=$new_port/tcp
        firewall-cmd --reload
    elif command -v iptables >/dev/null 2>&1; then
        iptables -I INPUT -p tcp --dport $new_port -j ACCEPT
    fi

    echo -e "${YELLOW}正在重启SSH服务...${NC}"
    if command -v systemctl >/dev/null 2>&1; then
        systemctl restart sshd
    elif command -v service >/dev/null 2>&1; then
        service ssh restart
    else
        echo -e "${RED}无法识别系统服务管理工具，请手动重启SSH服务。${NC}"
    fi

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}SSH端口已成功修改为 $new_port。${NC}"
        echo -e "${YELLOW}请记住新的端口号，并确保防火墙已放行该端口，以免无法连接。${NC}"
    else
        echo -e "${RED}SSH端口修改失败。${NC}"
    fi
    read -p "按任意键继续..."
}

function switch_ip_priority() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          切换 IP 网络优先级${NC}"
        echo -e "${CYAN}=========================================${NC}"
        
        # --- 1. 获取当前状态 ---
        local gai_file="/etc/gai.conf"
        local status_v4_pri="${BLUE}未知${NC}"
        local status_v6_kernel="${GREEN}启用${NC}"

        if [ -f "$gai_file" ] && grep -qE "^precedence\s+::ffff:0:0/96\s+100" "$gai_file"; then
            status_v4_pri="${GREEN}IPv4 优先${NC}"
        else
            status_v4_pri="${BLUE}IPv6 优先 (系统默认)${NC}"
        fi

        if [ "$(sysctl -n net.ipv6.conf.all.disable_ipv6)" == "1" ]; then
            status_v6_kernel="${RED}已完全禁用${NC}"
        fi

        echo -e "当前解析策略: $status_v4_pri"
        echo -e "内核 IPv6 状态: $status_v6_kernel"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${GREEN}1.${NC} 设置 IPv4 优先 (推荐: 解决国内连接慢)"
        echo -e " ${GREEN}2.${NC} 恢复 IPv6 优先 (默认)"
        echo -e " ${GREEN}3.${NC} 完全禁用系统 IPv6 (慎用)"
        echo -e " ${GREEN}4.${NC} 重新启用系统 IPv6"
        echo -e " ${GREEN}5.${NC} 测试当前实际出口 IP"
        echo -e " ${RED}0.${NC} 返回上一级"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入选择: " choice

        case $choice in
            1)
                echo -e "${YELLOW}正在修改 $gai_file ...${NC}"
                [ ! -f "$gai_file" ] && touch "$gai_file"
                sed -i '/::ffff:0:0\/96/d' "$gai_file"
                echo "precedence ::ffff:0:0/96  100" >> "$gai_file"
                echo -e "${GREEN}✅ 已设置为 IPv4 优先。${NC}"
                sleep 2
                ;;
            2)
                echo -e "${YELLOW}正在恢复系统默认策略...${NC}"
                sed -i '/^precedence\s*::ffff:0:0\/96\s*100/d' "$gai_file"
                echo -e "${GREEN}✅ 已恢复 IPv6 优先。${NC}"
                sleep 2
                ;;
            3)
                echo -e "${RED}正在内核层面禁用 IPv6...${NC}"
                sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null
                sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null
                sysctl -w net.ipv6.conf.lo.disable_ipv6=1 >/dev/null
                echo -e "${GREEN}✅ IPv6 已彻底禁用。${NC}"
                sleep 2
                ;;
            4)
                echo -e "${YELLOW}正在重新启用 IPv6...${NC}"
                sysctl -w net.ipv6.conf.all.disable_ipv6=0 >/dev/null
                sysctl -w net.ipv6.conf.default.disable_ipv6=0 >/dev/null
                sysctl -w net.ipv6.conf.lo.disable_ipv6=0 >/dev/null
                echo -e "${GREEN}✅ IPv6 已启用。${NC}"
                sleep 2
                ;;
            5)
                echo -e "${BLUE}正在检测出口 IP (使用 ip.sb)...${NC}"
                local ip_detect=$(curl -sS --max-time 5 https://api.ip.sb/ip || echo "连接超时")
                echo -e "${YELLOW}当前公网出口 IP: ${GREEN}$ip_detect${NC}"
                read -p "按回车键继续..."
                ;;
            0) break ;;
            *) echo -e "${RED}无效选择！${NC}"; sleep 1 ;;
        esac
    done
}

function change_hostname() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          修改主机名${NC}"
    echo -e "${CYAN}=========================================${NC}"
    read -p "请输入新的主机名: " new_hostname

    if [[ -z "$new_hostname" ]]; then
        echo -e "${RED}主机名不能为空。${NC}"
        read -p "按任意键继续..."
        return
    fi

    echo -e "${YELLOW}正在修改主机名...${NC}"
    hostnamectl set-hostname $new_hostname

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}主机名已成功修改为 $new_hostname。${NC}"
        echo -e "${YELLOW}可能需要重启系统或重新连接SSH才能看到更改。${NC}"
    else
        echo -e "${RED}主机名修改失败。${NC}"
    fi
    read -p "按任意键继续..."
}

function configure_chinese_locale() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}          中文语言支持管理${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  安装/配置中文语言支持"
        echo -e " ${GREEN}2.${NC}  还原/恢复英文语言环境"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回上一级菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择: " locale_choice

        case "$locale_choice" in
            1)
                install_chinese_locale
                ;;
            2)
                restore_chinese_locale
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

function install_chinese_locale() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          安装中文语言支持${NC}"
    echo -e "${CYAN}=========================================${NC}"
    
    # 检查是否为 Debian/Ubuntu
    if [ ! -f /etc/debian_version ]; then
        echo -e "${RED}此功能仅支持 Debian/Ubuntu 系统。${NC}"
        read -p "按任意键继续..."
        return
    fi

    echo -e "${GREEN}[1/6] 更新软件源...${NC}"
    apt update -y

    echo -e "${GREEN}[2/6] 安装中文字体和语言包...${NC}"
    apt install -y fonts-noto-cjk fonts-wqy-microhei fonts-wqy-zenhei manpages-zh locales language-pack-zh-hans

    echo -e "${GREEN}[3/6] 修复翻译文件缺失...${NC}"
    # 强制重装核心包以恢复 .mo 翻译文件
    apt install --reinstall -y bash coreutils grep sed 2>/dev/null

    echo -e "${GREEN}[4/6] 生成中文 Locale...${NC}"
    [ -f /etc/locale.gen ] || touch /etc/locale.gen
    sed -i 's/^# *zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g' /etc/locale.gen
    sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
    locale-gen zh_CN.UTF-8
    locale-gen en_US.UTF-8

    echo -e "${GREEN}[5/6] 设置环境变量...${NC}"
    # 通过 update-locale 设置系统默认
    if command -v update-locale &>/dev/null; then
        update-locale LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8 LANGUAGE=zh_CN:zh
    fi

    # 写入当前用户的 .bashrc（防止云主机不读取系统配置）
    if ! grep -q "export LANG=zh_CN.UTF-8" ~/.bashrc; then
        echo "export LANG=zh_CN.UTF-8" >> ~/.bashrc
        echo "export LANGUAGE=zh_CN:zh" >> ~/.bashrc
        echo "export LC_ALL=zh_CN.UTF-8" >> ~/.bashrc
    fi

    # 添加中文 man 别名
    if ! grep -q "alias cman=" ~/.bashrc; then
        echo "alias cman='man -L zh_CN'" >> ~/.bashrc
    fi

    echo -e "${GREEN}[6/6] 调整 SSH 配置...${NC}"
    # 禁止客户端覆盖语言设置
    if [ -f /etc/ssh/sshd_config ]; then
        sed -i 's/^AcceptEnv LANG LC_*/#AcceptEnv LANG LC_*/g' /etc/ssh/sshd_config
        systemctl restart sshd 2>/dev/null || service ssh restart 2>/dev/null
    fi

    echo -e "${GREEN}=== 中文环境配置完成！ ===${NC}"
    echo -e "请执行 ${YELLOW}source ~/.bashrc${NC} 使配置立即生效。"
    echo -e "或断开 SSH 重新连接。测试命令：${YELLOW}date${NC} 应显示中文日期。"
    read -p "按任意键继续..."
}

function restore_chinese_locale() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          还原语言支持 (恢复英文)${NC}"
    echo -e "${CYAN}=========================================${NC}"

    # 1. 还原环境变量
    echo -e "${BLUE}[1/4] 正在从 ~/.bashrc 中移除中文环境变量...${NC}"
    sed -i '/export LANG=zh_CN.UTF-8/d' ~/.bashrc
    sed -i '/export LANGUAGE=zh_CN:zh/d' ~/.bashrc
    sed -i '/export LC_ALL=zh_CN.UTF-8/d' ~/.bashrc
    sed -i "/alias cman='man -L zh_CN'/d" ~/.bashrc
    
    # 2. 还原系统 Locale
    echo -e "${BLUE}[2/4] 正在重置系统 Locale 为 en_US.UTF-8...${NC}"
    if command -v update-locale &>/dev/null; then
        update-locale LANG=en_US.UTF-8 LC_ALL= LANGUAGE=
    fi
    locale-gen en_US.UTF-8

    # 3. 还原 SSH 配置
    echo -e "${BLUE}[3/4] 正在恢复 SSH AcceptEnv 配置...${NC}"
    if [ -f /etc/ssh/sshd_config ]; then
        sed -i 's/^#AcceptEnv LANG LC_*/AcceptEnv LANG LC_*/g' /etc/ssh/sshd_config
        systemctl restart sshd 2>/dev/null || service ssh restart 2>/dev/null
    fi

    echo -e "${BLUE}[4/4] 刷新当前会话环境变量...${NC}"
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    unset LANGUAGE

    echo -e "${GREEN}=== 语言环境还原完成！ ===${NC}"
    echo -e "系统已切换回英文环境 (en_US.UTF-8)。"
    echo -e "请执行 ${YELLOW}source ~/.bashrc${NC} 或重新连接 SSH 以完全生效。"
    read -p "按任意键继续..."
}
