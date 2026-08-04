// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure logic, no I/O: which way a given Sa'i round walks. Odd rounds
// go Safa -> Marwah, even rounds go Marwah -> Safa. Round 1 starts at
// Safa (odd, Safa -> Marwah) and round 7 is also odd, so it too runs
// Safa -> Marwah — which is exactly what makes a full 7-round Sa'i
// begin at Safa and end at Marwah. No special-casing of round 7 is
// needed; the plain odd/even rule already produces that result.

enum SaiDirection { safaToMarwah, marwahToSafa }

/// Returns the walking direction for the given 1-based [round] (1-7).
SaiDirection saiDirectionForRound(int round) {
  assert(round >= 1 && round <= 7, 'Sa\'i round must be between 1 and 7');
  return round.isOdd ? SaiDirection.safaToMarwah : SaiDirection.marwahToSafa;
}
