import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

/// Wraps a single HealthKit data point with a friendly type
class HealthSample {
  HealthSample({
    required this.type,
    required this.value,
    required this.unit,
    required this.dateFrom,
    required this.dateTo,
  });
  final HealthDataType type;
  final double value;
  final String unit;
  final DateTime dateFrom;
  final DateTime dateTo;
}

/// Summary of today's health data
class TodayHealthSummary {
  TodayHealthSummary({
    required this.activeCalories,
    required this.basalCalories,
    required this.totalCalories,
    required this.steps,
    required this.distanceKm,
    required this.exerciseMinutes,
    this.latestHeartRate,
    this.avgHeartRate,
    this.maxHeartRate,
    this.sleepHours,
    required this.workouts,
  });

  factory TodayHealthSummary.empty() => TodayHealthSummary(
        activeCalories: 0,
        basalCalories: 0,
        totalCalories: 0,
        steps: 0,
        distanceKm: 0,
        exerciseMinutes: 0,
        workouts: <HealthWorkout>[],
      );
  final double activeCalories; // kcal
  final double basalCalories; // kcal
  final double totalCalories; // kcal
  final int steps;
  final double distanceKm;
  final int exerciseMinutes;
  final double? latestHeartRate; // bpm
  final double? avgHeartRate; // bpm
  final double? maxHeartRate; // bpm
  final double? sleepHours; // last night
  final List<HealthWorkout> workouts;
}

class HealthWorkout {
  HealthWorkout({
    required this.type,
    required this.durationMinutes,
    required this.calories,
    required this.date,
  });
  final String type;
  final int durationMinutes;
  final double calories;
  final DateTime date;
}

class HealthService {
  HealthService._internal();
  static final HealthService instance = HealthService._internal();

  final Health _health = Health();
  final bool _authorized = false;

  // Types we need from HealthKit
  static const List<HealthDataType> _readTypes = <HealthDataType>[
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.BASAL_ENERGY_BURNED,
    HealthDataType.HEART_RATE,
    HealthDataType.STEPS,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.EXERCISE_TIME,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.WORKOUT,
  ];

  /// Request HealthKit permissions. Returns true if granted.
  Future<bool> requestPermissions() async {
    try {
      await _health.configure();
      return _health.requestAuthorization(
        _readTypes,
        permissions: List<HealthDataAccess>.filled(
          _readTypes.length,
          HealthDataAccess.READ,
        ),
      );
    } on Exception catch (e) {
      debugPrint('HealthKit permission error: $e');
      return false;
    }
  }

  Future<bool> get isAuthorized async {
    if (_authorized) {
      return true;
    }
    try {
      await _health.configure();
      return await _health.hasPermissions(_readTypes) ?? false;
    } on Exception catch (_) {
      return false;
    }
  }

  /// Fetch all today's health data
  Future<TodayHealthSummary> getTodaySummary() async {
    final DateTime now = DateTime.now();
    final DateTime startOfDay = DateTime(now.year, now.month, now.day);

    try {
      // ── Active Calories ─────────────────────────────────────
      double activeCalories = 0;
      try {
        final List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
          startTime: startOfDay,
          endTime: now,
          types: <HealthDataType>[HealthDataType.ACTIVE_ENERGY_BURNED],
        );
        activeCalories = data.fold(
          0.0,
          (double sum, HealthDataPoint d) =>
              sum + (d.value as NumericHealthValue).numericValue.toDouble(),
        );
      } on Exception catch (_) {}

      // ── Basal Calories ──────────────────────────────────────
      double basalCalories = 0;
      try {
        final List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
          startTime: startOfDay,
          endTime: now,
          types: <HealthDataType>[HealthDataType.BASAL_ENERGY_BURNED],
        );
        basalCalories = data.fold(
          0.0,
          (double sum, HealthDataPoint d) =>
              sum + (d.value as NumericHealthValue).numericValue.toDouble(),
        );
      } on Exception catch (_) {}

      // ── Steps ───────────────────────────────────────────────
      int steps = 0;
      try {
        steps = await _health.getTotalStepsInInterval(startOfDay, now) ?? 0;
      } on Exception catch (_) {}

      // ── Distance ────────────────────────────────────────────
      double distanceM = 0;
      try {
        final List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
          startTime: startOfDay,
          endTime: now,
          types: <HealthDataType>[HealthDataType.DISTANCE_WALKING_RUNNING],
        );
        distanceM = data.fold(
          0.0,
          (double sum, HealthDataPoint d) =>
              sum + (d.value as NumericHealthValue).numericValue.toDouble(),
        );
      } on Exception catch (_) {}

      // ── Exercise Minutes ────────────────────────────────────
      int exerciseMinutes = 0;
      try {
        final List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
          startTime: startOfDay,
          endTime: now,
          types: <HealthDataType>[HealthDataType.EXERCISE_TIME],
        );
        exerciseMinutes = data
            .fold(
              0.0,
              (double sum, HealthDataPoint d) =>
                  sum + (d.value as NumericHealthValue).numericValue.toDouble(),
            )
            .round();
      } on Exception catch (_) {}

      // ── Heart Rate ──────────────────────────────────────────
      double? latestHR;
      double? avgHR;
      double? maxHR;
      try {
        final List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
          startTime: startOfDay,
          endTime: now,
          types: <HealthDataType>[HealthDataType.HEART_RATE],
        );
        if (data.isNotEmpty) {
          final List<double> values = data
              .map(
                (HealthDataPoint d) =>
                    (d.value as NumericHealthValue).numericValue.toDouble(),
              )
              .toList();
          latestHR = values.last;
          avgHR = values.reduce((double a, double b) => a + b) / values.length;
          maxHR = values.reduce((double a, double b) => a > b ? a : b);
        }
      } on Exception catch (_) {}

      // ── Sleep (last night: yesterday 8pm → today 10am) ──────
      double? sleepHours;
      try {
        final DateTime sleepEnd = DateTime(now.year, now.month, now.day, 10);
        final DateTime sleepStart =
            sleepEnd.subtract(const Duration(hours: 14));
        final List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
          startTime: sleepStart,
          endTime: sleepEnd,
          types: <HealthDataType>[HealthDataType.SLEEP_ASLEEP],
        );
        if (data.isNotEmpty) {
          final double totalMinutes = data.fold(
            0.0,
            (double sum, HealthDataPoint d) =>
                sum + d.dateTo.difference(d.dateFrom).inMinutes.toDouble(),
          );
          sleepHours = totalMinutes / 60;
        }
      } on Exception catch (_) {}

      // ── Workouts (last 7 days) ───────────────────────────────
      final List<HealthWorkout> workouts = <HealthWorkout>[];
      try {
        final DateTime weekAgo = now.subtract(const Duration(days: 7));
        final List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
          startTime: weekAgo,
          endTime: now,
          types: <HealthDataType>[HealthDataType.WORKOUT],
        );
        for (final HealthDataPoint d in data) {
          final WorkoutHealthValue w = d.value as WorkoutHealthValue;
          workouts.add(
            HealthWorkout(
              type: _workoutTypeLabel(w.workoutActivityType),
              durationMinutes: d.dateTo.difference(d.dateFrom).inMinutes,
              calories: w.totalEnergyBurned?.toDouble() ?? 0,
              date: d.dateFrom,
            ),
          );
        }
        workouts.sort(
          (HealthWorkout a, HealthWorkout b) => b.date.compareTo(a.date),
        );
      } on Exception catch (_) {}

      return TodayHealthSummary(
        activeCalories: activeCalories,
        basalCalories: basalCalories,
        totalCalories: activeCalories + basalCalories,
        steps: steps,
        distanceKm: distanceM / 1000,
        exerciseMinutes: exerciseMinutes,
        latestHeartRate: latestHR,
        avgHeartRate: avgHR,
        maxHeartRate: maxHR,
        sleepHours: sleepHours,
        workouts: workouts,
      );
    } on Exception catch (e) {
      debugPrint('HealthKit fetch error: $e');
      return TodayHealthSummary.empty();
    }
  }

  /// Fetch heart rate data points for chart (last N hours)
  Future<List<HealthSample>> getHeartRateSamples({int hours = 6}) async {
    final DateTime now = DateTime.now();
    final DateTime start = now.subtract(Duration(hours: hours));
    try {
      final List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        startTime: start,
        endTime: now,
        types: <HealthDataType>[HealthDataType.HEART_RATE],
      );
      return data
          .map(
            (HealthDataPoint d) => HealthSample(
              type: HealthDataType.HEART_RATE,
              value: (d.value as NumericHealthValue).numericValue.toDouble(),
              unit: 'bpm',
              dateFrom: d.dateFrom,
              dateTo: d.dateTo,
            ),
          )
          .toList();
    } on Exception catch (_) {
      return <HealthSample>[];
    }
  }

  String _workoutTypeLabel(HealthWorkoutActivityType type) {
    switch (type) {
      case HealthWorkoutActivityType.TRADITIONAL_STRENGTH_TRAINING:
        return 'Fuerza';
      case HealthWorkoutActivityType.FUNCTIONAL_STRENGTH_TRAINING:
        return 'Funcional';
      case HealthWorkoutActivityType.RUNNING:
        return 'Correr';
      case HealthWorkoutActivityType.BIKING:
        return 'Ciclismo';
      case HealthWorkoutActivityType.WALKING:
        return 'Caminar';
      case HealthWorkoutActivityType.SWIMMING:
        return 'Natación';
      case HealthWorkoutActivityType.YOGA:
        return 'Yoga';
      case HealthWorkoutActivityType.HIGH_INTENSITY_INTERVAL_TRAINING:
        return 'HIIT';
      case HealthWorkoutActivityType.ELLIPTICAL:
        return 'Elíptica';
      case HealthWorkoutActivityType.ROWING:
        return 'Remo';
      case HealthWorkoutActivityType.STAIR_CLIMBING:
        return 'Escaleras';
      case _:
        return 'Ejercicio';
    }
  }
}
