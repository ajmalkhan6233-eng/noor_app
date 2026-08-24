// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Silent Mode and the pre-adhan reminder, moved to Home's front page
// (2026-08-24 live-device review: both were "buried in Settings",
// wanted as easily-reachable controls). This is a quick master
// on/off for each — Silent Mode toggles all five prayers together;
// per-prayer customization and the extra-minutes/reminder-minutes
// fields stay in Settings, reached from here via the icon's own
// screen for anything beyond the on/off flip.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../prayer_times/data/silent_mode_settings.dart';
import '../../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../../settings/logic/settings_cubit/settings_state.dart';

class HomeQuickToggles extends StatelessWidget {
  const HomeQuickToggles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final s = state.settings.silentMode;
        final silentOn = s.fajr && s.dhuhr && s.asr && s.maghrib && s.isha;
        final reminderOn = state.settings.preReminderEnabled;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _chip(
              context,
              icon: silentOn ? Icons.notifications_off : Icons.notifications_off_outlined,
              label: 'Silent Mode',
              on: silentOn,
              onTap: () => context.read<SettingsCubit>().setSilentMode(
                SilentModeSettings(
                  fajr: !silentOn,
                  dhuhr: !silentOn,
                  asr: !silentOn,
                  maghrib: !silentOn,
                  isha: !silentOn,
                  extraMinutesAfterIqamath: s.extraMinutesAfterIqamath,
                ),
              ),
            ),
            const SizedBox(width: 12),
            _chip(
              context,
              icon: reminderOn ? Icons.notifications_active : Icons.notifications_active_outlined,
              label: 'Pre-adhan reminder',
              on: reminderOn,
              onTap: () => context.read<SettingsCubit>().setPreReminderEnabled(!reminderOn),
            ),
          ],
        );
      },
    );
  }

  Widget _chip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool on,
    required VoidCallback onTap,
  }) {
    return SemanticButton(
      label: label,
      hint: on ? 'On. Double tap to turn off' : 'Off. Double tap to turn on',
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: on ? AppColors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: on ? AppColors.gold : AppColors.hairline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: on ? AppColors.gold : AppColors.sage),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: on ? AppColors.gold : AppColors.sage, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
