// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Full Zakat al-Mal calculator: gold, silver, cash, receivables,
// business inventory, minus liabilities. Nisab is priced from
// user-entered gold/silver prices — this offline app never fetches a
// market price. All maths is pure and unit-tested — see
// zakat_calculator.dart.

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../data/zakat_calculator.dart';
import 'widgets/zakat_number_field.dart';
import 'widgets/zakat_result_card.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  var _inputs = const ZakatInputs();

  @override
  Widget build(BuildContext context) {
    final result = ZakatCalculator.calculate(_inputs);
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: const Text('Zakat calculator')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Gold & silver', style: AppTypography.caption),
                const SizedBox(height: 8),
                ZakatNumberField(
                  label: 'Gold (grams)',
                  onChanged: (v) => setState(
                    () => _inputs = _inputs.copyWith(goldGrams: v),
                  ),
                ),
                ZakatNumberField(
                  label: 'Gold price per gram (today)',
                  onChanged: (v) => setState(
                    () => _inputs = _inputs.copyWith(goldPricePerGram: v),
                  ),
                ),
                ZakatNumberField(
                  label: 'Silver (grams)',
                  onChanged: (v) => setState(
                    () => _inputs = _inputs.copyWith(silverGrams: v),
                  ),
                ),
                ZakatNumberField(
                  label: 'Silver price per gram (today)',
                  onChanged: (v) => setState(
                    () => _inputs = _inputs.copyWith(silverPricePerGram: v),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Other assets & liabilities',
                  style: AppTypography.caption,
                ),
                const SizedBox(height: 8),
                ZakatNumberField(
                  label: 'Cash & savings',
                  onChanged: (v) =>
                      setState(() => _inputs = _inputs.copyWith(cash: v)),
                ),
                ZakatNumberField(
                  label: 'Receivables owed to you',
                  onChanged: (v) => setState(
                    () => _inputs = _inputs.copyWith(receivables: v),
                  ),
                ),
                ZakatNumberField(
                  label: 'Business inventory value',
                  onChanged: (v) => setState(
                    () =>
                        _inputs = _inputs.copyWith(businessInventoryValue: v),
                  ),
                ),
                ZakatNumberField(
                  label: 'Liabilities (debts due now)',
                  onChanged: (v) => setState(
                    () => _inputs = _inputs.copyWith(liabilities: v),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ZakatResultCard(result: result),
        ],
      ),
    );
  }
}
