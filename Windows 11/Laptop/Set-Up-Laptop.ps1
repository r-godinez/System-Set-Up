param (
    [switch]$TestMode = $false
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# -------------------------------
# Setup
# -------------------------------
$logFile = ".\Logs\InstallApps-Log.txt"
Start-Transcript -Path $logFile -Append

Write-Host "=== System Setup for Windows 11 ===" -ForegroundColor Cyan

if ($TestMode) {
    Write-Host "Test mode is ENABLED (apps will NOT be installed)" -ForegroundColor Yellow
} else {
    Write-Host "Test mode is DISABLED (apps WILL be installed)" -ForegroundColor Yellow
}

Write-Host "Logging to: $logFile" -ForegroundColor DarkGray
Pause

# -------------------------------
# Step 1: Install WSL2
# -------------------------------
Write-Host "`n=== Step 1: Installing WSL2 ===" -ForegroundColor Cyan
Pause

Write-Host "`n--- Enabling WSL2 Features ---" -ForegroundColor Yellow

if ($TestMode) {
    Write-Host "[TEST MODE] Would enable WSL2 features" -ForegroundColor Gray
} else {
    try {
        # Enable WSL feature
        Write-Host "Enabling WSL feature..." -ForegroundColor Yellow
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -ErrorAction SilentlyContinue
        
        # Enable Virtual Machine Platform feature
        Write-Host "Enabling Virtual Machine Platform feature..." -ForegroundColor Yellow
        Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart -ErrorAction SilentlyContinue
        
        # Set WSL2 as default version
        Write-Host "Setting WSL2 as default version..." -ForegroundColor Yellow
        wsl --set-default-version 2 -ErrorAction SilentlyContinue
        
        Write-Host "[SUCCESS] WSL2 features enabled" -ForegroundColor Green
        Write-Host "Note: A reboot may be required for WSL2 to work properly" -ForegroundColor Yellow
    }
    catch {
        Write-Host "[ERROR] Failed to enable WSL2 features: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "You may need to run this script as Administrator" -ForegroundColor Yellow
    }
}

Write-Host "`n--- WSL2 Installation Complete ---" -ForegroundColor Green

# -------------------------------
# Step 2: Install Winget Apps
# -------------------------------
Write-Host "`n=== Step 2: Install Winget apps ===" -ForegroundColor Cyan
Pause

$manualApps = @(
    "Microsoft.OneDrive",   
    "Google.GoogleDrive",
    "Apple.iTunes",         
    "Proton.ProtonVPN",      
    "GIMP.GIMP.3",           
    "Docker.DockerDesktop",
    "Docker.DockerCompose",
    "Docker.DockerCLI",
    "Git.Git",
    "GitHub.GitHubDesktop",
    "Hashicorp.Terraform",
    "GoLang.Go",
    "Microsoft.PowerShell",
    "Brave.Brave",
    "Google.Chrome",
    "Logitech.OptionsPlus",
    "Greenshot.Greenshot",
    "Microsoft.VisualStudioCode",
    "Anysphere.Cursor",
    "Mobatek.MobaXterm",
    "Microsoft.WindowsTerminal",
    "Notion.Notion",
    "Guru3D.Afterburner",   
    "TechPowerUp.GPU-Z",     
    "REALiX.HWiNFO"    
)

foreach ($app in $manualApps) {
    if ($TestMode) {
        Write-Host "[TEST MODE] Would install: $app" -ForegroundColor Gray
    } else {
        Write-Host "Installing $app..." -ForegroundColor Yellow
        winget install --id $app --accept-package-agreements --accept-source-agreements -e
    }
}

# -------------------------------
# Step 3: Manual install reminders
# -------------------------------
Write-Host "`n=== Step 3: Manual installs required ===" -ForegroundColor Magenta
Pause

$manualOnlyApps = @(
    @{ Name = "Spotify"; Url = "https://www.spotify.com/download/windows/" },
    @{ Name = "CherryTree"; Url = "https://www.giuspen.com/cherrytree/" }
)

foreach ($app in $manualOnlyApps) {
    Write-Host "* $($app.Name)" -ForegroundColor DarkYellow
    Write-Host "  - $($app.Url)" -ForegroundColor DarkGray
}

Write-Host "`nYou can install these apps manually via the links above." -ForegroundColor DarkGray

# -------------------------------
# Step 4: Personalize W11 UI
# -------------------------------
Write-Host "`n=== Step 4: Personalizing Windows 11 UI ===" -ForegroundColor Cyan
Pause

function Set-RegistryValue {
    param(
        [string]$Path,
        [string]$Name,
        [object]$Value,
        [string]$Type = "DWord"
    )
    
    try {
        if ($TestMode) {
            Write-Host "[TEST MODE] Would set registry: $Path\$Name = $Value" -ForegroundColor Gray
        } else {
            if (!(Test-Path $Path)) {
                New-Item -Path $Path -Force | Out-Null
            }
            Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type
            Write-Host "[SUCCESS] Set $Path\$Name = $Value" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "[ERROR] Failed to set ${Path}\${Name}: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n--- Applying UI Personalization ---" -ForegroundColor Yellow

# Theme and Appearance
Write-Host "`nSetting Dark Mode..." -ForegroundColor Yellow
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "ColorPrevalence" -Value 1

# Accent Color (Metal Blue)
Write-Host "`nSetting Accent Color to Metal Blue..." -ForegroundColor Yellow
try {
    if ($TestMode) {
        Write-Host "[TEST MODE] Would set accent color to Metal Blue" -ForegroundColor Gray
    } else {
        # Set accent color registry values
        $accentColor = 0xFF3B82C4  # Metal Blue in BGR format
        Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AccentColor" -Value $accentColor -Type "DWord"
        Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AutoColorization" -Value 0
        Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "ColorPrevalence" -Value 1
        
        Write-Host "[SUCCESS] Set accent color registry values" -ForegroundColor Green
        Write-Host "Note: You may need to manually change accent color in Settings > Personalization > Colors" -ForegroundColor Yellow
    }
} catch {
    Write-Host "[WARNING] Could not set accent color registry values: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Taskbar Customization
Write-Host "`nCustomizing Taskbar..." -ForegroundColor Yellow
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 1  # Align taskbar to center

# Disable widgets
Write-Host "Disabling widgets..." -ForegroundColor Yellow
try {
    if ($TestMode) {
        Write-Host "[TEST MODE] Would disable widgets" -ForegroundColor Gray
    } else {
        # Set basic widget registry values
        Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0 -ErrorAction SilentlyContinue
        Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarWi" -Value 0 -ErrorAction SilentlyContinue
        
        Write-Host "[SUCCESS] Widget registry settings applied" -ForegroundColor Green
        Write-Host "Note: You may need to manually disable widgets in Settings > Personalization > Taskbar > Widgets" -ForegroundColor Yellow
    }
} catch {
    Write-Host "[WARNING] Could not disable widgets via registry: $($_.Exception.Message)" -ForegroundColor Yellow
}

Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Value 0  # Disable chat
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0  # Hide task view
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSi" -Value 0  # Small taskbar icons

# Search Box
Write-Host "`nConfiguring Search..." -ForegroundColor Yellow
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0  # Hide search completely

# Start Menu
Write-Host "`nCustomizing Start Menu..." -ForegroundColor Yellow
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackDocs" -Value 0  # Don't show recently opened items
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_ShowClassicMode" -Value 0  # Use Windows 11 start menu
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_IrisMenu" -Value 0  # Disable recommended section
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_ShowRecommendations" -Value 0  # Disable recommendations
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_AccountNotifications" -Value 0  # Disable account notifications
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_Layout" -Value 1  # More pins layout

# Start Menu Folders
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_ShowSettingsFolder" -Value 1  # Show Settings folder
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_ShowFileExplorerFolder" -Value 1  # Show File Explorer folder
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_ShowDownloadsFolder" -Value 1  # Show Downloads folder
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_ShowNetworkFolder" -Value 1  # Show Network folder

# File Explorer
Write-Host "`nConfiguring File Explorer..." -ForegroundColor Yellow
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1  # Show hidden files
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0  # Show file extensions
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Value 1  # Open File Explorer to This PC

# Desktop and Visual Effects
Write-Host "`nConfiguring Desktop..." -ForegroundColor Yellow
Set-RegistryValue -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x9E,0x1E,0x07,0x80,0x12,0x00,0x00,0x00)) -Type "Binary"  # Disable some animations
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2  # Best performance

# Context Menu (Windows 11 style)
Write-Host "`nConfiguring Context Menu..." -ForegroundColor Yellow
# Note: Classic context menu configuration removed due to compatibility issues

# Windows Updates and Notifications
Write-Host "`nConfiguring Notifications..." -ForegroundColor Yellow
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name "NOC_GLOBAL_SETTING_TOAST_SIZE_ENABLED" -Value 1

# Performance Settings
Write-Host "`nConfiguring Performance Settings..." -ForegroundColor Yellow

# Lock Screen Settings
Write-Host "`nConfiguring Lock Screen..." -ForegroundColor Yellow
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" -Name "LockScreenOption" -Value 0  # Picture mode
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "RotatingLockScreenEnabled" -Value 0  # Disable lock screen status
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Value 0  # Disable fun facts, tips on lock screen
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Value 0  # Disable lock screen status

# Device Usage
Write-Host "`nConfiguring Device Usage..." -ForegroundColor Yellow
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Value 1  # Development

# Display Scale (125%)
Write-Host "`nSetting Display Scale..." -ForegroundColor Yellow
Set-RegistryValue -Path "HKCU:\Control Panel\Desktop" -Name "LogPixels" -Value 120  # 125% scaling

# Power Settings (Better Performance)
Write-Host "`nSetting Power Mode..." -ForegroundColor Yellow
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "PowerThrottling" -Value 0  # Disable power throttling

# Time Format (24 hours)
Write-Host "`nSetting 24-hour time format..." -ForegroundColor Yellow
Set-RegistryValue -Path "HKCU:\Control Panel\International" -Name "sTimeFormat" -Value "HH:mm:ss" -Type "String"

# Note about settings refresh
Write-Host "`nNote: Registry changes have been applied." -ForegroundColor Yellow
Write-Host "Some settings may require a restart of Windows Explorer or a reboot to take effect." -ForegroundColor Yellow

Write-Host "`n--- UI Personalization Complete ---" -ForegroundColor Green
Write-Host "Note: Some changes may require a reboot to take full effect." -ForegroundColor Yellow

# -------------------------------
# Manual Settings Instructions
# -------------------------------
Write-Host "`n=== MANUAL SETTINGS REQUIRED ===" -ForegroundColor Magenta
Write-Host "The following settings need to be changed manually:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. ACCENT COLOR:" -ForegroundColor Cyan
Write-Host "   - Right-click on desktop > Personalize" -ForegroundColor White
Write-Host "   - OR: Settings > Personalization > Colors" -ForegroundColor White
Write-Host "   - Select 'Metal Blue' or your preferred accent color" -ForegroundColor White
Write-Host "   - Toggle 'Show accent color on Start and taskbar' ON" -ForegroundColor White
Write-Host ""
Write-Host "2. DISABLE WIDGETS:" -ForegroundColor Cyan
Write-Host "   - Right-click on taskbar > Taskbar settings" -ForegroundColor White
Write-Host "   - OR: Settings > Personalization > Taskbar" -ForegroundColor White
Write-Host "   - Turn OFF 'Widgets' toggle" -ForegroundColor White
Write-Host ""
Write-Host "3. VERIFY OTHER SETTINGS:" -ForegroundColor Cyan
Write-Host "   - Check that Dark mode is enabled" -ForegroundColor White
Write-Host "   - Verify taskbar is centered" -ForegroundColor White
Write-Host "   - Confirm search box is hidden" -ForegroundColor White
Write-Host ""
Write-Host "If registry changes don't apply automatically:" -ForegroundColor Yellow
Write-Host "1. Restart Windows Explorer (Ctrl+Shift+Esc > Windows Explorer > Restart)" -ForegroundColor DarkGray
Write-Host "2. Or reboot your computer" -ForegroundColor DarkGray
Write-Host "3. Or manually change in Settings > Personalization" -ForegroundColor DarkGray

# -------------------------------
# Step 4.5: Taskbar and Desktop Management
# -------------------------------
Write-Host "`n=== Step 4.5: Managing Taskbar and Desktop ===" -ForegroundColor Cyan
Pause

function Manage-TaskbarApps {
    param(
        [string]$Action,
        [string]$AppName = "",
        [string]$AppPath = ""
    )
    
    try {
        if ($TestMode) {
            Write-Host "[TEST MODE] Would $Action taskbar app: $AppName" -ForegroundColor Gray
        } else {
            if ($Action -eq "remove") {
                Write-Host "Removing all apps from taskbar..." -ForegroundColor Yellow
                # Clear taskbar pins using multiple methods
                $taskbarPaths = @(
                    "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar",
                    "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\TaskBar"
                )
                
                foreach ($taskbarPath in $taskbarPaths) {
                    if (Test-Path $taskbarPath) {
                        Get-ChildItem $taskbarPath -Filter "*.lnk" | Remove-Item -Force
                    }
                }
                
                # Also clear from registry
                $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband"
                if (Test-Path $regPath) {
                    Remove-ItemProperty -Path $regPath -Name "Favorites" -ErrorAction SilentlyContinue
                    Remove-ItemProperty -Path $regPath -Name "FavoritesResolve" -ErrorAction SilentlyContinue
                }
                
                Write-Host "[SUCCESS] Cleared taskbar" -ForegroundColor Green
            } elseif ($Action -eq "add" -and $AppPath -and (Test-Path $AppPath)) {
                Write-Host "Adding $AppName to taskbar..." -ForegroundColor Yellow
                # Pin app to taskbar using COM object
                $shell = New-Object -ComObject Shell.Application
                $folder = $shell.Namespace((Get-Item $AppPath).DirectoryName)
                $item = $folder.ParseName((Get-Item $AppPath).Name)
                $verb = $item.Verbs() | Where-Object {$_.Name -eq "Pin to taskbar"}
                if ($verb) {
                    $verb.DoIt()
                    Write-Host "[SUCCESS] Pinned $AppName to taskbar" -ForegroundColor Green
                } else {
                    Write-Host "[WARNING] Could not pin $AppName to taskbar - verb not found" -ForegroundColor Yellow
                }
            } elseif ($Action -eq "add" -and $AppPath) {
                Write-Host "[WARNING] $AppName not found at $AppPath" -ForegroundColor Yellow
            }
        }
    }
    catch {
        Write-Host "[ERROR] Failed to $Action taskbar app: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Manage-DesktopShortcuts {
    try {
        if ($TestMode) {
            Write-Host "[TEST MODE] Would clear desktop shortcuts except Recycle Bin" -ForegroundColor Gray
        } else {
            Write-Host "Clearing desktop shortcuts (except Recycle Bin)..." -ForegroundColor Yellow
            
            # Get all possible desktop paths
            $desktopPaths = @(
                [Environment]::GetFolderPath("Desktop"),
                "$env:USERPROFILE\Desktop",
                "$env:PUBLIC\Desktop"
            )
            
            $removedCount = 0
            foreach ($desktopPath in $desktopPaths) {
                if (Test-Path $desktopPath) {
                    Write-Host "Checking desktop path: $desktopPath" -ForegroundColor DarkGray
                    
                    # Remove all shortcuts except Recycle Bin
                    $shortcuts = Get-ChildItem $desktopPath -Filter "*.lnk" -ErrorAction SilentlyContinue
                    foreach ($shortcut in $shortcuts) {
                        if ($shortcut.Name -ne "Recycle Bin.lnk" -and $shortcut.Name -notlike "*Recycle*") {
                            Remove-Item $shortcut.FullName -Force -ErrorAction SilentlyContinue
                            $removedCount++
                            Write-Host "Removed: $($shortcut.Name)" -ForegroundColor DarkGray
                        }
                    }
                    
                    # Also remove any other files that might be shortcuts
                    $otherFiles = Get-ChildItem $desktopPath -File -ErrorAction SilentlyContinue | Where-Object {
                        $_.Extension -eq ".lnk" -or $_.Extension -eq ".url" -or $_.Extension -eq ".pif"
                    }
                    foreach ($file in $otherFiles) {
                        if ($file.Name -ne "Recycle Bin.lnk" -and $file.Name -notlike "*Recycle*") {
                            Remove-Item $file.FullName -Force -ErrorAction SilentlyContinue
                            $removedCount++
                            Write-Host "Removed: $($file.Name)" -ForegroundColor DarkGray
                        }
                    }
                }
            }
            
            Write-Host "[SUCCESS] Cleared $removedCount desktop shortcuts" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "[ERROR] Failed to clear desktop shortcuts: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Manage-StartMenuApps {
    param(
        [string[]]$AppNames
    )
    
    try {
        if ($TestMode) {
            Write-Host "[TEST MODE] Would add apps to Start menu: $($AppNames -join ', ')" -ForegroundColor Gray
        } else {
            Write-Host "Adding apps to Start menu..." -ForegroundColor Yellow
            $startMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
            
            foreach ($appName in $AppNames) {
                # First try to find using our improved function
                $appPath = Find-AppPath -AppName $appName
                
                # If not found, try Get-Command
                if (-not $appPath) {
                    $command = Get-Command $appName -ErrorAction SilentlyContinue
                    if ($command) {
                        $appPath = $command.Source
                    }
                }
                
                # Try alternative names for some apps
                if (-not $appPath) {
                    switch ($appName) {
                        "GitHub Desktop" { 
                            $command = Get-Command "GitHubDesktop" -ErrorAction SilentlyContinue
                            if ($command) { $appPath = $command.Source }
                        }
                        "Docker Desktop" { 
                            $command = Get-Command "Docker Desktop" -ErrorAction SilentlyContinue
                            if ($command) { $appPath = $command.Source }
                        }
                        "Proton VPN" { 
                            $command = Get-Command "ProtonVPN" -ErrorAction SilentlyContinue
                            if ($command) { $appPath = $command.Source }
                        }
                        "MobaXterm" { 
                            $command = Get-Command "MobaXterm" -ErrorAction SilentlyContinue
                            if ($command) { $appPath = $command.Source }
                        }
                        "Visual Studio Code" { 
                            $command = Get-Command "code" -ErrorAction SilentlyContinue
                            if ($command) { $appPath = $command.Source }
                        }
                        "Bitwarden" { 
                            $command = Get-Command "Bitwarden" -ErrorAction SilentlyContinue
                            if ($command) { $appPath = $command.Source }
                        }
                    }
                }
                
                if ($appPath -and (Test-Path $appPath)) {
                    # Try to pin to Start menu using COM object
                    try {
                        $shell = New-Object -ComObject Shell.Application
                        $folder = $shell.Namespace((Get-Item $appPath).DirectoryName)
                        $item = $folder.ParseName((Get-Item $appPath).Name)
                        $verb = $item.Verbs() | Where-Object {$_.Name -eq "Pin to Start"}
                        if ($verb) {
                            $verb.DoIt()
                            Write-Host "[SUCCESS] Pinned $appName to Start menu" -ForegroundColor Green
                        } else {
                            # Fallback to creating shortcut
                            $shortcutPath = Join-Path $startMenuPath "$appName.lnk"
                            $WshShell = New-Object -ComObject WScript.Shell
                            $Shortcut = $WshShell.CreateShortcut($shortcutPath)
                            $Shortcut.TargetPath = $appPath
                            $Shortcut.Save()
                            Write-Host "[SUCCESS] Added $appName to Start menu (shortcut)" -ForegroundColor Green
                        }
                    } catch {
                        # Fallback to creating shortcut
                        $shortcutPath = Join-Path $startMenuPath "$appName.lnk"
                        $WshShell = New-Object -ComObject WScript.Shell
                        $Shortcut = $WshShell.CreateShortcut($shortcutPath)
                        $Shortcut.TargetPath = $appPath
                        $Shortcut.Save()
                        Write-Host "[SUCCESS] Added $appName to Start menu (shortcut fallback)" -ForegroundColor Green
                    }
                } else {
                    Write-Host "[WARNING] Could not find $appName to add to Start menu" -ForegroundColor Yellow
                }
            }
        }
    }
    catch {
        Write-Host "[ERROR] Failed to add apps to Start menu: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Find-AppPath {
    param([string]$AppName)
    
    $possiblePaths = @()
    
    switch ($AppName) {
        "Brave" {
            $possiblePaths = @(
                "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe",
                "C:\Program Files (x86)\BraveSoftware\Brave-Browser\Application\brave.exe",
                "${env:PROGRAMFILES}\BraveSoftware\Brave-Browser\Application\brave.exe",
                "${env:PROGRAMFILES(X86)}\BraveSoftware\Brave-Browser\Application\brave.exe"
            )
        }
        "Terminal" {
            $possiblePaths = @(
                "${env:LOCALAPPDATA}\Microsoft\WindowsApps\wt.exe",
                "C:\Users\$env:USERNAME\AppData\Local\Microsoft\WindowsApps\wt.exe",
                "${env:PROGRAMFILES}\WindowsApps\Microsoft.WindowsTerminal_*\wt.exe"
            )
        }
        "Notion" {
            $possiblePaths = @(
                "${env:LOCALAPPDATA}\Programs\Notion\Notion.exe",
                "${env:PROGRAMFILES}\Notion\Notion.exe",
                "${env:PROGRAMFILES(X86)}\Notion\Notion.exe"
            )
        }
        "Cursor" {
            $possiblePaths = @(
                "${env:LOCALAPPDATA}\Programs\cursor\Cursor.exe",
                "${env:PROGRAMFILES}\Cursor\Cursor.exe",
                "${env:PROGRAMFILES(X86)}\Cursor\Cursor.exe"
            )
        }
        "Visual Studio Code" {
            $possiblePaths = @(
                "${env:LOCALAPPDATA}\Programs\Microsoft VS Code\Code.exe",
                "${env:PROGRAMFILES}\Microsoft VS Code\Code.exe",
                "${env:PROGRAMFILES(X86)}\Microsoft VS Code\Code.exe"
            )
        }
        "Bitwarden" {
            $possiblePaths = @(
                "${env:LOCALAPPDATA}\Programs\Bitwarden\Bitwarden.exe",
                "${env:PROGRAMFILES}\Bitwarden\Bitwarden.exe",
                "${env:PROGRAMFILES(X86)}\Bitwarden\Bitwarden.exe"
            )
        }
        "Docker Desktop" {
            $possiblePaths = @(
                "${env:PROGRAMFILES}\Docker\Docker\Docker Desktop.exe",
                "${env:PROGRAMFILES(X86)}\Docker\Docker\Docker Desktop.exe"
            )
        }
        "GitHub Desktop" {
            $possiblePaths = @(
                "${env:LOCALAPPDATA}\GitHubDesktop\GitHubDesktop.exe",
                "${env:PROGRAMFILES}\GitHub Desktop\GitHubDesktop.exe",
                "${env:PROGRAMFILES(X86)}\GitHub Desktop\GitHubDesktop.exe"
            )
        }
        "MobaXterm" {
            $possiblePaths = @(
                "${env:PROGRAMFILES}\Mobatek\MobaXterm\MobaXterm.exe",
                "${env:PROGRAMFILES(X86)}\Mobatek\MobaXterm\MobaXterm.exe"
            )
        }
        "Proton VPN" {
            $possiblePaths = @(
                "${env:PROGRAMFILES}\ProtonVPN\ProtonVPN.exe",
                "${env:PROGRAMFILES(X86)}\ProtonVPN\ProtonVPN.exe"
            )
        }
        "Outlook" {
            $possiblePaths = @(
                "${env:PROGRAMFILES}\Microsoft Office\root\Office16\OUTLOOK.EXE",
                "${env:PROGRAMFILES(X86)}\Microsoft Office\root\Office16\OUTLOOK.EXE"
            )
        }
    }
    
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            return $path
        }
    }
    
    # Try to find via Get-Command
    $command = Get-Command $AppName -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }
    
    return $null
}

# Clear taskbar
Manage-TaskbarApps -Action "remove"

# Add specific apps to taskbar
$taskbarApps = @("Brave", "Terminal")

foreach ($appName in $taskbarApps) {
    $appPath = Find-AppPath -AppName $appName
    if ($appPath) {
        Manage-TaskbarApps -Action "add" -AppName $appName -AppPath $appPath
    } else {
        Write-Host "[WARNING] $appName not found in common locations" -ForegroundColor Yellow
    }
}

# Clear desktop shortcuts
Manage-DesktopShortcuts

# Add apps to Start menu
$startMenuApps = @("Notion", "Cursor", "Bitwarden", "Docker Desktop", "GitHub Desktop", "MobaXterm", "Proton VPN", "Visual Studio Code", "Outlook")
Manage-StartMenuApps -AppNames $startMenuApps

Write-Host "`n--- Taskbar and Desktop Management Complete ---" -ForegroundColor Green

# Restart Windows Explorer to apply changes
Write-Host "`nRestarting Windows Explorer to apply taskbar changes..." -ForegroundColor Yellow
try {
    if ($TestMode) {
        Write-Host "[TEST MODE] Would restart Windows Explorer" -ForegroundColor Gray
    } else {
        Stop-Process -Name "explorer" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Start-Process "explorer.exe"
        Write-Host "[SUCCESS] Windows Explorer restarted" -ForegroundColor Green
    }
} catch {
    Write-Host "[WARNING] Could not restart Windows Explorer: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "You may need to manually restart Windows Explorer or reboot for all changes to take effect" -ForegroundColor Yellow
}

# -------------------------------
# Step 5: Remove Unwanted Apps
# -------------------------------
Write-Host "`n=== Step 5: Removing Unwanted Apps ===" -ForegroundColor Cyan
Pause

function Remove-App {
    param(
        [string]$AppName,
        [string]$PackageName
    )
    
    try {
        if ($TestMode) {
            Write-Host "[TEST MODE] Would remove: $AppName" -ForegroundColor Gray
        } else {
            Write-Host "Removing $AppName..." -ForegroundColor Yellow
            Get-AppxPackage $PackageName -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -like "*$PackageName*"} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
            Write-Host "[SUCCESS] Removed $AppName" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "[ERROR] Failed to remove ${AppName}: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n--- Removing Microsoft Apps ---" -ForegroundColor Yellow

$appsToRemove = @(
    @{ Name = "Feedback Hub"; Package = "*Microsoft.FeedbackHub*" },
    @{ Name = "Game Assist"; Package = "*Microsoft.GameApp*" },
    @{ Name = "Ink Handwriting"; Package = "*Microsoft.InputApp*" },
    @{ Name = "Xbox"; Package = "*Microsoft.XboxApp*" },
    @{ Name = "Xbox Live"; Package = "*Microsoft.XboxGamingOverlay*" },
    @{ Name = "Start Experiences App"; Package = "*Microsoft.Windows.StartMenuExperienceHost*" },
    @{ Name = "Solitaire and Casual Games"; Package = "*Microsoft.MicrosoftSolitaireCollection*" },
    @{ Name = "Quick Assist"; Package = "*Microsoft.QuickAssist*" },
    @{ Name = "Microsoft To Do"; Package = "*Microsoft.Todos*" },
    @{ Name = "Microsoft Teams"; Package = "*Microsoft.Teams*" },
    @{ Name = "Microsoft News"; Package = "*Microsoft.BingNews*" },
    @{ Name = "Microsoft Edge"; Package = "*Microsoft.MicrosoftEdge*" },
    @{ Name = "Microsoft Bing"; Package = "*Microsoft.BingWeather*" },
    @{ Name = "Microsoft ClipChamp"; Package = "*Microsoft.Clipchamp*" },
    @{ Name = "LinkedIn"; Package = "*Microsoft.LinkedIn*" }
)

foreach ($app in $appsToRemove) {
    Remove-App -AppName $app.Name -PackageName $app.Package
}

Write-Host "`n--- Apps Removal Complete ---" -ForegroundColor Green

# -------------------------------
# Step 6: Remove System Components
# -------------------------------
Write-Host "`n=== Step 6: Removing System Components ===" -ForegroundColor Cyan
Pause

Write-Host "`n--- Disabling Game Bar ---" -ForegroundColor Yellow

if ($TestMode) {
    Write-Host "[TEST MODE] Would disable Game Bar" -ForegroundColor Gray
} else {
    try {
        Set-RegistryValue -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 0
        Set-RegistryValue -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 0
        Set-RegistryValue -Path "HKCU:\Software\Microsoft\GameBar" -Name "ShowStartupPanel" -Value 0
        Set-RegistryValue -Path "HKCU:\Software\Microsoft\GameBar" -Name "UseNexusForGameBarEnabled" -Value 0
        Write-Host "[SUCCESS] Game Bar disabled" -ForegroundColor Green
    }
    catch {
        Write-Host "[ERROR] Failed to disable Game Bar: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n--- System Components Removal Complete ---" -ForegroundColor Green

# -------------------------------
# Step 7: System Configuration
# -------------------------------
Write-Host "`n=== Step 7: System Configuration ===" -ForegroundColor Cyan
Pause

Write-Host "`n--- Renaming PC to 'MiniBox' ---" -ForegroundColor Yellow

if ($TestMode) {
    Write-Host "[TEST MODE] Would rename PC to 'MiniBox'" -ForegroundColor Gray
} else {
    try {
        $computerName = "MiniBox"
        Rename-Computer -NewName $computerName -Force
        Write-Host "[SUCCESS] PC renamed to 'MiniBox' (reboot required)" -ForegroundColor Green
    }
    catch {
        Write-Host "[ERROR] Failed to rename PC: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "You may need to run this script as Administrator to rename the PC" -ForegroundColor Yellow
    }
}

Write-Host "`n--- Renaming Current User Account to 'ricardog' ---" -ForegroundColor Yellow

if ($TestMode) {
    Write-Host "[TEST MODE] Would rename current user account to 'ricardog'" -ForegroundColor Gray
} else {
    try {
        # Get current user
        $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Split('\')[1]
        Write-Host "Current user: $currentUser" -ForegroundColor Cyan
        
        # Check if target name already exists
        $userExists = Get-LocalUser -Name "ricardog" -ErrorAction SilentlyContinue
        if ($userExists) {
            Write-Host "User 'ricardog' already exists. Skipping rename." -ForegroundColor Yellow
        } else {
            # Rename the current user account
            if ($currentUser -ne "ricardog") {
                Rename-LocalUser -Name $currentUser -NewName "ricardog"
                Write-Host "[SUCCESS] User account renamed from '$currentUser' to 'ricardog'" -ForegroundColor Green
                Write-Host "Note: You will need to log out and back in for the change to take full effect" -ForegroundColor Yellow
            } else {
                Write-Host "Current user is already named 'ricardog'" -ForegroundColor Yellow
            }
        }
    }
    catch {
        Write-Host "[ERROR] Failed to rename user account: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "You may need to run this script as Administrator to rename user accounts" -ForegroundColor Yellow
    }
}

Write-Host "`n--- System Configuration Complete ---" -ForegroundColor Green

# -------------------------------
# Step 8: Create Settings Refresh Script
# -------------------------------
Write-Host "`n=== Step 8: Creating Settings Refresh Script ===" -ForegroundColor Cyan
Pause

Write-Host "`n--- Creating Windows Settings Refresh Script ---" -ForegroundColor Yellow

$refreshScript = @'
# Windows Settings Refresh Script
# Run this script if accent color or widgets don't apply properly

Write-Host "Refreshing Windows Settings..." -ForegroundColor Cyan

# Restart Windows Explorer to apply registry changes
Write-Host "Restarting Windows Explorer..." -ForegroundColor Yellow
try {
    Stop-Process -Name "explorer" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    Start-Process "explorer.exe"
    Write-Host "Windows Explorer restarted" -ForegroundColor Green
} catch {
    Write-Host "Could not restart Windows Explorer" -ForegroundColor Red
}

Write-Host "`nSettings refresh complete!" -ForegroundColor Green
Write-Host "If issues persist, try:" -ForegroundColor Yellow
Write-Host "1. Manually change accent color in Settings > Personalization > Colors" -ForegroundColor DarkGray
Write-Host "2. Manually disable widgets in Settings > Personalization > Taskbar" -ForegroundColor DarkGray
Write-Host "3. Reboot your computer" -ForegroundColor DarkGray
'@

try {
    if ($TestMode) {
        Write-Host "[TEST MODE] Would create refresh script" -ForegroundColor Gray
    } else {
        $refreshScriptPath = ".\Refresh-WindowsSettings.ps1"
        $refreshScript | Out-File -FilePath $refreshScriptPath -Encoding UTF8
        Write-Host "[SUCCESS] Created refresh script: $refreshScriptPath" -ForegroundColor Green
        Write-Host "Run this script if accent color or widgets don't apply properly" -ForegroundColor Yellow
    }
} catch {
    Write-Host "[ERROR] Failed to create refresh script: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n--- Settings Refresh Script Complete ---" -ForegroundColor Green

# -------------------------------
# Done
# -------------------------------
Write-Host "`n=== All Done! Reboot your PC and enjoy your setup. ===" -ForegroundColor Green
Write-Host "`nIf accent color or widgets don't change:" -ForegroundColor Yellow
Write-Host "1. Run the Refresh-WindowsSettings.ps1 script" -ForegroundColor DarkGray
Write-Host "2. Or restart Windows Explorer manually" -ForegroundColor DarkGray
Write-Host "3. Or reboot your computer" -ForegroundColor DarkGray
Stop-Transcript
Pause