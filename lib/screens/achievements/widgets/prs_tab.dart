import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../i18n/app_localizations.dart';
import '../../../i18n/language_provider.dart';
import '../../../models/achievement.dart';
import '../../../providers/pr_streak_provider.dart';
import '../../../theme/app_theme.dart';
import 'one_rm_chart.dart';

class PrTab extends StatefulWidget {
  const PrTab({super.key, required this.provider});
  final PrStreakProvider provider;

  @override
  State<PrTab> createState() => PrTabState();
}

class PrTabState extends State<PrTab> {
  String? _selectedExercise;

  @override
  Widget build(BuildContext context) {
    final Map<String, PersonalRecord> bestPrs =
        widget.provider.bestPrByExercise;
    if (bestPrs.isEmpty) {
      final AchievementsStrings s =
          context.read<LanguageProvider>().strings.achievements;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('🏆', style: TextStyle(fontSize: 50)),
            const SizedBox(height: 12),
            Text(
              s.prsEmptyTitle,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              s.prsEmptyBody,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        if (_selectedExercise != null) ...<Widget>[
          OneRmChart(
            exerciseName: _selectedExercise!,
            prs: widget.provider.allPrs
                .where(
                  (PersonalRecord p) =>
                      p.exerciseName == _selectedExercise,
                )
                .toList(),
          ),
          const SizedBox(height: 16),
        ],
        Builder(
          builder: (BuildContext ctx) {
            final AchievementsStrings s =
                ctx.read<LanguageProvider>().strings.achievements;
            return Text(
              _selectedExercise == null ? s.prsBestLabel : s.prsTapHint,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        ...bestPrs.entries.map((MapEntry<String, PersonalRecord> e) {
          final bool isSelected = _selectedExercise == e.key;
          return GestureDetector(
            onTap: () => setState(() {
              _selectedExercise = isSelected ? null : e.key;
            }),
            child: PrCard(pr: e.value, isSelected: isSelected),
          );
        }),
        const SizedBox(height: 60),
      ],
    );
  }
}

class PrCard extends StatelessWidget {
  const PrCard({super.key, required this.pr, this.isSelected = false});
  final PersonalRecord pr;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryOrange.withValues(alpha: 0.1)
            : AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? AppTheme.primaryOrange
              : const Color(0xFF2A2A2A),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('🏆', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  pr.exerciseName,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '${pr.weight}kg × ${pr.reps} reps',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '~${pr.estimated1rm.toStringAsFixed(1)}kg',
                style: const TextStyle(
                  color: AppTheme.primaryOrange,
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                ),
              ),
              Text(
                context
                    .read<LanguageProvider>()
                    .strings
                    .achievements
                    .prs1rmLabel,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
