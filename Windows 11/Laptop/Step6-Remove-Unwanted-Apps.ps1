param (
    [switch]$TestMode = $false
)

Write-Host "=== Step 6: Removing Unwanted Apps ===" -ForegroundColor Cyan
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

