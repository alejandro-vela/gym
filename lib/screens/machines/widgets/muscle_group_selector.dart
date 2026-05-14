import 'package:flutter/material.dart';

import '../../../models/machine.dart';
import '../../../theme/app_theme.dart';

class MuscleGroupSelector extends StatelessWidget {
  const MuscleGroupSelector({
    super.key,
    required this.selectedMuscles,
    required this.onToggle,
  });
  final List<String> selectedMuscles;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: kMuscleGroups.map((String muscle) {
        final bool isSelected = selectedMuscles.contains(muscle);
        return GestureDetector(
          onTap: () => onToggle(muscle),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryOrange.withValues(alpha: 0.2)
                  : AppTheme.cardDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryOrange
                    : const Color(0xFF333333),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              muscle,
              style: TextStyle(
                color: isSelected
                    ? AppTheme.primaryOrange
                    : AppTheme.textSecondary,
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
