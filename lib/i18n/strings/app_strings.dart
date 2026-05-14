class AppStrings {
  const AppStrings({
    required this.title,
    required this.tagline,
    required this.version,
  });

  factory AppStrings.fromJson(Map<String, dynamic> j) => AppStrings(
        title: j['title'] as String,
        tagline: j['tagline'] as String,
        version: j['version'] as String,
      );

  final String title;
  final String tagline;
  final String version;
}

class ImagePaths {
  const ImagePaths({
    required this.logo,
    required this.placeholderMachine,
    required this.placeholderAvatar,
    required this.bodyFront,
    required this.bodyBack,
    required this.appleWatchIcon,
    required this.emptyWorkout,
  });

  factory ImagePaths.fromJson(Map<String, dynamic> j) => ImagePaths(
        logo: j['logo'] as String,
        placeholderMachine: j['placeholder_machine'] as String,
        placeholderAvatar: j['placeholder_avatar'] as String,
        bodyFront: j['body_front'] as String,
        bodyBack: j['body_back'] as String,
        appleWatchIcon: j['apple_watch_icon'] as String,
        emptyWorkout: j['empty_workout'] as String,
      );

  final String logo;
  final String placeholderMachine;
  final String placeholderAvatar;
  final String bodyFront;
  final String bodyBack;
  final String appleWatchIcon;
  final String emptyWorkout;
}
