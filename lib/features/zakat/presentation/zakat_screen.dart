// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A simple 2.5% Zakat al-Mal calculator. Nisab (the minimum wealth
// threshold, traditionally 85g gold or 595g silver) is stated as
// text, never converted to a live currency figure — that would need
// a market-price network call, which this app never makes.

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/presentation/widgets/app_card.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  final _controller = TextEditingController();
  double? _wealth;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final due = _wealth == null ? null : _wealth! * 0.025;
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
                const Text('Zakatable wealth', style: AppTypography.caption),
                const SizedBox(height: 8),
                Semantics(
                  textField: true,
                  label: 'Total zakatable wealth',
                  child: TextField(
                    controller: _controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(color: AppColors.ink),
                    decoration: const InputDecoration(
                      hintText: 'Cash, savings, and other zakatable assets',
                    ),
                    onChanged: (v) =>
                        setState(() => _wealth = double.tryParse(v)),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.hairline, height: 1),
                const SizedBox(height: 16),
                const Text('Zakat due (2.5%)', style: AppTypography.caption),
                const SizedBox(height: 4),
                Text(
                  due == null ? '—' : due.toStringAsFixed(2),
                  style: AppTypography.heroDisplay.copyWith(fontSize: 36),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: const Text(
              'Zakat is due only once your wealth has met or exceeded the '
              'nisab threshold — traditionally the value of 85g of gold, '
              'or 595g of silver (whichever your school of thought uses) '
              '— for a full lunar year. This calculator does not check '
              'current gold/silver prices, since that would require a '
              'network call this offline app never makes; confirm you '
              'meet the nisab yourself before relying on this figure.',
              style: AppTypography.caption,
            ),
          ),
        ],
      ),
    );
  }
}
