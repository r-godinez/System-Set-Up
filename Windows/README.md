## 💻 Windows System Reinstall Automation Script

This PowerShell script automates reinstalling your most-used apps after a fresh Windows install.

### 🔧 Features

- Restores exported Winget apps
- Installs commonly used apps not in the export list
- Uses `winget` for fast, silent setup
- Provides URLs for manually downloadable drivers/tools
- Supports dry-run testing (no apps installed)
- Logs all actions to `InstallApps-Log.txt`

### ▶️ How to Use

1. **Run in Dry-Run Mode (safe preview):**
```powershell
.\Install-AllApps.ps1 -TestMode
```

2. **Actual Run (Remove Apps)**
```powershell
.\Install-AllApps.ps1 -TestMode:$false
```

## 🧹 Debloat Windows 11 (Optional but Recommended)

This script removes common Windows 11 bloatware while preserving tools essential for **gaming** and **development**. Run it after a fresh install to streamline your system before restoring apps.

### 🔧 Features

- Removes preinstalled apps like:
  - Xbox Game Bar
  - Cortana
  - Solitaire & Candy Crush
  - Clipchamp, News, Weather, etc.
- Keeps essential components like:
  - Microsoft Store & App Installer
  - Xbox controller support
  - WSL & dev tools (PowerShell, Terminal, VS Code)
- Creates a log file (`Debloat-Log.txt`)
- Supports **dry-run mode** for safe testing

---

### 🚀 Usage

> ⚠️ Run in **PowerShell as Administrator**

#### ✅ Dry Run (Test Mode)

Preview what would be removed:

```powershell
.\Debloat-Windows.ps1 -TestMode
```

#### ✅ Actual Run (Remove Apps)

Remove bloatware:

```powershell
.\Debloat-Windows.ps1
```