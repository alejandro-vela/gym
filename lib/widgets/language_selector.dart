import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../i18n/language_provider.dart';
import '../theme/app_theme.dart';

/// A compact language picker — can be placed in any AppBar or settings screen.
class LanguageSelectorButton extends StatelessWidget {
  const LanguageSelectorButton({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageProvider langProvider = context.watch<LanguageProvider>();

    return PopupMenuButton<SupportedLanguage>(
      color: AppTheme.cardDark,
      tooltip: 'Idioma / Language',
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            langProvider.currentLanguage.flag,
            style: const TextStyle(fontSize: 18),
          ),
          const Icon(
            Icons.arrow_drop_down_rounded,
            color: AppTheme.textSecondary,
            size: 18,
          ),
        ],
      ),
      onSelected: (SupportedLanguage lang) =>
          unawaited(langProvider.setLanguage(lang)),
      itemBuilder: (_) => langProvider.supportedLanguages
          .map(
            (SupportedLanguage lang) => PopupMenuItem<SupportedLanguage>(
              value: lang,
              child: Row(
                children: <Widget>[
                  Text(lang.flag, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Text(
                    lang.displayName,
                    style: TextStyle(
                      color: lang == langProvider.currentLanguage
                          ? AppTheme.primaryOrange
                          : AppTheme.textPrimary,
                      fontWeight: lang == langProvider.currentLanguage
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  if (lang == langProvider.currentLanguage) ...<Widget>[
                    const Spacer(),
                    const Icon(
                      Icons.check_rounded,
                      color: AppTheme.primaryOrange,
                      size: 16,
                    ),
                  ],
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

/// Full language settings screen for a dedicated settings page.
class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageProvider langProvider = context.watch<LanguageProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Idioma / Language')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Selecciona tu idioma / Select your language',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                ...langProvider.supportedLanguages.map(
                  (SupportedLanguage lang) => _LanguageTile(
                    language: lang,
                    isSelected: lang == langProvider.currentLanguage,
                    onTap: () =>
                        unawaited(langProvider.setLanguage(lang)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });
  final SupportedLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryOrange.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryOrange
                : const Color(0xFF2A2A2A),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            Text(language.flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                language.displayName,
                style: TextStyle(
                  color: isSelected
                      ? AppTheme.primaryOrange
                      : AppTheme.textPrimary,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.primaryOrange,
              ),
          ],
        ),
      ),
    );
  }
}
