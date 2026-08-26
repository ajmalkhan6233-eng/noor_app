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

  // A stable controller/focus node, not one rebuilt inline in build() —
  // that earlier version recreated the TextEditingController on every
  // SettingsCubit rebuild (including the one setProfileName itself
  // triggers), which is a real bug on top of never disposing the old
  // controller. Saves on both the keyboard's done key and on losing
  // focus (tapping elsewhere) — previously the only way to save was an
  // unlabelled keyboard action with no in-app confirmation (2026-08-25
  // live-device review: "no enter button to save... check and edit").
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();
  var _nameSeeded = false;

  @override
  void initState() {
    super.initState();
    _load();
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) _saveName(context);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _saveName(BuildContext context) {
    context.read<SettingsCubit>().setProfileName(_nameController.text.trim());
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
        // Seed the controller from persisted state exactly once — after
        // that, the field is the source of truth so an in-flight edit
        // is never clobbered by a rebuild from an unrelated cubit
        // change.
        if (!_nameSeeded) {
          _nameController.text = state.settings.profileName ?? '';
          _nameSeeded = true;
        }
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your name (kept on this device only)', style: AppTypography.caption),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                style: const TextStyle(color: AppColors.ink),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Add a name',
                  hintStyle: const TextStyle(color: AppColors.sage),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check, color: AppColors.gold),
                    tooltip: 'Save name',
                    onPressed: () {
                      _saveName(context);
                      _nameFocusNode.unfocus();
                    },
                  ),
                ),
                onSubmitted: (_) {
                  _saveName(context);
                  _nameFocusNode.unfocus();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _weeklyChart() {
    final last7 = _history.length > 7 ? _history.sublist(_history.length - 7) : _history;
    final rangeLabel = last7.length == 1 ? 'Today' : 'Last ${last7.length} days';
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$rangeLabel · prayers completed', style: AppTypography.caption),
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
