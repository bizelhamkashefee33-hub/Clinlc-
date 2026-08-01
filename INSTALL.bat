@echo off
REM 🚀 MASTAN CLINIC FACTORY - Windows Installation Script
REM برای سیستم‌های Windows (CMD)

echo =========================================================
echo 🧠 MASTAN AI FACTORY - Windows Setup
echo =========================================================
echo.

echo Checking Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js not found!
    echo Download from: https://nodejs.org/
    pause
    exit /b 1
)
echo OK: Node.js found

echo Checking Docker...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker not found!
    echo Download from: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)
echo OK: Docker found

echo.
echo Installing dependencies...
call npm install

echo.
echo =========================================================
echo OK: Setup Complete!
echo =========================================================
echo.
echo Next Steps:
echo.
echo 1. Start Docker Services:
echo    docker-compose up -d
echo.
echo 2. Access Applications:
echo    Frontend:  http://localhost:5173
echo    Backend:   http://localhost:3000/api/health
echo.
echo 3. View Logs:
echo    docker-compose logs -f
echo.
echo Happy coding! 🚀
echo.
pause
