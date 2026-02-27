# iOS Real Device Smoke Test Cases

Use these cases when reporting what the smoke pass actually covered.

## Core Cases

### IOS-SMOKE-001 Analyze

- Goal: confirm repository-level Dart health before device deployment.
- Command: `dart analyze`
- Pass: exits `0`
- Failure layer: analyze

### IOS-SMOKE-002 Runner Target Health

- Goal: confirm the release Runner target still resolves correct iOS metadata.
- Commands:
  - `xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release -sdk iphoneos -showBuildSettings`
- Pass:
  - `PRODUCT_BUNDLE_IDENTIFIER` present
  - `DEVELOPMENT_TEAM` present
  - `INFOPLIST_FILE` present
  - `EXECUTABLE_NAME` present
  - `FULL_PRODUCT_NAME` present
- Failure layer: target health

### IOS-SMOKE-003 PacketTunnel Target Health

- Goal: confirm the Packet Tunnel extension still has explicit signing metadata.
- Commands:
  - `xcodebuild -workspace ios/Runner.xcworkspace -scheme PacketTunnel -configuration Release -sdk iphoneos -showBuildSettings`
- Pass:
  - `PRODUCT_BUNDLE_IDENTIFIER` present
  - `DEVELOPMENT_TEAM` present
  - `CODE_SIGN_ENTITLEMENTS` present
  - `INFOPLIST_FILE` present
  - `EXECUTABLE_NAME` present
  - `FULL_PRODUCT_NAME` present
- Failure layer: target health

### IOS-SMOKE-004 Release Install

- Goal: prove the current tree can build and install to real hardware.
- Command: `make ios-install-release IOS_DEVICE=<udid>`
- Pass:
  - command exits `0`
  - build log contains a successful Xcode build
  - install log contains successful install or launch
- Failure layer: build or install

### IOS-SMOKE-005 Installed App Visibility

- Goal: confirm the built app is actually present on the iPhone.
- Command:
  - `xcrun devicectl device info apps --device <udid> --bundle-id <runner bundle id>`
- Pass:
  - bundle identifier appears in installed apps
- Failure layer: install

### IOS-SMOKE-006 Explicit Relaunch

- Goal: confirm the installed app can be relaunched after installation.
- Command:
  - `xcrun devicectl device process launch --device <udid> --terminate-existing <runner bundle id>`
- Pass:
  - command exits `0`
  - output reports `Launched application`
- Failure layer: launch

### IOS-SMOKE-007 Running Process Presence

- Goal: confirm the relaunched app stays live long enough to observe on device.
- Command:
  - `xcrun devicectl device info processes --device <udid> --json-output <file>`
- Pass:
  - a running process executable resolves inside the installed app bundle URL
- Failure layer: launch

### IOS-SMOKE-008 Sandbox Application Support Health

- Goal: confirm the launched app can create and retain its sandbox support files.
- Command:
  - `xcrun devicectl device copy from --device <udid> --domain-type appDataContainer --domain-identifier <runner bundle id> --source Library --destination <dir>`
- Pass:
  - `Application Support/` exists
  - `app.db` exists
  - `vpn_nodes.json` exists
  - `configs/` exists
  - `services/` exists
- Failure layer: sandbox

### IOS-SMOKE-009 Log Evidence

- Goal: preserve enough evidence to debug failures without claiming more coverage than was actually captured.
- Required evidence:
  - saved `make ios-install-release` log
  - saved `devicectl` relaunch log
- Optional evidence:
  - `Application Support/logs/` exists and was copied
- Pass:
  - required logs are saved
  - optional log directory status is reported explicitly
- Failure layer: logs

### IOS-SMOKE-010 Coverage Gap Statement

- Goal: avoid overstating what the smoke pass proves.
- Pass:
  - final report explicitly states whether UI interaction and Packet Tunnel connect/disconnect were exercised
- Failure layer: reporting
