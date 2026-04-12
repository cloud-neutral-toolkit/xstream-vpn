param(
  [Parameter(Mandatory = $true)]
  [string]$FlutterVersion
)

$ErrorActionPreference = "Stop"

$installRoot = Join-Path $env:RUNNER_TEMP "flutter-sdk"
if (Test-Path $installRoot) {
  Remove-Item -Recurse -Force $installRoot
}
New-Item -ItemType Directory -Path $installRoot | Out-Null

$archive = Join-Path $installRoot "flutter-sdk.zip"
$flutterUri = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_${FlutterVersion}-stable.zip"
$attempt = 0
while ($true) {
  try {
    $attempt++
    Invoke-WebRequest -Uri $flutterUri -OutFile $archive -TimeoutSec 600
    break
  } catch {
    if ($attempt -ge 5) { throw }
    Start-Sleep -Seconds 2
  }
}
Expand-Archive -Path $archive -DestinationPath $installRoot -Force

"$installRoot\flutter\bin" | Out-File -FilePath $env:GITHUB_PATH -Encoding utf8 -Append
& "$installRoot\flutter\bin\flutter.bat" --version
