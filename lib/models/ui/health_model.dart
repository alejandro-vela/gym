import '../../i18n/strings/app_strings.dart';
import '../../i18n/strings/common_strings.dart';
import '../../i18n/strings/health_strings.dart';
import '../../providers/health_provider.dart';
import '../../services/health_service.dart';

class HealthModel {
  const HealthModel({
    required this.strings,
    required this.images,
    required this.common,
    required this.permissionStatus,
    required this.summary,
    required this.heartRateSamples,
    required this.isLoading,
    required this.error,
    required this.calorieGoal,
    required this.calorieProgress,
    required this.syncedTimeLabel,
  });

  final HealthStrings strings;
  final ImagePaths images;
  final CommonStrings common;

  final HealthPermissionStatus permissionStatus;
  final TodayHealthSummary? summary;
  final List<HealthSample> heartRateSamples;
  final bool isLoading;
  final String? error;
  final double calorieGoal;
  final double calorieProgress;
  final String syncedTimeLabel;
}
