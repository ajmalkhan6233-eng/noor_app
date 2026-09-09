import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/dhikr_item_model.dart';

class DhikrCounterState {
  final DhikrItemModel selectedItem;
  final int currentCount;
  final int totalSessionCount;
  final String currentPhase;

  const DhikrCounterState({
    required this.selectedItem,
    required this.currentCount,
    required this.totalSessionCount,
    required this.currentPhase,
  });

  DhikrCounterState copyWith({
    DhikrItemModel? selectedItem,
    int? currentCount,
    int? totalSessionCount,
    String? currentPhase,
  }) {
    return DhikrCounterState(
      selectedItem: selectedItem ?? this.selectedItem,
      currentCount: currentCount ?? this.currentCount,
      totalSessionCount: totalSessionCount ?? this.totalSessionCount,
      currentPhase: currentPhase ?? this.currentPhase,
    );
  }
}

class DhikrCounterCubit extends Cubit<DhikrCounterState> {
  DhikrCounterCubit()
      : super(const DhikrCounterState(
          selectedItem: DhikrItemModel.defaultPresets[0],
          currentCount: 0,
          totalSessionCount: 0,
          currentPhase: 'SubhanAllah',
        ));

  void selectItem(DhikrItemModel item) {
    emit(state.copyWith(
      selectedItem: item,
      currentCount: 0,
    ));
  }

  void increment() {
    final nextCount = state.currentCount + 1;
    final nextTotal = state.totalSessionCount + 1;

    if (nextCount % 33 == 0) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }

    emit(state.copyWith(
      currentCount: nextCount,
      totalSessionCount: nextTotal,
    ));
  }

  void decrement() {
    if (state.currentCount <= 0) return;
    HapticFeedback.selectionClick();
    emit(state.copyWith(
      currentCount: state.currentCount - 1,
      totalSessionCount: state.totalSessionCount > 0 ? state.totalSessionCount - 1 : 0,
    ));
  }

  void reset() {
    HapticFeedback.vibrate();
    emit(state.copyWith(currentCount: 0));
  }
}