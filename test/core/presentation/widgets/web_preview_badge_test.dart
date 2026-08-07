// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// kIsWeb is a compile-time constant, so it can't be flipped at test
// runtime here — this just confirms the widget renders nothing (not
// an error) off the web, which is what every existing suite run
// (including widget_test.dart's build-stamp assertion) relies on.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/presentation/widgets/web_preview_badge.dart';

void main() {
  testWidgets('renders nothing outside a web build', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: WebPreviewBadge())),
    );

    expect(find.text('WEB PREVIEW — not final build'), findsNothing);
    expect(find.byType(SizedBox), findsOneWidget);
  });
}
