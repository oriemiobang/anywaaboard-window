# Anywaa Board for Windows

## Current state

The native layout source is in [`layout/anywaa_board.klc`](layout/anywaa_board.klc).
It has not yet been compiled into an installer. Compilation requires
[Microsoft Keyboard Layout Creator](https://www.microsoft.com/en-us/download/details.aspx?id=102134)
on Windows.

The NSIS wrapper is in [`installer/anywaa_board.nsi`](installer/anywaa_board.nsi).
It expects the MKLC-generated package at
`build/mklc_output/setup.exe` and produces
`dist/AnywaaBoard_Setup_v1.0.0.exe`. Use
[`installer/build-installer.ps1`](installer/build-installer.ps1) to validate
the prerequisites and build it.

## Build the native layout

1. Install Microsoft Keyboard Layout Creator.
2. Open `layout/anywaa_board.klc`.
3. Build the DLL and setup package.
4. Install the generated package on a test machine.
5. Add **Anywaa Board** under the keyboard options for an installed Windows
   language.
6. Use **Win + Space** to switch layouts.

The generated package must be tested on both Windows 10 and Windows 11 before
it is wrapped in the NSIS installer described by Issue #3.

## Native layout mappings

| Press | Inserts |
|---|---|
| AltGr + A | ä |
| AltGr + Shift + A | Ä |
| AltGr + E | ë |
| AltGr + Shift + E | Ë |
| AltGr + I | ï |
| AltGr + Shift + I | Ï |
| AltGr + O | ö |
| AltGr + Shift + O | Ö |
| AltGr + X | ø |
| AltGr + Shift + X | Ø |

The native layout does not emit digraphs. `dh`, `nh`, `ng`, `th`, and `ny` are
planned for the AutoHotkey fallback.

## Planned installation package

The release checklist is in [`release-checklist.md`](release-checklist.md), and
the v1.0.0 release-note template is in
[`release-notes/windows-v1.0.0.md`](release-notes/windows-v1.0.0.md). Until
the package exists and passes Windows 10 and Windows 11 testing, do not treat
the MKLC output as a production installer.
