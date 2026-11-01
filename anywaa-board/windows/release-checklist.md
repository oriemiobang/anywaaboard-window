# Windows v1.0.0 release checklist

This checklist is intentionally not marked complete until the generated
installer has been tested on real Windows 10 and Windows 11 machines.

## Build and installer validation

- [ ] Build `windows/layout/anywaa_board.klc` with Microsoft Keyboard Layout Creator.
- [ ] Copy the generated MKLC `setup.exe` to `windows/build/mklc_output/setup.exe`.
- [ ] Install NSIS and confirm `makensis` is available on `PATH`.
- [ ] Run `windows/installer/build-installer.ps1`.
- [ ] Confirm `windows/dist/AnywaaBoard_Setup_v1.0.0.exe` is smaller than 5 MB.
- [ ] Test installation on a clean Windows 10 machine.
- [ ] Test installation on a clean Windows 11 machine.
- [ ] Confirm the layout appears in Windows keyboard settings without rebooting.
- [ ] Test all ten vowel mappings in Notepad, Word, Chrome, WhatsApp Web, and VS Code.
- [ ] Confirm normal US QWERTY keys remain unchanged.
- [ ] Uninstall from Windows Settings and confirm the layout and DLL are removed.

## GitHub release

- [ ] Confirm the repository remote and release permissions.
- [ ] Commit source and documentation changes.
- [ ] Create tag `windows-v1.0.0`.
- [ ] Create release titled `Anywaa Board for Windows v1.0.0`.
- [ ] Attach `AnywaaBoard_Setup_v1.0.0.exe`.
- [ ] Publish the notes in `windows/release-notes/windows-v1.0.0.md`.
- [ ] Download the release asset from GitHub.
- [ ] Install the downloaded asset and repeat the smoke tests.
