#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

PLATFORM="all"
DRY_RUN=0
UPLOAD=1
CLEAN_ARTIFACTS=1
DEEP_CLEAN=0
BUILD_NAME=""
BUILD_NUMBER=""
IOS_EXPORT_METHOD="app-store"

IOS_IPA_DIR="$ROOT_DIR/build/ios/ipa"
IOS_ARCHIVE_DIR="$ROOT_DIR/build/ios/archive"
MACOS_ARCHIVE_PATH="$ROOT_DIR/build/macos/archive/Runner.xcarchive"
MACOS_EXPORT_DIR="$ROOT_DIR/build/macos/export"

usage() {
  cat <<'USAGE'
Usage:
  scripts/release-testflight.sh [options]

Options:
  --platform <ios|macos|all>   Choose upload platform(s). Default: all
  --build-name <x.y.z>         Override Flutter build name
  --build-number <n>           Override Flutter build number
  --no-upload                  Build/export only, skip TestFlight upload
  --no-clean                   Keep existing build artifacts
  --deep-clean                 Run flutter clean before building
  --dry-run                    Print commands without executing
  -h, --help                   Show this help

Required .env fields:
  XSTREAM_APPLE_TEAM_ID
  XSTREAM_IOS_BUNDLE_ID
  XSTREAM_IOS_PACKET_TUNNEL_BUNDLE_ID
  XSTREAM_MACOS_BUNDLE_ID
  XSTREAM_MACOS_PACKET_TUNNEL_BUNDLE_ID
  ASC_KEY_ID
  ASC_ISSUER_ID
  ASC_KEY_PATH
USAGE
}

log() {
  printf '%s\n' "$*"
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '[dry-run] '
    printf '%q ' "$@"
    printf '\n'
    return 0
  fi
  "$@"
}

run_bash() {
  local cmd="$1"
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '[dry-run] bash -lc %q\n' "$cmd"
    return 0
  fi
  bash -lc "$cmd"
}

require_cmd() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || fail "Missing command: $cmd"
}

require_env() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    fail "Missing required env: $name"
  fi
}

parse_pubspec_version() {
  local version_line version_name version_number
  version_line="$(sed -nE 's/^version:[[:space:]]*([^[:space:]]+).*/\1/p' "$ROOT_DIR/pubspec.yaml" | head -n1)"
  [[ -n "$version_line" ]] || fail "Unable to parse version from pubspec.yaml"

  version_name="${version_line%%+*}"
  version_number="${version_line##*+}"

  if [[ -z "$BUILD_NAME" ]]; then
    BUILD_NAME="$version_name"
  fi
  if [[ -z "$BUILD_NUMBER" ]]; then
    BUILD_NUMBER="$version_number"
  fi

  [[ "$BUILD_NUMBER" =~ ^[0-9]+$ ]] || fail "Build number must be an integer, got: $BUILD_NUMBER"
}

load_env_file() {
  [[ -f "$ENV_FILE" ]] || fail "Env file not found: $ENV_FILE"
  # shellcheck disable=SC1090
  set -a; source "$ENV_FILE"; set +a
}

prepare_api_key_file() {
  local dst_dir dst_file
  dst_dir="$HOME/.appstoreconnect/private_keys"
  dst_file="$dst_dir/AuthKey_${ASC_KEY_ID}.p8"

  [[ -f "$ASC_KEY_PATH" ]] || fail "ASC_KEY_PATH not found: $ASC_KEY_PATH"

  run mkdir -p "$dst_dir"
  if [[ "$DRY_RUN" == "1" ]]; then
    log "[dry-run] install key -> $dst_file"
    return 0
  fi

  if [[ ! -f "$dst_file" ]] || ! cmp -s "$ASC_KEY_PATH" "$dst_file"; then
    install -m 600 "$ASC_KEY_PATH" "$dst_file"
  fi
}

validate_project_binding() {
  local ios_main ios_packet mac_main mac_packet

  ios_main="$(sed -nE 's/^[[:space:]]*PRODUCT_BUNDLE_IDENTIFIER = ([^;]+);/\1/p' "$ROOT_DIR/ios/Runner.xcodeproj/project.pbxproj" | grep -v 'RunnerTests' | grep -v '\.PacketTunnel$' | head -n1 || true)"
  ios_packet="$(sed -nE 's/^[[:space:]]*PRODUCT_BUNDLE_IDENTIFIER = ([^;]+);/\1/p' "$ROOT_DIR/ios/Runner.xcodeproj/project.pbxproj" | grep -E '\.PacketTunnel$' | head -n1 || true)"
  mac_main="$(sed -nE 's/^[[:space:]]*PRODUCT_BUNDLE_IDENTIFIER[[:space:]]*=[[:space:]]*([^[:space:]]+).*/\1/p' "$ROOT_DIR/macos/Runner/Configs/AppInfo.xcconfig" | head -n1 || true)"
  mac_packet="$(sed -nE 's/^[[:space:]]*PRODUCT_BUNDLE_IDENTIFIER = ([^;]+);/\1/p' "$ROOT_DIR/macos/Runner.xcodeproj/project.pbxproj" | grep -E '\.PacketTunnel$' | head -n1 || true)"

  [[ "$ios_main" == "$XSTREAM_IOS_BUNDLE_ID" ]] || fail "iOS bundle id mismatch (project=$ios_main env=$XSTREAM_IOS_BUNDLE_ID)"
  [[ "$ios_packet" == "$XSTREAM_IOS_PACKET_TUNNEL_BUNDLE_ID" ]] || fail "iOS packet tunnel bundle id mismatch (project=$ios_packet env=$XSTREAM_IOS_PACKET_TUNNEL_BUNDLE_ID)"
  [[ "$mac_main" == "$XSTREAM_MACOS_BUNDLE_ID" ]] || fail "macOS bundle id mismatch (project=$mac_main env=$XSTREAM_MACOS_BUNDLE_ID)"
  [[ "$mac_packet" == "$XSTREAM_MACOS_PACKET_TUNNEL_BUNDLE_ID" ]] || fail "macOS packet tunnel bundle id mismatch (project=$mac_packet env=$XSTREAM_MACOS_PACKET_TUNNEL_BUNDLE_ID)"
}

clean_artifacts() {
  if [[ "$CLEAN_ARTIFACTS" == "1" ]]; then
    run rm -rf "$IOS_IPA_DIR" "$IOS_ARCHIVE_DIR" "$MACOS_ARCHIVE_PATH" "$MACOS_EXPORT_DIR"
  fi

  if [[ "$DEEP_CLEAN" == "1" ]]; then
    run_bash "cd '$ROOT_DIR' && flutter clean"
  fi
}

build_ios_ipa() {
  run_bash "cd '$ROOT_DIR' && ./build_scripts/build_ios_xray.sh"
  run_bash "cd '$ROOT_DIR' && flutter pub get"

  run_bash "cd '$ROOT_DIR' && flutter build ipa --release --export-method '$IOS_EXPORT_METHOD' --build-name '$BUILD_NAME' --build-number '$BUILD_NUMBER'"
}

upload_ios() {
  local ipa_path
  ipa_path="$(find "$IOS_IPA_DIR" -maxdepth 1 -type f -name '*.ipa' | head -n1 || true)"
  [[ -n "$ipa_path" ]] || fail "No iOS IPA found in $IOS_IPA_DIR"

  run xcrun altool --upload-app --type ios --file "$ipa_path" --apiKey "$ASC_KEY_ID" --apiIssuer "$ASC_ISSUER_ID" --verbose
}

build_macos_archive_export() {
  local export_opts
  export_opts="$(mktemp /tmp/xstream-macos-export-options.XXXXXX)"
  cat > "$export_opts" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>method</key>
  <string>app-store</string>
  <key>signingStyle</key>
  <string>automatic</string>
  <key>teamID</key>
  <string>${XSTREAM_APPLE_TEAM_ID}</string>
  <key>uploadSymbols</key>
  <true/>
</dict>
</plist>
PLIST

  run_bash "cd '$ROOT_DIR' && flutter pub get"
  run_bash "cd '$ROOT_DIR' && ./build_scripts/build_macos_xray_from_vendor.sh"
  run_bash "cd '$ROOT_DIR' && flutter build macos --release --build-name '$BUILD_NAME' --build-number '$BUILD_NUMBER'"

  run xcodebuild \
    -workspace "$ROOT_DIR/macos/Runner.xcworkspace" \
    -scheme Runner \
    -configuration Release \
    -archivePath "$MACOS_ARCHIVE_PATH" \
    -destination 'generic/platform=macOS' \
    -allowProvisioningUpdates \
    archive

  run xcodebuild \
    -exportArchive \
    -archivePath "$MACOS_ARCHIVE_PATH" \
    -exportPath "$MACOS_EXPORT_DIR" \
    -exportOptionsPlist "$export_opts" \
    -allowProvisioningUpdates

  if [[ "$DRY_RUN" != "1" ]]; then
    rm -f "$export_opts"
  fi
}

upload_macos() {
  local pkg_path
  pkg_path="$(find "$MACOS_EXPORT_DIR" -maxdepth 1 -type f -name '*.pkg' | head -n1 || true)"
  [[ -n "$pkg_path" ]] || fail "No macOS .pkg found in $MACOS_EXPORT_DIR"

  run xcrun altool --upload-app --type macos --file "$pkg_path" --apiKey "$ASC_KEY_ID" --apiIssuer "$ASC_ISSUER_ID" --verbose
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --platform)
      PLATFORM="${2:-}"
      [[ -n "$PLATFORM" ]] || fail "--platform requires a value"
      shift 2
      ;;
    --build-name)
      BUILD_NAME="${2:-}"
      [[ -n "$BUILD_NAME" ]] || fail "--build-name requires a value"
      shift 2
      ;;
    --build-number)
      BUILD_NUMBER="${2:-}"
      [[ -n "$BUILD_NUMBER" ]] || fail "--build-number requires a value"
      shift 2
      ;;
    --no-upload)
      UPLOAD=0
      shift
      ;;
    --no-clean)
      CLEAN_ARTIFACTS=0
      shift
      ;;
    --deep-clean)
      DEEP_CLEAN=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "Unknown argument: $1"
      ;;
  esac
done

case "$PLATFORM" in
  ios|macos|all) ;;
  *) fail "Invalid --platform: $PLATFORM (use ios|macos|all)" ;;
esac

require_cmd flutter
require_cmd xcrun
require_cmd xcodebuild

load_env_file
require_env XSTREAM_APPLE_TEAM_ID
require_env XSTREAM_IOS_BUNDLE_ID
require_env XSTREAM_IOS_PACKET_TUNNEL_BUNDLE_ID
require_env XSTREAM_MACOS_BUNDLE_ID
require_env XSTREAM_MACOS_PACKET_TUNNEL_BUNDLE_ID
require_env ASC_KEY_ID
require_env ASC_ISSUER_ID
require_env ASC_KEY_PATH

parse_pubspec_version
validate_project_binding
clean_artifacts

if [[ "$UPLOAD" == "1" ]]; then
  prepare_api_key_file
fi

log "Release config: platform=$PLATFORM build=${BUILD_NAME}+${BUILD_NUMBER} upload=$UPLOAD"

if [[ "$PLATFORM" == "ios" || "$PLATFORM" == "all" ]]; then
  log "==> iOS: build IPA"
  build_ios_ipa
  if [[ "$UPLOAD" == "1" ]]; then
    log "==> iOS: upload to TestFlight"
    upload_ios
  fi
fi

if [[ "$PLATFORM" == "macos" || "$PLATFORM" == "all" ]]; then
  log "==> macOS: archive/export"
  build_macos_archive_export
  if [[ "$UPLOAD" == "1" ]]; then
    log "==> macOS: upload to TestFlight"
    upload_macos
  fi
fi

log "Done."
