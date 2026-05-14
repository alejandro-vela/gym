class ProgressStrings {
  const ProgressStrings({
    required this.title,
    required this.tabMeasurements,
    required this.tabHistory,
    required this.statWorkouts,
    required this.statMinutes,
    required this.sectionWeightChart,
    required this.sectionLatest,
    required this.sectionHistory,
    required this.addMeasurement,
    required this.emptyMeasurementsTitle,
    required this.emptyMeasurementsBody,
    required this.emptyHistoryTitle,
    required this.emptyHistoryBody,
    required this.workoutCompleted,
    required this.caloriesTotal,
    required this.fieldWeight,
    required this.fieldBodyFat,
    required this.fieldChest,
    required this.fieldWaist,
    required this.fieldHips,
    required this.fieldLeftArm,
    required this.fieldRightArm,
    required this.fieldLeftThigh,
    required this.fieldRightThigh,
    required this.measurementWeight,
    required this.measurementBodyFat,
    required this.measurementChest,
    required this.measurementWaist,
    required this.measurementArmLeft,
    required this.measurementArmRight,
  });

  factory ProgressStrings.fromJson(Map<String, dynamic> j) => ProgressStrings(
        title: j['title'] as String,
        tabMeasurements: j['tab_measurements'] as String,
        tabHistory: j['tab_history'] as String,
        statWorkouts: j['stat_workouts'] as String,
        statMinutes: j['stat_minutes'] as String,
        sectionWeightChart: j['section_weight_chart'] as String,
        sectionLatest: j['section_latest'] as String,
        sectionHistory: j['section_history'] as String,
        addMeasurement: j['add_measurement'] as String,
        emptyMeasurementsTitle: j['empty_measurements_title'] as String,
        emptyMeasurementsBody: j['empty_measurements_body'] as String,
        emptyHistoryTitle: j['empty_history_title'] as String,
        emptyHistoryBody: j['empty_history_body'] as String,
        workoutCompleted: j['workout_completed'] as String,
        caloriesTotal: j['calories_total'] as String,
        fieldWeight: j['field_weight'] as String,
        fieldBodyFat: j['field_body_fat'] as String,
        fieldChest: j['field_chest'] as String,
        fieldWaist: j['field_waist'] as String,
        fieldHips: j['field_hips'] as String,
        fieldLeftArm: j['field_left_arm'] as String,
        fieldRightArm: j['field_right_arm'] as String,
        fieldLeftThigh: j['field_left_thigh'] as String,
        fieldRightThigh: j['field_right_thigh'] as String,
        measurementWeight: j['measurement_weight'] as String,
        measurementBodyFat: j['measurement_body_fat'] as String,
        measurementChest: j['measurement_chest'] as String,
        measurementWaist: j['measurement_waist'] as String,
        measurementArmLeft: j['measurement_arm_left'] as String,
        measurementArmRight: j['measurement_arm_right'] as String,
      );

  final String title;
  final String tabMeasurements;
  final String tabHistory;
  final String statWorkouts;
  final String statMinutes;
  final String sectionWeightChart;
  final String sectionLatest;
  final String sectionHistory;
  final String addMeasurement;
  final String emptyMeasurementsTitle;
  final String emptyMeasurementsBody;
  final String emptyHistoryTitle;
  final String emptyHistoryBody;
  final String workoutCompleted;
  final String caloriesTotal;
  final String fieldWeight;
  final String fieldBodyFat;
  final String fieldChest;
  final String fieldWaist;
  final String fieldHips;
  final String fieldLeftArm;
  final String fieldRightArm;
  final String fieldLeftThigh;
  final String fieldRightThigh;
  final String measurementWeight;
  final String measurementBodyFat;
  final String measurementChest;
  final String measurementWaist;
  final String measurementArmLeft;
  final String measurementArmRight;
}
