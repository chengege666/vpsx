#!/bin/bash

# =========================================================
#  VPSX 一键安装引导脚本
#  功能：自动安装 Git、克隆仓库并启动主程序
# =========================================================

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 定义安装路径
INSTALL_PATH="/root/vpsx"
REPO_URL="https://github.com/chengege666/vpsx.git"

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}       VPSX 正在准备环境...${NC}"
echo -e "${BLUE}=========================================${NC}"

# 1. 检查并安装 Git
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}未检测到 Git，正在尝试安装...${NC}"
    if [ -f /etc/debian_version ]; then
        apt-get update && apt-get install -y git
    elif [ -f /etc/redhat-release ]; then
        yum install -y git
    else
        echo -e "${RED}无法自动安装 Git，请手动安装后重试。${NC}"
        exit 1
    fi
fi

# 2. 克隆或更新仓库
if [ -d "$INSTALL_PATH" ]; then
    echo -e "${YELLOW}检测到已安装 VPSX，正在尝试更新...${NC}"
    cd "$INSTALL_PATH" && git pull
else
    echo -e "${GREEN}正在克隆 VPSX 仓库到 $INSTALL_PATH...${NC}"
    git clone "$REPO_URL" "$INSTALL_PATH"
fi

# 3. 检查克隆是否成功
if [ ! -f "$INSTALL_PATH/vpsx.sh" ]; then
    echo -e "${RED}错误：无法获取项目文件，请检查网络连接。${NC}"
    exit 1
fi

# 4. 设置执行权限并启动
echo -e "${GREEN}环境准备就绪，正在启动 VPSX...${NC}"
chmod +x "$INSTALL_PATH/vpsx.sh"
cd "$INSTALL_PATH" && ./vpsx.sh
