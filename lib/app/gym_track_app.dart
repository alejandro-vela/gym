import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../i18n/language_provider.dart';
import '../theme/app_theme.dart';
import 'app_providers.dart';
import 'auth_gate.dart';

class GymTrackApp extends StatelessWidget {
  const GymTrackApp({super.key, required this.languageProvider});

  final LanguageProvider languageProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildProviders(languageProvider),
      child: MaterialApp(
        title: 'GymTrack Pro',
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const AuthGate(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
