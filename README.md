# Muse 使用助手：Windows 独立浏览器与 Windscribe 安装包

面向中国大陆 Windows 用户的中文安装和启动助手。下载一个 ZIP，解压后双击 Install.cmd；之后使用桌面 Muse-US 快捷方式。

**这是联网安装器，不是离线浏览器/VPN 软件合集，也不是 Muse 官方产品。** Muse-US 只是快捷方式名称。它创建独立浏览器数据目录，不改变账号地区、不保证美国出口、Muse 可用性或地区资格。默认打开 https://muse.ai/join；邀请码与配图见 [Muse 注册与邀请码使用指南](MUSE-GUIDE.md)。

## 下载

[下载 Muse Windows Kit ZIP](https://github.com/huamaoshe/muse-windows-kit/releases/latest)

在发布页的 Assets 区域下载 Muse-Windows-Kit-v1.0.0.zip，不要选择 Source code。

## 使用步骤

1. 将 ZIP 全部解压到固定、可写的目录，例如 D:\MuseKit。不要直接在 ZIP 内运行，也不要放进 Program Files。
2. 双击 Install.cmd。浏览器从 Google Chrome for Testing 官方稳定版接口下载；Windscribe 从其官方 GitHub 发布下载。首次需要联网，下载体积较大。VPN 安装过程需要自行点击官方向导，可能弹出管理员权限确认和许可条款。
3. 安装成功后生成桌面 Muse-US 快捷方式。先在 Windscribe 登录自己的账号，按服务可用情况选择美国节点，等待显示已连接。
4. 回到启动窗口，输入大写 YES。脚本随后使用包内 Data 目录启动独立浏览器。VPN 状态由用户确认，脚本不检测出口 IP，不强制 VPN 连接，也不自动登录。
5. 输入 Muse 官方地址。如希望自动打开，可在 config.json 的 startUrl 填写 https:// 开头的官方地址。不要填写密码、令牌或非官方网站。

支持 Intel/AMD x64 Windows 10/11，不支持 Windows ARM 或 32 位系统。Chrome for Testing 面向测试且不会自动更新；关闭独立浏览器后重新运行 Install.cmd 可获取当时的稳定版。此助手只用于建立独立访问环境，日常浏览请使用自动更新的正式浏览器。

## 中国大陆下载与连接问题

GitHub、Google 存储与 Windscribe 的访问速度和可达性取决于网络；本包不能解决首次官方下载被阻断的问题，也不保证 VPN 在大陆可连接。下载失败会停止，不会继续执行未验证文件。稍后换一个可访问官方站点的网络，再运行 Install.cmd；不建议使用陌生镜像或关闭系统安全保护。

浏览器验证 Google 数字签名；Windscribe 2.24.13 验证 GitHub 公布的 SHA256 与数字签名。签名验证需要系统证书和网络状态正常。ZIP 自身附带的校验值只用于检查传输完整性，不能代替发布者身份验证。

自定义 VPN 安装路径：在 config.json 的 vpnPath 修改路径（JSON 中反斜杠写成两个），然后运行 Start.cmd。安装取消时脚本会报错，可重新运行；已在默认路径安装的 Windscribe 会被复用。重新安装会重置 startUrl 为 Muse 加入页。

## 文件与数据

- Install.cmd / Install.ps1：下载、验证、安装、创建快捷方式。
- Start.cmd / Start.ps1：先打开 VPN，等待 YES，再启动独立浏览器。
- config.json：VPN 路径与首页，不含账号凭据。
- Data：独立浏览器的 Cookie、历史记录与账号登录数据。请勿上传或分享使用后的整个目录。
- Browser / Downloads / browser-path.txt：安装时生成。移动目录后重新运行 Install.cmd 以重建快捷方式与路径。

Windscribe 是系统级 VPN，会影响其他应用网络。VPN 设置请在官方应用中完成：登录、选择节点、连接；不附带账号、订阅、预置密钥或承诺可用的节点。若 VPN 中断，请关闭浏览器并检查官方应用的连接和防火墙设置。

移除助手：删除桌面快捷方式与解压目录（先备份 Data）。Windscribe 需单独在 Windows“已安装的应用”中卸载。

## 官方来源与再分发说明

本项目只分发自行编写的启动脚本和文档，不捆绑 Chrome for Testing、Chromium 或 Windscribe 二进制，也不修改品牌和程序。未将 Chrome for Testing 仓库代码的 Apache 许可误当成浏览器二进制的再分发授权。Chromium 便携二进制再分发需要保留对应第三方许可等材料，本次未完成该离线发行审核，因此采用用户端直接下载官方软件的方式。使用第三方软件须遵循各自许可和条款。

- Chromium 下载说明：https://www.chromium.org/getting-involved/download-chromium/
- Chrome for Testing 官方说明：https://developer.chrome.com/docs/automation-and-testing/download-test-binaries
- 稳定版接口：https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json
- Windscribe 官方下载：https://windscribe.com/download
- Windscribe 官方发布：https://github.com/Windscribe/Desktop-App/releases/tag/v2.24.13
- 固定 Windows x64 下载：https://github.com/Windscribe/Desktop-App/releases/download/v2.24.13/Windscribe_2.24.13_amd64.exe
- Windscribe SHA256：821ff217d87b4acbd71408303d9a5bc35abfefdada6761f7fd2944a92d5609d2

核验日期：2026-10-14。已验证脚本语法、验证模式、ZIP 结构和官方元数据；未在本机安装 VPN，也未完成真实 Muse 登录测试。



