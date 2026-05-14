class LoginStrings {
  const LoginStrings({
    required this.title,
    required this.tagline,
    required this.googleBtn,
    required this.appleBtn,
    required this.legal,
    required this.errorCancelled,
    required this.errorNetwork,
    required this.errorGeneric,
  });

  factory LoginStrings.fromJson(Map<String, dynamic> j) => LoginStrings(
        title: j['title'] as String,
        tagline: j['tagline'] as String,
        googleBtn: j['google_btn'] as String,
        appleBtn: j['apple_btn'] as String,
        legal: j['legal'] as String,
        errorCancelled: j['error_cancelled'] as String,
        errorNetwork: j['error_network'] as String,
        errorGeneric: j['error_generic'] as String,
      );

  final String title;
  final String tagline;
  final String googleBtn;
  final String appleBtn;
  final String legal;
  final String errorCancelled;
  final String errorNetwork;
  final String errorGeneric;
}
