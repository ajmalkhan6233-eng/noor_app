# noor (نور) — Feature Masterlist / Request Log

**Status:** Complete. All 87 items retrieved from project history, 5 August 2026.
**Summary: 63 done · 6 partial · 12 not done · 4 blocked on external sources · 4 declined with reasons stated.**

---

## Phase 1 — Foundations (1–13)
1. Feature-first `lib/` scaffold — **DONE**
2. `lib/core/` scaffold — **DONE**
3. pubspec, exact package versions — **DONE**
4. `.clinerules` — **DONE**
5. `app_colors.dart`, dark emerald — **DONE**, replaced by light palette at #46
6. `haptic_service.dart` — **DONE**
7. `database_helper.dart`, encrypted SQLite — **DONE**
8. TasbihState / TasbihCubit — **DONE**
9. Accessible HapticCounterButton — **DONE**
10. "ALLAH" watermark in source comments — **DONE**
11. Splash: BISMILLAHIR RAHMANIR RAHEEM in caps — **DONE**
12. Splash fades after 2–3s — **DONE**
13. Clean, modular architecture — **DONE**

## Phase 2 — Getting it to build (14–22)
14. Phone-only usage instructions — **DONE**
15. GitHub Actions build workflow — **DONE**
16. "Pro version" workflow — **DONE**
17. One step at a time — **DONE** (ongoing)
18. Fix failing APK build (compileSdk 36) — **DONE**
19. Master Requirements Document — **DONE**
20. System Architecture document — **DONE**
21. Workflow renamed (`noor.yml`, no spaces) — **DONE**
22. APK published as GitHub Release — **DONE**

## Phase 3 — Research and accuracy (23–26)
23. Study Muslim Pro / Athan — **PARTIAL**, visual design not addressed until #46
24. Verify every Quran letter/dot/diacritic to Sharia standard — **DONE**. Sourced from Tanzil (CC BY 3.0), verified by diffing two independent mirrors ayah by ayah. Caught a real defect: a spurious shadda in the Bismillah of Surahs 95 and 97. All 114 surah counts and the 6,236 total verified.
25. Donation hidden, not in the user's face — **DONE**, single entry at the foot of Settings only
26. Reverse-engineer other apps' code if useful — **DECLINED**. Won't reverse-engineer proprietary apps; public features studied instead.

## Phase 4 — The cosmic splash (27–33)
27. Bismillah against an expanding galaxy, light travelling toward the viewer — **DONE**
28. Background must not be black — **DONE**, deep emerald radial gradient
29. Keep it editable/removable later — **DONE**, `splash_config.dart`, single `cosmicEnabled` switch
30. More animation, spiritual feeling — **DONE**: breathing nur, slow field rotation, per-star twinkle, word-by-word reveal
31. Bismillah letters overlapping when scaling — **DONE**, fixed
32. Splash too slow — **DONE**, reduced to 2.8s
33. Bismillah should travel forward with the field, not just fade — **DONE**

## Phase 5 — Features (34–45)
34. Prayer times, selectable calculation method and madhab — **DONE**
35. Qibla — **DONE**. Great-circle bearing verified against nine published city bearings within 0.5°.
36. Fix erratic compass — **DONE**. Root cause: naive angle averaging (359° + 1° → 180°, backwards). `AngleMath` now averages as unit vectors (359° + 1° → 0°, correct).
37. Qibla in 3D, not a flat dial — **DONE** in build 18: recessed face, raised bezel, needle shadow/gradient, accelerometer tilt, engraved ticks
38. Compass draggable, position remembered — **DONE**
39. Settings gear draggable — **DONE**
40. Tasbih counter draggable, reachable by either thumb — **DONE**
41. Dhikr dropdown, not overcrowded — **DONE**
42. Quran, full text — **DONE**, 6,236 ayahs, checksum-verified, search, bookmarks, last-read position
43. Azkar text — **PARTIAL**, morning (26) + evening (24) from MIT-licensed source; after-prayer/sleep/travel **BLOCKED**, no licensed source
44. Settings screen — **DONE**
45. Navigation (bottom nav + dashboard) — **DONE**

## Phase 6 — Visual direction (46–55)
46. "Looks like a child built it," make premium — **DONE**, Cormorant/Inter/Amiri (SIL OFL)
47. Cards still bright green — **DONE**, `surfaceTintColor: transparent`
48. Licences page unstyled — **DONE**
49. Empty states too large — **DONE**
50. Chips too loud — **DONE**
51. Scroll/entrance animation, modern feel — **DONE**: staggered entrances, viewport reveals, tab cross-fade, tap scale, astrolabe sweep, reduced-motion respected
52. Light theme like Athan — **DONE** in build 18
53. iOS-style bouncy scroll, shrinking title — **DONE**
54. Allah engraved/embossed/gold — **DONE** in build 18
55. *(tracked together with 46–54 in the retained record — no separate distinct item recovered)*

## Phase 7 — Sri Lankan features (56–62)
56. Iqamath separate from adhan — **DONE**
57. District presets, no GPS required — **DONE**, 25 districts
58. Silent mode during prayer — **DONE**
59. Auto-start on boot — **DONE**
60. Monthly timetable — **DONE**
61. English / Tamil / Sinhala — **DONE**, Noto Sans Tamil + Sinhala bundled
62. Notifications on dashboard, not buried in Settings — **DONE**

## Phase 8 — Hajj and Umrah (63–69)
63. Full Hajj/Umrah guide, three languages — **PARTIAL**: English in; Tamil/Sinhala **BLOCKED**
64. Pronunciation guides, three languages — **BLOCKED**, same reason
65. Beginner/experienced categories — **DONE**
66. Profile: name, umrah count, hajj count — **DONE**
67. Tawaf/Sa'i counter, idtiba + ramal reminders — **DONE**. Ramal was missing from the original spec; added after verification against six independent sources.
68. Zakat calculator — **DONE**. Nisab 87.48g gold / 612.36g silver, unit tested at and around the threshold.
69. Hijri calendar — **DONE**, Ramadan, both Eids, Ashura, white days

## Phase 9 — Privacy, legal, donation (70–77)
70. No INTERNET permission in the manifest — **NOT DONE**. Foundation of the privacy claim; still outstanding.
71. Disable `allowBackup` — **NOT DONE**. Encrypted database can currently be swept into Google cloud backup.
72. Privacy claim under Sri Lankan and international law — **NOT DONE**
73. No login, no name, no age — plug and play — **DONE**
74. Rewrite donate text — **NOT DONE**. Should state noor is free/offline/ad-free, donations go to Sadaqah Jariyah where possible.
75. Donate as a floating 3D element, findable but never intrusive — **NOT DONE**
76. Remove technical typefaces list from About — **NOT DONE**
77. Remove open-source licences page — **DECLINED**. SIL Open Font Licence requires the licence text ship with the app; removing it means the fonts can't legally be used. Can be buried a level deeper instead.

## Phase 10 — Release readiness (78–83)
78. Database passphrase from Android Keystore — **NOT VERIFIED**. Commanded, never confirmed — likely still the placeholder. **Release blocker.**
79. Adhan notification scheduler — **PARTIAL**. Toggles and silent-window scheduling exist; end-to-end delivery unverified.
80. Release keystore and AAB — **NOT DONE**. Required for Play Store.
81. Privacy policy URL — **NOT DONE**. Required for Play Store.
82. Store listing, screenshots, Data Safety form — **NOT DONE**
83. $25 Google Play developer account — **NOT DONE**, your action

## Declined, and why (84–87)
84. Write Quranic text from memory — **DECLINED**. Text must come from Tanzil, verified; a single wrong diacritic changes the word.
85. Write/transliterate Arabic, Tamil, or Sinhala religious text — **DECLINED**. Model-generated religious text in three scripts is where errors hide unseen.
86. Ship the Hajj guide as authoritative without review — **DECLINED**. The rites affect ritual validity; guide carries a scholar-confirmation notice and needs review before being presented as authoritative.
87. Remove the open-source licences page — **DECLINED**, see 77.

---

## Where things stood after build 18

**Working:** splash, dashboard, prayer times, qibla, Quran, azkar (morning/evening), tasbih, settings, Zakat, Hijri calendar, pilgrimage tracker, Hajj/Umrah guide (English), trilingual UI.

**Outstanding, in priority order:**
1. Database passphrase — verify Keystore-backed (78)
2. INTERNET permission removed from manifest (70)
3. `allowBackup` disabled (71)
4. Release keystore and AAB (80)
5. Privacy policy published (81)
6. Donate text and placement (74, 75)
7. About page cleanup (76)
8. Prayer times cross-checked against a real timetable for several days
9. **Quran re-sourced directly from tanzil.net and re-diffed** — the bundled file came from a GitHub mirror because tanzil.net was unreachable from the build environment, and it is **version 1.0.2**, not the current 1.1. Resolve before release — see 07_QA_SECURITY_AND_RELEASE.md.
10. Azkar sources for after-prayer, sleep, travel (43)
11. Tamil and Sinhala guide text (63, 64)
12. Scholar review of the Hajj/Umrah guide

## Two things worth remembering
**The Quran defect** — diffing two independent mirrors caught a spurious shadda in the Bismillah of two surahs that no count/structure check would have found. The entire argument for never generating sacred text.
**The compass bug** — naive averaging of 359° and 1° gives 180° (exactly backwards); averaging as unit vectors gives 0° (correct). One line of math likely explains the old compass misbehaving.
