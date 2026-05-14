class RecoveryStrings {
  const RecoveryStrings({
    required this.title,
    required this.frontView,
    required this.backView,
    required this.tapHint,
    required this.detailTitle,
    required this.legendFresh,
    required this.legendRecovering,
    required this.legendFatigued,
    required this.statusFresh,
    required this.statusRecovering,
    required this.statusFatigued,
    required this.noRecent,
    required this.alertFatiguedTitle,
    required this.alertFatiguedBody,
    required this.alertRecoveringTitle,
    required this.alertRecoveringBody,
    required this.alertFreshTitle,
    required this.alertFreshBody,
    required this.muscleNames,
  });

  factory RecoveryStrings.fromJson(Map<String, dynamic> j) => RecoveryStrings(
        title: j['title'] as String,
        frontView: j['front_view'] as String,
        backView: j['back_view'] as String,
        tapHint: j['tap_hint'] as String,
        detailTitle: j['detail_title'] as String,
        legendFresh: j['legend_fresh'] as String,
        legendRecovering: j['legend_recovering'] as String,
        legendFatigued: j['legend_fatigued'] as String,
        statusFresh: j['status_fresh'] as String,
        statusRecovering: j['status_recovering'] as String,
        statusFatigued: j['status_fatigued'] as String,
        noRecent: j['no_recent'] as String,
        alertFatiguedTitle: j['alert_fatigued_title'] as String,
        alertFatiguedBody: j['alert_fatigued_body'] as String,
        alertRecoveringTitle: j['alert_recovering_title'] as String,
        alertRecoveringBody: j['alert_recovering_body'] as String,
        alertFreshTitle: j['alert_fresh_title'] as String,
        alertFreshBody: j['alert_fresh_body'] as String,
        muscleNames: Map<String, String>.from(
          j['muscle_names'] as Map<dynamic, dynamic>,
        ),
      );

  final String title;
  final String frontView;
  final String backView;
  final String tapHint;
  final String detailTitle;
  final String legendFresh;
  final String legendRecovering;
  final String legendFatigued;
  final String statusFresh;
  final String statusRecovering;
  final String statusFatigued;
  final String noRecent;
  final String alertFatiguedTitle;
  final String alertFatiguedBody;
  final String alertRecoveringTitle;
  final String alertRecoveringBody;
  final String alertFreshTitle;
  final String alertFreshBody;
  final Map<String, String> muscleNames;

  String statusRecoveringHours(int hours) =>
      statusRecovering.replaceAll('{hours}', '$hours');
  String fatiguedBody(String muscles) =>
      alertFatiguedBody.replaceAll('{muscles}', muscles);
  String recoveringBody(String muscles) =>
      alertRecoveringBody.replaceAll('{muscles}', muscles);
  String muscleName(String key) => muscleNames[key] ?? key;
}

class OverloadStrings {
  const OverloadStrings({
    required this.suggestionIncrease,
    required this.suggestionMaintain,
    required this.increaseLabel,
  });

  factory OverloadStrings.fromJson(Map<String, dynamic> j) => OverloadStrings(
        suggestionIncrease: j['suggestion_increase'] as String,
        suggestionMaintain: j['suggestion_maintain'] as String,
        increaseLabel: j['increase_label'] as String,
      );

  final String suggestionIncrease;
  final String suggestionMaintain;
  final String increaseLabel;

  String increase(double value) =>
      increaseLabel.replaceAll('{value}', '$value');
}
