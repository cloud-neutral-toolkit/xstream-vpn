---
name: xstream-core-tdd
description: Use this skill when adding or refactoring Xstream core logic with TDD, including sync protocol serialization, encryption/decryption, and Packet Tunnel config guards. It provides a red-green-refactor workflow and a focused test matrix for stable core behavior.
---

# Xstream Core TDD

Apply a strict `Red -> Green -> Refactor` loop for core logic that must stay stable across releases.

## When to Use

- Editing `lib/services/sync/*` protocol or crypto code
- Editing `lib/utils/tun_config_guard.dart`
- Reviewing regressions in config serialization and parsing

## Workflow

1. Start with a failing test for one behavior only.
- Run: `flutter test test/sync/...` or `flutter test test/utils/...`

2. Implement the minimum code change to pass.
- Avoid changing unrelated behavior.

3. Refactor with tests still green.
- Keep public behavior unchanged.

4. Repeat per behavior.
- One assertion cluster per behavior.

## Core Test Matrix

1. `SyncCrypto`
- Round-trip encrypt/decrypt must preserve payload bytes.
- Invalid ciphertext length must fail fast.
- Wrong secret must fail authentication.

2. `SyncPayload`
- `SyncRequest.toBytes()` layout must remain stable.
- `clientVersion` byte-length limit must be enforced.
- `parseSyncResponse()` must correctly decode status/version/config/metadata.
- Truncated payload must fail with explicit error.

3. `TunConfigGuard`
- On Apple platforms, non-`utunN` interface fields in `tun` inbound must be removed.
- Valid `utunN` values must be preserved.
- Non-JSON or unrelated payloads must remain unchanged.

Detailed case list: `references/test-cases.md`.

## Exit Criteria

- Added/updated tests cover all modified branches.
- `flutter test` passes for the touched test files.
- No UI layout changes and no feature-scope expansion.
