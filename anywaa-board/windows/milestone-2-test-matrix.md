# Milestone 2 AutoHotkey test matrix

Run these tests with AutoHotkey v2 on Windows 10 and Windows 11. The script
must be tested in both the `.ahk` form and the compiled executable form.

| Area | Test | Expected result |
|---|---|---|
| Vowels | RAlt+A, E, I, O, X | `ä ë ï ö ø` |
| Uppercase vowels | RAlt+Shift+A, E, I, O, X | `Ä Ë Ï Ö Ø` |
| Digraphs | RAlt+D, N, G, T, Y | `dh nh ng th ny` |
| Uppercase digraphs | RAlt+Shift+D, N, G, T, Y | `DH NH NG TH NY` |
| Normal keys | Type every unbound key with and without modifiers | Standard output is unchanged |
| Tray | Start the script | Tray icon and Active menu item appear |
| Mapping guide | Click the tray guide item | Windows README opens |
| Startup enable | Click Run on startup, sign out, sign in | Script starts automatically |
| Startup disable | Click Run on startup again, sign out, sign in | Script no longer starts |
| Exit | Click Exit | Tray icon disappears and process exits |
| Applications | Notepad, Word, Chrome, WhatsApp Web, Gmail, VS Code | All mappings insert correctly |
| Compiled form | Repeat all tests with `AnywaaBoard_Script.exe` | Same behavior without AutoHotkey installed |

Record the Windows version, AutoHotkey version, application version, and
result for each test before publishing release assets.
