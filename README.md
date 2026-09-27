# vpsx - 全能 VPS 管理面板 自用 自用 自用

`vpsx` 是一个为 Linux 服务器设计的交互式全能管理脚本，旨在简化 VPS 的日常运维、系统优化及应用部署。通过模块化的设计，用户可以轻松完成从系统监控到复杂容器化应用的部署与管理。



## 🚀 快速开始

### 方式一：一键脚本安装 (推荐)
直接运行以下命令，自动完成依赖安装、项目部署及快捷键配置：

```bash
wget -N https://raw.githubusercontent.com/chengege666/vpsx/main/install.sh && bash install.sh
```

### 方式二：手动克隆安装
如果您已安装 `git`，也可以手动克隆仓库：

```bash
git clone https://github.com/chengege666/vpsx.git /root/vpsx && chmod +x /root/vpsx/vpsx.sh && /root/vpsx/vpsx.sh
```
### 方式三：短链接
```bash
bash <(curl -sL lj.1231818.xyz/vpsx)
```
## ⌨️ 常用命令

安装完成后，您可以使用以下命令：

- **启动面板**: 直接输入 `vpsx` (推荐) 或 `k` (如果已配置)
- **更新脚本**: 在面板中选择 `000` 或再次运行安装脚本
- **卸载脚本**: 在面板中选择 `00`



## 🗑️ 卸载脚本

如果您不再需要此脚本，可以通过面板内的 `00` 选项安全卸载。该操作将删除脚本文件及快捷键配置，但不会影响您已安装的 Docker 容器及应用数据。



