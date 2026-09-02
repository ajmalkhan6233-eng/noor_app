// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// On-device text-to-speech for an Azkar/Dua's English `translation`
// field only — never the Arabic `content`/`arabicText` or the
// `transliteration` field. Reading Latin-script transliteration
// through an English TTS voice mispronounces it (wrong phonemes for
// the same letters), which is worse than no audio at all — so this
// class has no method that accepts anything but a translation string.
// Uses the OS's built-in engine (Android TextToSpeech / iOS
// AVSpeechSynthesizer) via flutter_tts — no network call.

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AzkarTranslationSpeechPlayer {
  AzkarTranslationSpeechPlayer({FlutterTts? tts}) : _tts = tts ?? FlutterTts() {
    _tts.setLanguage('en-US');
  }

  final FlutterTts _tts;

  /// Fires when the current utterance finishes on its own.
  void setOnComplete(VoidCallback onComplete) {
    _tts.setCompletionHandler(onComplete);
  }

  /// Speaks [translation] aloud, stopping any utterance already in
  /// progress first so tapping a different item's play button never
  /// overlaps speech.
  Future<void> speak(String translation) async {
    await _tts.stop();
    await _tts.speak(translation);
  }

  Future<void> stop() => _tts.stop();
}
