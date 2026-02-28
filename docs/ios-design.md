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

在 iOS Tunnel 模式下，运行时 canonical config 会移除本地 `SOCKS/HTTP` inbound，只保留 `tun` inbound，避免 `PacketTunnel` 扩展与 Host App 的本地端口监听冲突。

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

## iOS 首页监控最小实现

本节记录 iOS 首页“监控卡片区域”的最小补全方案。目标是只补一条轻量监控快照链路，不改现有 Flutter 页面结构，不改连接主流程，不改其它页面。

### 设计边界

- 仅作用于 iOS
- 仅补首页监控卡片所需的数据
- Host App 仍然只负责配置、启动和停止 System VPN
- `PacketTunnelProvider` 仍然是唯一的数据面入口
- 不引入新的本地代理端口，不改变 Secure Tunnel 启动方式

### 最小数据链路

```text
PacketTunnelProvider
  -> App Group shared state snapshot
  -> Darwin Host bridge
  -> Flutter Home screen metrics cards
```

### 指标范围

- 下载速率：真数据，由 `PacketTunnel` 扩展周期性写入快照
- 上传速率：真数据，由 `PacketTunnel` 扩展周期性写入快照
- 内存：真数据，由 `PacketTunnel` 扩展进程自身采样并写入快照
- 延迟：继续复用首页现有延迟结果，不额外改变现有探测逻辑
- CPU：若暂无稳定 iOS 采样口，则首页显示占位值 `--`

### 责任划分

1. `ios/PacketTunnel/PacketTunnelProvider.swift`
   - 只在扩展进程内采样下载、上传、内存
   - 将最新快照写入 App Group 共享状态
   - 不直接驱动 Flutter UI
2. `darwin/MacosHostApi.swift`
   - 通过 `getPacketTunnelMetrics()` 读取共享快照并映射为 Host App 可消费的数据结构
   - 不承担采样逻辑
3. `lib/utils/native_bridge.dart`
   - 只负责把 Host App 返回的快照转换为 Flutter 可用对象
4. `lib/screens/home_screen.dart`
   - 只消费现有延迟与 Darwin 监控快照
   - 仅更新首页监控卡片区域的视觉与展示顺序
   - macOS 共用同一组新卡片 UI，并通过 `PacketTunnelProvider` 写入同一份 App Group 快照

### 共享状态约束

- 快照必须落在 App Group 共享容器，不能依赖主 App 私有沙盒
- 快照必须是覆盖式最新值，而不是累积日志
- 快照更新频率保持轻量高频，当前 Darwin 基线为约 `500ms`
- 快照字段应保持窄接口，优先包含：
  - `downloadBytesPerSecond`
  - `uploadBytesPerSecond`
  - `memoryBytes`
  - `cpuPercent`
  - `updatedAt`
- 延迟不写入这条快照，继续沿用 Flutter 侧活跃连接毫秒探测结果

当前快照 key：

- `packet_tunnel_metrics_snapshot`

### UI 约束

- 不改首页节点列表交互
- 不改其它页面
- 不改现有连接按钮与业务动作
- 首页监控卡片只做展示层重排：
  - 第一行主卡：下载为主、上传为辅
  - 第二行：延迟、CPU
  - 第三行：内存薄卡

### 为什么采用这条最小方案

- 不需要把 Host App 和 `PacketTunnelProvider` 做成强耦合双向通道
- 不需要修改 Secure Tunnel 启动链路
- 不需要把其它页面或连接主流程一起拉进实时采集重构
- 能先补齐 Apple Packet Tunnel 首页最重要的监控信息，再视需要扩展更完整的 runtime stats

## 平台差异

- iOS：`PacketTunnelProvider + libxray.a`
- macOS：保留现有的 `PacketTunnelProvider + dynamic bridge` 路径

这意味着 iOS 与 macOS 在 Secure Tunnel engine 装载方式上不同，但 Flutter UI 与 Darwin 控制面保持一致。

当前 iOS `PacketTunnelProvider` 会直接在扩展进程内采样：

- 下载速率
- 上传速率
- 内存
- CPU 使用率

首页延迟卡仍由 Flutter Home 侧定期测量当前活跃连接并以毫秒展示。

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
