// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Presentation only dispatches `start()`/`setManualLocation()` and
// reads state — location, compass, tilt, and qibla math all stay out
// of the widget tree.

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/location/location_service.dart';
import '../../../../core/sensors/compass_reading.dart';
import '../../../../core/sensors/compass_service.dart';
import '../../../../core/sensors/magnetic_declination.dart';
import '../../../../core/sensors/tilt_service.dart';
import '../../../../core/utils/angle_math.dart';
import '../../../prayer_times/data/sri_lanka_district.dart';
import '../../../settings/data/settings_repository.dart';
import '../../data/qibla_calculator.dart';
import 'qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit({
    LocationService? locationService,
    CompassService? compassService,
    TiltService? tiltService,
    SettingsRepository? settingsRepository,
  }) : _locationService = locationService ?? const LocationService(),
       _compassService = compassService ?? CompassService(),
       _tiltService = tiltService ?? TiltService(),
       _settingsRepository = settingsRepository ?? SettingsRepository(),
       super(const QiblaState());

  final LocationService _locationService;
  final CompassService _compassService;
  final TiltService _tiltService;
  final SettingsRepository _settingsRepository;
  StreamSubscription<CompassReading>? _compassSubscription;
  StreamSubscription<TiltReading>? _tiltSubscription;
  Timer? _compassStallTimer;

  /// If flutter_compass genuinely never delivers a first event (seen
  /// on a real device: the needle stayed on an infinite loading spinner
  /// indefinitely, reported as "the app is completely locked") there's
  /// no other signal anything is wrong — [CompassAccuracy.unavailable]
  /// only covers "no magnetometer at all", not "has one, but the
  /// stream just isn't producing". A plain timeout is the only way to
  /// tell "still loading" from "never going to arrive" apart.
  static const _compassStallTimeout = Duration(seconds: 5);

  // Hysteresis for the good/not-good accuracy boundary specifically —
  // magnetometer accuracy readings genuinely oscillate reading to
  // reading on a real device (indoors, near other electronics), and
  // that boundary drives two visible UI changes at once: the needle's
  // dim/undim and whether CalibrationPrompt is mounted at all (a
  // whole banner popping in and out, not just an alpha fade). Reported
  // repeatedly as "the compass is blinking" even after the needle's
  // own alpha was smoothed (see QiblaNeedle) — that fix only covered
  // the needle's opacity, not this banner mount/unmount, which is the
  // more jarring of the two. Requiring 3 consecutive readings on the
  // new side before actually flipping means a single noisy sample
  // can't do it alone.
  static const _hysteresisStreak = 3;
  bool _uiGood = false;
  int _streakCount = 0;
  CompassAccuracy _lastDisplayed = CompassAccuracy.unavailable;

  /// Only the good/not-good boundary is debounced — CalibrationPrompt
  /// and the needle's dim both branch on that boundary alone, not on
  /// which specific non-good classification it is. [unavailable]
  /// passes straight through: that's a device-capability fact, not
  /// sensor noise, so there's nothing to debounce.
  CompassAccuracy _debouncedDisplayAccuracy(CompassAccuracy raw) {
    if (raw == CompassAccuracy.unavailable) {
      _uiGood = false;
      _streakCount = 0;
      _lastDisplayed = CompassAccuracy.unavailable;
      return _lastDisplayed;
    }
    final rawGood = raw == CompassAccuracy.good;
    if (rawGood == _uiGood) {
      _streakCount = 0;
      _lastDisplayed = raw;
      return _lastDisplayed;
    }
    _streakCount++;
    if (_streakCount >= _hysteresisStreak) {
      _uiGood = rawGood;
      _streakCount = 0;
      _lastDisplayed = raw;
    }
    return _lastDisplayed;
  }

  /// Resolves a location automatically — a cached or bounded GPS fix
  /// first, then a previously chosen Sri Lankan district — so this
  /// always settles within a few seconds rather than hanging on GPS
  /// indefinitely. Only if neither is available does it surface an
  /// error, for the district-picker fallback UI to resolve.
  Future<void> start() async {
    emit(state.copyWith(isResolvingLocation: true, locationError: null));

    final coordinates = await _locationService.autoFetchCoordinates();
    if (coordinates != null) {
      _applyLocation(coordinates.latitude, coordinates.longitude);
      return;
    }

    final appSettings = await _settingsRepository.load();
    final district = findSriLankaDistrict(appSettings.selectedDistrict);
    if (district != null) {
      _applyLocation(district.latitude, district.longitude);
      return;
    }

    emit(
      state.copyWith(
        isResolvingLocation: false,
        locationError:
            'Enable location, or choose a district below, to see the '
            'qibla direction.',
      ),
    );
  }

  /// Lets the district-picker fallback set a location directly when
  /// GPS was unavailable and no district was already known.
  void setManualLocation(double latitude, double longitude) {
    _applyLocation(latitude, longitude);
  }

  void _applyLocation(double latitude, double longitude) {
    final declination = MagneticDeclination.estimate(latitude, longitude);
    emit(
      state.copyWith(
        latitude: latitude,
        longitude: longitude,
        bearingDegrees: QiblaCalculator.bearingToKaaba(latitude, longitude),
        distanceKm: QiblaCalculator.distanceToKaabaKm(latitude, longitude),
        isResolvingLocation: false,
        locationError: null,
      ),
    );
    _listen(declination);
  }

  void _listen(double declination) {
    _compassSubscription?.cancel();
    _compassStallTimer?.cancel();
    var firstReadingSeen = false;
    _compassStallTimer = Timer(_compassStallTimeout, () {
      if (!firstReadingSeen && !isClosed) {
        emit(state.copyWith(compassStalled: true));
      }
    });
    _compassSubscription = _compassService.readings.listen((reading) {
      if (!firstReadingSeen) {
        firstReadingSeen = true;
        _compassStallTimer?.cancel();
      }
      final trueHeading = reading.headingDegrees == null
          ? null
          : AngleMath.normalise(reading.headingDegrees! + declination);
      emit(
        state.copyWith(
          headingDegrees: trueHeading,
          compassAccuracy: reading.accuracy,
          displayAccuracy: _debouncedDisplayAccuracy(reading.accuracy),
          compassStalled: false,
        ),
      );
    });

    _tiltSubscription?.cancel();
    _tiltSubscription = _tiltService.readings.listen((reading) {
      emit(state.copyWith(tiltX: reading.x, tiltY: reading.y));
    });
  }

  @override
  Future<void> close() {
    _compassSubscription?.cancel();
    _tiltSubscription?.cancel();
    _compassStallTimer?.cancel();
    return super.close();
  }
}
