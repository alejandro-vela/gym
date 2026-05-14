import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _sub = AuthService.instance.authStateChanges.listen(_onAuthChanged);
  }

  AuthStatus _status = AuthStatus.loading;
  User? _user;
  String? _error;
  late final StreamSubscription<User?> _sub;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get error => _error;

  Future<void> signInWithGoogle() => _run(AuthService.instance.signInWithGoogle);
  Future<void> signInWithApple() => _run(AuthService.instance.signInWithApple);

  Future<void> signOut() async {
    await AuthService.instance.signOut();
  }

  Future<void> _run(Future<UserCredential> Function() action) async {
    _error = null;
    notifyListeners();
    try {
      await action();
    } on Exception catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _onAuthChanged(User? user) {
    _user = user;
    _status = user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_sub.cancel());
    super.dispose();
  }
}
