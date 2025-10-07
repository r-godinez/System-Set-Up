param (
    [switch]$TestMode = $false
)

Write-Host "=== Step 2: Install Winget Apps ===" -ForegroundColor Cyan
Pause

# Function to check if winget is available and install if needed
function Install-WingetIfNeeded {
    try {
        $wingetVersion = winget --version 2>$null
        if ($wingetVersion) {
            Write-Host "[SUCCESS] Winget is available: $wingetVersion" -ForegroundColor Green
            return $true
        }
    }
    catch {
        Write-Host "[INFO] Winget is not installed. Installing winget..." -ForegroundColor Yellow
    }
    
    # Install winget via App Installer
    try {
        if ($TestMode) {
            Write-Host "[TEST MODE] Would install winget via App Installer" -ForegroundColor Gray
            return $true
        } else {
            Write-Host "Downloading and installing App Installer (includes winget)..." -ForegroundColor Yellow
            
            # Download App Installer from Microsoft
            $appInstallerUrl = "https://aka.ms/getwinget"
            $tempPath = "$env:TEMP\Microsoft.DesktopAppInstaller.msixbundle"
            
            Write-Host "Downloading from: $appInstallerUrl" -ForegroundColor DarkGray
            Invoke-WebRequest -Uri $appInstallerUrl -OutFile $tempPath -UseBasicParsing
            
            # Install App Installer
            Write-Host "Installing App Installer..." -ForegroundColor Yellow
            Add-AppxPackage -Path $tempPath -ForceApplicationShutdown
            
            # Clean up
            Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
            
            # Wait a moment and verify installation
            Start-Sleep -Seconds 5
            $wingetVersion = winget --version 2>$null
            if ($wingetVersion) {
                Write-Host "[SUCCESS] Winget installed successfully: $wingetVersion" -ForegroundColor Green
                return $true
            } else {
                Write-Host "[ERROR] Winget installation failed. Please install manually from Microsoft Store." -ForegroundColor Red
                return $false
            }
        }
    }
    catch {
        Write-Host "[ERROR] Failed to install winget: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Please install App Installer from Microsoft Store manually." -ForegroundColor Yellow
        return $false
    }
    
    return $false
}

# Function to check if app is available on winget
function Test-AppAvailableOnWinget {
    param([string]$AppId)
    
    try {
        $searchResult = winget search --id $AppId --exact 2>$null
        if ($LASTEXITCODE -eq 0 -and $searchResult -match $AppId) {
            return $true
        }
        return $false
    }
    catch {
        return $false
    }
}

# Function to refresh winget sources
function Update-WingetSources {
    try {
        Write-Host "Updating winget sources..." -ForegroundColor Yellow
        winget source update 2>$null
        Write-Host "[SUCCESS] Winget sources updated" -ForegroundColor Green
    }
    catch {
        Write-Host "[WARNING] Could not update winget sources: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# Function to install app with winget source check
function Install-WingetApp {
    param(
        [string]$AppId,
        [string]$AppName = $AppId,
        [int]$MaxRetries = 3
    )
    
    # Check if app is available on winget
    if (-not (Test-AppAvailableOnWinget -AppId $AppId)) {
        Write-Host "[SKIP] $AppName ($AppId) - App ID doesn't have source from winget" -ForegroundColor Yellow
        return $false
    }
    
    for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
        try {
            if ($TestMode) {
                Write-Host "[TEST MODE] Would install: $AppName ($AppId)" -ForegroundColor Gray
                return $true
            } else {
                Write-Host "Installing $AppName (attempt $attempt/$MaxRetries)..." -ForegroundColor Yellow
                
                # Use --silent flag for better automation
                winget install --id $AppId --accept-package-agreements --accept-source-agreements --silent 2>&1 | Out-Null
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "[SUCCESS] Installed $AppName" -ForegroundColor Green
                    return $true
                } else {
                    Write-Host "[WARNING] Installation attempt $attempt failed for $AppName" -ForegroundColor Yellow
                    if ($attempt -lt $MaxRetries) {
                        Write-Host "Retrying in 5 seconds..." -ForegroundColor DarkGray
                        Start-Sleep -Seconds 5
                    }
                }
            }
        }
        catch {
            Write-Host "[ERROR] Failed to install $AppName : $($_.Exception.Message)" -ForegroundColor Red
            if ($attempt -lt $MaxRetries) {
                Write-Host "Retrying in 5 seconds..." -ForegroundColor DarkGray
                Start-Sleep -Seconds 5
            }
        }
    }
    
    Write-Host "[FAILED] Could not install $AppName after $MaxRetries attempts" -ForegroundColor Red
    return $false
}

# Install winget if needed
if (-not (Install-WingetIfNeeded)) {
    Write-Host "[ERROR] Cannot proceed without winget. Continuing with other setup steps..." -ForegroundColor Red
} else {
    # Update winget sources for latest packages
    Update-WingetSources
    
    # Define apps to install with friendly names
    $appsToInstall = @(
        @{ Id = "Microsoft.OneDrive"; Name = "OneDrive" },
        @{ Id = "Google.GoogleDrive"; Name = "Google Drive" },
        @{ Id = "Apple.iTunes"; Name = "iTunes" },
        @{ Id = "Proton.ProtonVPN"; Name = "ProtonVPN" },
        @{ Id = "Bitwarden.Bitwarden"; Name = "Bitwarden Password Manager" },
        @{ Id = "GIMP.GIMP.3"; Name = "GIMP Photo Editor" },
        @{ Id = "Docker.DockerDesktop"; Name = "Docker Desktop" },
        @{ Id = "Docker.DockerCompose"; Name = "Docker Compose" },
        @{ Id = "Docker.DockerCLI"; Name = "Docker CLI" },
        @{ Id = "Git.Git"; Name = "Git" },
        @{ Id = "GitHub.GitHubDesktop"; Name = "GitHub Desktop" },
        @{ Id = "Hashicorp.Terraform"; Name = "Terraform" },
        @{ Id = "GoLang.Go"; Name = "Go Programming Language" },
        @{ Id = "Microsoft.PowerShell"; Name = "PowerShell" },
        @{ Id = "Brave.Brave"; Name = "Brave Browser" },
        @{ Id = "Google.Chrome"; Name = "Google Chrome" },
        @{ Id = "TheDocumentFoundation.LibreOffice"; Name = "LibreOffice" },
        @{ Id = "Discord.Discord"; Name = "Discord" },
        @{ Id = "Logitech.OptionsPlus"; Name = "Logitech Options Plus" },
        @{ Id = "Greenshot.Greenshot"; Name = "Greenshot Screenshot Tool" },
        @{ Id = "Microsoft.VisualStudioCode"; Name = "Visual Studio Code" },
        @{ Id = "Anysphere.Cursor"; Name = "Cursor IDE" },
        @{ Id = "Mobatek.MobaXterm"; Name = "MobaXterm SSH Client" },
        @{ Id = "Microsoft.WindowsTerminal"; Name = "Windows Terminal" },
        @{ Id = "Notion.Notion"; Name = "Notion" },
        @{ Id = "REALiX.HWiNFO"; Name = "HWiNFO Hardware Info" },
        @{ Id = "9WZDNCRFJ4MV"; Name = "Lenovo Vantage" },
        @{ Id = "Malwarebytes.Malwarebytes"; Name = "Malwarebytes Antivirus" },
        @{ Id = "Piriform.CCleaner"; Name = "CCleaner" },
        @{ Id = "JGraph.Draw"; Name = "Draw.io" },
        @{ Id = "RaspberryPiFoundation.RaspberryPiImager"; Name = "Raspberry Pi Imager" },
        @{ Id = "OpenVPNTechnologies.OpenVPN"; Name = "OpenVPN" },
        @{ Id = "Python.Python.3.12"; Name = "Python Interpreter" }
    )
    
    Write-Host "`n--- Installing $($appsToInstall.Count) applications via winget ---" -ForegroundColor Yellow
    
    $successCount = 0
    $skippedApps = @()
    
    foreach ($app in $appsToInstall) {
        $result = Install-WingetApp -AppId $app.Id -AppName $app.Name
        
        if ($result) {
            $successCount++
        } else {
            $skippedApps += $app.Name
        }
        Write-Host "" # Add spacing between installations
    }
    
    # Installation summary
    Write-Host "`n--- Winget Installation Summary ---" -ForegroundColor Cyan
    Write-Host "Successfully installed: $successCount applications" -ForegroundColor Green
    
    if ($skippedApps.Count -gt 0) {
        Write-Host "`nSkipped (not available on winget):" -ForegroundColor Yellow
        foreach ($skippedApp in $skippedApps) {
            Write-Host "  - $skippedApp" -ForegroundColor Yellow
        }
        Write-Host "`nYou can manually change these to winget-compatible sources and re-run the script." -ForegroundColor DarkGray
    }
}

Write-Host "`n--- Winget Installation Complete ---" -ForegroundColor Green

