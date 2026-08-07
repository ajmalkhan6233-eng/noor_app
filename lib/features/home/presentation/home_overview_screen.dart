// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Home tab: header, next-prayer card, quick actions, today's
// prayer list, and notification toggles — the one screen that
// gathers everything someone checks first, so those toggles aren't
// buried in Settings.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/build_info.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/presentation/widgets/section_header.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../prayer_times/data/prayer_times_result.dart';
import '../../prayer_times/logic/prayer_cubit/prayer_cubit.dart';
import '../../prayer_times/logic/prayer_cubit/prayer_state.dart';
import '../../prayer_times/presentation/widgets/prayer_times_list.dart';
import '../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../settings/logic/settings_cubit/settings_state.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/edit_location_dialog.dart';
import 'widgets/next_prayer_card.dart';
import 'widgets/quick_action_row.dart';

class HomeOverviewScreen extends StatelessWidget {
  const HomeOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PrayerCubit()..loadSettings()),
        BlocProvider(create: (_) => SettingsCubit()..load()),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  Future<void> _editLocation(BuildContext context, String? current) async {
    final result = await showEditLocationDialog(context, current: current);
    if (result != null && context.mounted) {
      await context.read<SettingsCubit>().setLocationLabel(
        result.trim().isEmpty ? null : result.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settingsState) => BlocBuilder<
              PrayerCubit,
              PrayerState
            >(
              builder: (context, prayerState) => ListView(
                children: [
                  StaggeredFadeIn(
                    children: [
                      DashboardHeader(
                        locationLabel: settingsState.settings.locationLabel,
                        hijriOffsetDays: settingsState.settings.hijriOffsetDays,
                        onEditLocation: () => _editLocation(
                          context,
                          settingsState.settings.locationLabel,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _prayerSection(context, prayerState, settingsState),
                      const SizedBox(height: 20),
                      const QuickActionRow(),
                      const SizedBox(height: 16),
                      _buildStamp(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStamp() {
    return Center(
      child: Semantics(
        label: BuildInfo.label,
        child: const Text(BuildInfo.label, style: AppTypography.caption),
      ),
    );
  }

  Widget _prayerSection(
    BuildContext context,
    PrayerState state,
    SettingsState settingsState,
  ) {
    final result = state.result;
    if (result is! PrayerTimesComputed) {
      return AppCard(
        child: Text(
          AppLocalizations.of(context)!.setLocationOnPrayerTabMessage,
          style: AppTypography.caption,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NextPrayerCard(times: result),
        const SizedBox(height: 16),
        SectionHeader(AppLocalizations.of(context)!.todayLabel),
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
