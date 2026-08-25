// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Regression test for a live-device bug (2026-08-25): a device whose
// magnetometer stream keeps delivering events with a null heading
// (seen on a real Xiaomi/MIUI phone) got stuck on an infinite
// CircularProgressIndicator forever — the compassStalled timeout never
// fired because the cubit treated "any event, even a null-heading
// one" as proof the compass was working.

import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/core/location/location_service.dart';
import 'package:noor/core/sensors/compass_service.dart';
import 'package:noor/core/sensors/tilt_service.dart';
import 'package:noor/features/qibla/logic/qibla_cubit/qibla_cubit.dart';
import 'package:noor/features/settings/data/app_settings.dart';
import 'package:noor/features/settings/data/settings_repository.dart';

TiltService _noTilt() => TiltService(eventsProvider: () => null);

class _FakeLocationService extends LocationService {
  const _FakeLocationService(this.result);
  final Coordinates? result;

  @override
  Future<Coordinates?> getCurrentCoordinates({
    Duration timeout = const Duration(seconds: 10),
    bool promptIfNeeded = true,
  }) async => result;

  @override
  Future<Coordinates?> autoFetchCoordinates({
    Duration timeout = const Duration(seconds: 10),
  }) async => result;
}

class _FakeSettingsRepository extends SettingsRepository {
  _FakeSettingsRepository(this._settings);
  final AppSettings _settings;

  @override
  Future<AppSettings> load() async => _settings;
}

void main() {
  test(
    'compassStalled fires when every event has a null heading, not just '
    'when no event ever arrives',
    () {
      fakeAsync((async) {
        final controller = StreamController<CompassEvent>();
        final cubit = QiblaCubit(
          locationService: const _FakeLocationService(
            Coordinates(latitude: 6.9271, longitude: 79.8612),
          ),
          settingsRepository: _FakeSettingsRepository(const AppSettings()),
          compassService: CompassService(eventsProvider: () => controller.stream),
          tiltService: _noTilt(),
        );

        unawaited(cubit.start());
        async.elapse(Duration.zero);

        // Simulate the real device: the stream is alive and keeps
        // delivering events, but every one has a null heading.
        controller.add(CompassEvent.fromList(null));
        async.elapse(const Duration(seconds: 1));
        controller.add(CompassEvent.fromList(null));
        async.elapse(const Duration(seconds: 6));

        expect(cubit.state.headingDegrees, isNull);
        expect(
          cubit.state.compassStalled,
          isTrue,
          reason:
              'null-heading events must not silently disarm the stall '
              'timer — the UI would be stuck on a spinner forever',
        );

        cubit.close();
        controller.close();
      });
    },
  );

  test('a genuine heading clears compassStalled even after it was set', () {
    fakeAsync((async) {
      final controller = StreamController<CompassEvent>();
      final cubit = QiblaCubit(
        locationService: const _FakeLocationService(
          Coordinates(latitude: 6.9271, longitude: 79.8612),
        ),
        settingsRepository: _FakeSettingsRepository(const AppSettings()),
        compassService: CompassService(eventsProvider: () => controller.stream),
        tiltService: _noTilt(),
      );

      unawaited(cubit.start());
      async.elapse(Duration.zero);
      async.elapse(const Duration(seconds: 6));
      expect(cubit.state.compassStalled, isTrue);

      controller.add(CompassEvent.fromList([90.0, 0.0, 5.0]));
      async.elapse(Duration.zero);

      expect(cubit.state.compassStalled, isFalse);
      expect(cubit.state.headingDegrees, isNotNull);

      cubit.close();
      controller.close();
    });
  });
}
