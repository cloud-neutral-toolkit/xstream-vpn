# 开发手册

该仓库是 Flutter 客户端应用，文档需要覆盖平台架构、构建链路与运维排障。

本页用于记录本地开发环境、项目结构、测试面与贴合当前代码库的贡献约定。

## 与当前代码对齐的说明

- 文档目标仓库: `xstream.svc.plus`
- 仓库类型: `flutter-app`
- 构建与运行依据: pubspec.yaml (`xstream`)
- 主要实现与运维目录: `scripts/`, `test/`, `lib/`, `ios/`, `android/`, `web/`
- `package.json` 脚本快照: No package.json scripts were detected.

## 工程实现参考入口

- 总入口: [docs/engineering/README.md](/Users/shenlan/workspaces/cloud-neutral-toolkit/xstream-vpn/docs/engineering/README.md)
- 覆盖矩阵: [docs/engineering/source-coverage.md](/Users/shenlan/workspaces/cloud-neutral-toolkit/xstream-vpn/docs/engineering/source-coverage.md)
- Flutter 壳层与界面: [docs/engineering/flutter-shell-ui.md](/Users/shenlan/workspaces/cloud-neutral-toolkit/xstream-vpn/docs/engineering/flutter-shell-ui.md)
- Flutter 运行时服务: [docs/engineering/flutter-runtime-services.md](/Users/shenlan/workspaces/cloud-neutral-toolkit/xstream-vpn/docs/engineering/flutter-runtime-services.md)
- Flutter 桥接与契约: [docs/engineering/flutter-bridge-contracts.md](/Users/shenlan/workspaces/cloud-neutral-toolkit/xstream-vpn/docs/engineering/flutter-bridge-contracts.md)
- Go Core FFI: [docs/engineering/go-core-ffi.md](/Users/shenlan/workspaces/cloud-neutral-toolkit/xstream-vpn/docs/engineering/go-core-ffi.md)
- 原生宿主与 Packet Tunnel: [docs/engineering/native-platform-hosts.md](/Users/shenlan/workspaces/cloud-neutral-toolkit/xstream-vpn/docs/engineering/native-platform-hosts.md)

## 需要继续归并的现有文档

- `CONTRIBUTING.md`

## 本页下一步应补充的内容

- 先描述当前已落地实现，再补充未来规划，避免只写愿景不写现状。
- 术语需要与仓库根 README、构建清单和实际目录保持一致。
- 将上方列出的历史 runbook、spec、子系统说明逐步链接并归并到本页。
- 持续让环境搭建与测试命令对应真实存在的脚本、Make 目标或语言工具链。
