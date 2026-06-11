# run-parallel.ps1 - Run several tasks in parallel on Windows using background jobs.
# Demonstrates Start-Job / Wait-Job / Receive-Job to fan out work and collect results.
# Run from the repo root:  .\scripts\windows\run-parallel.ps1

$ErrorActionPreference = "Stop"

Write-Host "== Starting 3 workers in parallel ==" -ForegroundColor Cyan

$workers = 1..3 | ForEach-Object {
    $id = $_
    Start-Job -Name "worker-$id" -ScriptBlock {
        param($n)
        Start-Sleep -Seconds $n          # simulate uneven work
        "worker-$n finished after ${n}s"
    } -ArgumentList $id
}

Write-Host "Jobs launched: $($workers.Name -join ', ')"

Write-Host "`n== Waiting for all workers to finish ==" -ForegroundColor Cyan
$workers | Wait-Job | Out-Null

Write-Host "`n== Results (note: order reflects completion, not launch) ==" -ForegroundColor Cyan
$workers | ForEach-Object { Receive-Job $_ }

$workers | Remove-Job
Write-Host "`n== All parallel work complete ==" -ForegroundColor Green
