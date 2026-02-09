#!/bin/bash
# VPSX 一键安装脚本
# 使用方法: bash <(curl -sL https://raw.githubusercontent.com/chengege666/vpsx/main/install.sh)

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 安装目录
INSTALL_DIR="$HOME/.vpsx"
REPO_URL="https://github.com/chengege666/vpsx.git"
REPO_DIR="/tmp/vpsx-clone-$$"

echo -e "${GREEN}🚀 开始安装 VPSX...${NC}"

# 清理旧的临时目录
cleanup() {
    rm -rf "$REPO_DIR"
}
trap cleanup EXIT

# 克隆仓库到临时目录
echo -e "${BLUE}📦 下载 VPSX 文件...${NC}"
git clone --depth=1 "$REPO_URL" "$REPO_DIR"

# 创建安装目录
mkdir -p "$INSTALL_DIR"

# 复制所有文件
cp -r "$REPO_DIR"/* "$INSTALL_DIR"/

# 设置权限
chmod +x "$INSTALL_DIR/vpsx.sh"
chmod +x "$INSTALL_DIR/modules/"*.sh 2>/dev/null || true

# 创建启动器脚本
cat > "$INSTALL_DIR/launch.sh" << 'EOF'
#!/bin/bash
INSTALL_DIR="$HOME/.vpsx"
MAIN_SCRIPT="$INSTALL_DIR/vpsx.sh"

if [ ! -f "$MAIN_SCRIPT" ]; then
    echo -e "\033[31m错误: VPSX 未正确安装\033[0m"
    exit 1
fi

cd "$INSTALL_DIR"
exec bash "$MAIN_SCRIPT"
EOF

chmod +x "$INSTALL_DIR/launch.sh"

# 创建快捷命令
echo -e "${YELLOW}🔧 设置快捷命令...${NC}"

# 添加到 bashrc
if ! grep -q "alias vpsx=" ~/.bashrc; then
    echo "alias vpsx='~/.vpsx/launch.sh'" >> ~/.bashrc
fi

# 添加到 zshrc
if [ -f ~/.zshrc ] && ! grep -q "alias vpsx=" ~/.zshrc; then
    echo "alias vpsx='~/.vpsx/launch.sh'" >> ~/.zshrc
fi

# 立即生效
if [ -n "$BASH_VERSION" ]; then
    source ~/.bashrc 2>/dev/null || true
fi

echo -e "${GREEN}✅ VPSX 安装完成！${NC}"
echo ""
echo -e "使用方法:"
echo -e "  ${YELLOW}vpsx${NC}          # 启动 VPSX 管理面板"
echo -e "  ${YELLOW}~/.vpsx/vpsx.sh${NC}  # 或者直接运行"
echo ""
echo -e "安装目录: ${YELLOW}~/.vpsx/${NC}"
echo -e "卸载方法: 删除 ${YELLOW}~/.vpsx/${NC} 目录"

# 询问是否立即启动
read -p "是否立即启动 VPSX? (Y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    exec ~/.vpsx/launch.sh
fi