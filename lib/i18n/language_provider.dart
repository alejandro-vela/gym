import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localizations.dart';

enum SupportedLanguage {
  es('es', 'Español', '🇪🇸'),
  en('en', 'English', '🇺🇸');

  const SupportedLanguage(this.code, this.displayName, this.flag);
  final String code;
  final String displayName;
  final String flag;

  static SupportedLanguage fromCode(String code) =>
      SupportedLanguage.values.firstWhere(
        (SupportedLanguage l) => l.code == code,
        orElse: () => SupportedLanguage.es,
      );
}

class LanguageProvider extends ChangeNotifier {
  static const String _prefKey = 'app_language';
  static const SupportedLanguage _defaultLanguage = SupportedLanguage.es;

  late AppLocalizations _strings;
  SupportedLanguage _currentLanguage = _defaultLanguage;
  bool _isInitialized = false;

  // ── Public API ──────────────────────────────────────────────────

  AppLocalizations get strings => _strings;
  SupportedLanguage get currentLanguage => _currentLanguage;
  bool get isInitialized => _isInitialized;
  List<SupportedLanguage> get supportedLanguages => SupportedLanguage.values;

  /// Initializes the provider: loads the saved language or falls back to default.
  /// Must be awaited before the app renders any UI.
  Future<void> initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedCode = prefs.getString(_prefKey);
    _currentLanguage = savedCode != null
        ? SupportedLanguage.fromCode(savedCode)
        : _defaultLanguage;

    await _loadLanguage(_currentLanguage);
    _isInitialized = true;
    notifyListeners();
  }

  /// Switches the language and persists the choice.
  Future<void> setLanguage(SupportedLanguage language) async {
    if (_currentLanguage == language) {
      return;
    }
    _currentLanguage = language;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, language.code);

    await _loadLanguage(language);
    notifyListeners();
  }

  // ── Internal ────────────────────────────────────────────────────

  Future<void> _loadLanguage(SupportedLanguage language) async {
    try {
      final String jsonStr =
          await rootBundle.loadString('assets/i18n/${language.code}.json');
      final Map<String, dynamic> jsonMap =
          json.decode(jsonStr) as Map<String, dynamic>;
      _strings = AppLocalizations.fromJson(jsonMap);
    } on Exception catch (e) {
      debugPrint('[LanguageProvider] Failed to load ${language.code}.json: $e');
      // Fallback: try default language
      if (language != _defaultLanguage) {
        await _loadLanguage(_defaultLanguage);
      }
    }
  }
}

// ─── Convenience extension on BuildContext ───────────────────────
// Usage: context.strings.home.welcome
// Usage: context.strings.common.save
extension LocalizationContext on BuildContext {
  AppLocalizations get strings => read<LanguageProvider>().strings;

  /// Watches for language changes and rebuilds on switch.
  AppLocalizations get watchStrings => watch<LanguageProvider>().strings;
}
