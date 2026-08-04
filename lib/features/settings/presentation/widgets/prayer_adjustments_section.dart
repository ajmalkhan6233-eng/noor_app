// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../prayer_times/data/prayer_adjustments.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';

/// Per-prayer manual minute offsets, applied on top of the chosen
/// calculation method.
class PrayerAdjustmentsSection extends StatelessWidget {
  const PrayerAdjustmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final adjustments = state.settings.prayerSettings.adjustments;
        return Column(
          children: [
            _row(context, 'Fajr', adjustments.fajr,
                (v) => adjustments.copyWith(fajr: v)),
            _row(context, 'Sunrise', adjustments.sunrise,
                (v) => adjustments.copyWith(sunrise: v)),
            _row(context, 'Dhuhr', adjustments.dhuhr,
                (v) => adjustments.copyWith(dhuhr: v)),
            _row(context, 'Asr', adjustments.asr,
                (v) => adjustments.copyWith(asr: v)),
            _row(context, 'Maghrib', adjustments.maghrib,
                (v) => adjustments.copyWith(maghrib: v)),
            _row(context, 'Isha', adjustments.isha,
                (v) => adjustments.copyWith(isha: v)),
          ],
        );
      },
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    int minutes,
    PrayerAdjustmentMinutes Function(int) apply,
  ) {
    void change(int delta) {
      context.read<SettingsCubit>().setAdjustments(apply(minutes + delta));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.ink)),
          Row(
            children: [
              SemanticButton(
                label: 'Decrease $label offset',
                onTap: () => change(-1),
                child: const Icon(Icons.remove, color: AppColors.emerald),
              ),
              SizedBox(
                width: 48,
                child: Text(
                  '$minutes min',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.sage),
                ),
              ),
              SemanticButton(
                label: 'Increase $label offset',
                onTap: () => change(1),
                child: const Icon(Icons.add, color: AppColors.emerald),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
