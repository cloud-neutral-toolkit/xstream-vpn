# Flutter 桥接与调用契约参考

本页按“设计意图与边界 → 文件职责 → 类型清单 → 函数/方法清单 → 接口契约 → 约束与副作用”的顺序整理当前仓库实现。描述以当前主路径为准，不保留历史兼容叙述。

函数与方法表以当前手写实现的签名库存为主，个别复杂多行声明会做适度压缩；遇到不规则泛型、闭包或平台回调时，以源码中的完整签名为最终依据。

## 设计意图与边界

覆盖 Dart 侧 MethodChannel、Pigeon、FFI 绑定和桥接状态对象。重点是跨层调用入口、参数封送和资源释放约定。

## 文件列表与职责

| 文件 | 职责 | 说明 |
| --- | --- | --- |
| lib/bindings/bridge_bindings.dart | Dart FFI typedef 与动态库绑定封装。 | 手写实现，纳入本页覆盖范围。 |
| lib/utils/native_bridge.dart | Dart 侧原生桥接总入口，封装 MethodChannel、Pigeon 与 FFI 调用。 | 手写实现，纳入本页覆盖范围。 |
| lib/xray_ffi.dart | iOS 进程内 Xray 直接 FFI 入口。 | 手写实现，纳入本页覆盖范围。 |

## 关键数据结构 / 类 / 枚举 / typedef / extension

| 符号 | 类型 | 所在文件 | 说明 |
| --- | --- | --- | --- |
| StartNodeServiceNative | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| StartNodeServiceDart | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| CreateWindowsServiceNative | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| CreateWindowsServiceDart | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| StopNodeServiceNative | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| StopNodeServiceDart | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| WriteConfigFilesNative | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| WriteConfigFilesDart | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| CheckNodeStatusNative | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| CheckNodeStatusDart | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| PerformActionNative | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| PerformActionDart | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| FreeCStringNative | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| FreeCStringDart | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| IsXrayDownloadingNative | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| IsXrayDownloadingDart | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| StartXrayNative | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| StartXrayDart | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| StopXrayNative | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| StopXrayDart | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DesktopIntegrationCommandNative | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DesktopIntegrationCommandDart | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| InitTrayNative | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| InitTrayDart | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| GetDesktopRuntimeSnapshotNative | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| GetDesktopRuntimeSnapshotDart | typedef | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| BridgeBindings | class | lib/bindings/bridge_bindings.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| NativeBridge | class | lib/utils/native_bridge.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| LinuxDesktopIntegrationStatus | class | lib/utils/native_bridge.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| _DarwinFlutterApiImpl | class | lib/utils/native_bridge.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| PacketTunnelStatus | class | lib/utils/native_bridge.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DesktopRuntimeSnapshot | class | lib/utils/native_bridge.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| PacketTunnelMetricsSnapshot | class | lib/utils/native_bridge.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| XrayFFI | class | lib/xray_ffi.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |

## 函数与方法清单

### `lib/bindings/bridge_bindings.dart`

Dart FFI typedef 与动态库绑定封装。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `lib/utils/native_bridge.dart`

Dart 侧原生桥接总入口，封装 MethodChannel、Pigeon 与 FFI 调用。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| _isDesktop | lib/utils/native_bridge.dart / NativeBridge | 无 | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _isDarwin | lib/utils/native_bridge.dart / NativeBridge | 无 | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _isMobile | lib/utils/native_bridge.dart / NativeBridge | 无 | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| isTunnelStartAcceptedMessage | lib/utils/native_bridge.dart / NativeBridge | String? message | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| looksLikePacketTunnelPermissionIssue | lib/utils/native_bridge.dart / NativeBridge | String? message | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _platformErrorSummary | lib/utils/native_bridge.dart / NativeBridge | PlatformException e | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _openLib | lib/utils/native_bridge.dart / NativeBridge | 无 | ffi.DynamicLibrary | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| isTunMode | lib/utils/native_bridge.dart / NativeBridge | 无 | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| startNodeForTunnel | lib/utils/native_bridge.dart / NativeBridge | String nodeName | Future<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| stopNodeForTunnel | lib/utils/native_bridge.dart / NativeBridge | 无 | Future<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| startNodeService | lib/utils/native_bridge.dart / NativeBridge | String nodeName | Future<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| stopNodeService | lib/utils/native_bridge.dart / NativeBridge | String nodeName | Future<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _runSerializedConnectionOp | lib/utils/native_bridge.dart / NativeBridge | ( | return | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _buildBootstrapNodeConfigString | lib/utils/native_bridge.dart / NativeBridge | {required bool isTunMode} | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _normalizeConfigToken | lib/utils/native_bridge.dart / NativeBridge | String raw | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _ensureDarwinFlutterApiReady | lib/utils/native_bridge.dart / NativeBridge | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| startPacketTunnel | lib/utils/native_bridge.dart / NativeBridge | 无 | Future<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| stopPacketTunnel | lib/utils/native_bridge.dart / NativeBridge | 无 | Future<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _looksLikeIosPluginRegistrationError | lib/utils/native_bridge.dart / NativeBridge | String error | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| startXray | lib/utils/native_bridge.dart / NativeBridge | String configJson | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| stopXray | lib/utils/native_bridge.dart / NativeBridge | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| onPacketTunnelError | lib/utils/native_bridge.dart / _DarwinFlutterApiImpl | String code, String message | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| onPacketTunnelStateChanged | lib/utils/native_bridge.dart / _DarwinFlutterApiImpl | darwin_host.TunnelStatus status | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| onSystemWillRestart | lib/utils/native_bridge.dart / _DarwinFlutterApiImpl | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| onSystemWillShutdown | lib/utils/native_bridge.dart / _DarwinFlutterApiImpl | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |
| onSystemWillSleep | lib/utils/native_bridge.dart / _DarwinFlutterApiImpl | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 系统 API / MethodChannel / FFI / NetworkExtension。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/xray_ffi.dart`

iOS 进程内 Xray 直接 FFI 入口。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| start | lib/xray_ffi.dart / XrayFFI | String jsonConfig | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 见当前主流程。 |
| stop | lib/xray_ffi.dart / XrayFFI | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 见当前主流程。 |

## 接口契约与跨层依赖

### MethodChannel

| Channel | 方向 | 主要方法 | 返回约定 |
| --- | --- | --- | --- |
| `com.xstream/native` | Flutter -> 原生 | `writeConfigFiles`、`startNodeService`、`stopNodeService`、`checkNodeStatus`、`performAction`、`savePacketTunnelProfile`、`startPacketTunnel`、`stopPacketTunnel`、`getPacketTunnelStatus`、`openVpnSettings`、`setSystemProxy` | 以 `String` 成功消息、布尔值、状态字典或 `FlutterError`/平台错误字符串返回。 |
| `com.xstream/logger` | 原生 -> Flutter | `log` | 原生侧推送日志文本，Flutter 侧写入 `LogConsole` / `LogStore`。 |

### Pigeon / Darwin Host API

| 接口 | Dart 调用面 | 宿主实现 |
| --- | --- | --- |
| `DarwinHostApi` | `lib/utils/native_bridge.dart` 中的 `darwin_host.DarwinHostApi` | `darwin/MacosHostApi.swift` 的 `DarwinHostApiImpl` |
| `DarwinFlutterApi` | `lib/utils/native_bridge.dart` 中 `_DarwinFlutterApiImpl` | Darwin 宿主在系统事件与 Packet Tunnel 状态变化时回调 Flutter |

### FFI

| Dart 绑定 | Go 导出符号 | 约定 |
| --- | --- | --- |
| `BridgeBindings.startNodeService` | `StartNodeService` | `char*` 入参是服务名；返回 `char*` 结果后需调用 `FreeCString` 释放。 |
| `BridgeBindings.stopNodeService` | `StopNodeService` | 语义同上。 |
| `BridgeBindings.writeConfigFiles` | `WriteConfigFiles` | 传入 7 个 C 字符串路径/内容参数，返回结果字符串。 |
| `BridgeBindings.performAction` | `PerformAction` | 传入 action 与 password；返回结果字符串。 |
| `BridgeBindings.startXray` / `stopXray` | `StartXray` / `StopXray` | 负责桌面或 iOS 进程内 Xray 生命周期。 |
| `BridgeBindings.desktopIntegrationCommand` | `DesktopIntegrationCommand` | Linux 桌面集成专用 JSON 命令通道。 |
| `BridgeBindings.getDesktopRuntimeSnapshot` | `GetDesktopRuntimeSnapshot` | 可选导出；部分平台返回运行时快照 JSON。 |
| `XrayFFI.start` / `stop` | `StartXray` / `StopXray` | iOS 进程内直接符号查找；调用方负责释放 Dart 侧配置入参，不负责释放返回指针。 |


## 已知约束 / 副作用 / 线程与平台注意点

- 文档只覆盖当前仓库自研代码，不展开第三方依赖、Pods、Flutter/平台生成注册器和 `*.g.dart` 内部实现。
- 带 `PacketTunnel`、`NativeBridge`、`go_core`、`Session`、`sync`、`sqlite`、`SharedPreferences`、`UserDefaults` 的符号通常伴随 I/O、系统 API 或跨线程副作用，修改前应先核对调用链。
- Swift / Kotlin / Go 的错误返回风格不同：Swift 多为 `throws`/`Result`，Kotlin 以字符串状态和 `Map` 回传，Go FFI 以 `*C.char` 或 `C.int` 作为桥接结果。
- 本页的“主要调用方或用途”列用于帮助定位主调用闭环，不代表唯一调用点；需要精确调用图时仍应回到源码。
