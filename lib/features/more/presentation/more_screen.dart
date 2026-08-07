// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Secondary features and app settings — everything that isn't one of
// the four primary bottom-nav tabs, plus quick-access duplicates of
// the dashboard's shortcuts for anyone who lands here first.

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/utils/semantics_helpers.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../calendar/presentation/calendar_screen.dart';
import '../../hajj_umrah_guide/presentation/hajj_guide_screen.dart';
import '../../hajj_umrah_guide/presentation/umrah_guide_screen.dart';
import '../../pilgrimage/presentation/pilgrimage_home_screen.dart';
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
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: Text(l10n.moreTab)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          StaggeredFadeIn(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _row(context, Icons.explore, l10n.qiblaScreenTitle, const QiblaScreen()),
                      _divider(),
                      _row(context, Icons.blur_circular, l10n.tasbihScreenTitle, const TasbihScreen()),
                      _divider(),
                      _row(context, Icons.calendar_month, l10n.calendarLabel, const CalendarScreen()),
                      _divider(),
                      _row(context, Icons.savings_outlined, l10n.zakatCalculatorLabel, const ZakatScreen()),
                      _divider(),
                      _row(context, Icons.mosque, l10n.pilgrimageLabel, const PilgrimageHomeScreen()),
                      _divider(),
                      _row(context, Icons.menu_book_outlined, l10n.umrahGuideLabel, const UmrahGuideScreen()),
                      _divider(),
                      _row(context, Icons.menu_book, l10n.hajjGuideLabel, const HajjGuideScreen()),
                    ],
                  ),
                ),
              ),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _row(context, Icons.settings_outlined, l10n.settingsSemanticLabel, const SettingsScreen()),
                    _divider(),
                    _row(context, Icons.info_outline, l10n.aboutLabel, const AboutScreen()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(color: AppColors.hairline, height: 1);

  Widget _row(BuildContext context, IconData icon, String label, Widget destination) {
    return SemanticButton(
      label: label,
      hint: AppLocalizations.of(context)!.openHint,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => destination),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.emerald, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, style: const TextStyle(color: AppColors.ink)),
            ),
            const Icon(Icons.chevron_right, color: AppColors.sage, size: 18),
          ],
        ),
      ),
    );
  }
}
