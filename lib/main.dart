import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';

void main() {
  runApp(const NoorApp());
}

class NoorApp extends StatelessWidget {
  const NoorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0E14),
        fontFamily: 'Roboto',
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PrayerTimes _prayerTimes;
  late Timer _timer;
  Duration _timeUntilNext = Duration.zero;
  String _nextPrayerName = '';

  // One-Tap Prayer Completion Trackers
  final Map<String, bool> _completedPrayers = {
    'Fajr': false,
    'Dhuhr': false,
    'Asr': false,
    'Maghrib': false,
    'Isha': false,
  };

  @override
  void initState() {
    super.initState();
    _initPrayerTimes();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCountdown());
  }

  void _initPrayerTimes() {
    // Colombo, Sri Lanka Coordinates (Default)
    final coordinates = Coordinates(6.9271, 79.8612);
    
    // ACJU / Shafi Calculation Method setup
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;

    _prayerTimes = PrayerTimes(
      coordinates,
      DateComponents.from(DateTime.now()),
      params,
    );
    _updateCountdown();
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final nextPrayer = _prayerTimes.nextPrayer();
    final nextTime = _prayerTimes.timeForPrayer(nextPrayer);

    if (nextTime != null) {
      setState(() {
        _timeUntilNext = nextTime.difference(now);
        _nextPrayerName = _getPrayerName(nextPrayer);
      });
    } else {
      // Past Isha: calculate remaining time until tomorrow's Fajr
      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowTimes = PrayerTimes(
        Coordinates(6.9271, 79.8612),
        DateComponents.from(tomorrow),
        CalculationMethod.muslim_world_league.getParameters()..madhab = Madhab.shafi,
      );
      setState(() {
        _timeUntilNext = tomorrowTimes.fajr.difference(now);
        _nextPrayerName = 'Fajr';
      });
    }
  }

  String _getPrayerName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr: return 'Fajr';
      case Prayer.sunrise: return 'Sunrise';
      case Prayer.dhuhr: return 'Dhuhr';
      case Prayer.asr: return 'Asr';
      case Prayer.maghrib: return 'Maghrib';
      case Prayer.isha: return 'Isha';
      default: return 'Fajr';
    }
  }

  String _formatDuration(Duration duration) {
    String hours = duration.inHours.remainder(24).toString().padLeft(2, '0');
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B0E14),
              Color(0xFF161B22),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'NOOR',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800, // Fixed here
                        letterSpacing: 3.0,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Sri Lanka (ACJU)',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),

                // Live Countdown Hero Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B22),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withOpacity(0.05),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'NEXT PRAYER: ${_nextPrayerName.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: Color(0xFF8B949E),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _formatDuration(_timeUntilNext),
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF0F6FC),
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Remaining until Adhan',
                        style: TextStyle(fontSize: 12, color: Color(0xFF8B949E)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Today\'s Prayers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF0F6FC),
                  ),
                ),
                const SizedBox(height: 12),

                // Prayer Check-list
                Expanded(
                  child: ListView(
                    children: _completedPrayers.keys.map((prayer) {
                      final isDone = _completedPrayers[prayer]!;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161B22),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          title: Text(
                            prayer,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDone ? Colors.white54 : Colors.white,
                              decoration: isDone ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isDone ? Icons.check_circle : Icons.circle_outlined,
                              color: isDone ? const Color(0xFF00E676) : const Color(0xFF8B949E),
                              size: 28,
                            ),
                            onPressed: () {
                              setState(() {
                                _completedPrayers[prayer] = !isDone;
                              });
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}