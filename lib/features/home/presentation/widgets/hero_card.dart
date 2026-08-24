// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Section 3 of the UI Structure Pass: the Home tab's hero card —
// location + Hijri pills, an "Assalamu Alaikum" greeting, and today's
// Gregorian date underneath. Replaces the old DashboardHeader (whose
// calligraphy now lives in the persistent top bar instead, so it
// isn't repeated here).
//
// Deliberately compact, not the shared AppTypography.heroDisplay size
// (44px, used for the prayer countdown/Zakat total/About app name) —
// a large "Assalamu Alaikum" here was taking up roughly half the
// visible screen on a phone, crowding out the actually time-sensitive
// content (next prayer, streak) below it.
//
// KNOWN ISSUE (web preview only, unconfirmed on real device): the
// greeting/date text renders one character per line in the GitHub
// Pages CanvasKit build. Measured the actual LayoutBuilder constraints
// feeding this Row — a normal w=338, plenty of room — so it isn't a
// width-collapse/missing-Expanded bug in this file. Looks like a
// CanvasKit web-rendering artifact rather than a real defect; needs
// checking against the real APK (Flutter/device tooling, not
// available here) before spending more time on it.

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/hijri_date.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.locationLabel,
    required this.hijriOffsetDays,
    required this.onEditLocation,
  });

  final String? locationLabel;
  final int hijriOffsetDays;
  final VoidCallback onEditLocation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hijri = HijriDate.fromGregorian(DateTime.now(), offsetDays: hijriOffsetDays);
    final dateSubtitle = DateFormat.yMMMMEEEEd(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(DateTime.now());

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.assalamuAlaikumGreeting,
                  style: const TextStyle(
                    fontFamily: AppTypography.displayFamily,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(dateSubtitle, style: AppTypography.caption),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 6,
            runSpacing: 6,
            children: [
              _pill(
                icon: Icons.location_on_outlined,
                label: locationLabel ?? l10n.locationNameDialogTitle,
                onTap: onEditLocation,
                semanticLabel: locationLabel == null
                    ? l10n.locationNameDialogTitle
                    : l10n.locationLabelSemanticValue(locationLabel!),
                semanticHint: l10n.editLocationNameHint,
              ),
              _pill(icon: Icons.brightness_2_outlined, label: hijri.formatted),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    String? semanticLabel,
    String? semanticHint,
  }) {
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.gold, size: 14),
          const SizedBox(width: 6),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
    if (onTap == null) return content;
    return SemanticButton(
      label: semanticLabel ?? label,
      hint: semanticHint,
      onTap: onTap,
      child: content,
    );
  }
}
