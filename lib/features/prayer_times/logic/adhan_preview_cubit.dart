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
