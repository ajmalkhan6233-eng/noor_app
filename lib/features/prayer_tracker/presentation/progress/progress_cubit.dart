// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// State for the Progress card: today's stats, the whole on-device tick
// history (for the month heatmap), the weekly goal, and the Week/Month
// choice. A failed read falls back to an empty card, never a spinner.

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/prayer_tracker_repository.dart';
import '../../logic/progress/month_grid.dart';
import '../../logic/progress/weekly_goal.dart';
import 'progress_stats.dart';

class ProgressState extends Equatable {
  const ProgressState({
    this.loading = true,
    this.stats = ProgressStats.empty,
    this.counts = const {},
    this.goal = kDefaultWeeklyGoal,
    this.showMonth = false,
    required this.month,
  });

  final bool loading;
  final ProgressStats stats;

  /// Prayers ticked per day (date-only keys), the whole history.
  final Map<DateTime, int> counts;
  final int goal;

  /// Week bars (false) or the month heatmap (true).
  final bool showMonth;

  /// First day of the month shown in the heatmap.
  final DateTime month;

  ProgressState copyWith({
    bool? loading,
    ProgressStats? stats,
    Map<DateTime, int>? counts,
    int? goal,
    bool? showMonth,
    DateTime? month,
  }) {
    return ProgressState(
      loading: loading ?? this.loading,
      stats: stats ?? this.stats,
      counts: counts ?? this.counts,
      goal: goal ?? this.goal,
      showMonth: showMonth ?? this.showMonth,
      month: month ?? this.month,
    );
  }

  @override
  List<Object?> get props => [loading, stats, counts, goal, showMonth, month];
}

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit({
    PrayerTrackerRepository? repository,
    DateTime Function()? clock,
    WeeklyGoalStore? goalStore,
  }) : _repository = repository ?? PrayerTrackerRepository(),
       _clock = clock ?? DateTime.now,
       _goalStore = goalStore ?? const WeeklyGoalStore(),
       super(ProgressState(month: firstOfMonth((clock ?? DateTime.now)())));

  final PrayerTrackerRepository _repository;
  final DateTime Function() _clock;
  final WeeklyGoalStore _goalStore;

  Future<void> load() async {
    try {
      final counts = await _repository.completionCountsByDay();
      final goal = await _goalStore.load();
      if (isClosed) return;
      emit(
        state.copyWith(
          loading: false,
          counts: counts,
          goal: goal,
          stats: ProgressStats.compute(counts, _clock()),
        ),
      );
    } catch (_) {
      if (!isClosed) emit(state.copyWith(loading: false));
    }
  }

  void showWeek() => emit(state.copyWith(showMonth: false));

  void showMonthView() => emit(state.copyWith(showMonth: true, month: firstOfMonth(_clock())));

  void previousMonth() => emit(state.copyWith(month: addMonths(state.month, -1)));

  /// Never past the current month.
  void nextMonth() {
    final next = addMonths(state.month, 1);
    if (next.isAfter(firstOfMonth(_clock()))) return;
    emit(state.copyWith(month: next));
  }

  bool get canGoNext => !addMonths(state.month, 1).isAfter(firstOfMonth(_clock()));

  Future<void> setGoal(int goal) async {
    final clamped = clampGoal(goal);
    emit(state.copyWith(goal: clamped));
    await _goalStore.save(clamped);
  }

  /// The prayers ticked on [date], for the day detail sheet.
  Future<Set<String>> prayersOn(DateTime date) => _repository.completedPrayersOn(date);
}
