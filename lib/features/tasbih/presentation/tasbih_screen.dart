// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_color_tokens.dart';
import '../../../core/utils/semantics_helpers.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../home/presentation/widgets/milestone_nudge_sheet.dart';
import '../logic/tasbih_cubit/tasbih_cubit.dart';
import '../logic/tasbih_cubit/tasbih_state.dart';
import 'widgets/dhikr_selector.dart';
import 'widgets/draggable_counter_group.dart';

/// Screen-free-friendly tasbih (dhikr counter) screen.
///
/// Provides its own [TasbihCubit] and restores any previously saved
/// count on load, so the counter survives app restarts. The counter
/// itself is draggable and remembers where it was left.
class TasbihScreen extends StatelessWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasbihCubit()..loadSaved(),
      child: const _TasbihView(),
    );
  }
}

class _TasbihView extends StatelessWidget {
  const _TasbihView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.colors.paper,
      appBar: AppBar(title: Text(l10n.tasbihScreenTitle)),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: DhikrSelector()),
          ),
          Expanded(
            child: BlocConsumer<TasbihCubit, TasbihState>(
              listener: (context, state) {
                if (state.justHitMilestone && state.count == 100) {
                  maybeShowMilestoneNudge(
                    context: context,
                    milestoneKey: 'tasbih_100_complete',
                    message: "You completed a full tasbih cycle. noor is "
                        "free, always — this only takes a second if you'd "
                        "like to help keep it that way.",
                  );
                }
              },
              builder: (context, state) {
                return Stack(
                  // The orb's drag range now spans a large fraction of
                  // the screen (see TasbihOrb._maxPullFraction) — it
                  // must not be clipped at this Stack's own bounds.
                  clipBehavior: Clip.none,
                  children: [
                    DraggableCounterGroup(
                      dhikrLabel: state.dhikrLabel,
                      count: state.count,
                      pulsing: state.justHitMilestone,
                      onTap: () => context.read<TasbihCubit>().increment(),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: SemanticButton(
                        label: l10n.tasbihResetSemanticLabel,
                        hint: l10n.tasbihResetHint,
                        onTap: () => context.read<TasbihCubit>().reset(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            l10n.resetLabel,
                            style: TextStyle(
                              color: context.colors.gold,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
