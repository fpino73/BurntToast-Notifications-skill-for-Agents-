# Notification Skill — Windows Desktop Toasts for AI Coding Agents

Sends native Windows toast notifications from **OpenCode** and **Claude Code** agents using the BurntToast PowerShell module.

## Quick Start

```powershell
# 1. Install BurntToast (run as Administrator)
Install-Module -Name BurntToast -Force -AllowClobber

# 2. Copy to your project
# OpenCode:  cp -r notification/ .agents/skills/notification/
# Claude:    cp -r notification/ .claude/skills/notification/

# 3. Test it
.\notify.ps1 "Hello" "Notifications work!" success
```

## Features

- Native Windows toast popups via BurntToast
- Auto-fallback to Windows Forms API if BurntToast is missing
- Supports success, error, and info notification types
- Silent mode, custom icons, action buttons, auto-expire

## Requirements

- Windows 10+
- PowerShell 5.1+
- BurntToast module (auto-installed via `Install-Module`)

## License

MIT
