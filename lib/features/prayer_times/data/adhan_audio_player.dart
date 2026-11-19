// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Adhan preview playback. Since 2026-11-19 it plays the res/raw files
// the adhan notifications already use, through AdhanPreviewChannel.kt
// (Android MediaPlayer, prepared from a local resource: starts at
// once). The second copy of every adhan under assets/audio/adhan (about
// 20 MB) was removed. Never streams, never fetches remote audio. See
// assets/audio/adhan/README.md for provenance and licences.

import 'dart:async';

import 'package:flutter/services.dart';

import 'adhan_reciter.dart';

/// True when [prayerName] has an adhan to preview (not Sunrise).
bool hasAdhanForPrayer(String prayerName) =>
    adhanRawResourceFor(AdhanReciter.doha, prayerName) != null;

/// Thin wrapper so callers (a Cubit, never a widget directly) don't
/// depend on the platform channel.
class AdhanAudioPlayer {
  AdhanAudioPlayer({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('com.noorapp.noorprayer/adhan_preview');

  final MethodChannel _channel;
  final StreamController<void> _completed = StreamController<void>.broadcast();
  bool _listening = false;

  /// Fires when a preview plays to its end.
  Stream<void> get onComplete => _completed.stream;

  Future<void> play(String prayerName, {AdhanReciter reciter = AdhanReciter.doha}) async {
    final name = adhanRawResourceFor(reciter, prayerName);
    if (name == null) return;
    _listen();
    try {
      await _channel.invokeMethod<bool>('play', {'name': name});
    } catch (_) {
      // No Android side (web preview, tests): silently nothing.
    }
  }

  Future<void> stop() async {
    try {
      await _channel.invokeMethod<void>('stop');
    } catch (_) {}
  }

  Future<void> dispose() async {
    await stop();
    await _completed.close();
  }

  // Set lazily: registering a handler needs the Flutter binding, which
  // plain unit tests don't start.
  void _listen() {
    if (_listening) return;
    _listening = true;
    try {
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'completed' && !_completed.isClosed) _completed.add(null);
      });
    } catch (_) {
      _listening = false;
    }
  }
}
