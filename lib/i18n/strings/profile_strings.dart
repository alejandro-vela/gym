class ProfileStrings {
  const ProfileStrings({
    required this.title,
    required this.signOut,
    required this.signOutConfirm,
    required this.signOutBody,
    required this.guest,
    required this.statsWorkouts,
    required this.statsStreak,
  });

  factory ProfileStrings.fromJson(Map<String, dynamic> j) => ProfileStrings(
        title: j['title'] as String,
        signOut: j['sign_out'] as String,
        signOutConfirm: j['sign_out_confirm'] as String,
        signOutBody: j['sign_out_body'] as String,
        guest: j['guest'] as String,
        statsWorkouts: j['stats_workouts'] as String,
        statsStreak: j['stats_streak'] as String,
      );

  final String title;
  final String signOut;
  final String signOutConfirm;
  final String signOutBody;
  final String guest;
  final String statsWorkouts;
  final String statsStreak;
}
