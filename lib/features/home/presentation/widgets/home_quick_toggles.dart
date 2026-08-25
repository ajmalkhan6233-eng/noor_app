// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Silent Mode and the pre-adhan reminder, moved to Home's front page
// (2026-08-24 live-device review: both were "buried in Settings",
// wanted as easily-reachable controls). Silent Mode is a quick master
// on/off toggling all five prayers together — per-prayer
// customization stays in Settings. The reminder chip opens a minutes
// dropdown directly here (5/10/15/20/30, or off) rather than only
// toggling on/off — picking a value was previously Settings-only,
// which is exactly the "shouldn't need to leave the front page for
// this" friction flagged in the same review.

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
            _reminderChip(context, reminderOn, state.settings.preReminderMinutes),
          ],
        );
      },
    );
  }

  static const _minuteOptions = [5, 10, 15, 20, 30];

  Widget _reminderChip(BuildContext context, bool on, int minutes) {
    final label = on ? 'Reminder: $minutes min' : 'Pre-adhan reminder';
    return PopupMenuButton<int>(
      // -1 means "off"; a real minute value both enables and sets it.
      onSelected: (value) {
        final cubit = context.read<SettingsCubit>();
        if (value < 0) {
          cubit.setPreReminderEnabled(false);
        } else {
          cubit.setPreReminderMinutes(value);
          cubit.setPreReminderEnabled(true);
        }
      },
      color: AppColors.card,
      itemBuilder: (context) => [
        for (final m in _minuteOptions)
          PopupMenuItem(
            value: m,
            child: Text('$m minutes before', style: const TextStyle(color: AppColors.ink)),
          ),
        const PopupMenuItem(
          value: -1,
          child: Text('Off', style: TextStyle(color: AppColors.sage)),
        ),
      ],
      child: Semantics(
        label: label,
        hint: 'Double tap to choose reminder timing',
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
              Icon(
                on ? Icons.notifications_active : Icons.notifications_active_outlined,
                size: 16,
                color: on ? AppColors.gold : AppColors.sage,
              ),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: on ? AppColors.gold : AppColors.sage, fontSize: 12)),
              const Icon(Icons.arrow_drop_down, size: 16, color: AppColors.sage),
            ],
          ),
        ),
      ),
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
