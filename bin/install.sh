#!/bin/bash

# Navigate to the home directory
cd $HOME

# Create a temporary folder
mkdir temp_____

# Navigate into the temporary folder
cd temp_____

# Remove any previous francinette directory
rm -r -fo francinette

# Download francinette from GitHub
git clone --recursive https://github.com/xicodomingues/francinette.git

# Install compilers and tools for Windows using Chocolatey (choco)
if ($env:OS -ne "Windows_NT") {
    echo "Administrator permissions needed to install C compilers, Python, and update current packages"
    Start-Process powershell -Verb runAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command "choco upgrade all; choco install mingw make -y; choco install python -y"'
}

# Copy the francinette folder to the home directory
Copy-Item -Recurse francinette "$HOME"

# Clean up the temporary folder
cd $HOME
Remove-Item -Recurse -Force temp_____

# Navigate to the francinette directory
cd "$HOME/francinette"

# Set up a Python virtual environment
if (!(python -m venv venv)) {
    echo "Please ensure that you can create a Python virtual environment."
    echo "Contact me if you have no idea how to proceed (fsoares- on Slack)"
    exit 1
}

# Activate the virtual environment
. ./venv/Scripts/Activate.ps1

# Install Python requirements
if (!(pip install -r requirements.txt)) {
    echo "Problem launching the installer. Contact me (fsoares- on Slack)"
    exit 1
}

# Set up the PowerShell profile for aliases
$profilePath = "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

if (!(Test-Path $profilePath)) {
    New-Item -Path $profilePath -ItemType File -Force
}

# Add francinette alias to the profile
if (-not (Get-Content $profilePath | Select-String "francinette=")) {
    Add-Content $profilePath "`nalias francinette='$HOME/francinette/tester.ps1'"
}

# Add paco alias to the profile
if (-not (Get-Content $profilePath | Select-String "paco=")) {
    Add-Content $profilePath "`nalias paco='$HOME/francinette/tester.ps1'"
}

# Load the updated profile
& $profilePath

# Print help for francinette
& "$HOME/francinette/tester.ps1" --help

Write-Host "... and don't forget, paco is not a replacement for your own tests!" -ForegroundColor Yellow
