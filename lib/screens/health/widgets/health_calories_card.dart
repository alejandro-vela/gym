import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../i18n/app_localizations.dart';
import '../../../i18n/language_provider.dart';
import '../../../theme/app_theme.dart';

export 'health_calories_breakdown.dart';
export 'health_quick_stat.dart';

class HealthCalorieRing extends StatelessWidget {
  const HealthCalorieRing({
    super.key,
    required this.strings,
    required this.activeCalories,
    required this.totalCalories,
    required this.goal,
    required this.progress,
    required this.onGoalTap,
  });
  final HealthStrings strings;
  final double activeCalories;
  final double totalCalories;
  final double goal;
  final double progress;
  final VoidCallback onGoalTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 120,
            height: 120,
            child: CustomPaint(
              painter: CalorieRingPainter(progress: progress),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      activeCalories.round().toString(),
                      style: const TextStyle(
                        color: AppTheme.primaryOrange,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      context.read<LanguageProvider>().strings.common.kcal,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  strings.caloriesActive,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                HealthCalorieRow(
                  label: strings.caloriesActive,
                  value: '${activeCalories.round()} ${context.read<LanguageProvider>().strings.common.kcal}',
                  color: AppTheme.primaryOrange,
                ),
                HealthCalorieRow(
                  label: strings.caloriesBasal,
                  value: '${totalCalories.round()} ${context.read<LanguageProvider>().strings.common.kcal}',
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onGoalTap,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: const Color(0xFF333333),
                            color: progress >= 1
                                ? AppTheme.success
                                : AppTheme.primaryOrange,
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        strings.progressPct((progress * 100).round()),
                        style: TextStyle(
                          color: progress >= 1
                              ? AppTheme.success
                              : AppTheme.primaryOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onGoalTap,
                  child: Row(
                    children: <Widget>[
                      Text(
                        strings.calorieGoalValue('${goal.round()}'),
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.edit_rounded,
                        size: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ],
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

class HealthCalorieRow extends StatelessWidget {
  const HealthCalorieRow({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class CalorieRingPainter extends CustomPainter {
  const CalorieRingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2 - 10;
    const double strokeWidth = 10.0;

    final Paint bgPaint = Paint()
      ..color = const Color(0xFF2A2A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final Paint progressPaint = Paint()
      ..color = progress >= 1 ? AppTheme.success : AppTheme.primaryOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress.clamp(0.0, 1.0),
        false,
        progressPaint,
      );
    }

    if (progress >= 1) {
      final Paint glowPaint = Paint()
        ..color = AppTheme.success.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi,
        false,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CalorieRingPainter old) => old.progress != progress;
}
