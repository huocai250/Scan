# Scan - 懒人式黑客工具箱

![GitHub](https://img.shields.io/github/license/huocai250/Scan) 
![Shell](https://img.shields.io/badge/language-Shell-green)

一个界面友好、功能集成的 Shell 黑客工具箱，专为渗透测试爱好者设计。

## 功能列表

- **Nmap 高级扫描**：端口、服务、OS 指纹、漏洞脚本
- **MSF 木马生成**：一键生成 Android / Windows 木马
- **Meterpreter 监听**：快速启动反弹 Shell 监听
- **局域网断网攻击**：ARP 欺骗（内网测试）
- **信息收集**：Whois 查询 + DNS 枚举
- **密码破解**：MD5 在线破解 + Hydra 字典爆破
- **完整日志记录**：所有操作自动记录

## 安装与使用

```bash
git clone https://github.com/huocai250/Scan.git
cd Scan
chmod +x Scan.sh
sudo ./Scan.sh
```

**推荐环境**：Kali Linux / Parrot OS

## 注意事项

- **仅限授权测试环境使用**，禁止用于非法用途
- 大部分功能需要 root 权限
- 使用前请确保已安装必要工具：`nmap metasploit-framework hydra`

⭐ 如果对你有帮助，请给个 Star 支持！

**作者**：huocai250