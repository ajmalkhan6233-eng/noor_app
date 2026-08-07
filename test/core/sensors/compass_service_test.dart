// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'dart:async';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/sensors/compass_reading.dart';
import 'package:noor/core/sensors/compass_service.dart';

CompassEvent _event({double? heading, double? accuracy}) =>
    CompassEvent.fromList([heading ?? 0, 0, accuracy ?? -1]);

void main() {
  group('CompassService.readings', () {
    test('reports unavailable when there is no event stream at all', () async {
      final service = CompassService(eventsProvider: () => null);
      final reading = await service.readings.first;
      expect(reading.accuracy, CompassAccuracy.unavailable);
      expect(reading.headingDegrees, isNull);
    });

    test('reports unavailable for an event with no heading', () async {
      final service = CompassService(
        eventsProvider: () => Stream.value(
          CompassEvent.fromList(null),
        ),
      );
      final reading = await service.readings.first;
      expect(reading.accuracy, CompassAccuracy.unavailable);
    });

    test('holds the last known heading through a transient null reading', () async {
      final controller = StreamController<CompassEvent>();
      final service = CompassService(eventsProvider: () => controller.stream);

      final readings = <CompassReading>[];
      final subscription = service.readings.listen(readings.add);

      controller.add(_event(heading: 120, accuracy: 5));
      // A magnetometer hiccup — flutter_compass emits these on real
      // devices during interference/recalibration, not "no compass".
      controller.add(CompassEvent.fromList(null));
      controller.add(_event(heading: 121, accuracy: 5));
      await Future<void>.delayed(Duration.zero);

      expect(readings[0].headingDegrees, closeTo(120, 1e-9));
      // Must NOT be null — that's what made the needle vanish/reappear
      // (flicker) on every transient hiccup. Held at the last value.
      expect(readings[1].headingDegrees, closeTo(120, 1e-9));
      expect(readings[1].accuracy, CompassAccuracy.uncalibrated);
      // Smoothing resumes normally once real readings continue.
      expect(readings[2].headingDegrees, isNotNull);

      await subscription.cancel();
      await controller.close();
    });

    test('classifies a null accuracy as uncalibrated', () async {
      final service = CompassService(
        eventsProvider: () => Stream.value(_event(heading: 90)),
      );
      final reading = await service.readings.first;
      expect(reading.accuracy, CompassAccuracy.uncalibrated);
      expect(reading.headingDegrees, closeTo(90, 1e-9));
    });

    test('classifies a large reported deviation as low', () async {
      final service = CompassService(
        eventsProvider: () => Stream.value(_event(heading: 90, accuracy: 40)),
      );
      final reading = await service.readings.first;
      expect(reading.accuracy, CompassAccuracy.low);
    });

    test('classifies a small reported deviation as good', () async {
      final service = CompassService(
        eventsProvider: () => Stream.value(_event(heading: 90, accuracy: 5)),
      );
      final reading = await service.readings.first;
      expect(reading.accuracy, CompassAccuracy.good);
    });

    test('smooths successive headings rather than jumping instantly', () async {
      final controller = StreamController<CompassEvent>();
      final service = CompassService(
        smoothingFactor: 0.5,
        eventsProvider: () => controller.stream,
      );

      final readings = <CompassReading>[];
      final subscription = service.readings.listen(readings.add);

      controller.add(_event(heading: 0, accuracy: 5));
      controller.add(_event(heading: 100, accuracy: 5));
      await Future<void>.delayed(Duration.zero);

      expect(readings[0].headingDegrees, closeTo(0, 1e-9));
      // Halfway (factor 0.5) from 0 toward 100 is 50 — not an instant
      // jump to the new raw reading.
      expect(readings[1].headingDegrees, closeTo(50, 1e-9));

      await subscription.cancel();
      await controller.close();
    });

    test('default smoothing factor damps noise more than a single reading', () async {
      final controller = StreamController<CompassEvent>();
      final service = CompassService(eventsProvider: () => controller.stream);
      expect(service.smoothingFactor, 0.06);

      final readings = <CompassReading>[];
      final subscription = service.readings.listen(readings.add);

      controller.add(_event(heading: 0, accuracy: 5));
      controller.add(_event(heading: 100, accuracy: 5));
      await Future<void>.delayed(Duration.zero);

      // Moves only 6% of the way toward a sudden 100-degree jump —
      // real magnetometer noise (a few degrees of jitter) is damped
      // to a fraction of a degree per event, not visible as a twitch.
      expect(readings[1].headingDegrees, closeTo(6, 1e-9));

      await subscription.cancel();
      await controller.close();
    });
  });
}
