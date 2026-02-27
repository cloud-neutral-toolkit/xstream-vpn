#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Sync the repo-managed Xstream iOS real-device smoke skill into Codex local skills.

Usage:
  sync_to_codex_home.sh

Copies:
  skills/xstream-ios-real-device-smoke
  -> ${CODEX_HOME:-$HOME/.codex}/skills/xstream-ios-real-device-smoke

Notes:
  - The repo copy is the canonical source.
  - The target skill directory is replaced on each sync to avoid drift.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_SKILL="$(cd "${SCRIPT_DIR}/.." && pwd)"
TARGET_ROOT="${CODEX_HOME:-$HOME/.codex}/skills"
TARGET_SKILL="${TARGET_ROOT}/xstream-ios-real-device-smoke"

realpath_py() {
  python3 - "$1" <<'PY'
import os
import sys

print(os.path.realpath(sys.argv[1]))
PY
}

mkdir -p "${TARGET_ROOT}"

if [[ -e "${TARGET_SKILL}" ]] && [[ "$(realpath_py "${SRC_SKILL}")" == "$(realpath_py "${TARGET_SKILL}")" ]]; then
  echo "source and target are the same path, nothing to do"
  exit 0
fi

echo ">>> syncing ${SRC_SKILL}"
echo ">>>      to ${TARGET_SKILL}"
rm -rf "${TARGET_SKILL}"
cp -R "${SRC_SKILL}" "${TARGET_SKILL}"
echo ">>> sync complete"
