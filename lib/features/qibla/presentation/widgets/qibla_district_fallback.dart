// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shown only once GPS has failed/timed out and no district was
// already known — wires the shared DistrictSelector to QiblaCubit
// instead of PrayerCubit, and persists the choice via SettingsCubit
// so Prayer Times picks up the same location too.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../prayer_times/presentation/widgets/district_selector.dart';
import '../../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../../settings/logic/settings_cubit/settings_state.dart';
import '../../logic/qibla_cubit/qibla_cubit.dart';

class QiblaDistrictFallback extends StatelessWidget {
  const QiblaDistrictFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return DistrictSelector(
          selectedDistrict: state.settings.selectedDistrict,
          onSelected: (district) {
            context.read<QiblaCubit>().setManualLocation(
              district.latitude,
              district.longitude,
              originLabel: district.name,
            );
            context.read<SettingsCubit>().setSelectedDistrict(district.name);
          },
        );
      },
    );
  }
}
