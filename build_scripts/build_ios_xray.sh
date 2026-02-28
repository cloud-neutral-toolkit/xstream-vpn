#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT_DIR="$DIR/build/ios"
LIBXRAY_DIR="$DIR/libXray"
OUTPUT_ARCHIVE="$OUTPUT_DIR/libxray.a"
OUTPUT_HEADER="$OUTPUT_DIR/libxray.h"

if [[ ! -d "$LIBXRAY_DIR" || ! -f "$LIBXRAY_DIR/go.mod" ]]; then
  echo "libXray submodule is missing. Run:"
  echo "  git submodule update --init --recursive libXray"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"
rm -f "$OUTPUT_ARCHIVE" "$OUTPUT_HEADER"

cd "$DIR/go_core"

echo ">>> Building iOS Packet Tunnel bridge archive..."

export CGO_ENABLED=1
export GOOS=ios
export GOARCH=arm64
export CC="$(xcrun --sdk iphoneos --find clang)"
export CGO_CFLAGS="-isysroot $(xcrun --sdk iphoneos --show-sdk-path)"

go mod download
go build -buildmode=c-archive -o "$OUTPUT_ARCHIVE" ./bridge_ios.go

echo ">>> Output archive: $OUTPUT_ARCHIVE"
echo ">>> Output header: $OUTPUT_HEADER"
