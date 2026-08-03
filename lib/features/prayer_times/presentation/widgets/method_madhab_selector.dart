// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The active calculation method and madhab are always visible and
// always user-changeable — never silently assumed.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../data/prayer_settings.dart';
import '../../logic/prayer_cubit/prayer_cubit.dart';
import '../../logic/prayer_cubit/prayer_state.dart';

/// Dropdowns for the calculation method and Asr madhab, always
/// reflecting (and able to change) the cubit's current [PrayerSettings].
class MethodMadhabSelector extends StatelessWidget {
  const MethodMadhabSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerCubit, PrayerState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Semantics(
                label: AppStrings.calculationMethodSemanticLabel,
                value: state.settings.method.label,
                child: DropdownButton<PrayerCalculationMethod>(
                  isExpanded: true,
                  value: state.settings.method,
                  dropdownColor: AppColors.surface,
                  style: const TextStyle(color: AppColors.textPrimary),
                  items: [
                    for (final method in PrayerCalculationMethod.values)
                      DropdownMenuItem(
                        value: method,
                        child: Text(method.label),
                      ),
                  ],
                  onChanged: (method) {
                    if (method != null) {
                      context.read<PrayerCubit>().setMethod(method);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Semantics(
              label: AppStrings.madhabSemanticLabel,
              value: state.settings.madhab.label,
              child: DropdownButton<PrayerMadhab>(
                value: state.settings.madhab,
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: AppColors.textPrimary),
                items: [
                  for (final madhab in PrayerMadhab.values)
                    DropdownMenuItem(value: madhab, child: Text(madhab.label)),
                ],
                onChanged: (madhab) {
                  if (madhab != null) {
                    context.read<PrayerCubit>().setMadhab(madhab);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
