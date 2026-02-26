#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="android-build-env"
OUT="$(pwd)/output"
BUILD_ID=$(date +%s)

log() {
  printf "\n[%s] %s\n" "$(date +'%H:%M:%S')" "$*" >&2
}

log "Building Docker image..."
docker build -t "$IMAGE_NAME" .

log "Running build inside container..."

docker run --rm \
  -v "$OUT":/output \
  "$IMAGE_NAME" \
  bash -c "npm ci --omit=dev --yes && cd android && ./gradlew assembleRelease && cp app/build/outputs/apk/release/app-release-unsigned.apk /output/app-release-$BUILD_ID.apk"


log "Build completed successfully!"

log "APK saved in ./output"