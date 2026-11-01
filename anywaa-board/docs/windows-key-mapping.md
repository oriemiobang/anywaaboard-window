# Anywaa Board Windows key mapping

## Scope

This document records the proposed AltGr mapping for the standard US QWERTY
base layout. `AltGr` means the physical Right Alt key. On Windows, the
equivalent `Ctrl+Alt` combination may be recognized by some applications, but
Right Alt is the supported interaction.

The base keyboard remains unchanged: pressing a key without AltGr produces the
same output as the standard US QWERTY layout.

## Vowel and special-character mappings

| Key combination | Output | Unicode | Rationale |
|---|---|---|---|
| AltGr + A | ä | U+00E4 | A is the base letter. |
| AltGr + Shift + A | Ä | U+00C4 | Uppercase form of ä. |
| AltGr + E | ë | U+00EB | E is the base letter. |
| AltGr + Shift + E | Ë | U+00CB | Uppercase form of ë. |
| AltGr + I | ï | U+00EF | I is the base letter. |
| AltGr + Shift + I | Ï | U+00CF | Uppercase form of ï. |
| AltGr + O | ö | U+00F6 | O is the base letter. |
| AltGr + Shift + O | Ö | U+00D6 | Uppercase form of ö. |
| AltGr + X | ø | U+00F8 | X is a memorable available key in the base layout. |
| AltGr + Shift + X | Ø | U+00D8 | Uppercase form of ø. |

## Digraph mappings

These are part of the complete Anywaa Board interaction design, but are not
implemented in the MKLC layout:

| Key combination | Output | Unicode | Rationale |
|---|---|---|---|
| AltGr + D | dh | — | D is the first letter. |
| AltGr + N | nh | — | N is the first letter. |
| AltGr + G | ng | — | G is the final letter. |
| AltGr + T | th | — | T is the first letter. |
| AltGr + Y | ny | — | Y represents the `y` sound. |

MKLC emits one character per key event and cannot directly produce these
two-character strings. The AutoHotkey v2 fallback will provide lowercase and
uppercase digraph output in Milestone 2.

## Compatibility review

The mapping uses Unicode Latin characters with diaeresis or stroke and does
not alter unmodified US QWERTY output. A formal conflict review against
installed Windows language layouts remains a release acceptance task. It must
be performed on a Windows 10 and Windows 11 test machine before publishing an
installer.

## Review checklist

- [ ] Reviewed by at least one native Dha Anywaa speaker.
- [ ] Confirmed that the five vowel pairs are intuitive.
- [ ] Compared with the Windows US international and other installed layouts.
- [ ] Verified AltGr output in Notepad, Word, Chrome, WhatsApp Web, and VS Code.
- [ ] Verified normal key output remains unchanged.
