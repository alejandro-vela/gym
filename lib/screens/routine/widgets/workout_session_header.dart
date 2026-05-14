import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../i18n/app_localizations.dart';
import '../../../i18n/language_provider.dart';
import '../../../theme/app_theme.dart';

class WorkoutSessionHeader extends StatelessWidget {
  const WorkoutSessionHeader({
    super.key,
    required this.sessionTime,
    required this.currentIndex,
    required this.total,
    required this.onFinish,
  });
  final String sessionTime;
  final int currentIndex;
  final int total;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final WorkoutSessionStrings ws =
        context.read<LanguageProvider>().strings.workoutSession;
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 8,
        16,
        12,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(bottom: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ws.title,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.timer_rounded,
                      color: AppTheme.primaryOrange,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      sessionTime,
                      style: const TextStyle(
                        color: AppTheme.primaryOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      ws.count(currentIndex + 1, total),
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onFinish,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text(ws.finishButton),
          ),
        ],
      ),
    );
  }
}
