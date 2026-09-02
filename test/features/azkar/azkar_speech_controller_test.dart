// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/azkar/data/azkar_speech_controller.dart';
import 'package:noor/features/azkar/data/azkar_translation_speech_player.dart';

class _FakeSpeechPlayer implements AzkarTranslationSpeechPlayer {
  final List<String> spoken = [];
  int stopCount = 0;
  void Function()? _onComplete;

  @override
  void setOnComplete(void Function() onComplete) => _onComplete = onComplete;

  @override
  Future<void> speak(String translation) async {
    spoken.add(translation);
  }

  @override
  Future<void> stop() async {
    stopCount++;
  }

  void completeNow() => _onComplete?.call();
}

void main() {
  late _FakeSpeechPlayer player;
  late AzkarSpeechController controller;

  setUp(() {
    player = _FakeSpeechPlayer();
    controller = AzkarSpeechController(player: player);
  });

  test('toggling a stopped item speaks its translation and marks it playing', () async {
    await controller.toggle(1, 'Glory be to Allah');

    expect(player.spoken, ['Glory be to Allah']);
    expect(controller.value, 1);
  });

  test('toggling the same already-playing item stops it', () async {
    await controller.toggle(1, 'Glory be to Allah');
    await controller.toggle(1, 'Glory be to Allah');

    expect(player.stopCount, 1);
    expect(controller.value, isNull);
  });

  test('toggling a different item switches without needing an explicit stop first', () async {
    await controller.toggle(1, 'Glory be to Allah');
    await controller.toggle(2, 'Praise be to Allah');

    expect(controller.value, 2);
    expect(player.spoken, ['Glory be to Allah', 'Praise be to Allah']);
  });

  test('the player finishing on its own clears the playing item', () async {
    await controller.toggle(1, 'Glory be to Allah');
    player.completeNow();

    expect(controller.value, isNull);
  });
}
