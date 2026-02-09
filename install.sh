#!/bin/bash
# VPSX 一键安装脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}🚀 VPSX 安装程序启动...${NC}"
echo ""

# 检查是否已安装
if [ -d "/root/vpsx" ] && [ -f "/root/vpsx/vpsx.sh" ]; then
    echo -e "${YELLOW}检测到已安装，直接启动...${NC}"
    cd /root/vpsx
    exec bash vpsx.sh
fi

# 安装依赖
echo -e "${BLUE}安装必要依赖...${NC}"
apt update && apt install -y curl git wget

# 克隆仓库
echo -e "${BLUE}下载 VPSX 文件...${NC}"
cd /root
if [ -d "vpsx" ]; then
    rm -rf vpsx
fi
git clone https://github.com/chengege666/vpsx.git
cd vpsx

# 设置权限
chmod +x vpsx.sh
chmod +x modules/*.sh 2>/dev/null || true

# 创建快捷方式
echo -e "${YELLOW}创建快捷命令...${NC}"
if ! grep -q "alias vpsx=" ~/.bashrc; then
    echo 'alias vpsx="cd /root/vpsx && bash vpsx.sh"' >> ~/.bashrc
fi

# 立即生效
source ~/.bashrc 2>/dev/null || true

echo -e "${GREEN}✅ 安装完成！${NC}"
echo ""
echo -e "使用方法:"
echo -e "  1. ${YELLOW}vpsx${NC} - 启动管理面板"
echo -e "  2. ${YELLOW}cd /root/vpsx && ./vpsx.sh${NC} - 直接运行"
echo ""
echo -e "即将启动 VPSX..."

# 等待 2 秒后启动
sleep 2
exec bash /root/vpsx/vpsx.sh