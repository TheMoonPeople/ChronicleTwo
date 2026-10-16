@echo off
git -C "%~dp0." submodule update --init tools/kazarov || exit /b 1
call "%~dp0tools\kazarov\scripts\kazarov.cmd" "%~dp0." build %*
