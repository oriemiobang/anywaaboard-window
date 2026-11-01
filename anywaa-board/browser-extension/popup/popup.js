(() => {
  const extensionApi = globalThis.browser ?? globalThis.chrome;
  const guideUrl = "https://github.com/oriemiobang/anywaaboard-window/blob/main/windows/README.md";
  const toggle = document.querySelector("#toggle");
  const status = document.querySelector("#status");
  const wordCount = document.querySelector("#word-count");
  let activeTab;
  let domainKey;

  function setStatus(message) {
    status.textContent = message;
  }

  async function queryActiveTab() {
    const tabs = await extensionApi.tabs.query({ active: true, currentWindow: true });
    return tabs[0];
  }

  async function refresh() {
    activeTab = await queryActiveTab();
    if (!activeTab?.id || !activeTab.url || !/^https?:/u.test(activeTab.url)) {
      toggle.disabled = true;
      setStatus("This page cannot receive keyboard input.");
      return;
    }
    domainKey = `anywaa_enabled_${new URL(activeTab.url).hostname}`;
    const stored = await extensionApi.storage.local.get(domainKey);
    toggle.checked = stored[domainKey] !== false;
    try {
      const response = await extensionApi.tabs.sendMessage(activeTab.id, { type: "GET_STATUS" });
      wordCount.textContent = `Words learned: ${response?.wordCount ?? 0}`;
    } catch {
      wordCount.textContent = "Words learned: unavailable";
    }
  }

  toggle.addEventListener("change", async () => {
    const enabled = toggle.checked;
    await extensionApi.storage.local.set({ [domainKey]: enabled });
    try {
      await extensionApi.tabs.sendMessage(activeTab.id, { type: "TOGGLE", enabled });
      setStatus(enabled ? "Enabled on this site." : "Disabled on this site.");
    } catch {
      setStatus("Reload the page to apply this setting.");
    }
  });

  document.querySelector("#guide-link").addEventListener("click", (event) => {
    event.preventDefault();
    extensionApi.tabs.create({ url: guideUrl });
  });

  refresh().catch(() => setStatus("Could not read the current site."));
})();
