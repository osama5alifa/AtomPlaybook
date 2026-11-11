@echo off
reg delete "HKCR\Directory\Background\shellex\ContextMenuHandlers\NvCplDesktopContext" /f >nul 2>&1
reg delete "HKCR\Directory\shellex\ContextMenuHandlers\NvCplDesktopContext" /f >nul 2>&1
echo NVIDIA desktop context menu disabled. Restart Explorer.
pause
