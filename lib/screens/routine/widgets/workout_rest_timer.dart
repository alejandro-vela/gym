import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../i18n/app_localizations.dart';
import '../../../i18n/language_provider.dart';
import '../../../theme/app_theme.dart';

class WorkoutRestTimerBanner extends StatelessWidget {
  const WorkoutRestTimerBanner({
    super.key,
    required this.seconds,
    required this.onSkip,
  });
  final int seconds;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.info.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: AppTheme.info.withValues(alpha: 0.3)),
        ),
      ),
      child: Builder(
        builder: (BuildContext ctx) {
          final WorkoutSessionStrings ws =
              ctx.read<LanguageProvider>().strings.workoutSession;
          final CommonStrings cs =
              ctx.read<LanguageProvider>().strings.common;
          return Row(
            children: <Widget>[
              const Icon(
                Icons.hourglass_bottom_rounded,
                color: AppTheme.info,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                ws.restTimerLabel,
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
              Text(
                '${seconds}s',
                style: const TextStyle(
                  color: AppTheme.info,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onSkip,
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.info,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                ),
                child: Text(cs.skip),
              ),
            ],
          );
        },
      ),
    );
  }
}
