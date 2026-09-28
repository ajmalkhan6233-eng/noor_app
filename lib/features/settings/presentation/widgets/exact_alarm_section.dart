// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Android 12+/14 does not grant "Alarms & reminders" (exact alarms) by
// default. Nothing in the app ever asked for it, so on a device where it
// is off (verified live 2026-09-28: `dumpsys alarm` showed every adhan
// as an inexact alarm, flags=0x20 with a 1h window) resolveScheduleMode
// silently fell back to inexact scheduling and the adhan fired minutes to
// an hour late. This card only renders while the grant is missing and
// opens the system page for it; status is re-checked on resume, same
// pattern as BatteryOptimizationSection.

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../core/utils/semantics_helpers.dart';

class ExactAlarmSection extends StatefulWidget {
  const ExactAlarmSection({super.key, this.plugin});

  final FlutterLocalNotificationsPlugin? plugin;

  @override
  State<ExactAlarmSection> createState() => _ExactAlarmSectionState();
}

class _ExactAlarmSectionState extends State<ExactAlarmSection>
    with WidgetsBindingObserver {
  late final FlutterLocalNotificationsPlugin _plugin =
      widget.plugin ?? FlutterLocalNotificationsPlugin();
  bool? _canExact;

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

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
    bool? can;
    try {
      can = await _android?.canScheduleExactNotifications();
    } catch (_) {}
    if (mounted) setState(() => _canExact = can);
  }

  @override
  Widget build(BuildContext context) {
    if (_canExact != false) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader('Exact prayer-time alarms'),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Without "Alarms & reminders" allowed, Android may deliver '
                'the adhan minutes to an hour late. Allow it so the adhan '
                'fires at the exact prayer time.',
                style: AppTypography.caption(context.colors.sage),
              ),
              const SizedBox(height: 8),
              SemanticButton(
                label: 'Allow exact alarms',
                hint: 'Opens the system Alarms and reminders page for this app',
                onTap: () async {
                  await _android?.requestExactAlarmsPermission();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    'Allow exact alarms',
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
