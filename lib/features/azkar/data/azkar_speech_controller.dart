// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Tracks which single Azkar/Dua item (if any) currently has its
// translation being read aloud, and owns the one shared
// AzkarTranslationSpeechPlayer/TTS engine underneath every
// AzkarTranslationAudioButton — same reasoning as SurahReaderScreen
// owning one SurahAudioPlayer: the OS TTS engine is one resource, so
// "another item tapped stops the previous one" needs one shared owner,
// not a player per tile. A singleton (like LocationService's own
// session-wide GPS cache) rather than a widget-owned instance, since
// AzkarItemTile is rendered from two separate screens (the category
// list and the bookmarks list) that don't otherwise share a widget
// ancestor to hang a single instance off of.
//
// [ValueNotifier]'s value is the currently-speaking item's id, or null.

import 'package:flutter/foundation.dart';

import 'azkar_translation_speech_player.dart';

class AzkarSpeechController extends ValueNotifier<int?> {
  AzkarSpeechController({AzkarTranslationSpeechPlayer? player})
    : _player = player ?? AzkarTranslationSpeechPlayer(),
      super(null) {
    _player.setOnComplete(() => value = null);
  }

  static final instance = AzkarSpeechController();

  final AzkarTranslationSpeechPlayer _player;

  /// Speaks [translation] for [itemId], or stops it if that same item
  /// is already speaking. Tapping a different item while one is
  /// already speaking switches to the new one (the player itself stops
  /// the old utterance first).
  Future<void> toggle(int itemId, String translation) async {
    if (value == itemId) {
      await _player.stop();
      value = null;
      return;
    }
    value = itemId;
    await _player.speak(translation);
  }
}
