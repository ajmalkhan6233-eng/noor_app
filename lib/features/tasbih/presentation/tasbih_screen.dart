// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/utils/semantics_helpers.dart';
import '../logic/tasbih_cubit/tasbih_cubit.dart';
import '../logic/tasbih_cubit/tasbih_state.dart';
import 'widgets/haptic_counter_button.dart';

/// Screen-free-friendly tasbih (dhikr counter) screen.
///
/// Provides its own [TasbihCubit] and restores any previously saved
/// count on load, so the counter survives app restarts.
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
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: BlocBuilder<TasbihCubit, TasbihState>(
        builder: (context, state) {
          return Center(
            child: StaggeredFadeIn(
              children: [
                Semantics(
                  label: 'Currently counting ${state.dhikrLabel}',
                  child: Text(
                    state.dhikrLabel,
                    style: const TextStyle(color: AppColors.sage, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 32),
                HapticCounterButton(
                  count: state.count,
                  pulsing: state.justHitMilestone,
                  onTap: () => context.read<TasbihCubit>().increment(),
                ),
                const SizedBox(height: 40),
                SemanticButton(
                  label: AppStrings.tasbihResetSemanticLabel,
                  hint: 'Double tap to reset the count to zero',
                  onTap: () => context.read<TasbihCubit>().reset(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        color: AppColors.emerald,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
