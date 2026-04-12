#!/usr/bin/env bash
set -euo pipefail

script_path="build_scripts/package_windows_msi.ps1"

python3 - <<'PY'
from pathlib import Path
import re
import sys

script_path = Path("build_scripts/package_windows_msi.ps1")
text = script_path.read_text(encoding="utf-8")

match = re.search(
    r"function\s+Emit-DirectoryContents\s*\{.*?param\((?P<params>.*?)\n\s*\)\s*",
    text,
    re.S,
)
if not match:
    print("Unable to locate Emit-DirectoryContents parameter block.", file=sys.stderr)
    raise SystemExit(1)

params = match.group("params")
if "RelativeDirectory" not in params:
    print("RelativeDirectory parameter missing from Emit-DirectoryContents.", file=sys.stderr)
    raise SystemExit(1)

relative_block = re.search(
    r"\[.*?AllowEmptyString.*?\]\s*\[string\]\$RelativeDirectory",
    params,
    re.S,
)
if not relative_block:
    print("Expected AllowEmptyString() on the MSI directory recursion root parameter.", file=sys.stderr)
    raise SystemExit(1)

relative_line = re.search(r".*\$RelativeDirectory.*", params)
if relative_line and "Mandatory = $true" in relative_line.group(0):
    print("Emit-DirectoryContents must allow an empty root directory.", file=sys.stderr)
    raise SystemExit(1)

print("Windows MSI script guard passed.")
PY
