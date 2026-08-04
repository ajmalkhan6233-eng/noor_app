// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/pilgrimage/data/sai_direction.dart';

void main() {
  group('saiDirectionForRound', () {
    test('odd rounds go Safa to Marwah', () {
      for (final round in [1, 3, 5, 7]) {
        expect(saiDirectionForRound(round), SaiDirection.safaToMarwah);
      }
    });

    test('even rounds go Marwah to Safa', () {
      for (final round in [2, 4, 6]) {
        expect(saiDirectionForRound(round), SaiDirection.marwahToSafa);
      }
    });

    test('a full 7-round Sa\'i begins at Safa and ends at Marwah', () {
      // Round 1 (the start) walks Safa -> Marwah, so it *begins* at Safa.
      expect(saiDirectionForRound(1), SaiDirection.safaToMarwah);
      // Round 7 (the final round) is also odd, so it too walks
      // Safa -> Marwah, meaning the whole Sa'i *ends* at Marwah.
      expect(saiDirectionForRound(7), SaiDirection.safaToMarwah);
    });

    test('asserts on out-of-range rounds', () {
      expect(() => saiDirectionForRound(0), throwsA(isA<AssertionError>()));
      expect(() => saiDirectionForRound(8), throwsA(isA<AssertionError>()));
    });
  });
}
