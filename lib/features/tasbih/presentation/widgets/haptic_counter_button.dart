import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../logic/tasbih_cubit/tasbih_cubit.dart';
import '../../logic/tasbih_cubit/tasbih_state.dart';

/// Accessible tactile counter button. Wrapped in Semantics() for
/// VoiceOver/TalkBack, with a glass + glow treatment (BackdropFilter
/// blur, glowing border, spring scale-tap) built natively in Flutter.
class HapticCounterButton extends StatefulWidget {
  const HapticCounterButton({super.key});

  @override
  State<HapticCounterButton> createState() => _HapticCounterButtonState();
}

class _HapticCounterButtonState extends State<HapticCounterButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
    lowerBound: 0.92,
    upperBound: 1.0,
    value: 1.0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap(TasbihCubit cubit) async {
    await _controller.reverse();
    await _controller.forward();
    await cubit.increment();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TasbihCubit>();
    return BlocBuilder<TasbihCubit, TasbihState>(
      builder: (context, state) {
        return Semantics(
          button: true,
          label:
              'Tasbih counter, ${state.count} of ${state.target ?? "unlimited"}',
          hint: 'Double tap to count one ${state.dhikrLabel}',
          child: GestureDetector(
            onTap: () => _handleTap(cubit),
            child: ScaleTransition(
              scale: _controller,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(120),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    width: 220,
                    height: 220,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.cardSurface.withOpacity(0.55),
                      border: Border.all(
                        color: AppColors.gold.withOpacity(0.35),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: state.isMilestone
                              ? AppColors.glowMilestone
                              : AppColors.glowSoft,
                          blurRadius: state.isMilestone ? 40 : 20,
                          spreadRadius: state.isMilestone ? 6 : 2,
                        ),
                      ],
                    ),
                    child: Text(
                      '${state.count}',
                      style: const TextStyle(
                        color: AppColors.hudText,
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
