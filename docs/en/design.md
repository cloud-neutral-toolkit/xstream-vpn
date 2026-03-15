# Design

This repository is a Flutter client application and should document platform architecture, build pipeline, and operator troubleshooting.

Use this page to consolidate design decisions, ADR-style tradeoffs, and roadmap-sensitive implementation notes.

## Current code-aligned notes

- Documentation target: `xstream.svc.plus`
- Repo kind: `flutter-app`
- Manifest and build evidence: pubspec.yaml (`xstream`)
- Primary implementation and ops directories: `scripts/`, `test/`, `lib/`, `ios/`, `android/`, `web/`
- Package scripts snapshot: No package.json scripts were detected.

## Existing docs to reconcile

- `VPN_STARTUP_FIX_PLAN.md`
- `dns-secure-tunnel-design.md`
- `ios-design.md`
- `macos-packet-tunnel-implementation.md`
- `multi-platform-vpn-design.md`
- `packet_tunnel_provider_design.md`

## What this page should cover next

- Describe the current implementation rather than an aspirational future-only design.
- Keep terminology aligned with the repository root README, manifests, and actual directories.
- Link deeper runbooks, specs, or subsystem notes from the legacy docs listed above.
- Promote one-off implementation notes into reusable design records when behavior, APIs, or deployment contracts change.
