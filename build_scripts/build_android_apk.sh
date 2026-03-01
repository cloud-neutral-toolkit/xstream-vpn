#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APK_PATH="$ROOT_DIR/build/app/outputs/flutter-apk/app-release.apk"
BRANCH="${BRANCH:-$(git -C "$ROOT_DIR" rev-parse --abbrev-ref HEAD)}"
BUILD_ID="${BUILD_ID:-$(git -C "$ROOT_DIR" rev-parse --short HEAD)}"
BUILD_DATE="${BUILD_DATE:-$(date '+%Y-%m-%d')}"
UNAME_S="${UNAME_S:-$(uname -s)}"

if [[ "$UNAME_S" != "Darwin" && "$UNAME_S" != "Linux" ]]; then
  echo "Android APK build is only supported on macOS or Linux"
  exit 0
fi

cd "$ROOT_DIR"

echo ">>> Building Android native bridge (.so) ..."
./build_scripts/build_android_xray.sh

echo ">>> Building Android release APK ..."
flutter build apk --release \
  --dart-define=BRANCH_NAME="$BRANCH" \
  --dart-define=BUILD_ID="$BUILD_ID" \
  --dart-define=BUILD_DATE="$BUILD_DATE"

if [[ ! -f "$APK_PATH" ]]; then
  echo "APK build completed but output not found: $APK_PATH"
  exit 1
fi

echo ">>> APK ready:"
echo "    $APK_PATH"
