@echo off
title AtomOS - Revert 0.5 ms Timer Resolution
echo.
echo This removes the AtomOS timer daemon and returns Windows to its
echo default timer resolution (15.625 ms dynamic tick).
echo.
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator rights...
    powershell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
echo Stopping scheduled task...
schtasks /End /TN "\Atom\Atom-TimerResolution" >nul 2>&1
schtasks /Delete /TN "\Atom\Atom-TimerResolution" /F >nul 2>&1
echo Removing fallback Run entry...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v AtomTimerResolution /f >nul 2>&1
echo Stopping running instance...
taskkill /IM SetTimerResolution.exe /F >nul 2>&1
echo Restoring boot timer defaults...
bcdedit /deletevalue disabledynamictick >nul 2>&1
bcdedit /deletevalue useplatformtick >nul 2>&1
echo.
echo Done. A restart clears the remaining timer state.
pause
