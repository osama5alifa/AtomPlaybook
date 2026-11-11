@echo off
sc config NVDisplay.ContainerLocalSystem start= demand >nul 2>&1
sc start NVDisplay.ContainerLocalSystem >nul 2>&1
echo NVIDIA Display Container enabled.
pause
