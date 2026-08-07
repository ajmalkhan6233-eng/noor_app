// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Small pill showing where the app currently sources prayer times
// from; tapping opens the existing GPS/district picker in a sheet so
// there's exactly one place that logic lives (LocationSelector).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/utils/semantics_helpers.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../../../prayer_times/logic/prayer_cubit/prayer_cubit.dart';
import '../../../../prayer_times/logic/prayer_cubit/prayer_state.dart';
import '../../../../prayer_times/presentation/widgets/location_selector.dart';
import '../../../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../../../settings/logic/settings_cubit/settings_state.dart';

class LocationPill extends StatelessWidget {
  const LocationPill({super.key});

  void _openPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: LocationSelector(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return BlocBuilder<PrayerCubit, PrayerState>(
          builder: (context, prayerState) {
            final label = settingsState.settings.selectedDistrict ??
                (prayerState.usingGps
                    ? l10n.locationSetViaGpsLabel
                    : l10n.locationSetLabel);
            return SemanticButton(
              label: l10n.changeLocationSemanticLabel,
              hint: l10n.changeLocationHint,
              onTap: () => _openPicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.hairline),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on_outlined, color: AppColors.gold, size: 14),
                    const SizedBox(width: 4),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 84),
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppTypography.caption,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
