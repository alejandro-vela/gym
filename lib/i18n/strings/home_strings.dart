class TipData {
  const TipData({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });

  factory TipData.fromJson(Map<String, dynamic> j) => TipData(
        icon: j['icon'] as String,
        title: j['title'] as String,
        body: j['body'] as String,
        color: j['color'] as String,
      );

  final String icon;
  final String title;
  final String body;
  final String color;
}

class HomeStrings {
  const HomeStrings({
    required this.welcome,
    required this.appName,
    required this.todayLabel,
    required this.statMachines,
    required this.statWorkouts,
    required this.statTodayExercises,
    required this.startWorkout,
    required this.activeSessionTitle,
    required this.activeSessionElapsed,
    required this.restDayTitle,
    required this.restDayHint,
    required this.quickLinkRecovery,
    required this.quickLinkPrs,
    required this.tipOfDay,
    required this.tips,
  });

  factory HomeStrings.fromJson(Map<String, dynamic> j) => HomeStrings(
        welcome: j['welcome'] as String,
        appName: j['app_name'] as String,
        todayLabel: j['today_label'] as String,
        statMachines: j['stat_machines'] as String,
        statWorkouts: j['stat_workouts'] as String,
        statTodayExercises: j['stat_today_exercises'] as String,
        startWorkout: j['start_workout'] as String,
        activeSessionTitle: j['active_session_title'] as String,
        activeSessionElapsed: j['active_session_elapsed'] as String,
        restDayTitle: j['rest_day_title'] as String,
        restDayHint: j['rest_day_hint'] as String,
        quickLinkRecovery: j['quick_link_recovery'] as String,
        quickLinkPrs: j['quick_link_prs'] as String,
        tipOfDay: j['tip_of_day'] as String,
        tips: (j['tips'] as List<dynamic>)
            .map((dynamic t) => TipData.fromJson(t as Map<String, dynamic>))
            .toList(),
      );

  final String welcome;
  final String appName;
  final String todayLabel;
  final String statMachines;
  final String statWorkouts;
  final String statTodayExercises;
  final String startWorkout;
  final String activeSessionTitle;
  final String activeSessionElapsed;
  final String restDayTitle;
  final String restDayHint;
  final String quickLinkRecovery;
  final String quickLinkPrs;
  final String tipOfDay;
  final List<TipData> tips;
}
