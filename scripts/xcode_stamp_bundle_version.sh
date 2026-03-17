#!/bin/sh
set -eu

resolve_repo_root() {
  if [ -n "${FLUTTER_APPLICATION_PATH:-}" ] && [ -f "${FLUTTER_APPLICATION_PATH}/pubspec.yaml" ]; then
    printf '%s\n' "${FLUTTER_APPLICATION_PATH}"
    return
  fi

  if [ -n "${FLUTTER_SOURCE_ROOT_OVERRIDE:-}" ] && [ -f "${FLUTTER_SOURCE_ROOT_OVERRIDE}/pubspec.yaml" ]; then
    printf '%s\n' "${FLUTTER_SOURCE_ROOT_OVERRIDE}"
    return
  fi

  if [ -n "${PROJECT_DIR:-}" ] && [ -f "${PROJECT_DIR}/../pubspec.yaml" ]; then
    (
      cd "${PROJECT_DIR}/.." >/dev/null 2>&1
      pwd
    )
    return
  fi

  echo "error: unable to locate pubspec.yaml for version stamping" >&2
  exit 1
}

plist_set() {
  key="$1"
  value="$2"
  plist="$3"

  if ! /usr/libexec/PlistBuddy -c "Set :${key} ${value}" "${plist}" >/dev/null 2>&1; then
    /usr/libexec/PlistBuddy -c "Add :${key} string ${value}" "${plist}" >/dev/null
  fi
}

repo_root="$(resolve_repo_root)"
pubspec_path="${repo_root}/pubspec.yaml"
version_line="$(sed -n 's/^version:[[:space:]]*//p' "${pubspec_path}" | head -n 1)"

case "${version_line}" in
  *+*)
    build_name="${version_line%%+*}"
    build_number="${version_line##*+}"
    ;;
  *)
    echo "error: invalid pubspec version '${version_line}'" >&2
    exit 1
    ;;
esac

if [ -z "${TARGET_BUILD_DIR:-}" ] || [ -z "${INFOPLIST_PATH:-}" ]; then
  echo "error: TARGET_BUILD_DIR or INFOPLIST_PATH is not set" >&2
  exit 1
fi

plist_path="${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

if [ ! -f "${plist_path}" ]; then
  echo "warning: skipping version stamp because plist does not exist at ${plist_path}" >&2
  exit 0
fi

plist_set "CFBundleShortVersionString" "${build_name}" "${plist_path}"
plist_set "CFBundleVersion" "${build_number}" "${plist_path}"

echo "Stamped ${plist_path} -> ${build_name} (${build_number})"
