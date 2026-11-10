@echo off
if not exist "%~dp0tools\kazarov\scripts\kazarov.cmd" git -C "%~dp0." submodule update --init tools/kazarov || exit /b 1
setlocal
where pwsh >nul 2>&1
if errorlevel 1 goto legacy
pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\windows\kazarov.ps1" run %*
exit /b %errorlevel%
:legacy
call "%~dp0tools\kazarov\scripts\kazarov.cmd" "%~dp0." run %*
exit /b %errorlevel%
