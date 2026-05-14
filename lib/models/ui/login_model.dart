class LoginModel {
  const LoginModel({
    required this.title,
    required this.tagline,
    required this.googleBtn,
    required this.appleBtn,
    required this.legal,
    required this.errorCancelled,
    required this.errorNetwork,
    required this.errorGeneric,
    this.error,
  });

  final String title;
  final String tagline;
  final String googleBtn;
  final String appleBtn;
  final String legal;
  final String errorCancelled;
  final String errorNetwork;
  final String errorGeneric;
  final String? error;
}
