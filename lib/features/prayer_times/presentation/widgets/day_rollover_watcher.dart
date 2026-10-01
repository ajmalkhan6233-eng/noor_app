// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Keeps the shared PrayerCubit on the real "today": checks when the app
// returns to the foreground and once a minute while open, and reloads
// the tracker checklist when midnight has passed.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../prayer_tracker/logic/prayer_tracker_cubit/prayer_tracker_cubit.dart';
import '../../logic/prayer_cubit/prayer_cubit.dart';

class DayRolloverWatcher extends StatefulWidget {
  const DayRolloverWatcher({super.key, required this.child});

  final Widget child;

  @override
  State<DayRolloverWatcher> createState() => _DayRolloverWatcherState();
}

class _DayRolloverWatcherState extends State<DayRolloverWatcher> with WidgetsBindingObserver {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _check());
  }

  void _check() {
    if (!mounted) return;
    if (context.read<PrayerCubit>().refreshIfDayChanged()) {
      context.read<PrayerTrackerCubit>().load();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    _check();
    // Location enabled in the phone's settings is picked up here.
    if (mounted) context.read<PrayerCubit>().retryLocationIfFallback();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
