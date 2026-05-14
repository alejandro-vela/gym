import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

import 'i18n/language_provider.dart';
import 'providers/health_provider.dart';
import 'providers/machines_provider.dart';
import 'providers/pr_streak_provider.dart';
import 'providers/routine_provider.dart';
import 'providers/workout_provider.dart';
import 'screens/main_shell.dart';
import 'services/database_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final LanguageProvider languageProvider = LanguageProvider();
  await languageProvider.initialize();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await DatabaseService.instance.initDatabase();
  runApp(GymTrackApp(languageProvider: languageProvider));
}

class GymTrackApp extends StatelessWidget {
  const GymTrackApp({super.key, required this.languageProvider});
  final LanguageProvider languageProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),
        ChangeNotifierProvider<MachinesProvider>(
          create: (_) {
            final MachinesProvider p = MachinesProvider();
            unawaited(p.loadMachines());
            return p;
          },
        ),
        ChangeNotifierProvider<RoutineProvider>(
          create: (_) {
            final RoutineProvider p = RoutineProvider();
            unawaited(p.loadAllDays());
            return p;
          },
        ),
        ChangeNotifierProvider<WorkoutProvider>(
          create: (_) => WorkoutProvider(),
        ),
        ChangeNotifierProvider<ProgressProvider>(
          create: (_) {
            final ProgressProvider p = ProgressProvider();
            unawaited(p.loadProgress());
            return p;
          },
        ),
        ChangeNotifierProvider<HealthProvider>(
          create: (_) => HealthProvider(),
        ),
        ChangeNotifierProvider<PrStreakProvider>(
          create: (_) {
            final PrStreakProvider p = PrStreakProvider();
            unawaited(p.loadAll());
            return p;
          },
        ),
        ChangeNotifierProvider<RecoveryProvider>(
          create: (_) {
            final RecoveryProvider p = RecoveryProvider();
            unawaited(p.loadRecovery());
            return p;
          },
        ),
      ],
      child: MaterialApp(
        title: 'GymTrack Pro',
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const MainShell(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
