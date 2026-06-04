#!/bin/bash

# VPS SSH Key 配置脚本
# 为 GitHub 私有仓库配置 SSH 认证

GITHUB_EMAIL="${1:-"git@github.com"}"
REMOTE_URL="git@github.com:chengege666/vpsx.git"
SSH_KEY_PATH="$HOME/.ssh/id_ed25519"

echo "========================================="
echo "  GitHub SSH Key 配置脚本"
echo "========================================="
echo ""

# 1. 检查 SSH Key 是否已存在
if [ -f "$SSH_KEY_PATH" ]; then
    echo "[✓] SSH Key 已存在: $SSH_KEY_PATH"
else
    echo "[*] 正在生成 SSH Key ..."
    mkdir -p "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$SSH_KEY_PATH" -N ""
    if [ $? -ne 0 ]; then
        echo "[✗] SSH Key 生成失败"
        exit 1
    fi
    echo "[✓] SSH Key 生成成功"
fi

echo ""
echo "========================================="
echo "  请将以下公钥添加到 GitHub："
echo "========================================="
echo ""
cat "${SSH_KEY_PATH}.pub"
echo ""
echo "========================================="
echo "  操作步骤："
echo "  1. 打开 https://github.com/settings/ssh/new"
echo "  2. Title 随意填写（如：VPS）"
echo "  3. Key 粘贴上面输出的内容"
echo "  4. 点击 Add SSH Key"
echo "========================================="
echo ""

# 2. 等待用户确认已添加
read -p "确认已添加 SSH Key 到 GitHub 后，按 Enter 继续测试连接 ..."

# 3. 测试 SSH 连接
echo ""
echo "[*] 正在测试 SSH 连接 ..."
ssh -T git@github.com -o StrictHostKeyChecking=accept-new 2>&1
SSH_RESULT=$?

if [ $SSH_RESULT -eq 1 ]; then
    # ssh -T 返回 1 表示认证成功但无 shell 访问（正常情况）
    echo "[✓] SSH 连接测试通过"
elif [ $SSH_RESULT -eq 0 ]; then
    echo "[✓] SSH 连接测试通过"
else
    echo "[✗] SSH 连接失败，请检查公钥是否正确添加"
    echo "    返回码: $SSH_RESULT"
    exit 1
fi

# 4. 更新远程地址为 SSH 格式
echo ""
echo "[*] 正在更新 Git 远程地址 ..."
cd "$(dirname "$0")"
CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "[✗] 不是 Git 仓库，跳过远程地址更新"
else
    if [ "$CURRENT_REMOTE" != "$REMOTE_URL" ]; then
        git remote set-url origin "$REMOTE_URL"
        echo "[✓] 远程地址已更新为: $REMOTE_URL"
    else
        echo "[✓] 远程地址已经是 SSH 格式，无需修改"
    fi
fi

echo ""
echo "========================================="
echo "  配置完成！"
echo "  你现在可以正常使用："
echo "  git pull"
echo "  git push"
echo "========================================="
