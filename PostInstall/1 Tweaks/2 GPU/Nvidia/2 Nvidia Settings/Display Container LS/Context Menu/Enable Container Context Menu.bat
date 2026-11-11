@echo off
reg add "HKCR\Directory\Background\shellex\ContextMenuHandlers\NvCplDesktopContext" /ve /d "{3D1975AF-48C6-4f8e-A182-BE0E08FA86A9}" /f >nul 2>&1
reg add "HKCR\Directory\shellex\ContextMenuHandlers\NvCplDesktopContext" /ve /d "{3D1975AF-48C6-4f8e-A182-BE0E08FA86A9}" /f >nul 2>&1
echo NVIDIA desktop context menu enabled. Restart Explorer.
pause
