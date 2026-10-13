param([switch]$VerifyOnly)
$ErrorActionPreference = 'Stop'
if ($VerifyOnly) { Write-Output 'Launcher verification mode OK'; exit 0 }
try {
 $root = $PSScriptRoot
 $pathFile = Join-Path $root 'browser-path.txt'
 if (-not (Test-Path -LiteralPath $pathFile)) { throw '请先运行 Install.cmd。' }
 $browser = (Get-Content -LiteralPath $pathFile -Raw).Trim()
 if (-not (Test-Path -LiteralPath $browser)) { throw '找不到浏览器，请重新运行 Install.cmd。' }
 $cfg = Get-Content (Join-Path $root 'config.json') -Raw | ConvertFrom-Json
 if (-not (Test-Path -LiteralPath $cfg.vpnPath)) { throw '找不到 VPN，请检查 config.json 中的 vpnPath。' }
 Start-Process -FilePath $cfg.vpnPath
 Write-Host '请在 Windscribe 登录，手动选择美国节点，并确认已连接。'
 Write-Host '脚本不会检查 VPN 状态；独立浏览器也不会锁定美国出口。'
 $answer = Read-Host '确认 VPN 已连接后输入 YES（其他输入取消）'
 if ($answer -cne 'YES') { exit 0 }
 $data = Join-Path $root 'Data'
 New-Item -ItemType Directory -Force $data | Out-Null
 $url = [string]$cfg.startUrl
 if ($url -ne 'about:blank' -and $url -notmatch '^https://[^\s"<>]+$') { throw 'startUrl 只允许 https:// 地址或 about:blank。' }
 Start-Process -FilePath $browser -ArgumentList @("--user-data-dir=`"$data`"",'--no-first-run',"`"$url`"")
} catch { Write-Host ('失败：' + $_.Exception.Message) -ForegroundColor Red; exit 1 }
