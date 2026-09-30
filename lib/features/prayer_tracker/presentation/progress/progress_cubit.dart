// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// State is null while loading. A failed read falls back to an empty
// card rather than spinning forever.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/prayer_tracker_repository.dart';
import 'progress_stats.dart';

class ProgressCubit extends Cubit<ProgressStats?> {
  ProgressCubit({PrayerTrackerRepository? repository, DateTime Function()? clock})
    : _repository = repository ?? PrayerTrackerRepository(),
      _clock = clock ?? DateTime.now,
      super(null);

  final PrayerTrackerRepository _repository;
  final DateTime Function() _clock;

  Future<void> load() async {
    try {
      final counts = await _repository.completionCountsByDay();
      emit(ProgressStats.compute(counts, _clock()));
    } catch (_) {
      emit(ProgressStats.empty);
    }
  }
}
