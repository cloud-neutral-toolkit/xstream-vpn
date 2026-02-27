# macOS Baseline

## Tunnel Mode

Use these commands:

```bash
scutil --nc list
scutil --nc status "Xstream"
route -n get default
ps -axo pid,ppid,etime,command | rg 'PacketTunnel|xray'
curl -I --max-time 12 https://example.com
/usr/bin/log show --last 10m --style compact --predicate 'subsystem == "plus.svc.xstream" OR process CONTAINS "PacketTunnel" OR process == "nesessionmanager"'
```

Expected pass signals:

- `Xstream` is `Connected`.
- Competing System VPN entries are `Disconnected`.
- `scutil --nc status` shows a live `utunN` interface with IPv4 or IPv6 assigned.
- `route -n get default` points to the same `utunN`.
- `ps` shows `PacketTunnel.appex` running.
- `curl -I` returns an HTTP response instead of timing out.
- Recent logs do not contain `start failed`, `permission denied`, `unsupported`, or `superceded by another configuration` for the active session.

Typical fail patterns:

- `Disconnected` with `last stop reason Configuration was superceded by another configuration`:
  another System VPN replaced Xstream.
- `Packet Tunnel status not ready: unsupported`:
  status-query path failed; inspect app logs and Pigeon bindings.
- `Connected` but default route is not `utunN`:
  routing is not fully applied.
- `Connected` and `utunN` exists but `curl` fails:
  data-plane issue inside Packet Tunnel or Xray runtime.

## Proxy Mode

Use these commands:

```bash
networksetup -getwebproxy Wi-Fi
networksetup -getsecurewebproxy Wi-Fi
networksetup -getsocksfirewallproxy Wi-Fi
lsof -nP -iTCP:1080 -iTCP:1081 -sTCP:LISTEN
ps -axo pid,ppid,etime,command | rg '/xray|xray '
curl -I --max-time 12 https://example.com
```

Expected pass signals:

- `Xstream` is not required to be connected.
- Local listeners exist on `127.0.0.1:1080` or `127.0.0.1:1081`.
- System proxy output matches the active proxy configuration when Xstream manages system proxies.
- A standalone `xray` runtime process is present when Proxy Mode is active.
- Traffic succeeds through the configured proxy path.

Interpretation notes:

- Tunnel Mode and Proxy Mode are different baselines. Do not require both to be active at the same time.
- In Tunnel Mode, system Web Proxy and Secure Web Proxy usually remain `Enabled: No`.
- In Proxy Mode, the key evidence is local proxy listeners and matching proxy settings, not `utunN`.
