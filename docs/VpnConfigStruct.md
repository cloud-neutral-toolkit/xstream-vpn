# VpnConfig 与节点持久化说明

本文对齐当前实现，说明 Xstream 的节点模型、多节点语义、持久化布局，以及运行时 `config.json` 的生成方式。

适用范围：

- Flutter `VpnConfig` / `VpnNode`
- `NativeBridge` 节点启动与切换
- 本地持久化（SQLite / `vpn_nodes.json`）
- 运行时配置目录（`configs/` / `services/` / `logs/`）

## 1. 当前行为概览

Xstream 当前支持：

- 多节点保存
- 多节点切换
- 节点导入、导出、删除

Xstream 当前不支持：

- 多节点同时运行
- 多个并行活跃的 System VPN / Packet Tunnel 会话
- 一个节点内维护多个并行上游并在运行时自动轮换

当前实现的关键约束是：

- 节点列表是多条记录
- 活跃节点只有一条
- Packet Tunnel / Secure Tunnel 启动前，会把选中的节点配置写入统一运行时入口 `config.json`

## 2. 数据结构

### 2.1 `VpnNode`

`VpnNode` 表示一条已保存的节点记录，核心字段如下：

| 字段 | 含义 |
| --- | --- |
| `name` | 节点名称，UI 展示与逻辑索引都依赖此字段 |
| `countryCode` | 节点代码，用于生成配置文件名与服务名 |
| `configPath` | 当前节点对应的 JSON 配置文件路径 |
| `serviceName` | 平台侧启动控制名；桌面平台对应服务文件或任务名 |
| `protocol` | 当前节点协议，例如 `vless` |
| `transport` | 传输层配置，例如 `tcp`、`xhttp` |
| `security` | 传输安全配置，例如 `tls` |
| `enabled` | 是否启用 |

说明：

- `name` 应保持唯一。
- `configPath` 指向单个节点配置文件，而不是统一运行时 `config.json`。

### 2.2 `VpnConfig`

`VpnConfig` 是节点配置的集中管理入口，负责：

- 加载节点列表
- 查询单个节点
- 添加、更新、删除节点
- 导入、导出节点数据
- 生成节点配置文件
- 将节点列表持久化到 SQLite 和 `vpn_nodes.json`

常用方法：

| 方法 | 作用 |
| --- | --- |
| `load()` | 读取本地节点数据 |
| `nodes` | 返回当前内存中的节点列表 |
| `getNodeByName(name)` | 按名称查找节点 |
| `addNode(node)` | 添加节点 |
| `updateNode(node)` | 更新节点 |
| `removeNode(name)` | 从内存移除节点 |
| `saveToFile()` | 同步写回本地持久化 |
| `importFromJson(jsonStr)` | 从导入数据恢复节点列表 |
| `deleteNodeFiles(node)` | 删除节点配置文件、服务文件与持久化记录 |
| `generateContent(...)` | 生成节点 JSON 配置与服务描述 |
| `generateFromVlessUri(...)` | 从 `vless://` 输入生成节点配置 |

## 3. 多节点与单活跃节点语义

### 3.1 支持多节点保存

`VpnConfig` 在内存中使用 `_nodes` 列表管理节点。首页加载后会直接渲染 `VpnConfig.nodes`，因此 UI 层本身按“多节点列表”工作。

这意味着：

- 可以保存多条节点记录
- 可以在首页选择不同节点
- 可以导入后继续保留旧节点

### 3.2 仅允许一个活跃节点

虽然可以保存多条节点记录，但同一时刻只有一个活跃节点：

- `GlobalState.activeNodeName` 只保存一个节点名
- `startNodeForTunnel()` 启动前会停止其他已运行节点
- `startNodeService()` 启动前同样会停止其他节点

因此当前行为应理解为：

- 多节点是“多条可选配置”
- 不是“多条并发运行实例”

### 3.3 统一运行时入口 `config.json`

启动 Packet Tunnel / Secure Tunnel 或代理模式时，不直接把每个节点文件作为长期唯一入口，而是会：

1. 解析选中节点对应的源配置
2. 根据当前模式重写 `inbounds`
3. 写入统一运行时配置 `configs/config.json`
4. 再由当前平台使用这份 `config.json` 启动

因此：

- `node-*-config.json` 是节点源配置
- `config.json` 是当前活跃节点的运行时入口

切换节点时，实际效果是“重写统一运行时配置并重新启动”，而不是同时保留多个活跃运行态。

## 4. 本地持久化布局

### 4.1 主数据源：`app.db`

当前实现中，SQLite 是节点列表的主数据源。应用启动时会优先读取：

- `app.db`
- 表：`vpn_nodes`

`vpn_nodes` 表中保存：

- `name`
- `country_code`
- `config_path`
- `service_name`
- `protocol`
- `transport`
- `security`
- `enabled`
- `updated_at`

说明：

- 如果 SQLite 中已有记录，应用会优先使用 SQLite 数据。
- `vpn_nodes.json` 在当前实现中主要承担兼容与导出作用。

### 4.2 兼容/导出文件：`vpn_nodes.json`

`vpn_nodes.json` 保存的是节点列表的 JSON 快照。

用途：

- 兼容旧实现
- 导出备份
- 当 SQLite 为空时作为回退加载源

注意：

- 若 `app.db` 中已有节点记录，仅修改 `vpn_nodes.json` 不会改变应用实际加载结果。
- 手工排查时应优先检查 SQLite，再检查 `vpn_nodes.json`。

### 4.3 单节点配置：`configs/node-*-config.json`

每个节点会生成自己的 JSON 配置文件，通常位于：

- `configs/node-<code>-config.json`

这类文件用于：

- 保存该节点的源配置
- 作为切换或重建运行时配置时的输入

### 4.4 统一运行时配置：`configs/config.json`

当前活跃节点启动前，会生成统一入口：

- `configs/config.json`

它是：

- 当前运行态实际使用的配置
- 单节点源配置经过模式修正后的结果

### 4.5 服务定义：`services/`

桌面平台会生成服务相关文件，通常位于：

- `services/<serviceName>`

用途：

- 保存平台侧启动控制文件
- 支撑节点启动/停止/状态检查

### 4.6 日志目录：`logs/`

运行日志位于：

- `logs/`

macOS 当前运行态日志文件名为：

- `logs/xray-runtime.log`

## 5. macOS 路径示例

macOS 下，基础目录来自应用支持目录。当前常见路径示例：

```text
~/Library/Application Support/plus.svc.xstream/
```

目录结构通常为：

```text
plus.svc.xstream/
├── app.db
├── vpn_nodes.json
├── bin/
├── configs/
│   ├── config.json
│   └── node-*-config.json
├── services/
└── logs/
```

如果使用受容器约束的分发方式，实际路径可能位于容器内的 `Application Support` 目录；排查时应以应用当前运行环境返回的路径为准。

## 6. 运维查看命令（macOS）

以下命令适合查看节点持久化与当前运行态配置。

先定义基础目录：

```zsh
BASE="$HOME/Library/Application Support/plus.svc.xstream"
```

查看导出/兼容节点快照：

```zsh
cat "$BASE/vpn_nodes.json"
```

查看 SQLite 中的节点记录：

```zsh
sqlite3 "$BASE/app.db" \
  "select name,country_code,config_path,service_name,enabled from vpn_nodes order by updated_at desc, name asc;"
```

查看配置目录：

```zsh
ls -la "$BASE/configs"
```

查看当前运行时配置：

```zsh
cat "$BASE/configs/config.json"
```

查看节点源配置：

```zsh
cat "$BASE/configs/node-<code>-config.json"
```

查看服务定义目录：

```zsh
ls -la "$BASE/services"
```

查看运行日志：

```zsh
tail -n 200 "$BASE/logs/xray-runtime.log"
```

## 7. 运维注意事项

### 7.1 手工排查时以 SQLite 为准

应用加载顺序是：

1. 先读 `app.db`
2. 若 SQLite 无记录，再回退到 `vpn_nodes.json`
3. 回退加载成功后，再迁移回 SQLite

因此：

- 看到 `vpn_nodes.json` 有内容，不代表当前应用一定使用了这份数据
- 节点异常时先查 `app.db`

### 7.2 节点切换会覆盖运行时 `config.json`

`config.json` 不是永久归属某一条节点的文件，而是“当前活跃节点的运行态快照”。排查时不要把它误认为全部节点的源配置。

### 7.3 节点命名应保持稳定且避免前缀冲突

当前生成逻辑会基于节点名推导配置文件名和服务名。如果多个节点使用相同的前缀片段，可能出现生成物覆盖，导致：

- `node-*-config.json` 被覆盖
- 服务定义文件名冲突

运维与测试阶段建议：

- 为节点使用稳定、可区分的命名
- 导入后检查 `configs/` 与 `services/` 中的实际文件名

### 7.4 删除节点会同时清理关联文件

删除节点时，系统会尝试同时删除：

- 节点配置文件
- 服务定义文件
- 本地持久化记录

如果磁盘上仍有残留文件，应进一步检查：

- `configs/`
- `services/`
- `app.db`
- `vpn_nodes.json`
