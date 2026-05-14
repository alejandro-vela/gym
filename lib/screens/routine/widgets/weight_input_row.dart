import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class WeightInputRow extends StatelessWidget {
  const WeightInputRow({
    super.key,
    required this.label,
    required this.helperText,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final String helperText;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: value >= 2.5
                    ? () => onChanged((value - 2.5).clamp(0, 999))
                    : null,
                child: const WeightStepBtn(icon: Icons.remove_rounded),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: value >= 5
                    ? () => onChanged((value - 5).clamp(0, 999))
                    : null,
                child: const WeightStepBtn(
                  icon: Icons.keyboard_double_arrow_left_rounded,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      '${value.toStringAsFixed(1)} kg',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => onChanged((value + 5).clamp(0, 999)),
                child: const WeightStepBtn(
                  icon: Icons.keyboard_double_arrow_right_rounded,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => onChanged((value + 2.5).clamp(0, 999)),
                child: const WeightStepBtn(icon: Icons.add_rounded),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              helperText,
              style: TextStyle(
                color: AppTheme.textSecondary.withValues(alpha: 0.5),
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeightStepBtn extends StatelessWidget {
  const WeightStepBtn({super.key, required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppTheme.primaryOrange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, size: 18, color: AppTheme.primaryOrange),
    );
  }
}

class NumberInput extends StatelessWidget {
  const NumberInput({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: value > min ? () => onChanged(value - 1) : null,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: value > min
                        ? AppTheme.primaryOrange.withValues(alpha: 0.2)
                        : AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    Icons.remove_rounded,
                    size: 16,
                    color: AppTheme.primaryOrange,
                  ),
                ),
              ),
              Text(
                '$value',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: value < max ? () => onChanged(value + 1) : null,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    size: 16,
                    color: AppTheme.primaryOrange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
