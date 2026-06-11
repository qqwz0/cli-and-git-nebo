# setup-env.ps1 - Windows environment setup for the todo app.
# Chains several routine operations: check tools -> install deps -> prepare folders.
# Run from the repo root:  .\scripts\windows\setup-env.ps1

$ErrorActionPreference = "Stop"

Write-Host "== 1. Checking required tools ==" -ForegroundColor Cyan
node --version
npm --version

Write-Host "`n== 2. Installing project dependencies ==" -ForegroundColor Cyan
npm install

Write-Host "`n== 3. Preparing runtime folders ==" -ForegroundColor Cyan
$buildDir = Join-Path $PSScriptRoot "..\..\build"
if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir | Out-Null
    Write-Host "Created $buildDir"
} else {
    Write-Host "$buildDir already exists"
}

Write-Host "`n== 4. Environment ready. Start the app with: npm start ==" -ForegroundColor Green
