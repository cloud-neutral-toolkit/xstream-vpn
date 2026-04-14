# Go Core FFI 参考

本页按“设计意图与边界 → 文件职责 → 类型清单 → 函数/方法清单 → 接口契约 → 约束与副作用”的顺序整理当前仓库实现。描述以当前主路径为准，不保留历史兼容叙述。

函数与方法表以当前手写实现的签名库存为主，个别复杂多行声明会做适度压缩；遇到不规则泛型、闭包或平台回调时，以源码中的完整签名为最终依据。

## 设计意图与边界

覆盖 Go FFI 导出层与平台桥接实现。重点是导出函数、错误字符串、句柄管理、桌面集成与运行时快照。

## 文件列表与职责

| 文件 | 职责 | 说明 |
| --- | --- | --- |
| go_core/bridge.go | Go FFI/平台桥接文件，负责 `bridge` 对应的平台实现或公共导出层。 | 手写实现，纳入本页覆盖范围。 |
| go_core/bridge_android.go | Go FFI/平台桥接文件，负责 `bridge_android` 对应的平台实现或公共导出层。 | 手写实现，纳入本页覆盖范围。 |
| go_core/bridge_darwin.go | Go FFI/平台桥接文件，负责 `bridge_darwin` 对应的平台实现或公共导出层。 | 手写实现，纳入本页覆盖范围。 |
| go_core/bridge_ios.go | Go FFI/平台桥接文件，负责 `bridge_ios` 对应的平台实现或公共导出层。 | 手写实现，纳入本页覆盖范围。 |
| go_core/bridge_linux.go | Go FFI/平台桥接文件，负责 `bridge_linux` 对应的平台实现或公共导出层。 | 手写实现，纳入本页覆盖范围。 |
| go_core/bridge_windows.go | Go FFI/平台桥接文件，负责 `bridge_windows` 对应的平台实现或公共导出层。 | 手写实现，纳入本页覆盖范围。 |
| go_core/constants.go | Go FFI/平台桥接文件，负责 `constants` 对应的平台实现或公共导出层。 | 手写实现，纳入本页覆盖范围。 |

## 关键数据结构 / 类 / 枚举 / typedef / extension

本子系统没有单独的手写类型定义，主要由函数、模板或宿主壳层构成。

## 函数与方法清单

### `go_core/bridge.go`

Go FFI/平台桥接文件，负责 `bridge` 对应的平台实现或公共导出层。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| FreeCString | go_core/bridge.go / bridge.go | str *C.char | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| main | go_core/bridge.go / bridge.go | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |

### `go_core/bridge_android.go`

Go FFI/平台桥接文件，负责 `bridge_android` 对应的平台实现或公共导出层。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| androidStartXrayInternal | go_core/bridge_android.go / bridge_android.go | cfgData []byte | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| androidStopXrayInternal | go_core/bridge_android.go / bridge_android.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| clearAndroidNodeRegistry | go_core/bridge_android.go / bridge_android.go | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| WriteConfigFiles | go_core/bridge_android.go / bridge_android.go | xrayPathC, xrayContentC, servicePathC, serviceContentC, vpnPathC, vpnContentC, passwordC *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StartNodeService | go_core/bridge_android.go / bridge_android.go | name *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StopNodeService | go_core/bridge_android.go / bridge_android.go | name *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| CheckNodeStatus | go_core/bridge_android.go / bridge_android.go | name *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StartXray | go_core/bridge_android.go / bridge_android.go | configC *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StopXray | go_core/bridge_android.go / bridge_android.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StartXrayTunnel | go_core/bridge_android.go / bridge_android.go | configC *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StartXrayTunnelWithFd | go_core/bridge_android.go / bridge_android.go | configC *C.char, tunFd C.int32_t | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| SubmitInboundPacket | go_core/bridge_android.go / bridge_android.go | handle C.longlong, data *C.uint8_t, length C.int32_t, protocol C.int32_t | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StopXrayTunnel | go_core/bridge_android.go / bridge_android.go | handle C.longlong | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| FreeXrayTunnel | go_core/bridge_android.go / bridge_android.go | handle C.longlong | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| CreateWindowsService | go_core/bridge_android.go / bridge_android.go | name, execPath, configPath *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| PerformAction | go_core/bridge_android.go / bridge_android.go | action, password *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| IsXrayDownloading | go_core/bridge_android.go / bridge_android.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| main | go_core/bridge_android.go / bridge_android.go | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |

### `go_core/bridge_darwin.go`

Go FFI/平台桥接文件，负责 `bridge_darwin` 对应的平台实现或公共导出层。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| FreeCString | go_core/bridge_darwin.go / bridge_darwin.go | str *C.char | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |

### `go_core/bridge_ios.go`

Go FFI/平台桥接文件，负责 `bridge_ios` 对应的平台实现或公共导出层。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| setTunnelLastError | go_core/bridge_ios.go / bridge_ios.go | msg string | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| getTunnelLastError | go_core/bridge_ios.go / bridge_ios.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| injectSockoptInterface | go_core/bridge_ios.go / bridge_ios.go | cfgData []byte, iface string | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| startXrayInternal | go_core/bridge_ios.go / bridge_ios.go | cfgData []byte | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| stopXrayInternal | go_core/bridge_ios.go / bridge_ios.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| clearNodeRegistry | go_core/bridge_ios.go / bridge_ios.go | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| WriteConfigFiles | go_core/bridge_ios.go / bridge_ios.go | xrayPathC, xrayContentC, servicePathC, serviceContentC, vpnPathC, vpnContentC, passwordC *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StartNodeService | go_core/bridge_ios.go / bridge_ios.go | name *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StopNodeService | go_core/bridge_ios.go / bridge_ios.go | name *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| CheckNodeStatus | go_core/bridge_ios.go / bridge_ios.go | name *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StartXray | go_core/bridge_ios.go / bridge_ios.go | configC *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StopXray | go_core/bridge_ios.go / bridge_ios.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StartXrayTunnelWithFd | go_core/bridge_ios.go / bridge_ios.go | configC *C.char, fd C.int, interfaceC *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| GetLastXrayTunnelError | go_core/bridge_ios.go / bridge_ios.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StopXrayTunnel | go_core/bridge_ios.go / bridge_ios.go | handle C.longlong | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| FreeXrayTunnel | go_core/bridge_ios.go / bridge_ios.go | handle C.longlong | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| CreateWindowsService | go_core/bridge_ios.go / bridge_ios.go | name, execPath, configPath *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| PerformAction | go_core/bridge_ios.go / bridge_ios.go | action, password *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| IsXrayDownloading | go_core/bridge_ios.go / bridge_ios.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| main | go_core/bridge_ios.go / bridge_ios.go | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |

### `go_core/bridge_linux.go`

Go FFI/平台桥接文件，负责 `bridge_linux` 对应的平台实现或公共导出层。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| getMainWin | go_core/bridge_linux.go / bridge_linux.go | 无 | Window | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| findWindow | go_core/bridge_linux.go / bridge_linux.go | const char* name | Window | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| isIconic | go_core/bridge_linux.go / bridge_linux.go | 无 | int | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| hideWindow | go_core/bridge_linux.go / bridge_linux.go | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| showWindow | go_core/bridge_linux.go / bridge_linux.go | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| startXrayInternal | go_core/bridge_linux.go / bridge_linux.go | cfgData []byte | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| stopXrayInternal | go_core/bridge_linux.go / bridge_linux.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| clearNodeRegistry | go_core/bridge_linux.go / bridge_linux.go | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| desktopIntegrationResult | go_core/bridge_linux.go / bridge_linux.go | resp desktopIntegrationResponse | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| detectDesktopEnvironment | go_core/bridge_linux.go / bridge_linux.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| runOutput | go_core/bridge_linux.go / bridge_linux.go | name string, args ...string) (string, error | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| linuxConfigDir | go_core/bridge_linux.go / bridge_linux.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| linuxAutostartDesktopFile | go_core/bridge_linux.go / bridge_linux.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| linuxProxySnapshotPath | go_core/bridge_linux.go / bridge_linux.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| linuxTunnelHelperPath | go_core/bridge_linux.go / bridge_linux.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| notifyDesktop | go_core/bridge_linux.go / bridge_linux.go | title, body string | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| setAutostartEnabled | go_core/bridge_linux.go / bridge_linux.go | enable bool, execPath string | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| isAutostartEnabled | go_core/bridge_linux.go / bridge_linux.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| writeProxySnapshot | go_core/bridge_linux.go / bridge_linux.go | data map[string]string | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| readProxySnapshot | go_core/bridge_linux.go / bridge_linux.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| gsettingsGet | go_core/bridge_linux.go / bridge_linux.go | schema string, key string | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| gsettingsSet | go_core/bridge_linux.go / bridge_linux.go | schema string, key string, value string | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| kdeConfigTool | go_core/bridge_linux.go / bridge_linux.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| kreadConfigTool | go_core/bridge_linux.go / bridge_linux.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| reloadKDEProxy | go_core/bridge_linux.go / bridge_linux.go | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| setLinuxProxy | go_core/bridge_linux.go / bridge_linux.go | enable bool | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| defaultIfEmpty | go_core/bridge_linux.go / bridge_linux.go | value string, fallback string | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| handleTunnelHelper | go_core/bridge_linux.go / bridge_linux.go | action string, mode string) (string, error | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| DesktopIntegrationCommand | go_core/bridge_linux.go / bridge_linux.go | requestC *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| WriteConfigFiles | go_core/bridge_linux.go / bridge_linux.go | xrayPathC, xrayContentC, servicePathC, serviceContentC, vpnPathC, vpnContentC, passwordC *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StartNodeService | go_core/bridge_linux.go / bridge_linux.go | name *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StopNodeService | go_core/bridge_linux.go / bridge_linux.go | name *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| CheckNodeStatus | go_core/bridge_linux.go / bridge_linux.go | name *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| PerformAction | go_core/bridge_linux.go / bridge_linux.go | action, password *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| IsXrayDownloading | go_core/bridge_linux.go / bridge_linux.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StartXray | go_core/bridge_linux.go / bridge_linux.go | configC *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StopXray | go_core/bridge_linux.go / bridge_linux.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| monitorMinimize | go_core/bridge_linux.go / bridge_linux.go | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| InitTray | go_core/bridge_linux.go / bridge_linux.go | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| func | go_core/bridge_linux.go / bridge_linux.go | 无 | go | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| func | go_core/bridge_linux.go / bridge_linux.go | 无 | go | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |

### `go_core/bridge_windows.go`

Go FFI/平台桥接文件，负责 `bridge_windows` 对应的平台实现或公共导出层。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| startXrayInternal | go_core/bridge_windows.go / bridge_windows.go | cfgData []byte | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| stopXrayInternal | go_core/bridge_windows.go / bridge_windows.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| clearNodeRegistry | go_core/bridge_windows.go / bridge_windows.go | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| filetimeToUint64 | go_core/bridge_windows.go / bridge_windows.go | value windows.Filetime | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| currentWorkingSetBytes | go_core/bridge_windows.go / bridge_windows.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| currentCPUPercent | go_core/bridge_windows.go / bridge_windows.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| WriteConfigFiles | go_core/bridge_windows.go / bridge_windows.go | xrayPath, xrayContent, servicePath, serviceContent, vpnPath, vpnContent, password *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| writeConfigFile | go_core/bridge_windows.go / bridge_windows.go | pathC, contentC *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| updateVpnNodesConfig | go_core/bridge_windows.go / bridge_windows.go | pathC, contentC *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| CreateWindowsService | go_core/bridge_windows.go / bridge_windows.go | name, execPath, configPath *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StartNodeService | go_core/bridge_windows.go / bridge_windows.go | name *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StopNodeService | go_core/bridge_windows.go / bridge_windows.go | name *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| CheckNodeStatus | go_core/bridge_windows.go / bridge_windows.go | name *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| PerformAction | go_core/bridge_windows.go / bridge_windows.go | action, password *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| IsXrayDownloading | go_core/bridge_windows.go / bridge_windows.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StartXray | go_core/bridge_windows.go / bridge_windows.go | configC *C.char | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| StopXray | go_core/bridge_windows.go / bridge_windows.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| GetDesktopRuntimeSnapshot | go_core/bridge_windows.go / bridge_windows.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| findMainWindow | go_core/bridge_windows.go / bridge_windows.go | 无 | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| showWindow | go_core/bridge_windows.go / bridge_windows.go | h windows.Handle, cmd int32 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| getPlacement | go_core/bridge_windows.go / bridge_windows.go | h windows.Handle, wp *windowPlacement | Void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| monitorMinimize | go_core/bridge_windows.go / bridge_windows.go | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| getPlacement | go_core/bridge_windows.go / bridge_windows.go | windowHandle, &wp | if | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| onTrayReady | go_core/bridge_windows.go / bridge_windows.go | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| func | go_core/bridge_windows.go / bridge_windows.go | 无 | go | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| InitTray | go_core/bridge_windows.go / bridge_windows.go | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| func | go_core/bridge_windows.go / bridge_windows.go | 无 | go | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |
| main | go_core/bridge_windows.go / bridge_windows.go | 无 | func | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 调用 libxray、系统服务、桌面集成或 C FFI。 | 由 Dart FFI、Swift Packet Tunnel 或 JNI/宿主层调用。 |

### `go_core/constants.go`

Go FFI/平台桥接文件，负责 `constants` 对应的平台实现或公共导出层。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

## 接口契约与跨层依赖

| 契约 | 说明 |
| --- | --- |
| `FreeCString` | 所有返回 `*C.char` 的导出函数都应由 Dart/Swift/Kotlin/C++ 调用方在读取后释放。 |
| `StartXray` / `StopXray` | 负责单实例 Xray 引擎启停；平台层不应重复持有旧句柄。 |
| `StartXrayTunnel*` / `StopXrayTunnel` / `FreeXrayTunnel` | Android/iOS/macOS Packet Tunnel 句柄生命周期接口；成功返回 `handle > 0`，失败时通过错误字符串补充原因。 |
| `WriteConfigFiles` | 将配置文件、服务文件和节点快照落盘；桌面平台与 Android 共享“路径 + 内容”风格入参。 |
| `DesktopIntegrationCommand` | Linux 专用扩展接口，使用 JSON 请求/响应承载托盘、自启动、代理等桌面能力。 |


## 已知约束 / 副作用 / 线程与平台注意点

- 文档只覆盖当前仓库自研代码，不展开第三方依赖、Pods、Flutter/平台生成注册器和 `*.g.dart` 内部实现。
- 带 `PacketTunnel`、`NativeBridge`、`go_core`、`Session`、`sync`、`sqlite`、`SharedPreferences`、`UserDefaults` 的符号通常伴随 I/O、系统 API 或跨线程副作用，修改前应先核对调用链。
- Swift / Kotlin / Go 的错误返回风格不同：Swift 多为 `throws`/`Result`，Kotlin 以字符串状态和 `Map` 回传，Go FFI 以 `*C.char` 或 `C.int` 作为桥接结果。
- 本页的“主要调用方或用途”列用于帮助定位主调用闭环，不代表唯一调用点；需要精确调用图时仍应回到源码。
