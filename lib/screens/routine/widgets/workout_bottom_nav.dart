import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../i18n/app_localizations.dart';
import '../../../i18n/language_provider.dart';
import '../../../theme/app_theme.dart';

class WorkoutBottomNavBar extends StatelessWidget {
  const WorkoutBottomNavBar({
    super.key,
    required this.canGoBack,
    required this.canGoForward,
    required this.isLast,
    required this.onBack,
    required this.onForward,
    required this.onFinish,
  });
  final bool canGoBack;
  final bool canGoForward;
  final bool isLast;
  final VoidCallback onBack;
  final VoidCallback onForward;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Builder(
        builder: (BuildContext ctx) {
          final WorkoutSessionStrings ws =
              ctx.read<LanguageProvider>().strings.workoutSession;
          final CommonStrings cs =
              ctx.read<LanguageProvider>().strings.common;
          return Row(
            children: <Widget>[
              if (canGoBack)
                OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: Text(cs.previous),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              const Spacer(),
              if (isLast)
                ElevatedButton.icon(
                  onPressed: onFinish,
                  icon: const Icon(Icons.emoji_events_rounded, size: 18),
                  label: Text(ws.completeCelebration),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: canGoForward ? onForward : null,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: Text(cs.next),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class WorkoutExerciseNavigation extends StatelessWidget {
  const WorkoutExerciseNavigation({
    super.key,
    required this.exercises,
    required this.currentIndex,
    required this.onSelect,
  });
  final List<String> exercises;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: exercises.length,
        itemBuilder: (_, int i) {
          final bool isSelected = i == currentIndex;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryOrange
                    : AppTheme.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryOrange
                      : const Color(0xFF333333),
                ),
              ),
              child: Text(
                exercises[i].split(' ').first,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
