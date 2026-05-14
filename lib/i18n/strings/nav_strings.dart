class NavStrings {
  const NavStrings({
    required this.home,
    required this.machines,
    required this.routine,
    required this.progress,
    required this.watch,
  });

  factory NavStrings.fromJson(Map<String, dynamic> j) => NavStrings(
        home: j['home'] as String,
        machines: j['machines'] as String,
        routine: j['routine'] as String,
        progress: j['progress'] as String,
        watch: j['watch'] as String,
      );

  final String home;
  final String machines;
  final String routine;
  final String progress;
  final String watch;
}
