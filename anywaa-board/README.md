# Anywaa Board for Windows

Anywaa Board makes Dha Anywaa characters available on Windows through a native
keyboard layout and an optional AutoHotkey fallback.

## Project status

The project is currently bootstrapped from the Windows V2 issue specification.
Milestones 1, 2, and 3 are implemented in source and awaiting platform
acceptance testing:

- Issue #1: mapping decision record created in [`docs/windows-key-mapping.md`](docs/windows-key-mapping.md)
- Issue #2: MKLC source scaffold created at [`windows/layout/anywaa_board.klc`](windows/layout/anywaa_board.klc)
- Issues #3 and #4: installer and release packaging are scaffolded
- Issue #5: AutoHotkey v2 source created
- Issue #6: reproducible Ahk2Exe build script created
- Issues #7-#12: browser extension source, packaging, testing, and privacy
  documentation created

The `.klc` file must be opened and built with Microsoft Keyboard Layout
Creator on Windows. The generated installer is intentionally not committed
until it has been built and tested on supported Windows versions.

## Repository layout

```text
anywaa-board/
├── docs/
│   └── windows-key-mapping.md
├── windows/
│   ├── AnywaaBoard.ahk
│   ├── build-ahk.ps1
│   ├── installer/
│   │   ├── anywaa_board.nsi
│   │   ├── build-installer.ps1
│   │   └── license.txt
│   ├── layout/
│   │   └── anywaa_board.klc
│   ├── milestone-2-test-matrix.md
│   ├── release-notes/
│   │   └── windows-v1.0.0.md
│   ├── release-checklist.md
│   └── README.md
├── browser-extension/
│   ├── content.js
│   ├── dictionary.js
│   ├── assets/
│   ├── manifest.json
│   ├── manifest_firefox.json
│   ├── popup/
│   └── TESTING.md
└── README.md
```

## Development sequence

1. Review the mapping with a native Dha Anywaa speaker.
2. Open and build the `.klc` source with MKLC.
3. Test the generated layout on Windows 10 and Windows 11.
4. Build the NSIS installer only after the MKLC package is verified.
5. Create the GitHub release only after the installer smoke tests pass.
6. Test the AutoHotkey fallback on supported Windows versions.
7. Test the browser extension in Chrome and Firefox.
8. Publish only after all release checklist items are complete.

## Important limitation

MKLC maps a key combination to a single Unicode character. The digraphs
`dh`, `nh`, `ng`, `th`, and `ny` therefore cannot be emitted natively as
two-character strings by this layout. They are reserved for the AutoHotkey
implementation in Milestone 2.
