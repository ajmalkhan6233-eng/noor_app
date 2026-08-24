// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of PrayerTimesList to keep that file under the project's
// line-count convention. A compact inline toggle — replaces the
// large full-width notification-toggles card that used to sit
// separately on the Home dashboard.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';

class PrayerNotificationBell extends StatelessWidget {
  const PrayerNotificationBell({
    super.key,
    required this.prayerName,
    required this.enabled,
    required this.onTap,
  });

  final String prayerName;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: SemanticButton(
        label: l10n.notificationToggleSemanticLabel(prayerName),
        hint: enabled ? l10n.turnOffNotificationHint : l10n.turnOnNotificationHint,
        onTap: onTap,
        child: Icon(
          enabled ? Icons.notifications_active : Icons.notifications_off_outlined,
          size: 24,
          color: enabled ? AppColors.gold : AppColors.sage,
        ),
      ),
    );
  }
}
