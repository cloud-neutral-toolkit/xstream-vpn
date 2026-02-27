# iOS Real Device Smoke Report

- Device: `00008140-000E75903EF2801C`
- Artifacts: `/var/folders/qg/z_8_ddtx49qdffyx2byxx_400000gn/T//xstream-ios-smoke.NPx9bR`

## Build

- Analyze: PASS
- Release install: PASS

## Target Health

- Runner: PASS
  - Bundle ID: `plus.svc.xstream`
  - Team: `N3G9T67W78`
  - Info.plist: `Runner/Info.plist`
  - Executable: `Runner`
  - Product: `Runner.app`
- PacketTunnel: PASS
  - Bundle ID: `plus.svc.xstream.PacketTunnel`
  - Team: `N3G9T67W78`
  - Entitlements: `PacketTunnel/PacketTunnel.entitlements`
  - Info.plist: `PacketTunnel/Info.plist`
  - Executable: `PacketTunnel`
  - Product: `PacketTunnel.appex`

## Install And Launch

- Installed app present on device: PASS
- Relaunch: PASS
- Running process: PASS
  - Match: `10550|file:///private/var/containers/Bundle/Application/71B99205-B6EB-45D7-83E3-FF070F5B9808/Runner.app/Runner`

## Sandbox

- Snapshot: PASS
- Application Support present: PASS
- `app.db`: PASS
- `vpn_nodes.json`: PASS
- `configs/`: PASS
- `services/`: PASS
- `logs/`: NOT_CREATED_YET

## Logs

- Required build/install log: `/var/folders/qg/z_8_ddtx49qdffyx2byxx_400000gn/T//xstream-ios-smoke.NPx9bR/ios-install-release.log`
- Required relaunch log: `/var/folders/qg/z_8_ddtx49qdffyx2byxx_400000gn/T//xstream-ios-smoke.NPx9bR/device-relaunch.log`
- Analyze log: `/var/folders/qg/z_8_ddtx49qdffyx2byxx_400000gn/T//xstream-ios-smoke.NPx9bR/dart-analyze.log`

## Notes

- This pass verifies build, install, relaunch, process visibility, and sandbox readiness on a physical iPhone.
- This pass does not verify Packet Tunnel connect or disconnect behavior from UI.
