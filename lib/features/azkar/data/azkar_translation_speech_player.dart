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
//
// Live-device feedback (2026-09-06): the default system voice read too
// fast/flat to follow comfortably. A slower rate and a deliberate
// voice pick (preferring a higher-quality/"network" en-US voice over
// the on-device default, when the OS reports one) makes it clearer —
// this is still whatever voice the device actually has installed,
// there is no bundled recording to swap in.

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AzkarTranslationSpeechPlayer {
  AzkarTranslationSpeechPlayer({FlutterTts? tts}) : _tts = tts ?? FlutterTts() {
    _tts.setLanguage('en-US');
    _tts.setSpeechRate(0.42);
    _tts.setPitch(1.0);
    _pickBestVoice();
  }

  final FlutterTts _tts;

  /// Best-effort: some Android builds report multiple en-US voices of
  /// visibly different quality (a `quality` field, higher = better, or
  /// a name containing "network"/"enhanced" for a cloud-rendered
  /// voice vs. the terse local default). Falls through quietly to
  /// whatever the OS already picked if this can't be determined —
  /// never crashes the player over a missing/malformed voice list.
  Future<void> _pickBestVoice() async {
    try {
      final voices = await _tts.getVoices as List<dynamic>?;
      if (voices == null || voices.isEmpty) return;
      final enUs = voices
          .whereType<Map<dynamic, dynamic>>()
          .where((v) => (v['locale'] as String?)?.toLowerCase().startsWith('en-us') ?? false)
          .toList();
      if (enUs.isEmpty) return;
      enUs.sort((a, b) {
        final qa = int.tryParse('${a['quality'] ?? 0}') ?? 0;
        final qb = int.tryParse('${b['quality'] ?? 0}') ?? 0;
        if (qa != qb) return qb.compareTo(qa);
        final na = (a['name'] as String? ?? '').toLowerCase();
        final nb = (b['name'] as String? ?? '').toLowerCase();
        final aIsEnhanced = na.contains('network') || na.contains('enhanced') ? 1 : 0;
        final bIsEnhanced = nb.contains('network') || nb.contains('enhanced') ? 1 : 0;
        return bIsEnhanced.compareTo(aIsEnhanced);
      });
      final best = enUs.first;
      await _tts.setVoice({
        'name': '${best['name']}',
        'locale': '${best['locale']}',
      });
    } catch (_) {
      // No voice list, or the platform doesn't support setVoice — the
      // language set above is still in effect either way.
    }
  }

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
