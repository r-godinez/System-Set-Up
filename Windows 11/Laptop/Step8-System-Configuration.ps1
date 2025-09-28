param (
    [switch]$TestMode = $false
)

Write-Host "=== Step 8: System Configuration ===" -ForegroundColor Cyan
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

Write-Host "`n--- Renaming Current User Account to 'rgodinez' ---" -ForegroundColor Yellow

if ($TestMode) {
    Write-Host "[TEST MODE] Would rename current user account to 'rgodinez'" -ForegroundColor Gray
} else {
    try {
        # Get current user
        $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Split('\')[1]
        Write-Host "Current user: $currentUser" -ForegroundColor Cyan
        
        # Check if target name already exists
        $userExists = Get-LocalUser -Name "rgodinez" -ErrorAction SilentlyContinue
        if ($userExists) {
            Write-Host "User 'rgodinez' already exists. Skipping rename." -ForegroundColor Yellow
        } else {
            # Rename the current user account
            if ($currentUser -ne "rgodinez") {
                Rename-LocalUser -Name $currentUser -NewName "rgodinez"
                Write-Host "[SUCCESS] User account renamed from '$currentUser' to 'rgodinez'" -ForegroundColor Green
                Write-Host "Note: You will need to log out and back in for the change to take full effect" -ForegroundColor Yellow
            } else {
                Write-Host "Current user is already named 'rgodinez'" -ForegroundColor Yellow
            }
        }
    }
    catch {
        Write-Host "[ERROR] Failed to rename user account: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "You may need to run this script as Administrator to rename user accounts" -ForegroundColor Yellow
    }
}

Write-Host "`n--- System Configuration Complete ---" -ForegroundColor Green

