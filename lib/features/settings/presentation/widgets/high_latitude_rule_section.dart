// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../prayer_times/data/prayer_high_latitude_rule.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';

/// How Fajr/Isha are bounded at high latitudes.
class HighLatitudeRuleSection extends StatelessWidget {
  const HighLatitudeRuleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final rule = state.settings.prayerSettings.highLatitudeRule;
        return Semantics(
          label: 'High latitude rule',
          value: rule.label,
          child: DropdownButton<PrayerHighLatitudeRule>(
            isExpanded: true,
            value: rule,
            dropdownColor: AppColors.surface,
            style: const TextStyle(color: AppColors.textPrimary),
            items: [
              for (final option in PrayerHighLatitudeRule.values)
                DropdownMenuItem(value: option, child: Text(option.label)),
            ],
            onChanged: (option) {
              if (option != null) {
                context.read<SettingsCubit>().setHighLatitudeRule(option);
              }
            },
          ),
        );
      },
    );
  }
}
