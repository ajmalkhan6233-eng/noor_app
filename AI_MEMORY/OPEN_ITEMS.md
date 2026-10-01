# OPEN_ITEMS (full detail: docs/NEEDS_DECISION.md, CLAUDE.md "Genuinely open")

- Fix CI signing: Aj re-copies RELEASE_KEYSTORE_BASE64 in GitHub Settings > Secrets (steps in CLAUDE_HISTORY.md)
- Decide first-launch wipe of tracker data (lib/main.dart:19-28): keep or only wipe if DB looks restored. Reply "keep" or "restore-only"
- Decide Dawn accent: approve 0xFF8A5A00 for text? Reply "approve amber" or "leave"
- Qibla glitch: needs real GPU/compositor trace before re-enabling; Aj to say when to start
- Progress edit window: 2 days editable vs 14 shown; reply "widen" or "label"
- Play Console: answer SCHEDULE_EXACT_ALARM declaration (Aj)
- Bundled audio 44 MB: keep offline or move to download (Aj decision)
- Tamil/Sinhala + prayer names: need Aj/translator approval (religious wording)
- Azkar still 74 vs ~150: each entry needs a Hisn al-Muslim source fetch
- Adhan reciters beyond 5: need a clearly licensed named reciter
- Pull 4 remote commits on main: Aj says "pull"
- adhan internal import risk (prayer_repository.dart:10): decision needed before upgrading adhan
- Stale .clinerules contradicts CLAUDE.md (INTERNET rule, palette file): Aj to say "update .clinerules" or ignore
- 17 lib files over 150 lines: split only with device verification
