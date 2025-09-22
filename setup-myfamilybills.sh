#!/bin/bash

# MyFamilyBills Docker Compose Launcher Script
# This script downloads the latest Docker images and launches the application using Docker Compose

set -e

echo "🚀 MyFamilyBills Docker Launcher"
echo "================================"

# Configuration
BACKEND_CONTAINER="backend"
FRONTEND_CONTAINER="frontend"
COMPOSE_FILE="docker-compose.yml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker Desktop first."
    exit 1
fi

print_status "Docker is running"

# Check if docker-compose is available
if ! command -v docker-compose > /dev/null 2>&1; then
    if ! docker compose version > /dev/null 2>&1; then
        print_error "Docker Compose is not available. Please install Docker Compose."
        exit 1
    else
        DOCKER_COMPOSE="docker compose"
    fi
else
    DOCKER_COMPOSE="docker-compose"
fi

print_status "Docker Compose is available"

# Download docker-compose.yml if it doesn't exist
if [ ! -f "$COMPOSE_FILE" ]; then
    echo
    echo "📥 Downloading docker-compose.yml..."
    curl -sSL https://raw.githubusercontent.com/aikeymouse/myfamilybills/main/docker-compose.yml -o docker-compose.yml
    print_status "docker-compose.yml downloaded"
fi

# Stop and remove existing containers if they exist
echo
echo "🧹 Cleaning up existing containers..."
$DOCKER_COMPOSE down 2>/dev/null || true

# Create data directory for database persistence
mkdir -p ./data
print_status "Data directory created"

# Pull latest images and start services
echo
echo "� Pulling latest Docker images and starting services..."
$DOCKER_COMPOSE pull
$DOCKER_COMPOSE up -d

print_status "Services started successfully"

# Wait a moment for containers to start
echo
echo "⏳ Waiting for containers to start..."
sleep 10

# Check container status
echo
echo "📊 Container Status:"
$DOCKER_COMPOSE ps

echo
print_status "🎉 MyFamilyBills is now running!"
echo
echo "📱 Access your application:"
echo "   Frontend: http://localhost:8085"
echo "   Backend API: http://localhost:3085"
echo
echo "🛑 To stop the application, run:"
echo "   $DOCKER_COMPOSE down"
echo
echo "🗑️  To view logs, run:"
echo "   $DOCKER_COMPOSE logs -f"

# Open browser (optional)
read -p "🌐 Open browser to http://localhost:8085? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v open > /dev/null; then
        open http://localhost:8085
    elif command -v xdg-open > /dev/null; then
        xdg-open http://localhost:8085
    else
        echo "Please open http://localhost:8085 in your browser"
    fi
fi

# Open browser (optional)
read -p "🌐 Open browser to http://localhost:8085? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v open > /dev/null; then
        open http://localhost:8085
    elif command -v xdg-open > /dev/null; then
        xdg-open http://localhost:8085
    else
        echo "Please open http://localhost:8085 in your browser"
    fi
fi
