# Anywaa Board for Windows

## Current state

Brand assets are stored in the repository `assets/` directory. The supplied
Anywaa Board icon is used for browser-extension icons and the Windows
installer icon. The supplied Bella Technologies mark is used in the extension
popup and NSIS installer header.

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

## AutoHotkey fallback

[`AnywaaBoard.ahk`](AnywaaBoard.ahk) provides the same vowel mappings and adds
the five Dha Anywaa digraphs for computers where a keyboard layout cannot be
installed. It requires [AutoHotkey v2](https://www.autohotkey.com/).

Run the source by double-clicking `AnywaaBoard.ahk`. The script remains in the
system tray and only intercepts the documented Right Alt combinations. Use the
tray menu to open this guide, enable or disable startup, or exit.

The supplied Anywaa Board icon is used for the tray icon when the source is
run from this repository and is embedded as the compiled executable icon.

To create the standalone executable, install AutoHotkey v2 and run:

```powershell
.\windows\build-ahk.ps1
```

The script expects `Ahk2Exe.exe` in a standard AutoHotkey installation path.
Alternatively, provide an explicit compiler path:

```powershell
.\windows\build-ahk.ps1 -Ahk2ExePath "C:\Path\To\Ahk2Exe.exe"
```

The output is `windows/dist/AnywaaBoard_Script.exe`. It must be tested on a
clean machine without AutoHotkey before release. See
[`milestone-2-test-matrix.md`](milestone-2-test-matrix.md).

Generated files under `windows/build/` and `windows/dist/` are excluded from
source control. Attach the tested executable to the GitHub release instead of
committing it to the repository.
