import '../../i18n/strings/app_strings.dart';
import '../../i18n/strings/common_strings.dart';
import '../../i18n/strings/progress_strings.dart';
import '../body_measurement.dart';
import '../routine_exercise.dart';

class ProgressModel {
  const ProgressModel({
    required this.strings,
    required this.images,
    required this.common,
    required this.measurements,
    required this.sessions,
    required this.totalWorkouts,
    required this.totalMinutes,
    required this.latestMeasurement,
    required this.isLoading,
  });

  final ProgressStrings strings;
  final ImagePaths images;
  final CommonStrings common;

  final List<BodyMeasurement> measurements;
  final List<WorkoutSession> sessions;
  final int totalWorkouts;
  final int totalMinutes;
  final BodyMeasurement? latestMeasurement;
  final bool isLoading;
}
