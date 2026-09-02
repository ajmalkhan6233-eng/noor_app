// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A local-only "Progress" view — an optional display name (never an
// account, never sent anywhere), a headline completion stat, a weekly
// ring pattern, and a recent-days list, built entirely from
// PrayerTrackerRepository's existing per-day completion data. Redesigned
// 2026-08-29 for real visual impact (was previously just a name field
// and a flat bar chart) — see widgets/progress_hero_stat.dart and
// widgets/weekly_pattern_row.dart for the new pieces.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../settings/data/settings_repository.dart';
import '../../settings/logic/settings_cubit/settings_cubit.dart';
import '../../settings/logic/settings_cubit/settings_state.dart';
import '../data/prayer_tracker_repository.dart';
import '../../../core/constants/app_color_tokens.dart';
import 'widgets/name_entry_transition.dart';
import 'widgets/profile_name_card.dart';
import 'widgets/profile_name_header.dart';
import 'widgets/progress_hero_stat.dart';
import 'widgets/recent_days_list.dart';
import 'widgets/weekly_pattern_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({
    super.key,
    PrayerTrackerRepository? repository,
    SettingsRepository? settingsRepository,
  }) : _repository = repository,
       _settingsRepository = settingsRepository;

  final PrayerTrackerRepository? _repository;
  final SettingsRepository? _settingsRepository;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late final PrayerTrackerRepository _repository =
      widget._repository ?? PrayerTrackerRepository();
  List<({DateTime date, int completedCount, bool fasted})> _history = const [];
  bool _loading = true;

  /// Forces the entry card back open to edit an already-saved name —
  /// reset once a save fires again. Independent of whether a name is
  /// actually saved: that's [SettingsState.settings.profileName].
  bool _editingName = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    List<({DateTime date, int completedCount, bool fasted})> history = const [];
    try {
      final today = DateTime.now();
      final raw = await _repository.historyForRange(
        today.subtract(const Duration(days: 13)),
        today,
      );
      // Trim leading days with no activity at all — on a fresh install
      // those are just padding before the app existed on this device,
      // not real "0/5" days (2026-08-24 live-device review: "we just
      // now installed... no point [showing] the 24th, 23rd..."). Always
      // keep at least today, even with nothing logged yet.
      var firstActive = raw.length - 1;
      for (var i = 0; i < raw.length; i++) {
        if (raw[i].completedCount > 0 || raw[i].fasted) {
          firstActive = i;
          break;
        }
      }
      history = raw.sublist(firstActive);
    } catch (_) {
      // A DB read failure leaves history empty rather than spinning
      // forever — the same "stuck loading spinner" bug class already
      // hit once on the Quran/Azkar tabs (see CLAUDE.md Phase 1); this
      // screen has no reason to be exempt from the same safety net.
    }
    if (mounted) {
      setState(() {
        _history = history;
        _loading = false;
      });
    }
  }

  List<({DateTime date, int completedCount, bool fasted})> get _last7 =>
      _history.length > 7 ? _history.sublist(_history.length - 7) : _history;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(repository: widget._settingsRepository)..load(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          final name = settingsState.settings.profileName?.trim();
          final hasName = name != null && name.isNotEmpty;
          final showEntryCard = !hasName || _editingName;
          return Scaffold(
            backgroundColor: context.colors.paper,
            appBar: AppBar(
              title: hasName && !showEntryCard
                  ? ProfileNameHeader(
                      name: name,
                      onEdit: () => setState(() => _editingName = true),
                    )
                  : const Text('Progress'),
            ),
            body: _loading
                ? Center(child: CircularProgressIndicator(color: context.colors.gold))
                : ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      NameEntryTransition(
                        show: showEntryCard,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ProfileNameCard(
                            onSaved: () => setState(() => _editingName = false),
                          ),
                        ),
                      ),
                      ProgressHeroStat(days: _last7),
                      const SizedBox(height: 16),
                      WeeklyPatternCard(days: _last7),
                      const SizedBox(height: 16),
                      RecentDaysList(days: _history.reversed.toList()),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
