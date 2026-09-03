// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Silent Mode and the pre-adhan reminder, moved to Home's front page
// (2026-08-24: both were "buried in Settings"). Silent Mode is a
// quick master on/off toggling all five prayers together — per-prayer
// customization stays in Settings.
//
// 2026-09-03: restyled as glass pills — see home_quick_toggle_pill.dart
// for the shared GlassPill/GlowIcon styling and why it's deliberately
// static (no per-frame redraw), and pre_adhan_reminder_chip.dart for
// the reminder chip's own file (split out here to stay under the
// 150-line limit, which this file was already over before tonight).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../prayer_times/data/silent_mode_channel.dart';
import '../../../prayer_times/data/silent_mode_settings.dart';
import '../../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../../settings/logic/settings_cubit/settings_state.dart';
import 'home_quick_toggle_pill.dart';
import 'pre_adhan_reminder_chip.dart';

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
              child: QuickToggleChip(
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
              child: PreAdhanReminderChip(on: reminderOn, minutes: state.settings.preReminderMinutes),
            ),
          ],
        );
      },
    );
  }
}
