# Template Script

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

param (
    [switch]$TestMode = $true
)

# -------------------------------
# Setup
# -------------------------------
$logFile = ".\InstallApps-Log.txt"
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
$wingetJson = "PATH-TO-WINGET.JSON"
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

# Add --id for winget app you want to install
$manualApps = @(
    "Microsoft.Office",
    "Mozilla.Firefox",
    "Google.Chrome"
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

# Add apps not found on winget
$manualOnlyApps = @(
    @{ Name = "GIGABYTE SSD Firmware Update Tool"; Url = "https://www.gigabyte.com/Support/Utility" },
    @{ Name = "GIGABYTE Performance Library"; Url = "https://www.gigabyte.com/MicroSite/185/download/utility_easytune.htm" },
    @{ Name = "GIGABYTE Storage Library"; Url = "https://www.gigabyte.com/MicroSite/185/download/utility_sataraid.htm" },
    @{ Name = "Razer Axon"; Url = "https://www.razer.com/axon" },
    @{ Name = "Intel Serial IO / Chipset"; Url = "https://www.intel.com/content/www/us/en/download-center/home.html" },
    @{ Name = "Realtek Audio Driver / Control"; Url = "https://www.realtek.com/en/component/zoo/category/pc-audio-codecs-high-definition-audio-codecs-software" },
    @{ Name = "Realtek Ethernet Controller"; Url = "https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software" },
    @{ Name = "Samsung Magician"; Url = "https://semiconductor.samsung.com/consumer-storage/magician/" },
    @{ Name = "Corsair Device Control Service"; Url = "https://www.corsair.com/us/en/icue" },
    @{ Name = "AV1, MPEG2, HEIF Extensions (MSIX)"; Url = "https://apps.microsoft.com" }
)

# Displays apps alongside their corresponding URL
foreach ($app in $manualOnlyApps) {
    Write-Host "* $($app.Name)" -ForegroundColor DarkYellow
    Write-Host "  ↳ $($app.Url)" -ForegroundColor DarkGray
}

Write-Host "`nYou can reinstall these apps manually via the links above." -ForegroundColor DarkGray

# -------------------------------
# Step 4: Done
# -------------------------------
Write-Host "`n=== All Done! Reboot your PC and enjoy your setup. ===" -ForegroundColor Green
Stop-Transcript
Pause
