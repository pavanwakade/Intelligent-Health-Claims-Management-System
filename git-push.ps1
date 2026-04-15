# IHCMS Git Push Script
# Double-click or run in PowerShell

Set-Location "C:\Users\Pawan\Desktop\IHCMS"

Write-Host "`n=== Step 1: Setting Git Identity ===" -ForegroundColor Cyan
git config user.name "pavan wakde"
git config user.email "pavanwakade199@gmail.com"
Write-Host "Identity set." -ForegroundColor Green

Write-Host "`n=== Step 2: Staging All Files ===" -ForegroundColor Cyan
git add .
Write-Host "Staged." -ForegroundColor Green

Write-Host "`n=== Step 3: Committing ===" -ForegroundColor Cyan
git commit -m "Add HCMS blueprint with process dashboard and GitHub Actions automation"

Write-Host "`n=== Step 4: Setting Remote ===" -ForegroundColor Cyan
$existing = git remote get-url origin 2>$null
if ($existing) {
    git remote set-url origin https://github.com/pavanwakade/Intelligent-Health-Claims-Management-System.git
    Write-Host "Remote URL updated." -ForegroundColor Green
} else {
    git remote add origin https://github.com/pavanwakade/Intelligent-Health-Claims-Management-System.git
    Write-Host "Remote added." -ForegroundColor Green
}

Write-Host "`n=== Step 5: Pushing to GitHub ===" -ForegroundColor Cyan
git branch -M main
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n SUCCESS! Code is now live on GitHub." -ForegroundColor Green
    Write-Host "View at: https://github.com/pavanwakade/Intelligent-Health-Claims-Management-System" -ForegroundColor Cyan
} else {
    Write-Host "`n Push failed. Try authenticating via GitHub CLI or Personal Access Token." -ForegroundColor Red
}

Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
