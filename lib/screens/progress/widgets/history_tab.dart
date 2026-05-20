import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/routine_exercise.dart';
import '../../../models/ui/progress_model.dart';
import '../../../theme/app_theme.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key, required this.model, required this.presenter});

  final ProgressModel model;
  final Object presenter;

  @override
  Widget build(BuildContext context) {
    final List<WorkoutSession> sessions = model.sessions;

    if (sessions.isEmpty) {
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
              model.strings.emptyHistoryTitle,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 17,
              ),
            ),
            Text(
              model.strings.emptyHistoryBody,
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
        return _SessionCard(session: s, model: model);
      },
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session, required this.model});

  final WorkoutSession session;
  final ProgressModel model;

  @override
  Widget build(BuildContext context) {
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
                  DateFormat('EEEE d MMM yyyy').format(session.date),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  session.durationMinutes != null
                      ? '⏱ ${session.durationMinutes} ${model.common.min}'
                      : model.strings.workoutCompleted,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
  }
}
