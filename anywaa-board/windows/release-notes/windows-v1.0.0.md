# Anywaa Board for Windows v1.0.0

Anywaa Board adds Dha Anywaa vowel characters to Windows through a native
keyboard layout.

For computers where a keyboard layout cannot be installed, this release also
provides an AutoHotkey v2 fallback with digraph shortcuts.

## Installation

1. Download `AnywaaBoard_Setup_v1.0.0.exe` from this release.
2. Run the installer as an administrator and accept the license.
3. Open **Settings > Time & language > Language & region**.
4. Open the options for an installed language and add **Anywaa Board**.
5. Press **Win + Space** to switch to the layout.

## Key mappings

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

All unmodified keys behave like the standard US QWERTY layout. Digraph
shortcuts are available through the AutoHotkey edition:

| Press | Inserts |
|---|---|
| AltGr + D / N / G / T / Y | dh / nh / ng / th / ny |
| AltGr + Shift + D / N / G / T / Y | DH / NH / NG / TH / NY |

The `.ahk` asset requires AutoHotkey v2. The compiled
`AnywaaBoard_Script.exe` asset does not require AutoHotkey to be installed.

## Uninstallation

Uninstall **Anywaa Board** from **Settings > Apps > Installed apps**. The
uninstaller first removes the MKLC keyboard layout, then removes the wrapper
files and registration.

## Verification

This release must not be published until the Windows 10 and Windows 11
acceptance tests in `windows/release-checklist.md` have passed.
