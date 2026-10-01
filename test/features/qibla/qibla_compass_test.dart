// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Angle maths, the 0/360 wrap, and the no-sensor / no-location paths of
// the rebuilt Qibla screen.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/location/location_service.dart';
import 'package:noor/core/sensors/compass_reading.dart';
import 'package:noor/core/sensors/compass_service.dart';
import 'package:noor/core/sensors/magnetic_declination.dart';
import 'package:noor/features/qibla/data/qibla_calculator.dart';
import 'package:noor/features/qibla/logic/heading_filter.dart';
import 'package:noor/features/qibla/logic/qibla_compass_cubit.dart';
import 'package:noor/features/qibla/logic/qibla_compass_state.dart';
import 'package:noor/features/qibla/presentation/qibla_compass_screen.dart';
import 'package:noor/features/qibla/presentation/widgets/qibla_dial.dart';

import '../../helpers/silent_haptics.dart';
import '../../helpers/theme_harness.dart';

class _Location extends LocationService {
  const _Location(this.fix);
  final Coordinates? fix;

  @override
  Future<Coordinates?> autoFetchCoordinates({Duration timeout = const Duration(seconds: 10)}) async => fix;

  @override
  Future<Coordinates?> getCurrentCoordinates({
    Duration timeout = const Duration(seconds: 10),
    bool promptIfNeeded = true,
  }) async => fix;
}

class _Compass extends CompassService {
  _Compass(this.stream);
  final Stream<CompassReading> stream;

  @override
  Stream<CompassReading> get readings => stream;
}

const _london = Coordinates(latitude: 51.5074, longitude: -0.1278);

CompassReading _good(double heading) =>
    CompassReading(headingDegrees: heading, accuracy: CompassAccuracy.good);

void main() {
  group('bearing and distance maths (unchanged)', () {
    test('London to the Kaaba is about 119 degrees and 4,800 km', () {
      final bearing = QiblaCalculator.bearingToKaaba(_london.latitude, _london.longitude);
      final km = QiblaCalculator.distanceToKaabaKm(_london.latitude, _london.longitude);
      expect(bearing, closeTo(119, 1));
      expect(km, inInclusiveRange(4700, 4900));
    });
  });

  group('HeadingFilter', () {
    test('first reading passes through, normalised', () {
      expect(HeadingFilter().update(-10), closeTo(350, 1e-9));
      expect(HeadingFilter().update(725), closeTo(5, 1e-9));
    });

    test('crossing north moves the short way (359 -> 1 is 2 degrees, not 358)', () {
      final filter = HeadingFilter(factor: 0.5, deadbandDegrees: 0);
      filter.update(359);
      final next = filter.update(1);
      expect(next, closeTo(0, 1e-9));
    });

    test('crossing north the other way (1 -> 359)', () {
      final filter = HeadingFilter(factor: 0.5, deadbandDegrees: 0);
      filter.update(1);
      expect(filter.update(359), closeTo(0, 1e-9));
    });

    test('converges to a steady reading and ignores sub-degree jitter', () {
      final filter = HeadingFilter();
      var value = filter.update(100);
      for (var i = 0; i < 60; i++) {
        value = filter.update(200);
      }
      expect(value, closeTo(200, 1.5));
      final steady = filter.update(200.1);
      expect((steady - value).abs(), lessThan(0.2));
    });
  });

  group('QiblaCompassState', () {
    test('needle angle is bearing minus heading, wrapped into [0, 360)', () {
      expect(const QiblaCompassState(bearing: 10, heading: 350).needleAngle, closeTo(20, 1e-9));
      expect(const QiblaCompassState(bearing: 350, heading: 10).needleAngle, closeTo(340, 1e-9));
      expect(const QiblaCompassState(bearing: 119, heading: 119).needleAngle, closeTo(0, 1e-9));
    });

    test('aligned works across the 0/360 wrap and within 3 degrees only', () {
      expect(const QiblaCompassState(bearing: 359, heading: 1).aligned, isTrue);
      expect(const QiblaCompassState(bearing: 1, heading: 359).aligned, isTrue);
      expect(const QiblaCompassState(bearing: 90, heading: 94).aligned, isFalse);
    });

    test('without a compass the needle is the bearing from north and never aligned', () {
      const state = QiblaCompassState(bearing: 119, sensorUnavailable: true);
      expect(state.needleAngle, 119);
      expect(state.aligned, isFalse);
      expect(state.hasHeading, isFalse);
    });
  });

  group('QiblaCompassCubit', () {
    test('no compass sensor: static arrow data, no crash', () async {
      final cubit = QiblaCompassCubit(
        locationService: const _Location(_london),
        compassService: _Compass(Stream.value(const CompassReading(headingDegrees: null, accuracy: CompassAccuracy.unavailable))),
        hapticService: SilentHaptics(),
      );
      await cubit.start();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.sensorUnavailable, isTrue);
      expect(cubit.state.bearing, closeTo(119, 1));
      expect(cubit.state.heading, isNull);
      expect(cubit.state.approximateLocation, isFalse);
      await cubit.close();
    });

    test('a sensor that never answers is treated as missing after the timeout', () async {
      final silent = StreamController<CompassReading>();
      final cubit = QiblaCompassCubit(
        locationService: const _Location(_london),
        compassService: _Compass(silent.stream),
        hapticService: SilentHaptics(),
        noSensorTimeout: const Duration(milliseconds: 20),
      );
      await cubit.start();
      await Future<void>.delayed(const Duration(milliseconds: 60));

      expect(cubit.state.sensorUnavailable, isTrue);
      await cubit.close();
      await silent.close();
    });

    test('a failing sensor stream degrades to the static arrow', () async {
      final broken = StreamController<CompassReading>();
      final cubit = QiblaCompassCubit(
        locationService: const _Location(_london),
        compassService: _Compass(broken.stream),
        hapticService: SilentHaptics(),
      );
      await cubit.start();
      broken.addError(StateError('sensor channel failed'));
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.sensorUnavailable, isTrue);
      await cubit.close();
      await broken.close();
    });

    test('unknown location uses the Colombo default and says so, never an error', () async {
      final cubit = QiblaCompassCubit(
        locationService: const _Location(null),
        compassService: _Compass(const Stream.empty()),
        hapticService: SilentHaptics(),
      );
      await cubit.start();

      expect(cubit.state.approximateLocation, isTrue);
      expect(cubit.state.bearing, isNotNull);
      expect(cubit.state.loading, isFalse);
      expect(cubit.state.bearing, closeTo(QiblaCalculator.bearingToKaaba(6.9271, 79.8612), 1e-9));
      await cubit.close();
    });

    test('heading is magnetic + declination, wrap-safe, and aligning fires one tap', () async {
      final readings = StreamController<CompassReading>();
      final haptics = SilentHaptics();
      final cubit = QiblaCompassCubit(
        locationService: const _Location(_london),
        compassService: _Compass(readings.stream),
        hapticService: haptics,
        filter: HeadingFilter(factor: 1, deadbandDegrees: 0),
      );
      await cubit.start();
      final declination = MagneticDeclination.estimate(_london.latitude, _london.longitude);
      final bearing = cubit.state.bearing!;

      // Point the phone so that magnetic + declination equals the bearing.
      readings.add(_good(bearing - declination));
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.heading, closeTo(bearing, 1e-6));
      expect(cubit.state.aligned, isTrue);
      expect(haptics.taps, 1);

      // Staying aligned does not tap again; leaving and returning does.
      readings.add(_good(bearing - declination + 0.5));
      await Future<void>.delayed(Duration.zero);
      expect(haptics.taps, 1);
      readings.add(_good(bearing - declination + 90));
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.aligned, isFalse);
      readings.add(_good(bearing - declination));
      await Future<void>.delayed(Duration.zero);
      expect(haptics.taps, 2);

      await cubit.close();
      await readings.close();
    });
  });

  group('QiblaDial', () {
    testWidgets('ring turns opposite to the phone, needle points at the Qibla', (tester) async {
      await tester.pumpWidget(
        themedApp(
          const Scaffold(body: Center(child: QiblaDial(heading: 90, needleAngle: 30, aligned: false))),
          allThemes['Nebula']!(),
        ),
      );
      final angles = tester
          .widgetList<Transform>(find.descendant(of: find.byType(QiblaDial), matching: find.byType(Transform)))
          .map((t) => math.atan2(t.transform.storage[1], t.transform.storage[0]))
          .toList();
      expect(angles.any((a) => (a - (-math.pi / 2)).abs() < 1e-6), isTrue, reason: 'ring at -heading');
      expect(angles.any((a) => (a - math.pi / 6).abs() < 1e-6), isTrue, reason: 'needle at 30 degrees');
    });
  });

  group('QiblaCompassScreen in every theme', () {
    final states = <String, QiblaCompassState>{
      'with compass': const QiblaCompassState(
        loading: false,
        bearing: 119,
        distanceKm: 4800,
        heading: 80,
        accuracy: CompassAccuracy.low,
      ),
      'no compass': const QiblaCompassState(loading: false, bearing: 292, distanceKm: 2900, sensorUnavailable: true, approximateLocation: true),
    };
    for (final theme in allThemes.entries) {
      for (final state in states.entries) {
        for (final scale in [1.0, 2.0]) {
          testWidgets('${state.key}, ${theme.key}, ${(scale * 100).round()}% text', (tester) async {
            tester.view.physicalSize = const Size(360 * 3, 740 * 3);
            tester.view.devicePixelRatio = 3;
            addTearDown(tester.view.reset);
            final cubit = _FixedCubit(state.value);
            addTearDown(cubit.close);

            await tester.pumpWidget(themedApp(QiblaCompassScreen(cubit: cubit), theme.value(), textScale: scale));
            await tester.pump();

            expect(tester.takeException(), isNull);
            expect(find.byType(QiblaDial), findsOneWidget);
            expect(find.textContaining('°'), findsWidgets);
          });
        }
      }
    }
  });
}

class _FixedCubit extends QiblaCompassCubit {
  _FixedCubit(QiblaCompassState fixed) : super(hapticService: SilentHaptics()) {
    emit(fixed);
  }
}
