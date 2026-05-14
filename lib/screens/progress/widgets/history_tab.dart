import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../i18n/app_localizations.dart';
import '../../../i18n/language_provider.dart';
import '../../../models/routine_exercise.dart';
import '../../../providers/workout_provider.dart';
import '../../../theme/app_theme.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key, required this.provider});
  final ProgressProvider provider;

  @override
  Widget build(BuildContext context) {
    final List<WorkoutSession> sessions = provider.sessions;

    if (sessions.isEmpty) {
      final ProgressStrings s =
          context.read<LanguageProvider>().strings.progress;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.history_rounded,
              color: AppTheme.textSecondary,
              size: 50,
            ),
            const SizedBox(height: 12),
            Text(
              s.emptyHistoryTitle,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 17),
            ),
            Text(
              s.emptyHistoryBody,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: sessions.length,
      itemBuilder: (_, int i) {
        final WorkoutSession s = sessions[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.fitness_center_rounded,
                  color: AppTheme.primaryOrange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DateFormat('EEEE d MMM yyyy').format(s.date),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      s.durationMinutes != null
                          ? '⏱ ${s.durationMinutes} ${context.read<LanguageProvider>().strings.common.min}'
                          : context.read<LanguageProvider>().strings.progress.workoutCompleted,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '✓',
                  style: TextStyle(
                    color: AppTheme.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
