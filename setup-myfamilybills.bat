@echo off
REM MyFamilyBills Docker Compose Launcher Script for Windows
REM This script downloads the latest Docker images and launches the application using Docker Compose

echo.
echo 🚀 MyFamilyBills Docker Launcher
echo ================================

REM Configuration
set BACKEND_CONTAINER=backend
set FRONTEND_CONTAINER=frontend
set COMPOSE_FILE=docker-compose.yml

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

echo ✅ Docker is running

REM Check if docker-compose is available
docker-compose --version >nul 2>&1
if errorlevel 1 (
    docker compose version >nul 2>&1
    if errorlevel 1 (
        echo ❌ Docker Compose is not available. Please install Docker Compose.
        pause
        exit /b 1
    ) else (
        set DOCKER_COMPOSE=docker compose
    )
) else (
    set DOCKER_COMPOSE=docker-compose
)

echo ✅ Docker Compose is available

REM Download docker-compose.yml if it doesn't exist
if not exist "%COMPOSE_FILE%" (
    echo.
    echo 📥 Downloading docker-compose.yml...
    curl -sSL https://raw.githubusercontent.com/aikeymouse/myfamilybills/main/docker-compose.yml -o docker-compose.yml
    if errorlevel 1 (
        echo ❌ Failed to download docker-compose.yml
        pause
        exit /b 1
    )
    echo ✅ docker-compose.yml downloaded
)

REM Stop and remove existing containers if they exist
echo.
echo 🧹 Cleaning up existing containers...
%DOCKER_COMPOSE% down >nul 2>&1

REM Create data directory for database persistence
if not exist "data" mkdir data
echo ✅ Data directory created

REM Pull latest images and start services
echo.
echo � Pulling latest Docker images and starting services...
%DOCKER_COMPOSE% pull
if errorlevel 1 (
    echo ❌ Failed to pull Docker images
    pause
    exit /b 1
)

%DOCKER_COMPOSE% up -d
if errorlevel 1 (
    echo ❌ Failed to start services
    pause
    exit /b 1
)

echo ✅ Services started successfully

REM Wait a moment for containers to start
echo.
echo ⏳ Waiting for containers to start...
timeout /t 10 /nobreak >nul

REM Check container status
echo.
echo 📊 Container Status:
%DOCKER_COMPOSE% ps

echo.
echo ✅ 🎉 MyFamilyBills is now running!
echo.
echo 📱 Access your application:
echo    Frontend: http://localhost:8085
echo    Backend API: http://localhost:3085
echo.
echo 🛑 To stop the application, run:
echo    %DOCKER_COMPOSE% down
echo.
echo 🗑️  To view logs, run:
echo    %DOCKER_COMPOSE% logs -f

REM Open browser (optional)
set /p "openBrowser=🌐 Open browser to http://localhost:8085? (y/n): "
if /i "%openBrowser%"=="y" (
    start http://localhost:8085
)

echo.
echo Press any key to exit...
pause >nul

REM Open browser (optional)
set /p "openBrowser=🌐 Open browser to http://localhost:8085? (y/n): "
if /i "%openBrowser%"=="y" (
    start http://localhost:8085
)

echo.
echo Press any key to exit...
pause >nul
