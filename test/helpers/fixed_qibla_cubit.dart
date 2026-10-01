// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:noor/features/qibla/logic/qibla_compass_cubit.dart';
import 'package:noor/features/qibla/logic/qibla_compass_state.dart';

import 'silent_haptics.dart';

/// A Qibla cubit frozen on one state (no sensors, no location).
class FixedQiblaCubit extends QiblaCompassCubit {
  FixedQiblaCubit(QiblaCompassState fixed) : super(hapticService: SilentHaptics()) {
    emit(fixed);
  }
}
