# 原生宿主与 Packet Tunnel 参考

本页按“设计意图与边界 → 文件职责 → 类型清单 → 函数/方法清单 → 接口契约 → 约束与副作用”的顺序整理当前仓库实现。描述以当前主路径为准，不保留历史兼容叙述。

函数与方法表以当前手写实现的签名库存为主，个别复杂多行 Swift / Kotlin / C++ 声明会做适度压缩；遇到不规则泛型、闭包或平台回调时，以源码中的完整签名为最终依据。

## 设计意图与边界

覆盖 Darwin Host API、Apple Runner/PacketTunnel、自研 Android 宿主、Linux 宿主和 Windows Runner。重点是平台入口、系统 VPN/Packet Tunnel 生命周期与宿主层交互。

## 文件列表与职责

| 文件 | 职责 | 说明 |
| --- | --- | --- |
| darwin/MacosHostApi.swift | Darwin 宿主 API 手写实现，承接 Flutter Pigeon 调用与 Packet Tunnel 管理。 | 手写实现，纳入本页覆盖范围。 |
| darwin/Messages.g.swift | Pigeon 生成的 Swift 合同文件；本文档只记录其接口契约，不逐行解释实现。 | 自动生成合同文件，仅记录接口契约。 |
| ios/Runner/AppDelegate.swift | Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。 | 手写实现，纳入本页覆盖范围。 |
| ios/Runner/NativeBridge+ConfigWriter.swift | Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。 | 手写实现，纳入本页覆盖范围。 |
| ios/Runner/NativeBridge+Logger.swift | Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。 | 手写实现，纳入本页覆盖范围。 |
| ios/Runner/NativeBridge+ServiceControl.swift | Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。 | 手写实现，纳入本页覆盖范围。 |
| ios/Runner/NativeBridge+XrayInit.swift | Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。 | 手写实现，纳入本页覆盖范围。 |
| ios/PacketTunnel/PacketTunnel-Bridging-Header.h | Linux/Windows 宿主文件，负责窗口壳层或声明。 | 手写实现，纳入本页覆盖范围。 |
| ios/PacketTunnel/PacketTunnelProvider.swift | Apple Packet Tunnel 扩展实现，负责系统网络设置、utun 解析、Xray 启停与指标采样。 | 手写实现，纳入本页覆盖范围。 |
| ios/Runner/Runner-Bridging-Header.h | Linux/Windows 宿主文件，负责窗口壳层或声明。 | 手写实现，纳入本页覆盖范围。 |
| macos/Runner/AppDelegate.swift | Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。 | 手写实现，纳入本页覆盖范围。 |
| macos/Runner/MainFlutterWindow.swift | Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。 | 手写实现，纳入本页覆盖范围。 |
| macos/Runner/NativeBridge+ConfigWriter.swift | Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。 | 手写实现，纳入本页覆盖范围。 |
| macos/Runner/NativeBridge+Logger.swift | Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。 | 手写实现，纳入本页覆盖范围。 |
| macos/Runner/NativeBridge+ServiceControl.swift | Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。 | 手写实现，纳入本页覆盖范围。 |
| macos/Runner/NativeBridge+SystemProxy.swift | Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。 | 手写实现，纳入本页覆盖范围。 |
| macos/Runner/NativeBridge+XrayInit.swift | Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。 | 手写实现，纳入本页覆盖范围。 |
| macos/PacketTunnel/PacketTunnelProvider.swift | Apple Packet Tunnel 扩展实现，负责系统网络设置、utun 解析、Xray 启停与指标采样。 | 手写实现，纳入本页覆盖范围。 |
| android/app/src/main/kotlin/com/example/xstream/MainActivity.kt | Android 自研宿主文件，负责 Activity / Controller / Service / JNI 桥接。 | 手写实现，纳入本页覆盖范围。 |
| android/app/src/main/kotlin/com/example/xstream/NativePacketTunnelBridge.kt | Android 自研宿主文件，负责 Activity / Controller / Service / JNI 桥接。 | 手写实现，纳入本页覆盖范围。 |
| android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt | Android 自研宿主文件，负责 Activity / Controller / Service / JNI 桥接。 | 手写实现，纳入本页覆盖范围。 |
| android/app/src/main/kotlin/com/example/xstream/XstreamPacketTunnelService.kt | Android 自研宿主文件，负责 Activity / Controller / Service / JNI 桥接。 | 手写实现，纳入本页覆盖范围。 |
| android/app/src/main/cpp/packet_tunnel_jni.cpp | C++ 宿主文件，负责 JNI 或 Windows Runner 宿主行为。 | 手写实现，纳入本页覆盖范围。 |
| linux/main.cc | Linux/Windows 宿主文件，负责窗口壳层或声明。 | 手写实现，纳入本页覆盖范围。 |
| linux/my_application.cc | Linux/Windows 宿主文件，负责窗口壳层或声明。 | 手写实现，纳入本页覆盖范围。 |
| linux/my_application.h | Linux/Windows 宿主文件，负责窗口壳层或声明。 | 手写实现，纳入本页覆盖范围。 |
| windows/runner/flutter_window.cpp | C++ 宿主文件，负责 JNI 或 Windows Runner 宿主行为。 | 手写实现，纳入本页覆盖范围。 |
| windows/runner/flutter_window.h | Linux/Windows 宿主文件，负责窗口壳层或声明。 | 手写实现，纳入本页覆盖范围。 |
| windows/runner/main.cpp | C++ 宿主文件，负责 JNI 或 Windows Runner 宿主行为。 | 手写实现，纳入本页覆盖范围。 |
| windows/runner/resource.h | Linux/Windows 宿主文件，负责窗口壳层或声明。 | 手写实现，纳入本页覆盖范围。 |
| windows/runner/utils.cpp | C++ 宿主文件，负责 JNI 或 Windows Runner 宿主行为。 | 手写实现，纳入本页覆盖范围。 |
| windows/runner/utils.h | Linux/Windows 宿主文件，负责窗口壳层或声明。 | 手写实现，纳入本页覆盖范围。 |
| windows/runner/win32_window.cpp | C++ 宿主文件，负责 JNI 或 Windows Runner 宿主行为。 | 手写实现，纳入本页覆盖范围。 |
| windows/runner/win32_window.h | Linux/Windows 宿主文件，负责窗口壳层或声明。 | 手写实现，纳入本页覆盖范围。 |

## 关键数据结构 / 类 / 枚举 / typedef / extension

| 符号 | 类型 | 所在文件 | 说明 |
| --- | --- | --- | --- |
| DarwinHostApiImpl: | class | darwin/MacosHostApi.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| TunnelRouteV4 | struct | darwin/Messages.g.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| TunnelRouteV6 | struct | darwin/Messages.g.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| TunnelProfile | struct | darwin/Messages.g.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| TunnelStatus | struct | darwin/Messages.g.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| TunnelMetricsSnapshot | struct | darwin/Messages.g.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| MessagesPigeonCodec: | class | darwin/Messages.g.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DarwinHostApi | protocol | darwin/Messages.g.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DarwinHostApiSetup | class | darwin/Messages.g.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DarwinFlutterApiProtocol | protocol | darwin/Messages.g.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DarwinFlutterApi: | class | darwin/Messages.g.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppDelegate: | class | ios/Runner/AppDelegate.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppDelegate | extension | ios/Runner/NativeBridge+ConfigWriter.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppDelegate | extension | ios/Runner/NativeBridge+Logger.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppDelegate | extension | ios/Runner/NativeBridge+ServiceControl.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppDelegate | extension | ios/Runner/NativeBridge+XrayInit.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppDelegate: | class | macos/Runner/AppDelegate.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| ProxyMode: | enum | macos/Runner/AppDelegate.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| MenuLanguage | enum | macos/Runner/AppDelegate.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| MenuState | struct | macos/Runner/AppDelegate.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| MainFlutterWindow: | class | macos/Runner/MainFlutterWindow.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppDelegate | extension | macos/Runner/NativeBridge+ConfigWriter.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppDelegate | extension | macos/Runner/NativeBridge+Logger.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppDelegate | extension | macos/Runner/NativeBridge+ServiceControl.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppDelegate | extension | macos/Runner/NativeBridge+SystemProxy.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppDelegate | extension | macos/Runner/NativeBridge+XrayInit.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| PacketTunnelProvider: | class | macos/PacketTunnel/PacketTunnelProvider.swift | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| MainActivity | class | android/app/src/main/kotlin/com/example/xstream/MainActivity.kt | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| XstreamPacketTunnelService | class | android/app/src/main/kotlin/com/example/xstream/XstreamPacketTunnelService.kt | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| _MyApplication | struct | linux/my_application.cc | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| FlutterWindow | class | windows/runner/flutter_window.h | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| TrayMenuState | struct | windows/runner/flutter_window.h | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| class | enum | windows/runner/flutter_window.h | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| WindowClassRegistrar | class | windows/runner/win32_window.cpp | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| Win32Window | class | windows/runner/win32_window.h | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| Point | struct | windows/runner/win32_window.h | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| Size | struct | windows/runner/win32_window.h | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |

## 函数与方法清单

### `darwin/MacosHostApi.swift`

Darwin 宿主 API 手写实现，承接 Flutter Pigeon 调用与 Packet Tunnel 管理。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| appGroupPath | darwin/MacosHostApi.swift / DarwinHostApiImpl | 无 | throws -> String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| redirectStdErr | darwin/MacosHostApi.swift / DarwinHostApiImpl | path: String, completion: @escaping (Result<Void, Error>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| generateTls | darwin/MacosHostApi.swift / DarwinHostApiImpl | 无 | throws -> FlutterStandardTypedData | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| setupShutdownNotification | darwin/MacosHostApi.swift / DarwinHostApiImpl | 无 | throws -> Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| startPacketTunnel | darwin/MacosHostApi.swift / DarwinHostApiImpl | completion: @escaping (Result<Void, Error>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| stopPacketTunnel | darwin/MacosHostApi.swift / DarwinHostApiImpl | completion: @escaping (Result<Void, Error>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| getPacketTunnelStatus | darwin/MacosHostApi.swift / DarwinHostApiImpl | completion: @escaping (Result<TunnelStatus, Error>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| sharedDefaults | darwin/MacosHostApi.swift / DarwinHostApiImpl | 无 | UserDefaults | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| readPacketTunnelMetricsSnapshot | darwin/MacosHostApi.swift / DarwinHostApiImpl | 无 | TunnelMetricsSnapshot | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| integerValue | darwin/MacosHostApi.swift / DarwinHostApiImpl | _ raw: Any? | Int64? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| doubleValue | darwin/MacosHostApi.swift / DarwinHostApiImpl | _ raw: Any? | Double? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| storedPacketTunnelOptions | darwin/MacosHostApi.swift / DarwinHostApiImpl | 无 | [String: NSObject]? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| buildPacketTunnelOptions | darwin/MacosHostApi.swift / DarwinHostApiImpl | profile: TunnelProfile | [String: NSObject] | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| packetTunnelProviderBundleId | darwin/MacosHostApi.swift / DarwinHostApiImpl | 无 | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| loadTunnelManager | darwin/MacosHostApi.swift / DarwinHostApiImpl | completion: @escaping (NETunnelProviderManager?, Error?) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| shouldForceManagerRecreation | darwin/MacosHostApi.swift / DarwinHostApiImpl | staleManagerHint: String? | Bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| packetTunnelOptionsEqual | darwin/MacosHostApi.swift / DarwinHostApiImpl | _ lhs: [String: NSObject]?, _ rhs: [String: NSObject] | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| packetTunnelOptions | darwin/MacosHostApi.swift / DarwinHostApiImpl | from dictionary: [String: Any]? | [String: NSObject]? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| isPluginRegistrationError | darwin/MacosHostApi.swift / DarwinHostApiImpl | _ message: String? | Bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| mapStatus | darwin/MacosHostApi.swift / DarwinHostApiImpl | _ status: NEVPNStatus | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| shouldExposeStartedAt | darwin/MacosHostApi.swift / DarwinHostApiImpl | for state: String | Bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| describeError | darwin/MacosHostApi.swift / DarwinHostApiImpl | _ error: Error | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| listUtunInterfaces | darwin/MacosHostApi.swift / DarwinHostApiImpl | 无 | [String] | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| clearStartedAt | darwin/MacosHostApi.swift / DarwinHostApiImpl | 无 | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| readStartedAt | darwin/MacosHostApi.swift / DarwinHostApiImpl | 无 | Int64? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| writeLastError | darwin/MacosHostApi.swift / DarwinHostApiImpl | _ message: String | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| clearLastError | darwin/MacosHostApi.swift / DarwinHostApiImpl | 无 | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| readLastError | darwin/MacosHostApi.swift / DarwinHostApiImpl | 无 | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| emitPacketTunnelStateChanged | darwin/MacosHostApi.swift / DarwinHostApiImpl | 无 | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| emitPacketTunnelError | darwin/MacosHostApi.swift / DarwinHostApiImpl | code: String, message: String | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `darwin/Messages.g.swift`

Pigeon 生成的 Swift 合同文件；本文档只记录其接口契约，不逐行解释实现。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| wrapResult | darwin/Messages.g.swift / Messages.g.swift | _ result: Any? | [Any?] | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| wrapError | darwin/Messages.g.swift / Messages.g.swift | _ error: Any | [Any?] | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| createConnectionError | darwin/Messages.g.swift / Messages.g.swift | withChannelName channelName: String | PigeonError | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| isNullish | darwin/Messages.g.swift / Messages.g.swift | _ value: Any? | Bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| fromList | darwin/Messages.g.swift / TunnelRouteV4 | _ pigeonVar_list: [Any?] | TunnelRouteV4? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| toList | darwin/Messages.g.swift / TunnelRouteV4 | 无 | [Any?] | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| fromList | darwin/Messages.g.swift / TunnelRouteV6 | _ pigeonVar_list: [Any?] | TunnelRouteV6? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| toList | darwin/Messages.g.swift / TunnelRouteV6 | 无 | [Any?] | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| fromList | darwin/Messages.g.swift / TunnelProfile | _ pigeonVar_list: [Any?] | TunnelProfile? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| toList | darwin/Messages.g.swift / TunnelProfile | 无 | [Any?] | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| fromList | darwin/Messages.g.swift / TunnelStatus | _ pigeonVar_list: [Any?] | TunnelStatus? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| toList | darwin/Messages.g.swift / TunnelStatus | 无 | [Any?] | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| fromList | darwin/Messages.g.swift / TunnelMetricsSnapshot | _ pigeonVar_list: [Any?] | TunnelMetricsSnapshot? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| toList | darwin/Messages.g.swift / TunnelMetricsSnapshot | 无 | [Any?] | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| readValue | darwin/Messages.g.swift / TunnelMetricsSnapshot | ofType type: UInt8 | Any? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| writeValue | darwin/Messages.g.swift / TunnelMetricsSnapshot | _ value: Any | override func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| reader | darwin/Messages.g.swift / TunnelMetricsSnapshot | with data: Data | FlutterStandardReader | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| writer | darwin/Messages.g.swift / TunnelMetricsSnapshot | with data: NSMutableData | FlutterStandardWriter | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| appGroupPath | darwin/Messages.g.swift / DarwinHostApi | 无 | throws -> String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| startXApiServer | darwin/Messages.g.swift / DarwinHostApi | config: FlutterStandardTypedData, completion: @escaping (Result<Void, Error>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| redirectStdErr | darwin/Messages.g.swift / DarwinHostApi | path: String, completion: @escaping (Result<Void, Error>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| generateTls | darwin/Messages.g.swift / DarwinHostApi | 无 | throws -> FlutterStandardTypedData | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| setupShutdownNotification | darwin/Messages.g.swift / DarwinHostApi | 无 | throws -> Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| savePacketTunnelProfile | darwin/Messages.g.swift / DarwinHostApi | profile: TunnelProfile, completion: @escaping (Result<String, Error>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| startPacketTunnel | darwin/Messages.g.swift / DarwinHostApi | completion: @escaping (Result<Void, Error>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| stopPacketTunnel | darwin/Messages.g.swift / DarwinHostApi | completion: @escaping (Result<Void, Error>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| getPacketTunnelStatus | darwin/Messages.g.swift / DarwinHostApi | completion: @escaping (Result<TunnelStatus, Error>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| getPacketTunnelMetrics | darwin/Messages.g.swift / DarwinHostApi | completion: @escaping (Result<TunnelMetricsSnapshot, Error>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| setUp | darwin/Messages.g.swift / DarwinHostApiSetup | binaryMessenger: FlutterBinaryMessenger, api: DarwinHostApi?, messageChannelSuffix: String = "" | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| onSystemWillShutdown | darwin/Messages.g.swift / DarwinFlutterApiProtocol | completion: @escaping (Result<Void, PigeonError>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| onSystemWillRestart | darwin/Messages.g.swift / DarwinFlutterApiProtocol | completion: @escaping (Result<Void, PigeonError>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| onSystemWillSleep | darwin/Messages.g.swift / DarwinFlutterApiProtocol | completion: @escaping (Result<Void, PigeonError>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| onPacketTunnelStateChanged | darwin/Messages.g.swift / DarwinFlutterApiProtocol | status statusArg: TunnelStatus, completion: @escaping (Result<Void, PigeonError>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| onPacketTunnelError | darwin/Messages.g.swift / DarwinFlutterApiProtocol | code codeArg: String, message messageArg: String, completion: @escaping (Result<Void, PigeonError>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| onSystemWillShutdown | darwin/Messages.g.swift / DarwinFlutterApi | completion: @escaping (Result<Void, PigeonError>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| onSystemWillRestart | darwin/Messages.g.swift / DarwinFlutterApi | completion: @escaping (Result<Void, PigeonError>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| onSystemWillSleep | darwin/Messages.g.swift / DarwinFlutterApi | completion: @escaping (Result<Void, PigeonError>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| onPacketTunnelStateChanged | darwin/Messages.g.swift / DarwinFlutterApi | status statusArg: TunnelStatus, completion: @escaping (Result<Void, PigeonError>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| onPacketTunnelError | darwin/Messages.g.swift / DarwinFlutterApi | code codeArg: String, message messageArg: String, completion: @escaping (Result<Void, PigeonError>) -> Void | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `ios/Runner/AppDelegate.swift`

Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| didInitializeImplicitFlutterEngine | ios/Runner/AppDelegate.swift / AppDelegate | _ engineBridge: FlutterImplicitEngineBridge | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `ios/Runner/NativeBridge+ConfigWriter.swift`

Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| writeConfigFiles | ios/Runner/NativeBridge+ConfigWriter.swift / AppDelegate | call: FlutterMethodCall, result: @escaping FlutterResult | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `ios/Runner/NativeBridge+Logger.swift`

Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| logToFlutter | ios/Runner/NativeBridge+Logger.swift / AppDelegate | _ level: String, _ message: String | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `ios/Runner/NativeBridge+ServiceControl.swift`

Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| handleServiceControl | ios/Runner/NativeBridge+ServiceControl.swift / AppDelegate | call: FlutterMethodCall, result: @escaping FlutterResult | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `ios/Runner/NativeBridge+XrayInit.swift`

Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| handlePerformAction | ios/Runner/NativeBridge+XrayInit.swift / AppDelegate | call: FlutterMethodCall, bundleId: String, result: @escaping FlutterResult | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `ios/PacketTunnel/PacketTunnel-Bridging-Header.h`

Linux/Windows 宿主文件，负责窗口壳层或声明。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `ios/PacketTunnel/PacketTunnelProvider.swift`

Apple Packet Tunnel 扩展实现，负责系统网络设置、utun 解析、Xray 启停与指标采样。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| resolveOptions | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | options: [String: NSObject]? | throws -> [String: NSObject] | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| resolveConfigData | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | options: [String: NSObject] | Data | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| shouldEnableIPv6 | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | options: [String: NSObject], launchOptions: [String: NSObject]? | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| parseIPv6Routes | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | _ rawRoutes: [[String: Any]] | [NEIPv6Route] | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| startPathMonitor | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | 无 | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| resolvePacketFlowFileDescriptor | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | ) -> (fd: Int32, detail: String | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| resolveUtunInterfaceName | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | forFileDescriptor fd: Int32 | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| normalizeUtunInterfaceName | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | _ raw: String? | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| utunSortKey | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | _ name: String | Int | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| annotateFdDetail | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | _ detail: String, interfaceName: String? | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| resolveIntSelectorPath | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | on object: NSObject, path: [String] | Int32? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| callIntSelector | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | on object: NSObject, selectorName: String | Int32? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| callObjectSelector | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | on object: NSObject, selectorName: String | NSObject? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| scanObjectIvarsForFileDescriptor | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | _ object: NSObject | Int32? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| ensurePathMonitor | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | 无 | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| start | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | config: Data, fd: Int32, fdDetail: String, egressInterface: String | throws -> Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| stop | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| start | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | config: Data, fd: Int32, fdDetail: String, egressInterface: String | throws -> Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| stop | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| start | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | configData: Data, fd: Int32, fdDetail: String, egressInterface: String | throws -> Int64 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| stop | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | handle: Int64 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| free | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | handle: Int64 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| releaseCString | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | _ ptr: UnsafeMutablePointer<CChar>? | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| readBridgeError | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| summarizeConfig | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | _ data: Data | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| start | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | interfaceName: String? | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| stop | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| captureSnapshot | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | interfaceName: String | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| normalizeInterfaceName | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | _ raw: String? | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| readCounters | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | interfaceName: String, timestamp: TimeInterval | InterfaceCounters? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| currentMemoryBytes | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | 无 | Int64? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| currentCpuPercent | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | 无 | Double? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| refreshResourceMetricsIfNeeded | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | force: Bool = false, timestamp: TimeInterval | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| clear | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| markConnected | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| markFailed | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | _ error: String | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| markDisconnected | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | reason: NEProviderStopReason | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| describe | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | _ reason: NEProviderStopReason | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| isFailureReason | ios/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider.swift | _ reason: NEProviderStopReason | Bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `ios/Runner/Runner-Bridging-Header.h`

Linux/Windows 宿主文件，负责窗口壳层或声明。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `macos/Runner/AppDelegate.swift`

Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| applicationDidFinishLaunching | macos/Runner/AppDelegate.swift / MenuState | _ notification: Notification | override func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| applicationWillTerminate | macos/Runner/AppDelegate.swift / MenuState | _ notification: Notification | override func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| applicationShouldTerminateAfterLastWindowClosed | macos/Runner/AppDelegate.swift / MenuState | _ sender: NSApplication | Bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| applicationSupportsSecureRestorableState | macos/Runner/AppDelegate.swift / MenuState | _ app: NSApplication | Bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| buildStatusMenu | macos/Runner/AppDelegate.swift / MenuState | 无 | NSMenu | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| refreshMenuUI | macos/Runner/AppDelegate.swift / MenuState | 无 | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| menuText | macos/Runner/AppDelegate.swift / MenuState | _ key: MenuTextKey | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| setLaunchAtLoginEnabled | macos/Runner/AppDelegate.swift / MenuState | target | if | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| startAcceleration | macos/Runner/AppDelegate.swift / MenuState | 无 | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| stopAcceleration | macos/Runner/AppDelegate.swift / MenuState | 无 | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| resolveTargetNodeName | macos/Runner/AppDelegate.swift / MenuState | 无 | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| loadNodeNames | macos/Runner/AppDelegate.swift / MenuState | 无 | [String] | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| resolveRulesFile | macos/Runner/AppDelegate.swift / MenuState | 无 | URL? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| notifyFlutterMenuAction | macos/Runner/AppDelegate.swift / MenuState | action: String, payload: [String: Any] = [:] | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| handleUpdateMenuState | macos/Runner/AppDelegate.swift / MenuState | call: FlutterMethodCall, result: @escaping FlutterResult | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| isLaunchAtLoginEnabled | macos/Runner/AppDelegate.swift / MenuState | 无 | Bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| setLaunchAtLoginEnabled | macos/Runner/AppDelegate.swift / MenuState | _ enabled: Bool | Bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `macos/Runner/MainFlutterWindow.swift`

Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| awakeFromNib | macos/Runner/MainFlutterWindow.swift / MainFlutterWindow | 无 | override func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `macos/Runner/NativeBridge+ConfigWriter.swift`

Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| writeConfigFiles | macos/Runner/NativeBridge+ConfigWriter.swift / AppDelegate | call: FlutterMethodCall, result: @escaping FlutterResult | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| writeXrayConfig | macos/Runner/NativeBridge+ConfigWriter.swift / AppDelegate | path: String, content: String | throws -> Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| writePlistFile | macos/Runner/NativeBridge+ConfigWriter.swift / AppDelegate | path: String, content: String | throws -> Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| updateVpnNodesConfig | macos/Runner/NativeBridge+ConfigWriter.swift / AppDelegate | path: String, content: String | throws -> Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| writeStringToFile | macos/Runner/NativeBridge+ConfigWriter.swift / AppDelegate | path: String, content: String | throws -> Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `macos/Runner/NativeBridge+Logger.swift`

Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| logToFlutter | macos/Runner/NativeBridge+Logger.swift / AppDelegate | _ level: String, _ message: String | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `macos/Runner/NativeBridge+ServiceControl.swift`

Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| handleServiceControl | macos/Runner/NativeBridge+ServiceControl.swift / AppDelegate | call: FlutterMethodCall, bundleId: String, result: @escaping FlutterResult | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `macos/Runner/NativeBridge+SystemProxy.swift`

Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| handleSystemProxy | macos/Runner/NativeBridge+SystemProxy.swift / AppDelegate | call: FlutterMethodCall, result: @escaping FlutterResult | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| runSetSystemProxy | macos/Runner/NativeBridge+SystemProxy.swift / AppDelegate | enable: Bool, password: String, result: @escaping FlutterResult | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `macos/Runner/NativeBridge+XrayInit.swift`

Apple Runner 宿主文件，负责 Flutter 通道、菜单栏/生命周期、配置或系统集成。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| handlePerformAction | macos/Runner/NativeBridge+XrayInit.swift / AppDelegate | call: FlutterMethodCall, bundleId: String, result: @escaping FlutterResult | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| runResetXray | macos/Runner/NativeBridge+XrayInit.swift / AppDelegate | bundleId: String, password _: String, result: @escaping FlutterResult | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| resolveAppSupportRoot | macos/Runner/NativeBridge+XrayInit.swift / AppDelegate | bundleId: String | URL? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `macos/PacketTunnel/PacketTunnelProvider.swift`

Apple Packet Tunnel 扩展实现，负责系统网络设置、utun 解析、Xray 启停与指标采样。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| resolveOptions | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | options: [String: NSObject]? | throws -> [String: NSObject] | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| resolveConfigData | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | options: [String: NSObject] | Data | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| shouldEnableIPv6 | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | options: [String: NSObject], launchOptions: [String: NSObject]? | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| parseIPv6Routes | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | _ rawRoutes: [[String: Any]] | [NEIPv6Route] | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| startPathMonitor | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | 无 | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| resolvePacketFlowFileDescriptor | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | ) -> (fd: Int32, detail: String | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| resolveUtunInterfaceName | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | forFileDescriptor fd: Int32 | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| normalizeUtunInterfaceName | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | _ raw: String? | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| utunSortKey | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | _ name: String | Int | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| annotateFdDetail | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | _ detail: String, interfaceName: String? | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| resolveIntSelectorPath | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | on object: NSObject, path: [String] | Int32? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| callIntSelector | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | on object: NSObject, selectorName: String | Int32? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| callObjectSelector | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | on object: NSObject, selectorName: String | NSObject? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| scanObjectIvarsForFileDescriptor | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | _ object: NSObject | Int32? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| start | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | interfaceName: String? | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| stop | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| captureSnapshot | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | interfaceName: String | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| normalizeInterfaceName | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | _ raw: String? | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| readCounters | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | interfaceName: String, timestamp: TimeInterval | InterfaceCounters? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| currentMemoryBytes | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | 无 | Int64? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| currentCpuPercent | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | 无 | Double? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| refreshResourceMetricsIfNeeded | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | force: Bool = false, timestamp: TimeInterval | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| clear | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| start | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | config: Data, fd: Int32, fdDetail: String, egressInterface: String | throws -> Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| stop | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| start | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | config: Data, fd: Int32, fdDetail: String, egressInterface: String | throws -> Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| stop | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| start | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | configData: Data, fd: Int32, fdDetail: String, egressInterface: String | throws -> Int64 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| stop | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | handle: Int64 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| free | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | handle: Int64 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| releaseCString | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | _ ptr: UnsafeMutablePointer<CChar>? | private func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| readBridgeError | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| summarizeConfig | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | _ data: Data | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| openBridgeHandle | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | ) -> (handle: UnsafeMutableRawPointer?, error: String? | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| markConnected | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| markFailed | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | _ error: String | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| markDisconnected | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | reason: NEProviderStopReason | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| describe | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | _ reason: NEProviderStopReason | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |
| isFailureReason | macos/PacketTunnel/PacketTunnelProvider.swift / PacketTunnelProvider | _ reason: NEProviderStopReason | Bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由宿主进程、系统回调或 Flutter 通道调用。 |

### `android/app/src/main/kotlin/com/example/xstream/MainActivity.kt`

Android 自研宿主文件，负责 Activity / Controller / Service / JNI 桥接。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| configureFlutterEngine | android/app/src/main/kotlin/com/example/xstream/MainActivity.kt / MainActivity | flutterEngine: FlutterEngine | override fun | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| openVpnSettings | android/app/src/main/kotlin/com/example/xstream/MainActivity.kt / MainActivity | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |

### `android/app/src/main/kotlin/com/example/xstream/NativePacketTunnelBridge.kt`

Android 自研宿主文件，负责 Activity / Controller / Service / JNI 桥接。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| isAvailable | android/app/src/main/kotlin/com/example/xstream/NativePacketTunnelBridge.kt / NativePacketTunnelBridge.kt | 无 | Boolean | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| startTunnel | android/app/src/main/kotlin/com/example/xstream/NativePacketTunnelBridge.kt / NativePacketTunnelBridge.kt | configJson: String, tunFd: Int | Long | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| stopTunnel | android/app/src/main/kotlin/com/example/xstream/NativePacketTunnelBridge.kt / NativePacketTunnelBridge.kt | handle: Long | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| freeTunnel | android/app/src/main/kotlin/com/example/xstream/NativePacketTunnelBridge.kt / NativePacketTunnelBridge.kt | handle: Long | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| nativeStartTunnel | android/app/src/main/kotlin/com/example/xstream/NativePacketTunnelBridge.kt / NativePacketTunnelBridge.kt | configJson: String, tunFd: Int | Long | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| nativeStopTunnel | android/app/src/main/kotlin/com/example/xstream/NativePacketTunnelBridge.kt / NativePacketTunnelBridge.kt | handle: Long | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| nativeFreeTunnel | android/app/src/main/kotlin/com/example/xstream/NativePacketTunnelBridge.kt / NativePacketTunnelBridge.kt | handle: Long | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |

### `android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt`

Android 自研宿主文件，负责 Activity / Controller / Service / JNI 桥接。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| saveProfile | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context, profileMap: Map<*, *> | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| onVpnPermissionResult | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context, granted: Boolean | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| startService | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context, stored: String | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| stop | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| status | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context | Map<String, Any?> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| markConnected | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context | fun | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| markDisconnected | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context | fun | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| markFailed | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context, message: String | fun | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| prefs | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context | Unit | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| writeState | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context, state: String | private fun | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| readState | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| writeError | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context, message: String | private fun | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| clearError | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context | private fun | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| clearStartedAt | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context | private fun | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| markPendingPermission | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context | private fun | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| clearPendingPermission | android/app/src/main/kotlin/com/example/xstream/PacketTunnelController.kt / PacketTunnelController.kt | context: Context | private fun | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |

### `android/app/src/main/kotlin/com/example/xstream/XstreamPacketTunnelService.kt`

Android 自研宿主文件，负责 Activity / Controller / Service / JNI 桥接。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| onDestroy | android/app/src/main/kotlin/com/example/xstream/XstreamPacketTunnelService.kt / XstreamPacketTunnelService | 无 | override fun | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| startTunnel | android/app/src/main/kotlin/com/example/xstream/XstreamPacketTunnelService.kt / XstreamPacketTunnelService | profileJson: String? | private fun | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| stopTunnel | android/app/src/main/kotlin/com/example/xstream/XstreamPacketTunnelService.kt / XstreamPacketTunnelService | markDisconnected: Boolean = true | private fun | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| resolveConfigJson | android/app/src/main/kotlin/com/example/xstream/XstreamPacketTunnelService.kt / XstreamPacketTunnelService | profile: JSONObject | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| ensureTunInbound | android/app/src/main/kotlin/com/example/xstream/XstreamPacketTunnelService.kt / XstreamPacketTunnelService | configJson: String, mtu: Int | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| addIpv4Routes | android/app/src/main/kotlin/com/example/xstream/XstreamPacketTunnelService.kt / XstreamPacketTunnelService | builder: Builder, routes: JSONArray? | private fun | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| addIpv6Routes | android/app/src/main/kotlin/com/example/xstream/XstreamPacketTunnelService.kt / XstreamPacketTunnelService | builder: Builder, routes: JSONArray? | private fun | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| maskToPrefixLength | android/app/src/main/kotlin/com/example/xstream/XstreamPacketTunnelService.kt / XstreamPacketTunnelService | mask: String | Int | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| jsonStringArray | android/app/src/main/kotlin/com/example/xstream/XstreamPacketTunnelService.kt / XstreamPacketTunnelService | array: JSONArray? | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| jsonIntArray | android/app/src/main/kotlin/com/example/xstream/XstreamPacketTunnelService.kt / XstreamPacketTunnelService | array: JSONArray? | List<Int> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Android/Linux/Windows 宿主主流程调用。 |

### `android/app/src/main/cpp/packet_tunnel_jni.cpp`

C++ 宿主文件，负责 JNI 或 Windows Runner 宿主行为。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| ensureBridgeLoaded | android/app/src/main/cpp/packet_tunnel_jni.cpp / packet_tunnel_jni.cpp | 无 | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| toJStringAndFree | android/app/src/main/cpp/packet_tunnel_jni.cpp / packet_tunnel_jni.cpp | JNIEnv* env, char* ptr | jstring | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |

### `linux/main.cc`

Linux/Windows 宿主文件，负责窗口壳层或声明。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| main | linux/main.cc / main.cc | int argc, char** argv | int | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |

### `linux/my_application.cc`

Linux/Windows 宿主文件，负责窗口壳层或声明。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| my_application_activate | linux/my_application.cc / _MyApplication | GApplication* application | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| my_application_local_command_line | linux/my_application.cc / _MyApplication | GApplication* application, gchar*** arguments, int* exit_status | gboolean | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| my_application_startup | linux/my_application.cc / _MyApplication | GApplication* application | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| my_application_shutdown | linux/my_application.cc / _MyApplication | GApplication* application | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| my_application_dispose | linux/my_application.cc / _MyApplication | GObject* object | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| my_application_class_init | linux/my_application.cc / _MyApplication | MyApplicationClass* klass | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| my_application_init | linux/my_application.cc / _MyApplication | MyApplication* self | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| my_application_new | linux/my_application.cc / my_application.cc | 无 | MyApplication* | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |

### `linux/my_application.h`

Linux/Windows 宿主文件，负责窗口壳层或声明。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `windows/runner/flutter_window.cpp`

C++ 宿主文件，负责 JNI 或 Windows Runner 宿主行为。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| OnCreate | windows/runner/flutter_window.cpp / FlutterWindow | 无 | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| OnDestroy | windows/runner/flutter_window.cpp / FlutterWindow | 无 | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| RegisterNativeChannel | windows/runner/flutter_window.cpp / FlutterWindow | 无 | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| ShowMainWindow | windows/runner/flutter_window.cpp / FlutterWindow | 无 | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| WideFromUtf8 | windows/runner/flutter_window.cpp / FlutterWindow | const std::string& utf8_text | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| MenuText | windows/runner/flutter_window.cpp / FlutterWindow | MenuTextKey key | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| ShowTrayContextMenu | windows/runner/flutter_window.cpp / FlutterWindow | 无 | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |

### `windows/runner/flutter_window.h`

Linux/Windows 宿主文件，负责窗口壳层或声明。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `windows/runner/main.cpp`

C++ 宿主文件，负责 JNI 或 Windows Runner 宿主行为。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| FindExistingInstanceWindow | windows/runner/main.cpp / main.cpp | 无 | HWND | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| ActivateExistingInstance | windows/runner/main.cpp / main.cpp | HWND window | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |

### `windows/runner/resource.h`

Linux/Windows 宿主文件，负责窗口壳层或声明。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `windows/runner/utils.cpp`

C++ 宿主文件，负责 JNI 或 Windows Runner 宿主行为。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| CreateAndAttachConsole | windows/runner/utils.cpp / utils.cpp | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| GetCommandLineArguments | windows/runner/utils.cpp / utils.cpp | 无 | std::vector<std::string> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| Utf8FromUtf16 | windows/runner/utils.cpp / utils.cpp | const wchar_t* utf16_string | std::string | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |

### `windows/runner/utils.h`

Linux/Windows 宿主文件，负责窗口壳层或声明。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `windows/runner/win32_window.cpp`

C++ 宿主文件，负责 JNI 或 Windows Runner 宿主行为。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| Scale | windows/runner/win32_window.cpp / win32_window.cpp | int source, double scale_factor | int | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| EnableFullDpiSupportIfAvailable | windows/runner/win32_window.cpp / win32_window.cpp | HWND hwnd | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| GetInstance | windows/runner/win32_window.cpp / win32_window.cpp | 无 | WindowClassRegistrar* | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| GetWindowClass | windows/runner/win32_window.cpp / WindowClassRegistrar | 无 | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| UnregisterWindowClass | windows/runner/win32_window.cpp / WindowClassRegistrar | 无 | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| Win32Window | windows/runner/win32_window.cpp / Win32Window | 无 | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| Show | windows/runner/win32_window.cpp / Win32Window | 无 | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| Destroy | windows/runner/win32_window.cpp / Win32Window | 无 | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| SetChildContent | windows/runner/win32_window.cpp / Win32Window | HWND content | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| GetClientArea | windows/runner/win32_window.cpp / Win32Window | 无 | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| GetHandle | windows/runner/win32_window.cpp / Win32Window | 无 | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| SetQuitOnClose | windows/runner/win32_window.cpp / Win32Window | bool quit_on_close | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| OnCreate | windows/runner/win32_window.cpp / Win32Window | 无 | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| OnDestroy | windows/runner/win32_window.cpp / Win32Window | 无 | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |
| UpdateTheme | windows/runner/win32_window.cpp / Win32Window | HWND const window | 见声明 / 实现文件 | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Android/Linux/Windows 宿主主流程调用。 |

### `windows/runner/win32_window.h`

Linux/Windows 宿主文件，负责窗口壳层或声明。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

## 接口契约与跨层依赖

### Packet Tunnel / Darwin Host

| 接口 | 方向 | 说明 |
| --- | --- | --- |
| `DarwinHostApiImpl.savePacketTunnelProfile` | Flutter -> Darwin | 将隧道 profile 保存到 App Group / Manager 配置。 |
| `DarwinHostApiImpl.startPacketTunnel` / `stopPacketTunnel` | Flutter -> Darwin | 准备 `NETunnelProviderManager` 并控制 Packet Tunnel 生命周期。 |
| `PacketTunnelProvider.startTunnel` / `stopTunnel` | 系统 -> Extension | Apple 系统网络扩展入口；负责网络设置、utun 解析、Xray 启停与指标采样。 |
| `DarwinFlutterApi.onPacketTunnelStateChanged` / `onPacketTunnelError` | Darwin -> Flutter | 将系统侧状态变化和错误回推到 Dart。 |

### Android

| 接口 | 方向 | 说明 |
| --- | --- | --- |
| `MainActivity` MethodChannel handlers | Flutter -> Android | 负责保存 profile、请求 VPN 权限、启动/停止 `VpnService`、读取状态。 |
| `PacketTunnelController` | Activity/Service 间共享 | 负责 profile 持久化、权限状态、服务启动状态与错误信息。 |
| `XstreamPacketTunnelService` | Android 系统 -> Service | 真正建立 TUN 接口、补齐 Xray TUN inbound 并调用 JNI/Go bridge。 |
| `NativePacketTunnelBridge` / JNI | Kotlin -> C++ -> Go | 负责 `nativeStartTunnel/nativeStopTunnel/nativeFreeTunnel` 句柄调用。 |

### Desktop Hosts

| 接口 | 方向 | 说明 |
| --- | --- | --- |
| macOS `AppDelegate` + `NativeBridge+*.swift` | Flutter <-> macOS | 负责菜单栏、登录启动、配置写入、系统代理与辅助操作。 |
| Linux `MyApplication` | Flutter <-> GTK Host | 负责窗口宿主、命令行参数、最小化行为。 |
| Windows `FlutterWindow` / `Win32Window` | Flutter <-> Win32 Host | 负责托盘图标、原生菜单、单实例与窗口生命周期。 |


## 已知约束 / 副作用 / 线程与平台注意点

- 文档只覆盖当前仓库自研代码，不展开第三方依赖、Pods、Flutter/平台生成注册器和 `*.g.dart` 内部实现。
- 带 `PacketTunnel`、`NativeBridge`、`go_core`、`Session`、`sync`、`sqlite`、`SharedPreferences`、`UserDefaults` 的符号通常伴随 I/O、系统 API 或跨线程副作用，修改前应先核对调用链。
- Swift / Kotlin / Go 的错误返回风格不同：Swift 多为 `throws`/`Result`，Kotlin 以字符串状态和 `Map` 回传，Go FFI 以 `*C.char` 或 `C.int` 作为桥接结果。
- 本页的“主要调用方或用途”列用于帮助定位主调用闭环，不代表唯一调用点；需要精确调用图时仍应回到源码。
