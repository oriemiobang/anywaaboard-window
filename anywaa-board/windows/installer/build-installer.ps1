$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$installerDirectory = $PSScriptRoot
$sourcePackage = Join-Path $installerDirectory '..\build\mklc_output\setup.exe'
$outputDirectory = Join-Path $installerDirectory '..\dist'
$script = Join-Path $installerDirectory 'anywaa_board.nsi'

if (-not (Test-Path -LiteralPath $sourcePackage -PathType Leaf)) {
    throw "MKLC output not found: $sourcePackage. Build the .klc source with MKLC first."
}

$makensis = Get-Command makensis -ErrorAction SilentlyContinue
if ($null -eq $makensis) {
    throw 'NSIS was not found on PATH. Install NSIS, then run this script again.'
}

New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
Push-Location $installerDirectory
try {
    & $makensis.Source $script
    if ($LASTEXITCODE -ne 0) {
        throw "makensis failed with exit code $LASTEXITCODE."
    }
}
finally {
    Pop-Location
}

$output = Join-Path $outputDirectory 'AnywaaBoard_Setup_v1.0.0.exe'
if (-not (Test-Path -LiteralPath $output -PathType Leaf)) {
    throw "NSIS completed without producing the expected output: $output"
}

Write-Host "Created $output"
