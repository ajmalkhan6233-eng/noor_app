# noor improvements (Phase 3 plan)

Quality work only: no new features, packages or cloud services. Status is tracked in docs/OVERNIGHT_LOG.md.

## About, privacy, help
1. About shows the app version (constant kept in sync with pubspec by a test).
2. About shows the privacy statement: "No ads, no tracking. Your data stays on your phone."
3. About links to the existing Privacy Policy screen (it was hidden).
4. New Help / FAQ screen (plain-language answers about what the app does, alarms, location, backup, the one download feature).
5. Help / FAQ reachable from About and from Settings.
6. About split into small widgets (font credits, link cards).
7. Privacy Policy screen: const cleanup, screen-reader header semantics.
8. Privacy statement wording reused from one l10n key (Home/About/Help stay consistent).

## Accessibility and screen-reader flow
9. SectionHeader announces as a heading.
10. Decorative icons excluded from the semantics tree where a label already exists (chips, tiles).
11. SemanticButton guarantees a 48x48dp minimum tap target.
12. Status-bar/navigation-bar icon brightness follows the active theme (light icons on dark themes, dark on Dawn/Mushaf).
13. Not-yet-due prayer hint localized ("Not yet due today").
14. Progress card: ring and bars announce a full sentence.
15. Loading indicators announce as live "loading" once, not repeatedly.
16. Tracker chips announce done/not done state (`checked`).
17. Help screen and About use ordered semantics (header first).
18. Text-scale guard verified by a widget test at 200%.

## Empty states and plain-language errors
19. Progress card first-run message explains how to start ("Tick a prayer on Home to see your progress").
20. Quran bookmarks empty state.
21. Azkar bookmarks empty state.
22. Calendar with no reminders: friendly prompt.
23. Audio download failure: plain message with what to do next.
24. Backup restore errors: plain message (wrong passphrase vs damaged file).
25. Location denied: plain explanation and a clear next step.
26. Notification permission denied: plain explanation.

## Visual consistency and themes
27. Smooth theme transition (explicit themeAnimationDuration/curve).
28. Every card uses AppCard (one style across all 4 themes): audit and fix stragglers.
29. Consistent spacing through AppSpacing in new screens (Help, About).
30. Mushaf: remaining hard-coded radii on shared widgets use the theme radius.
31. Emerald Night and Mushaf appear in the Settings picker with localized labels (done).
32. Theme picker items have a minimum size and wrap cleanly at large text.
33. Theme preview colors for contrast verified in tests (done).
34. Splash/first frame background matches the theme (no flash of wrong color).

## Haptics and feedback
35. Prayer tick fires the existing HapticService tap.
36. Day-complete (5/5) fires the milestone pulse once.
37. Fasting toggle fires a tap.
38. Theme switch fires a light tap.

## Performance and startup
39. Streak/history queries single-pass (done in Phase 2).
40. Cosmic background animation pauses while app is not resumed (battery).
41. Avoid rebuilding whole Home on each minute tick (scope setState to the clock widgets).
42. Progress card cubit does not reload on unrelated rebuilds.
43. R8/shrink already on (verified); keep proguard rules; document in readiness doc.

## Tests and quality gates
44. Widget smoke test for every constructible screen in all 4 themes.
45. Golden-path widget test: first run -> Home -> tick a prayer -> Progress shows it.
46. Help/FAQ and About widget tests.
47. Analyzer clean (zero issues) — done in Phase 2; keep at 0.
48. Contrast test for all themes (done).
49. README updated: themes, progress card, Help/FAQ, how to build.
50. CLAUDE.md updated: new themes, rules learned this session (never `dart format lib`, never local APK build).
