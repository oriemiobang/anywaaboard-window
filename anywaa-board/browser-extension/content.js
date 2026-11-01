(() => {
  const extensionApi = globalThis.browser ?? globalThis.chrome;
  const GUIDE_URL = "https://github.com/oriemiobang/anywaaboard-window/blob/main/anywaa-board/windows/README.md";
  const MAPPINGS = Object.freeze({
    a: "ä", e: "ë", i: "ï", o: "ö", x: "ø",
    d: "dh", n: "nh", g: "ng", t: "th", y: "ny",
  });
  const UPPERCASE = Object.freeze({
    a: "Ä", e: "Ë", i: "Ï", o: "Ö", x: "Ø",
    d: "DH", n: "NH", g: "NG", t: "TH", y: "NY",
  });
  let enabled = true;
  let suggestionBar;
  let activeField;
  let enabledKey;

  function storageGet(key) {
    return extensionApi.storage.local.get(key);
  }

  async function loadEnabled() {
    enabledKey = `anywaa_enabled_${location.hostname}`;
    const stored = await storageGet(enabledKey);
    enabled = stored[enabledKey] !== false;
  }

  function isEditableField(target) {
    if (!(target instanceof Element)) return false;
    if (target.closest("[contenteditable='true'], [contenteditable=''], input, textarea")) {
      const field = target.closest("[contenteditable='true'], [contenteditable=''], input, textarea");
      if (field.matches("input, textarea")) {
        return !["button", "checkbox", "file", "hidden", "image", "radio", "range", "reset", "submit"].includes(field.type);
      }
      return true;
    }
    return false;
  }

  function editableTarget(target) {
    if (!(target instanceof Element)) return null;
    return target.closest("[contenteditable='true'], [contenteditable=''], input, textarea");
  }

  function insertText(field, text) {
    if (field.matches("input, textarea")) {
      const start = field.selectionStart ?? field.value.length;
      const end = field.selectionEnd ?? start;
      field.setRangeText(text, start, end, "end");
      field.dispatchEvent(new InputEvent("input", { bubbles: true, inputType: "insertText", data: text }));
      return true;
    }

    field.focus();
    if (document.execCommand("insertText", false, text)) return true;
    const selection = window.getSelection();
    if (!selection || !selection.rangeCount) return false;
    const range = selection.getRangeAt(0);
    range.deleteContents();
    range.insertNode(document.createTextNode(text));
    range.collapse(false);
    selection.removeAllRanges();
    selection.addRange(range);
    field.dispatchEvent(new InputEvent("input", { bubbles: true, inputType: "insertText", data: text }));
    return true;
  }

  function currentWord(field) {
    if (field.matches("input, textarea")) {
      const beforeCursor = field.value.slice(0, field.selectionStart ?? field.value.length);
      return beforeCursor.split(/\s/u).pop() ?? "";
    }
    const selection = window.getSelection();
    return selection?.anchorNode?.textContent?.slice(0, selection.anchorOffset).split(/\s/u).pop() ?? "";
  }

  function replaceCurrentWord(field, word) {
    if (field.matches("input, textarea")) {
      const cursor = field.selectionStart ?? field.value.length;
      const beforeCursor = field.value.slice(0, cursor);
      const start = beforeCursor.search(/\S+$/u);
      field.setRangeText(word, start < 0 ? cursor : start, cursor, "end");
      field.dispatchEvent(new InputEvent("input", { bubbles: true, inputType: "insertReplacementText", data: word }));
      return;
    }
    const selection = window.getSelection();
    if (selection?.rangeCount && selection.isCollapsed && selection.anchorNode?.nodeType === Node.TEXT_NODE) {
      const nodeText = selection.anchorNode.textContent ?? "";
      const cursor = selection.anchorOffset;
      const start = nodeText.slice(0, cursor).search(/\S+$/u);
      const range = selection.getRangeAt(0);
      range.setStart(selection.anchorNode, start < 0 ? cursor : start);
      range.setEnd(selection.anchorNode, cursor);
      selection.removeAllRanges();
      selection.addRange(range);
    }
    insertText(field, word);
  }

  function createSuggestionBar() {
    const bar = document.createElement("div");
    bar.id = "anywaa-suggestion-bar";
    bar.setAttribute("role", "listbox");
    bar.style.cssText = "position:fixed;z-index:2147483647;display:flex;gap:2px;background:#fff;border:1px solid #cbd5e1;border-radius:8px;padding:4px;box-shadow:0 4px 16px rgba(15,23,42,.18);font:13px -apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;";
    document.documentElement.appendChild(bar);
    return bar;
  }

  function hideSuggestions() {
    if (suggestionBar) suggestionBar.replaceChildren();
  }

  function showSuggestions(words, field) {
    if (!words.length) {
      hideSuggestions();
      return;
    }
    suggestionBar ??= createSuggestionBar();
    const rect = field.getBoundingClientRect();
    suggestionBar.style.left = `${Math.max(4, rect.left)}px`;
    suggestionBar.style.top = `${Math.max(4, rect.top - 38)}px`;
    suggestionBar.replaceChildren();
    words.forEach((word) => {
      const button = document.createElement("button");
      button.type = "button";
      button.textContent = word;
      button.style.cssText = "border:0;background:transparent;border-radius:5px;color:#1e293b;cursor:pointer;padding:5px 8px;font:inherit;";
      button.addEventListener("mouseenter", () => { button.style.background = "#eff6ff"; });
      button.addEventListener("mouseleave", () => { button.style.background = "transparent"; });
      button.addEventListener("mousedown", (event) => {
        event.preventDefault();
        replaceCurrentWord(field, word);
        hideSuggestions();
      });
      suggestionBar.appendChild(button);
    });
  }

  async function updateSuggestions(field) {
    activeField = field;
    showSuggestions(await AnywaaDictionary.suggest(currentWord(field)), field);
  }

  function onKeydown(event) {
    if (event.key === " " || event.key === "Enter") {
      hideSuggestions();
    }
    const isAltGr = event.getModifierState("AltGraph") || (event.altKey && event.ctrlKey);
    if (!enabled || !isAltGr || event.key.length !== 1) return;
    const field = editableTarget(event.target);
    if (!field || !isEditableField(event.target)) return;
    const key = event.code.startsWith("Key")
      ? event.code.slice(3).toLowerCase()
      : event.key.toLowerCase();
    const text = event.shiftKey ? UPPERCASE[key] : MAPPINGS[key];
    if (!text) return;
    event.preventDefault();
    event.stopPropagation();
    insertText(field, text);
    hideSuggestions();
  }

  async function onInput(event) {
    const field = editableTarget(event.target);
    if (!field || !enabled) return;
    const value = field.matches("input, textarea") ? field.value : field.textContent;
    const committedWord = value?.trimEnd().split(/\s/u).pop() ?? "";
    if (/\s$/u.test(value ?? "")) await AnywaaDictionary.learn(committedWord);
    await updateSuggestions(field);
  }

  function onFocus(event) {
    const field = editableTarget(event.target);
    if (field) updateSuggestions(field);
  }

  function onBlur(event) {
    if (suggestionBar && event.relatedTarget && suggestionBar.contains(event.relatedTarget)) return;
    hideSuggestions();
  }

  extensionApi.runtime.onMessage.addListener((message, _sender, sendResponse) => {
    if (message.type === "TOGGLE") {
      enabled = message.enabled === true;
      if (!enabled) hideSuggestions();
    }
    if (message.type === "GET_STATUS") {
      AnywaaDictionary.count().then((wordCount) => sendResponse({ enabled, wordCount }));
      return true;
    }
    return false;
  });

  document.addEventListener("keydown", onKeydown, true);
  document.addEventListener("input", onInput, true);
  document.addEventListener("focusin", onFocus, true);
  document.addEventListener("focusout", onBlur, true);
  loadEnabled();

  globalThis.AnywaaBoardContent = Object.freeze({
    guideUrl: GUIDE_URL,
    isEnabled: () => enabled,
    getWordCount: () => AnywaaDictionary.count(),
  });
})();
