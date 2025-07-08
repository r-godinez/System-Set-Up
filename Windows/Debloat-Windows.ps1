[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

param (
    [switch]$TestMode = $false
)

$logFile = "$PSScriptRoot\Debloat-Log.txt"
"[$(Get-Date)] Starting debloat process..." | Out-File -FilePath $logFile -Encoding UTF8

function Remove-App {
    param([string]$AppId, [string]$Description)

    if ($TestMode) {
        Write-Host "[TEST MODE] Would remove: $Description ($AppId)" -ForegroundColor Gray
        "Would remove: $Description ($AppId)" | Out-File -Append -FilePath $logFile
    } else {
        Write-Host "Removing: $Description..." -ForegroundColor Yellow
        try {
            Get-AppxPackage $AppId | Remove-AppxPackage -ErrorAction Stop
            "Removed: $Description ($AppId)" | Out-File -Append -FilePath $logFile
        } catch {
            "Failed to remove: $Description ($AppId) — $_" | Out-File -Append -FilePath $logFile
        }
    }
}

# -------------------------------
# Apps to Remove
# -------------------------------
$appsToRemove = @(
    @{ Id="Microsoft.XboxGamingOverlay"; Desc="Xbox Game Bar" },
    @{ Id="Microsoft.BingNews"; Desc="Microsoft News" },
    @{ Id="Microsoft.BingWeather"; Desc="Microsoft Weather" },
    @{ Id="Microsoft.ZuneMusic"; Desc="Groove Music" },
    @{ Id="Microsoft.ZuneVideo"; Desc="Movies & TV" },
    @{ Id="Microsoft.549981C3F5F10"; Desc="Cortana" },
    @{ Id="MicrosoftTeams"; Desc="Teams (consumer)" },
    @{ Id="Clipchamp.Clipchamp"; Desc="Clipchamp Video Editor" },
    @{ Id="king.com.CandyCrushSaga"; Desc="Candy Crush" },
    @{ Id="Microsoft.MicrosoftSolitaireCollection"; Desc="Solitaire Collection" },
    @{ Id="Microsoft.Todos"; Desc="Microsoft To-Do" },
    @{ Id="Microsoft.GetHelp"; Desc="Get Help" },
    @{ Id="Microsoft.People"; Desc="People App" }
)

# -------------------------------
# Remove Bloatware
# -------------------------------
Write-Host "`n=== Removing Bloatware ===" -ForegroundColor Cyan

foreach ($app in $appsToRemove) {
    Remove-App -AppId $app.Id -Description $app.Desc
}

# -------------------------------
# Disable Background Apps (manually for now)
# -------------------------------
Write-Host "`n=== Recommendation: Disable background apps manually ===" -ForegroundColor Cyan
Write-Host "Go to Settings > Apps > Installed Apps > Advanced options, set background permission to 'Never'." -ForegroundColor Gray
"Manual step: Disable background apps via Settings." | Out-File -Append -FilePath $logFile

# -------------------------------
# Done
# -------------------------------
Write-Host "`n✅ Debloat complete. You may want to reboot your PC." -ForegroundColor Green
"[$(Get-Date)] Debloat complete." | Out-File -Append -FilePath $logFile
