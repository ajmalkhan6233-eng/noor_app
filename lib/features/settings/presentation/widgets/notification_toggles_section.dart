// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/notification_settings.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';

/// Per-prayer notification toggles.
class NotificationTogglesSection extends StatelessWidget {
  const NotificationTogglesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final n = state.settings.notifications;
        return Column(
          children: [
            _toggle(context, 'Fajr', n.fajr, (v) => n.copyWith(fajr: v)),
            _toggle(context, 'Dhuhr', n.dhuhr, (v) => n.copyWith(dhuhr: v)),
            _toggle(context, 'Asr', n.asr, (v) => n.copyWith(asr: v)),
            _toggle(
              context,
              'Maghrib',
              n.maghrib,
              (v) => n.copyWith(maghrib: v),
            ),
            _toggle(context, 'Isha', n.isha, (v) => n.copyWith(isha: v)),
          ],
        );
      },
    );
  }

  Widget _toggle(
    BuildContext context,
    String label,
    bool value,
    NotificationSettings Function(bool) apply,
  ) {
    return Semantics(
      label: '$label notification',
      toggled: value,
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        activeThumbColor: AppColors.gold,
        title: Text(label, style: const TextStyle(color: AppColors.parchment)),
        value: value,
        onChanged: (v) =>
            context.read<SettingsCubit>().setNotifications(apply(v)),
      ),
    );
  }
}
