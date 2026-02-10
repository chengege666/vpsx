# vpsx - 全能 VPS 管理面板 自用 自用 自用

`vpsx` 是一个为 Linux 服务器设计的交互式全能管理脚本，旨在简化 VPS 的日常运维、系统优化及应用部署。通过模块化的设计，用户可以轻松完成从系统监控到复杂容器化应用的部署与管理。

## 🌟 主要功能

- **📊 系统信息查询**: 实时查看 CPU、内存、磁盘、网络及系统版本等核心数据。
- **⚙️ 系统优化与更新**: 一键更新系统软件包，清理冗余文件，管理 BBR 加速。
- **🛠️ 基础工具箱**: 快速安装常用运维工具（如 wget, curl, git, vim, screen 等）。
- **🐳 Docker 专家管理**: 
  - 一键安装/更新 Docker 及 Docker Compose 环境。
  - 容器运行状态实时监控。
- **🚀 应用中心 (App Center)**:
  - **Komari**: 强大的监控面板管理。
  - **PanSou**: 网盘搜索引擎管理。
  - **Watchtower**: 容器自动更新利器，支持多种通知配置。
  - **AdGuard Home**: 专业的 DNS 拦截与隐私保护工具。
  - **Nginx Proxy Manager (NPM)**: 图形化反向代理管理工具。
- **🧪 VPS 性能测试**: 集成多种主流测试脚本，一键跑分、测速。
- **⌨️ 快捷操作**: 支持配置快捷键 `k` 快速启动脚本。

## 🚀 快速开始

### 方式一：一键脚本安装 (推荐)
直接运行以下命令，自动完成依赖安装、项目部署及快捷键配置：

```bash
wget -P /root -N https://raw.githubusercontent.com/chengege666/vpsx/main/install.sh && bash /root/install.sh
```

### 方式二：手动克隆安装
如果您已安装 `git`，也可以手动克隆仓库：

```bash
git clone https://github.com/chengege666/vpsx.git /root/vpsx && chmod +x /root/vpsx/vpsx.sh && /root/vpsx/vpsx.sh
```

### 方式三：使用 curl 直接运行 (不保存文件)
适合临时使用，不下载完整项目：

```bash
curl -sSL https://raw.githubusercontent.com/chengege666/vpsx/main/install.sh | bash
```

## ⌨️ 常用命令

安装完成后，您可以使用以下命令：

- **启动面板**: 直接输入 `vpsx` (推荐) 或 `k` (如果已配置)
- **更新脚本**: 在面板中选择 `000` 或再次运行安装脚本
- **卸载脚本**: 在面板中选择 `00`


## 🛠️ 模块化架构

脚本采用了清晰的目录结构，方便开发者自行扩展：

- `vpsx.sh`: 脚本主入口。
- `modules/`: 核心功能模块文件夹。
  - `app_center.sh`: 各类应用部署与管理逻辑。
  - `docker.sh`: Docker 环境配置。
  - `self_manage.sh`: 脚本自身的更新与卸载逻辑。
- `utils/`: 通用工具类，包含颜色定义和常用函数。

## 🗑️ 卸载脚本

如果您不再需要此脚本，可以通过面板内的 `00` 选项安全卸载。该操作将删除脚本文件及快捷键配置，但不会影响您已安装的 Docker 容器及应用数据。

## 🤝 贡献与反馈

欢迎提交 Issue 或 Pull Request 来完善此项目。

---
**感谢您的使用！如果觉得好用，请给个 Star ⭐**

<img width="408" height="529" alt="image" src="https://github.com/user-attachments/assets/d9478ac6-1101-4c93-aa4b-b9e3254fbf3c" />
