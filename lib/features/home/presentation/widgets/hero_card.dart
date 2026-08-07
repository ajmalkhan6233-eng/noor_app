// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Section 3 of the UI Structure Pass: the Home tab's hero card —
// location + Hijri pills, an "Assalamu Alaikum" greeting in the
// display serif, and today's Gregorian date underneath. Replaces the
// old DashboardHeader (whose calligraphy now lives in the persistent
// top bar instead, so it isn't repeated here).

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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
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
          const SizedBox(height: 16),
          Text(l10n.assalamuAlaikumGreeting, style: AppTypography.heroDisplay),
          const SizedBox(height: 4),
          Text(dateSubtitle, style: AppTypography.caption),
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
