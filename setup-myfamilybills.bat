@echo off
REM MyFamilyBills Docker Launcher Script for Windows
REM This script downloads the latest Docker images and launches the application

echo.
echo 🚀 MyFamilyBills Docker Launcher
echo ================================

REM Configuration
set BACKEND_IMAGE=aikeymouse/myfamilybills-backend:latest
set FRONTEND_IMAGE=aikeymouse/myfamilybills-frontend:latest
set NETWORK_NAME=myfamilybills-network
set BACKEND_CONTAINER=backend
set FRONTEND_CONTAINER=frontend

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

echo ✅ Docker is running

REM Stop and remove existing containers if they exist
echo.
echo 🧹 Cleaning up existing containers...
docker stop %BACKEND_CONTAINER% %FRONTEND_CONTAINER% >nul 2>&1
docker rm %BACKEND_CONTAINER% %FRONTEND_CONTAINER% >nul 2>&1

REM Remove existing network if it exists
docker network rm %NETWORK_NAME% >nul 2>&1

REM Create network
echo.
echo 🌐 Creating Docker network...
docker network create %NETWORK_NAME%
if errorlevel 1 (
    echo ❌ Failed to create network
    pause
    exit /b 1
)
echo ✅ Network '%NETWORK_NAME%' created

REM Pull latest images
echo.
echo 📥 Pulling latest Docker images...
echo Pulling backend image: %BACKEND_IMAGE%
docker pull %BACKEND_IMAGE%
if errorlevel 1 (
    echo ❌ Failed to pull backend image
    pause
    exit /b 1
)

echo Pulling frontend image: %FRONTEND_IMAGE%
docker pull %FRONTEND_IMAGE%
if errorlevel 1 (
    echo ❌ Failed to pull frontend image
    pause
    exit /b 1
)

echo ✅ Images pulled successfully

REM Create data directory for database persistence
if not exist "data" mkdir data
echo ✅ Data directory created

REM Launch backend container
echo.
echo 🗄️  Starting backend container...
docker run -d --name %BACKEND_CONTAINER% --network %NETWORK_NAME% -p 3085:3085 -v "%CD%/data:/app/data" %BACKEND_IMAGE%
if errorlevel 1 (
    echo ❌ Failed to start backend container
    pause
    exit /b 1
)
echo ✅ Backend container started on port 3085

REM Launch frontend container
echo.
echo 🌐 Starting frontend container...
docker run -d --name %FRONTEND_CONTAINER% --network %NETWORK_NAME% -p 8085:80 %FRONTEND_IMAGE%
if errorlevel 1 (
    echo ❌ Failed to start frontend container
    pause
    exit /b 1
)
echo ✅ Frontend container started on port 8085

REM Wait a moment for containers to start
echo.
echo ⏳ Waiting for containers to start...
timeout /t 5 /nobreak >nul

REM Check container status
echo.
echo 📊 Container Status:
docker ps --filter "name=%BACKEND_CONTAINER%" --filter "name=%FRONTEND_CONTAINER%" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo ✅ 🎉 MyFamilyBills is now running!
echo.
echo 📱 Access your application:
echo    Frontend: http://localhost:8085
echo    Backend API: http://localhost:3085
echo.
echo 🛑 To stop the application, run:
echo    docker stop %BACKEND_CONTAINER% %FRONTEND_CONTAINER%
echo.
echo 🗑️  To remove containers:
echo    docker rm %BACKEND_CONTAINER% %FRONTEND_CONTAINER%
echo    docker network rm %NETWORK_NAME%

REM Open browser (optional)
set /p "openBrowser=🌐 Open browser to http://localhost:8085? (y/n): "
if /i "%openBrowser%"=="y" (
    start http://localhost:8085
)

echo.
echo Press any key to exit...
pause >nul
