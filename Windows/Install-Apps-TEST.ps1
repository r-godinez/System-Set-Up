[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Install-AllApps.ps1
# This script restores apps from winget-apps.json and installs additional winget apps found in your system list.

# -------------------------------
# Configuration
# -------------------------------
$wingetJson = ".\winget-apps.json"

# -------------------------------
# STEP 1: Import exported winget apps
# -------------------------------
Write-Host "`n=== Step 1: Installing apps from winget-apps.json ===" -ForegroundColor Cyan

if (Test-Path $wingetJson) {
    # winget import -i $wingetJson --accept-package-agreements --accept-source-agreements
    Write-Host "[TEST MODE] Would import apps from: $wingetJson" -ForegroundColor Gray
} else {
    Write-Host "ERROR: winget-apps.json not found!" -ForegroundColor Red
    exit 1
}

# -------------------------------
# STEP 2: Install additional apps from winget list
# (These were NOT included in the exported JSON)
# -------------------------------
Write-Host "`n=== Step 2: Installing extra apps manually from winget list ===" -ForegroundColor Cyan

$manualApps = @(
    "Microsoft.Office",
    "Microsoft.OneDrive",
    "Mozilla.Firefox",
    "Google.Chrome",
    "Google.GoogleDrive",
    "Logitech.OptionsPlus",
    "VideoLAN.VLC",
    "Nvidia.PhysX",
    "Giuspen.Cherrytree",
    "Valve.Steam",
    "Ubisoft.Connect",
    "KDE.digiKam",
    "Mobatek.MobaXterm",
    "GOG.Galaxy",
    "EpicGames.EpicGamesLauncher",
    "ElectronicArts.EADesktop",
    "Doist.Todoist",
    "Notion.Notion",
    "Discord.Discord",
    "RaspberryPiFoundation.RaspberryPiImager",
    "Zoom.Zoom.EXE",
    "Microsoft.VisualStudioCode",
    "Python.Python.3.12"
)

foreach ($app in $manualApps) {
    Write-Host "Installing $app..." -ForegroundColor Yellow
    # winget install --id $app --accept-package-agreements
    Write-Host "[TEST MODE] Would install: $app" -ForegroundColor Gray

}

# -------------------------------
# STEP 3: Reminder for manual installs
# -------------------------------
Write-Host "`n=== Step 3: Manual installs required for the following apps ===" -ForegroundColor Magenta

$manualOnlyApps = @(
    "GIGABYTE SSD Firmware Update Tool",
    "GIGABYTE Performance Library",
    "GIGABYTE Storage Library",
    "Razer Synapse",
    "Razer Axon",
    "Intel Serial IO / Chipset",
    "NVIDIA Graphics Driver / App / Control Panel",
    "Realtek Audio Driver / Control",
    "Realtek Ethernet Controller",
    "Samsung Magician",
    "Corsair Device Control Service",
    "iTunes (MSIX)",
    "Malwarebytes (MSIX)",
    "AV1, MPEG2, HEIF Extensions (MSIX)",
    "Spotify (MSIX)"
)

foreach ($app in $manualOnlyApps) {
    Write-Host "* $app" -ForegroundColor DarkYellow
}

Write-Host "`nYou can reinstall these apps manually via: vendor websites or Microsoft Store." -ForegroundColor DarkGray

# -------------------------------
# STEP 4: Done
# -------------------------------
Write-Host "`n=== All Done! Reboot your PC and enjoy your setup. ===" -ForegroundColor Green
