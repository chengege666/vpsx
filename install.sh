#!/bin/bash

# ====================================================
#  vpsx 一键安装脚本
#  支持系统: Ubuntu, Debian, CentOS, AlmaLinux, Rocky
# ====================================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 检查 root 权限
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}错误: 必须使用 root 权限运行此脚本！${NC}"
   exit 1
fi

# 项目路径
INSTALL_PATH="/root/vpsx"
REPO_URL="https://github.com/chengege666/vpsx.git"
MIRROR_URL="https://github.1231818.xyz/https://github.com/chengege666/vpsx.git"

echo -e "${CYAN}================================================${NC}"
echo -e "${GREEN}            vpsx 一键安装工具            ${NC}"
echo -e "${CYAN}================================================${NC}"

# 选择下载源
select_download_source() {
    echo -e "请选择下载源："
    echo -e "1) GitHub 原生 (可能需要魔法)"
    echo -e "2) GitHub 镜像 (推荐国内服务器)"
    read -p "请输入选项 [1-2] (默认2): " source_choice
    source_choice=${source_choice:-2}
    
    if [ "$source_choice" == "1" ]; then
        FINAL_REPO_URL="$REPO_URL"
    else
        FINAL_REPO_URL="$MIRROR_URL"
    fi
    echo -e "${BLUE}已选择下载源: ${FINAL_REPO_URL}${NC}"
}

# 检测包管理器并安装必要依赖
install_dependencies() {
    echo -e "${BLUE}[1/3] 正在检查并安装必要依赖...${NC}"
    
    if command -v apt >/dev/null 2>&1; then
        apt update && apt install -y git curl
    elif command -v yum >/dev/null 2>&1; then
        yum install -y git curl
    elif command -v dnf >/dev/null 2>&1; then
        dnf install -y git curl
    else
        echo -e "${RED}错误: 无法识别包管理器，请手动安装 git 和 curl。${NC}"
        exit 1
    fi
}

# 下载或更新项目
download_project() {
    echo -e "${BLUE}[2/3] 正在获取最新项目文件...${NC}"
    
    if [ -d "$INSTALL_PATH" ]; then
        echo -e "${YELLOW}检测到已安装，正在尝试更新...${NC}"
        cd "$INSTALL_PATH" && git pull
    else
        echo -e "${YELLOW}正在克隆项目仓库...${NC}"
        git clone "$FINAL_REPO_URL" "$INSTALL_PATH"
    fi

    if [ $? -ne 0 ]; then
        echo -e "${RED}错误: 项目获取失败，请检查网络连接或仓库地址。${NC}"
        exit 1
    fi
}

# 配置环境
setup_environment() {
    echo -e "${BLUE}[3/3] 正在配置运行环境...${NC}"
    
    # 赋予执行权限
    chmod +x "$INSTALL_PATH/vpsx.sh"
    # 递归查找并赋予所有 shell 脚本执行权限
    find "$INSTALL_PATH" -name "*.sh" -exec chmod +x {} +

    # 创建全局命令快捷方式
    ln -sf "$INSTALL_PATH/vpsx.sh" /usr/local/bin/vpsx
    
    echo -e "${GREEN}配置完成！${NC}"
}

# 执行安装流程
select_download_source
install_dependencies
download_project
setup_environment

echo -e "${CYAN}================================================${NC}"
echo -e "${GREEN}            vpsx 安装/更新成功！            ${NC}"
echo -e "${CYAN}================================================${NC}"
echo -e "您可以在任何地方输入 ${YELLOW}vpsx${NC} 来启动脚本。"
echo -e "正在为您启动主程序..."
sleep 2

# 启动脚本
bash "$INSTALL_PATH/vpsx.sh"
