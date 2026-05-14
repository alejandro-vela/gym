import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/achievement.dart';
import '../../providers/pr_streak_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/muscle_body_map.dart';

class MuscleRecoveryScreen extends StatefulWidget {
  const MuscleRecoveryScreen({super.key});

  @override
  State<MuscleRecoveryScreen> createState() => _MuscleRecoveryScreenState();
}

class _MuscleRecoveryScreenState extends State<MuscleRecoveryScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<RecoveryProvider>().loadRecovery());
  }

  @override
  Widget build(BuildContext context) {
    final RecoveryStrings rs =
        context.watch<LanguageProvider>().strings.recovery;
    return Scaffold(
      appBar: AppBar(
        title: Text(rs.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () =>
                unawaited(context.read<RecoveryProvider>().loadRecovery()),
          ),
        ],
      ),
      body: Consumer<RecoveryProvider>(
        builder: (BuildContext context, RecoveryProvider provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryOrange,
              ),
            );
          }

          // Build status map for all known muscles
          final DateTime now = DateTime.now();
          final Map<String, MuscleStatus> statusMap =
              <String, MuscleStatus>{};
          final Map<String, double> percentMap = <String, double>{};

          for (final String muscle in kMuscleRecoveryHours.keys) {
            statusMap[muscle] = provider.statusFor(muscle, now);
            percentMap[muscle] = provider.recoveryPercentFor(muscle, now);
          }

          final List<String> fatiguedMuscles = statusMap.entries
              .where(
                (MapEntry<String, MuscleStatus> e) =>
                    e.value == MuscleStatus.fatigued,
              )
              .map((MapEntry<String, MuscleStatus> e) => e.key)
              .toList();

          final List<String> recoveringMuscles = statusMap.entries
              .where(
                (MapEntry<String, MuscleStatus> e) =>
                    e.value == MuscleStatus.recovering,
              )
              .map((MapEntry<String, MuscleStatus> e) => e.key)
              .toList();

          final RecoveryStrings rs =
              context.read<LanguageProvider>().strings.recovery;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              // Summary banner
              if (fatiguedMuscles.isNotEmpty)
                _AlertBanner(
                  color: AppTheme.danger,
                  icon: Icons.warning_amber_rounded,
                  title: rs.alertFatiguedTitle,
                  body: rs.fatiguedBody(fatiguedMuscles.join(', ')),
                )
              else if (recoveringMuscles.isNotEmpty)
                _AlertBanner(
                  color: AppTheme.warning,
                  icon: Icons.hourglass_bottom_rounded,
                  title: rs.alertRecoveringTitle,
                  body: rs.recoveringBody(recoveringMuscles.join(', ')),
                )
              else
                _AlertBanner(
                  color: AppTheme.success,
                  icon: Icons.check_circle_rounded,
                  title: rs.alertFreshTitle,
                  body: rs.alertFreshBody,
                ),
              const SizedBox(height: 20),

              // Body Map
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      rs.tapHint,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    MuscleBodyMap(
                      muscleStatus: statusMap,
                      recoveryPercents: percentMap,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Muscle list
              Text(
                rs.detailTitle,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...kMuscleRecoveryHours.keys.map(
                (String muscle) => _MuscleListTile(
                  muscle: muscle,
                  status: statusMap[muscle] ?? MuscleStatus.fresh,
                  percent: percentMap[muscle] ?? 1.0,
                  entry: provider.latestByMuscle[muscle],
                  strings: rs,
                ),
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  const _AlertBanner({
    required this.color,
    required this.icon,
    required this.title,
    required this.body,
  });
  final Color color;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
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

class _MuscleListTile extends StatelessWidget {
  const _MuscleListTile({
    required this.muscle,
    required this.status,
    required this.percent,
    required this.entry,
    required this.strings,
  });
  final String muscle;
  final MuscleStatus status;
  final double percent;
  final MuscleRecoveryEntry? entry;
  final RecoveryStrings strings;

  @override
  Widget build(BuildContext context) {
    final Color color = status.color;
    final int hoursTotal = kMuscleRecoveryHours[muscle] ?? 48;
    final int hoursLeft = ((1 - percent) * hoursTotal).round();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  muscle,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  entry == null
                      ? strings.noRecent
                      : status == MuscleStatus.fresh
                          ? strings.statusFresh
                          : strings.statusRecoveringHours(hoursLeft),
                  style: TextStyle(
                    color: entry == null ? AppTheme.textSecondary : color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: const Color(0xFF2A2A2A),
                color: color,
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
