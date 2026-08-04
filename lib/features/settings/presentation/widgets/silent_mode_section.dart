// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Per-prayer "silence the phone" toggles, the shared extra-minutes
// field, and (when needed) a button to grant the Do Not Disturb
// access Android requires before ringer mode can be changed.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../prayer_times/data/silent_mode_channel.dart';
import '../../../prayer_times/data/silent_mode_settings.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';

class SilentModeSection extends StatefulWidget {
  const SilentModeSection({super.key, SilentModeChannel? channel})
    : _channel = channel ?? const SilentModeChannel();

  final SilentModeChannel _channel;

  @override
  State<SilentModeSection> createState() => _SilentModeSectionState();
}

class _SilentModeSectionState extends State<SilentModeSection> {
  bool? _hasAccess;

  @override
  void initState() {
    super.initState();
    widget._channel.hasNotificationPolicyAccess().then((granted) {
      if (mounted) setState(() => _hasAccess = granted);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final s = state.settings.silentMode;
        final anyOn = s.fajr || s.dhuhr || s.asr || s.maghrib || s.isha;
        return Column(
          children: [
            _toggle(context, 'Fajr', s.fajr, (v) => s.copyWith(fajr: v)),
            _toggle(context, 'Dhuhr', s.dhuhr, (v) => s.copyWith(dhuhr: v)),
            _toggle(context, 'Asr', s.asr, (v) => s.copyWith(asr: v)),
            _toggle(
              context,
              'Maghrib',
              s.maghrib,
              (v) => s.copyWith(maghrib: v),
            ),
            _toggle(context, 'Isha', s.isha, (v) => s.copyWith(isha: v)),
            const SizedBox(height: 8),
            _extraMinutes(context, s),
            if (anyOn && _hasAccess == false) ...[
              const SizedBox(height: 12),
              _accessButton(context),
            ],
          ],
        );
      },
    );
  }

  Widget _toggle(
    BuildContext context,
    String label,
    bool value,
    SilentModeSettings Function(bool) apply,
  ) {
    return Semantics(
      label: '$label silent mode',
      toggled: value,
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        activeThumbColor: AppColors.emerald,
        title: Text(label, style: const TextStyle(color: AppColors.ink)),
        value: value,
        onChanged: (v) => context.read<SettingsCubit>().setSilentMode(apply(v)),
      ),
    );
  }

  Widget _extraMinutes(BuildContext context, SilentModeSettings s) {
    void change(int delta) {
      final next = (s.extraMinutesAfterIqamath + delta).clamp(0, 60);
      context.read<SettingsCubit>().setSilentMode(
        s.copyWith(extraMinutesAfterIqamath: next),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Extra minutes after iqamath',
          style: TextStyle(color: AppColors.ink),
        ),
        Row(
          children: [
            SemanticButton(
              label: 'Decrease extra silent minutes',
              onTap: () => change(-1),
              child: const Icon(Icons.remove, color: AppColors.emerald),
            ),
            SizedBox(
              width: 48,
              child: Text(
                '${s.extraMinutesAfterIqamath} min',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.sage),
              ),
            ),
            SemanticButton(
              label: 'Increase extra silent minutes',
              onTap: () => change(1),
              child: const Icon(Icons.add, color: AppColors.emerald),
            ),
          ],
        ),
      ],
    );
  }

  Widget _accessButton(BuildContext context) {
    return SemanticButton(
      label: 'Grant Do Not Disturb access',
      hint: 'Required for Silent Mode to change the ringer automatically',
      onTap: () async {
        await widget._channel.requestNotificationPolicyAccess();
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Text(
          'Grant Do Not Disturb access',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.emerald),
        ),
      ),
    );
  }
}
