# Browser extension validation

## Local loading

### Chrome

1. Open `chrome://extensions`.
2. Enable Developer mode.
3. Select **Load unpacked** and choose `browser-extension`.
4. Confirm the service worker has no errors.

### Firefox

1. Open `about:debugging#/runtime/this-firefox`.
2. Select **Load Temporary Add-on**.
3. Choose `browser-extension/manifest_firefox.json`.
4. Confirm the background and content scripts have no errors.

## Functional matrix

Test both browsers and record the browser version:

- AltGr plus `A E I O X` inserts `ä ë ï ö ø`.
- AltGr plus Shift plus those keys inserts uppercase variants.
- AltGr plus `D N G T Y` inserts `dh nh ng th ny`.
- AltGr plus Shift plus those keys inserts uppercase digraphs.
- Non-AltGr typing is unchanged.
- Inputs, textareas, and ordinary contenteditable fields work.
- WhatsApp Web, Gmail, Facebook, and VS Code web are tested separately.
- Google Docs is tested separately; its canvas/editor implementation may not
  expose a standard contenteditable selection.
- Popup toggle persists independently for each hostname.
- The suggestion bar appears above the active field and disappears on blur,
  Space, Enter, and disable.
- Repeated words increment frequency.
- The extension dictionary retains `ä`, `ë`, `ï`, `ö`, and `ø` across sites
  and browser sessions.
- A dictionary larger than 10,000 words is pruned automatically.

## Packaging

```powershell
.\package-extension.ps1 -Browser chrome
.\package-extension.ps1 -Browser firefox
```

The generated ZIP files are written to `browser-extension/dist/` and are
excluded from source control.

The store submission must also include the published
[`privacy-policy.md`](privacy-policy.md) URL.

- Confirm the supplied Anywaa Board icon appears in the toolbar and popup.
- Confirm the Bella Technologies mark appears in the popup footer.
