// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of home_quick_toggles.dart to stay under the 150-line
// limit (that file was already over before tonight's glass-pill
// restyle, not a regression introduced by it — fixed properly while
// already touching the file rather than left as-is). The pre-adhan
// reminder chip's own minutes-dropdown menu, self-contained.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../settings/logic/settings_cubit/settings_cubit.dart';
import 'home_quick_toggle_pill.dart';
import '../../../../core/constants/app_color_tokens.dart';

class PreAdhanReminderChip extends StatelessWidget {
  const PreAdhanReminderChip({super.key, required this.on, required this.minutes});

  final bool on;
  final int minutes;

  static const _minuteOptions = [5, 10, 15, 20, 30];

  @override
  Widget build(BuildContext context) {
    final label = on ? 'Reminder: $minutes min' : 'Pre-adhan reminder';
    return PopupMenuButton<int>(
      // -1 means "off"; a real minute value both enables and sets it.
      onSelected: (value) {
        final cubit = context.read<SettingsCubit>();
        if (value < 0) {
          cubit.setPreReminderEnabled(false);
        } else {
          cubit.setPreReminderMinutes(value);
          cubit.setPreReminderEnabled(true);
        }
      },
      color: context.colors.card,
      itemBuilder: (context) => [
        for (final m in _minuteOptions)
          PopupMenuItem(
            value: m,
            child: Text('$m minutes before', style: TextStyle(color: context.colors.ink)),
          ),
        PopupMenuItem(
          value: -1,
          child: Text('Off', style: TextStyle(color: context.colors.sage)),
        ),
      ],
      child: Semantics(
        label: label,
        hint: 'Double tap to choose reminder timing',
        child: GlassPill(
          on: on,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GlowIcon(
                  on ? Icons.notifications_active : Icons.notifications_active_outlined,
                  on: on,
                ),
                const SizedBox(width: 6),
                Text(label, style: TextStyle(color: on ? context.colors.gold : context.colors.sage, fontSize: 12)),
                Icon(Icons.arrow_drop_down, size: 16, color: context.colors.sage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
