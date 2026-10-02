# CURRENT_STATE (updated 2026-10-02)

- Branch: main at 004322f (matches remote on 2026-10-02). CI status for 004322f: not checked. Earlier push 6316681 had APK build + Web Preview green.
- Version: 1.1.1+3 (adds Settings "Check for update" row). Play Store status: unknown for now

## What works (VERIFIED 2026-10-01, NOT re-verified since 1.1.1+3)
- flutter analyze: No issues found
- flutter test: 607 passed, 0 failed
- GitHub: arm64 APK run #5 (36836555627) success; Web Preview success; signing workflow green but debug-signed
- Nothing run on a physical device

## What works (per docs, UNVERIFIED by me)
- Prayer times/alarms, Quran reader, Azkar (74), 5 adhan reciters, Tasbih, interactive progress, calendar, zakat, 4 themes, EN+Tamil

## Known problems
- Qibla: GPU glitch history (CLAUDE.md says hidden; latest commits mention a lean Qibla screen: re-check before trusting)
- Release signing: RELEASE_KEYSTORE_BASE64 empty/invalid (Aj fixes the secret)
- Daily checklist sometimes pre-checked on fresh install; first-launch wipe may delete testers' ticks
- Dawn gold accent contrast 1.60:1 (decision needed)
- Many lib files over 150 lines (CI warns)
- Tamil/Sinhala for new UI = English placeholders
- .clinerules outdated (CLAUDE.md wins)

## Next physical action
- Aj: pick one item from OPEN_ITEMS.md and say GO.
