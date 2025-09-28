param (
    [switch]$TestMode = $false
)

Write-Host "=== Step 9: Creating Utility Scripts ===" -ForegroundColor Cyan
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

Write-Host "`n--- Creating Winget Management Script ---" -ForegroundColor Yellow

$wingetManagementScript = @'
# Winget Management Script
# This script provides utilities for managing winget installations

param(
    [switch]$ListInstalled,
    [switch]$UpdateAll,
    [switch]$Search,
    [string]$SearchTerm = "",
    [switch]$Help
)

function Show-Help {
    Write-Host "Winget Management Script" -ForegroundColor Cyan
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\Winget-Management.ps1 -ListInstalled    # List all installed apps"
    Write-Host "  .\Winget-Management.ps1 -UpdateAll        # Update all installed apps"
    Write-Host "  .\Winget-Management.ps1 -Search -SearchTerm 'appname'  # Search for apps"
    Write-Host "  .\Winget-Management.ps1 -Help             # Show this help"
}

function List-InstalledApps {
    Write-Host "Installed applications via winget:" -ForegroundColor Cyan
    winget list
}

function Update-AllApps {
    Write-Host "Updating all installed applications..." -ForegroundColor Yellow
    winget upgrade --all --accept-package-agreements --accept-source-agreements
}

function Search-Apps {
    param([string]$Term)
    if ($Term) {
        Write-Host "Searching for '$Term'..." -ForegroundColor Cyan
        winget search $Term
    } else {
        Write-Host "Please provide a search term with -SearchTerm" -ForegroundColor Red
    }
}

# Main execution
if ($Help) {
    Show-Help
} elseif ($ListInstalled) {
    List-InstalledApps
} elseif ($UpdateAll) {
    Update-AllApps
} elseif ($Search) {
    Search-Apps -Term $SearchTerm
} else {
    Show-Help
}
'@

try {
    if ($TestMode) {
        Write-Host "[TEST MODE] Would create winget management script" -ForegroundColor Gray
    } else {
        $wingetScriptPath = ".\Winget-Management.ps1"
        $wingetManagementScript | Out-File -FilePath $wingetScriptPath -Encoding UTF8
        Write-Host "[SUCCESS] Created winget management script: $wingetScriptPath" -ForegroundColor Green
        Write-Host "Use this script to manage your winget installations:" -ForegroundColor Yellow
        Write-Host "  .\Winget-Management.ps1 -ListInstalled    # List installed apps" -ForegroundColor DarkGray
        Write-Host "  .\Winget-Management.ps1 -UpdateAll        # Update all apps" -ForegroundColor DarkGray
        Write-Host "  .\Winget-Management.ps1 -Search -SearchTerm 'appname'  # Search apps" -ForegroundColor DarkGray
    }
} catch {
    Write-Host "[ERROR] Failed to create winget management script: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n--- Utility Scripts Creation Complete ---" -ForegroundColor Green

