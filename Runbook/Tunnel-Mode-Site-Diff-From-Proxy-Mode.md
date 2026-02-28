# Tunnel Mode 可访问性低于 Proxy Mode 排查 Runbook

最后更新：2026-02-28

## 1. 问题描述

现象：

- 同一节点下，Proxy Mode 可以访问目标站点
- Tunnel Mode 无法直接访问同一站点
- 典型站点：`https://grok.com/`

本案例适用于：

- Xstream 已成功建立 System VPN / Secure Tunnel
- 用户反馈“代理模式正常，Tunnel 模式异常”
- 怀疑是 Packet Tunnel、DNS、QUIC / HTTP3、站点 challenge 或上游传输差异

## 2. 影响范围

影响的是：

- Tunnel Mode 下的目标站点访问体验
- 复杂站点的页面初始化、挑战页、长连接或附加资源加载

通常不代表：

- Packet Tunnel 启动失败
- 节点完全不可用
- 本地 DNS 或 TLS 完全失效

## 3. 已知案例结论

在 `grok.com` 案例中，已验证到：

- Tunnel Mode 控制面正常接管
- 默认路由已切到 `utunN`
- `PacketTunnel` 进程存在
- 运行时 `routing.rules` 为空，没有对目标站点做显式拦截
- `grok.com` 的 DNS 解析正常
- `grok.com` 的 TLS 握手正常

但系统路径访问返回：

- `HTTP/2 403`
- `cf-mitigated: challenge`

同时当前节点为：

- `vless + xhttp + tls`

运行日志中反复出现：

- `INTERNAL_ERROR`
- `unexpected EOF`

这类现象更接近：

- 站点侧 challenge / 风控
- Tunnel Mode 与 Proxy Mode 的数据面语义差异
- 当前 `xhttp` 上游对复杂站点不够稳定

而不是：

- Packet Tunnel 没有接管系统流量

## 4. 诊断步骤

### 4.1 先确认 Tunnel Mode 控制面是否正常

检查系统 VPN 与默认路由：

```zsh
scutil --nc list
scutil --nc status "Xstream"
route -n get default
ps -axo pid,ppid,etime,command | rg 'PacketTunnel|xray'
```

通过标准：

- 默认路由在 `utunN`
- `PacketTunnel` 进程存在

如果这两项不成立，不要进入本 Runbook，先排查 Packet Tunnel 启动问题。

### 4.2 检查运行时配置

确认当前活跃配置与传输方式：

```zsh
BASE="$HOME/Library/Application Support/plus.svc.xstream"
cat "$BASE/configs/config.json"
```

重点观察：

- outbound 协议
- `streamSettings.network`
- 是否为 `xhttp`
- DNS 设置
- `routing.rules`

### 4.3 先做低层可达性排除

```zsh
dig +short grok.com
echo | openssl s_client -connect grok.com:443 -servername grok.com -brief
curl -I --max-time 15 https://grok.com
```

判读：

- `dig` 正常：不是纯 DNS 失败
- `openssl s_client` 正常：不是纯 TLS 握手失败
- `curl` 返回 `403` 且带 `cf-mitigated: challenge`：优先怀疑站点 challenge，而不是 Tunnel 没通

### 4.4 对比系统路径与代理路径

最关键的一步是用同一目标对比：

```zsh
curl -I --max-time 15 https://grok.com
curl -I --proxy socks5h://127.0.0.1:1080 --max-time 15 https://grok.com
```

判读：

- 系统路径 challenge，代理路径正常：
  说明问题更像 Tunnel Mode 数据面差异
- 两条路径都 challenge：
  更偏向站点策略或当前出口信誉
- 系统路径失败，代理路径正常：
  更偏向 Tunnel Mode 数据面问题

### 4.5 检查运行日志中的传输层异常

```zsh
tail -n 300 "$BASE/logs/xray-runtime.log"
```

重点关注：

- `splithttp`
- `INTERNAL_ERROR`
- `unexpected EOF`
- `failed to transfer response payload`

如果当前节点使用 `xhttp` 且日志中持续出现上述错误，应优先怀疑：

- 当前上游传输稳定性不足
- challenge 页或后续资源在该链路上失败

## 5. 推荐使用 MCP 自检工具

如果已启用 `xstream-mcp-server`，优先使用：

- `runtime_config_check`
- `runtime_log_check`
- `runtime_diagnose`
- `runtime_site_path_check`

其中 `runtime_site_path_check` 专门用于本案例，可直接对比：

- 系统路径
- 本地 SOCKS 路径

输入示例：

```json
{
  "url": "https://grok.com/"
}
```

如果返回：

- `classification = system-path-challenge-proxy-ok`

则通常说明：

- Packet Tunnel 控制面正常
- 问题不在“隧道是否接管”
- 优先检查 Tunnel Mode 下的 DNS、QUIC / HTTP3、站点 challenge 与当前节点传输稳定性

## 6. 修复与缓解方案

优先级建议如下。

### 方案 1：更换非 `xhttp` 节点验证

优先用：

- `tcp + tls`

目的：

- 排除当前 `xhttp` 上游不稳定带来的误判

### 方案 2：对比 Tunnel Mode 与 Proxy Mode

保持同一节点不变，只切换模式。

如果只有 Tunnel Mode 异常，则优先看：

- 系统路径与代理路径差异
- QUIC / HTTP3
- 站点 challenge

### 方案 3：针对浏览器做 QUIC 差异验证

在 Tunnel Mode 下，浏览器可能保留更接近直连的访问行为。Proxy Mode 则常常退回到 TCP 代理语义。

因此可进一步验证：

- 禁用浏览器 QUIC 后是否恢复
- 浏览器真实页面是否卡在 challenge / 附加资源加载阶段

### 方案 4：更换出口或节点

如果系统路径和代理路径都被 challenge，通常更偏向：

- 站点风控
- 当前出口信誉

此时应优先更换节点或出口，而不是修改 Packet Tunnel 控制面。

## 7. 验证方法

修复后至少验证：

1. `route -n get default` 仍在 `utunN`
2. `PacketTunnel` 进程仍存在
3. `runtime_site_path_check` 分类不再是 `system-path-challenge-proxy-ok`
4. 浏览器可正常加载目标站点主页
5. 日志中相关站点访问不再持续出现 `INTERNAL_ERROR` / `unexpected EOF`

## 8. 回滚计划

若修改节点或传输方式后出现更大范围访问异常：

1. 切回原节点
2. 回退到 Proxy Mode 保证可用性
3. 保留当前 `config.json`、目标节点配置与运行日志
4. 继续通过 MCP 工具或日志做离线比较

## 9. 结论模板

可直接用于问题记录：

```text
Tunnel Mode 控制面正常，默认路由已在 utunN，PacketTunnel 进程存在。
目标站点 DNS 与 TLS 握手正常，不是基础连通性问题。
系统路径访问返回 challenge，而本地代理路径可正常访问，说明问题更偏向 Tunnel Mode 数据面语义差异，而不是 Packet Tunnel 接管失败。
若当前节点使用 xhttp，且日志中存在 INTERNAL_ERROR / unexpected EOF，应同时怀疑当前上游传输稳定性不足。
```
