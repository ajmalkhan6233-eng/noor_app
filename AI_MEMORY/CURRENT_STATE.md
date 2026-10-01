# CURRENT_STATE (2026-10-01)

- Branch: main at 6316681 (octopus-memory merged and pushed; local branch deleted). CI for that push: APK build + Web Preview green.
- Version: 1.1.0+2. Play Store status: unknown for now

## What works (VERIFIED today)
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
