param (
    [switch]$TestMode = $false
)

Write-Host "=== Step 7: Removing System Components ===" -ForegroundColor Cyan
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

