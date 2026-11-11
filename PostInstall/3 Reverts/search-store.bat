@echo off
echo Run the bat as an admin
echo Starting in 5 seconds

timeout /t 5 /nobreak >nul

echo Windows Search Service: setting to Automatic
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WSearch" /v "Start" /t REG_DWORD /d 2 /f
echo Starting WSearch...
net start WSearch 2>nul

echo AppX Deployment Service: setting to Manual
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AppXSvc" /v "Start" /t REG_DWORD /d 3 /f
echo Starting AppXSvc...
net start AppXSvc 2>nul

echo Client License Service: setting to Manual
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ClipSVC" /v "Start" /t REG_DWORD /d 3 /f
echo Starting ClipSVC...
net start ClipSVC 2>nul

echo Windows Install Service: setting to Manual
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\InstallService" /v "Start" /t REG_DWORD /d 3 /f
echo Starting InstallService...
net start InstallService 2>nul

echo Token Broker: setting to Manual
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TokenBroker" /v "Start" /t REG_DWORD /d 3 /f
echo Starting TokenBroker...
net start TokenBroker 2>nul

echo Wallet Service: setting to Manual
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WalletService" /v "Start" /t REG_DWORD /d 3 /f
echo Starting WalletService...
net start WalletService 2>nul

echo Windows Store Service: setting to Manual
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WSService" /v "Start" /t REG_DWORD /d 3 /f
echo Starting WSService...
net start WSService 2>nul

echo Allowing Store to run...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v "DisableStoreApps" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AllowStoreToRunInBackground" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore" /v "EnableAutoStoreUpdates" /t REG_DWORD /d 1 /f

echo Installing Microsoft Store from local MSIX...
if exist "%~dp0Microsoft Store Installer\MS_Store.msix" (
    powershell -Command "Add-AppxPackage -Path '%~dp0Microsoft Store Installer\MS_Store.msix' -ErrorAction SilentlyContinue"
    echo Microsoft Store installed.
) else (
    echo WARNING: MS_Store.msix not found in 'Microsoft Store Installer' folder.
    echo Please download the Microsoft Store package manually.
)

echo Done. Restart Explorer or reboot for full effect.
pause
