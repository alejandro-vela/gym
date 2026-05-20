import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/ui/health_model.dart';
import '../../providers/health_provider.dart';
import '../../services/health_service.dart';
import '../../theme/app_theme.dart';
import 'health_presenter.dart';
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

class _HealthScreenState extends State<HealthScreen> implements HealthView {
  late HealthPresenter _presenter;
  HealthModel? _model;

  @override
  void initState() {
    super.initState();
    _presenter = HealthPresenter(view: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _presenter.getUI(context);
    });
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }

  @override
  void setUI(HealthModel model) {
    if (mounted) {
      setState(() => _model = model);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_model == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryOrange),
        ),
      );
    }
    final HealthModel m = _model!;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(m.strings.title),
            const SizedBox(width: 8),
            Image.asset(
              m.images.appleWatchIcon,
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
            onPressed: () => unawaited(_presenter.refresh(context)),
            tooltip: m.strings.refresh,
          ),
        ],
      ),
      body: _buildBody(m),
    );
  }

  Widget _buildBody(HealthModel m) {
    if (m.permissionStatus == HealthPermissionStatus.unknown) {
      return HealthPermissionScreen(
        strings: m.strings,
        onRequest: () => unawaited(_presenter.requestPermissions(context)),
      );
    }

    if (m.permissionStatus == HealthPermissionStatus.denied) {
      return HealthPermissionDeniedScreen(
        strings: m.strings,
        onRequest: () => unawaited(_presenter.requestPermissions(context)),
      );
    }

    if (m.isLoading && m.summary == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(color: AppTheme.primaryOrange),
            const SizedBox(height: 16),
            Text(
              m.strings.syncing,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    if (m.error != null && m.summary == null) {
      return HealthErrorView(
        title: m.strings.errorTitle,
        message: m.error!,
        retryLabel: m.common.retry,
        onRetry: () => unawaited(_presenter.refresh(context)),
      );
    }

    final TodayHealthSummary s = m.summary!;

    return RefreshIndicator(
      color: AppTheme.primaryOrange,
      backgroundColor: AppTheme.cardDark,
      onRefresh: () => _presenter.refresh(context),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: <Widget>[
          _SyncRow(
            dateLabel: DateFormat('EEEE d MMM').format(DateTime.now()),
            isLoading: m.isLoading,
            syncedLabel: m.syncedTimeLabel,
          ),
          const SizedBox(height: 20),
          HealthCalorieRing(
            strings: m.strings,
            activeCalories: s.activeCalories,
            totalCalories: s.totalCalories,
            goal: m.calorieGoal,
            progress: m.calorieProgress,
            onGoalTap: () => _showGoalDialog(context, m),
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              HealthQuickStat(
                icon: Icons.directions_walk_rounded,
                label: m.strings.statSteps,
                value: _formatNumber(s.steps),
                color: AppTheme.info,
              ),
              const SizedBox(width: 10),
              HealthQuickStat(
                icon: Icons.route_rounded,
                label: m.strings.statDistance,
                value: '${s.distanceKm.toStringAsFixed(1)}km',
                color: AppTheme.success,
              ),
              const SizedBox(width: 10),
              HealthQuickStat(
                icon: Icons.timer_rounded,
                label: m.strings.statExercise,
                value: '${s.exerciseMinutes}${m.common.min}',
                color: AppTheme.primaryOrange,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (s.latestHeartRate != null) ...<Widget>[
            HealthHeartRateCard(
              strings: m.strings,
              latest: s.latestHeartRate!,
              avg: s.avgHeartRate,
              max: s.maxHeartRate,
              samples: m.heartRateSamples,
            ),
            const SizedBox(height: 16),
          ],
          if (s.sleepHours != null) ...<Widget>[
            HealthSleepCard(strings: m.strings, hours: s.sleepHours!),
            const SizedBox(height: 16),
          ],
          HealthCaloriesBreakdown(
            strings: m.strings,
            active: s.activeCalories,
            basal: s.basalCalories,
          ),
          const SizedBox(height: 16),
          if (s.workouts.isNotEmpty) ...<Widget>[
            HealthSectionHeader(
              title: m.strings.workoutsTitle,
              icon: Icons.watch_rounded,
            ),
            const SizedBox(height: 8),
            ...s.workouts
                .take(5)
                .map((HealthWorkout w) => HealthWorkoutCard(workout: w)),
          ] else ...<Widget>[
            HealthNoWorkoutsCard(strings: m.strings),
          ],
        ],
      ),
    );
  }

  String _formatNumber(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';

  void _showGoalDialog(BuildContext context, HealthModel m) {
    double goal = m.calorieGoal;
    unawaited(
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppTheme.cardDark,
          title: Text(
            m.strings.setGoalTitle,
            style: const TextStyle(color: AppTheme.textPrimary),
          ),
          content: StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setS) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '${goal.round()} ${m.common.kcal}',
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
                  m.strings.setGoalHint,
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
              child: Text(m.common.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                _presenter.setCalorieGoal(context, goal);
                Navigator.pop(context);
              },
              child: Text(m.common.save),
            ),
          ],
        ),
      ),
    );
  }
}

class _SyncRow extends StatelessWidget {
  const _SyncRow({
    required this.dateLabel,
    required this.isLoading,
    required this.syncedLabel,
  });

  final String dateLabel;
  final bool isLoading;
  final String syncedLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          dateLabel,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
          ),
        ),
        if (isLoading)
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
                syncedLabel,
                style: const TextStyle(
                  color: AppTheme.success,
                  fontSize: 12,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
