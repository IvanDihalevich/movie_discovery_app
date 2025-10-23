# Movie Discovery App - Git Setup Script for GitHub Repository
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Movie Discovery App - Git Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Git is installed
Write-Host "Checking if Git is installed..." -ForegroundColor Yellow
try {
    $gitVersion = git --version
    Write-Host "Git is installed: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Git is not installed!" -ForegroundColor Red
    Write-Host "Please install Git from: https://git-scm.com/download/win" -ForegroundColor Red
    Write-Host "Then run this script again." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Initializing Git repository..." -ForegroundColor Yellow
git init

Write-Host ""
Write-Host "Adding files to Git..." -ForegroundColor Yellow
git add .

Write-Host ""
Write-Host "Making initial commit..." -ForegroundColor Yellow
git commit -m "Initial commit: Movie Discovery App with Clean Architecture"

Write-Host ""
Write-Host "Connecting to GitHub repository..." -ForegroundColor Yellow
git remote add origin https://github.com/IvanDihalevich/movie_discovery_app.git

Write-Host ""
Write-Host "Setting up main branch..." -ForegroundColor Yellow
git branch -M main

Write-Host ""
Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
git push -u origin main

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host " Successfully pushed to GitHub!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your repository is now available at:" -ForegroundColor Cyan
Write-Host "https://github.com/IvanDihalevich/movie_discovery_app" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Get TMDB API key (see API_SETUP.md)" -ForegroundColor White
Write-Host "2. Install Flutter SDK (see SETUP_INSTRUCTIONS.md)" -ForegroundColor White
Write-Host "3. Run the app: flutter run" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to exit"
