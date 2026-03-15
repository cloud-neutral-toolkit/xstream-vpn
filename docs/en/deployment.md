# Deployment

This repository is a Flutter client application and should document platform architecture, build pipeline, and operator troubleshooting.

Use this page to standardize deployment prerequisites, supported topologies, operational checks, and rollback notes.

## Current code-aligned notes

- Documentation target: `xstream.svc.plus`
- Repo kind: `flutter-app`
- Manifest and build evidence: pubspec.yaml (`xstream`)
- Primary implementation and ops directories: `scripts/`, `test/`, `lib/`, `ios/`, `android/`, `web/`
- Package scripts snapshot: No package.json scripts were detected.

## Existing docs to reconcile

- `apple-network-extension-signing-setup.md`

## What this page should cover next

- Describe the current implementation rather than an aspirational future-only design.
- Keep terminology aligned with the repository root README, manifests, and actual directories.
- Link deeper runbooks, specs, or subsystem notes from the legacy docs listed above.
- Verify deployment steps against current scripts, manifests, CI/CD flow, and environment contracts before each release.
