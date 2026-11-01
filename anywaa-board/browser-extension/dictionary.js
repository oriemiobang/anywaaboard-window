(() => {
  const extensionApi = globalThis.browser ?? globalThis.chrome;
  const STORAGE_KEY = "anywaa_browser_dict";
  const MAX_WORDS = 10000;
  const MIN_WORD_LENGTH = 2;
  const MAX_SUGGESTIONS = 3;
  const LETTERS_ONLY = /^\p{L}+$/u;

  async function readDictionary() {
    try {
      const stored = await extensionApi.storage.local.get(STORAGE_KEY);
      const parsed = stored[STORAGE_KEY] ?? {};
      return parsed && typeof parsed === "object" && !Array.isArray(parsed) ? parsed : {};
    } catch {
      return {};
    }
  }

  async function writeDictionary(dictionary) {
    try {
      await extensionApi.storage.local.set({ [STORAGE_KEY]: dictionary });
      return true;
    } catch {
      return false;
    }
  }

  function sanitize(value) {
    return String(value ?? "").toLocaleLowerCase().replace(/[^\p{L}]/gu, "");
  }

  function prune(dictionary) {
    const entries = Object.entries(dictionary)
      .sort(([, left], [, right]) => {
        const score = (entry) => (entry.frequency * 0.7) + (entry.lastUsed / 1e13);
        return score(right) - score(left);
      })
      .slice(0, Math.floor(MAX_WORDS * 0.7));
    return Object.fromEntries(entries);
  }

  async function save(dictionary) {
    const normalized = Object.keys(dictionary).length > MAX_WORDS
      ? prune(dictionary)
      : dictionary;
    if (!(await writeDictionary(normalized))) {
      await writeDictionary(prune(normalized));
    }
  }

  async function learn(rawWord) {
    const word = sanitize(rawWord);
    if (word.length < MIN_WORD_LENGTH || !LETTERS_ONLY.test(word)) return;
    const dictionary = await readDictionary();
    const now = Date.now();
    const entry = dictionary[word];
    dictionary[word] = entry
      ? { ...entry, frequency: entry.frequency + 1, lastUsed: now }
      : { text: word, frequency: 1, firstSeen: now, lastUsed: now };
    await save(dictionary);
  }

  function scoreEntry(entry, prefix, maxFrequency, now) {
    const normalizedFrequency = entry.frequency / maxFrequency;
    const daysSinceUse = Math.max(0, now - entry.lastUsed) / 86400000;
    const recency = 1 / (daysSinceUse + 1);
    const prefixScore = prefix.length / entry.text.length;
    return (normalizedFrequency * 0.5) + (recency * 0.3) + (prefixScore * 0.2);
  }

  async function suggest(rawPrefix) {
    const prefix = sanitize(rawPrefix);
    if (!prefix) return [];
    const entries = Object.values(await readDictionary())
      .filter((entry) => entry && typeof entry.text === "string" &&
        entry.text.startsWith(prefix) && entry.text !== prefix);
    if (!entries.length) return [];
    const maxFrequency = Math.max(...entries.map((entry) => entry.frequency), 1);
    const now = Date.now();
    return entries
      .sort((left, right) =>
        scoreEntry(right, prefix, maxFrequency, now) -
        scoreEntry(left, prefix, maxFrequency, now))
      .slice(0, MAX_SUGGESTIONS)
      .map((entry) => entry.text);
  }

  async function count() {
    return Object.keys(await readDictionary()).length;
  }

  globalThis.AnywaaDictionary = Object.freeze({ count, learn, suggest });
})();
