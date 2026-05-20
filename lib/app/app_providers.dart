import 'dart:async';

import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

import '../i18n/language_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/health_provider.dart';
import '../providers/machines_provider.dart';
import '../providers/pr_streak_provider.dart';
import '../providers/routine_provider.dart';
import '../providers/workout_provider.dart';

List<SingleChildWidget> buildProviders(LanguageProvider languageProvider) {
  return <SingleChildWidget>[
    ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
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
      create: (_) => ProgressProvider(),
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
  ];
}
