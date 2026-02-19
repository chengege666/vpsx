function system_cleanup() {
    # 定义颜色（若外部未定义则使用默认值）
    : ${CYAN:="\e[36m"}
    : ${NC:="\e[0m"}
    : ${YELLOW:="\e[33m"}
    : ${BLUE:="\e[34m"}
    : ${GREEN:="\e[32m"}
    : ${RED:="\e[31m"}

    clear
    echo -e "${CYAN}"
    echo "=========================================="
    echo "              系统清理功能        "
    echo "=========================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}⚠️ 警告：系统清理操作将删除不必要的文件，请谨慎操作！${NC}"
    echo ""
    read -p "是否继续执行系统清理？(y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then 
        echo -e "${YELLOW}已取消系统清理操作${NC}"
        return
    fi

    # 新增：询问是否扫描大文件
    echo ""
    read -p "是否扫描系统中的大文件（>100MB）以便选择删除？(y/n): " scan_large
    if [[ "$scan_large" == "y" || "$scan_large" == "Y" ]]; then
        _scan_large_files
    fi

    # 原有清理逻辑保持不变...
    # （从“if [ -f /etc/debian_version ]; then”开始的所有代码）
    # 注意：原代码中的 BACKUP_DIR 相关行已移除，请确保后续没有引用 BACKUP_DIR
    # 如果希望保留备份机制，可自行调整
    if [ -f /etc/debian_version ]; then
        echo -e "${BLUE}检测到 Debian/Ubuntu 系统${NC}"
        echo -e "${YELLOW}开始深度清理系统...${NC}"
        echo ""
        
        # 1. 清理包管理器缓存
        echo -e "${BLUE}[步骤1/8] 清理APT缓存和旧包...${NC}"
        # 修复 'Malformed entry' 错误，删除可能损坏的 docker.list 文件
        if [ -f /etc/apt/sources.list.d/docker.list ]; then
            mv /etc/apt/sources.list.d/docker.list /etc/apt/sources.list.d/docker.list.bak
            echo -e "${YELLOW}已备份并移除可能损坏的 docker.list${NC}"
        fi
        apt clean
        apt autoclean
        apt autoremove -y
        
        # 安装并使用 deborphan 清理孤立软件包
        if ! command -v deborphan >/dev/null 2>&1; then
            echo -e "${YELLOW}安装 deborphan 以清理孤立软件包...${NC}"
            apt update && apt install -y deborphan
        fi
        if command -v deborphan >/dev/null 2>&1; then
            echo -e "${YELLOW}清理孤立软件包...${NC}"
            deborphan | xargs apt -y purge 2>/dev/null
        fi
        
        # 2. 清理旧内核 (增强安全性：确保不删除当前内核及其配套文件)
        echo -e "${BLUE}[步骤2/8] 清理旧内核...${NC}"
        local current_kernel=$(uname -r)
        # 查找所有已安装的内核包，但不包括当前运行的内核版本
        local kernel_pkgs=$(dpkg-query -W -f='${Package}\n' 'linux-image-[0-9]*' 'linux-headers-[0-9]*' | grep -v "$current_kernel")
        
        if [ -n "$kernel_pkgs" ]; then
            echo -e "${YELLOW}发现旧内核包，准备清理...${NC}"
            echo "$kernel_pkgs" | xargs apt-get -y purge
        else
            echo -e "${GREEN}未发现需要清理的旧内核。${NC}"
        fi
        
        # 3. 清理日志文件 (更彻底)
        echo -e "${BLUE}[步骤3/8] 清理日志文件...${NC}"
        journalctl --vacuum-time=7d 2>/dev/null  # 保留7天日志
        find /var/log -name "*.log" -type f -mtime +30 -delete 2>/dev/null
        find /var/log -name "*.gz" -type f -mtime +7 -delete 2>/dev/null
        find /var/log -name "*.old" -type f -mtime +7 -delete 2>/dev/null
        find /var/log -name "*.[0-9]" -type f -mtime +7 -delete 2>/dev/null
        truncate -s 0 /var/log/*.log 2>/dev/null
        
        # 4. 清理临时文件 (扩大范围)
        echo -e "${BLUE}[步骤4/8] 清理临时文件...${NC}"
        rm -rf /tmp/*
        rm -rf /var/tmp/*
        rm -rf /var/cache/apt/archives/*
        rm -rf /var/cache/debconf/*
        
        # 5. 清理缩略图缓存
        echo -e "${BLUE}[步骤5/8] 清理缩略图缓存...${NC}"
        find /home -type d -name ".thumbnails" -exec rm -rf {} + 2>/dev/null
        find /root -type d -name ".thumbnails" -exec rm -rf {} + 2>/dev/null
        
        # 6. 清理浏览器缓存 (如果存在)
        echo -e "${BLUE}[步骤6/8] 清理浏览器缓存...${NC}"
        # 清理常见浏览器缓存路径
        for user_home in /home/* /root; do
            [ -d "$user_home/.cache/google-chrome" ] && rm -rf "$user_home/.cache/google-chrome/*" 2>/dev/null
            [ -d "$user_home/.cache/mozilla" ] && rm -rf "$user_home/.cache/mozilla/*" 2>/dev/null
        done
        
        # 7. 清理崩溃报告
        echo -e "${BLUE}[步骤7/8] 清理崩溃报告...${NC}"
        rm -rf /var/crash/*
        find /var/lib/apport/crash -type f -delete 2>/dev/null
        
        # 8. 清理软件包列表缓存
        echo -e "${BLUE}[步骤8/8] 清理软件包列表缓存...${NC}"
        rm -rf /var/lib/apt/lists/*
        apt update  # 重新生成干净的列表
        
    elif [ -f /etc/redhat-release ]; then
        echo -e "${BLUE}检测到 CentOS/RHEL 系统${NC}"
        echo -e "${YELLOW}开始深度清理系统...${NC}"
        echo ""
        
        # 1. 清理YUM/DNF缓存
        echo -e "${BLUE}[步骤1/8] 清理YUM/DNF缓存...${NC}"
        if command -v dnf >/dev/null 2>&1; then
            dnf clean all
            dnf autoremove -y
        else
            yum clean all
            package-cleanup --oldkernels --count=1 -y 2>/dev/null
            package-cleanup --leaves -y 2>/dev/null
        fi
        
        # 2. 清理旧内核
        echo -e "${BLUE}[步骤2/8] 清理旧内核...${NC}"
        if command -v dnf >/dev/null 2>&1; then
            dnf remove -y $(dnf repoquery --installonly --latest-limit=-1 -q) 2>/dev/null
        else
            package-cleanup --oldkernels --count=1 -y 2>/dev/null
        fi
        
        # 3. 清理日志文件
        echo -e "${BLUE}[步骤3/8] 清理日志文件...${NC}"
        journalctl --vacuum-time=7d 2>/dev/null
        find /var/log -name "*.log" -type f -mtime +30 -delete 2>/dev/null
        find /var/log -name "*.gz" -type f -mtime +7 -delete 2>/dev/null
        find /var/log -name "*.[0-9]" -type f -mtime +7 -delete 2>/dev/null
        truncate -s 0 /var/log/*.log 2>/dev/null
        
        # 4. 清理临时文件
        echo -e "${BLUE}[步骤4/8] 清理临时文件...${NC}"
        rm -rf /tmp/*
        rm -rf /var/tmp/*
        rm -rf /var/cache/yum/*
        rm -rf /var/cache/dnf/*
        
        # 5. 清理缩略图缓存
        echo -e "${BLUE}[步骤5/8] 清理缩略图缓存...${NC}"
        find /home -type d -name ".thumbnails" -exec rm -rf {} + 2>/dev/null
        find /root -type d -name ".thumbnails" -exec rm -rf {} + 2>/dev/null
        
        # 6. 清理浏览器缓存
        echo -e "${BLUE}[步骤6/8] 清理浏览器缓存...${NC}"
        for user_home in /home/* /root; do
            [ -d "$user_home/.cache/google-chrome" ] && rm -rf "$user_home/.cache/google-chrome/*" 2>/dev/null
            [ -d "$user_home/.cache/mozilla" ] && rm -rf "$user_home/.cache/mozilla/*" 2>/dev/null
        done
        
        # 7. 清理崩溃报告
        echo -e "${BLUE}[步骤7/8] 清理崩溃报告...${NC}"
        rm -rf /var/crash/*
        find /var/spool/abrt -type f -delete 2>/dev/null
        
        # 8. 清理系统缓存
        echo -e "${BLUE}[步骤8/8] 清理系统缓存...${NC}"
        sync
        echo 3 > /proc/sys/vm/drop_caches 2>/dev/null
        
    else
        echo -e "${RED}不支持的系统类型！${NC}"
        echo -e "${YELLOW}仅支持 Debian/Ubuntu 和 CentOS/RHEL 系统。${NC}"
        return
    fi
    
    # 通用清理步骤 (所有系统)
    echo -e "${BLUE}[通用步骤] 执行通用清理...${NC}"
    
    # 清理垃圾文件
    find /tmp -name "*.tmp" -type f -delete 2>/dev/null
    find /tmp -name "*.swp" -type f -delete 2>/dev/null
    find /home -name "*.bak" -type f -mtime +30 -delete 2>/dev/null
    
    # 清理空目录
    find /tmp -type d -empty -delete 2>/dev/null
    find /var/tmp -type d -empty -delete 2>/dev/null
    
    # 显示清理结果
    echo ""
    echo -e "${GREEN}✅ 系统深度清理完成！${NC}"
    echo -e "${YELLOW}释放的磁盘空间：${NC}"
    df -h / | tail -1 | awk '{print "根分区可用空间: " $4}'
    
    echo -e "${CYAN}"
    echo "=========================================="
    echo -e "${NC}"
}

# 新增内部函数：扫描大文件并交互式删除
_scan_large_files() {
    echo -e "${BLUE}扫描大于100MB的文件（仅限 /home, /var, /tmp, /var/tmp）...${NC}"
    local search_paths=("/home" "/var" "/tmp" "/var/tmp")
    local threshold="100M"
    local file_list=()
    
    # 收集大文件
    for path in "${search_paths[@]}"; do
        if [ -d "$path" ]; then
            while IFS= read -r -d '' file; do
                file_list+=("$file")
            done < <(find "$path" -type f -size +"$threshold" -print0 2>/dev/null)
        fi
    done

    if [ ${#file_list[@]} -eq 0 ]; then
        echo -e "${GREEN}未找到大于100MB的文件。${NC}"
        return
    fi

    echo -e "${YELLOW}找到 ${#file_list[@]} 个大文件：${NC}"
    local count=0
    for file in "${file_list[@]}"; do
        ((count++))
        echo "----------------------------------------"
        echo "文件 #$count: $file"
        
        # 文件大小
        local size=$(du -h "$file" 2>/dev/null | cut -f1)
        echo "大小: $size"
        
        # 修改时间
        local mtime=$(date -r "$file" "+%Y-%m-%d %H:%M:%S" 2>/dev/null)
        echo "修改时间: $mtime"
        
        # 文件类型
        local ftype=$(file -b "$file" 2>/dev/null)
        echo "类型: $ftype"
        
        # 尝试查询所属软件包（仅支持 Debian/Ubuntu 和 RHEL/CentOS）
        if [ -f /etc/debian_version ]; then
            local pkg=$(dpkg -S "$file" 2>/dev/null | head -1)
            [ -n "$pkg" ] && echo "属于软件包: $pkg"
        elif [ -f /etc/redhat-release ]; then
            local pkg=$(rpm -qf "$file" 2>/dev/null)
            [ -n "$pkg" ] && echo "属于软件包: $pkg"
        fi
        
        read -p "是否删除此文件？(y/n): " ans
        if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
            rm -f "$file" && echo -e "${GREEN}已删除${NC}" || echo -e "${RED}删除失败${NC}"
        fi
    done
}
