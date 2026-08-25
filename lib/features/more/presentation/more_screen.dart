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

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/utils/semantics_helpers.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../calendar/presentation/calendar_screen.dart';
import '../../prayer_times/logic/prayer_cubit/prayer_cubit.dart';
import '../../qibla/presentation/qibla_screen.dart';
import '../../settings/presentation/about_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../tasbih/presentation/tasbih_screen.dart';
import '../../zakat/presentation/zakat_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final prayerCubit = context.read<PrayerCubit>();
    final tiles = <_MoreTile>[
      _MoreTile(
        icon: Icons.explore,
        color: AppColors.accentSecondary,
        label: l10n.qiblaScreenTitle,
        builder: (_) => const QiblaScreen(),
      ),
      _MoreTile(
        icon: Icons.blur_circular,
        color: AppColors.gold,
        label: l10n.tasbihScreenTitle,
        builder: (_) => const TasbihScreen(),
      ),
      _MoreTile(
        icon: Icons.calendar_month,
        color: AppColors.accentSecondary,
        label: l10n.calendarLabel,
        builder: (_) => const CalendarScreen(),
      ),
      _MoreTile(
        icon: Icons.savings_outlined,
        color: AppColors.gold,
        label: l10n.zakatCalculatorLabel,
        builder: (_) => const ZakatScreen(),
      ),
      _MoreTile(
        icon: Icons.settings_outlined,
        color: AppColors.sage,
        label: l10n.settingsSemanticLabel,
        builder: (_) => const SettingsScreen(),
        onClosed: () => prayerCubit.loadSettings(),
      ),
      _MoreTile(
        icon: Icons.info_outline,
        color: AppColors.sage,
        label: l10n.aboutLabel,
        builder: (_) => const AboutScreen(),
      ),
      // Hajj/Umrah/pilgrimage guide feature is cut from v1 (see
      // CLAUDE.md Deferred section) — its screens stay in the repo
      // but aren't exposed here.
    ];

    return Scaffold(
      // Transparent so HomeDashboard's CosmicBackground shows through
      // — this tab sits directly above that persistent layer.
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(l10n.moreTab), backgroundColor: AppColors.paper),
      // SingleChildScrollView wraps the shrink-wrapped grid so a short
      // viewport (small phone, split-screen, the default flutter_test
      // surface) scrolls instead of overflowing — the grid's own
      // NeverScrollableScrollPhysics only makes sense with a scrollable
      // ancestor, which this now always provides.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: StaggeredFadeIn(
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 20,
              crossAxisSpacing: 12,
              // 0.8 left just enough room for the icon + 2 lines of
              // label text at the default text scale — a system font
              // size above 1.0x (live device: MIUI) pushed the label
              // 2.3px past the cell's fixed height, so this leaves more
              // headroom rather than assuming default scale.
              childAspectRatio: 0.72,
              children: [for (final tile in tiles) tile],
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  const _MoreTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.builder,
    this.onClosed,
  });

  final IconData icon;
  final Color color;
  final String label;
  final WidgetBuilder builder;
  final VoidCallback? onClosed;

  @override
  Widget build(BuildContext context) {
    return SemanticButton(
      label: label,
      hint: AppLocalizations.of(context)!.openHint,
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute<void>(builder: builder));
        onClosed?.call();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.ink, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
