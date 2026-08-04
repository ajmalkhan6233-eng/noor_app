// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Every day of the current Gregorian month, computed offline from the
// same location/settings already active on the Prayer Times screen.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/location/location_service.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/prayer_settings.dart';
import '../logic/monthly_timetable_cubit/monthly_timetable_cubit.dart';
import '../logic/monthly_timetable_cubit/monthly_timetable_state.dart';
import 'widgets/monthly_timetable_row.dart';

/// Scrollable list of every day in the current month's prayer
/// schedule, for the coordinates/settings already active elsewhere.
class MonthlyTimetableScreen extends StatelessWidget {
  const MonthlyTimetableScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.settings,
  });

  final double latitude;
  final double longitude;
  final PrayerSettings settings;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MonthlyTimetableCubit(
        coordinates: Coordinates(latitude: latitude, longitude: longitude),
        settings: settings,
        month: DateTime.now(),
      ),
      child: const _MonthlyTimetableView(),
    );
  }
}

class _MonthlyTimetableView extends StatelessWidget {
  const _MonthlyTimetableView();

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.monthlyTimetableScreenTitle),
      ),
      body: BlocBuilder<MonthlyTimetableCubit, MonthlyTimetableState>(
        builder: (context, state) {
          if (state.days.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              AppCard(
                child: Column(
                  children: [
                    for (final day in state.days)
                      MonthlyTimetableRow(
                        day: day,
                        isToday:
                            day.date.year == today.year &&
                            day.date.month == today.month &&
                            day.date.day == today.day,
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
