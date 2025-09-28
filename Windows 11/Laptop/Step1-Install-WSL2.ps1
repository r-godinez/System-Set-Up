param (
    [switch]$TestMode = $false
)

Write-Host "=== Step 1: Installing WSL2 ===" -ForegroundColor Cyan
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

