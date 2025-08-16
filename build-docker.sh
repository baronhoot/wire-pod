#!/bin/bash

set -e

echo "Building Wire-Pod Docker image with Whisper and CUDA support..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if NVIDIA Container Toolkit is available (Linux only)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if ! docker run --rm --gpus all nvidia/cuda:12.8-devel-ubuntu22.04 nvidia-smi > /dev/null 2>&1; then
        echo "Warning: NVIDIA Container Toolkit not detected. CUDA acceleration will not be available."
        echo "To enable CUDA support, install NVIDIA Container Toolkit:"
        echo "  https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html"
    else
        echo "NVIDIA Container Toolkit detected. CUDA acceleration will be available."
    fi
fi

# Build the image
echo "Building Docker image..."
docker-compose build

echo ""
echo "Build completed successfully!"
echo ""
echo "To run the container:"
echo "  docker-compose up -d"
echo ""
echo "To view logs:"
echo "  docker-compose logs -f wire-pod"
echo ""
echo "To stop the container:"
echo "  docker-compose down"
echo ""
echo "The container will be available at:"
echo "  - Web interface: http://localhost:8080"
echo "  - HTTPS: https://localhost:443"
echo "  - HTTP: http://localhost:80"
echo "  - Additional service: http://localhost:8084"
