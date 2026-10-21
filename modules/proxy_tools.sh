#!/bin/bash

# 搭建节点工具模块

# 搭建节点工具菜单
function node_tools_menu() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}            工具菜单${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  安装 3x-ui 面板 (启动x-ui)"
        echo -e " ${GREEN}2.${NC}  cgg-Argo 隧道管理"
        echo -e " ${GREEN}3.${NC}  s-ui（s-ui）"
        echo -e " ${GREEN}4.${NC}  PVE 工具箱"
        echo -e " ${GREEN}5.${NC}  PVE 镜像转换与部署"
        echo -e " ${GREEN}6.${NC}  Cloudflare Argo Tunnel (一键安装/卸载)"
        echo -e " ${GREEN}7.${NC}  cgg-vless"
        echo -e " ${GREEN}8.${NC}  NAT-Subconverter-Nginx (一键部署)"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回主菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-8): " node_choice

        case "$node_choice" in
            1)
                echo -e "${BLUE}正在启动 3x-ui 安装脚本...${NC}"
                bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
                read -p "按任意键继续..."
                ;;
            2)
                echo -e "${BLUE}正在启动 cgg-Argo 隧道管理脚本...${NC}"
                bash <(curl -L -s 'https://raw.githubusercontent.com/chengege666/cggargo/main/argo.sh')
                read -p "按任意键继续..."
                ;;
            3)
                echo -e "${BLUE}正在启动 s-ui 脚本...${NC}"
                bash <(curl -Ls https://raw.githubusercontent.com/alireza0/s-ui/master/install.sh)
                read -p "按任意键继续..."
                ;;
            4)
                echo -e "${BLUE}正在启动 PVE 工具箱脚本...${NC}"
                bash <(curl -fsSL lj.1231818.xyz/pve)
                read -p "按任意键继续..."
                ;;
            5)
                echo -e "${BLUE}正在启动 PVE 镜像转换与部署脚本...${NC}"
                bash <(curl -sL https://lj.1231818.xyz/pvezh)
                read -p "按任意键继续..."
                ;;
            6)
                argo_menu
                ;;
            7)
                echo -e "${BLUE}正在启动 cgg-vless 脚本...${NC}"
                bash <(curl -fsSL https://lj.1231818.xyz/vless)
                read -p "按任意键继续..."
                ;;
            8)
                echo -e "${BLUE}正在启动 NAT-Subconverter-Nginx 部署脚本...${NC}"
                wget -qO sub_mgr.sh https://raw.githubusercontent.com/chengege666/net-sub/main/sub_mgr.sh && bash sub_mgr.sh
                read -p "按任意键继续..."
                ;;
            0)
                break
                ;;
            *)
                echo -e "${RED}无效的选择，请重新输入！${NC}"
                read -p "按任意键继续..."
                ;;
        esac
    done
}

# ==========================================
# Cloudflare Argo Tunnel 管理 (参考 cggargo)
# ==========================================

ARGO_BIN="/usr/local/bin/cloudflared"
ARGO_CRED_DIR="/etc/cloudflared"
ARGO_CONFIG_FILE="${ARGO_CRED_DIR}/config.yml"
ARGO_TOKEN_FILE="${ARGO_CRED_DIR}/token"
ARGO_CRED_FILE="${ARGO_CRED_DIR}/credentials.json"
ARGO_SYSTEMD_UNIT="/etc/systemd/system/cloudflared.service"
ARGO_OPENRC_UNIT="/etc/init.d/cloudflared"

# 检测包管理器
function _argo_pkg_mgr() {
    if command -v apk >/dev/null 2>&1; then
        echo "apk"
    elif command -v apt-get >/dev/null 2>&1; then
        echo "apt"
    elif command -v dnf >/dev/null 2>&1; then
        echo "dnf"
    elif command -v yum >/dev/null 2>&1; then
        echo "yum"
    else
        echo ""
    fi
}

# 确保存在下载工具 curl/wget
function _argo_install_deps() {
    if command -v curl >/dev/null 2>&1 || command -v wget >/dev/null 2>&1; then
        return 0
    fi
    local mgr
    mgr=$(_argo_pkg_mgr)
    if [ -z "$mgr" ]; then
        echo -e "${RED}[错误]${NC} 缺少 curl/wget 且未识别包管理器，请手动安装。"
        return 1
    fi
    echo -e "${BLUE}[安装中]${NC} 正在安装下载工具 curl..."
    case "$mgr" in
        apk) apk add --no-cache curl >/dev/null 2>&1 ;;
        apt) apt-get update -y >/dev/null 2>&1 && apt-get install -y curl >/dev/null 2>&1 ;;
        dnf) dnf install -y curl >/dev/null 2>&1 ;;
        yum) yum install -y curl >/dev/null 2>&1 ;;
    esac
    if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
        echo -e "${RED}[失败]${NC} curl 安装失败，请检查网络或手动安装。"
        return 1
    fi
    return 0
}

# 下载 cloudflared 二进制 (GitHub 官方 releases)
function _argo_download_binary() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}[错误]${NC} 下载安装 cloudflared 需要 root 权限。"
        return 1
    fi
    if command -v cloudflared >/dev/null 2>&1; then
        ARGO_BIN="$(command -v cloudflared)"
        echo -e "${GREEN}[已安装]${NC} cloudflared 已存在：${ARGO_BIN}"
        return 0
    fi
    local arch file_name
    arch=$(uname -m)
    case "$arch" in
        x86_64|amd64)  file_name="cloudflared-linux-amd64" ;;
        aarch64|arm64) file_name="cloudflared-linux-arm64" ;;
        *)
            echo -e "${RED}[错误]${NC} 不支持的架构: ${arch}"
            return 1
            ;;
    esac
    echo -e "${BLUE}[安装中]${NC} 正在下载 cloudflared (${arch})..."
    mkdir -p "$(dirname "$ARGO_BIN")"
    if command -v curl >/dev/null 2>&1; then
        curl -L --fail --connect-timeout 20 -o "$ARGO_BIN" "https://github.com/cloudflare/cloudflared/releases/latest/download/${file_name}"
    else
        wget -q -O "$ARGO_BIN" "https://github.com/cloudflare/cloudflared/releases/latest/download/${file_name}"
    fi
    if [ ! -f "$ARGO_BIN" ]; then
        echo -e "${RED}[失败]${NC} cloudflared 下载失败，请检查网络（GitHub 可能不可达）。"
        return 1
    fi
    chmod +x "$ARGO_BIN"
    if ! "$ARGO_BIN" --version >/dev/null 2>&1; then
        echo -e "${RED}[失败]${NC} cloudflared 校验失败，文件可能不完整，已清理。"
        rm -f "$ARGO_BIN"
        return 1
    fi
    echo -e "${GREEN}[成功]${NC} cloudflared 安装完成：$("$ARGO_BIN" --version 2>/dev/null | head -n1)"
    return 0
}

# 交互输入域名映射
function _argo_input_mappings() {
    ARGO_MAPPINGS=""
    local num i domain port stream_type ws_path stream proto
    while true; do
        read -p "需要配置多少个域名映射 (例如 2): " num
        if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -gt 0 ] && [ "$num" -le 20 ]; then
            break
        fi
        echo -e "${RED}请输入 1-20 之间的数字。${NC}"
    done
    for i in $(seq 1 "$num"); do
        echo -e "${CYAN}--- 配置第 ${i} 个域名 ---${NC}"
        while true; do
            read -p "请输入绑定的域名 (Public Hostname): " domain
            [ -n "$domain" ] && break
            echo -e "${RED}域名不能为空。${NC}"
        done
        while true; do
            read -p "请输入本地监听端口 (默认 443): " port
            port=${port:-443}
            if [[ "$port" =~ ^[0-9]+$ ]] && [ "$port" -ge 1 ] && [ "$port" -le 65535 ]; then
                break
            fi
            echo -e "${RED}请输入 1-65535 的有效端口。${NC}"
        done
        echo "请选择传输方式："
        echo "1) WebSocket (默认)"
        echo "2) gRPC"
        echo "3) TCP"
        read -p "选择 (1/2/3，默认 1): " stream_type
        stream_type=${stream_type:-1}
        case "$stream_type" in
            2)
                stream="grpc"
                ws_path="vmess-grpc"
                ;;
            3)
                stream="tcp"
                ws_path="-"
                ;;
            *)
                stream="ws"
                read -p "请输入 WebSocket 路径 (默认 /): " ws_path
                ws_path=${ws_path:-/}
                [[ "$ws_path" != /* ]] && ws_path="/${ws_path}"
                ;;
        esac
        read -p "请输入回源协议 http/https/tcp (默认 http): " proto
        proto=${proto:-http}
        case "$proto" in http|https|tcp) ;; *) proto="http" ;; esac
        ARGO_MAPPINGS="${ARGO_MAPPINGS}${domain}|${port}|${ws_path}|${proto}|${stream}"$'\n'
    done
}

# 生成 config.yml
function _argo_write_config() {
    mkdir -p "$ARGO_CRED_DIR"
    chmod 700 "$ARGO_CRED_DIR"
    {
        echo "# Cloudflare Tunnel Auto Generated by vpsx"
        echo
        echo "ingress:"
        printf '%s\n' "$ARGO_MAPPINGS" | while IFS='|' read -r domain port ws_path proto stream; do
            [ -z "$domain" ] && continue
            case "$proto" in
                tcp)   service="tcp://localhost:${port}" ;;
                https) service="https://localhost:${port}" ;;
                *)     service="http://localhost:${port}" ;;
            esac
            echo "  - hostname: ${domain}"
            echo "    service: ${service}"
            echo "    originRequest:"
            echo "      noTLSVerify: true"
            echo "      httpHostHeader: ${domain}"
            if [ "$stream" = "ws" ] && [ "$proto" != "tcp" ]; then
                echo "      headers:"
                echo "        Connection: Upgrade"
                echo "        Upgrade: websocket"
            fi
            echo
        done
        echo "  - service: http_status:404"
    } > "$ARGO_CONFIG_FILE"
    chmod 600 "$ARGO_CONFIG_FILE"
    echo -e "${GREEN}[成功]${NC} 配置文件已写入：${ARGO_CONFIG_FILE}"
}

# 输入凭证并构建服务启动参数
function _argo_input_credentials() {
    ARGO_RUN_ARGS=""
    ARGO_MODE=""
    echo "请选择凭证方式："
    echo "1) Cloudflare Tunnel Token (推荐)"
    echo "2) credentials JSON (直接粘贴内容)"
    local mode token content
    read -p "选择 (1/2，默认 1): " mode
    mode=${mode:-1}
    if [ "$mode" = "1" ]; then
        while true; do
            read -p "请输入 Tunnel Token (以 eyJ 开头): " token
            [ -n "$token" ] && break
            echo -e "${RED}Token 不能为空。${NC}"
        done
        printf "%s" "$token" > "$ARGO_TOKEN_FILE"
        chmod 600 "$ARGO_TOKEN_FILE"
        # 新版 cloudflared 支持 --token-file，旧版需内联 token
        if "$ARGO_BIN" tunnel run --help 2>&1 | grep -q -- '--token-file'; then
            ARGO_RUN_ARGS="tunnel run --token-file ${ARGO_TOKEN_FILE}"
        else
            ARGO_RUN_ARGS="tunnel run --token $(tr -d '\r\n' < "$ARGO_TOKEN_FILE")"
        fi
        ARGO_MODE="token"
    else
        echo "请粘贴 credentials JSON 内容 (输入完按回车两次结束)："
        content=""
        while IFS= read -r line; do
            [ -z "$line" ] && break
            content="${content}${line}"$'\n'
        done
        printf "%s" "$content" > "$ARGO_CRED_FILE"
        chmod 600 "$ARGO_CRED_FILE"
        if [ ! -s "$ARGO_CRED_FILE" ]; then
            echo -e "${RED}[错误]${NC} 凭证内容为空。"
            return 1
        fi
        if command -v jq >/dev/null 2>&1 && ! jq -e . "$ARGO_CRED_FILE" >/dev/null 2>&1; then
            echo -e "${RED}[错误]${NC} JSON 格式校验失败，请检查粘贴内容。"
            return 1
        fi
        ARGO_RUN_ARGS="tunnel run --credentials-file ${ARGO_CRED_FILE}"
        ARGO_MODE="json"
    fi
    return 0
}

# 创建并启动服务 (systemd/OpenRC 双兼容)
function _argo_setup_service() {
    if command -v systemctl >/dev/null 2>&1; then
        cat > "$ARGO_SYSTEMD_UNIT" <<EOF
[Unit]
Description=Cloudflare Tunnel Service (vpsx)
After=network-online.target

[Service]
Type=simple
ExecStart=${ARGO_BIN} ${ARGO_RUN_ARGS}
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF
        systemctl daemon-reload
        systemctl enable --now cloudflared >/dev/null 2>&1
        sleep 2
        if systemctl is-active --quiet cloudflared; then
            echo -e "${GREEN}[成功]${NC} cloudflared 服务已启动 (systemd)。"
            return 0
        fi
    elif command -v rc-service >/dev/null 2>&1; then
        cat > "$ARGO_OPENRC_UNIT" <<EOF
#!/sbin/openrc-run

name="cloudflared"
description="Cloudflare Tunnel Service (vpsx)"
command="${ARGO_BIN}"
command_args="${ARGO_RUN_ARGS}"
command_background="yes"
pidfile="/run/cloudflared.pid"
output_log="/var/log/cloudflared.log"
error_log="/var/log/cloudflared.log"

depend() {
    need net
    after net
}
EOF
        chmod +x "$ARGO_OPENRC_UNIT"
        rc-update add cloudflared default >/dev/null 2>&1
        rc-service cloudflared restart >/dev/null 2>&1
        sleep 2
        if rc-service cloudflared status >/dev/null 2>&1; then
            echo -e "${GREEN}[成功]${NC} cloudflared 服务已启动 (OpenRC)。"
            return 0
        fi
    else
        echo -e "${RED}[错误]${NC} 未检测到 systemd 或 OpenRC，无法注册服务。"
        return 1
    fi
    echo -e "${RED}[失败]${NC} 服务启动失败，常见原因："
    echo -e "  ${YELLOW}1.${NC} Token 或 JSON 凭证无效 (登录 Cloudflare Zero Trust 检查)"
    echo -e "  ${YELLOW}2.${NC} config.yml 格式错误"
    echo -e "  ${YELLOW}3.${NC} 网络被防火墙/代理阻断，cloudflared 无法连接 Cloudflare"
    if command -v systemctl >/dev/null 2>&1; then
        echo -e "排查: ${YELLOW}journalctl -u cloudflared -n 50 --no-pager${NC}"
        echo -e "修复后执行: ${YELLOW}systemctl restart cloudflared${NC}"
    else
        echo -e "排查: ${YELLOW}cat /var/log/cloudflared.log${NC}"
        echo -e "修复后执行: ${YELLOW}rc-service cloudflared restart${NC}"
    fi
    return 1
}

# 一键安装 Cloudflare Argo Tunnel
function argo_install() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}     Cloudflare Argo Tunnel 一键安装${NC}"
    echo -e "${CYAN}=========================================${NC}"
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}[错误]${NC} 请以 root 权限运行。"
        read -p "按任意键继续..."
        return
    fi
    if [ -f "$ARGO_CONFIG_FILE" ] || [ -f "$ARGO_SYSTEMD_UNIT" ] || [ -f "$ARGO_OPENRC_UNIT" ]; then
        echo -e "${YELLOW}检测到已有 Argo Tunnel 配置/服务，继续将覆盖。${NC}"
        read -p "是否继续？(y/N): " confirm
        if [[ ! "$confirm" =~ ^[yY]$ ]]; then
            echo -e "${YELLOW}已取消。${NC}"
            read -p "按任意键继续..."
            return
        fi
    fi
    if ! _argo_install_deps; then
        read -p "按任意键继续..."
        return
    fi
    if ! _argo_download_binary; then
        read -p "按任意键继续..."
        return
    fi
    _argo_input_mappings
    _argo_write_config
    if ! _argo_input_credentials; then
        read -p "按任意键继续..."
        return
    fi
    if ! _argo_setup_service; then
        read -p "按任意键继续..."
        return
    fi
    echo
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}               安装完成${NC}"
    echo -e "${GREEN}=========================================${NC}"
    echo -e "配置文件: ${ARGO_CONFIG_FILE}"
    [ "$ARGO_MODE" = "token" ] && echo -e "Token 文件: ${ARGO_TOKEN_FILE}"
    [ "$ARGO_MODE" = "json" ] && echo -e "凭证文件: ${ARGO_CRED_FILE}"
    echo
    echo -e "${YELLOW}域名映射列表:${NC}"
    printf '%s\n' "$ARGO_MAPPINGS" | while IFS='|' read -r domain port ws_path proto stream; do
        [ -z "$domain" ] && continue
        echo -e "  - ${domain} -> localhost:${port} (${proto}/${stream})"
    done
    echo
    echo -e "${YELLOW}后续步骤提醒:${NC}"
    echo -e "  1. Token 模式: 到 Zero Trust 面板为隧道添加 Public Hostname 指向对应本地端口"
    echo -e "  2. JSON 模式: 使用本地 config.yml 的 ingress 规则"
    echo -e "  3. 客户端节点地址填优选IP/域名，端口 443，Host/SNI 填绑定域名"
    echo -e "  4. 回源协议为 https 时需在面板勾选 No TLS Verify"
    echo
    echo -e "查看日志: journalctl -u cloudflared -f (Alpine: cat /var/log/cloudflared.log)"
    echo -e "重启服务: systemctl restart cloudflared (Alpine: rc-service cloudflared restart)"
    read -p "按任意键继续..."
}

# 卸载 Cloudflare Argo Tunnel
function argo_uninstall() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}[错误]${NC} 卸载需要 root 权限。"
        read -p "按任意键继续..."
        return
    fi
    if [ ! -f "$ARGO_SYSTEMD_UNIT" ] && [ ! -f "$ARGO_OPENRC_UNIT" ] && ! command -v cloudflared >/dev/null 2>&1; then
        echo -e "${YELLOW}未检测到 Argo Tunnel 安装。${NC}"
        read -p "按任意键继续..."
        return
    fi
    read -p "确定卸载？将删除服务/配置/凭证/二进制 (y/N): " confirm
    if [[ ! "$confirm" =~ ^[yY]$ ]]; then
        echo -e "${YELLOW}已取消。${NC}"
        read -p "按任意键继续..."
        return
    fi
    if command -v systemctl >/dev/null 2>&1 && [ -f "$ARGO_SYSTEMD_UNIT" ]; then
        systemctl disable --now cloudflared >/dev/null 2>&1
        rm -f "$ARGO_SYSTEMD_UNIT"
        systemctl daemon-reload >/dev/null 2>&1
    fi
    if command -v rc-service >/dev/null 2>&1 && [ -f "$ARGO_OPENRC_UNIT" ]; then
        rc-service cloudflared stop >/dev/null 2>&1
        rc-update del cloudflared default >/dev/null 2>&1
        rm -f "$ARGO_OPENRC_UNIT"
    fi
    rm -rf "$ARGO_CRED_DIR"
    rm -f "$ARGO_BIN"
    echo -e "${GREEN}Argo Tunnel 已卸载。${NC}"
    read -p "按任意键继续..."
}

# 临时隧道 (Quick Tunnel，免 Token)
function argo_quick_tunnel() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}    Cloudflare 临时隧道 (Quick Tunnel)${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${YELLOW}无需 Token/域名，启动后自动生成 trycloudflare.com 随机地址。${NC}"
    echo -e "${YELLOW}每次启动地址都会变化，客户端需同步修改地址和 SNI。${NC}"
    echo
    if ! _argo_install_deps; then
        read -p "按任意键继续..."
        return
    fi
    if ! command -v cloudflared >/dev/null 2>&1 && [ ! -x "$ARGO_BIN" ]; then
        if ! _argo_download_binary; then
            read -p "按任意键继续..."
            return
        fi
    fi
    local bin port
    bin="$(command -v cloudflared 2>/dev/null || echo "$ARGO_BIN")"
    while true; do
        read -p "请输入节点本地端口 (默认 443): " port
        port=${port:-443}
        if [[ "$port" =~ ^[0-9]+$ ]] && [ "$port" -ge 1 ] && [ "$port" -le 65535 ]; then
            break
        fi
        echo -e "${RED}请输入 1-65535 的有效端口。${NC}"
    done
    echo
    echo -e "${BLUE}启动中，Ctrl+C 停止并返回菜单，生成的地址见下方：${NC}"
    "$bin" tunnel --url "http://localhost:${port}"
    echo
    read -p "按任意键继续..."
}

# 查看 Argo Tunnel 运行状态与配置
function argo_status() {
    clear
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${GREEN}          Argo Tunnel 运行状态${NC}"
    echo -e "${CYAN}=========================================${NC}"
    local version=""
    if [ -x "$ARGO_BIN" ]; then
        version=$("$ARGO_BIN" --version 2>/dev/null | head -n1)
    elif command -v cloudflared >/dev/null 2>&1; then
        version=$(cloudflared --version 2>/dev/null | head -n1)
    fi
    if [ -n "$version" ]; then
        echo -e " ● 二进制: ${GREEN}已安装${NC} (${version})"
    else
        echo -e " ● 二进制: ${RED}未安装${NC}"
    fi
    if command -v systemctl >/dev/null 2>&1 && systemctl cat cloudflared >/dev/null 2>&1; then
        if systemctl is-active --quiet cloudflared; then
            echo -e " ● 服务: ${GREEN}运行中${NC} (systemd)"
        else
            echo -e " ● 服务: ${RED}未运行${NC} (systemd)"
        fi
        echo -e " ● 日志: journalctl -u cloudflared -f"
    elif command -v rc-service >/dev/null 2>&1 && [ -f "$ARGO_OPENRC_UNIT" ]; then
        if rc-service cloudflared status >/dev/null 2>&1; then
            echo -e " ● 服务: ${GREEN}运行中${NC} (OpenRC)"
        else
            echo -e " ● 服务: ${RED}未运行${NC} (OpenRC)"
        fi
        echo -e " ● 日志: cat /var/log/cloudflared.log"
    else
        echo -e " ● 服务: ${YELLOW}未注册${NC}"
    fi
    echo -e "${CYAN}-----------------------------------------${NC}"
    if [ -f "$ARGO_CONFIG_FILE" ]; then
        echo -e "${YELLOW}当前 config.yml:${NC}"
        cat "$ARGO_CONFIG_FILE"
    else
        echo -e "${YELLOW}未找到配置文件 ${ARGO_CONFIG_FILE}${NC}"
    fi
    echo -e "${CYAN}=========================================${NC}"
    read -p "按任意键继续..."
}

# Cloudflare Argo Tunnel 管理菜单
function argo_menu() {
    while true; do
        clear
        echo -e "${CYAN}=========================================${NC}"
        echo -e "${GREEN}   Cloudflare Argo Tunnel 管理 ${NC}"
        echo -e "${CYAN}=========================================${NC}"
        echo -e " ${GREEN}1.${NC}  一键安装 Argo Tunnel (Token/JSON 凭证)"
        echo -e " ${GREEN}2.${NC}  卸载 Argo Tunnel (删除服务与配置)"
        echo -e " ${GREEN}3.${NC}  临时隧道 (Quick Tunnel 免Token)"
        echo -e " ${GREEN}4.${NC}  查看运行状态与配置"
        echo -e "${CYAN}-----------------------------------------${NC}"
        echo -e " ${RED}0.${NC}  返回工具菜单"
        echo -e "${CYAN}=========================================${NC}"
        read -p "请输入你的选择 (0-4): " argo_choice

        case "$argo_choice" in
            1)
                argo_install
                ;;
            2)
                argo_uninstall
                ;;
            3)
                argo_quick_tunnel
                ;;
            4)
                argo_status
                ;;
            0)
                break
                ;;
            *)
                echo -e "${RED}无效的选择，请重新输入！${NC}"
                read -p "按任意键继续..."
                ;;
        esac
    done
}
