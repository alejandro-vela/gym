import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../core/presenter/base_presenter.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/ui/ui_models.dart';
import '../../providers/auth_provider.dart';

abstract class LoginView extends BaseView<LoginModel> {
  @override
  void setUI(LoginModel model);
}

class LoginPresenter extends BasePresenter<LoginView> {
  LoginPresenter({required super.view});

  AuthProvider? _auth;
  BuildContext? _ctx;

  @override
  void getUI(BuildContext context) {
    _ctx = context;
    _auth ??= context.read<AuthProvider>()..addListener(_onAuthChanged);
    _buildAndDeliver(context);
  }

  @override
  void dispose() {
    _auth?.removeListener(_onAuthChanged);
    super.dispose();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    await context.read<AuthProvider>().signInWithGoogle();
  }

  Future<void> signInWithApple(BuildContext context) async {
    await context.read<AuthProvider>().signInWithApple();
  }

  void _onAuthChanged() {
    if (_ctx != null) {
      _buildAndDeliver(_ctx!);
    }
  }

  void _buildAndDeliver(BuildContext context) {
    final LoginStrings s = context.read<LanguageProvider>().strings.login;
    final AuthProvider auth = context.read<AuthProvider>();

    view.setUI(
      LoginModel(
        title: s.title,
        tagline: s.tagline,
        googleBtn: s.googleBtn,
        appleBtn: s.appleBtn,
        legal: s.legal,
        errorCancelled: s.errorCancelled,
        errorNetwork: s.errorNetwork,
        errorGeneric: s.errorGeneric,
        error: auth.error,
      ),
    );
  }
}
