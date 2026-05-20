import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_provider.dart';
import '../screens/login/login_screen.dart';
import '../screens/main_shell.dart';
import '../screens/onboarding/onboarding_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool? _onboardingDone;

  @override
  void initState() {
    super.initState();
    unawaited(_checkOnboarding());
  }

  Future<void> _checkOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _onboardingDone = prefs.getBool(kOnboardingKey) ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthStatus status = context.watch<AuthProvider>().status;

    if (status == AuthStatus.loading || _onboardingDone == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (status == AuthStatus.unauthenticated) {
      return const LoginScreen();
    }

    if (_onboardingDone == false) {
      return OnboardingScreen(
        onDone: () => setState(() => _onboardingDone = true),
      );
    }

    return const MainShell();
  }
}
