@echo off
rem DLoad - 启动基于 DeepSeek Harness (DSH) 的开源 IDE 环境
rem 启动后自动打开浏览器访问 http://127.0.0.1:3080
cd /d "%~dp0"
set "PATH=%~dp0node_modules\.bin;%PATH%"

rem 检查 3080 端口是否已被占用（DSH 默认端口）
powershell -NoProfile -Command "if (Get-NetTCPConnection -LocalPort 3080 -State Listen -ErrorAction SilentlyContinue) { exit 1 } else { exit 0 }"
if errorlevel 1 (
    echo [DLoad] DSH 已在运行中，端口 3080 被占用，本次不再重复启动。
    echo [DLoad] 如需重启：请先运行 stop-dsh.cmd 停止旧实例，再运行本脚本。
    echo [DLoad] 正在运行实例的访问地址（带 token 的完整 URL）见它的启动窗口日志。
    pause
    exit /b 1
)

echo [DLoad] 正在启动 DeepSeek Harness Web IDE ...
echo [DLoad] 服务地址: http://127.0.0.1:3080（浏览器将自动打开）
echo [DLoad] 停止服务：本窗口按 Ctrl+C，或直接关闭本窗口；也可运行 stop-dsh.cmd
node_modules\.bin\dsh.cmd web
