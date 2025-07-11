param (
    [switch]$TestMode = $false
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
# -------------------------------
# Setup
# -------------------------------
$logFile = ".\Logs\Debloat-Windows-Log.txt"
"[$(Get-Date)] Debloat started (TestMode: $TestMode)" | Out-File -FilePath $logFile -Encoding UTF8

function Remove-App {
    param (
        [string]$AppId,
        [string]$Description
    )

    Write-Host "`nTrying to remove: $Description ($AppId)" -ForegroundColor Cyan

    try {
        if ($TestMode) {
            Write-Host "[TEST MODE] Would remove: $AppId" -ForegroundColor Gray
            Add-Content -Path $logFile -Value "[TEST MODE] Would remove: $Description ($AppId)"
        } else {
            Get-AppxPackage -AllUsers -Name $AppId | Remove-AppxPackage -ErrorAction Stop
            Write-Host "Removed: $AppId" -ForegroundColor Yellow
            Add-Content -Path $logFile -Value "Removed: $Description ($AppId)"
        }
    } catch {
        Write-Host "Error removing: $AppId — $_" -ForegroundColor Red
        Add-Content -Path $logFile -Value "Error removing: $Description ($AppId) — $_"
    }
}

# -------------------------------
# Apps to Remove
# -------------------------------
$appsToRemove = @(
    @{ Id = "Microsoft.XboxGamingOverlay"; Desc = "Xbox Game Bar" },
    @{ Id = "Microsoft.Xbox.TCUI"; Desc = "Xbox TCUI" },
    @{ Id = "Microsoft.XboxGameCallableUI"; Desc = "Xbox Cal lable UI" },
    @{ Id = "Microsoft.XboxSpeechToTextOverlay"; Desc = "Xbox Speech Overlay" },
    @{ Id = "Microsoft.ZuneMusic"; Desc = "Groove Music" },
    @{ Id = "Microsoft.ZuneVideo"; Desc = "Movies & TV" },
    @{ Id = "Microsoft.People"; Desc = "People App" },
    @{ Id = "Microsoft.BingNews"; Desc = "Bing News" },
    @{ Id = "Microsoft.GetHelp"; Desc = "Get Help" },
    @{ Id = "Microsoft.Getstarted"; Desc = "Tips App" },
    @{ Id = "Microsoft.MicrosoftOfficeHub"; Desc = "Office Hub" },
    @{ Id = "Microsoft.MicrosoftSolitaireCollection"; Desc = "Solitaire" },
    @{ Id = "Microsoft.SkypeApp"; Desc = "Skype" },
    @{ Id = "Microsoft.Todos"; Desc = "To Do" },
    @{ Id = "Microsoft.YourPhone"; Desc = "Phone Link" }
)

# -------------------------------
# Run Debloat Process
# -------------------------------
foreach ($app in $appsToRemove) {
    Remove-App -AppId $app.Id -Description $app.Desc
}

# -------------------------------
# Manual Reminder
# -------------------------------
Write-Host "`nGo to Settings > Apps > Installed Apps > Advanced Options to manually remove leftover apps like:" -ForegroundColor Magenta
Write-Host "- Cortana" -ForegroundColor DarkYellow
Write-Host "- Microsoft Teams (Machine-wide)" -ForegroundColor DarkYellow
Write-Host "- Edge / Bing integrations (some cannot be removed)" -ForegroundColor DarkYellow
Write-Host "`nYou can also use tools like O&O AppBuster or ThisIsWin11 for fine-grained control." -ForegroundColor DarkGray

# -------------------------------
# Done
# -------------------------------
$doneMsg = "[$(Get-Date)] Debloat complete."
Write-Host "`n$doneMsg" -ForegroundColor Green
Add-Content -Path $logFile -Value $doneMsg
Pause
