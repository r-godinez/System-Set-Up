param (
    [switch]$TestMode = $false
)

Write-Host "=== Step 4: Personalizing Windows 11 UI ===" -ForegroundColor Cyan
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
