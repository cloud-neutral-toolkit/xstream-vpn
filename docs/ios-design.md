# iOS App Design

本文档说明 Xstream 在 iOS 平台的整体实现方式，重点覆盖 Flutter UI、Host App、Network Extension 与内置 Secure Tunnel engine 的协作关系。

## 架构一览

```text
Flutter UI (Dart)
  -> iOS Host App (Swift bridge, control plane only)
  -> NETunnelProviderManager
  -> PacketTunnelProvider (Network Extension target)
  -> libxray.a (statically linked Go bridge)
  -> packetFlow + setTunnelNetworkSettings
```

关键约束：

- Host App 只负责保存配置、启动和停止 System VPN
- `PacketTunnelProvider` 是唯一的系统级网络入口
- Secure Tunnel engine 只在 `PacketTunnel` 扩展进程内启动
- Host App 不能直接调用 `PacketTunnelProvider` 的业务方法

## iOS 实际调用路径

1. Flutter UI 在 `lib/utils/native_bridge.dart` 里组装 `TunnelProfile`
2. Dart 通过 Pigeon 调用 `darwin/MacosHostApi.swift`
3. Host App 使用 `NETunnelProviderManager.saveToPreferences(...)` 保存 profile
4. Host App 使用 `NETunnelProviderManager.connection.startVPNTunnel(...)` 启动 System VPN
5. 系统拉起 `ios/PacketTunnel/PacketTunnelProvider.swift`
6. 扩展调用 `setTunnelNetworkSettings(...)` 并解析 `packetFlow` 对应的 TUN fd
7. 扩展直接调用静态链接的 `libxray.a` 导出符号 `StartXrayTunnelWithFd(...)`

## Secure Tunnel engine 集成

1. 初始化 `libXray` 子模块：
   `git submodule update --init --recursive libXray`
2. 运行 `./build_scripts/build_ios_xray.sh`
3. 脚本输出：
   - `build/ios/libxray.a`
   - `build/ios/libxray.h`
4. `PacketTunnel` target 在 Xcode 构建阶段自动执行这条脚本
5. `PacketTunnel.appex` 通过 `-force_load $(SRCROOT)/../build/ios/libxray.a` 静态链接 bridge archive

## Swift bridge 与 PacketTunnel target

- `ios/PacketTunnel/PacketTunnel-Bridging-Header.h` 引入 `bindings/bridge.h`
- `go_core/bridge_ios.go` 导出以下 C 接口：
  - `StartXrayTunnelWithFd`
  - `StopXrayTunnel`
  - `FreeXrayTunnel`
  - `GetLastXrayTunnelError`
  - `FreeCString`
- `ios/PacketTunnel/PacketTunnelProvider.swift` 直接调用这些导出符号

这条 iOS 路径不依赖运行时 `dylib` 发现，也不依赖 `dlopen` / `dlsym`。

## 配置与共享状态

- Host App 与扩展通过 `providerConfiguration` 传递 System VPN 基础配置
- 运行时配置文件与状态落在 App Group 共享容器
- `packet_tunnel_last_error`、`packet_tunnel_started_at` 等状态由扩展侧维护

## 平台差异

- iOS：`PacketTunnelProvider + libxray.a`
- macOS：保留现有的 `PacketTunnelProvider + dynamic bridge` 路径

这意味着 iOS 与 macOS 在 Secure Tunnel engine 装载方式上不同，但 Flutter UI 与 Darwin 控制面保持一致。

## 构建验证

建议至少验证：

1. `./build_scripts/build_ios_xray.sh`
2. `flutter build ios --release`
3. 真机安装后的 `Runner.app/PlugIns/PacketTunnel.appex`
4. `PacketTunnel` 启动后能进入 `StartXrayTunnelWithFd(...)`

## App Store 相关能力

提交前需确保 Xcode 已启用：

- `Network Extension`
- `App Groups`

`PacketTunnel` 与主 App 需要使用同一个 Team 和共享组标识，才能让 Host App 与扩展共享 System VPN 运行配置。
