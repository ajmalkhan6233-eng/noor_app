// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A local-only "Progress" view — an optional display name (never an
// account, never sent anywhere) plus a weekly bar chart and a recent-
// days list, built entirely from PrayerTrackerRepository's existing
// per-day completion data. This is the answer to "can we see weekly/
// monthly progress" without adding any account, network call, or new
// data collection (2026-08-24 live-device review) — every number here
// was already being tracked locally; this just visualizes it.

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../settings/logic/settings_cubit/settings_state.dart';
import '../data/prayer_tracker_repository.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, PrayerTrackerRepository? repository})
    : _repository = repository;

  final PrayerTrackerRepository? _repository;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late final PrayerTrackerRepository _repository =
      widget._repository ?? PrayerTrackerRepository();
  List<({DateTime date, int completedCount, bool fasted})> _history = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final today = DateTime.now();
    final history = await _repository.historyForRange(
      today.subtract(const Duration(days: 13)),
      today,
    );
    if (mounted) {
      setState(() {
        _history = history;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit()..load(),
      child: Scaffold(
        backgroundColor: AppColors.paper,
        appBar: AppBar(title: const Text('Progress')),
        body: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
            : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _nameCard(context),
                  const SizedBox(height: 16),
                  _weeklyChart(),
                  const SizedBox(height: 16),
                  _recentList(),
                ],
              ),
      ),
    );
  }

  Widget _nameCard(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final controller = TextEditingController(text: state.settings.profileName ?? '');
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your name (kept on this device only)', style: AppTypography.caption),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                style: const TextStyle(color: AppColors.ink),
                decoration: const InputDecoration(
                  hintText: 'Add a name',
                  hintStyle: TextStyle(color: AppColors.sage),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) => context.read<SettingsCubit>().setProfileName(value),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _weeklyChart() {
    final last7 = _history.length > 7 ? _history.sublist(_history.length - 7) : _history;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Last 7 days · prayers completed', style: AppTypography.caption),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final day in last7)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 60 * (day.completedCount / 5).clamp(0.04, 1.0),
                            decoration: BoxDecoration(
                              color: day.completedCount == 5 ? AppColors.gold : AppColors.accentSecondary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            DateFormat.E().format(day.date).substring(0, 1),
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentList() {
    final reversed = _history.reversed.toList();
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (final day in reversed) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      DateFormat.MMMEd().format(day.date),
                      style: const TextStyle(color: AppColors.ink),
                    ),
                  ),
                  Text(
                    '${day.completedCount}/5 prayers',
                    style: AppTypography.caption,
                  ),
                  if (day.fasted) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.nightlight_round, color: AppColors.gold, size: 14),
                  ],
                ],
              ),
            ),
            if (day != reversed.last) const Divider(color: AppColors.hairline, height: 1),
          ],
        ],
      ),
    );
  }
}
