import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../providers/health_provider.dart';
import '../../services/health_service.dart';
import '../../theme/app_theme.dart';
import 'widgets/health_calories_card.dart';
import 'widgets/health_error_view.dart';
import 'widgets/health_heart_rate_card.dart';
import 'widgets/health_permission_screen.dart';
import 'widgets/health_sleep_card.dart';
import 'widgets/health_workouts_card.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(context.read<HealthProvider>().initialize());
    });
  }

  @override
  Widget build(BuildContext context) {
    final HealthStrings hs = context.watch<LanguageProvider>().strings.health;
    final AppLocalizations loc = context.watch<LanguageProvider>().strings;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(hs.title),
            const SizedBox(width: 8),
            Image.asset(
              loc.images.appleWatchIcon,
              width: 20,
              height: 20,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.watch_rounded,
                color: AppTheme.primaryOrange,
                size: 20,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () =>
                unawaited(context.read<HealthProvider>().refresh()),
            tooltip: hs.refresh,
          ),
        ],
      ),
      body: Consumer<HealthProvider>(
        builder: (BuildContext context, HealthProvider provider, _) {
          if (provider.permissionStatus == HealthPermissionStatus.unknown) {
            return HealthPermissionScreen(
              strings: hs,
              onRequest: () => unawaited(provider.requestPermissions()),
            );
          }

          if (provider.permissionStatus == HealthPermissionStatus.denied) {
            return HealthPermissionDeniedScreen(
              strings: hs,
              onRequest: () => unawaited(provider.requestPermissions()),
            );
          }

          if (provider.isLoading && provider.summary == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircularProgressIndicator(color: AppTheme.primaryOrange),
                  const SizedBox(height: 16),
                  Text(
                    hs.syncing,
                    style: const TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            );
          }

          if (provider.error != null && provider.summary == null) {
            return HealthErrorView(
              title: hs.errorTitle,
              message: provider.error!,
              retryLabel: context.read<LanguageProvider>().strings.common.retry,
              onRetry: () => unawaited(provider.refresh()),
            );
          }

          final TodayHealthSummary s = provider.summary!;

          return RefreshIndicator(
            color: AppTheme.primaryOrange,
            backgroundColor: AppTheme.cardDark,
            onRefresh: provider.refresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      DateFormat('EEEE d MMM').format(DateTime.now()),
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    if (provider.isLoading)
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppTheme.primaryOrange,
                        ),
                      )
                    else
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.sync_rounded,
                            size: 14,
                            color: AppTheme.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hs.syncedTime(DateFormat('HH:mm').format(DateTime.now())),
                            style: const TextStyle(
                              color: AppTheme.success,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                HealthCalorieRing(
                  strings: hs,
                  activeCalories: s.activeCalories,
                  totalCalories: s.totalCalories,
                  goal: provider.calorieGoal,
                  progress: provider.calorieProgress,
                  onGoalTap: () => _showGoalDialog(context, provider, hs),
                ),
                const SizedBox(height: 20),

                Row(
                  children: <Widget>[
                    HealthQuickStat(
                      icon: Icons.directions_walk_rounded,
                      label: hs.statSteps,
                      value: _formatNumber(s.steps),
                      color: AppTheme.info,
                    ),
                    const SizedBox(width: 10),
                    HealthQuickStat(
                      icon: Icons.route_rounded,
                      label: hs.statDistance,
                      value: '${s.distanceKm.toStringAsFixed(1)}km',
                      color: AppTheme.success,
                    ),
                    const SizedBox(width: 10),
                    HealthQuickStat(
                      icon: Icons.timer_rounded,
                      label: hs.statExercise,
                      value: '${s.exerciseMinutes}${context.read<LanguageProvider>().strings.common.min}',
                      color: AppTheme.primaryOrange,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (s.latestHeartRate != null) ...<Widget>[
                  HealthHeartRateCard(
                    strings: hs,
                    latest: s.latestHeartRate!,
                    avg: s.avgHeartRate,
                    max: s.maxHeartRate,
                    samples: provider.heartRateSamples,
                  ),
                  const SizedBox(height: 16),
                ],

                if (s.sleepHours != null) ...<Widget>[
                  HealthSleepCard(strings: hs, hours: s.sleepHours!),
                  const SizedBox(height: 16),
                ],

                HealthCaloriesBreakdown(
                  strings: hs,
                  active: s.activeCalories,
                  basal: s.basalCalories,
                ),
                const SizedBox(height: 16),

                if (s.workouts.isNotEmpty) ...<Widget>[
                  HealthSectionHeader(
                    title: hs.workoutsTitle,
                    icon: Icons.watch_rounded,
                  ),
                  const SizedBox(height: 8),
                  ...s.workouts
                      .take(5)
                      .map((HealthWorkout w) => HealthWorkoutCard(workout: w)),
                ] else ...<Widget>[
                  HealthNoWorkoutsCard(strings: hs),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(1)}k';
    }
    return '$n';
  }

  void _showGoalDialog(
    BuildContext context,
    HealthProvider provider,
    HealthStrings hs,
  ) {
    final CommonStrings cs = context.read<LanguageProvider>().strings.common;
    double goal = provider.calorieGoal;
    unawaited(showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: Text(
          hs.setGoalTitle,
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        content: StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setS) => Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '${goal.round()} ${cs.kcal}',
                style: const TextStyle(
                  color: AppTheme.primaryOrange,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Slider(
                value: goal,
                min: 200,
                max: 1200,
                divisions: 20,
                activeColor: AppTheme.primaryOrange,
                inactiveColor: AppTheme.cardDark,
                onChanged: (double v) => setS(() => goal = v),
              ),
              Text(
                hs.setGoalHint,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(cs.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              provider.setCalorieGoal(goal);
              Navigator.pop(context);
            },
            child: Text(cs.save),
          ),
        ],
      ),
    ),);
  }
}
