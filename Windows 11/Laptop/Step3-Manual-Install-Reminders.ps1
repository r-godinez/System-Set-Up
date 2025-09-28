param (
    [switch]$TestMode = $false
)

Write-Host "=== Step 3: Manual Install Reminders ===" -ForegroundColor Magenta
Pause

$manualOnlyApps = @(
    @{ Name = "Spotify"; Url = "https://www.spotify.com/download/windows/" },
    @{ Name = "CherryTree"; Url = "https://www.giuspen.com/cherrytree/" }
)

foreach ($app in $manualOnlyApps) {
    Write-Host "* $($app.Name)" -ForegroundColor DarkYellow
    Write-Host "  - $($app.Url)" -ForegroundColor DarkGray
}

Write-Host "`nYou can install these apps manually via the links above." -ForegroundColor DarkGray

Write-Host "`n--- Manual Install Reminders Complete ---" -ForegroundColor Green

