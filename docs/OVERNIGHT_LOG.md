# Overnight log

Resume rule: read this file, continue at "NEXT". Never redo DONE items.
Work dir: worktree `zealous-merkle-5d5e7c`. Local `main` is checked out (dirty) in the repo root, so merges are done on branch `main-merge` (from origin/main) and pushed with `git push origin main-merge:main`.

## JOB 1 (Parts A-E): DONE except Part E checklist (do at the very end)
- main merged+pushed (5da39c4). GitHub build arm64 run #3 (id 36765007730) SUCCESS, APK at apk-releases:dist/noor-arm64.apk. Web Preview green. 'Build Noor Android APK' (signing) is the known-broken keystore-secret workflow.
- Part D done once: backup/* tags pushed, all branches deleted except main/apk-releases. Skipped (checked out in other worktrees): claude/android-app-verification-336c38, claude/list-apk-desktop-build-e050d5, claude/multi-window-debugging-0fce92, claude/remote-control-de9128 (+ local main dirty in repo root). Stashes tagged backup/stash-0, backup/stash-1 (not dropped).

## JOB 2 (polish) on branch polish/overnight
- DONE Phase 1: docs/FINDINGS.md (50), docs/NEEDS_DECISION.md
- DONE batch1 (#1,#3,#34,#35,#42): main.dart try/catch, text-scale cap, audio sub cancel, tasbih closed guards
- DONE batch2 (#23,#24,#38,#39,#40 + analyzer to 0 issues): streak/history single queries, dart fix const/imports
- DONE batch3 (#4-#16,#19 l10n + 48dp targets for chevrons/hijri/dismiss). #18 -> NEEDS_DECISION.
- DONE batch4: Mushaf flat (radiusFor on 16 files, no glow in flat themes), contrast test all 4 themes (#20-22,#48). SKIPPED #25/#26 lazy lists (StaggeredFadeIn needs eager children; 114 simple tiles). Dawn gold contrast -> NEEDS_DECISION #9.
- DONE batch5: file splits (prayer_chip, backup_action_button, current_time_chip, support_button, surah_download_progress/failure, splash_decision_placeholder). Still >150: compass_service, surah_audio_download_service, paginated_full_quran_text, notification_service, location_onboarding, quran_repository, database_migrations, about_screen, app_theme, app_color_tokens, azkar_repository, qibla_cubit, prayer_cubit, tracker repo/card, azkar_category, icon painters a, settings_repository, surah_audio_button, surah_index, draggable_floating, app.dart(160).
- NOTE: never run `dart format lib` (reformats 200 files). Scripts live in the scratchpad (splitter.py).
- NEXT (batch6+): a11y tap targets + l10n of hard-coded labels (#4-#19), then #20-22 Mushaf flat, #25/26 lazy lists, #41 file splits, #45 Help/FAQ, #48 contrast test, #49 docs
- Then Phase 3 IMPROVEMENTS.md (50) + do them, Phase 4 gate + PLAY_STORE_READINESS.md, Phase 5 merge/build/cleanup, Part E report.
