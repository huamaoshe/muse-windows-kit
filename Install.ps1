param([switch]$VerifyOnly)
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$root = $PSScriptRoot
if ($VerifyOnly) { Write-Output 'Installer verification mode OK'; exit 0 }
try {
 if (-not [Environment]::Is64BitOperatingSystem -or $env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64') { throw '仅支持 Intel/AMD 64 位 Windows 10/11。' }
 $cache = Join-Path $root 'Downloads'
 New-Item -ItemType Directory -Force $cache,(Join-Path $root 'Data') | Out-Null
 function Download($url,$path) {
  $tmp = "$path.partial"
  for ($i=1; $i -le 3; $i++) {
   try { Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $tmp -TimeoutSec 600; Move-Item -LiteralPath $tmp -Destination $path -Force; return }
   catch { if ($i -eq 3) { throw }; Start-Sleep -Seconds 2 }
  }
 }
 Write-Host '正在读取 Google 官方稳定版浏览器信息……'
 $meta = Invoke-RestMethod 'https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json'
 $url = ($meta.channels.Stable.downloads.chrome | Where-Object platform -eq 'win64').url
 if ($url -notmatch '^https://storage\.googleapis\.com/chrome-for-testing-public/[0-9.]+/win64/chrome-win64\.zip$') { throw '浏览器官方下载地址异常。' }
 $version = $meta.channels.Stable.version
 $browserDir = Join-Path $root "Browser\$version"
 $browser = Join-Path $browserDir 'chrome-win64\chrome.exe'
 if (-not (Test-Path -LiteralPath $browser)) {
  $zip = Join-Path $cache "chrome-$version.zip"
  Write-Host '正在下载独立浏览器，可能需要几分钟……'
  Download $url $zip
  New-Item -ItemType Directory -Force $browserDir | Out-Null
  Expand-Archive -LiteralPath $zip -DestinationPath $browserDir -Force
 }
 if (-not (Test-Path -LiteralPath $browser)) { throw '浏览器解压失败。' }
 $sig = Get-AuthenticodeSignature -LiteralPath $browser
 if ($sig.Status -ne 'Valid' -or $sig.SignerCertificate.Subject -notmatch 'O=Google LLC') { throw '浏览器 Google 签名验证失败，已停止。' }
 $browser | Set-Content -LiteralPath (Join-Path $root 'browser-path.txt') -Encoding UTF8
 $vpnPaths = @((Join-Path $env:ProgramFiles 'Windscribe\Windscribe.exe'))
 if (${env:ProgramFiles(x86)}) { $vpnPaths += Join-Path ${env:ProgramFiles(x86)} 'Windscribe\Windscribe.exe' }
 $vpn = $vpnPaths | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
 if (-not $vpn) {
  Write-Host '正在下载官方 Windscribe 2.24.13……'
  $installer = Join-Path $cache 'Windscribe_2.24.13_amd64.exe'
  Download 'https://github.com/Windscribe/Desktop-App/releases/download/v2.24.13/Windscribe_2.24.13_amd64.exe' $installer
  $expected = '821ff217d87b4acbd71408303d9a5bc35abfefdada6761f7fd2944a92d5609d2'
  if ((Get-FileHash -LiteralPath $installer -Algorithm SHA256).Hash.ToLowerInvariant() -ne $expected) { throw 'Windscribe SHA256 不匹配，已停止。' }
  if ((Get-AuthenticodeSignature -LiteralPath $installer).Status -ne 'Valid') { throw 'Windscribe 数字签名验证失败，已停止。' }
  Write-Host '请在官方安装窗口完成安装；Windows 可能要求管理员权限。'
  $p = Start-Process -FilePath $installer -Wait -PassThru
  if ($p.ExitCode -notin @(0,3010)) { throw "Windscribe 安装未完成，退出码 $($p.ExitCode)" }
  $vpn = $vpnPaths | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
 }
 if (-not $vpn) { throw '未找到 Windscribe。若使用了自定义安装目录，请在 config.json 设置 vpnPath，然后运行 Start.cmd。' }
 @{vpnPath=$vpn; startUrl='https://muse.ai/join'} | ConvertTo-Json | Set-Content (Join-Path $root 'config.json') -Encoding UTF8
 $shell = New-Object -ComObject WScript.Shell
 $shortcut = $shell.CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'Muse-US.lnk'))
 $shortcut.TargetPath = Join-Path $root 'Start.cmd'
 $shortcut.WorkingDirectory = $root
 $shortcut.IconLocation = "$browser,0"
 $shortcut.Save()
 Write-Host '安装完成。桌面 Muse-US 快捷方式已创建。'
 & (Join-Path $root 'Start.ps1')
} catch {
 Write-Host ('失败：' + $_.Exception.Message) -ForegroundColor Red
 Write-Host '请查看 README.md 的下载故障说明。可重新运行 Install.cmd。'
 exit 1
}
