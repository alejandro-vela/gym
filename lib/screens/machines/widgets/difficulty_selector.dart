import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class DifficultySelector extends StatelessWidget {
  const DifficultySelector({
    super.key,
    required this.difficulty,
    required this.labels,
    required this.onSelect,
  });
  final int difficulty;
  final List<String> labels;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = <Color>[
      AppTheme.success,
      AppTheme.warning,
      AppTheme.danger,
    ];
    return Row(
      children: <int>[1, 2, 3].map((int d) {
        final bool isSelected = difficulty == d;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: d < 3 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onSelect(d),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors[d - 1].withValues(alpha: 0.2)
                      : AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? colors[d - 1]
                        : const Color(0xFF333333),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  labels[d - 1],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? colors[d - 1]
                        : AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
