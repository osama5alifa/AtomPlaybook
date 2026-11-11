@echo off
title AtomOS - Undo CompactOS
echo.
echo This turns CompactOS off and returns the system files to normal.
echo.
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator rights...
    powershell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
compact.exe /CompactOS:never
echo.
echo Done. Reboot to finish.
pause
