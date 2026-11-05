@echo off
rem DLoad - 停止 DSH Web 服务（结束监听 3080 端口的进程树）
powershell -NoProfile -Command "$c = Get-NetTCPConnection -LocalPort 3080 -State Listen -ErrorAction SilentlyContinue; if (-not $c) { Write-Host '[DLoad] DSH 未在运行（端口 3080 无监听）'; exit 0 }; $c | Select-Object -ExpandProperty OwningProcess -Unique | ForEach-Object { Write-Host ('[DLoad] 结束进程 PID=' + $_); taskkill /PID $_ /T /F | Out-Null }; Start-Sleep -Seconds 2; if (Get-NetTCPConnection -LocalPort 3080 -State Listen -ErrorAction SilentlyContinue) { Write-Host '[DLoad] 端口 3080 仍被占用，请手动检查该端口进程'; exit 1 } else { Write-Host '[DLoad] DSH 已停止' }"
pause
