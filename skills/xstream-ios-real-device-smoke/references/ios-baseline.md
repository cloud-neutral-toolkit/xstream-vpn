# iOS Real Device Baseline

Use this baseline for executable iOS smoke checks on a connected physical iPhone.

## Preconditions

- Host is macOS.
- `flutter`, `dart`, `xcodebuild`, and `xcrun devicectl` are available.
- A physical iPhone is connected and visible in `flutter devices`.
- The repo can sign `ios/Runner.xcworkspace` for device deployment.

## Minimum Pass Conditions

### Build

- `dart analyze` exits `0`.
- `make ios-install-release IOS_DEVICE=<udid>` exits `0`.

### Runner Target Health

Collect settings from:

```bash
xcodebuild -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -sdk iphoneos \
  -showBuildSettings
```

Minimum expected fields:

- `PRODUCT_BUNDLE_IDENTIFIER`
- `DEVELOPMENT_TEAM`
- `INFOPLIST_FILE`
- `EXECUTABLE_NAME`
- `FULL_PRODUCT_NAME`

### PacketTunnel Target Health

Collect settings from:

```bash
xcodebuild -workspace ios/Runner.xcworkspace \
  -scheme PacketTunnel \
  -configuration Release \
  -sdk iphoneos \
  -showBuildSettings
```

Minimum expected fields:

- `PRODUCT_BUNDLE_IDENTIFIER`
- `DEVELOPMENT_TEAM`
- `CODE_SIGN_ENTITLEMENTS`
- `INFOPLIST_FILE`
- `EXECUTABLE_NAME`
- `FULL_PRODUCT_NAME`

`CODE_SIGN_ENTITLEMENTS` is required here because Packet Tunnel signing must remain explicit.

### Install

Verify the app is present on the device:

```bash
xcrun devicectl device info apps \
  --device <udid> \
  --bundle-id <runner bundle id>
```

Minimum pass condition:

- The Runner bundle appears in the installed apps list.

### Launch

Relaunch the app explicitly:

```bash
xcrun devicectl device process launch \
  --device <udid> \
  --terminate-existing \
  <runner bundle id>
```

Then confirm a live process from `devicectl device info processes --json-output ...`.

Minimum pass condition:

- At least one running process executable resolves inside the installed app bundle path.

### Logs

Required log coverage:

- `make ios-install-release` output saved.
- `devicectl device process launch` output saved.

Best-effort log coverage:

- Snapshot the app sandbox and look for `Application Support/logs`.
- If the log directory is absent, report that it was not created yet.
- Do not treat missing device system logs as a failure unless the task explicitly required them.

### Sandbox

Copy the app data container and inspect `Library` contents:

```bash
xcrun devicectl device copy from \
  --device <udid> \
  --domain-type appDataContainer \
  --domain-identifier <runner bundle id> \
  --source Library \
  --destination <local temp dir>
```

Minimum pass condition after a successful launch:

- `Application Support/` exists.
- `Application Support/app.db` exists.
- `Application Support/vpn_nodes.json` exists.
- `Application Support/configs/` exists.
- `Application Support/services/` exists.

## What This Baseline Does Not Prove

- Packet Tunnel connect/disconnect success from the Home screen.
- System VPN route takeover.
- Packet Tunnel data-plane health.
- Manual UI regression on Home or Settings.

Those require an additional runtime or manual interaction pass.
