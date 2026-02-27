#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Run an executable iOS real-device smoke pass for Xstream.

Usage:
  ios_real_device_smoke.sh [--device <udid>] [--skip-analyze] [--report <path>] [--keep-artifacts]

What it verifies:
  - dart analyze
  - Runner release target health
  - PacketTunnel release target health
  - release install to a connected iPhone
  - explicit app relaunch
  - running app process on device
  - sandbox Application Support readiness
  - required build/install/launch logs

Notes:
  - Runs from the repo root automatically.
  - Requires macOS, Xcode, Flutter, and a connected physical iPhone.
  - Does not claim Packet Tunnel connect/disconnect coverage.
EOF
}

info() {
  printf '>>> %s\n' "$*"
}

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

DEVICE_ID=""
SKIP_ANALYZE=0
KEEP_ARTIFACTS=0
REPORT_PATH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --device)
      [[ $# -ge 2 ]] || fail "--device requires a value"
      DEVICE_ID="$2"
      shift 2
      ;;
    --skip-analyze)
      SKIP_ANALYZE=1
      shift
      ;;
    --report)
      [[ $# -ge 2 ]] || fail "--report requires a value"
      REPORT_PATH="$2"
      shift 2
      ;;
    --keep-artifacts)
      KEEP_ARTIFACTS=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
done

[[ "$(uname -s)" == "Darwin" ]] || fail "this script requires macOS"

for cmd in dart flutter xcodebuild xcrun git python3; do
  command -v "$cmd" >/dev/null 2>&1 || fail "missing required command: $cmd"
done

ARTIFACT_DIR="$(mktemp -d "${TMPDIR:-/tmp}/xstream-ios-smoke.XXXXXX")"
ANALYZE_LOG="${ARTIFACT_DIR}/dart-analyze.log"
INSTALL_LOG="${ARTIFACT_DIR}/ios-install-release.log"
LAUNCH_LOG="${ARTIFACT_DIR}/device-relaunch.log"
RUNNER_SETTINGS="${ARTIFACT_DIR}/runner-build-settings.txt"
PACKET_SETTINGS="${ARTIFACT_DIR}/packet-tunnel-build-settings.txt"
APPS_JSON="${ARTIFACT_DIR}/device-apps.json"
PROCS_JSON="${ARTIFACT_DIR}/device-processes.json"
APPDATA_DIR="${ARTIFACT_DIR}/app-data"
REPORT_TMP="${ARTIFACT_DIR}/report.md"

cleanup() {
  if [[ "${KEEP_ARTIFACTS}" -eq 0 ]]; then
    rm -rf "${ARTIFACT_DIR}"
  fi
}
trap cleanup EXIT

extract_setting() {
  local file="$1"
  local target="$2"
  local key="$3"
  python3 - "$file" "$target" "$key" <<'PY'
import re
import sys

path, target, key = sys.argv[1:]
current = None
pattern = re.compile(rf"\s*{re.escape(key)} = (.*)")

with open(path, encoding="utf-8", errors="ignore") as handle:
    for raw_line in handle:
        line = raw_line.rstrip("\n")
        header = re.match(r"Build settings for action build and target (.+):", line)
        if header:
            current = header.group(1)
            continue
        if current == target:
            match = pattern.match(line)
            if match:
                print(match.group(1))
                sys.exit(0)
sys.exit(1)
PY
}

read_app_url() {
  local json_file="$1"
  local bundle_id="$2"
  python3 - "$json_file" "$bundle_id" <<'PY'
import json
import sys

path, bundle_id = sys.argv[1:]
data = json.load(open(path, encoding="utf-8"))
for app in data.get("result", {}).get("apps", []):
    if app.get("bundleIdentifier") == bundle_id:
        print(app.get("url", ""))
        sys.exit(0)
sys.exit(1)
PY
}

read_process_match() {
  local json_file="$1"
  local app_url="$2"
  local executable_name="$3"
  python3 - "$json_file" "$app_url" "$executable_name" <<'PY'
import json
import sys

path, app_url, executable_name = sys.argv[1:]
data = json.load(open(path, encoding="utf-8"))
prefix = app_url.rstrip("/") + "/"
expected = prefix + executable_name

for proc in data.get("result", {}).get("runningProcesses", []):
    executable = proc.get("executable", "")
    if executable == expected or executable.startswith(prefix):
        print(f"{proc.get('processIdentifier', '')}|{executable}")
        sys.exit(0)
sys.exit(1)
PY
}

write_report() {
  cat > "${REPORT_TMP}" <<EOF
# iOS Real Device Smoke Report

- Device: \`${DEVICE_ID}\`
- Artifacts: \`${ARTIFACT_DIR}\`

## Build

- Analyze: ${ANALYZE_STATUS}
- Release install: ${INSTALL_STATUS}

## Target Health

- Runner: ${RUNNER_STATUS}
  - Bundle ID: \`${RUNNER_BUNDLE_ID:-n/a}\`
  - Team: \`${RUNNER_TEAM:-n/a}\`
  - Info.plist: \`${RUNNER_INFOPLIST:-n/a}\`
  - Executable: \`${RUNNER_EXECUTABLE:-n/a}\`
  - Product: \`${RUNNER_PRODUCT:-n/a}\`
- PacketTunnel: ${PACKET_STATUS}
  - Bundle ID: \`${PACKET_BUNDLE_ID:-n/a}\`
  - Team: \`${PACKET_TEAM:-n/a}\`
  - Entitlements: \`${PACKET_ENTITLEMENTS:-n/a}\`
  - Info.plist: \`${PACKET_INFOPLIST:-n/a}\`
  - Executable: \`${PACKET_EXECUTABLE:-n/a}\`
  - Product: \`${PACKET_PRODUCT:-n/a}\`

## Install And Launch

- Installed app present on device: ${APP_STATUS}
- Relaunch: ${LAUNCH_STATUS}
- Running process: ${PROCESS_STATUS}
  - Match: \`${PROCESS_MATCH:-n/a}\`

## Sandbox

- Snapshot: ${SANDBOX_STATUS}
- Application Support present: ${APP_SUPPORT_STATUS}
- \`app.db\`: ${APP_DB_STATUS}
- \`vpn_nodes.json\`: ${VPN_NODES_STATUS}
- \`configs/\`: ${CONFIGS_STATUS}
- \`services/\`: ${SERVICES_STATUS}
- \`logs/\`: ${LOG_DIR_STATUS}

## Logs

- Required build/install log: \`${INSTALL_LOG}\`
- Required relaunch log: \`${LAUNCH_LOG}\`
- Analyze log: \`${ANALYZE_LOG}\`

## Notes

- This pass verifies build, install, relaunch, process visibility, and sandbox readiness on a physical iPhone.
- This pass does not verify Packet Tunnel connect or disconnect behavior from UI.
EOF

  if [[ -n "${REPORT_PATH}" ]]; then
    mkdir -p "$(dirname "${REPORT_PATH}")"
    cp "${REPORT_TMP}" "${REPORT_PATH}"
  fi
}

ANALYZE_STATUS="SKIPPED"
INSTALL_STATUS="PENDING"
RUNNER_STATUS="PENDING"
PACKET_STATUS="PENDING"
APP_STATUS="PENDING"
LAUNCH_STATUS="PENDING"
PROCESS_STATUS="PENDING"
SANDBOX_STATUS="PENDING"
APP_SUPPORT_STATUS="PENDING"
APP_DB_STATUS="PENDING"
VPN_NODES_STATUS="PENDING"
CONFIGS_STATUS="PENDING"
SERVICES_STATUS="PENDING"
LOG_DIR_STATUS="PENDING"

RUNNER_BUNDLE_ID=""
RUNNER_TEAM=""
RUNNER_INFOPLIST=""
RUNNER_EXECUTABLE=""
RUNNER_PRODUCT=""
PACKET_BUNDLE_ID=""
PACKET_TEAM=""
PACKET_ENTITLEMENTS=""
PACKET_INFOPLIST=""
PACKET_EXECUTABLE=""
PACKET_PRODUCT=""
PROCESS_MATCH=""

cd "${ROOT_DIR}"

info "Workspace status"
git status --short --branch

if [[ -z "${DEVICE_ID}" ]]; then
  DEVICE_ID="$(
    flutter devices --machine | python3 -c '
import json
import sys

devices = json.load(sys.stdin)
for device in devices:
    if device.get("targetPlatform") == "ios":
        print(device.get("id", ""))
        break
'
  )"
fi

[[ -n "${DEVICE_ID}" ]] || fail "no connected iOS device found; connect a device or pass --device <udid>"

if [[ "${SKIP_ANALYZE}" -eq 0 ]]; then
  info "Running dart analyze"
  if dart analyze 2>&1 | tee "${ANALYZE_LOG}"; then
    ANALYZE_STATUS="PASS"
  else
    ANALYZE_STATUS="FAIL"
    write_report
    fail "dart analyze failed"
  fi
else
  : > "${ANALYZE_LOG}"
fi

info "Collecting Runner build settings"
xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release -sdk iphoneos -showBuildSettings > "${RUNNER_SETTINGS}"
RUNNER_BUNDLE_ID="$(extract_setting "${RUNNER_SETTINGS}" "Runner" "PRODUCT_BUNDLE_IDENTIFIER" || true)"
RUNNER_TEAM="$(extract_setting "${RUNNER_SETTINGS}" "Runner" "DEVELOPMENT_TEAM" || true)"
RUNNER_INFOPLIST="$(extract_setting "${RUNNER_SETTINGS}" "Runner" "INFOPLIST_FILE" || true)"
RUNNER_EXECUTABLE="$(extract_setting "${RUNNER_SETTINGS}" "Runner" "EXECUTABLE_NAME" || true)"
RUNNER_PRODUCT="$(extract_setting "${RUNNER_SETTINGS}" "Runner" "FULL_PRODUCT_NAME" || true)"
if [[ -n "${RUNNER_BUNDLE_ID}" && -n "${RUNNER_TEAM}" && -n "${RUNNER_INFOPLIST}" && -n "${RUNNER_EXECUTABLE}" && -n "${RUNNER_PRODUCT}" ]]; then
  RUNNER_STATUS="PASS"
else
  RUNNER_STATUS="FAIL"
  write_report
  fail "Runner target health check failed"
fi

info "Collecting PacketTunnel build settings"
xcodebuild -workspace ios/Runner.xcworkspace -scheme PacketTunnel -configuration Release -sdk iphoneos -showBuildSettings > "${PACKET_SETTINGS}"
PACKET_BUNDLE_ID="$(extract_setting "${PACKET_SETTINGS}" "PacketTunnel" "PRODUCT_BUNDLE_IDENTIFIER" || true)"
PACKET_TEAM="$(extract_setting "${PACKET_SETTINGS}" "PacketTunnel" "DEVELOPMENT_TEAM" || true)"
PACKET_ENTITLEMENTS="$(extract_setting "${PACKET_SETTINGS}" "PacketTunnel" "CODE_SIGN_ENTITLEMENTS" || true)"
PACKET_INFOPLIST="$(extract_setting "${PACKET_SETTINGS}" "PacketTunnel" "INFOPLIST_FILE" || true)"
PACKET_EXECUTABLE="$(extract_setting "${PACKET_SETTINGS}" "PacketTunnel" "EXECUTABLE_NAME" || true)"
PACKET_PRODUCT="$(extract_setting "${PACKET_SETTINGS}" "PacketTunnel" "FULL_PRODUCT_NAME" || true)"
if [[ -n "${PACKET_BUNDLE_ID}" && -n "${PACKET_TEAM}" && -n "${PACKET_ENTITLEMENTS}" && -n "${PACKET_INFOPLIST}" && -n "${PACKET_EXECUTABLE}" && -n "${PACKET_PRODUCT}" ]]; then
  PACKET_STATUS="PASS"
else
  PACKET_STATUS="FAIL"
  write_report
  fail "PacketTunnel target health check failed"
fi

info "Installing release build to device ${DEVICE_ID}"
if make ios-install-release IOS_DEVICE="${DEVICE_ID}" 2>&1 | tee "${INSTALL_LOG}"; then
  INSTALL_STATUS="PASS"
else
  INSTALL_STATUS="FAIL"
  write_report
  fail "release install failed"
fi

info "Verifying installed app visibility"
xcrun devicectl device info apps --device "${DEVICE_ID}" --bundle-id "${RUNNER_BUNDLE_ID}" --json-output "${APPS_JSON}" >/dev/null
if APP_URL="$(read_app_url "${APPS_JSON}" "${RUNNER_BUNDLE_ID}")"; then
  APP_STATUS="PASS"
else
  APP_STATUS="FAIL"
  write_report
  fail "installed app not found on device"
fi

info "Explicit relaunch"
if xcrun devicectl device process launch --device "${DEVICE_ID}" --terminate-existing "${RUNNER_BUNDLE_ID}" 2>&1 | tee "${LAUNCH_LOG}"; then
  LAUNCH_STATUS="PASS"
else
  LAUNCH_STATUS="FAIL"
  write_report
  fail "device relaunch failed"
fi

sleep 3

info "Checking running process"
xcrun devicectl device info processes --device "${DEVICE_ID}" --json-output "${PROCS_JSON}" >/dev/null
if PROCESS_MATCH="$(read_process_match "${PROCS_JSON}" "${APP_URL}" "${RUNNER_EXECUTABLE}")"; then
  PROCESS_STATUS="PASS"
else
  PROCESS_STATUS="FAIL"
  write_report
  fail "running app process not found on device"
fi

info "Copying app sandbox Library"
mkdir -p "${APPDATA_DIR}"
if xcrun devicectl device copy from --device "${DEVICE_ID}" --domain-type appDataContainer --domain-identifier "${RUNNER_BUNDLE_ID}" --source Library --destination "${APPDATA_DIR}" >/dev/null 2>&1; then
  SANDBOX_STATUS="PASS"
else
  SANDBOX_STATUS="FAIL"
  write_report
  fail "failed to copy app sandbox data"
fi

APP_SUPPORT_DIR="${APPDATA_DIR}/Application Support"
if [[ -d "${APP_SUPPORT_DIR}" ]]; then
  APP_SUPPORT_STATUS="PASS"
else
  APP_SUPPORT_STATUS="FAIL"
fi

if [[ -f "${APP_SUPPORT_DIR}/app.db" ]]; then
  APP_DB_STATUS="PASS"
else
  APP_DB_STATUS="FAIL"
fi

if [[ -f "${APP_SUPPORT_DIR}/vpn_nodes.json" ]]; then
  VPN_NODES_STATUS="PASS"
else
  VPN_NODES_STATUS="FAIL"
fi

if [[ -d "${APP_SUPPORT_DIR}/configs" ]]; then
  CONFIGS_STATUS="PASS"
else
  CONFIGS_STATUS="FAIL"
fi

if [[ -d "${APP_SUPPORT_DIR}/services" ]]; then
  SERVICES_STATUS="PASS"
else
  SERVICES_STATUS="FAIL"
fi

if [[ -d "${APP_SUPPORT_DIR}/logs" ]]; then
  LOG_DIR_STATUS="PASS"
else
  LOG_DIR_STATUS="NOT_CREATED_YET"
fi

if [[ "${APP_SUPPORT_STATUS}" != "PASS" || "${APP_DB_STATUS}" != "PASS" || "${VPN_NODES_STATUS}" != "PASS" || "${CONFIGS_STATUS}" != "PASS" || "${SERVICES_STATUS}" != "PASS" ]]; then
  SANDBOX_STATUS="FAIL"
  write_report
  fail "sandbox Application Support validation failed"
fi

write_report

cat "${REPORT_TMP}"
if [[ -n "${REPORT_PATH}" ]]; then
  info "Report written to ${REPORT_PATH}"
fi
info "Artifacts kept at ${ARTIFACT_DIR}"
