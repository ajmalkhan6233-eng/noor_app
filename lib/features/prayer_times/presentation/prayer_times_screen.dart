// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_typography.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/collapsing_scaffold.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../prayer_tracker/presentation/widgets/prayer_tracker_card.dart';
import '../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../settings/logic/settings_cubit/settings_state.dart';
import '../data/prayer_settings.dart';
import '../data/prayer_times_result.dart';
import '../logic/prayer_cubit/prayer_cubit.dart';
import '../logic/prayer_cubit/prayer_state.dart';
import 'monthly_timetable_screen.dart';
import 'widgets/high_latitude_notice.dart';
import 'widgets/prayer_loading_skeleton.dart';
import 'widgets/prayer_times_list.dart';
import 'widgets/suhoor_iftar_row.dart';
import '../../../core/constants/app_color_tokens.dart';

/// Prayer-times screen. The astrolabe ring/countdown now leads Home
/// instead (2026-08-24 live-device review), so this tab's own job is
/// the detail underneath it: the full prayer list with per-prayer
/// notification toggles, Suhoor/Iftar, and the completion tracker.
/// No location text or link here any more — location is only ever
/// changed from Settings, with no pointer to it left on this screen
/// either (previously "manage location in Settings", removed
/// entirely per explicit request). PrayerCubit and SettingsCubit are
/// provided once by HomeDashboard (the tab shell) and shared across
/// every tab.
class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  void _openMonthlyTimetable(BuildContext context, PrayerState state) {
    if (!state.hasCoordinates) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MonthlyTimetableScreen(
          latitude: state.latitude!,
          longitude: state.longitude!,
          settings: state.settings,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<PrayerCubit, PrayerState>(
      builder: (context, state) => CollapsingScaffold(
        title: l10n.prayerTimesScreenTitle,
        transparentBody: true,
        actions: [
          Semantics(
            button: true,
            label: l10n.openMonthlyTimetableSemanticLabel,
            child: IconButton(
              icon: const Icon(Icons.calendar_month_outlined),
              onPressed: state.hasCoordinates
                  ? () => _openMonthlyTimetable(context, state)
                  : null,
            ),
          ),
        ],
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(
              child: StaggeredFadeIn(
                children: [
                  _buildResult(context, state),
                  if (state.result is PrayerTimesComputed) ...[
                    const SizedBox(height: 16),
                    SuhoorIftarRow(times: state.result as PrayerTimesComputed),
                  ],
                  const SizedBox(height: 16),
                  PrayerTrackerCard(
                    todayTimes: state.result is PrayerTimesComputed
                        ? state.result as PrayerTimesComputed
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _activeSettingsCaption(context, state.settings),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeSettingsCaption(BuildContext context, PrayerSettings settings) {
    final text = '${settings.method.label} · ${settings.madhab.label} madhab';
    return Center(
      child: Semantics(
        label: AppLocalizations.of(
          context,
        )!.activeCalculationSettingsLabel(text),
        child: Text(text, style: AppTypography.caption(context.colors.sage)),
      ),
    );
  }

  Widget _buildResult(BuildContext context, PrayerState state) {
    final result = state.result;
    return switch (result) {
      null when state.isResolvingLocation => const PrayerLoadingSkeleton(),
      null => Center(
        child: Text(
          AppLocalizations.of(context)!.enterLocationPrompt,
          style: AppTypography.caption(context.colors.sage),
        ),
      ),
      HighLatitudeUnresolved() => const HighLatitudeNotice(),
      PrayerTimesComputed() => BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) => PrayerTimesList(
          times: result,
          iqamathOffsets: state.iqamathOffsets,
          notifications: settingsState.settings.notifications,
          onToggleNotification: (prayer, enabled) => context
              .read<SettingsCubit>()
              .setNotifications(
                settingsState.settings.notifications.withPrayer(prayer, enabled),
              ),
        ),
      ),
    };
  }
}
