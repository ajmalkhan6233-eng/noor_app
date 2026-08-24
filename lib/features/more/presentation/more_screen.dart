// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Secondary features and app settings — everything that isn't one of
// the four primary bottom-nav tabs, plus quick-access duplicates of
// the dashboard's shortcuts for anyone who lands here first.

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/presentation/widgets/parallax_layer.dart';
import '../../../core/utils/semantics_helpers.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../calendar/presentation/calendar_screen.dart';
import '../../qibla/presentation/qibla_screen.dart';
import '../../settings/presentation/about_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../tasbih/presentation/tasbih_screen.dart';
import '../../zakat/presentation/zakat_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      // Transparent so HomeDashboard's CosmicBackground shows through
      // — this tab sits directly above that persistent layer.
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(l10n.moreTab), backgroundColor: AppColors.paper),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24),
        children: [
          StaggeredFadeIn(
            children: [
              ParallaxLayer(
                controller: _scrollController,
                child: Padding(
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
                        // Hajj/Umrah/pilgrimage guide feature is cut
                        // from v1 (see CLAUDE.md Deferred section) —
                        // its screens stay in the repo but aren't
                        // exposed here.
                      ],
                    ),
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
            Icon(icon, color: AppColors.gold, size: 20),
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
