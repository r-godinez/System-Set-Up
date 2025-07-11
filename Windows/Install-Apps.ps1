param (
    [switch]$TestMode = $false
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8


# -------------------------------
# Setup
# -------------------------------
$logFile = ".\Logs\InstallApps-Log.txt"
Start-Transcript -Path $logFile -Append


Write-Host "=== System Reinstall Setup ===" -ForegroundColor Cyan

if ($TestMode) {
    Write-Host "Test mode is ENABLED (apps will NOT be installed)" -ForegroundColor Yellow
} else {
    Write-Host "Test mode is DISABLED (apps WILL be installed)" -ForegroundColor Yellow
}

Write-Host "Logging to: $logFile" -ForegroundColor DarkGray
Pause

# -------------------------------
# Step 1: winget import
# -------------------------------
$wingetJson = ".\winget-apps.json"
Write-Host "`n=== Step 1: Install apps from winget-apps.json ===" -ForegroundColor Cyan
Pause

if (Test-Path $wingetJson) {
    if ($TestMode) {
        Write-Host "[TEST MODE] Would import apps from: $wingetJson" -ForegroundColor Gray
    } else {
        winget import -i $wingetJson --accept-package-agreements --accept-source-agreements
    }
} else {
    Write-Host "ERROR: winget-apps.json not found!" -ForegroundColor Red
    Stop-Transcript
    exit 1
}

# -------------------------------
# Step 2: Install individual apps
# -------------------------------
Write-Host "`n=== Step 2: Install additional Winget apps ===" -ForegroundColor Cyan
Pause

$manualApps = @(
    "Microsoft.OneDrive",
    "Apple.iTunes",
    "Spotify.Spotify", # can't be ran as admin
    "RazerInc.RazerInstaller.Synapse4", # can't be ran as admin
    "Intel.IntelDriverAndSupportAssistant",
    "GIGABYTE.BIOS"
    "Corsair.iCUE.5",
    "Guru3D.Afterburner",
    "REALiX.HWiNFO",
    # Nvidia Control Panel
    "9NF8H0H7WMLT",
    # Developer Tools
    "Docker.DockerDesktop",
    "Docker.DockerCompose",
    "Docker.DockerCLI",
    "Git.Git",
    "GitHub.GitHubDesktop",
    "Hashicorp.Terraform",
    "GoLang.Go",
"Microsoft.PowerShell"
# add cherrytree and logi+ and chrome, failed in json file
)

foreach ($app in $manualApps) {
    if ($TestMode) {
        Write-Host "[TEST MODE] Would install: $app" -ForegroundColor Gray
    } else {
        Write-Host "Installing $app..." -ForegroundColor Yellow
        winget install --id $app --accept-package-agreements --accept-source-agreements -e
    }
}

# -------------------------------
# Step 3: Manual install reminders
# -------------------------------
Write-Host "`n=== Step 3: Manual installs required ===" -ForegroundColor Magenta
Pause

$manualOnlyApps = @(
    @{ Name = "GIGABYTE SSD Firmware Update Tool"; Url = "https://www.gigabyte.com/Support/Utility" },
    @{ Name = "Intel Serial IO / Chipset"; Url = "https://www.intel.com/content/www/us/en/download-center/home.html" },
    @{ Name = "Samsung Magician"; Url = "https://semiconductor.samsung.com/consumer-storage/magician/" }
)

foreach ($app in $manualOnlyApps) {
    Write-Host "* $($app.Name)" -ForegroundColor DarkYellow
    Write-Host "  - $($app.Url)" -ForegroundColor DarkGray
}

Write-Host "`nYou can reinstall these apps manually via the links above." -ForegroundColor DarkGray

# -------------------------------
# Step 4: Done
# -------------------------------
Write-Host "`n=== All Done! Reboot your PC and enjoy your setup. ===" -ForegroundColor Green
Stop-Transcript
Pause
