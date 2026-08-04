// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/pilgrimage/data/tawaf_reminders.dart';

void main() {
  group('tawafRemindersFor', () {
    test('women never get Idtiba or Ramal reminders', () {
      for (var count = 0; count <= 7; count++) {
        final reminders = tawafRemindersFor(circuitCount: count, isMale: false);
        expect(reminders.idtibaActive, isFalse);
        expect(reminders.ramalActive, isFalse);
      }
    });

    test('men: Idtiba active for circuits 0-6, off once 7 are complete', () {
      for (var count = 0; count < 7; count++) {
        expect(
          tawafRemindersFor(circuitCount: count, isMale: true).idtibaActive,
          isTrue,
          reason: 'circuit $count should still be within Idtiba',
        );
      }
      expect(
        tawafRemindersFor(circuitCount: 7, isMale: true).idtibaActive,
        isFalse,
      );
    });

    test('men: Ramal active only during circuits 1-3 (count 0,1,2)', () {
      for (final count in [0, 1, 2]) {
        expect(
          tawafRemindersFor(circuitCount: count, isMale: true).ramalActive,
          isTrue,
          reason: 'circuit $count should be brisk-paced',
        );
      }
      for (final count in [3, 4, 5, 6, 7]) {
        expect(
          tawafRemindersFor(circuitCount: count, isMale: true).ramalActive,
          isFalse,
          reason: 'circuit $count should be normal pace',
        );
      }
    });
  });
}
