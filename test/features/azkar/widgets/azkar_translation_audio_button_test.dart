// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/azkar/presentation/widgets/azkar_translation_audio_button.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('available and not playing: tap fires onToggle', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        AzkarTranslationAudioButton(
          available: true,
          isPlaying: false,
          onToggle: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.byType(IconButton));
    expect(tapped, isTrue);
    expect(find.byIcon(Icons.volume_up_outlined), findsOneWidget);
  });

  testWidgets('playing shows the pause icon', (tester) async {
    await tester.pumpWidget(
      _wrap(AzkarTranslationAudioButton(available: true, isPlaying: true, onToggle: () {})),
    );

    expect(find.byIcon(Icons.pause_circle_outline), findsOneWidget);
  });

  testWidgets('unavailable disables the button and its own onPressed', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        AzkarTranslationAudioButton(
          available: false,
          isPlaying: false,
          onToggle: () => tapped = true,
        ),
      ),
    );

    final button = tester.widget<IconButton>(find.byType(IconButton));
    expect(button.onPressed, isNull);

    await tester.tap(find.byType(IconButton), warnIfMissed: false);
    expect(tapped, isFalse);
  });

  testWidgets('unavailable carries a clear semantics reason, not a bare disabled state', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AzkarTranslationAudioButton(available: false, isPlaying: false, onToggle: () {}),
      ),
    );

    expect(
      tester.getSemantics(find.byType(AzkarTranslationAudioButton)),
      matchesSemantics(
        isButton: true,
        label: 'Translation audio unavailable for this dua',
        value: 'Stopped',
        hint: 'No English translation is available yet for this item',
      ),
    );
  });
}
