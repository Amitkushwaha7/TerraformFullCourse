#!/bin/bash
set -e

echo "🚀 Building Lambda Layer with Pillow using Docker..."

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"
TERRAFORM_DIR="$PROJECT_DIR/terraform"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "📖 Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

echo "📦 Building layer in Linux container (Python 3.12)..."

# Get absolute Windows path for Docker Desktop
# Docker Desktop on Windows needs native Windows paths (C:\path) or //c/path format
cd "$TERRAFORM_DIR"

# Try to get Windows-style path first (for Git Bash on Windows)
if command -v cygpath &> /dev/null; then
  # Cygwin/Git Bash with cygpath
  DOCKER_MOUNT_PATH=$(cygpath -w "$TERRAFORM_DIR")
elif [[ -n "$WINDIR" ]]; then
  # We're on Windows - use pwd -W if available
  DOCKER_MOUNT_PATH=$(cd "$TERRAFORM_DIR" && pwd -W 2>/dev/null || pwd)
else
  # Linux/Mac
  DOCKER_MOUNT_PATH="$TERRAFORM_DIR"
fi

echo "🐳 Docker mount path: $DOCKER_MOUNT_PATH"

# Build the layer using Docker with Python 3.12 on Linux AMD64
docker run --rm \
  --platform linux/amd64 \
  -v "$DOCKER_MOUNT_PATH":/output \
  python:3.12-slim \
  bash -c "
    echo '📦 Installing Pillow for Linux AMD64...' && \
    pip install --quiet Pillow==10.4.0 -t /tmp/python/lib/python3.12/site-packages/ && \
    cd /tmp && \
    echo '📦 Creating layer zip file...' && \
    apt-get update -qq && apt-get install -y -qq zip > /dev/null 2>&1 && \
    zip -q -r pillow_layer.zip python/ && \
    cp pillow_layer.zip /output/ && \
    echo '✅ Layer built successfully for Linux (Lambda-compatible)!'
  "

echo "📍 Location: $TERRAFORM_DIR/pillow_layer.zip"
echo "✅ Layer is now compatible with AWS Lambda on all platforms!"