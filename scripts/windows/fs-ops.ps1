# fs-ops.ps1 - Windows filesystem operations demo.
# Chains: create -> list -> copy -> move -> symlink -> change permissions -> delete.
# Demonstrates the OS-specific commands for the CLI task on Windows.
# Run from the repo root:  .\scripts\windows\fs-ops.ps1

$ErrorActionPreference = "Stop"

$work = Join-Path $PSScriptRoot "..\..\build\fs-demo"

Write-Host "== 1. Create a working directory and a file ==" -ForegroundColor Cyan
New-Item -ItemType Directory -Path $work -Force | Out-Null
"hello from windows" | Set-Content (Join-Path $work "original.txt")

Write-Host "== 2. List directory contents ==" -ForegroundColor Cyan
Get-ChildItem $work

Write-Host "== 3. Copy the file ==" -ForegroundColor Cyan
Copy-Item (Join-Path $work "original.txt") (Join-Path $work "copy.txt")

Write-Host "== 4. Move (rename) the copy ==" -ForegroundColor Cyan
Move-Item (Join-Path $work "copy.txt") (Join-Path $work "moved.txt")

Write-Host "== 5. Create a link ==" -ForegroundColor Cyan
# NOTE: On Windows a *symbolic* link (New-Item -ItemType SymbolicLink) needs an
# elevated/Administrator shell or Developer Mode enabled. A *hard* link does not,
# so we use one here to keep the script runnable for everyone.
$link = Join-Path $work "link-to-original.txt"
if (Test-Path $link) { Remove-Item $link }
New-Item -ItemType HardLink -Path $link -Target (Join-Path $work "original.txt") | Out-Null

Write-Host "== 6. Change permissions (read-only for Users via icacls) ==" -ForegroundColor Cyan
icacls (Join-Path $work "original.txt") /grant:r "Users:(R)"

Write-Host "== 7. Final listing, then clean up ==" -ForegroundColor Cyan
Get-ChildItem $work
Remove-Item $work -Recurse -Force
Write-Host "Cleaned up $work" -ForegroundColor Green
