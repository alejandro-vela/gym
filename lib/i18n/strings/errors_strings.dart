class ErrorStrings {
  const ErrorStrings({
    required this.generic,
    required this.healthLoad,
    required this.deleteConfirmTitle,
    required this.noConnection,
  });

  factory ErrorStrings.fromJson(Map<String, dynamic> j) => ErrorStrings(
        generic: j['generic'] as String,
        healthLoad: j['health_load'] as String,
        deleteConfirmTitle: j['delete_confirm_title'] as String,
        noConnection: j['no_connection'] as String,
      );

  final String generic;
  final String healthLoad;
  final String deleteConfirmTitle;
  final String noConnection;

  String healthLoadDetail(String detail) =>
      healthLoad.replaceAll('{detail}', detail);
}

class WorkoutTypesStrings {
  const WorkoutTypesStrings({
    required this.strength,
    required this.functional,
    required this.running,
    required this.cycling,
    required this.walking,
    required this.swimming,
    required this.yoga,
    required this.hiit,
    required this.elliptical,
    required this.rowing,
    required this.stairClimbing,
    required this.defaultType,
  });

  factory WorkoutTypesStrings.fromJson(Map<String, dynamic> j) =>
      WorkoutTypesStrings(
        strength: j['strength'] as String,
        functional: j['functional'] as String,
        running: j['running'] as String,
        cycling: j['cycling'] as String,
        walking: j['walking'] as String,
        swimming: j['swimming'] as String,
        yoga: j['yoga'] as String,
        hiit: j['hiit'] as String,
        elliptical: j['elliptical'] as String,
        rowing: j['rowing'] as String,
        stairClimbing: j['stair_climbing'] as String,
        defaultType: j['default'] as String,
      );

  final String strength;
  final String functional;
  final String running;
  final String cycling;
  final String walking;
  final String swimming;
  final String yoga;
  final String hiit;
  final String elliptical;
  final String rowing;
  final String stairClimbing;
  final String defaultType;
}
