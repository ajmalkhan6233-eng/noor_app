// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of qibla_cubit.dart to stay under the 150-line limit —
// wires the compass/tilt sensor streams to state updates. Kept as a
// plain function (not a class) since it only ever needs to run once
// per _listen() call and closes over QiblaCubit's own state/emit.
//
// Compass null-heading handling: a device whose magnetometer stream
// keeps delivering events with a null heading (seen live: MIUI/Xiaomi
// hardware that never resolves a fused heading) used to count as
// "first reading seen" on the very first null event, permanently
// silencing the stall timer while the needle stayed stuck on an
// infinite spinner forever. Only a reading that actually carries a
// heading disarms the stall timer now.
//
// A null heading after a real one has already arrived is treated as a
// transient glitch, not a loss of the compass — live-reproduced and
// root-caused 2026-08-26: this device's magnetometer stream
// intermittently emits null-heading events mid-stream (not just
// before the first fix), and QiblaState.copyWith's headingDegrees
// param has no `?? this.headingDegrees` fallback (deliberate
// elsewhere, since null is meaningful there) — so passing the raw
// value straight through wiped a perfectly good heading back to null
// on every such event, which made QiblaCompassArea swap the entire
// compass out for a spinner (previously misdiagnosed as a GPU/Skia
// bug). Holding the last known heading through a transient null fixes
// it at the source.
//
// Stream errors (2026-08-29): flutter_compass/sensors_plus can emit a
// genuine stream error — not just a null reading — when the platform
// channel itself fails to set up a sensor, e.g. on a cloud emulator
// (Appetize and similar) with no simulated magnetometer/accelerometer.
// main.dart has no global zone guard, so an unhandled stream error
// here was a real crash risk. Both subscriptions now degrade the same
// way a missing sensor already does, instead of throwing.

import 'dart:async';

import '../../../../core/sensors/compass_reading.dart';
import '../../../../core/sensors/compass_service.dart';
import '../../../../core/sensors/tilt_service.dart';
import '../../../../core/utils/angle_math.dart';
import 'qibla_accuracy_debouncer.dart';
import 'qibla_state.dart';

typedef QiblaStateGetter = QiblaState Function();
typedef QiblaStateEmitter = void Function(QiblaState state);

class QiblaSensorSubscriptions {
  const QiblaSensorSubscriptions(this.compass, this.tilt);
  final StreamSubscription<CompassReading> compass;
  final StreamSubscription<TiltReading> tilt;

  void cancel() {
    compass.cancel();
    tilt.cancel();
  }
}

QiblaSensorSubscriptions bindQiblaSensors({
  required CompassService compassService,
  required TiltService tiltService,
  required QiblaAccuracyDebouncer debouncer,
  required double declination,
  required QiblaStateGetter state,
  required QiblaStateEmitter emit,
  required void Function() onFirstCompassReading,
  required void Function() onCompassError,
}) {
  var firstReadingSeen = false;
  final compassSub = compassService.readings.listen((reading) {
    if (!firstReadingSeen && reading.headingDegrees != null) {
      firstReadingSeen = true;
      onFirstCompassReading();
    }
    final trueHeading = reading.headingDegrees == null
        ? null
        : AngleMath.normalise(reading.headingDegrees! + declination);
    emit(
      state().copyWith(
        headingDegrees: trueHeading ?? state().headingDegrees,
        compassAccuracy: reading.accuracy,
        displayAccuracy: debouncer(reading.accuracy),
        compassStalled: trueHeading == null ? state().compassStalled : false,
      ),
    );
  }, onError: (Object _, StackTrace __) => onCompassError());

  final tiltSub = tiltService.readings.listen((reading) {
    emit(state().copyWith(tiltX: reading.x, tiltY: reading.y));
  }, onError: (Object _, StackTrace __) => emit(state().copyWith(tiltX: 0, tiltY: 0)));

  return QiblaSensorSubscriptions(compassSub, tiltSub);
}
