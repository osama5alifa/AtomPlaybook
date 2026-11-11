$ErrorActionPreference = 'Stop'

# Resolve source from playbook root (one level up from Executables)
$playbookRoot = Split-Path $PSScriptRoot -Parent
$setup        = Join-Path $playbookRoot 'PostInstall\AtomToolBox-Setup-0.2.5.exe'

if (-not (Test-Path $setup)) {
    Write-Warning "AtomToolBox installer not found: $setup"
    exit 1
}

# 0. Remove the old broken layout: 0.1.5 was copied as if it were the app,
#    so the shortcut launched the installer instead of AtomToolBox.
$legacyDir = 'C:\Program Files\AtomToolBox'
if (Test-Path $legacyDir) {
    $legacyExe = Join-Path $legacyDir 'AtomToolBox.exe'
    if ((Test-Path $legacyExe) -and ((Get-Item $legacyExe).Length -gt 40MB)) {
        Write-Host "Removing legacy installer-as-app copy..."
        Remove-Item -LiteralPath $legacyDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 1. Silent install (electron-builder NSIS: /S)
Write-Host "Installing AtomToolBox 0.2.5..."
$proc = Start-Process -FilePath $setup -ArgumentList '/S' -PassThru -Wait
Write-Host ("Installer exit code: " + $proc.ExitCode)

# 2. Locate the real executable - per-user or per-machine, name may vary
$candidates = @(
    (Join-Path $env:LOCALAPPDATA 'Programs\AtomToolBox\AtomToolBox.exe'),
    (Join-Path $env:LOCALAPPDATA 'Programs\atom-toolbox\AtomToolBox.exe'),
    (Join-Path $env:LOCALAPPDATA 'Programs\Atom ToolBox\AtomToolBox.exe'),
    'C:\Program Files\AtomToolBox\AtomToolBox.exe',
    'C:\Program Files (x86)\AtomToolBox\AtomToolBox.exe'
)
$dstExe = $null
for ($i = 0; $i -lt 30 -and -not $dstExe; $i++) {
    foreach ($c in $candidates) {
        if ((Test-Path $c) -and ((Get-Item $c).Length -lt 40MB)) { $dstExe = $c; break }
    }
    if (-not $dstExe) {
        $hit = Get-ChildItem (Join-Path $env:LOCALAPPDATA 'Programs') -Recurse -Filter 'AtomToolBox.exe' -ErrorAction SilentlyContinue |
               Where-Object { $_.Length -lt 40MB } | Select-Object -First 1
        if ($hit) { $dstExe = $hit.FullName }
    }
    if (-not $dstExe) { Start-Sleep -Seconds 1 }
}

if (-not $dstExe) {
    Write-Warning "AtomToolBox installed but AtomToolBox.exe was not found. Shortcuts not created."
    exit 1
}

$installDir = Split-Path $dstExe -Parent
Write-Host ("Installed app: " + $dstExe)

# 3. Shortcuts that point at the app, not the installer
$wsh = New-Object -ComObject WScript.Shell

$desktopPath = [Environment]::GetFolderPath('Desktop')
$scDesktop = $wsh.CreateShortcut((Join-Path $desktopPath 'AtomToolBox.lnk'))
$scDesktop.TargetPath = $dstExe
$scDesktop.WorkingDirectory = $installDir
$scDesktop.IconLocation = $dstExe
$scDesktop.Save()

$startMenuPath = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs'
New-Item -ItemType Directory -Path $startMenuPath -Force | Out-Null
$scStart = $wsh.CreateShortcut((Join-Path $startMenuPath 'AtomToolBox.lnk'))
$scStart.TargetPath = $dstExe
$scStart.WorkingDirectory = $installDir
$scStart.IconLocation = $dstExe
$scStart.Save()

$taskbarPinPath = Join-Path $env:APPDATA 'Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar'
New-Item -ItemType Directory -Path $taskbarPinPath -Force | Out-Null
$scTaskbar = $wsh.CreateShortcut((Join-Path $taskbarPinPath 'AtomToolBox.lnk'))
$scTaskbar.TargetPath = $dstExe
$scTaskbar.WorkingDirectory = $installDir
$scTaskbar.IconLocation = $dstExe
$scTaskbar.Save()

# 4. Record what was installed so support can see it
$key = 'HKLM:\SOFTWARE\Project Atom'
New-Item -Path $key -Force | Out-Null
Set-ItemProperty -Path $key -Name 'AtomToolBoxExe' -Value $dstExe -Type String -Force
Set-ItemProperty -Path $key -Name 'AtomToolBoxVersion' -Value '0.2.5' -Type String -Force

Write-Host "AtomToolBox 0.2.5 installed and shortcuts created."
