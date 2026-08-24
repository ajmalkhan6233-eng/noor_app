# noor — THE Complete File (this replaces every separate file before it)

**Use only this file from now on.** Ignore noor_backlog.md, noor_gap_analysis.md, noor_master.md, and noor_location_dashboard.md if you still have them open — everything from all of them is merged in here, nothing lost, nothing needs juggling between files anymore.

**How to use it:** work top to bottom. Paste one numbered/lettered block at a time into Claude Code, wait for it to finish and confirm, then move to the next. The order below already accounts for what's actually been completed so far — don't re-do anything marked done.

---

## STOP — Paste this first, before anything else in this file

The most important visual work (cosmic particle background, glass-panel effect, morphing nav) got skipped last session with no clear reason given. This needs answering before any more feature work continues, or the app risks finishing "complete" on paper while still looking exactly like it did at the start.

```
Before continuing to any new work, stop and explain plainly: what specifically is broken about the cosmic background, glass-panel effect, and morphing nav items (previously labeled C0/C1/C2)? Is this related to Flutter not being properly set up locally on this machine? If local Flutter still isn't working, that's the real blocker and needs solving directly — not routed around by working on smaller features instead. State exactly what's broken and what it would take to fix or safely retry it. Do not move to any other work in this file until this is answered.
```

---

## Progress so far — don't repeat these

- Section B (status checks): 5 of 6 confirmed done. Only the database migration item still needs confirming.
- C3 (splash particle refinement): confirmed already done.
- C4 (location gating skeletons): shipped.
- C5 (pre-adhan reminder alarm + DB migration): pushed, confirm CI passed before trusting it.
- Full palette audit (all 34 files, emerald retired app-wide): done.
- Religious text verification pass (Quran, Azkar, Hisn supplementary, Talbiyah): done, documented, no errors found.
- 189+ tests passing, APK build pipeline working, GitHub Releases publishing correctly.

---

## SECTION A — Needs a decision from you, not code

### A1. Reciter/Adhan audio licensing — still unresolved
The original candidate source (everyayah.com) is CC-BY-NC — not usable
in a paid app. Nothing has replaced it. Decide one of:
- Ship v1 with **no bundled recitation audio** (simplest, zero legal risk).
- Name a specific commercially-licensed source to use instead.
Nothing audio-related below should start until this is decided.

---

## SECTION L — Location, dashboard, and calligraphy pass (not started yet)

```
Several related fixes, in order:

1. LOCATION PERMISSION — currently asks repeatedly across multiple screens. Fix: ask once, at first launch only, with a short plain-language explanation of why (accurate prayer times for your area). After that, location only appears in Settings — never as a repeated prompt on other screens. Critically: if the user skips it, do not block or gate any part of the app — let them explore freely, just show a gentle, dismissible reminder, never a hard wall.

2. MANUAL TIME ADJUSTMENT — as part of that same one-time first-launch flow (right after location/district is picked, not buried later), add a short, plain explanation: "If a prayer time here doesn't match your local masjid, you can adjust it below" with a simple +/- minutes control right there, per prayer. This should also remain editable later in Settings.

3. A BUG CLUE for the text-wrapping investigation: the behavior seems to change once a location is actually selected — before location is set, text was reported wrapping one character per line; after a location is selected, the same text reportedly stretches into one long overflowing line instead. This may point to the container sizing itself off the location string's length, rather than a pure font issue.

4. GREETING TEXT — "Assalamu Alaikum" (or equivalent) should render once, normally, as part of the dashboard — not persist as a banner or repeat oddly.

5. DASHBOARD CHECK — compare the current Home screen against the original spec (HeroCard, StreakCapsule, NextPrayerCountdownCapsule, AyahOfDayCard, DailyGoalsList). Report plainly which of these five actually exist and are visibly working, and which are missing.

6. ALLAH CALLIGRAPHY — confirm the existing emboss treatment actually reads as carved/embossed (shadow and highlight giving it depth), not flat text with a glow. Fix if it's currently flat.

Run noor-visual-self-qa on all of this before reporting anything done. Report on each of the 6 items separately and plainly.
```

---

## SECTION C — Remaining feature work, one step at a time

### C0. Reusable glass-panel widget — ready code, check for duplicates first
```dart
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0xFF0D1117).withOpacity(0.55),
            borderRadius: borderRadius,
            border: Border.all(color: const Color(0x3300F2FE), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

### C1. Cosmic particle background — finish and verify (see STOP section above first)
### C2. Morphing nav dock (see STOP section above first)

### C6. Sunnah fasting card
Logic pre-written (weekday part exact; White Days needs your real Hijri class methods):
```dart
bool isSunnahFastingDay(DateTime gregorianDate) {
  return gregorianDate.weekday == DateTime.monday ||
      gregorianDate.weekday == DateTime.thursday;
}
// White Days = Hijri 13th-15th of any month — wire to existing Hijri conversion.
```

### C7. Ayah dual-language display
Check noor-religious-text-verification for per-translation licensing before picking a translation source.

### C8. Qibla 3D sensor fixes
### C9. Tasbih drag persistence + 3D visual
### C10. Calendar day modals/notes
### C11. Quran parallel translation view (depends on C7)
### C12. Duas audio + library expansion (depends on Section A1's licensing decision)

### C13. Kinetic digit-roll counter — ready code
```dart
import 'package:flutter/material.dart';

class RollingDigit extends StatelessWidget {
  final int value;
  final TextStyle? style;
  const RollingDigit({super.key, required this.value, this.style});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero)
            .animate(animation),
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: Text('$value', key: ValueKey<int>(value), style: style),
    );
  }
}
```

### Sri Lanka 2026 holiday data — partially verified
```
CONFIRMED: Sinhala & Tamil New Year Apr 13-14; Vesak Full Moon Poya May 30;
Christmas Dec 25. Eid al-Fitr/al-Adha: moon-sighting dependent, mark
"approximate." NOT YET FILLED: remaining ~9 Poya days + rest of the 26
total — verify against the government gazette before shipping, don't guess.
```

---

## SECTION D — Future ideas only, do not start yet

- Home screen widget (next prayer time) — every competitor has one, noor doesn't.
- Local encrypted backup/export — the real fix for "lose your phone, lose everything," unique to noor's offline architecture.
- Ramadan mode (Suhoor/Iftar countdown).
- Elderly/simple mode (larger text, fewer taps).
- Manual per-prayer time adjustment already covered in Section L above — don't duplicate.
- Quran surah ordering toggle (Mushaf vs revelation order) — cheap, uncommon differentiator.

**Not recommended, ever:** cloud sync/login, in-app Zakat payment processing, any paywall/subscription — all conflict with the locked architecture.
