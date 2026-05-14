import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/health_service.dart';

const String _kPermissionKey = 'health_permission_granted';

enum HealthPermissionStatus { unknown, granted, denied }

class HealthProvider extends ChangeNotifier {
  TodayHealthSummary? _summary;
  List<HealthSample> _heartRateSamples = <HealthSample>[];
  HealthPermissionStatus _permissionStatus = HealthPermissionStatus.unknown;
  bool _isLoading = false;
  String? _error;

  // Active calorie goal (kcal) — user can customize
  double _calorieGoal = 500;

  TodayHealthSummary? get summary => _summary;
  List<HealthSample> get heartRateSamples => _heartRateSamples;
  HealthPermissionStatus get permissionStatus => _permissionStatus;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get calorieGoal => _calorieGoal;

  double get calorieProgress => _summary != null
      ? (_summary!.activeCalories / _calorieGoal).clamp(0.0, 1.0)
      : 0;

  void setCalorieGoal(double goal) {
    _calorieGoal = goal;
    notifyListeners();
  }

  Future<void> initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool previouslyGranted = prefs.getBool(_kPermissionKey) ?? false;

    if (previouslyGranted) {
      _permissionStatus = HealthPermissionStatus.granted;
      notifyListeners();
      await _fetchData();
    }
  }

  Future<bool> requestPermissions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final bool granted = await HealthService.instance.requestPermissions();
    _permissionStatus = granted
        ? HealthPermissionStatus.granted
        : HealthPermissionStatus.denied;

    if (granted) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kPermissionKey, true);
      await _fetchData();
    } else {
      _isLoading = false;
    }
    notifyListeners();
    return granted;
  }

  Future<void> refresh() async {
    if (_permissionStatus != HealthPermissionStatus.granted) {
      return;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    await _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      _summary = await HealthService.instance.getTodaySummary();
      _heartRateSamples =
          await HealthService.instance.getHeartRateSamples(hours: 8);
    } on Exception catch (e) {
      _error = 'Error al leer datos de salud: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
