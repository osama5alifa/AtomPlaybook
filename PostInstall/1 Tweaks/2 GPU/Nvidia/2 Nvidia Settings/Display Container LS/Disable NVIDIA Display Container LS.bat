@echo off
sc stop NVDisplay.ContainerLocalSystem >nul 2>&1
sc config NVDisplay.ContainerLocalSystem start= disabled >nul 2>&1
echo NVIDIA Display Container disabled. Reboot to apply.
pause
