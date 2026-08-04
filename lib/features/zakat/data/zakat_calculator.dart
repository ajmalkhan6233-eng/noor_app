// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure Zakat al-Mal maths — no I/O, no widgets, fully unit-testable.
// Nisab (the minimum-wealth threshold) is the value of 87.48g of gold
// or 612.36g of silver; this app is offline, so the user supplies
// today's per-gram prices themselves rather than the app guessing or
// fetching them. Per majority contemporary fiqh council guidance, the
// LOWER of the two nisab values is used for mixed/cash wealth — that
// includes more people under the obligation, not fewer.

class ZakatInputs {
  const ZakatInputs({
    this.goldGrams = 0,
    this.goldPricePerGram = 0,
    this.silverGrams = 0,
    this.silverPricePerGram = 0,
    this.cash = 0,
    this.receivables = 0,
    this.businessInventoryValue = 0,
    this.liabilities = 0,
  });

  final double goldGrams;
  final double goldPricePerGram;
  final double silverGrams;
  final double silverPricePerGram;
  final double cash;
  final double receivables;
  final double businessInventoryValue;
  final double liabilities;

  double get goldValue => goldGrams * goldPricePerGram;
  double get silverValue => silverGrams * silverPricePerGram;

  double get netWealth =>
      goldValue +
      silverValue +
      cash +
      receivables +
      businessInventoryValue -
      liabilities;

  ZakatInputs copyWith({
    double? goldGrams,
    double? goldPricePerGram,
    double? silverGrams,
    double? silverPricePerGram,
    double? cash,
    double? receivables,
    double? businessInventoryValue,
    double? liabilities,
  }) {
    return ZakatInputs(
      goldGrams: goldGrams ?? this.goldGrams,
      goldPricePerGram: goldPricePerGram ?? this.goldPricePerGram,
      silverGrams: silverGrams ?? this.silverGrams,
      silverPricePerGram: silverPricePerGram ?? this.silverPricePerGram,
      cash: cash ?? this.cash,
      receivables: receivables ?? this.receivables,
      businessInventoryValue:
          businessInventoryValue ?? this.businessInventoryValue,
      liabilities: liabilities ?? this.liabilities,
    );
  }
}

class ZakatResult {
  const ZakatResult({
    required this.netWealth,
    required this.nisabThreshold,
    required this.nisabMet,
    required this.zakatDue,
  });

  final double netWealth;
  final double nisabThreshold;
  final bool nisabMet;
  final double zakatDue;
}

abstract final class ZakatCalculator {
  static const double nisabGoldGrams = 87.48;
  static const double nisabSilverGrams = 612.36;
  static const double rate = 0.025;

  static ZakatResult calculate(ZakatInputs inputs) {
    final nisabByGold = nisabGoldGrams * inputs.goldPricePerGram;
    final nisabBySilver = nisabSilverGrams * inputs.silverPricePerGram;

    // If a price wasn't entered (0), that metal can't set the floor —
    // fall back to whichever metal's nisab is actually prices-in.
    final candidates = [
      if (inputs.goldPricePerGram > 0) nisabByGold,
      if (inputs.silverPricePerGram > 0) nisabBySilver,
    ];
    final nisabThreshold = candidates.isEmpty
        ? 0.0
        : candidates.reduce((a, b) => a < b ? a : b);

    final netWealth = inputs.netWealth;
    final nisabMet = nisabThreshold > 0 && netWealth >= nisabThreshold;

    return ZakatResult(
      netWealth: netWealth,
      nisabThreshold: nisabThreshold,
      nisabMet: nisabMet,
      zakatDue: nisabMet ? netWealth * rate : 0,
    );
  }
}
