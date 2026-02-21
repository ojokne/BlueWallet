#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="android-build-env"

echo "....Building Docker image..."
docker build -t "$IMAGE_NAME" .

echo "....Running build inside container..."
docker run --rm "$IMAGE_NAME"
