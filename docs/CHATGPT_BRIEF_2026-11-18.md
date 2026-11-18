# NOOR (نور) — FULL BRIEF FOR CHATGPT
(Paste this whole file as your first message. Then read "YOUR JOB" below.)

## YOUR JOB (ChatGPT)
You are my senior product + engineering advisor. I am Ajmal, a business owner, NOT a developer. I explain by voice, so read garbled words kindly. Read everything below, then:
1. Tell me in 5 lines what you understood.
2. List what is still unclear (max 5 questions).
3. Give me a "NEXT LEVEL PLAN": the best order of steps to get Noor from "uploaded but stuck" to a published, trusted, growing app. Reason about each step: why, effort, risk, what I do vs what a coding AI does.
4. Flag anything in this brief that looks wrong, risky, or contradictory.
Keep answers short, plain, phone-friendly. Numbered steps. No jargon without one-line meaning.

## 1. WHAT NOOR IS
- Noor (نور): privacy-first Islamic prayer companion for the Sri Lankan Muslim community.
- Built as sadaqah jariyah. Fully free, donation-based support only.
- Android app (Flutter/Dart). Target: Google Play Store.
- Package name: com.noorapp.noorprayer (the earlier name was rejected by Play as taken).
- Version: 1.0.0. About 270+ commits.
- Public GitHub repo: ajmalkhan6233-eng/noor_app
- Privacy policy (live): https://sites.google.com/view/noor-privacy-policy123/home
- Languages in app: English, Tamil, Sinhala.

## 2. NON-NEGOTIABLE VALUES (never break)
- Halal and honest. No ads, no trackers, no analytics SDKs, ever.
- Privacy by structure: the app is offline. Only ONE network exception: optional, user-started Quran audio download.
- No in-app purchases, no billing library, no subscriptions.
- No AI-generated Quran, Arabic dua, Tamil or Sinhala religious text. Quran text only from Tanzil Project (CC BY 3.0, attribution must stay in About screen). Azkar only from Hisn al-Muslim.
- No audio/text/images without a clearly stated reusable license.
- Never claim something works without real proof on a real device.

## 3. FEATURES (built)
- Prayer times (offline, "adhan" package), per-prayer alarms, Silent mode, iqama-gap home state.
- Adhan with 5 selectable reciters.
- Quran reader (Tanzil text), bookmarks, Ayah of the Day, audio for 4 surahs (Al-Kahf, Ya-Sin, Ar-Rahman, Al-Mulk) plus Juz Amma. Reciter: Moeed Alharthi (CC BY 4.0).
- Azkar/Dua: 74 items, 11 categories (an older note said ~150; 74 is the real count).
- Tasbih (tap counter with haptics), Zakat calculator, Calendar with Sri Lankan holidays and user reminders, Progress screen with daily prayer checklist.
- Themes: Nebula (dark, default), Dawn (light), Emerald Night (optional).
- Qibla: HIDDEN behind "Coming soon" (see open items).

## 4. TECH
- Flutter/Dart, feature-first folders: lib/features/<feature>/{data,logic,presentation}. Core singletons in lib/core.
- State: flutter_bloc / Cubit. DB: sqflite_sqlcipher (encrypted, Android Keystore key), schema v10.
- Rules: max 150 lines per Dart file, UI never touches DB directly, every interactive widget has Semantics.
- Colors only through AppColorTokens (Cosmic palette: obsidian #05070B, card #0D1117, gold #FFB703, cyan #00F2FE).
- Builds: GitHub Actions only (AAB for Play Store). Never build APKs locally.
- Tools used so far: Claude Code (main builder), Kiro, Google Antigravity, Gemini (design), Canva (icon).

## 5. PLAY STORE STATUS (as told by Ajmal, 18 Nov 2026)
- Uploaded to Play Console, but stuck in CLOSED TESTING.
- Play requires 12 testers opted in for 14 continuous days before production access.
- Plan was to recruit testers through mosque WhatsApp groups (messages were drafted).
- Not done yet because Ajmal had no time (he was finishing a shop matter, now almost done).
- Google developer account registered, fee paid. Identity verification was submitted with a document mismatch (chose passport, uploaded driving license). UNKNOWN whether fixed.
- Play Console question still open: SCHEDULE_EXACT_ALARM permission declaration (needed for accurate Adhan).
- Plan after launch: free for the first month, then switch listing to paid in Play Console (store setting only, no code change). Existing installs stay free forever. NOTE: this conflicts a little with "donation-based, fully free" — please give your honest view.

## 6. OPEN ITEMS (as of 1 Oct handoff; last 2 months UNVERIFIED)
Ajmal's actions:
- CI signing: re-copy RELEASE_KEYSTORE_BASE64 correctly in GitHub Secrets (it was invalid base64).
- Answer SCHEDULE_EXACT_ALARM declaration in Play Console.
- Fix identity verification mismatch if still pending.
Decisions waiting:
- First-launch wipe of tracker data: keep, or only wipe if DB looks restored.
- Dawn theme accent: approve amber text color or leave.
- Progress edit window: 2 days editable vs 14 shown (widen or label).
- Bundled audio is 44 MB: keep offline, or move to download.
- Tamil/Sinhala and prayer-name wording needs a translator's approval.
Technical:
- Qibla needle glitch (GPU/compositor). Several paint fixes failed. Needs a real GPU trace, not more guessing. A Flutter Impeller on/off test was planned, not run.
- Azkar only 74; each new entry needs a real Hisn al-Muslim source check.
- More Adhan reciters need a clearly licensed, named reciter.
- Daily checklist sometimes pre-checked on fresh install (phone-maker backup restoring old data). A startup guard was added; needs device proof.
- 17 files over the 150-line limit; split only with device testing.
- Stale .clinerules contradicts CLAUDE.md (internet rule, palette).
- Branch drift happened when several AI tools worked in parallel. main must stay the single source of truth.

## 7. HOW AJMAL WORKS
- Phone-first (iPhone for visual checks; separate Android phone for real tests of alarms, notifications, Qibla).
- Wants short answers, one instruction at a time, exact text to paste, no long explanations.
- Nothing is built until he says "go". One task = one feature block.
- Keeps AI usage low. Prefers free tools.
- Faith first, family second, app third.

## 8. WHAT I WANT FROM YOU, SPECIFICALLY
- A realistic path to PRODUCTION on Play Store (testers, 14 days, exact steps, what can go wrong).
- Which open items block launch, and which can wait for 1.0.1.
- How to get 12 real testers fast and ethically in Sri Lanka.
- What would make Noor stand out as a trusted privacy-first app (without breaking the values above).
- A simple 30-day roadmap, with week-by-week actions split into "Ajmal does" and "coding AI does".
- Review of the pricing plan against my values.
- Finish with: the 3 things I should do THIS WEEK.
