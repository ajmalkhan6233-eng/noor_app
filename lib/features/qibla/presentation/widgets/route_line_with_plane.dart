// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of qibla_route_card.dart to stay under the 150-line-per-
// file rule — the curved dashed line, endpoint labels, and the
// travelling plane silhouette.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import 'route_line_painter.dart';

class RouteLineWithPlane extends StatefulWidget {
  const RouteLineWithPlane({super.key, required this.originLabel});

  final String originLabel;

  static const arc = RouteArc(start: Offset(14, 26), control: Offset(157, -6), end: Offset(300, 26));

  @override
  State<RouteLineWithPlane> createState() => _RouteLineWithPlaneState();
}

class _RouteLineWithPlaneState extends State<RouteLineWithPlane> with SingleTickerProviderStateMixin {
  late final AnimationController _planeController;

  @override
  void initState() {
    super.initState();
    _planeController = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
  }

  @override
  void dispose() {
    _planeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const arc = RouteLineWithPlane.arc;
    final originAbbrev = widget.originLabel.length > 3
        ? widget.originLabel.substring(0, 3).toUpperCase()
        : widget.originLabel.toUpperCase();

    return SizedBox(
      height: 34,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: const Size(314, 34),
            painter: RouteLinePainter(
              arc: arc,
              dashColor: colors.gold.withValues(alpha: 0.4),
              dotColors: (colors.accentSecondary, colors.gold),
            ),
          ),
          _endpointLabel(colors, arc.start.dx, originAbbrev),
          _endpointLabel(colors, arc.end.dx, 'MAKKAH'),
          AnimatedBuilder(
            animation: _planeController,
            builder: (context, _) {
              final t = _planeController.value;
              final point = arc.pointAt(t);
              final heading = arc.headingAt(t);
              return Positioned(
                left: point.dx - 9,
                top: point.dy - 4,
                child: Transform.rotate(
                  angle: heading,
                  child: CustomPaint(size: const Size(18, 8), painter: PlaneSilhouettePainter(colors.gold)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _endpointLabel(AppColorTokens colors, double centerX, String text) {
    return Positioned(
      left: centerX - 30,
      top: 0,
      child: SizedBox(
        width: 60,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.sage, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.6),
        ),
      ),
    );
  }
}
