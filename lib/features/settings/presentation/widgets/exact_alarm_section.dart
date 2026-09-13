// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Android 12+ gates *exact* alarms behind a separate "Alarms &
// reminders" grant (SCHEDULE_EXACT_ALARM) that nothing in the app ever
// asked for — notification_schedule_mode.dart already falls back to
// `inexactAllowWhileIdle` when it's missing, so nothing crashes, but a
// missing grant means every adhan can silently arrive up to an hour
// late (confirmed live via `dumpsys alarm`: scheduled adhan alarms
// carried a full 1-hour delivery window instead of firing on time —
// exactly the "no adhan fired" symptom, just delayed past when anyone
// noticed). Same "check on resume" pattern as
// BatteryOptimizationSection since the grant happens in a system
// settings screen, not in-app.

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';

class ExactAlarmSection extends StatefulWidget {
  const ExactAlarmSection({super.key, FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin;

  final FlutterLocalNotificationsPlugin? _plugin;

  @override
  State<ExactAlarmSection> createState() => _ExactAlarmSectionState();
}

class _ExactAlarmSectionState extends State<ExactAlarmSection>
    with WidgetsBindingObserver {
  bool? _canScheduleExact;
  late final FlutterLocalNotificationsPlugin _plugin =
      widget._plugin ?? FlutterLocalNotificationsPlugin();

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    final canExact = await _android?.canScheduleExactNotifications();
    if (mounted) setState(() => _canScheduleExact = canExact);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_canScheduleExact != false) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l10n.exactAlarmSectionHeader),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.exactAlarmNotGrantedMessage,
                style: AppTypography.caption(context.colors.sage),
              ),
              const SizedBox(height: 8),
              SemanticButton(
                label: l10n.grantExactAlarmPermissionLabel,
                hint: 'Opens the system alarms & reminders settings screen for this app',
                onTap: () async {
                  await _android?.requestExactAlarmsPermission();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    l10n.grantExactAlarmPermissionLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colors.gold),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
