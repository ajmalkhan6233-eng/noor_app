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
import '../../../prayer_times/data/silent_mode_channel.dart';
import '../../../prayer_times/data/silent_mode_settings.dart';
import '../../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../../settings/logic/settings_cubit/settings_state.dart';

class HomeQuickToggles extends StatefulWidget {
  const HomeQuickToggles({super.key, SilentModeChannel? channel})
    : _channel = channel ?? const SilentModeChannel();

  final SilentModeChannel _channel;

  @override
  State<HomeQuickToggles> createState() => _HomeQuickTogglesState();
}

class _HomeQuickTogglesState extends State<HomeQuickToggles> with WidgetsBindingObserver {
  // Set right before opening the system DND-access screen, since
  // requestNotificationPolicyAccess() just launches that screen and
  // returns immediately — it can't tell us whether the user actually
  // granted it. Re-checked on the next app resume instead (found live,
  // 2026-08-26: the toggle was marking itself "on" the instant the
  // settings screen opened, before the user had granted anything —
  // showing Silent Mode as enabled even if they backed out without
  // granting it, while the native ringer change would then silently
  // have no effect).
  bool _awaitingPolicyAccessResume = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !_awaitingPolicyAccessResume) return;
    _awaitingPolicyAccessResume = false;
    _finishEnableIfGranted();
  }

  Future<void> _finishEnableIfGranted() async {
    if (!await widget._channel.hasNotificationPolicyAccess()) return;
    if (!mounted) return;
    final s = context.read<SettingsCubit>().state.settings.silentMode;
    context.read<SettingsCubit>().setSilentMode(
      SilentModeSettings(
        fajr: true,
        dhuhr: true,
        asr: true,
        maghrib: true,
        isha: true,
        extraMinutesAfterIqamath: s.extraMinutesAfterIqamath,
      ),
    );
  }

  // Settings' own Silent Mode section (with its "Grant Do Not Disturb
  // access" button) was removed as duplicate UI (2026-08-25: "it's
  // already in the front page... remove it from settings") — this was
  // the only other place that button lived, so turning Silent Mode on
  // here now has to request that access itself, or the toggle would go
  // on visually while the ringer never actually changes.
  Future<void> _enableSilentMode(
    BuildContext context,
    SilentModeSettings s,
  ) async {
    if (await widget._channel.hasNotificationPolicyAccess()) {
      if (context.mounted) {
        context.read<SettingsCubit>().setSilentMode(
          SilentModeSettings(
            fajr: true,
            dhuhr: true,
            asr: true,
            maghrib: true,
            isha: true,
            extraMinutesAfterIqamath: s.extraMinutesAfterIqamath,
          ),
        );
      }
      return;
    }
    _awaitingPolicyAccessResume = true;
    await widget._channel.requestNotificationPolicyAccess();
  }

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
            Flexible(
              child: _chip(
                context,
                icon: silentOn ? Icons.notifications_off : Icons.notifications_off_outlined,
                label: 'Silent Mode',
                on: silentOn,
                onTap: () => silentOn
                    ? context.read<SettingsCubit>().setSilentMode(
                        SilentModeSettings(
                          fajr: false,
                          dhuhr: false,
                          asr: false,
                          maghrib: false,
                          isha: false,
                          extraMinutesAfterIqamath: s.extraMinutesAfterIqamath,
                        ),
                      )
                    : _enableSilentMode(context, s),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: _reminderChip(context, reminderOn, state.settings.preReminderMinutes),
            ),
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
          child: FittedBox(
            fit: BoxFit.scaleDown,
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
