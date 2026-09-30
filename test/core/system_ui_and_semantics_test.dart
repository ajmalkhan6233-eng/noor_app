// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/presentation/widgets/section_header.dart';
import 'package:noor/core/utils/semantics_helpers.dart';
import 'package:noor/core/utils/system_ui.dart';

void main() {
  test('dark themes get light status-bar icons, light themes get dark ones', () {
    expect(overlayStyleFor(Brightness.dark).statusBarIconBrightness, Brightness.light);
    expect(overlayStyleFor(Brightness.light).statusBarIconBrightness, Brightness.dark);
    expect(overlayStyleFor(Brightness.dark).statusBarColor, Colors.transparent);
  });

  testWidgets('SectionHeader is announced as a heading', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SectionHeader('Display'))));

    expect(
      tester.getSemantics(find.text('DISPLAY')),
      matchesSemantics(label: 'DISPLAY', isHeader: true),
    );
    handle.dispose();
  });

  testWidgets('SemanticButton reports checked state for toggles', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SemanticButton(
            label: 'Fajr',
            checked: true,
            onTap: () {},
            child: const SizedBox(width: 60, height: 60),
          ),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(SemanticButton)),
      matchesSemantics(label: 'Fajr', isButton: true, hasCheckedState: true, isChecked: true, hasEnabledState: true, isEnabled: true, hasTapAction: true),
    );
    handle.dispose();
  });
}
