// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Static Qibla compass — no sensor stream, no live needle rotation.
// The GPU/compositor rendering glitch that affected the previous live
// needle versions is entirely avoided by never animating the needle.
// The bearing to the Kaaba is computed once from the saved location
// and painted as a fixed compass rose. Clean, correct, zero GPU risk.
//
// Design: obsidian disc, cardinal directions, a gold needle drawn via
// CustomPainter pointing at the Kaaba bearing (0° = North, clockwise).

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/widgets/glass_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../prayer_times/logic/prayer_cubit/prayer_cubit.dart';
import '../../prayer_times/logic/prayer_cubit/prayer_state.dart';
import '../data/qibla_calculator.dart';
import '../../../core/constants/app_color_tokens.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.colors.paper,
      appBar: AppBar(
        backgroundColor: context.colors.paper,
        elevation: 0,
        title: Text(l10n.qiblaScreenTitle),
      ),
      body: BlocBuilder<PrayerCubit, PrayerState>(
        builder: (context, state) {
          if (!state.hasCoordinates) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: GlassCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_off_outlined, color: context.colors.sage, size: 36),
                      const SizedBox(height: 16),
                      Text(
                        'Set your location in Settings to see the Qibla direction.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: context.colors.ink, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final bearing = QiblaCalculator.bearingToKaaba(
            state.latitude!,
            state.longitude!,
          );
          final distance = QiblaCalculator.distanceToKaabaKm(
            state.latitude!,
            state.longitude!,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Compass dial
                Center(
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: CustomPaint(
                      painter: _QiblaCompassPainter(
                        bearingDegrees: bearing,
                        goldColor: context.colors.gold,
                        inkColor: context.colors.ink,
                        sageColor: context.colors.sage,
                        cardColor: context.colors.card,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Bearing + distance readout
                GlassCard(
                  child: Column(
                    children: [
                      Semantics(
                        label: '${bearing.round()} degrees towards Kaaba, '
                            '${distance.round()} kilometres away',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _stat(context, '${bearing.round()}°', 'Bearing'),
                            Container(width: 1, height: 40, color: context.colors.hairline),
                            _stat(context, '${distance.round()} km', 'Distance'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Direction to the Kaaba, Makkah',
                        style: TextStyle(color: context.colors.sage, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Face ${bearing.round()}° from true north',
                        style: TextStyle(
                          color: context.colors.gold,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Point yourself so the gold needle faces you. '
                  'You are then facing the Qibla.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.colors.sage, fontSize: 13),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: context.colors.gold,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(label, style: TextStyle(color: context.colors.sage, fontSize: 12)),
      ],
    );
  }
}

/// Draws a compass rose with cardinal directions (N/S/E/W) and a gold
/// needle pointing at [bearingDegrees] clockwise from north.
/// Pure CustomPainter — no animation, no sensor, no GPU tricks.
class _QiblaCompassPainter extends CustomPainter {
  const _QiblaCompassPainter({
    required this.bearingDegrees,
    required this.goldColor,
    required this.inkColor,
    required this.sageColor,
    required this.cardColor,
  });

  final double bearingDegrees;
  final Color goldColor;
  final Color inkColor;
  final Color sageColor;
  final Color cardColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Background disc
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = cardColor,
    );

    // Outer ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = goldColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Tick marks — 24 minor, 4 major (cardinal)
    final tickPaint = Paint()
      ..color = sageColor.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    final majorTickPaint = Paint()
      ..color = goldColor.withValues(alpha: 0.7)
      ..strokeWidth = 2;

    for (int i = 0; i < 24; i++) {
      final angle = i * 15.0 * math.pi / 180;
      final isCardinal = i % 6 == 0;
      final inner = radius - (isCardinal ? 18 : 10);
      final outer = radius - 2;
      final cos = math.cos(angle - math.pi / 2);
      final sin = math.sin(angle - math.pi / 2);
      canvas.drawLine(
        center + Offset(cos * inner, sin * inner),
        center + Offset(cos * outer, sin * outer),
        isCardinal ? majorTickPaint : tickPaint,
      );
    }

    // Cardinal labels N / S / E / W
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    void drawLabel(String text, double angle, Color color) {
      final labelRadius = radius - 28;
      final cos = math.cos(angle - math.pi / 2);
      final sin = math.sin(angle - math.pi / 2);
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      );
      textPainter.layout();
      final pos = center +
          Offset(
            cos * labelRadius - textPainter.width / 2,
            sin * labelRadius - textPainter.height / 2,
          );
      textPainter.paint(canvas, pos);
    }

    drawLabel('N', 0, goldColor);
    drawLabel('E', math.pi / 2, sageColor);
    drawLabel('S', math.pi, sageColor);
    drawLabel('W', 3 * math.pi / 2, sageColor);

    // Kaaba icon at center
    final kaabaPaint = Paint()
      ..color = goldColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 20, kaabaPaint);
    canvas.drawCircle(
      center,
      20,
      Paint()
        ..color = goldColor.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Needle pointing to Qibla bearing
    final needleAngle = bearingDegrees * math.pi / 180 - math.pi / 2;
    final needleLength = radius - 36;
    final needleTipX = center.dx + math.cos(needleAngle) * needleLength;
    final needleTipY = center.dy + math.sin(needleAngle) * needleLength;
    final needleBaseX = center.dx - math.cos(needleAngle) * 24;
    final needleBaseY = center.dy - math.sin(needleAngle) * 24;

    // Needle shadow/glow
    canvas.drawLine(
      Offset(needleBaseX, needleBaseY),
      Offset(needleTipX, needleTipY),
      Paint()
        ..color = goldColor.withValues(alpha: 0.18)
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );

    // Needle itself
    final needlePath = Path();
    final perpAngle = needleAngle + math.pi / 2;
    const baseWidth = 5.0;
    needlePath.moveTo(needleTipX, needleTipY);
    needlePath.lineTo(
      needleBaseX + math.cos(perpAngle) * baseWidth,
      needleBaseY + math.sin(perpAngle) * baseWidth,
    );
    needlePath.lineTo(
      needleBaseX - math.cos(perpAngle) * baseWidth,
      needleBaseY - math.sin(perpAngle) * baseWidth,
    );
    needlePath.close();
    canvas.drawPath(
      needlePath,
      Paint()
        ..color = goldColor
        ..style = PaintingStyle.fill,
    );

    // Center dot
    canvas.drawCircle(center, 6, Paint()..color = goldColor);
    canvas.drawCircle(center, 6, Paint()
      ..color = cardColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(_QiblaCompassPainter old) =>
      old.bearingDegrees != bearingDegrees;
}
