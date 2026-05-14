import 'package:flutter/material.dart';

import '../../../i18n/app_localizations.dart';
import '../../../theme/app_theme.dart';

class DaySelector extends StatelessWidget {
  const DaySelector({
    super.key,
    required this.selectedDay,
    required this.todayDay,
    required this.onDaySelected,
    required this.strings,
  });
  final int selectedDay;
  final int todayDay;
  final ValueChanged<int> onDaySelected;
  final RoutineStrings strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfaceDark,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List<Widget>.generate(7, (int i) {
          final int day = i + 1;
          final bool isSelected = day == selectedDay;
          final bool isToday = day == todayDay;

          return GestureDetector(
            onTap: () => onDaySelected(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 54,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryOrange
                    : isToday
                        ? AppTheme.primaryOrange.withValues(alpha: 0.15)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isToday && !isSelected
                    ? Border.all(
                        color: AppTheme.primaryOrange.withValues(alpha: 0.5),
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    strings.dayShort(day),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppTheme.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (isToday)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.primaryOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
