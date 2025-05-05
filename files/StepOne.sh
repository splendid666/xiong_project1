#!/bin/bash

echo -e "\n\033[1;34m===== 此文件不应当有任何错误，例如找不到xxx命令 =====\033[0m\n"

echo -e "\n\033[1;34m===== 系统基本信息检测 =====\033[0m\n"

# 1. 系统信息
echo -e "\033[1;32m[系统信息]\033[0m"
echo "主机名: $(hostname)"
echo "操作系统: $(lsb_release -d | cut -f2-)"
echo "内核版本: $(uname -r)"
echo "系统架构: $(uname -m)"
echo "系统时间: $(date)"
echo "运行时间: $(uptime -p | sed 's/up //')"

# 2. CPU信息
echo -e "\n\033[1;32m[CPU信息]\033[0m"
echo "CPU型号: $(grep 'model name' /proc/cpuinfo | head -n1 | cut -d':' -f2 | sed 's/^[ \t]*//')"
echo "CPU核心数: $(grep -c 'processor' /proc/cpuinfo)"
echo "CPU使用率: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')"

# 3. 内存信息
echo -e "\n\033[1;32m[内存信息]\033[0m"
free -h | awk '/^Mem:/ {print "总内存: " $2 "\n已用内存: " $3 "\n可用内存: " $4 "\n内存使用率: " $3/$2*100 "%"}'

# 4. 磁盘信息
echo -e "\n\033[1;32m[磁盘信息]\033[0m"
df -h --output=source,size,used,avail,pcent | grep -v 'tmpfs' | awk 'NR==1 {print "设备\t总大小\t已用\t可用\t使用率"} NR>1 {print $0}'

# 5. 网络信息
echo -e "\n\033[1;32m[网络信息]\033[0m"
echo "IP地址: $(hostname -I | awk '{print $1}')"
echo "公网IP: $(curl -s ifconfig.me || echo "无法获取")"
echo "默认网关: $(ip route | grep default | awk '{print $3}')"

# 6. 登录用户
echo -e "\n\033[1;32m[用户信息]\033[0m"
echo "当前用户: $(whoami)"
echo "登录用户数: $(who | wc -l)"
echo "最近登录用户:"
last -n 3 | grep -v 'reboot' | awk '{print $1}' | uniq | head -n 3

# 7. 系统负载
echo -e "\n\033[1;32m[系统负载]\033[0m"
echo "1分钟负载: $(uptime | awk -F'load average: ' '{print $2}' | cut -d, -f1)"
echo "5分钟负载: $(uptime | awk -F'load average: ' '{print $2}' | cut -d, -f2)"
echo "15分钟负载: $(uptime | awk -F'load average: ' '{print $2}' | cut -d, -f3)"

echo -e "\n\033[1;34m===== 检测完成 =====\033[0m\n"
