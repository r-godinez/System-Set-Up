param (
    [switch]$TestMode = $false
)

Write-Host "=== Step 5: Managing Taskbar and Desktop ===" -ForegroundColor Cyan
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

