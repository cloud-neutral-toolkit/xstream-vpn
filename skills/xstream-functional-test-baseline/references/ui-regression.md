# UI Regression

Use this matrix when the user asks for complete UI confidence instead of command-only validation.

## Preconditions

- At least one node exists in the node list.
- The app launches successfully.
- Start from a clean, known state:
  `GlobalState.activeNodeName` empty, no competing System VPN connected, and either Tunnel Mode or Proxy Mode selected intentionally.
- Do not treat UI labels alone as evidence. Re-check system state after each action.

## Coverage Matrix

### Home screen

Validate these flows:

1. Start in Tunnel Mode from the node list.
- Select a node.
- Trigger start from the Home screen.
- Expect success message instead of failure toast.
- Re-check:
  `scutil --nc status "Xstream"`,
  `route -n get default`,
  `ps -axo pid,ppid,etime,command | rg 'PacketTunnel|xray'`.

2. Stop in Tunnel Mode from the active node state.
- Trigger stop from the Home screen.
- Expect active node state to clear.
- Re-check:
  `scutil --nc status "Xstream"` no longer reports connected.

3. Start in Proxy Mode from the node list.
- Switch to Proxy Mode first.
- Trigger start from the Home screen.
- Expect the selected node to become active.
- Re-check:
  `lsof -nP -iTCP:1080 -iTCP:1081 -sTCP:LISTEN`,
  `ps -axo pid,ppid,etime,command | rg '/xray|xray '`.

4. Switch node while already connected.
- Start one node.
- Start a different node from the Home screen.
- Expect the old connection to stop and the new node to become active.
- Re-check the mode-appropriate runtime evidence after the switch.

### Settings screen

Validate these flows:

1. Toggle `隧道模式` on.
- Use the Settings switch wired to `GlobalState.setTunnelModeEnabled(true)`.
- Expect the mode change to propagate without changing layout.
- Expect the user-facing prompt to reconnect.

2. Toggle `隧道模式` off.
- Expect the mode to become Proxy Mode.
- Expect reconnect to be required.

3. Refresh visible tunnel status.
- After enabling Tunnel Mode and connecting, the settings status text should reflect connected or connecting state.
- Compare the displayed status with `NativeBridge.getPacketTunnelStatus()` evidence from system commands.

4. Permission guide path.
- If Tunnel Mode start fails with a permission-like message, confirm the permission guide dialog appears.
- Do not force this case unless the user explicitly wants failure-path testing.

### macOS status menu

Validate these flows:

1. Start Acceleration.
- From a disconnected state, use the menu item.
- If no node is selected, the menu may fall back to the first node from `vpn_nodes.json`.
- Re-check mode-appropriate runtime evidence after start.

2. Stop Acceleration.
- From a connected state, use the menu item.
- Expect the menu status to become disconnected.
- Re-check that the active connection is actually down.

3. Reconnect.
- From a connected state, use `Reconnect`.
- Expect stop then start behavior, not a stale connected UI.
- Re-check that the session was recreated cleanly.

4. Mode switching from menu.
- Toggle `Tun Mode`.
- Toggle `Proxy Only`.
- Expect the mode switch to route through Flutter and require reconnect.
- Re-check that the next start follows the selected path:
  Tunnel Mode uses `PacketTunnel`,
  Proxy Mode uses local proxy listeners.

## External confirmation after UI actions

After at least one successful start in each mode under test:

1. Run the local mode baseline checks again.
2. Then validate real browsing targets from `external-validation.md`.
3. Record which UI entry point established the active session:
   `Home`, `Settings`, or `Status Menu`.

## Pass Criteria

- UI state, menu state, and system state all agree after each action.
- Tunnel Mode actions result in `Xstream` and `utunN` evidence.
- Proxy Mode actions result in `1080/1081` listener evidence and standalone runtime evidence.
- Reconnect produces a real restart, not only a label refresh.
- Mode switch does not silently leave the old mode running.
- At least one successful browsing check exists for each mode that was exercised.
