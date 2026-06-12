# disk-report.ps1 - Quick directory size report for Windows.
# Lists the top-level entries of a folder with their sizes, largest first.
# Run from the repo root:  .\scripts\windows\disk-report.ps1 [path]

param(
    [string]$Target = "."
)

$ErrorActionPreference = "Stop"

Write-Host "== Directory report for: $((Resolve-Path $Target).Path) ==" -ForegroundColor Cyan

Get-ChildItem -Path $Target | ForEach-Object {
    $size = if ($_.PSIsContainer) {
        (Get-ChildItem $_.FullName -Recurse -File -ErrorAction SilentlyContinue |
            Measure-Object -Property Length -Sum).Sum
    } else {
        $_.Length
    }
    [PSCustomObject]@{
        Name   = $_.Name
        Type   = if ($_.PSIsContainer) { "dir" } else { "file" }
        SizeKB = [math]::Round(($size / 1KB), 1)
    }
} | Sort-Object SizeKB -Descending | Format-Table -AutoSize
