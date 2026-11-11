<div align="center">

<img src="https://pub-9bfd8baebd2648a7918dc48ef27bafd0.r2.dev/Banner4.png" alt="AtomOS" width="100%" />

**Windows, rebuilt for latency.**

[![Version](https://img.shields.io/badge/version-0.0.9-2f81f7?style=for-the-badge)](../../releases)
[![Windows](https://img.shields.io/badge/Windows-10%20%7C%2011-0078D6?style=for-the-badge&logo=windows)](https://www.microsoft.com/windows)
[![AME Wizard](https://img.shields.io/badge/AME%20Wizard-compatible-F59E0B?style=for-the-badge)](https://ameliorated.io)
[![Builds](https://img.shields.io/badge/supported%20builds-20-22C55E?style=for-the-badge)](#supported-builds)
[![License](https://img.shields.io/badge/license-MIT-8B5CF6?style=for-the-badge)](LICENSE)

[Download](../../releases) · [Documentation](https://www.atom-os.com/docs) · [Website](https://www.atom-os.com/) · [Issues](../../issues)

</div>

---

AtomOS is an [AME Wizard](https://ameliorated.io) playbook for Windows 10 and 11. It removes the bloat Windows ships with, cuts the background services, and holds the system timer at 0.5 ms so frame times stay consistent.

## What it does

- Makes Windows lighter and faster.
- Removes apps and services most people never use.
- Turns off telemetry, ads and Copilot.
- Gives you three levels: Tiny, Lite and Standard.
- Works on Windows 10 and Windows 11.
- Changes can be undone.

## Profiles

| | **Tiny** | **Lite** (default) | **Standard** |
| --- | --- | --- | --- |
| **Intent** | Dedicated gaming box | Daily driver | Clean Windows |
| Telemetry and ads | removed | removed | removed |
| Defender | **removed** (drivers included) | your choice | your choice |
| Store and Xbox | **removed** | your choice | your choice |
| Microsoft Edge | removed | removed | removed |
| Search / Bluetooth / Printing | removed unless ticked | removed unless ticked | kept |
| Windows Update | **frozen** | paused, servicing intact | untouched |
| Timer daemon (0.5 ms) | yes | yes | no |
| VBS / HVCI | **off** | **off** | untouched |
| Hypervisor | **off** | available | available |
| CPU mitigations | **off** | on | on |
| Pagefile | **disabled** | system managed | system managed |
| Hibernation | **off** | untouched | untouched |
| WinRE and recovery | **removed** | kept | kept |
| Reserved storage | off | off | off |
| Compression | CompactOS + LZX | CompactOS | none |
| UAC | silent | silent | Windows default |

Tiny is the extreme tier and is not supported. It is also the only profile that removes the pagefile and the recovery environment, both of which are deliberate, documented trades.

Tiny also deletes the staged component payload of every app it removes (WinSxS, WindowsApps, AppRepository) and drops the update rollback copies. That is where Windows 11 keeps the extra gigabytes. Restoring them needs a repair install.

## Supported builds

20 builds, `19044` through `28000`.

| Family | Builds |
| --- | --- |
| Windows 10 21H2 / 22H2 | `19044`, `19045` |
| Windows 11 21H2 | `22000` |
| Windows 11 22H2 | `22621`, `22631` |
| Windows 11 23H2 | `23620` |
| Windows 11 24H2 | `26100` |
| Windows 11 25H2 | `26200` |
| **Windows 11 26H2** | **`26300`** |
| Windows 11 26H1 and insiders | `27000` – `28000` |

Windows 11 26H1 (build 28000) is a separate device-scoped release and is supported as its own branch.

## Requirements

- Windows 10 or Windows 11 on a supported build, x64
- [AME Wizard](https://ameliorated.io)
- An internet connection (the browser step uses winget)
- No pending reboot or pending Windows updates
- A backup, or a VM snapshot

## Install

1. Back up, or take a VM snapshot.
2. Install [AME Wizard](https://ameliorated.io).
3. Drag the `.apbx` in, pick a profile, and wait (Tiny adds a 30-60 minute LZX pass).
4. Reboot, then read `C:\AtomOS-Report.txt`.

The `.apbx` is a 7z archive with the password `malte`, an AME convention rather than a secret. You can open it and read every YAML file before running it.

## Verify

Every run writes `C:\AtomOS-Report.txt` before the final restart:

```
Reserved storage   : DISABLED
Pagefile           : ABSENT
WinRE              : DISABLED
CompactOS          : ALWAYS
Edge               : absent
OneDrive setup     : absent
Copilot packages   : 0
App Installer      : present
winget             : yes
Atom tasks         : 1
```

Anything reading `PRESENT`, `still enabled` or `not set` names the step that did not land.

## Rollback

One script per change in `PostInstall\3 Reverts\`. `uncompact.bat` undoes compression, `10 Enable Paging File...bat` restores the pagefile, `timer.bat` removes the timer daemon. Defender removal needs a repair install.

## License

[MIT](LICENSE). Not affiliated with Microsoft or Ameliorated LLC. Windows is a trademark of Microsoft Corporation.

Credits: [AME Wizard](https://ameliorated.io), [7-Zip](https://7-zip.org/), and AtomToolBox.
