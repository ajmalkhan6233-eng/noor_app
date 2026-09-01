// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Secondary features and app settings — everything that isn't one of
// the four primary bottom-nav tabs. Rewritten from a traditional
// one-row-at-a-time list into a grid of small colored icon tiles
// (2026-08-25 live-device review, explicitly repeated several times:
// "small small tiny icons... like the other app" — matching the
// reference app's app-drawer-style More grid instead of a plain menu).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/icons/noor_icon_type.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../calendar/presentation/calendar_screen.dart';
import '../../prayer_times/logic/prayer_cubit/prayer_cubit.dart';
import '../../qibla/presentation/qibla_screen.dart';
import '../../settings/presentation/about_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../settings/presentation/support_developer_screen.dart';
import '../../tasbih/presentation/tasbih_screen.dart';
import '../../zakat/presentation/zakat_screen.dart';
import '../../../core/constants/app_color_tokens.dart';
import 'widgets/more_tile.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final prayerCubit = context.read<PrayerCubit>();
    final tiles = <MoreTile>[
      // Re-enabled 2026-09-01, direct request/decision, after the
      // dial's rendering-glitch root cause was found and fixed
      // (unthrottled sensor stream forcing repaints of the whole
      // Stack — see compass_needle_and_badge.dart).
      MoreTile(
        icon: NoorIconType.qibla,
        color: context.colors.accentSecondary,
        label: l10n.qiblaScreenTitle,
        builder: (_) => const QiblaScreen(),
      ),
      MoreTile(
        icon: NoorIconType.tasbih,
        color: context.colors.gold,
        label: l10n.tasbihScreenTitle,
        builder: (_) => const TasbihScreen(),
      ),
      MoreTile(
        icon: NoorIconType.calendar,
        color: context.colors.accentSecondary,
        label: l10n.calendarLabel,
        builder: (_) => const CalendarScreen(),
      ),
      MoreTile(
        // A balance scale, not a calculator — zakat is literally about
        // weighing wealth against nisab, and (2026-08-25, flagged
        // directly) a piggy-bank glyph was already ruled out as wrong
        // imagery for a halal/Shariah-compliant app.
        icon: NoorIconType.zakat,
        color: context.colors.gold,
        label: l10n.zakatCalculatorLabel,
        builder: (_) => const ZakatScreen(),
      ),
      MoreTile(
        // Sage previously — read as flat/washed-out next to the other
        // four tinted tiles (2026-08-27 live-device review). Cyan/gold
        // keeps all six tiles in the same visual family.
        icon: NoorIconType.settings,
        color: context.colors.accentSecondary,
        label: l10n.settingsSemanticLabel,
        builder: (_) => const SettingsScreen(),
        onClosed: () => prayerCubit.loadSettings(),
      ),
      MoreTile(
        icon: NoorIconType.about,
        color: context.colors.gold,
        label: l10n.aboutLabel,
        builder: (_) => const AboutScreen(),
      ),
      // 7th tile, added 2026-08-30: visible, not buried in Settings —
      // the existing Settings > Donate entry stays too, two doors to
      // the same room, not one hidden door.
      MoreTile(
        icon: NoorIconType.support,
        color: context.colors.gold,
        label: l10n.supportNoorTitle,
        builder: (_) => const SupportDeveloperScreen(),
      ),
      // Hajj/Umrah/pilgrimage guide feature is cut from v1 and its
      // source was removed entirely (2026-08-26) — see CLAUDE.md's
      // Deferred section.
    ];

    return Scaffold(
      // Transparent so HomeDashboard's CosmicBackground shows through
      // — this tab sits directly above that persistent layer.
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(l10n.moreTab), backgroundColor: context.colors.paper),
      // SingleChildScrollView wraps the wrap so a short viewport (small
      // phone, split-screen, the default flutter_test surface) scrolls
      // instead of overflowing.
      //
      // Wrap instead of GridView.count (2026-08-30): a fixed 3-column
      // grid pins any incomplete last row to the left edge — fine at
      // exactly 6 tiles (a full 2x3 grid), but a real, visible problem
      // the moment a 7th tile is added (an orphaned lone tile on its
      // own row). WrapAlignment.center keeps every row — full or
      // partial — centered regardless of tile count, so this doesn't
      // need revisiting the next time a tile is added or removed.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: StaggeredFadeIn(
          children: [
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 20,
                children: [for (final tile in tiles) SizedBox(width: 96, child: tile)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
