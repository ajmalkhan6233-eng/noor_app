// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/azkar/data/azkar_category.dart';
import 'package:noor/features/azkar/presentation/widgets/azkar_category_icon_painters_a.dart';
import 'package:noor/features/azkar/presentation/widgets/azkar_category_icon_painters_b.dart';

CustomPainter _painterFor(AzkarCategory category) {
  const color = Colors.amber;
  return switch (category) {
    AzkarCategory.morning => AzkarMorningIconPainter(color),
    AzkarCategory.evening => AzkarEveningIconPainter(color),
    AzkarCategory.afterPrayer => AzkarAfterPrayerIconPainter(color),
    AzkarCategory.sleep => AzkarSleepIconPainter(color),
    AzkarCategory.travel => AzkarTravelIconPainter(color),
    AzkarCategory.childProtection => AzkarChildProtectionIconPainter(color),
    AzkarCategory.illness => AzkarIllnessIconPainter(color),
    AzkarCategory.distress => AzkarDistressIconPainter(color),
    AzkarCategory.debt => AzkarDebtIconPainter(color),
    AzkarCategory.visitingGrave => AzkarVisitingGraveIconPainter(color),
    AzkarCategory.visitingSick => AzkarVisitingSickIconPainter(color),
  };
}

void main() {
  for (final category in AzkarCategory.values) {
    testWidgets('${category.label} icon renders without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(width: 24, height: 24, child: CustomPaint(painter: _painterFor(category))),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
