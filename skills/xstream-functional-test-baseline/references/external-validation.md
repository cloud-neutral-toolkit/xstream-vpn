# External Validation

Use this reference when the user wants a real-world browsing check after local Tunnel Mode or Proxy Mode baseline checks already pass.

## Preconditions

- Complete the relevant local baseline first:
  Tunnel Mode or Proxy Mode must already meet the pass criteria in `macos-baseline.md`.
- Use the currently selected mode intentionally.
- If Tunnel Mode is under validation, ensure no competing System VPN is connected.
- Prefer a real browser session.
- If browser automation is available, use it for repeatable checks. If not, perform the checks manually and record what was visible.

## Targets

Validate these benchmarks:

1. `https://chatgpt.com/`
2. `https://gemini.google.com/`
3. `https://grok.com/`

## Minimum Pass Condition

For each target:

- The page opens successfully without a browser error page.
- The main app shell, landing page, or sign-in screen finishes loading.
- Basic interactive readiness is visible:
  an input area, composer, sign-in control, or primary action is rendered and responsive.

Do not require account-specific or destructive actions.
If the user is already signed in, it is enough to confirm that the main prompt or composer surface is usable.
If the user is not signed in, it is enough to confirm that the sign-in or landing experience loads normally.

## Mode-Specific Interpretation

### Tunnel Mode

Use this after `Xstream Secure Tunnel` is connected and the default route is on `utunN`.

Pass evidence:

- The benchmark page loads in the browser.
- System VPN remains connected during the check.
- No competing System VPN replaces the active session.

### Proxy Mode

Use this after local listeners and proxy settings match the expected proxy path.

Pass evidence:

- The benchmark page loads in the browser through the active proxy configuration.
- Local listeners on `1080` or `1081` remain present during the check.
- If Xstream manages system proxies, proxy settings still match the selected proxy mode.

## Reporting Template

For each target, report:

- target URL
- active mode
- page loaded or failed
- visible readiness evidence
- blocking symptom if failed

Example:

- `chatgpt.com`, `Tunnel Mode`, loaded, composer visible, no blocking symptom
- `gemini.google.com`, `Proxy Mode`, failed, browser showed connection error
