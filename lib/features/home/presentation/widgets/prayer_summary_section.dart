// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of home_overview_screen.dart to keep it under the
// project's line-count convention: the astrolabe ring (moved here
// from Prayer Times, 2026-08-24 live-device review — "this circle
// design ... you can put it in the first page"), the smart iqamah
// line, and the full prayer-times row — or the "set a location"
// prompt when times aren't computed yet. The full prayer list with
// per-prayer notification toggles and Suhoor/Iftar times now live
// only on the Prayer Times tab (see PrayerTimesScreen) — showing them
// here too was the exact duplication flagged in Section B.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../prayer_times/data/prayer_times_result.dart';
import '../../../prayer_times/logic/prayer_cubit/prayer_state.dart';
import '../../../prayer_times/presentation/widgets/prayer_hero.dart';
import '../../../prayer_times/presentation/widgets/prayer_loading_skeleton.dart';
import '../../../settings/logic/settings_cubit/settings_state.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'iqamah_countdown_line.dart';
import 'prayer_times_strip.dart';

class PrayerSummarySection extends StatelessWidget {
  const PrayerSummarySection({
    super.key,
    required this.state,
    required this.settingsState,
  });

  final PrayerState state;
  final SettingsState settingsState;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final result = state.result;
    if (result is! PrayerTimesComputed) {
      if (state.isResolvingLocation) return const PrayerLoadingSkeleton();
      return AppCard(
        child: Text(l10n.setLocationOnPrayerTabMessage, style: AppTypography.caption),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrayerHero(times: result),
        IqamahCountdownLine(times: result, offsets: state.iqamathOffsets),
        const SizedBox(height: 20),
        PrayerTimesStrip(times: result),
      ],
    );
  }
}
