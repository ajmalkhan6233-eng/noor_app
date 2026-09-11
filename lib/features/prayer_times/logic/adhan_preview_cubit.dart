// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Lets a UI row preview a prayer's bundled Adhan recording without
// widgets touching AdhanAudioPlayer (package logic) directly.

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/adhan_audio_player.dart';
import '../data/adhan_reciter.dart';

/// Emits the name of the prayer currently previewing, or `null` when
/// nothing is playing.
class AdhanPreviewCubit extends Cubit<String?> {
  AdhanPreviewCubit({AdhanAudioPlayer? player})
    : _player = player ?? AdhanAudioPlayer(),
      super(null) {
    _completeSub = _player.onComplete.listen((_) {
      if (!isClosed) emit(null);
    });
  }

  final AdhanAudioPlayer _player;
  late final StreamSubscription<void> _completeSub;

  /// Plays [reciter]'s Adhan once, always fresh — unlike [togglePreview],
  /// never stops on a repeat call (2026-09-05, direct request: tapping
  /// through several reciter options in Settings to compare them should
  /// always play the new choice, not toggle silent when the previous
  /// tap happened to resolve to the same prayer-name key). Doesn't touch
  /// this cubit's `state`, since the per-prayer preview button elsewhere
  /// owns that toggle semantics independently.
  Future<void> playOnce(AdhanReciter reciter, {String prayerName = 'Fajr'}) {
    return _player.play(prayerName, reciter: reciter);
  }

  Future<void> togglePreview(
    String prayerName, {
    AdhanReciter reciter = AdhanReciter.doha,
  }) async {
    if (state == prayerName) {
      await _player.stop();
      emit(null);
      return;
    }
    emit(prayerName);
    await _player.play(prayerName, reciter: reciter);
  }

  @override
  Future<void> close() {
    _completeSub.cancel();
    _player.dispose();
    return super.close();
  }
}
