# Flutter 运行时服务参考

本页按“设计意图与边界 → 文件职责 → 类型清单 → 函数/方法清单 → 接口契约 → 约束与副作用”的顺序整理当前仓库实现。描述以当前主路径为准，不保留历史兼容叙述。

函数与方法表以当前手写实现的签名库存为主，个别复杂多行声明会做适度压缩；遇到不规则泛型、闭包或平台回调时，以源码中的完整签名为最终依据。

## 设计意图与边界

覆盖业务服务、全局配置、模板、日志与运行时辅助工具。重点是数据模型、持久化、同步、DNS、会话、遥测和配置生成路径。

## 文件列表与职责

| 文件 | 职责 | 说明 |
| --- | --- | --- |
| lib/services/account_usage_service.dart | 业务/运行时 service 文件，负责 `account_usage_service` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/app_version_service.dart | 业务/运行时 service 文件，负责 `app_version_service` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/global_proxy_service.dart | 业务/运行时 service 文件，负责 `global_proxy_service` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/permission_guide_service.dart | 业务/运行时 service 文件，负责 `permission_guide_service` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/sqlite_node_store.dart | 业务/运行时 service 文件，负责 `sqlite_node_store` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/tun_settings_service.dart | 业务/运行时 service 文件，负责 `tun_settings_service` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/vpn_config_service.dart | 业务/运行时 service 文件，负责 `vpn_config_service` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/desktop/desktop_platform_capabilities.dart | 业务/运行时 service 文件，负责 `desktop_platform_capabilities` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/dns/dns_control_plane.dart | 业务/运行时 service 文件，负责 `dns_control_plane` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/experimental/experimental_features.dart | 业务/运行时 service 文件，负责 `experimental_features` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/mcp/runtime_mcp_service.dart | 业务/运行时 service 文件，负责 `runtime_mcp_service` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/session/session_manager.dart | 业务/运行时 service 文件，负责 `session_manager` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/sync/desktop_sync_service.dart | 业务/运行时 service 文件，负责 `desktop_sync_service` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/sync/device_fingerprint.dart | 业务/运行时 service 文件，负责 `device_fingerprint` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/sync/sync_crypto.dart | 业务/运行时 service 文件，负责 `sync_crypto` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/sync/sync_payload.dart | 业务/运行时 service 文件，负责 `sync_payload` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/sync/sync_state.dart | 业务/运行时 service 文件，负责 `sync_state` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/sync/xray_config_writer.dart | 业务/运行时 service 文件，负责 `xray_config_writer` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/services/telemetry/telemetry_service.dart | 业务/运行时 service 文件，负责 `telemetry_service` 相关状态、I/O 或业务逻辑。 | 手写实现，纳入本页覆盖范围。 |
| lib/utils/app_logger.dart | 统一应用日志写入入口。 | 手写实现，纳入本页覆盖范围。 |
| lib/utils/global_config.dart | 全局运行态、应用支持目录路径和共享配置入口。 | 手写实现，纳入本页覆盖范围。 |
| lib/utils/log_store.dart | 日志缓存存储。 | 手写实现，纳入本页覆盖范围。 |
| lib/utils/tun_config_guard.dart | Darwin TUN inbound 防御性字段清洗。 | 手写实现，纳入本页覆盖范围。 |
| lib/utils/validators.dart | 简单参数校验辅助函数。 | 手写实现，纳入本页覆盖范围。 |
| lib/templates/xray_config_template.dart | 配置模板文件，向 `VpnConfig` 等服务提供 Xray / service 文本模板。 | 手写实现，纳入本页覆盖范围。 |
| lib/templates/xray_service_linux_template.dart | 配置模板文件，向 `VpnConfig` 等服务提供 Xray / service 文本模板。 | 手写实现，纳入本页覆盖范围。 |
| lib/templates/xray_service_macos_template.dart | 配置模板文件，向 `VpnConfig` 等服务提供 Xray / service 文本模板。 | 手写实现，纳入本页覆盖范围。 |
| lib/templates/xray_service_windows_template.dart | 配置模板文件，向 `VpnConfig` 等服务提供 Xray / service 文本模板。 | 手写实现，纳入本页覆盖范围。 |

## 关键数据结构 / 类 / 枚举 / typedef / extension

| 符号 | 类型 | 所在文件 | 说明 |
| --- | --- | --- | --- |
| AccountUsageSummary | class | lib/services/account_usage_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AccountUsageService | class | lib/services/account_usage_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppVersionInfo | class | lib/services/app_version_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppVersionService | class | lib/services/app_version_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| GlobalProxyService | class | lib/services/global_proxy_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| PermissionCheckItem | class | lib/services/permission_guide_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| PermissionGuideReport | class | lib/services/permission_guide_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| PermissionGuideService | class | lib/services/permission_guide_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| SqliteNodeStore | class | lib/services/sqlite_node_store.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| TEXT | protocol | lib/services/sqlite_node_store.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| TunSettingsService | class | lib/services/tun_settings_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| VlessUriProfile | class | lib/services/vpn_config_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| VpnNode | class | lib/services/vpn_config_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| VpnConfig | class | lib/services/vpn_config_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DesktopPlatformCapabilities | class | lib/services/desktop/desktop_platform_capabilities.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| ResolverTransport | enum | lib/services/dns/dns_control_plane.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| ResolverServerPolicy | class | lib/services/dns/dns_control_plane.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| FakeDnsPolicy | class | lib/services/dns/dns_control_plane.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DomainSets | class | lib/services/dns/dns_control_plane.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DnsPolicy | class | lib/services/dns/dns_control_plane.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| RoutePolicy | class | lib/services/dns/dns_control_plane.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DnsControlPlane | class | lib/services/dns/dns_control_plane.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| ExperimentalFeatures | class | lib/services/experimental/experimental_features.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| RuntimeMcpService | class | lib/services/mcp/runtime_mcp_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| SessionStatus | enum | lib/services/session/session_manager.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| LoginResult | class | lib/services/session/session_manager.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| SessionManager | class | lib/services/session/session_manager.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DesktopSyncResult | class | lib/services/sync/desktop_sync_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| SyncedNodeMetadata | class | lib/services/sync/desktop_sync_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DesktopSyncService | class | lib/services/sync/desktop_sync_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DeviceFingerprint | class | lib/services/sync/device_fingerprint.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| SyncCrypto | class | lib/services/sync/sync_crypto.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| SyncRequest | class | lib/services/sync/sync_payload.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| SyncResponseStatus | enum | lib/services/sync/sync_payload.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| SyncResponse | class | lib/services/sync/sync_payload.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| SyncSummary | class | lib/services/sync/sync_state.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| SyncStateStore | class | lib/services/sync/sync_state.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| XrayConfigWriter | class | lib/services/sync/xray_config_writer.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| TelemetryService | class | lib/services/telemetry/telemetry_service.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| GlobalState | class | lib/utils/global_config.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DnsTransportMode | enum | lib/utils/global_config.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DnsPreset | class | lib/utils/global_config.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| DnsConfig | class | lib/utils/global_config.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| XhttpAdvancedConfig | class | lib/utils/global_config.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| GlobalApplicationConfig | class | lib/utils/global_config.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| LogStore | class | lib/utils/log_store.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| TunConfigGuardResult | class | lib/utils/tun_config_guard.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |

## 函数与方法清单

### `lib/services/account_usage_service.dart`

业务/运行时 service 文件，负责 `account_usage_service` 相关状态、I/O 或业务逻辑。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `lib/services/app_version_service.dart`

业务/运行时 service 文件，负责 `app_version_service` 相关状态、I/O 或业务逻辑。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| shortLabel | lib/services/app_version_service.dart / AppVersionInfo | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| currentVersion | lib/services/app_version_service.dart / AppVersionService | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| buildNumber | lib/services/app_version_service.dart / AppVersionService | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| shortLabel | lib/services/app_version_service.dart / AppVersionService | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/services/global_proxy_service.dart`

业务/运行时 service 文件，负责 `global_proxy_service` 相关状态、I/O 或业务逻辑。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `lib/services/permission_guide_service.dart`

业务/运行时 service 文件，负责 `permission_guide_service` 相关状态、I/O 或业务逻辑。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| allPassed | lib/services/permission_guide_service.dart / PermissionGuideReport | 无 | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| looksLikePacketTunnelPermissionDenied | lib/services/permission_guide_service.dart / PermissionGuideService | String? message | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/services/sqlite_node_store.dart`

业务/运行时 service 文件，负责 `sqlite_node_store` 相关状态、I/O 或业务逻辑。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `lib/services/tun_settings_service.dart`

业务/运行时 service 文件，负责 `tun_settings_service` 相关状态、I/O 或业务逻辑。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `lib/services/vpn_config_service.dart`

业务/运行时 service 文件，负责 `vpn_config_service` 相关状态、I/O 或业务逻辑。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| toJson | lib/services/vpn_config_service.dart / VpnNode | 无 | Map<String, dynamic> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |
| nodes | lib/services/vpn_config_service.dart / VpnConfig | 无 | List<VpnNode> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |
| getNodeByName | lib/services/vpn_config_service.dart / VpnConfig | String name | VpnNode? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |
| addNode | lib/services/vpn_config_service.dart / VpnConfig | VpnNode node | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |
| removeNode | lib/services/vpn_config_service.dart / VpnConfig | String name | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |
| updateNode | lib/services/vpn_config_service.dart / VpnConfig | VpnNode updated | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |
| exportToJson | lib/services/vpn_config_service.dart / VpnConfig | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _nullableValue | lib/services/vpn_config_service.dart / VpnConfig | String? value | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _hasValue | lib/services/vpn_config_service.dart / VpnConfig | String? value | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _normalizePath | lib/services/vpn_config_service.dart / VpnConfig | String? value | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _buildSecureDnsConfig | lib/services/vpn_config_service.dart / VpnConfig | 无 | Map<String, dynamic> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _buildFakeDnsConfig | lib/services/vpn_config_service.dart / VpnConfig | 无 | List<Map<String, dynamic>>? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/services/desktop/desktop_platform_capabilities.dart`

业务/运行时 service 文件，负责 `desktop_platform_capabilities` 相关状态、I/O 或业务逻辑。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| current | lib/services/desktop/desktop_platform_capabilities.dart / DesktopPlatformCapabilities | 无 | DesktopPlatformCapabilities | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/services/dns/dns_control_plane.dart`

业务/运行时 service 文件，负责 `dns_control_plane` 相关状态、I/O 或业务逻辑。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| toXrayDnsServer | lib/services/dns/dns_control_plane.dart / ResolverServerPolicy | 无 | Map<String, dynamic> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| buildDnsServers | lib/services/dns/dns_control_plane.dart / DnsPolicy | 无 | List<Map<String, dynamic>> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| toXrayDnsConfig | lib/services/dns/dns_control_plane.dart / DnsPolicy | 无 | Map<String, dynamic> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| tunDnsCidrs | lib/services/dns/dns_control_plane.dart / RoutePolicy | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| directResolvers | lib/services/dns/dns_control_plane.dart / DnsControlPlane | 无 | List<ResolverServerPolicy> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| proxyResolvers | lib/services/dns/dns_control_plane.dart / DnsControlPlane | 无 | List<ResolverServerPolicy> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| fakeDns | lib/services/dns/dns_control_plane.dart / DnsControlPlane | 无 | FakeDnsPolicy | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| domainSets | lib/services/dns/dns_control_plane.dart / DnsControlPlane | 无 | DomainSets | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| tunnelDnsServers4 | lib/services/dns/dns_control_plane.dart / DnsControlPlane | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| tunnelDnsServers6 | lib/services/dns/dns_control_plane.dart / DnsControlPlane | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| buildDnsServers | lib/services/dns/dns_control_plane.dart / DnsControlPlane | 无 | List<Map<String, dynamic>> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| tunDnsCidrs | lib/services/dns/dns_control_plane.dart / DnsControlPlane | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| sniffingDestOverride | lib/services/dns/dns_control_plane.dart / DnsControlPlane | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/services/experimental/experimental_features.dart`

业务/运行时 service 文件，负责 `experimental_features` 相关状态、I/O 或业务逻辑。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `lib/services/mcp/runtime_mcp_service.dart`

业务/运行时 service 文件，负责 `runtime_mcp_service` 相关状态、I/O 或业务逻辑。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| _buildLauncherFromExecutable | lib/services/mcp/runtime_mcp_service.dart / RuntimeMcpService | String executablePath | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/services/session/session_manager.dart`

业务/运行时 service 文件，负责 `session_manager` 相关状态、I/O 或业务逻辑。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| isLoggedIn | lib/services/session/session_manager.dart / SessionManager | 无 | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| isMfaRequired | lib/services/session/session_manager.dart / SessionManager | 无 | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| cookie | lib/services/session/session_manager.dart / SessionManager | 无 | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| sessionToken | lib/services/session/session_manager.dart / SessionManager | 无 | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| mfaTicket | lib/services/session/session_manager.dart / SessionManager | 无 | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _normalizeBaseUrl | lib/services/session/session_manager.dart / SessionManager | String url | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| buildEndpoint | lib/services/session/session_manager.dart / SessionManager | String path | Uri | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _parseBody | lib/services/session/session_manager.dart / SessionManager | String body | Map<String, dynamic> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _isMfaRequired | lib/services/session/session_manager.dart / SessionManager | Map<String, dynamic> payload | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _extractMfaTicket | lib/services/session/session_manager.dart / SessionManager | Map<String, dynamic> payload | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _extractSessionToken | lib/services/session/session_manager.dart / SessionManager | Map<String, dynamic> payload | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _extractSessionCookie | lib/services/session/session_manager.dart / SessionManager | Map<String, String> headers | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/services/sync/desktop_sync_service.dart`

业务/运行时 service 文件，负责 `desktop_sync_service` 相关状态、I/O 或业务逻辑。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| dispose | lib/services/sync/desktop_sync_service.dart / DesktopSyncService | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _handleSessionChange | lib/services/sync/desktop_sync_service.dart / DesktopSyncService | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| isRenderableXrayConfig | lib/services/sync/desktop_sync_service.dart / DesktopSyncService | String? rawJson | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _extractMetadata | lib/services/sync/desktop_sync_service.dart / DesktopSyncService | Map<String, dynamic> payload | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _extractNodeMetadata | lib/services/sync/desktop_sync_service.dart / DesktopSyncService | List<SyncedNodeMetadata> candidates | SyncedNodeMetadata | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _firstNonEmptyString | lib/services/sync/desktop_sync_service.dart / DesktopSyncService | List<Object?> candidates | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _firstNonEmptyStringStatic | lib/services/sync/desktop_sync_service.dart / DesktopSyncService | List<Object?> candidates | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _nullableString | lib/services/sync/desktop_sync_service.dart / DesktopSyncService | String value | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _extractNodeNameFromVlessUriStatic | lib/services/sync/desktop_sync_service.dart / DesktopSyncService | String? uriText | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _extractHostFromVlessUri | lib/services/sync/desktop_sync_service.dart / DesktopSyncService | String? uriText | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _extractHostFromVlessUriStatic | lib/services/sync/desktop_sync_service.dart / DesktopSyncService | String? uriText | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _countryCodeFromHost | lib/services/sync/desktop_sync_service.dart / DesktopSyncService | String? host | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _hexEncode | lib/services/sync/desktop_sync_service.dart / DesktopSyncService | List<int> bytes | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/services/sync/device_fingerprint.dart`

业务/运行时 service 文件，负责 `device_fingerprint` 相关状态、I/O 或业务逻辑。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `lib/services/sync/sync_crypto.dart`

业务/运行时 service 文件，负责 `sync_crypto` 相关状态、I/O 或业务逻辑。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `lib/services/sync/sync_payload.dart`

业务/运行时 service 文件，负责 `sync_payload` 相关状态、I/O 或业务逻辑。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| toBytes | lib/services/sync/sync_payload.dart / SyncRequest | 无 | Uint8List | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| parseSyncResponse | lib/services/sync/sync_payload.dart / SyncResponse | Uint8List bytes | SyncResponse | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/services/sync/sync_state.dart`

业务/运行时 service 文件，负责 `sync_state` 相关状态、I/O 或业务逻辑。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| lastConfigVersion | lib/services/sync/sync_state.dart / SyncStateStore | 无 | int | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/services/sync/xray_config_writer.dart`

业务/运行时 service 文件，负责 `xray_config_writer` 相关状态、I/O 或业务逻辑。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| _normalizeCountryCode | lib/services/sync/xray_config_writer.dart / XrayConfigWriter | String? value, String fallback | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _pickValue | lib/services/sync/xray_config_writer.dart / XrayConfigWriter | String? preferred, String? fallback | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _normalizeNodeCode | lib/services/sync/xray_config_writer.dart / XrayConfigWriter | String raw | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |
| extractOutboundIdentity | lib/services/sync/xray_config_writer.dart / XrayConfigWriter | String rawJson | String? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 文件 I/O / 配置落盘。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/services/telemetry/telemetry_service.dart`

业务/运行时 service 文件，负责 `telemetry_service` 相关状态、I/O 或业务逻辑。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| collectData | lib/services/telemetry/telemetry_service.dart / TelemetryService | {required String appVersion} | Map<String, dynamic> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 网络请求、持久化或状态回写。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/utils/app_logger.dart`

统一应用日志写入入口。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| addAppLog | lib/utils/app_logger.dart / app_logger.dart | String message, {LogLevel level = LogLevel.info} | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/utils/global_config.dart`

全局运行态、应用支持目录路径和共享配置入口。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| _displayBranchLabel | lib/utils/global_config.dart / global_config.dart | String branch | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _firstNonEmpty | lib/utils/global_config.dart / global_config.dart | List<String> values | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| collectSystemInfo | lib/utils/global_config.dart / global_config.dart | 无 | Map<String, String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| normalizeConnectionMode | lib/utils/global_config.dart / GlobalState | String? value | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| isTunnelModeValue | lib/utils/global_config.dart / GlobalState | String? value | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| setConnectionMode | lib/utils/global_config.dart / GlobalState | String? mode | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| setTunnelModeEnabled | lib/utils/global_config.dart / GlobalState | bool enabled | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| fromStorage | lib/utils/global_config.dart / DnsTransportMode | String? value | DnsTransportMode | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| dohEnabled | lib/utils/global_config.dart / DnsConfig | 无 | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _bootstrapDirectDefault | lib/utils/global_config.dart / DnsConfig | {required bool primary} | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| proxyPrimaryDefault | lib/utils/global_config.dart / DnsConfig | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| proxySecondaryDefault | lib/utils/global_config.dart / DnsConfig | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| directPrimaryDefault | lib/utils/global_config.dart / DnsConfig | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| directSecondaryDefault | lib/utils/global_config.dart / DnsConfig | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| setDohEnabled | lib/utils/global_config.dart / DnsConfig | bool enabled | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| proxyResolversForXray | lib/utils/global_config.dart / DnsConfig | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| directResolversForXray | lib/utils/global_config.dart / DnsConfig | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| effectiveTunnelDnsServers4 | lib/utils/global_config.dart / DnsConfig | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| effectiveTunnelDnsServers6 | lib/utils/global_config.dart / DnsConfig | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| systemTunnelDnsServers4 | lib/utils/global_config.dart / DnsConfig | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| systemTunnelDnsServers6 | lib/utils/global_config.dart / DnsConfig | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| shouldCaptureSystemDnsToBuiltInDns | lib/utils/global_config.dart / DnsConfig | 无 | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| darwinSystemDnsMode | lib/utils/global_config.dart / DnsConfig | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| darwinPacketTunnelDnsServers4 | lib/utils/global_config.dart / DnsConfig | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| darwinPacketTunnelDnsServers6 | lib/utils/global_config.dart / DnsConfig | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| directDomainSet | lib/utils/global_config.dart / DnsConfig | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| proxyDomainSet | lib/utils/global_config.dart / DnsConfig | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| fakeDomainSet | lib/utils/global_config.dart / DnsConfig | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| directIpCidrs | lib/utils/global_config.dart / DnsConfig | 无 | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| setMode | lib/utils/global_config.dart / XhttpAdvancedConfig | String value | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| setAlpn | lib/utils/global_config.dart / XhttpAdvancedConfig | List<String> values | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| toggleAlpn | lib/utils/global_config.dart / XhttpAdvancedConfig | String value, bool enabled | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _normalizeMode | lib/utils/global_config.dart / XhttpAdvancedConfig | String? raw | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _normalizeAlpn | lib/utils/global_config.dart / XhttpAdvancedConfig | List<String>? raw | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 共享状态或偏好读写。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/utils/log_store.dart`

日志缓存存储。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| add | lib/utils/log_store.dart / LogStore | LogEntry entry | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| addLog | lib/utils/log_store.dart / LogStore | LogLevel level, String message | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| clear | lib/utils/log_store.dart / LogStore | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| getAll | lib/utils/log_store.dart / LogStore | 无 | List<LogEntry> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/utils/tun_config_guard.dart`

Darwin TUN inbound 防御性字段清洗。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| guardTunInterfaceFieldsForWrite | lib/utils/tun_config_guard.dart / TunConfigGuardResult | String rawJson | TunConfigGuardResult | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/utils/validators.dart`

简单参数校验辅助函数。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| checkNotEmpty | lib/utils/validators.dart / validators.dart | String value, String name | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| checkNotNull | lib/utils/validators.dart / validators.dart | Object? value, String name | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |

### `lib/templates/xray_config_template.dart`

配置模板文件，向 `VpnConfig` 等服务提供 Xray / service 文本模板。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `lib/templates/xray_service_linux_template.dart`

配置模板文件，向 `VpnConfig` 等服务提供 Xray / service 文本模板。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `lib/templates/xray_service_macos_template.dart`

配置模板文件，向 `VpnConfig` 等服务提供 Xray / service 文本模板。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

### `lib/templates/xray_service_windows_template.dart`

配置模板文件，向 `VpnConfig` 等服务提供 Xray / service 文本模板。

该文件没有独立的手写函数/方法符号，主要提供常量、模板、声明或由框架回调驱动。

## 接口契约与跨层依赖

| 契约 | 说明 |
| --- | --- |
| `VpnConfig` <-> `SqliteNodeStore` | 节点列表以内存模型为主、SQLite 为主持久化，必要时同步 JSON 快照与配置文件。 |
| `VpnConfig` <-> `NativeBridge` | 节点启动、停止、运行态配置写入和系统隧道切换都通过桥接层下沉到原生或 Go。 |
| `GlobalState` <-> 各 Service | `GlobalState` 是 Flutter 侧的共享运行态，偏好设置类 service 负责从 `SharedPreferences` 初始化并回写。 |
| `DesktopSyncService` <-> `SessionManager` / `DeviceFingerprint` / `SyncCrypto` / `XrayConfigWriter` | 同步链路负责认证态、设备身份、加解密、配置写入与本地版本状态的闭环。 |
| `DnsControlPlane` / 模板文件 | DNS 与模板文件共同定义运行时 Xray 配置片段，生成逻辑应与模板保持一致。 |


## 已知约束 / 副作用 / 线程与平台注意点

- 文档只覆盖当前仓库自研代码，不展开第三方依赖、Pods、Flutter/平台生成注册器和 `*.g.dart` 内部实现。
- 带 `PacketTunnel`、`NativeBridge`、`go_core`、`Session`、`sync`、`sqlite`、`SharedPreferences`、`UserDefaults` 的符号通常伴随 I/O、系统 API 或跨线程副作用，修改前应先核对调用链。
- Swift / Kotlin / Go 的错误返回风格不同：Swift 多为 `throws`/`Result`，Kotlin 以字符串状态和 `Map` 回传，Go FFI 以 `*C.char` 或 `C.int` 作为桥接结果。
- 本页的“主要调用方或用途”列用于帮助定位主调用闭环，不代表唯一调用点；需要精确调用图时仍应回到源码。
