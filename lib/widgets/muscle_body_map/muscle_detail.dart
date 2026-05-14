import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/achievement.dart';
import '../../providers/pr_streak_provider.dart';
import '../../theme/app_theme.dart';
import 'muscle_status_color.dart';

class MuscleDetail extends StatelessWidget {
  const MuscleDetail({
    super.key,
    required this.muscle,
    required this.status,
    required this.recoveryPct,
  });
  final String muscle;
  final MuscleStatus status;
  final double recoveryPct;

  @override
  Widget build(BuildContext context) {
    final Color color = status.color;
    final int hoursLeft = kMuscleRecoveryHours[muscle] != null
        ? ((1 - recoveryPct) * (kMuscleRecoveryHours[muscle]!)).round()
        : 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  muscle,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Builder(
                  builder: (BuildContext ctx) {
                    final RecoveryStrings rs =
                        ctx.read<LanguageProvider>().strings.recovery;
                    final String statusText = status == MuscleStatus.fresh
                        ? rs.statusFresh
                        : status == MuscleStatus.recovering
                            ? rs.statusRecoveringHours(hoursLeft)
                            : rs.statusFatigued;
                    return Text(
                      statusText,
                      style: TextStyle(color: color, fontSize: 12),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            child: Column(
              children: <Widget>[
                Text(
                  '${(recoveryPct * 100).round()}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: recoveryPct,
                    backgroundColor: const Color(0xFF333333),
                    color: color,
                    minHeight: 5,
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
