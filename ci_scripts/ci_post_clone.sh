#!/bin/sh
# ci_post_clone.sh
# Xcode Cloud post-clone script for Flutter projects
# This script runs after Xcode Cloud clones the repository.
# It installs Flutter, resolves dependencies, and generates
# the required configuration files for both iOS and macOS builds.

set -e

echo "=== Xcode Cloud: Post-Clone Script ==="
echo "CI_WORKSPACE: $CI_WORKSPACE"
echo "CI_PRIMARY_REPOSITORY_PATH: $CI_PRIMARY_REPOSITORY_PATH"

# Use the primary repository path
REPO_PATH="${CI_PRIMARY_REPOSITORY_PATH:-$CI_WORKSPACE/repository}"
cd "$REPO_PATH"

# ─── 1. Install Flutter SDK ───────────────────────────────────────────
FLUTTER_VERSION="3.24.3"
FLUTTER_HOME="$HOME/flutter"

if [ ! -d "$FLUTTER_HOME" ]; then
  echo ">>> Installing Flutter $FLUTTER_VERSION..."
  git clone https://github.com/flutter/flutter.git -b "$FLUTTER_VERSION" --depth 1 "$FLUTTER_HOME"
fi

export PATH="$FLUTTER_HOME/bin:$PATH"

echo ">>> Flutter version:"
flutter --version

# ─── 2. Install Go (required for xray bridge build) ──────────────────
GO_VERSION="1.23.0"
GO_HOME="$HOME/go"

if [ ! -d "$GO_HOME" ]; then
  echo ">>> Installing Go $GO_VERSION..."
  curl -sL "https://go.dev/dl/go${GO_VERSION}.darwin-arm64.tar.gz" -o /tmp/go.tar.gz
  mkdir -p "$GO_HOME"
  tar -xzf /tmp/go.tar.gz -C "$HOME"
  rm /tmp/go.tar.gz
fi

export PATH="$GO_HOME/bin:$PATH"
export GOPATH="$HOME/gopath"
export PATH="$GOPATH/bin:$PATH"

echo ">>> Go version:"
go version

# ─── 3. Resolve Flutter dependencies ─────────────────────────────────
echo ">>> Running flutter pub get..."
flutter pub get

# ─── 4. Install CocoaPods dependencies ────────────────────────────────
echo ">>> Installing CocoaPods..."
gem install cocoapods --no-document 2>/dev/null || true

# Determine which platform we're building for based on CI_XCODE_SCHEME or CI_PRODUCT_PLATFORM
echo ">>> CI_XCODE_SCHEME: ${CI_XCODE_SCHEME:-not set}"
echo ">>> CI_PRODUCT_PLATFORM: ${CI_PRODUCT_PLATFORM:-not set}"

# Install pods for iOS
if [ -f "ios/Podfile" ]; then
  echo ">>> Running pod install for iOS..."
  cd ios
  pod install --repo-update || pod install
  cd "$REPO_PATH"
fi

# Install pods for macOS
if [ -f "macos/Podfile" ]; then
  echo ">>> Running pod install for macOS..."
  cd macos
  pod install --repo-update || pod install
  cd "$REPO_PATH"
fi

echo "=== Post-Clone Script Complete ==="
