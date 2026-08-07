// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of home_overview_screen.dart to keep it under the
// project's line-count convention: the next-prayer countdown capsule,
// Suhoor/Iftar row, and today's prayer list with notification
// toggles — or the "set a location" prompt when times aren't
// computed yet.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../prayer_times/data/prayer_times_result.dart';
import '../../../prayer_times/logic/prayer_cubit/prayer_state.dart';
import '../../../prayer_times/presentation/widgets/prayer_times_list.dart';
import '../../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../../settings/logic/settings_cubit/settings_state.dart';
import 'next_prayer_countdown_capsule.dart';
import 'prayer_times_strip.dart';
import 'suhoor_iftar_row.dart';

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
      return AppCard(
        child: Text(l10n.setLocationOnPrayerTabMessage, style: AppTypography.caption),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NextPrayerCountdownCapsule(times: result),
        const SizedBox(height: 16),
        PrayerTimesStrip(times: result),
        const SizedBox(height: 16),
        SuhoorIftarRow(times: result),
        const SizedBox(height: 16),
        SectionHeader(l10n.todayLabel),
        AppCard(
          child: PrayerTimesList(
            times: result,
            notifications: settingsState.settings.notifications,
            onToggleNotification: (prayer, enabled) => context
                .read<SettingsCubit>()
                .setNotifications(
                  settingsState.settings.notifications.withPrayer(prayer, enabled),
                ),
          ),
        ),
      ],
    );
  }
}
