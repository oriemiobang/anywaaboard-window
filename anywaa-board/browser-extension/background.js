const extensionApi = globalThis.browser ?? globalThis.chrome;

extensionApi.runtime.onInstalled.addListener(() => {
  extensionApi.storage.local.set({ anywaa_enabled_defaults: true });
});
