---
name: notification
description: Windows desktop toast notifications via BurntToast for OpenCode and Claude Code agents. Sends system notifications on task completion, errors, long-running processes, or any event needing user attention.
license: MIT
metadata:
  author: Francisco Pinochet
  version: "1.0"
  requires:
    - BurntToast PowerShell module
    - Windows 10+
---

# Desktop Notification Skill (Windows)

Sends native Windows toast notifications from AI coding agents (OpenCode / Claude Code) using the **BurntToast** PowerShell module.

---

## Installation

### 1. Install BurntToast (one-time)

Open PowerShell **as Administrator** and run:

```powershell
Install-Module -Name BurntToast -Force -AllowClobber
```

Verify installation:

```powershell
Get-Module -ListAvailable -Name BurntToast
```

> If you get an `ExecutionPolicy` error, run first:
> `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`

### 2. Copy the skill to your project

**For OpenCode:**
```bash
cp -r notification/ .agents/skills/notification/
```

**For Claude Code:**
```bash
cp -r notification/ .claude/skills/notification/
```

### 3. Register the skill

**OpenCode** — add to `opencode.json`:
```json
{
  "skills": ["notification"]
}
```

**Claude Code** — skills are auto-detected from `.claude/skills/`. Ensure `notification/SKILL.md` is present in your skills directory.

---

## Usage

### Quick notification (inline)

```powershell
powershell -NoProfile -Command "Import-Module BurntToast; New-BurntToastNotification -Text 'Title', 'Message'"
```

### With helper script

Include `notify.ps1` in your project:

```powershell
.\notify.ps1 "Title" "Message" success
.\notify.ps1 "Error" "Something failed" error
.\notify.ps1 "Info" "Process completed" info
```

The script auto-falls back to native Windows API if BurntToast is not available.

---

## When the agent should notify

| Situation | Agent action |
|---|---|
| Long task completed (>30s) | `notify "Task Complete" "Finished in X seconds" success` |
| Execution error | `notify "Error" "Failed: [description]" error` |
| Important result ready | `notify "Result" "File generated at [path]" info` |
| Pipeline finished | `notify "Pipeline" "[name] completed successfully" success` |
| User intervention needed | `notify "Attention" "Action required on [task]" info` |

---

## Customization

### Custom icon
```powershell
New-BurntToastNotification -Text "Title", "Message" -AppLogo "C:\path\to\icon.png"
```

### Silent (no sound)
```powershell
New-BurntToastNotification -Text "Title", "Message" -Silent
```

### With action button (opens URL)
```powershell
$btn = New-BTButton -Content "Open" -Arguments "https://example.com"
New-BurntToastNotification -Text "Title", "Message" -Button $btn
```

### Auto-expire
```powershell
$expire = (Get-Date).AddHours(2)
New-BurntToastNotification -Text "Limited", "Expires soon" -ExpirationTime $expire
```

---

## Troubleshooting

| Problem | Solution |
|---|---|
| `Install-Module` not found | Install PowerShellGet: `Install-PackageProvider -Name NuGet -Force` |
| Access Denied error | Run PowerShell as Administrator |
| Notification not showing | Check Windows: Settings > System > Notifications > Enable app notifications |
| BurntToast missing at runtime | Check with `Get-Module -ListAvailable BurntToast` |

---

## Files

| File | Description |
|---|---|
| `SKILL.md` | This file — agent instructions and user setup guide |
| `notify.ps1` | Helper script with BurntToast + native fallback |
| `LICENSE.txt` | MIT license |
