// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Every day of the current Gregorian month, computed offline from the
// same location/settings already active on the Prayer Times screen.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_color_tokens.dart';
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
      // A dense data table reads better a touch lighter than the
      // app's usual near-black background. Blended halfway between
      // the locked paper/card tones rather than a new colour, so the
      // AppCard rows below still stand out against it.
      backgroundColor: Color.lerp(context.colors.paper, context.colors.card, 0.5),
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 560,
                  child: AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _header(context),
                        for (var index = 0; index < state.days.length; index++)
                          MonthlyTimetableRow(
                            day: state.days[index],
                            isToday:
                                state.days[index].date.year == today.year &&
                                state.days[index].date.month == today.month &&
                                state.days[index].date.day == today.day,
                            isAlternate: index.isOdd,
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _header(BuildContext context) {
    const labels = ['Day', 'Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: context.colors.card,
        border: Border(bottom: BorderSide(color: context.colors.hairline)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(labels.first, style: TextStyle(color: context.colors.sage, fontSize: 12)),
          ),
          for (final label in labels.skip(1))
            Expanded(
              child: Text(label, style: TextStyle(color: context.colors.sage, fontSize: 12)),
            ),
        ],
      ),
    );
  }
}
