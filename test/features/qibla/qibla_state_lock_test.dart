// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/sensors/compass_reading.dart';
import 'package:noor/features/qibla/logic/qibla_cubit/qibla_state.dart';

void main() {
  QiblaState stateWith({
    required double bearing,
    required double heading,
    CompassAccuracy accuracy = CompassAccuracy.good,
  }) {
    return QiblaState(
      bearingDegrees: bearing,
      headingDegrees: heading,
      compassAccuracy: accuracy,
    );
  }

  group('QiblaState.isLocked', () {
    test('locks when facing exactly the qibla with a good reading', () {
      final state = stateWith(bearing: 118.99, heading: 118.99);
      expect(state.isLocked, isTrue);
    });

    test('locks within the threshold, either side', () {
      expect(
        stateWith(bearing: 100, heading: 100 - kQiblaLockThresholdDegrees + 1)
            .isLocked,
        isTrue,
      );
      expect(
        stateWith(bearing: 100, heading: 100 + kQiblaLockThresholdDegrees - 1)
            .isLocked,
        isTrue,
      );
    });

    test('does not lock just outside the threshold', () {
      final state = stateWith(
        bearing: 100,
        heading: 100 + kQiblaLockThresholdDegrees + 1,
      );
      expect(state.isLocked, isFalse);
    });

    test('does not lock across the 0/360 wrap boundary either', () {
      final state = stateWith(bearing: 1, heading: 359);
      expect(state.isLocked, isTrue);
    });

    test('does not lock without a good compass reading', () {
      final state = stateWith(
        bearing: 100,
        heading: 100,
        accuracy: CompassAccuracy.low,
      );
      expect(state.isLocked, isFalse);
    });

    test('does not lock before a heading or bearing exists', () {
      expect(const QiblaState().isLocked, isFalse);
      expect(const QiblaState(bearingDegrees: 100).isLocked, isFalse);
    });
  });
}
