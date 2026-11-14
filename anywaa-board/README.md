# Anywaa Board — Dha Anywaa Keyboard for Windows

> **Type Dha Anywaa (Anuak) on any Windows PC.** Download `AnywaaBoard.exe`, double-click, and start typing — no installation wizard, no admin rights needed.

[![Download AnywaaBoard.exe](https://img.shields.io/github/v/release/oriemiobang/anywaaboard-window?label=Download%20AnywaaBoard.exe&style=for-the-badge&color=2E86C1)](https://github.com/oriemiobang/anywaaboard-window/releases/latest/download/AnywaaBoard.exe)

[![GitHub Release](https://img.shields.io/github/v/release/oriemiobang/anywaaboard-window?style=flat-square)](https://github.com/oriemiobang/anywaaboard-window/releases/latest)
[![License](https://img.shields.io/github/license/oriemiobang/anywaaboard-window?style=flat-square)](LICENSE)
[![Downloads](https://img.shields.io/github/downloads/oriemiobang/anywaaboard-window/total?style=flat-square&color=green)](https://github.com/oriemiobang/anywaaboard-window/releases)

---

## What is Anywaa Board?

**Anywaa Board** is a free, lightweight keyboard tool that lets you type **Dha Anywaa (Anuak)** characters on Windows. It adds special vowels (ä, ë, ï, ö, ø) and digraphs (dh, nh, ng, th, ny) using the **Right Alt (AltGr)** key — your normal keyboard stays exactly the same.

### Who is this for?

- Dha Anywaa / Anuak speakers who want to type in their language on Windows
- Students, teachers, and translators working with the Anuak language
- Anyone who needs Dha Anywaa characters for documents, messages, or social media

## ⬇️ Download & Install

### Option 1: Quick Download (Recommended)

1. **[Download AnywaaBoard.exe](https://github.com/oriemiobang/anywaaboard-window/releases/latest/download/AnywaaBoard.exe)** (1.4 MB)
2. Double-click the file
3. The setup runs automatically — done!

Anywaa Board installs itself and **starts automatically every time Windows boots**. No admin rights needed. Share the `.exe` file with friends via WhatsApp, Telegram, or email.

### Option 2: Browser Extension

For typing Dha Anywaa directly in Chrome or Firefox, see the [browser extension](browser-extension/).

## ⌨️ Key Mappings

Use **Right Alt (AltGr)** as the modifier key. All other keys work normally.

### Special Vowels

| Press | Types | Character |
|---|---|---|
| `RAlt + A` | ä | a with diaeresis |
| `RAlt + E` | ë | e with diaeresis |
| `RAlt + I` | ï | i with diaeresis |
| `RAlt + O` | ö | o with diaeresis |
| `RAlt + X` | ø | o with stroke |

> Hold **Shift** for uppercase: `RAlt + Shift + A` → **Ä**

### Digraphs

| Press | Types | Uppercase |
|---|---|---|
| `RAlt + D` | dh | DH |
| `RAlt + N` | nh | NH |
| `RAlt + G` | ng | NG |
| `RAlt + T` | th | TH |
| `RAlt + Y` | ny | NY |

## 🖥️ System Requirements

- **Windows 10** or **Windows 11**
- No admin rights required
- No internet connection needed after download
- File size: ~1.4 MB

## 🔧 How It Works

When you double-click `AnywaaBoard.exe`:

1. **Setup window** appears with a progress bar
2. The app installs to `%LOCALAPPDATA%\Programs\AnywaaBoard\`
3. Auto-startup is configured (Registry + Startup folder)
4. The keyboard is immediately active

On every Windows boot, Anywaa Board starts silently in the background with a notification badge confirming it's active.

### System Tray Menu

Right-click the Anywaa Board icon in the system tray (bottom-right):

- **Anywaa Board - Active** — Shows status
- **Open key mapping guide** — View all shortcuts
- **Run on startup** — Toggle auto-start (enabled by default)
- **Uninstall Anywaa Board** — Completely removes the app
- **Exit** — Stop until next restart

## 🗑️ Uninstall

Right-click the tray icon → **Uninstall Anywaa Board**. This removes:
- The installed executable
- Registry startup entries
- Start Menu shortcuts
- Startup folder shortcut

## 📁 Repository Layout

```text
anywaa-board/
├── docs/
│   └── windows-key-mapping.md       # Key mapping design decisions
├── windows/
│   ├── AnywaaBoard.ahk              # AutoHotkey v2 source
│   ├── build-ahk.ps1                # Build script (AHK → EXE)
│   ├── installer/                   # NSIS installer (native layout)
│   ├── layout/
│   │   └── anywaa_board.klc         # MKLC keyboard layout source
│   └── release-notes/
├── browser-extension/                # Chrome & Firefox extension
│   ├── content.js
│   ├── manifest.json
│   └── popup/
└── README.md
```

## 🛠️ Building from Source

### Prerequisites

- [AutoHotkey v2](https://www.autohotkey.com/) (includes the Ahk2Exe compiler)

### Build

```powershell
cd windows
.\build-ahk.ps1
```

The compiled executable is written to `windows/dist/AnywaaBoard.exe`.

## 📜 License

This project is open source. See [LICENSE](windows/installer/license.txt) for details.

## 🙌 Contributing

Contributions are welcome! If you speak Dha Anywaa and notice a mapping issue, please open an issue or pull request.

## 🔗 Links

- **Download:** [Latest Release](https://github.com/oriemiobang/anywaaboard-window/releases/latest)
- **Issues:** [Report a Bug](https://github.com/oriemiobang/anywaaboard-window/issues)
- **Publisher:** [Bella Technologies](https://bellatechnologies.com)

---

<p align="center">
  Made with ❤️ for the Anywaa community by <a href="https://bellatechnologies.com">Bella Technologies</a>
</p>

<!-- SEO keywords: anywaa board, anywaa keyboard, dha anywaa keyboard, anuak keyboard, anuak keyboard for windows, dha anywaa keyboard for windows, type anuak on windows, anuak characters windows, anywaa board download, dha anywaa typing tool -->
