# XStream

<p align="center">
  <img src="assets/logo.png" alt="XStream Logo" width="200"/>
</p>

## Project

XStream is a Flutter-based client for managing Xray node configs, local proxy mode, and Apple Secure Tunnel workflows in one app.
It is built for users who want a packaged desktop and mobile client with node import, tunnel diagnostics, and system-level networking support on macOS and iOS.

## TL;DR

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d macos
make build-macos-arm64
```

## Downloads

| Platform | Download |
| --- | --- |
| macOS | [Latest Release](https://github.com/cloud-neutral-toolkit/xstream-vpn/releases/latest) |
| Windows | [Latest Release](https://github.com/cloud-neutral-toolkit/xstream-vpn/releases/latest) |
| Linux | [Latest Release](https://github.com/cloud-neutral-toolkit/xstream-vpn/releases/latest) |
| iOS | [Latest Release](https://github.com/cloud-neutral-toolkit/xstream-vpn/releases/latest) |
| Android | [Latest Release](https://github.com/cloud-neutral-toolkit/xstream-vpn/releases/latest) |

All download buttons currently point to the latest GitHub release page.

## Snapshots

| Initial Setup | Sync Config |
| --- | --- |
| ![Initial Setup](docs/images/init-xray.png) | ![Sync Config](docs/images/sync-config.png) |

| Unlock Status | Custom Node Form |
| --- | --- |
| ![Unlock Status](docs/images/unlock-button.png) | ![Custom Node Form](docs/images/custom-node-form.png) |

## Learn More

- [User Manual](docs/user-manual.md)
- [Developer Guide](docs/dev-guide.md)
- [Architecture Overview](docs/architecture_overview.md)
- [Packet Tunnel Design](docs/packet_tunnel_provider_design.md)
- [macOS Packet Tunnel Implementation](docs/macos-packet-tunnel-implementation.md)
- [iOS Design](docs/ios-design.md)
- [FFI Bridge Architecture](docs/ffi-bridge-architecture.md)
- [MCP Server Guide](docs/xstream-mcp-server.md)
