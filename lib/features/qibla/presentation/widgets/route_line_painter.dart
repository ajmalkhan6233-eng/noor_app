// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The route card's curved dashed line, endpoint dots, and travelling
// plane silhouette — split out of qibla_route_card.dart to stay under
// the 150-line-per-file rule. Deliberately generic: a plain gold
// widebody silhouette, no tail markings, no airline name or livery of
// any kind — this is a decorative "distance to Makkah" motif, not a
// depiction of any real airline or aircraft.

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A single quadratic-Bezier arc from [start] to [end], bowing upward
/// through [control] — shared by the painter (for the dashed line) and
/// the plane's position/heading (via [pointAt]/[tangentAt]) so both
/// always agree exactly, unlike duplicating the curve math in two
/// places.
class RouteArc {
  const RouteArc({required this.start, required this.control, required this.end});

  final Offset start;
  final Offset control;
  final Offset end;

  Offset pointAt(double t) {
    final u = 1 - t;
    return Offset(
      u * u * start.dx + 2 * u * t * control.dx + t * t * end.dx,
      u * u * start.dy + 2 * u * t * control.dy + t * t * end.dy,
    );
  }

  /// Heading angle (radians) of the curve's tangent at [t], for
  /// rotating the plane so it always points the way it's travelling.
  double headingAt(double t) {
    final u = 1 - t;
    final dx = 2 * u * (control.dx - start.dx) + 2 * t * (end.dx - control.dx);
    final dy = 2 * u * (control.dy - start.dy) + 2 * t * (end.dy - control.dy);
    return math.atan2(dy, dx);
  }
}

class RouteLinePainter extends CustomPainter {
  RouteLinePainter({required this.arc, required this.dashColor, required this.dotColors});

  final RouteArc arc;
  final Color dashColor;

  /// Start dot color, end dot color.
  final (Color, Color) dotColors;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..moveTo(arc.start.dx, arc.start.dy);
    path.quadraticBezierTo(arc.control.dx, arc.control.dy, arc.end.dx, arc.end.dy);

    final dashPaint = Paint()
      ..color = dashColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dashLength = 1.0;
      const gapLength = 5.5;
      while (distance < metric.length) {
        final next = (distance + dashLength).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), dashPaint);
        distance = next + gapLength;
      }
    }

    canvas.drawCircle(arc.start, 4, Paint()..color = dotColors.$1);
    canvas.drawCircle(arc.end, 4, Paint()..color = dotColors.$2);
  }

  @override
  bool shouldRepaint(covariant RouteLinePainter old) =>
      old.arc.start != arc.start || old.arc.end != arc.end || old.arc.control != arc.control;
}

/// A generic top-down widebody silhouette — swept wings, no tail
/// markings, no airline identity of any kind.
class PlaneSilhouettePainter extends CustomPainter {
  PlaneSilhouettePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 32, size.height / 32);
    final fill = Paint()..color = color;
    final body = Path()
      ..moveTo(30, 16)
      ..cubicTo(24, 9.2, 18, 5.4, 10, 4.2)
      ..cubicTo(2, 3.2, -6, 4, -12, 8.8)
      ..cubicTo(-17, 12.4, -20, 13.2, -24, 14)
      ..lineTo(-28, 4.4)
      ..lineTo(-33, 13.4)
      ..lineTo(-36, 17.6)
      ..cubicTo(-28, 21.2, -16, 22.4, -4, 21.6)
      ..cubicTo(8, 21, 20, 19.2, 30, 16)
      ..close();
    canvas.drawPath(body, fill);
    final leftWing = Path()
      ..moveTo(-6, 19.6)
      ..lineTo(-26, 34.8)
      ..lineTo(-13, 34)
      ..lineTo(-0.4, 21.2)
      ..close();
    canvas.drawPath(leftWing, fill..color = color.withValues(alpha: 0.85));
    final tailFin = Path()
      ..moveTo(-27, 3.2)
      ..lineTo(-37, -3.6)
      ..lineTo(-29.6, 1.6)
      ..close();
    canvas.drawPath(tailFin, Paint()..color = color.withValues(alpha: 0.85));
  }

  @override
  bool shouldRepaint(covariant PlaneSilhouettePainter old) => old.color != color;
}
