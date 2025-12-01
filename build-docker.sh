#!/bin/bash
# HestiaCP Docker Build Script

set -e

# Configuration
IMAGE_NAME="hestiacp/hestiacp"
VERSION="1.10.0-alpha"
DOCKER_HUB_USERNAME="${DOCKER_HUB_USERNAME:-hestiacp}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    log_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    log_warn "docker-compose is not installed. Skipping compose validation."
fi

# Build the image
log_info "Building HestiaCP Docker image..."
docker build -t "${IMAGE_NAME}:${VERSION}" -t "${IMAGE_NAME}:latest" .

if [ $? -eq 0 ]; then
    log_info "Build successful!"
else
    log_error "Build failed!"
    exit 1
fi

# Display image info
log_info "Image details:"
docker images "${IMAGE_NAME}"

# Ask if user wants to push to Docker Hub
read -p "Do you want to push to Docker Hub? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Logging in to Docker Hub..."
    docker login

    log_info "Pushing ${IMAGE_NAME}:${VERSION}..."
    docker push "${IMAGE_NAME}:${VERSION}"

    log_info "Pushing ${IMAGE_NAME}:latest..."
    docker push "${IMAGE_NAME}:latest"

    log_info "Successfully pushed to Docker Hub!"
else
    log_info "Skipping Docker Hub push."
fi

# Ask if user wants to test the image
read -p "Do you want to test the image locally? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Starting test container with docker-compose..."
    docker-compose up -d

    log_info "Waiting for container to start..."
    sleep 10

    log_info "Container status:"
    docker-compose ps

    log_info "Container logs:"
    docker-compose logs --tail=50

    log_info "Test complete. Access HestiaCP at https://localhost:8083"
    log_info "To stop the test container, run: docker-compose down"
else
    log_info "Skipping local test."
fi

log_info "Build script completed!"
