#!/usr/bin/env bash
set -euo pipefail

# Stamp CFBundleShortVersionString / CFBundleVersion from pubspec.yaml into the built Info.plist.
# This is used by Xcode archive and CI builds to keep versioning consistent across targets.

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
pubspec="${PUBSPEC_PATH:-${root_dir}/pubspec.yaml}"

if [[ ! -f "$pubspec" ]]; then
  echo "[stamp-version] ❌ pubspec.yaml not found: ${pubspec}" >&2
  exit 1
fi

version_line="$(awk -F': ' '/^[[:space:]]*version:[[:space:]]*/ {print $2; exit}' "$pubspec" | tr -d '\r' | xargs || true)"
if [[ -z "$version_line" ]]; then
  echo "[stamp-version] ❌ version not found in pubspec.yaml" >&2
  exit 1
fi

# Supports both Flutter's canonical `X.Y.Z+BUILD` and this repo's `X.Y.Z-BUILD`.
marketing="$version_line"
build=""

if [[ "$marketing" == *"+"* ]]; then
  build="${marketing##*+}"
  marketing="${marketing%%+*}"
elif [[ "$marketing" == *"-"* ]]; then
  build="${marketing##*-}"
  marketing="${marketing%%-*}"
fi

if [[ -z "$build" ]]; then
  build="0"
fi

plist="${TARGET_BUILD_DIR:?}/${INFOPLIST_PATH:?}"
if [[ ! -f "$plist" ]]; then
  echo "[stamp-version] ❌ Info.plist not found: ${plist}" >&2
  exit 1
fi

plistbuddy="/usr/libexec/PlistBuddy"

set_or_add() {
  local key="$1"
  local value="$2"
  if "$plistbuddy" -c "Print :${key}" "$plist" >/dev/null 2>&1; then
    "$plistbuddy" -c "Set :${key} ${value}" "$plist" >/dev/null
  else
    "$plistbuddy" -c "Add :${key} string ${value}" "$plist" >/dev/null
  fi
}

set_or_add "CFBundleShortVersionString" "$marketing"
set_or_add "CFBundleVersion" "$build"

if [[ -n "${SCRIPT_OUTPUT_FILE_0:-}" ]]; then
  mkdir -p "$(dirname "$SCRIPT_OUTPUT_FILE_0")"
  echo "${marketing}-${build}" > "$SCRIPT_OUTPUT_FILE_0"
fi

echo "[stamp-version] ✅ ${TARGET_NAME:-target}: ${marketing} (${build})"

