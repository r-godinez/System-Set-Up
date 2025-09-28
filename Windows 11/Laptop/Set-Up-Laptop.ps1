param (
    [switch]$TestMode = $false
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# -------------------------------
# NEED TO UPDATE ON SCRIPT
# -------------------------------
# SETTINGS > PERSONALIZATION > COLORS > Transparency effects: ON
# SETTINGS > PERSONALIZATION > COLORS > Accent color: Manual (select Metal Blue, Show on Start & Taskbar: OFF, Show on Title bars & window borders: OFF)
# SETTINGS > ACCESIBILITY > MOUSE POINTER AND TOUCH > Mouse pointer style: BLACK
# SETTINGS > APPS > STARTUP: GOOGLEDRIVE (ON)
# SETTINGS > SYSTEM > DISPLAY > SCALE: 125%
# SETTINGS > SYSTEM > POWER & BATTERY > POWER MODE: Plugged in: Best Performance, On battery: Balanced
# UNINSTALL APPS: GAME ASSIST, MS BING, MS CLIPCHAMP, XBOX, XBOX LIVE, QUICK ASSIST, MS TEAMS, MS EDGE, LINKEDIN
#

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
# Function to run step scripts
# -------------------------------
function Invoke-StepScript {
    param(
        [string]$ScriptName,
        [string]$StepDescription
    )
    
    $scriptPath = ".\$ScriptName"
    
    if (Test-Path $scriptPath) {
        Write-Host "`n=== $StepDescription ===" -ForegroundColor Cyan
        try {
            & $scriptPath -TestMode:$TestMode
            Write-Host "[SUCCESS] Completed: $StepDescription" -ForegroundColor Green
        }
        catch {
            Write-Host "[ERROR] Failed to run $ScriptName`: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "Continuing with next step..." -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "[ERROR] Script not found: $scriptPath" -ForegroundColor Red
        Write-Host "Skipping: $StepDescription" -ForegroundColor Yellow
    }
}

# -------------------------------
# Execute all setup steps
# -------------------------------

# Step 1: Install WSL2
Invoke-StepScript -ScriptName "Step1-Install-WSL2.ps1" -StepDescription "Step 1: Installing WSL2"

# Step 2: Install Winget Apps
Invoke-StepScript -ScriptName "Step2-Install-WingetApps.ps1" -StepDescription "Step 2: Installing Winget Apps"

# Step 3: Manual Install Reminders
Invoke-StepScript -ScriptName "Step3-Manual-Install-Reminders.ps1" -StepDescription "Step 3: Manual Install Reminders"

# Step 4: Personalize UI
Invoke-StepScript -ScriptName "Step4-Personalize-UI.ps1" -StepDescription "Step 4: Personalizing Windows 11 UI"

# Step 5: Manage Taskbar and Desktop
Invoke-StepScript -ScriptName "Step5-Manage-Taskbar-Desktop.ps1" -StepDescription "Step 5: Managing Taskbar and Desktop"

# Step 6: Remove Unwanted Apps
Invoke-StepScript -ScriptName "Step6-Remove-Unwanted-Apps.ps1" -StepDescription "Step 6: Removing Unwanted Apps"

# Step 7: Remove System Components
Invoke-StepScript -ScriptName "Step7-Remove-System-Components.ps1" -StepDescription "Step 7: Removing System Components"

# Step 8: System Configuration
Invoke-StepScript -ScriptName "Step8-System-Configuration.ps1" -StepDescription "Step 8: System Configuration"

# Step 9: Create Utility Scripts
Invoke-StepScript -ScriptName "Step9-Create-Utility-Scripts.ps1" -StepDescription "Step 9: Creating Utility Scripts"

# -------------------------------
# Final Summary
# -------------------------------
Write-Host "`n=== ALL SETUP STEPS COMPLETED ===" -ForegroundColor Green
Write-Host "`nYour Windows 11 system has been configured!" -ForegroundColor Cyan
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Reboot your PC to ensure all changes take effect" -ForegroundColor White
Write-Host "2. Check the manual settings mentioned in Step 4" -ForegroundColor White
Write-Host "3. Install any manual apps listed in Step 3" -ForegroundColor White
Write-Host "4. Use the utility scripts created in Step 9 for ongoing management" -ForegroundColor White

Write-Host "`nIf accent color or widgets don't change:" -ForegroundColor Yellow
Write-Host "1. Run the Refresh-WindowsSettings.ps1 script" -ForegroundColor DarkGray
Write-Host "2. Or restart Windows Explorer manually" -ForegroundColor DarkGray
Write-Host "3. Or reboot your computer" -ForegroundColor DarkGray

Write-Host "`nThank you for using the Windows 11 Setup Script!" -ForegroundColor Cyan
Stop-Transcript
Pause
