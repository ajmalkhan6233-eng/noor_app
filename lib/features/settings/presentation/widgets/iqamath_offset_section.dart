// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Per-prayer minutes-after-adhan offsets used to compute the iqamath
// column shown on the Prayer Times screen.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../prayer_times/data/iqamath_offsets.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../logic/settings_cubit/settings_state.dart';

/// Five number fields controlling how many minutes after each adhan
/// the congregation (iqamath) starts.
class IqamathOffsetSection extends StatelessWidget {
  const IqamathOffsetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final offsets = state.settings.iqamathOffsets;
        return Column(
          children: [
            _row(context, 'Fajr', offsets.fajr, (v) => offsets.copyWith(fajr: v)),
            _row(
              context,
              'Dhuhr',
              offsets.dhuhr,
              (v) => offsets.copyWith(dhuhr: v),
            ),
            _row(context, 'Asr', offsets.asr, (v) => offsets.copyWith(asr: v)),
            _row(
              context,
              'Maghrib',
              offsets.maghrib,
              (v) => offsets.copyWith(maghrib: v),
            ),
            _row(
              context,
              'Isha',
              offsets.isha,
              (v) => offsets.copyWith(isha: v),
            ),
          ],
        );
      },
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    int minutes,
    IqamathOffsetMinutes Function(int) apply,
  ) {
    void change(int delta) {
      final next = (minutes + delta).clamp(0, 90);
      context.read<SettingsCubit>().setIqamathOffsets(apply(next));
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
                label: 'Decrease $label iqamath offset',
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
                label: 'Increase $label iqamath offset',
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
