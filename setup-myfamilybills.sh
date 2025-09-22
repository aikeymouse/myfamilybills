#!/bin/bash

# MyFamilyBills Docker Launcher Script
# This script downloads the latest Docker images and launches the application

set -e

echo "🚀 MyFamilyBills Docker Launcher"
echo "================================"

# Configuration
BACKEND_IMAGE="aikeymouse/myfamilybills-backend:latest"
FRONTEND_IMAGE="aikeymouse/myfamilybills-frontend:latest"
NETWORK_NAME="myfamilybills-network"
BACKEND_CONTAINER="backend"
FRONTEND_CONTAINER="frontend"

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

# Stop and remove existing containers if they exist
echo
echo "🧹 Cleaning up existing containers..."
docker stop $BACKEND_CONTAINER $FRONTEND_CONTAINER 2>/dev/null || true
docker rm $BACKEND_CONTAINER $FRONTEND_CONTAINER 2>/dev/null || true

# Remove existing network if it exists
docker network rm $NETWORK_NAME 2>/dev/null || true

# Create network
echo
echo "🌐 Creating Docker network..."
docker network create $NETWORK_NAME
print_status "Network '$NETWORK_NAME' created"

# Pull latest images
echo
echo "📥 Pulling latest Docker images..."
echo "Pulling backend image: $BACKEND_IMAGE"
docker pull $BACKEND_IMAGE

echo "Pulling frontend image: $FRONTEND_IMAGE"
docker pull $FRONTEND_IMAGE

print_status "Images pulled successfully"

# Create data directory for database persistence
mkdir -p ./data
print_status "Data directory created"

# Launch backend container
echo
echo "🗄️  Starting backend container..."
docker run -d \
    --name $BACKEND_CONTAINER \
    --network $NETWORK_NAME \
    -p 3085:3085 \
    -v "$(pwd)/data:/app/data" \
    $BACKEND_IMAGE

print_status "Backend container started on port 3085"

# Launch frontend container
echo
echo "🌐 Starting frontend container..."
docker run -d \
    --name $FRONTEND_CONTAINER \
    --network $NETWORK_NAME \
    -p 8085:80 \
    $FRONTEND_IMAGE

print_status "Frontend container started on port 8085"

# Wait a moment for containers to start
echo
echo "⏳ Waiting for containers to start..."
sleep 5

# Check container status
echo
echo "📊 Container Status:"
docker ps --filter "name=$BACKEND_CONTAINER" --filter "name=$FRONTEND_CONTAINER" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo
print_status "🎉 MyFamilyBills is now running!"
echo
echo "📱 Access your application:"
echo "   Frontend: http://localhost:8085"
echo "   Backend API: http://localhost:3085"
echo
echo "🛑 To stop the application, run:"
echo "   docker stop $BACKEND_CONTAINER $FRONTEND_CONTAINER"
echo
echo "🗑️  To remove containers:"
echo "   docker rm $BACKEND_CONTAINER $FRONTEND_CONTAINER"
echo "   docker network rm $NETWORK_NAME"

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
