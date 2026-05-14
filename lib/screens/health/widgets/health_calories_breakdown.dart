import 'package:flutter/material.dart';

import '../../../i18n/app_localizations.dart';
import '../../../theme/app_theme.dart';

class HealthCaloriesBreakdown extends StatelessWidget {
  const HealthCaloriesBreakdown({
    super.key,
    required this.strings,
    required this.active,
    required this.basal,
  });
  final HealthStrings strings;
  final double active;
  final double basal;

  @override
  Widget build(BuildContext context) {
    final double total = active + basal;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HealthSectionHeader(
            title: strings.caloriesTotal.replaceAll('{value}', ''),
            icon: Icons.local_fire_department_rounded,
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(
                child: CalBreakItem(
                  label: strings.caloriesActive,
                  value: active.round(),
                  total: total,
                  color: AppTheme.primaryOrange,
                  icon: Icons.directions_run_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CalBreakItem(
                  label: strings.caloriesBasal,
                  value: basal.round(),
                  total: total,
                  color: AppTheme.info,
                  icon: Icons.self_improvement_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.calculate_rounded,
                color: AppTheme.textSecondary,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                strings.caloriesTotalValue('${total.round()}'),
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CalBreakItem extends StatelessWidget {
  const CalBreakItem({
    super.key,
    required this.label,
    required this.value,
    required this.total,
    required this.color,
    required this.icon,
  });
  final String label;
  final int value;
  final double total;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final int pct = total > 0 ? (value / total * 100).round() : 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 6),
          Text(
            '$value kcal',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
            ),
          ),
          Text(
            '$pct% del total',
            style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class HealthSectionHeader extends StatelessWidget {
  const HealthSectionHeader({
    super.key,
    required this.title,
    required this.icon,
  });
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color: AppTheme.primaryOrange, size: 16),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
