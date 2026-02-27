---
name: xstream-functional-test-baseline
description: Verify Xstream functional baseline, UI interaction regression, and external browsing benchmarks on macOS after tunnel, proxy, Packet Tunnel, routing, build, menu, or runtime changes. Use when Codex needs to check whether Xstream is working end to end, confirm Tunnel Mode health, confirm Proxy Mode health, validate start/stop/reconnect/mode-switch behavior from the Home screen, Settings screen, and macOS status menu, validate external site readiness, validate release readiness, or debug regressions in System VPN, Packet Tunnel, local proxy ports, routing, or data-plane connectivity.
---

# Xstream Functional Test Baseline

Run a compact but repeatable macOS verification pass for Xstream.
Prefer proving the current runtime state with system commands over inferring behavior from code.

## Workflow

1. Confirm the workspace and avoid stale assumptions.
- Run from the Xstream repo root.
- Check `git status --short --branch` before interpreting build or runtime results.

2. Validate build health first.
- Run `dart analyze`.
- Run `make macos-arm64` for release packaging.
- If either fails, report that the functional baseline is not clean and stop there unless the user explicitly wants runtime debugging on a dirty build.

3. Validate Tunnel Mode control plane.
- Run `scutil --nc list`.
- Run `scutil --nc status "Xstream"`.
- Run `route -n get default`.
- Run `ps -axo pid,ppid,etime,command | rg 'PacketTunnel|xray'`.
- Interpret results using [`references/macos-baseline.md`](./references/macos-baseline.md).

4. Validate Tunnel Mode data plane.
- Run `curl -I --max-time 12 https://example.com`.
- If needed, run `/usr/bin/log show --last 10m --style compact --predicate 'subsystem == "plus.svc.xstream" OR process CONTAINS "PacketTunnel" OR process == "nesessionmanager"'`.
- Treat a successful HTTP response plus a connected `utunN` default route as the minimum pass condition for Tunnel Mode.

5. Validate Proxy Mode only when the user asks for it or when Tunnel Mode is disabled.
- Check `networksetup -getwebproxy Wi-Fi`.
- Check `networksetup -getsecurewebproxy Wi-Fi`.
- Check `networksetup -getsocksfirewallproxy Wi-Fi`.
- Check local listeners with `lsof -nP -iTCP:1080 -iTCP:1081 -sTCP:LISTEN`.
- Use the expectations in [`references/macos-baseline.md`](./references/macos-baseline.md).

6. Validate UI interaction regression when the user asks for full UI confidence.
- Read [`references/ui-regression.md`](./references/ui-regression.md).
- Exercise the Home screen, Settings screen, and macOS status menu.
- Cover start, stop, reconnect, and mode switching.
- After each UI action, rerun the minimum relevant system checks from [`references/macos-baseline.md`](./references/macos-baseline.md) instead of trusting UI text alone.

7. Validate external browsing benchmarks when the user asks for real-world confirmation.
- Read [`references/external-validation.md`](./references/external-validation.md).
- Run these checks only after Tunnel Mode or Proxy Mode already passes local baseline checks.
- Treat successful page load plus basic interactive readiness as the minimum pass condition.
- Report the active mode used for each external benchmark: `Tunnel Mode` or `Proxy Mode`.

8. Distinguish the failure layer before proposing fixes.
- Build failure: compiler, generated bindings, signing, packaging.
- Control-plane failure: `NETunnelProviderManager`, session status, permissions, Packet Tunnel launch.
- Data-plane failure: `utunN` route present but no real traffic success.
- Proxy-mode failure: local ports or system proxy settings do not match expected mode.

## Reporting Rules

- State what is verified now, not what was verified in a previous turn.
- Separate `Tunnel Mode`, `Proxy Mode`, `Build`, and `Logs`.
- If UI regression was exercised, report covered entry points explicitly:
  `Home`, `Settings`, `Status Menu`.
- If external validation was exercised, report each benchmark separately.
- For external validation, do not report only DNS or TCP reachability. Report browser-visible readiness.
- If Tunnel Mode is healthy, explicitly report:
  `Connected`, `utunN`, default route on `utunN`, PacketTunnel process present, and a successful outbound HTTP check.
- If another VPN is active, call out the competing session by name and treat it as a blocker for exclusive System VPN validation.
- If runtime and build are both healthy but UI interaction was not exercised, say that UI regression coverage is still pending.

## Reference

- Read [`references/macos-baseline.md`](./references/macos-baseline.md) for command expectations and pass/fail criteria.
- Read [`references/ui-regression.md`](./references/ui-regression.md) for the UI interaction matrix.
- Read [`references/external-validation.md`](./references/external-validation.md) for browser-based benchmark targets.
