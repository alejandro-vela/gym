class HealthStrings {
  const HealthStrings({
    required this.title,
    required this.syncedAt,
    required this.syncing,
    required this.refresh,
    required this.caloriesActive,
    required this.caloriesBasal,
    required this.caloriesTotal,
    required this.calorieGoal,
    required this.calorieProgressPct,
    required this.setGoalTitle,
    required this.setGoalHint,
    required this.statSteps,
    required this.statDistance,
    required this.statExercise,
    required this.heartRateTitle,
    required this.hrCurrent,
    required this.hrAvg,
    required this.hrMax,
    required this.hrChartHint,
    required this.zoneRest,
    required this.zoneNormal,
    required this.zoneModerate,
    required this.zoneIntense,
    required this.sleepTitle,
    required this.sleepOptimal,
    required this.sleepRegular,
    required this.sleepInsufficient,
    required this.sleepLastNight,
    required this.workoutsTitle,
    required this.noWorkoutsTitle,
    required this.noWorkoutsBody,
    required this.permissionTitle,
    required this.permissionSubtitle,
    required this.permissionFeatures,
    required this.permissionCta,
    required this.permissionPrivacy,
    required this.permissionDeniedTitle,
    required this.permissionDeniedBody,
    required this.errorTitle,
  });

  factory HealthStrings.fromJson(Map<String, dynamic> j) => HealthStrings(
        title: j['title'] as String,
        syncedAt: j['synced_at'] as String,
        syncing: j['syncing'] as String,
        refresh: j['refresh'] as String,
        caloriesActive: j['calories_active'] as String,
        caloriesBasal: j['calories_basal'] as String,
        caloriesTotal: j['calories_total'] as String,
        calorieGoal: j['calorie_goal'] as String,
        calorieProgressPct: j['calorie_progress_pct'] as String,
        setGoalTitle: j['set_goal_title'] as String,
        setGoalHint: j['set_goal_hint'] as String,
        statSteps: j['stat_steps'] as String,
        statDistance: j['stat_distance'] as String,
        statExercise: j['stat_exercise'] as String,
        heartRateTitle: j['heart_rate_title'] as String,
        hrCurrent: j['hr_current'] as String,
        hrAvg: j['hr_avg'] as String,
        hrMax: j['hr_max'] as String,
        hrChartHint: j['hr_chart_hint'] as String,
        zoneRest: j['zone_rest'] as String,
        zoneNormal: j['zone_normal'] as String,
        zoneModerate: j['zone_moderate'] as String,
        zoneIntense: j['zone_intense'] as String,
        sleepTitle: j['sleep_title'] as String,
        sleepOptimal: j['sleep_optimal'] as String,
        sleepRegular: j['sleep_regular'] as String,
        sleepInsufficient: j['sleep_insufficient'] as String,
        sleepLastNight: j['sleep_last_night'] as String,
        workoutsTitle: j['workouts_title'] as String,
        noWorkoutsTitle: j['no_workouts_title'] as String,
        noWorkoutsBody: j['no_workouts_body'] as String,
        permissionTitle: j['permission_title'] as String,
        permissionSubtitle: j['permission_subtitle'] as String,
        permissionFeatures:
            List<String>.from(j['permission_features'] as List<dynamic>),
        permissionCta: j['permission_cta'] as String,
        permissionPrivacy: j['permission_privacy'] as String,
        permissionDeniedTitle: j['permission_denied_title'] as String,
        permissionDeniedBody: j['permission_denied_body'] as String,
        errorTitle: j['error_title'] as String,
      );

  final String title;
  final String syncedAt;
  final String syncing;
  final String refresh;
  final String caloriesActive;
  final String caloriesBasal;
  final String caloriesTotal;
  final String calorieGoal;
  final String calorieProgressPct;
  final String setGoalTitle;
  final String setGoalHint;
  final String statSteps;
  final String statDistance;
  final String statExercise;
  final String heartRateTitle;
  final String hrCurrent;
  final String hrAvg;
  final String hrMax;
  final String hrChartHint;
  final String zoneRest;
  final String zoneNormal;
  final String zoneModerate;
  final String zoneIntense;
  final String sleepTitle;
  final String sleepOptimal;
  final String sleepRegular;
  final String sleepInsufficient;
  final String sleepLastNight;
  final String workoutsTitle;
  final String noWorkoutsTitle;
  final String noWorkoutsBody;
  final String permissionTitle;
  final String permissionSubtitle;
  final List<String> permissionFeatures;
  final String permissionCta;
  final String permissionPrivacy;
  final String permissionDeniedTitle;
  final String permissionDeniedBody;
  final String errorTitle;

  String syncedTime(String time) => syncedAt.replaceAll('{time}', time);
  String caloriesTotalValue(String value) =>
      caloriesTotal.replaceAll('{value}', value);
  String calorieGoalValue(String value) =>
      calorieGoal.replaceAll('{value}', value);
  String progressPct(int pct) => calorieProgressPct.replaceAll('{pct}', '$pct');
}
