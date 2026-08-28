// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../prayer_times/data/prayer_settings.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';

/// Calculation method and Asr madhab — always explicit, never assumed.
class MethodMadhabSection extends StatelessWidget {
  const MethodMadhabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final prayer = state.settings.prayerSettings;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              label: 'Calculation method',
              value: prayer.method.label,
              child: DropdownButton<PrayerCalculationMethod>(
                isExpanded: true,
                value: prayer.method,
                dropdownColor: context.colors.card,
                style: TextStyle(color: context.colors.ink),
                items: [
                  for (final method in PrayerCalculationMethod.values)
                    DropdownMenuItem(value: method, child: Text(method.label)),
                ],
                onChanged: (method) {
                  if (method != null) context.read<SettingsCubit>().setMethod(method);
                },
              ),
            ),
            const SizedBox(height: 8),
            Semantics(
              label: 'Asr madhab',
              value: prayer.madhab.label,
              child: DropdownButton<PrayerMadhab>(
                isExpanded: true,
                value: prayer.madhab,
                dropdownColor: context.colors.card,
                style: TextStyle(color: context.colors.ink),
                items: [
                  for (final madhab in PrayerMadhab.values)
                    DropdownMenuItem(value: madhab, child: Text(madhab.label)),
                ],
                onChanged: (madhab) {
                  if (madhab != null) context.read<SettingsCubit>().setMadhab(madhab);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
