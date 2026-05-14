import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../i18n/app_localizations.dart';
import '../../../i18n/language_provider.dart';
import '../../../theme/app_theme.dart';

class HealthPermissionScreen extends StatelessWidget {
  const HealthPermissionScreen({
    super.key,
    required this.strings,
    required this.onRequest,
  });
  final HealthStrings strings;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[AppTheme.primaryOrange, Color(0xFFFF3B30)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.watch_rounded,
                color: Colors.white,
                size: 52,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              strings.permissionTitle,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              strings.permissionSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ...strings.permissionFeatures.map(
              (String item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: <Widget>[
                    Text(
                      item,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRequest,
                icon: const Icon(Icons.health_and_safety_rounded),
                label: Text(strings.permissionCta),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              strings.permissionPrivacy,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF555555), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class HealthPermissionDeniedScreen extends StatelessWidget {
  const HealthPermissionDeniedScreen({
    super.key,
    required this.strings,
    required this.onRequest,
  });
  final HealthStrings strings;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final CommonStrings cs = context.read<LanguageProvider>().strings.common;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.block_rounded, color: AppTheme.danger, size: 60),
            const SizedBox(height: 16),
            Text(
              strings.permissionDeniedTitle,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              strings.permissionDeniedBody,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRequest,
              child: Text(cs.retry),
            ),
          ],
        ),
      ),
    );
  }
}
