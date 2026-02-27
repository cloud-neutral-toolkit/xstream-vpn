---
name: xstream-ios-real-device-smoke
description: Run a repeatable iOS real-device smoke pass for Xstream after Packet Tunnel, Runner, signing, Flutter iOS bridge, or release build changes. Use when Codex needs executable verification on a connected iPhone for release build health, install, relaunch, device-side process presence, build/install/launch logs, sandbox readiness, and Runner plus PacketTunnel target health.
---

# Xstream iOS Real Device Smoke

Run this only on macOS with Xcode, Flutter, signing, and a connected physical iPhone.
This skill is for executable real-device smoke coverage, not Simulator-only checks.

## Workflow

1. Confirm workspace state first.
- Run from the repo root.
- Check `git status --short --branch`.
- If unrelated user changes exist, do not reformat or rewrite them.

2. Format only files you touched before verification.
- Swift: `swift format --in-place <touched swift files>`
- Dart: `dart format <touched dart files>`
- Go: `gofmt -w <touched go files>`
- Do not mass-format unrelated files just to satisfy the smoke pass.

3. Validate build health before device deployment.
- Run `dart analyze`.
- For iOS native changes, inspect `Runner` and `PacketTunnel` build settings with `xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release -sdk iphoneos -showBuildSettings` and the same command for `PacketTunnel`.
- Interpret target health using [`references/ios-baseline.md`](./references/ios-baseline.md).

4. Run the deterministic smoke script.
- Default command: `skills/xstream-ios-real-device-smoke/scripts/ios_real_device_smoke.sh`
- If multiple iPhones are connected, pass `--device <udid>`.
- Use `--skip-analyze` only if `dart analyze` already passed in the same turn and you explicitly want to save time.
- Use `--report <path>` when you need a durable verification record.

5. Treat logs as two separate layers.
- Required: build, install, and relaunch logs from `make ios-install-release` and `devicectl device process launch`.
- Best-effort: app sandbox snapshot and optional `Application Support/logs` presence.
- Do not claim device system log coverage unless you actually captured it.

6. Distinguish the failure layer before proposing fixes.
- Analyze failure: Dart, generated bindings, or Flutter-level issues.
- Target health failure: bundle ID, entitlements, executable naming, Info.plist, development team.
- Install failure: signing, provisioning, trust, or device connectivity.
- Launch failure: app process missing or exits immediately after launch.
- Sandbox failure: `Application Support` missing expected files after launch.
- Packet Tunnel runtime failure: app launches, but connect/disconnect behavior was not verified unless you explicitly exercised it from UI.

## Reporting Rules

- Separate `Build`, `Install`, `Launch`, `Logs`, `Runner target`, `PacketTunnel target`, and `Sandbox`.
- State that the pass ran on a physical iPhone and include the UDID used.
- If UI was not exercised, explicitly say that System VPN connect/disconnect regression is still pending.
- If `Application Support/logs` does not exist yet, report `not created yet` instead of treating it as a default failure.
- If the app is installable and launchable but Packet Tunnel connect was not triggered, do not report Tunnel Mode as healthy.

## Reference

- Read [`references/ios-baseline.md`](./references/ios-baseline.md) for pass criteria and command expectations.
- Read [`references/test-cases.md`](./references/test-cases.md) before expanding the smoke scope or claiming formal coverage.
