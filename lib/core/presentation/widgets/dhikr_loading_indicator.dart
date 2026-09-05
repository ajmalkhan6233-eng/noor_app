// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A branded loading state — three pulsing gold/cyan dots plus a
// slowly cycling dhikr phrase — used wherever a screen would
// otherwise show a plain CircularProgressIndicator. Reuses
// DhikrOption's already-reviewed transliterations verbatim rather
// than typing new Arabic/transliterated text here (see
// noor-religious-text-verification).

import 'package:flutter/material.dart';

import '../../constants/app_color_tokens.dart';
import '../../../features/tasbih/data/dhikr_option.dart';

class DhikrLoadingIndicator extends StatefulWidget {
  const DhikrLoadingIndicator({super.key});

  @override
  State<DhikrLoadingIndicator> createState() => _DhikrLoadingIndicatorState();
}

class _DhikrLoadingIndicatorState extends State<DhikrLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _phraseIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.forward(from: 0);
          setState(() => _phraseIndex = (_phraseIndex + 1) % DhikrOption.values.length);
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: 'Loading',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final t = (_controller.value - i * 0.2).clamp(0.0, 1.0);
                  final pulse = (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.lerp(colors.sage, colors.gold, pulse),
                      boxShadow: [
                        BoxShadow(
                          color: colors.gold.withValues(alpha: pulse * 0.6),
                          blurRadius: 6 * pulse,
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: Text(
              DhikrOption.values[_phraseIndex].label,
              key: ValueKey(_phraseIndex),
              style: TextStyle(color: colors.sage, fontSize: 13, letterSpacing: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
