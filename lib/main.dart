import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/gym_track_app.dart';
import 'firebase_options.dart';
import 'i18n/language_provider.dart';
import 'services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final LanguageProvider languageProvider = LanguageProvider();
  await languageProvider.initialize();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await DatabaseService.instance.initDatabase();
  runApp(GymTrackApp(languageProvider: languageProvider));
}
