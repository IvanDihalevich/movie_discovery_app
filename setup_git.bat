@echo off
echo ========================================
echo  Movie Discovery App - Git Setup
echo ========================================
echo.

echo Checking if Git is installed...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Git is not installed!
    echo Please install Git from: https://git-scm.com/download/win
    echo Then run this script again.
    pause
    exit /b 1
)

echo Git is installed. Proceeding with setup...
echo.

echo Initializing Git repository...
git init

echo.
echo Adding files to Git...
git add .

echo.
echo Making initial commit...
git commit -m "Initial commit: Movie Discovery App with Clean Architecture"

echo.
echo Connecting to GitHub repository...
git remote add origin https://github.com/IvanDihalevich/movie_discovery_app.git

echo.
echo Setting up main branch...
git branch -M main

echo.
echo Pushing to GitHub...
git push -u origin main

echo.
echo ========================================
echo  Successfully pushed to GitHub!
echo ========================================
echo.
echo Your repository is now available at:
echo https://github.com/IvanDihalevich/movie_discovery_app
echo.
echo Next steps:
echo 1. Get TMDB API key (see API_SETUP.md)
echo 2. Install Flutter SDK (see SETUP_INSTRUCTIONS.md)
echo 3. Run the app: flutter run
echo.
pause
