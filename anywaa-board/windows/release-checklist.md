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

## Milestone 2 AutoHotkey assets

- [ ] Run `windows/milestone-2-test-matrix.md` on Windows 10.
- [ ] Run `windows/milestone-2-test-matrix.md` on Windows 11.
- [ ] Build `windows/AnywaaBoard.ahk` with `windows/build-ahk.ps1`.
- [ ] Confirm `windows/dist/AnywaaBoard_Script.exe` is under 2 MB.
- [ ] Test the compiled executable on a clean Windows machine without AutoHotkey.
- [ ] Attach `AnywaaBoard.ahk` and `AnywaaBoard_Script.exe` to the GitHub release.

## Milestone 3 browser extension

- [ ] Run `browser-extension/TESTING.md` in Chrome.
- [ ] Run `browser-extension/TESTING.md` in Firefox.
- [ ] Build the Chrome ZIP with `package-extension.ps1 -Browser chrome`.
- [ ] Build the Firefox ZIP with `package-extension.ps1 -Browser firefox`.
- [ ] Submit the Chrome package to the Chrome Web Store.
- [ ] Submit the Firefox package to Mozilla Add-ons.
- [ ] Publish the privacy policy before store submission.

## Final release gate

- [ ] Replace the installer license placeholder with Bella Technologies'
  approved legal license text.
- [ ] Confirm the GitHub repository URL used by the mapping-guide links.
- [ ] Confirm the public privacy-policy URL is live over HTTPS.
- [ ] Record tool versions and test results for every supported platform.
