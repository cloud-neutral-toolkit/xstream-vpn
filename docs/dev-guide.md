# 开发者构建指南（macOS）

本指南适用于希望在 macOS 上本地构建和调试 XStream 项目的开发者。

如果你使用 Xcode 进行 iOS/macOS 联调，请先阅读：

- [Xcode 在线调试（macOS / iOS）](xcode-online-debug.md)
- [本机 MCP Server（Codex / Genmini）](xstream-mcp-server.md)
- [Apple Signing 与 Packet Tunnel 能力申请（macOS / iOS）](apple-network-extension-signing-setup.md)
- [macOS Packet Tunnel 实现记录](macos-packet-tunnel-implementation.md)
- [VpnConfig 与节点持久化说明](VpnConfigStruct.md)

## 环境准备

### 1. 安装 Flutter

使用 Homebrew 安装 Flutter： brew install --cask flutter

或者参考官方安装指南：Flutter 安装文档

2. 安装 Xcode 和配置

前往 App Store 或 Apple Developer 官网安装最新版 Xcode。

初次安装后运行初始化命令： sudo xcodebuild -runFirstLaunch
安装命令行工具（如果未安装）： xcode-select --install

3. 安装 CocoaPods（iOS/macOS 必需）

sudo gem install cocoapods

4. 拉取依赖并构建

flutter pub get
sh scripts/generate_icons.sh  # 生成 iOS App 图标
flutter build macos
开发调试
使用 VS Code 或 Android Studio 打开项目根目录，可执行如下命令调试：
flutter run -d macos
或使用调试按钮直接运行项目。

# 项目结构说明

## 核心配置文件
- `pubspec.yaml` - Flutter项目配置文件，包含依赖、版本等信息
- `Makefile` - 构建脚本，定义各种构建任务
- `analysis_options.yaml` - Dart代码分析配置

## Flutter应用代码
- `lib/` - 主要Dart代码目录
  - `main.dart` - 应用入口文件
  - `screens/` - 界面文件（主屏幕、设置屏幕等）
  - `services/` - 服务层代码（VPN配置、更新服务、遥测等）
  - `utils/` - 工具类（主题、配置、日志等）
  - `widgets/` - UI组件（按钮、输入框、控制台等）
  - `templates/` - 配置模板（Xray配置、系统服务等）
  - `bindings/` - FFI绑定文件

## 平台特定代码
- `android/` - Android平台代码和配置
- `ios/` - iOS平台代码和配置
- `macos/` - macOS平台代码和配置
- `windows/` - Windows平台代码和配置
- `linux/` - Linux平台代码和配置
- `web/` - Web平台代码和配置

## Go核心模块
- `go_core/` - Go语言编写的核心功能模块
  - `bridge.go` - 主要桥接代码
  - `bridge_*.go` - 各平台特定的桥接实现

## 构建和部署
- `build_scripts/` - 各平台构建脚本
- `scripts/` - 辅助脚本（图标生成、清理等）
- `msix_config.yaml` - Windows MSIX包配置

## 文档和资源
- `docs/` - 项目文档
  - `macos-packet-tunnel-implementation.md` - macOS Packet Tunnel 的控制面、数据面、进程视角、构建与调用链路记录
  - `VpnConfigStruct.md` - 节点模型、多节点语义、本地持久化与运行时配置入口说明
- `assets/` - 静态资源（图标、Logo等）
- `bindings/` - 原生代码绑定文件

## 节点与配置运维排查

当前实现的运维要点：

- 支持多节点保存与切换
- 同一时刻只允许一个活跃节点
- `app.db` 是节点列表主数据源
- `vpn_nodes.json` 主要用于兼容与导出
- 当前活跃节点的运行时入口始终是 `configs/config.json`

macOS 下常见目录示例：

```text
~/Library/Application Support/plus.svc.xstream/
```

关键文件与目录：

- `app.db`：节点主数据源（SQLite）
- `vpn_nodes.json`：兼容/导出快照
- `configs/node-*-config.json`：单节点源配置
- `configs/config.json`：当前活跃节点运行时配置
- `services/`：服务定义文件
- `logs/xray-runtime.log`：运行日志

推荐排查顺序：

1. 先看 `app.db` 中是否存在目标节点。
2. 再看 `vpn_nodes.json` 是否与 SQLite 一致。
3. 查看 `configs/` 下是否存在目标节点的 `node-*-config.json`。
4. 查看 `configs/config.json` 是否已被切换为当前活跃节点。
5. 如仍异常，再检查 `services/` 与 `logs/xray-runtime.log`。

常用命令：

```zsh
BASE="$HOME/Library/Application Support/plus.svc.xstream"

sqlite3 "$BASE/app.db" \
  "select name,country_code,config_path,service_name,enabled from vpn_nodes order by updated_at desc, name asc;"

cat "$BASE/vpn_nodes.json"

ls -la "$BASE/configs"
cat "$BASE/configs/config.json"

ls -la "$BASE/services"
tail -n 200 "$BASE/logs/xray-runtime.log"
```

说明：

- 如果 `app.db` 中已有记录，应用会优先读取 SQLite，而不是 `vpn_nodes.json`。
- 切换节点时会重写 `configs/config.json`，这是当前运行态的统一入口。
- 若多个节点名称前缀相同，可能导致生成的配置文件或服务定义发生覆盖，排查时应同时核对 `configs/` 与 `services/`。

# 常见问题
构建失败、权限错误
检查是否正确授予 macOS 网络和文件访问权限

使用 flutter clean 清除缓存后重新构建


macos/
└── Runner/
    ├── AppDelegate.swift               # 保留主入口和 Flutter channel 注册逻辑
    ├── NativeBridge+ConfigWriter.swift # 包含 writeConfigFiles、writeFile 等配置写入相关函数
    ├── NativeBridge+XrayInit.swift     # 包含 runInitXray 的 AppleScript 权限处理与初始化逻辑
    ├── NativeBridge+ServiceControl.swift # 启动/停止/check 服务的 launchctl 相关逻辑
    └── NativeBridge+Logger.swift       # logToFlutter 日志通道封装

- DMG filename now follows the pattern:
  - `xstream-release-<tag>.dmg` if tagged on main branch
  - `xstream-latest-<commit>.dmg` if untagged on main
  - `xstream-dev-<commit>.dmg` for non-main branches
