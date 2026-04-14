# Flutter 壳层与界面参考

本页按“设计意图与边界 → 文件职责 → 类型清单 → 函数/方法清单 → 接口契约 → 约束与副作用”的顺序整理当前仓库实现。描述以当前主路径为准，不保留历史兼容叙述。

函数与方法表以当前手写实现的签名库存为主，个别复杂多行声明会做适度压缩；遇到不规则泛型、闭包或平台回调时，以源码中的完整签名为最终依据。

## 设计意图与边界

覆盖 Flutter 壳层入口、导航容器、页面、复用组件、本地化与主题扩展。重点是界面结构、状态绑定点和 UI 事件入口，不解释底层服务实现。

## 文件列表与职责

| 文件 | 职责 | 说明 |
| --- | --- | --- |
| lib/main.dart | Flutter 应用入口、全局初始化、主导航容器与二维码导入入口。 | 手写实现，纳入本页覆盖范围。 |
| lib/screens/about_screen.dart | 页面实现，负责 `about` 相关 UI 与交互入口。 | 手写实现，纳入本页覆盖范围。 |
| lib/screens/config_options_screen.dart | 页面实现，负责 `config_options` 相关 UI 与交互入口。 | 手写实现，纳入本页覆盖范围。 |
| lib/screens/help_screen.dart | 页面实现，负责 `help` 相关 UI 与交互入口。 | 手写实现，纳入本页覆盖范围。 |
| lib/screens/home_screen.dart | 页面实现，负责 `home` 相关 UI 与交互入口。 | 手写实现，纳入本页覆盖范围。 |
| lib/screens/login_screen.dart | 页面实现，负责 `login` 相关 UI 与交互入口。 | 手写实现，纳入本页覆盖范围。 |
| lib/screens/logs_screen.dart | 页面实现，负责 `logs` 相关 UI 与交互入口。 | 手写实现，纳入本页覆盖范围。 |
| lib/screens/settings_screen.dart | 页面实现，负责 `settings` 相关 UI 与交互入口。 | 手写实现，纳入本页覆盖范围。 |
| lib/screens/subscription_screen.dart | 页面实现，负责 `subscription` 相关 UI 与交互入口。 | 手写实现，纳入本页覆盖范围。 |
| lib/widgets/app_breadcrumb.dart | 复用组件文件，封装 `app_breadcrumb` 对应的界面片段。 | 手写实现，纳入本页覆盖范围。 |
| lib/widgets/custom_list_tile.dart | 复用组件文件，封装 `custom_list_tile` 对应的界面片段。 | 手写实现，纳入本页覆盖范围。 |
| lib/widgets/custom_text_field.dart | 复用组件文件，封装 `custom_text_field` 对应的界面片段。 | 手写实现，纳入本页覆盖范围。 |
| lib/widgets/log_console.dart | 复用组件文件，封装 `log_console` 对应的界面片段。 | 手写实现，纳入本页覆盖范围。 |
| lib/widgets/permission_guide_dialog.dart | 复用组件文件，封装 `permission_guide_dialog` 对应的界面片段。 | 手写实现，纳入本页覆盖范围。 |
| lib/widgets/take_picture.dart | 复用组件文件，封装 `take_picture` 对应的界面片段。 | 手写实现，纳入本页覆盖范围。 |
| lib/l10n/app_localizations.dart | 本地化字典访问层与 `BuildContext` 扩展。 | 手写实现，纳入本页覆盖范围。 |
| lib/utils/app_theme.dart | 主题、语义色和 `BuildContext` 主题扩展定义。 | 手写实现，纳入本页覆盖范围。 |

## 关键数据结构 / 类 / 枚举 / typedef / extension

| 符号 | 类型 | 所在文件 | 说明 |
| --- | --- | --- | --- |
| MyApp | class | lib/main.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| MainPage | class | lib/main.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| _MainPageState | class | lib/main.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| _NavigationDestination | class | lib/main.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| _AddNodeMenuAction | enum | lib/main.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AboutScreen | class | lib/screens/about_screen.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| ConfigOptionsScreen | class | lib/screens/config_options_screen.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| HelpScreen | class | lib/screens/help_screen.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| _HelpScreenState | class | lib/screens/help_screen.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| _HelpPaths | class | lib/screens/help_screen.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| HomeScreen | class | lib/screens/home_screen.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| _LatencyVisual | class | lib/screens/home_screen.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| _HomeScreenState | class | lib/screens/home_screen.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| LoginScreen | class | lib/screens/login_screen.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| _LoginScreenState | class | lib/screens/login_screen.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| LogsScreen | class | lib/screens/logs_screen.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| SettingsScreen | class | lib/screens/settings_screen.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| _SettingsScreenState | class | lib/screens/settings_screen.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| SubscriptionScreen | class | lib/screens/subscription_screen.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| _SubscriptionScreenState | class | lib/screens/subscription_screen.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppBreadcrumb | class | lib/widgets/app_breadcrumb.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| CustomListTile | class | lib/widgets/custom_list_tile.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| CustomTextField | class | lib/widgets/custom_text_field.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| LogLevel | enum | lib/widgets/log_console.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| LogEntry | class | lib/widgets/log_console.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| LogConsole | class | lib/widgets/log_console.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| LogConsoleState | class | lib/widgets/log_console.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| ScanQrCode | class | lib/widgets/take_picture.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| _ScanQrCodeState | class | lib/widgets/take_picture.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppLocalizations | class | lib/l10n/app_localizations.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| _AppLocalizationsDelegate | class | lib/l10n/app_localizations.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| LocalizationExtension | extension | lib/l10n/app_localizations.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppColors | class | lib/utils/app_theme.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| XStreamColors | class | lib/utils/app_theme.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| XStreamThemeContext | extension | lib/utils/app_theme.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |
| AppTheme | class | lib/utils/app_theme.dart | 类型/接口/别名定义；具体字段与成员以当前源码为准。 |

## 函数与方法清单

### `lib/main.dart`

Flutter 应用入口、全局初始化、主导航容器与二维码导入入口。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| getQrCodeData | lib/main.dart / main.dart | img.Image image | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| build | lib/main.dart / MyApp | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| createState | lib/main.dart / MainPage | 无 | State<MainPage> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| _desktopCapabilities | lib/main.dart / _MainPageState | 无 | DesktopPlatformCapabilities | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| _isMobileLayout | lib/main.dart / _MainPageState | BuildContext context | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| initState | lib/main.dart / _MainPageState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| dispose | lib/main.dart / _MainPageState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| didChangeAppLifecycleState | lib/main.dart / _MainPageState | AppLifecycleState state | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| _openAddConfig | lib/main.dart / _MainPageState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| _openAddConfigWithUri | lib/main.dart / _MainPageState | String uri | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| _showComingSoon | lib/main.dart / _MainPageState | String text | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| _toggleLanguage | lib/main.dart / _MainPageState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| _buildDestinations | lib/main.dart / _MainPageState | BuildContext context | List<NavigationRailDestination> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| _buildMobileDestinations | lib/main.dart / _MainPageState | BuildContext context | List<_NavigationDestination> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| _currentPageTitle | lib/main.dart / _MainPageState | BuildContext context | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| _currentBreadcrumbItems | lib/main.dart / _MainPageState | BuildContext context | List<String> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |
| build | lib/main.dart / _MainPageState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 应用启动时由 Flutter runtime 调用。 |

### `lib/screens/about_screen.dart`

页面实现，负责 `about` 相关 UI 与交互入口。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| _buildBody | lib/screens/about_screen.dart / AboutScreen | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| build | lib/screens/about_screen.dart / AboutScreen | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |

### `lib/screens/config_options_screen.dart`

页面实现，负责 `config_options` 相关 UI 与交互入口。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| build | lib/screens/config_options_screen.dart / ConfigOptionsScreen | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |

### `lib/screens/help_screen.dart`

页面实现，负责 `help` 相关 UI 与交互入口。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| createState | lib/screens/help_screen.dart / HelpScreen | 无 | State<HelpScreen> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildBody | lib/screens/help_screen.dart / _HelpScreenState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| build | lib/screens/help_screen.dart / _HelpScreenState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildBullet | lib/screens/help_screen.dart / _HelpScreenState | String text | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildPathRow | lib/screens/help_screen.dart / _HelpScreenState | BuildContext context, String label, String value | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |

### `lib/screens/home_screen.dart`

页面实现，负责 `home` 相关 UI 与交互入口。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| createState | lib/screens/home_screen.dart / HomeScreen | 无 | State<HomeScreen> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _showMessage | lib/screens/home_screen.dart / _HomeScreenState | String msg, {Color? bgColor} | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| initState | lib/screens/home_screen.dart / _HomeScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| dispose | lib/screens/home_screen.dart / _HomeScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _onConnectionModeChanged | lib/screens/home_screen.dart / _HomeScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| didChangeAppLifecycleState | lib/screens/home_screen.dart / _HomeScreenState | AppLifecycleState state | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _onActiveNodeChanged | lib/screens/home_screen.dart / _HomeScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _desktopCapabilities | lib/screens/home_screen.dart / _HomeScreenState | 无 | DesktopPlatformCapabilities | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _requiresPacketTunnelStatus | lib/screens/home_screen.dart / _HomeScreenState | 无 | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _packetTunnelExplicitlyUnavailable | lib/screens/home_screen.dart / _HomeScreenState | 无 | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _shouldPollPacketTunnelStatus | lib/screens/home_screen.dart / _HomeScreenState | 无 | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _shouldPollMetrics | lib/screens/home_screen.dart / _HomeScreenState | 无 | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _updateMonitoringState | lib/screens/home_screen.dart / _HomeScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _clearMonitoringData | lib/screens/home_screen.dart / _HomeScreenState | {required bool clearLatency} | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _startStatusPolling | lib/screens/home_screen.dart / _HomeScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _syncConnectedMeta | lib/screens/home_screen.dart / _HomeScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _formatDuration | lib/screens/home_screen.dart / _HomeScreenState | Duration duration | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _startMetricsPolling | lib/screens/home_screen.dart / _HomeScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _startLatencyPolling | lib/screens/home_screen.dart / _HomeScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _scheduleClearHighlight | lib/screens/home_screen.dart / _HomeScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _resolveActionNode | lib/screens/home_screen.dart / _HomeScreenState | 无 | VpnNode? | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _selectNode | lib/screens/home_screen.dart / _HomeScreenState | VpnNode node | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _formatRate | lib/screens/home_screen.dart / _HomeScreenState | int? bytesPerSecond | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _formatMemory | lib/screens/home_screen.dart / _HomeScreenState | int? memoryBytes | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _formatCpu | lib/screens/home_screen.dart / _HomeScreenState | double? cpuPercent | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _latencyVisual | lib/screens/home_screen.dart / _HomeScreenState | BuildContext context, int? latency | _LatencyVisual | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildMetricBadge | lib/screens/home_screen.dart / _HomeScreenState | IconData icon, Color color | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _hasActiveConnection | lib/screens/home_screen.dart / _HomeScreenState | 无 | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _connectionStateLabel | lib/screens/home_screen.dart / _HomeScreenState | BuildContext context | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _connectionStateColor | lib/screens/home_screen.dart / _HomeScreenState | 无 | Color | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _connectionMetaLine | lib/screens/home_screen.dart / _HomeScreenState | BuildContext context | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildSummaryStatusChip | lib/screens/home_screen.dart / _HomeScreenState | BuildContext context, VpnNode? node | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildPrimaryStatusCard | lib/screens/home_screen.dart / _HomeScreenState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildNodeOptionChip | lib/screens/home_screen.dart / _HomeScreenState | BuildContext context, VpnNode node | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildNodeSummarySection | lib/screens/home_screen.dart / _HomeScreenState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildMonitoringDashboard | lib/screens/home_screen.dart / _HomeScreenState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| build | lib/screens/home_screen.dart / _HomeScreenState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |

### `lib/screens/login_screen.dart`

页面实现，负责 `login` 相关 UI 与交互入口。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| createState | lib/screens/login_screen.dart / LoginScreen | 无 | State<LoginScreen> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| initState | lib/screens/login_screen.dart / _LoginScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| dispose | lib/screens/login_screen.dart / _LoginScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _formatDateTime | lib/screens/login_screen.dart / _LoginScreenState | DateTime dt | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _pad | lib/screens/login_screen.dart / _LoginScreenState | int n | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| build | lib/screens/login_screen.dart / _LoginScreenState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildLoggedInView | lib/screens/login_screen.dart / _LoginScreenState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildSyncStatusCard | lib/screens/login_screen.dart / _LoginScreenState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _infoRow | lib/screens/login_screen.dart / _LoginScreenState | BuildContext context, String label, String value | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildLoginForm | lib/screens/login_screen.dart / _LoginScreenState | BuildContext context, bool isMfaRequired | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |

### `lib/screens/logs_screen.dart`

页面实现，负责 `logs` 相关 UI 与交互入口。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| build | lib/screens/logs_screen.dart / LogsScreen | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |

### `lib/screens/settings_screen.dart`

页面实现，负责 `settings` 相关 UI 与交互入口。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| createState | lib/screens/settings_screen.dart / SettingsScreen | 无 | State<SettingsScreen> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _desktopCapabilities | lib/screens/settings_screen.dart / _SettingsScreenState | 无 | DesktopPlatformCapabilities | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| initState | lib/screens/settings_screen.dart / _SettingsScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildSection | lib/screens/settings_screen.dart / _SettingsScreenState | String title, List<Widget> children | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _syncBaseUrlFromSession | lib/screens/settings_screen.dart / _SettingsScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _syncUsernameFromSession | lib/screens/settings_screen.dart / _SettingsScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _formatTunStatusText | lib/screens/settings_screen.dart / _SettingsScreenState | BuildContext context, PacketTunnelStatus status | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _onToggleDnsOverHttps | lib/screens/settings_screen.dart / _SettingsScreenState | bool enabled | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _loadXhttpAdvancedDraft | lib/screens/settings_screen.dart / _SettingsScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _setDraftXhttpMode | lib/screens/settings_screen.dart / _SettingsScreenState | String value | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _toggleDraftXhttpAlpn | lib/screens/settings_screen.dart / _SettingsScreenState | String value, bool enabled | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _resetXhttpAdvancedDraft | lib/screens/settings_screen.dart / _SettingsScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _saveAndApplyXhttpAdvanced | lib/screens/settings_screen.dart / _SettingsScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildXhttpAdvancedConfig | lib/screens/settings_screen.dart / _SettingsScreenState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildMobileSettingsView | lib/screens/settings_screen.dart / _SettingsScreenState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _buildDesktopSettingsView | lib/screens/settings_screen.dart / _SettingsScreenState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| build | lib/screens/settings_screen.dart / _SettingsScreenState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| dispose | lib/screens/settings_screen.dart / _SettingsScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _showProxyDnsDialog | lib/screens/settings_screen.dart / _SettingsScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _showDirectDnsDialog | lib/screens/settings_screen.dart / _SettingsScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _showTelemetryData | lib/screens/settings_screen.dart / _SettingsScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |

### `lib/screens/subscription_screen.dart`

页面实现，负责 `subscription` 相关 UI 与交互入口。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| createState | lib/screens/subscription_screen.dart / SubscriptionScreen | 无 | State<SubscriptionScreen> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| initState | lib/screens/subscription_screen.dart / _SubscriptionScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| dispose | lib/screens/subscription_screen.dart / _SubscriptionScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _scheduleAutoParse | lib/screens/subscription_screen.dart / _SubscriptionScreenState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| build | lib/screens/subscription_screen.dart / _SubscriptionScreenState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |

### `lib/widgets/app_breadcrumb.dart`

复用组件文件，封装 `app_breadcrumb` 对应的界面片段。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| build | lib/widgets/app_breadcrumb.dart / AppBreadcrumb | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |

### `lib/widgets/custom_list_tile.dart`

复用组件文件，封装 `custom_list_tile` 对应的界面片段。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| build | lib/widgets/custom_list_tile.dart / CustomListTile | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |

### `lib/widgets/custom_text_field.dart`

复用组件文件，封装 `custom_text_field` 对应的界面片段。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| build | lib/widgets/custom_text_field.dart / CustomTextField | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |

### `lib/widgets/log_console.dart`

复用组件文件，封装 `log_console` 对应的界面片段。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| formatted | lib/widgets/log_console.dart / LogEntry | 无 | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _levelString | lib/widgets/log_console.dart / LogEntry | LogLevel level | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| createState | lib/widgets/log_console.dart / LogConsole | 无 | LogConsoleState | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| initState | lib/widgets/log_console.dart / LogConsoleState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| addLog | lib/widgets/log_console.dart / LogConsoleState | String message, {LogLevel level = LogLevel.info} | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| clearLogs | lib/widgets/log_console.dart / LogConsoleState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| exportLogs | lib/widgets/log_console.dart / LogConsoleState | 无 | void | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| build | lib/widgets/log_console.dart / LogConsoleState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| _getColor | lib/widgets/log_console.dart / LogConsoleState | LogLevel level | Color | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |

### `lib/widgets/permission_guide_dialog.dart`

复用组件文件，封装 `permission_guide_dialog` 对应的界面片段。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| titleForCheck | lib/widgets/permission_guide_dialog.dart / permission_guide_dialog.dart | String id | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |

### `lib/widgets/take_picture.dart`

复用组件文件，封装 `take_picture` 对应的界面片段。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| createState | lib/widgets/take_picture.dart / ScanQrCode | 无 | State<ScanQrCode> | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |
| build | lib/widgets/take_picture.dart / _ScanQrCodeState | BuildContext context | Widget | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 `MainPage` 或其他页面/组件树引用。 |

### `lib/l10n/app_localizations.dart`

本地化字典访问层与 `BuildContext` 扩展。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| get | lib/l10n/app_localizations.dart / AppLocalizations | String key | String | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 见当前主流程。 |
| isSupported | lib/l10n/app_localizations.dart / _AppLocalizationsDelegate | Locale locale | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 见当前主流程。 |
| shouldReload | lib/l10n/app_localizations.dart / _AppLocalizationsDelegate | covariant LocalizationsDelegate<AppLocalizations> old | bool | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 见当前主流程。 |
| l10n | lib/l10n/app_localizations.dart / LocalizationExtension | 无 | AppLocalizations | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 见当前主流程。 |

### `lib/utils/app_theme.dart`

主题、语义色和 `BuildContext` 主题扩展定义。

| 符号名 | 所在文件/类型 | 参数 | 返回值 | 异常/错误语义 | 副作用或外部依赖 | 主要调用方或用途 |
| --- | --- | --- | --- | --- | --- | --- |
| lerp | lib/utils/app_theme.dart / XStreamColors | XStreamColors? other, double t | XStreamColors | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| xColors | lib/utils/app_theme.dart / XStreamThemeContext | 无 | XStreamColors | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _inputDecoration | lib/utils/app_theme.dart / AppTheme | ColorScheme cs | InputDecorationTheme | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _dialogTheme | lib/utils/app_theme.dart / AppTheme | ColorScheme cs | DialogThemeData | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _appBarTheme | lib/utils/app_theme.dart / AppTheme | ColorScheme cs | AppBarTheme | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _navigationRailTheme | lib/utils/app_theme.dart / AppTheme | ColorScheme cs | NavigationRailThemeData | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _cardTheme | lib/utils/app_theme.dart / AppTheme | ColorScheme cs | CardThemeData | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _snackBarTheme | lib/utils/app_theme.dart / AppTheme | ColorScheme cs | SnackBarThemeData | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _popupMenuTheme | lib/utils/app_theme.dart / AppTheme | ColorScheme cs | PopupMenuThemeData | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _elevatedButtonTheme | lib/utils/app_theme.dart / AppTheme | ColorScheme cs | ElevatedButtonThemeData | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |
| _listTileTheme | lib/utils/app_theme.dart / AppTheme | ColorScheme cs | ListTileThemeData | 见当前实现；Go/原生桥接多使用错误字符串或 `throws`，其余以返回值和状态回写为主。 | 以当前文件职责为准。 | 由 Flutter 业务层、页面或桥接层调用。 |

## 接口契约与跨层依赖

| 契约 | 说明 |
| --- | --- |
| `MainPage` -> `GlobalState` | 导航容器通过 `ValueNotifier` 和监听器驱动 UI、节点状态、连接模式与语言切换。 |
| 页面 -> `NativeBridge` / 服务层 | 页面自身不直接管理 FFI 或平台 API，交互都经 `NativeBridge`、`VpnConfig`、`SessionManager`、`DesktopSyncService` 等服务完成。 |
| 页面 -> `context.l10n` | 所有用户可见文案都应通过 `AppLocalizations` 的 key 查询，避免散落硬编码。 |
| Widget -> Theme 扩展 | 自定义组件通过 `AppTheme` / `XStreamColors` 使用语义色，而不是直接耦合具体色值。 |


## 已知约束 / 副作用 / 线程与平台注意点

- 文档只覆盖当前仓库自研代码，不展开第三方依赖、Pods、Flutter/平台生成注册器和 `*.g.dart` 内部实现。
- 带 `PacketTunnel`、`NativeBridge`、`go_core`、`Session`、`sync`、`sqlite`、`SharedPreferences`、`UserDefaults` 的符号通常伴随 I/O、系统 API 或跨线程副作用，修改前应先核对调用链。
- Swift / Kotlin / Go 的错误返回风格不同：Swift 多为 `throws`/`Result`，Kotlin 以字符串状态和 `Map` 回传，Go FFI 以 `*C.char` 或 `C.int` 作为桥接结果。
- 本页的“主要调用方或用途”列用于帮助定位主调用闭环，不代表唯一调用点；需要精确调用图时仍应回到源码。
