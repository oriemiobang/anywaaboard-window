param(
    [ValidateSet('chrome', 'firefox')]
    [string]$Browser = 'chrome'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$root = $PSScriptRoot
$dist = Join-Path $root 'dist'
$staging = Join-Path $root ".staging-$Browser"
$archive = Join-Path $dist "anywaa-board-$Browser-v1.0.0.zip"

if (Test-Path -LiteralPath $staging) {
    Remove-Item -LiteralPath $staging -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $staging, $dist | Out-Null

Get-ChildItem -LiteralPath $root -File |
    Where-Object { $_.Extension -in '.js', '.json' -and $_.Name -ne 'manifest_firefox.json' } |
    Copy-Item -Destination $staging

if ($Browser -eq 'firefox') {
    Copy-Item (Join-Path $root 'manifest_firefox.json') (Join-Path $staging 'manifest.json')
}

foreach ($directory in @('popup', 'icons', 'assets')) {
    Copy-Item -LiteralPath (Join-Path $root $directory) -Destination $staging -Recurse
}

if (Test-Path -LiteralPath $archive) {
    Remove-Item -LiteralPath $archive -Force
}
Compress-Archive -Path (Join-Path $staging '*') -DestinationPath $archive
Remove-Item -LiteralPath $staging -Recurse -Force
Write-Host "Created $archive"
