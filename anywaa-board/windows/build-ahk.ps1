param(
    [string]$Ahk2ExePath
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$windowsDirectory = $PSScriptRoot
$source = Join-Path $windowsDirectory 'AnywaaBoard.ahk'
$outputDirectory = Join-Path $windowsDirectory 'dist'
$output = Join-Path $outputDirectory 'AnywaaBoard_Script.exe'
$icon = Join-Path $windowsDirectory 'installer\assets\anywaa-board.ico'

if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
    throw "AutoHotkey source not found: $source"
}
if (-not (Test-Path -LiteralPath $icon -PathType Leaf)) {
    throw "Application icon not found: $icon"
}

if ([string]::IsNullOrWhiteSpace($Ahk2ExePath)) {
    $pathCompiler = Get-Command Ahk2Exe.exe -ErrorAction SilentlyContinue
    if ($null -ne $pathCompiler) {
        $Ahk2ExePath = $pathCompiler.Source
    }
}

if ([string]::IsNullOrWhiteSpace($Ahk2ExePath)) {
    $candidatePaths = @(
        (Join-Path ${env:ProgramFiles} 'AutoHotkey\Compiler\Ahk2Exe.exe'),
        (Join-Path ${env:ProgramFiles} 'AutoHotkey\v2\Compiler\Ahk2Exe.exe'),
        (Join-Path ${env:ProgramFiles(x86)} 'AutoHotkey\Compiler\Ahk2Exe.exe')
    )
    $Ahk2ExePath = $candidatePaths |
        Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } |
        Select-Object -First 1
}

if ([string]::IsNullOrWhiteSpace($Ahk2ExePath) -or
    -not (Test-Path -LiteralPath $Ahk2ExePath -PathType Leaf)) {
    throw 'Ahk2Exe.exe was not found. Install AutoHotkey v2 or pass -Ahk2ExePath.'
}

# Locate a v2 base executable for the compiler.
$base = Join-Path (Split-Path $Ahk2ExePath) '..\v2\AutoHotkey64.exe'
if (-not (Test-Path -LiteralPath $base -PathType Leaf)) {
    $base = Join-Path ${env:ProgramFiles} 'AutoHotkey\v2\AutoHotkey64.exe'
}

New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

$ahk2ExeArgs = @('/in', $source, '/out', $output, '/icon', $icon)
if (Test-Path -LiteralPath $base -PathType Leaf) {
    $ahk2ExeArgs += @('/base', $base)
}

& $Ahk2ExePath @ahk2ExeArgs
if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
    throw "Ahk2Exe failed with exit code $LASTEXITCODE."
}

if (-not (Test-Path -LiteralPath $output -PathType Leaf)) {
    throw "Ahk2Exe completed without producing: $output"
}

$sizeMb = [Math]::Round((Get-Item -LiteralPath $output).Length / 1MB, 2)
Write-Host "Created $output ($sizeMb MB)"
if ($sizeMb -ge 2) {
    throw "Compiled executable is ${sizeMb} MB; acceptance requires under 2 MB."
}
