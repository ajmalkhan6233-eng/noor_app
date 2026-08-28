// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Suhoor/Iftar two-box row. Suhoor ends at Fajr, Iftar begins at
// Maghrib — reuses PrayerTimesComputed directly rather than a
// separate Ramadan-specific calculation. Moved here from the home
// feature (2026-08-24 live-device review): it now lives on the
// Prayer Times tab only, alongside the rest of that tab's detail.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/prayer_times_result.dart';
import 'prayer_time_format.dart';
import '../../../../core/constants/app_color_tokens.dart';

class SuhoorIftarRow extends StatelessWidget {
  const SuhoorIftarRow({super.key, required this.times});

  final PrayerTimesComputed times;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _box(context, icon: Icons.nightlight_round, label: l10n.suhoorLabel, time: times.fajr),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _box(context, icon: Icons.wb_twilight, label: l10n.iftarLabel, time: times.maghrib),
        ),
      ],
    );
  }

  Widget _box(
    BuildContext context, {
    required IconData icon,
    required String label,
    required DateTime time,
  }) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: context.colors.gold, size: 16),
              const SizedBox(width: 6),
              Text(label, style: AppTypography.caption(context.colors.sage)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            formatClock(time),
            style: TextStyle(
              color: context.colors.ink,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
