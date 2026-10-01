// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The weekly goal: a progress bar toward "N of the 35 prayers this
// week" with a way to change N (stored on this device only).

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/corner_radius.dart';
import '../../../../core/presentation/motion/motion.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../logic/progress/weekly_goal.dart';

class ProgressGoalCard extends StatelessWidget {
  const ProgressGoalCard({
    super.key,
    required this.done,
    required this.goal,
    required this.onGoalChanged,
  });

  final int done;
  final int goal;
  final ValueChanged<int> onGoalChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final reached = goalReached(done, goal);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(l10n.progressGoalTitle, style: AppTypography.caption(colors.sage)),
              ),
            ),
            SemanticButton(
              label: l10n.progressGoalEdit,
              onTap: () => _editGoal(context),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(Icons.tune, size: 20, color: colors.gold),
              ),
            ),
          ],
        ),
        Semantics(
          label: l10n.progressGoalLine(done, goal),
          value: reached ? l10n.progressGoalReached : null,
          excludeSemantics: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: goalFraction(done, goal)),
                duration: Motion.effective(context, const Duration(milliseconds: 600)),
                curve: Motion.curve,
                builder: (context, value, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(context.radiusFor(6)),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 10,
                    backgroundColor: colors.hairline,
                    valueColor: AlwaysStoppedAnimation(reached ? colors.accentSecondary : colors.gold),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                reached ? l10n.progressGoalReached : l10n.progressGoalLine(done, goal),
                style: AppTypography.caption(reached ? colors.ink : colors.sage),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _editGoal(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.card,
      builder: (sheetContext) => _GoalSheet(initial: goal, onChanged: onGoalChanged),
    );
  }
}

class _GoalSheet extends StatefulWidget {
  const _GoalSheet({required this.initial, required this.onChanged});

  final int initial;
  final ValueChanged<int> onChanged;

  @override
  State<_GoalSheet> createState() => _GoalSheetState();
}

class _GoalSheetState extends State<_GoalSheet> {
  late int _goal = clampGoal(widget.initial);

  void _set(int value) {
    final next = clampGoal(value);
    if (next == _goal) return;
    setState(() => _goal = next);
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(l10n.progressGoalSheetTitle, style: AppTypography.bodyStrong(colors.ink)),
            ),
            const SizedBox(height: 8),
            Text(l10n.progressGoalSheetBody, style: AppTypography.body(colors.sage)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SemanticButton(
                  label: l10n.progressGoalDecrease,
                  onTap: () => _set(_goal - 1),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Icon(Icons.remove_circle_outline, color: colors.gold),
                  ),
                ),
                Flexible(
                  child: Semantics(
                    liveRegion: true,
                    label: l10n.progressGoalValue(_goal),
                    excludeSemantics: true,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        l10n.progressGoalValue(_goal),
                        style: AppTypography.timeLarge(colors.ink),
                      ),
                    ),
                  ),
                ),
                SemanticButton(
                  label: l10n.progressGoalIncrease,
                  onTap: () => _set(_goal + 1),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Icon(Icons.add_circle_outline, color: colors.gold),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.progressGoalSheetDone, style: AppTypography.body(colors.gold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
