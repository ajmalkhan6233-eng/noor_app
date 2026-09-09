import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/dhikr_item_model.dart';
import '../logic/dhikr_counter_cubit.dart';

class DhikrScreen extends StatelessWidget {
  const DhikrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DhikrCounterCubit(),
      child: const _DhikrView(),
    );
  }
}

class _DhikrView extends StatelessWidget {
  const _DhikrView();

  @override
  Widget build(BuildContext context) {
    const obsidianBg = Color(0xFF05070B);
    const cardSurface = Color(0xFF0D1117);
    const goldAccent = Color(0xFFFFB703);
    const cyanAccent = Color(0xFF00F2FE);

    return Scaffold(
      backgroundColor: obsidianBg,
      appBar: AppBar(
        backgroundColor: cardSurface,
        title: const Text('Tactile Tasbih', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: BlocBuilder<DhikrCounterCubit, DhikrCounterState>(
        builder: (context, state) {
          final cubit = context.read<DhikrCounterCubit>();

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: cardSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cyanAccent.withOpacity(0.2)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<DhikrItemModel>(
                    value: state.selectedItem,
                    dropdownColor: cardSurface,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.white),
                    items: DhikrItemModel.defaultPresets.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item.title, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (item) {
                      if (item != null) cubit.selectItem(item);
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  children: [
                    Text(
                      state.selectedItem.arabicText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: goldAccent,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.selectedItem.transliteration,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Semantics(
                  label: 'Tap anywhere to count Dhikr',
                  hint: 'Increments the counter and vibrates',
                  button: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => cubit.increment(),
                    onVerticalDragEnd: (details) {
                      if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
                        cubit.decrement();
                      } else {
                        cubit.increment();
                      }
                    },
                    child: Center(
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cardSurface,
                          border: Border.all(color: cyanAccent, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: cyanAccent.withOpacity(0.15),
                              blurRadius: 30,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${state.currentCount}',
                              style: const TextStyle(
                                color: goldAccent,
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'TAP ANYWHERE',
                              style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Semantics(
                  label: 'Reset counter',
                  button: true,
                  child: TextButton.icon(
                    onPressed: () => cubit.reset(),
                    icon: const Icon(Icons.refresh, color: Colors.grey),
                    label: const Text('Reset', style: TextStyle(color: Colors.grey)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}