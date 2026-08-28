// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Fires the real adhan notification immediately, through the exact
// channel/sound a real scheduled prayer-time notification uses — lets
// someone confirm right now that it actually plays (not silenced by
// system Do Not Disturb, not blocked by a notification permission,
// not muted by battery optimization killing the alarm) instead of
// only finding out at the next missed prayer.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/semantics_helpers.dart';
import '../../../prayer_times/data/notification_service.dart';
import '../../../prayer_times/data/notification_slots.dart';
import '../../logic/settings_cubit/settings_cubit.dart';
import '../../../../core/constants/app_color_tokens.dart';

class TestAdhanSection extends StatelessWidget {
  const TestAdhanSection({super.key, NotificationService? service})
    : _service = service;

  final NotificationService? _service;

  @override
  Widget build(BuildContext context) {
    final service = _service ?? NotificationService();
    final reciter = context.watch<SettingsCubit>().state.settings.adhanReciter;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Play a prayer\'s real adhan notification right now, to '
          'confirm it actually sounds — not just that a preview plays.',
          style: TextStyle(color: context.colors.sage, fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final slot in PrayerSlot.values)
              SemanticButton(
                label: 'Test ${slotLabel(slot)} adhan now',
                onTap: () => service.showTestNotification(slot, reciter: reciter),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: context.colors.goldBorder),
                  ),
                  child: Text(slotLabel(slot), style: TextStyle(color: context.colors.gold, fontSize: 13)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SemanticButton(
          label: 'Schedule a real test notification in 3 minutes',
          onTap: () => service.scheduleLiveTestNotification(3, reciter: reciter),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: context.colors.hairline),
            ),
            child: Text(
              'Schedule test notification in 3 min (close app after)',
              style: TextStyle(color: context.colors.sage, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
