# Windows 11 Laptop Setup Script

A comprehensive PowerShell script to automatically configure and personalize a fresh Windows 11 installation. This script handles app installation, UI personalization, system configuration, and cleanup.

## 📋 Overview

This script performs the following operations:
- **Step 1**: Install and configure WSL2 (Windows Subsystem for Linux)
- **Step 2**: Install applications via Winget
- **Step 3**: Manual installation reminders
- **Step 4**: Windows 11 UI personalization
- **Step 5**: Remove unwanted Microsoft apps
- **Step 6**: Disable system components (Game Bar)
- **Step 7**: System configuration (PC rename, user account rename)

## 🚀 Quick Start

### Prerequisites
- Windows 11 (fresh installation recommended)
- Administrator privileges
- Internet connection
- PowerShell 5.1 or later

### First-Time Setup (Execution Policy)
Before running the script, you may need to enable script execution:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
Type `Y` when prompted to confirm.

### If download script
Run following command remove "downloaded from internet" mark

```powershell
Unblock-File -Path "C:\Path\to\file\Set-Up-Laptop.ps1"
```

### Running the Script

1. **Download the script** to your desired location (e.g., `C:\Users\YourUser\Documents\`)

2. **Open PowerShell as Administrator**:
   - Press `Win + X`
   - Select "Windows PowerShell (Admin)" or "Terminal (Admin)"

3. **Navigate to the script directory**:
   ```powershell
   cd "C:\Users\YourUser\Documents\"
   ```

4. **Run the script**:
   ```powershell
   .\Set-Up-Laptop.ps1
   ```

## 🔧 Command Line Options

### Test Mode
Run the script in test mode to see what would be changed without making actual modifications:

```powershell
.\Set-Up-Laptop.ps1 -TestMode
```

This will:
- Show all registry changes that would be made
- Display all apps that would be installed/removed
- Show system configuration changes
- **No actual changes will be applied**

## 📦 What Gets Installed

### WSL2 (Windows Subsystem for Linux)
- ✅ **WSL Feature**: Enables Windows Subsystem for Linux
- ✅ **Virtual Machine Platform**: Required for WSL2
- ✅ **WSL2 Default**: Sets WSL2 as the default version
- ✅ **Docker Integration**: Essential for Docker Desktop on Windows

### Applications (via Winget)
- **Development**: Git, GitHub Desktop, Terraform, Go, PowerShell, Docker Desktop
- **Browsers**: Brave, Google Chrome
- **Productivity**: Visual Studio Code, Cursor, Notion, CherryTree
- **Utilities**: OneDrive, iTunes, Spotify, ProtonVPN, GIMP
- **System Tools**: HWiNFO, GPU-Z, MSI Afterburner, Greenshot
- **Terminal**: Windows Terminal, MobaXterm
- **Hardware**: Logitech Options Plus

## 🎨 UI Personalization Applied

### Theme & Appearance
- ✅ Dark mode enabled (system and apps)
- ✅ Accent colors enabled
- ✅ 24-hour time format

### Taskbar Configuration
- ✅ Search: Hidden
- ✅ Task View: Off
- ✅ Widgets: Off
- ✅ Chat: Off
- ✅ Icons aligned to left
- ✅ Small taskbar icons

### Start Menu Settings
- ✅ Layout: More pins
- ✅ Recommended files: Off
- ✅ Tips recommendations: Off
- ✅ Account notifications: Off
- ✅ Folders enabled: Settings, File Explorer, Downloads, Network

### File Explorer
- ✅ Show hidden files
- ✅ Show file extensions
- ✅ Opens to "This PC"

### System Settings
- ✅ Display scale: 125%
- ✅ Power mode: Better Performance
- ✅ Lock screen: Picture mode
- ✅ Lock screen status: None
- ✅ Device usage: Development & Business

## 🗑️ Apps Removed

The following Microsoft apps will be uninstalled:
- Feedback Hub
- Game Assist
- Ink Handwriting
- Xbox & Xbox Live
- Solitaire and Casual Games
- Quick Assist
- Microsoft To Do
- Microsoft Teams
- Microsoft News
- Microsoft Edge
- Microsoft Bing
- Microsoft ClipChamp
- Start Experiences App

## ⚙️ System Configuration

### PC Settings
- **Computer Name**: Renamed to "MiniBox"
- **User Account**: Current account renamed to "ricardog"

### Disabled Components
- **Game Bar**: Completely disabled (all gaming features)

## 📝 Logging

The script creates detailed logs in:
```
.\Logs\InstallApps-Log.txt
```

This log includes:
- All executed commands
- Success/failure status
- Error messages
- Timestamps

## ⚠️ Important Notes

### Administrator Rights
**Required for:**
- PC renaming
- User account operations
- Some registry modifications
- App removal operations

### Reboot Requirements
**Reboot needed for:**
- PC name changes
- User account name changes
- Some UI personalization settings
- Display scaling changes

### Safety Features
- **Test Mode**: Always test first with `-TestMode`
- **Error Handling**: Comprehensive try-catch blocks
- **Backup**: Registry changes are user-level where possible
- **Rollback**: Most changes can be manually reversed

## 🔍 Troubleshooting

### Common Issues

#### "Execution Policy" Error
If you get this error:
```
cannot be loaded because running scripts is disabled on this system
```

**Solution 1 (Recommended - Current User Only):**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
Type `Y` when prompted to confirm.

**Solution 2 (Temporary - Session Only):**
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

**Solution 3 (Check Current Policy):**
```powershell
Get-ExecutionPolicy -List
```

**Why this happens:** Windows blocks PowerShell scripts by default for security. The `RemoteSigned` policy allows locally created scripts (like yours) to run while still protecting against malicious remote scripts.

#### "Access Denied" Errors
- Ensure you're running PowerShell as Administrator
- Check if antivirus is blocking the script

#### Apps Not Installing
- Verify internet connection
- Check if Winget is installed: `winget --version`
- Some apps may require manual installation

#### Registry Changes Not Applied
- Some changes require a reboot to take effect
- Check if the registry path exists
- Verify you have sufficient permissions

#### WSL2 Issues
- **Reboot Required**: WSL2 features may require a reboot to activate
- **Check WSL Status**: Run `wsl --status` to verify WSL2 is working
- **Docker Integration**: Ensure Docker Desktop is set to use WSL2 backend
- **Virtualization**: Make sure virtualization is enabled in BIOS/UEFI

### Manual Verification

#### Check Installed Apps
```powershell
Get-AppxPackage | Select-Object Name, Publisher
```

#### Check Registry Settings
```powershell
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme"
```

#### Check Computer Name
```powershell
$env:COMPUTERNAME
```

#### Check WSL2 Status
```powershell
wsl --status
wsl --list --verbose
```

## 📞 Support

### Before Running
1. **Backup important data**
2. **Create a system restore point**
3. **Test in a virtual machine first** (recommended)
4. **Run with `-TestMode` first**

### After Running
1. **Reboot your system**
2. **Verify all changes applied correctly**
3. **Check the log file for any errors**
4. **Test installed applications**

## 🔄 Customization

### Adding More Apps
Edit the `$manualApps` array in the script:
```powershell
$manualApps = @(
    "Microsoft.OneDrive",
    "Your.NewApp.Here",
    # Add more apps here
)
```

### Modifying Registry Settings
Add new registry modifications in Step 3:
```powershell
Set-RegistryValue -Path "Your\Registry\Path" -Name "SettingName" -Value "SettingValue"
```

### Changing Personalization
Modify the registry values in Step 3 to match your preferences.

## 📄 License

This script is provided as-is for educational and personal use. Use at your own risk.

## ⚡ Performance Notes

- **Script Runtime**: 15-30 minutes (depending on internet speed)
- **Disk Space**: ~5-10 GB for all applications
- **Network Usage**: ~2-5 GB for app downloads
- **CPU Usage**: Moderate during app installations

---

**Remember**: Always test with `-TestMode` first and create a system restore point before running in production!
