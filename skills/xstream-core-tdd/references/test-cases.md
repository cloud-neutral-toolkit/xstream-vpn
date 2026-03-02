# Core Test Cases

## SyncCrypto

1. Round-trip encrypt/decrypt
- Input: fixed 32-byte secret + 24-byte nonce + plaintext bytes
- Expect: decrypted bytes equal original plaintext

2. Invalid ciphertext length
- Input: ciphertext shorter than MAC length
- Expect: `StateError`

3. Secret mismatch
- Input: decrypt with wrong secret
- Expect: authentication failure

## SyncPayload

1. Request binary layout
- Input: deterministic request fields
- Expect: stable byte length and field offsets

2. Client version limit
- Input: `clientVersion` > 255 bytes
- Expect: `ArgumentError`

3. Response decode
- Input: valid payload with metadata
- Expect: status/version/config/metadata parsed correctly

4. Truncated payload
- Input: short config bytes or short metadata bytes
- Expect: parse error (`StateError`)

## TunConfigGuard

1. Invalid interface field stripping (Apple platforms)
- Input: `tun` inbound with non-`utunN` values
- Expect: invalid fields removed

2. Valid `utunN` preservation
- Input: all fields use `utunN`
- Expect: no field removal

3. Non-JSON passthrough
- Input: malformed JSON string
- Expect: original payload unchanged
