import 'dart:async';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/health_provider.dart';
import '../../services/health_service.dart';
import '../../theme/app_theme.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            const Text('Apple Watch'),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/apple_watch_icon.png',
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
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Consumer<HealthProvider>(
        builder: (BuildContext context, HealthProvider provider, _) {
          // Not yet asked
          if (provider.permissionStatus == HealthPermissionStatus.unknown) {
            return _PermissionScreen(
              onRequest: () => unawaited(provider.requestPermissions()),
            );
          }

          // Denied
          if (provider.permissionStatus == HealthPermissionStatus.denied) {
            return _PermissionDeniedScreen(
              onRetry: () => unawaited(provider.requestPermissions()),
            );
          }

          // Loading first time
          if (provider.isLoading && provider.summary == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(color: AppTheme.primaryOrange),
                  SizedBox(height: 16),
                  Text(
                    'Leyendo datos del Apple Watch...',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            );
          }

          // Error
          if (provider.error != null && provider.summary == null) {
            return _ErrorScreen(
              message: provider.error!,
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
                // ── Date & sync ─────────────────────────────
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
                            'Sincronizado ${DateFormat('HH:mm').format(DateTime.now())}',
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

                // ── Calorie Ring ─────────────────────────────
                _CalorieRing(
                  activeCalories: s.activeCalories,
                  totalCalories: s.totalCalories,
                  goal: provider.calorieGoal,
                  progress: provider.calorieProgress,
                  onGoalTap: () => _showGoalDialog(context, provider),
                ),
                const SizedBox(height: 20),

                // ── Quick stats row ──────────────────────────
                Row(
                  children: <Widget>[
                    _QuickStat(
                      icon: Icons.directions_walk_rounded,
                      label: 'Pasos',
                      value: _formatNumber(s.steps),
                      color: AppTheme.info,
                    ),
                    const SizedBox(width: 10),
                    _QuickStat(
                      icon: Icons.route_rounded,
                      label: 'Distancia',
                      value: '${s.distanceKm.toStringAsFixed(1)}km',
                      color: AppTheme.success,
                    ),
                    const SizedBox(width: 10),
                    _QuickStat(
                      icon: Icons.timer_rounded,
                      label: 'Ej. activo',
                      value: '${s.exerciseMinutes}min',
                      color: AppTheme.primaryOrange,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Heart rate ───────────────────────────────
                if (s.latestHeartRate != null) ...<Widget>[
                  _HeartRateCard(
                    latest: s.latestHeartRate!,
                    avg: s.avgHeartRate,
                    max: s.maxHeartRate,
                    samples: provider.heartRateSamples,
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Sleep ────────────────────────────────────
                if (s.sleepHours != null) ...<Widget>[
                  _SleepCard(hours: s.sleepHours!),
                  const SizedBox(height: 16),
                ],

                // ── Calories breakdown ───────────────────────
                _CaloriesBreakdown(
                  active: s.activeCalories,
                  basal: s.basalCalories,
                ),
                const SizedBox(height: 16),

                // ── Recent Workouts ──────────────────────────
                if (s.workouts.isNotEmpty) ...<Widget>[
                  const _SectionHeader(
                    title: 'Entrenos recientes del Watch',
                    icon: Icons.watch_rounded,
                  ),
                  const SizedBox(height: 8),
                  ...s.workouts
                      .take(5)
                      .map((HealthWorkout w) => _WorkoutCard(workout: w)),
                ] else ...<Widget>[
                  const _NoWorkoutsCard(),
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

  void _showGoalDialog(BuildContext context, HealthProvider provider) {
    double goal = provider.calorieGoal;
    unawaited(showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text(
          'Meta de calorías activas',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setS) => Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '${goal.round()} kcal',
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
              const Text(
                'Arrastra para ajustar tu meta diaria',
                style: TextStyle(
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
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.setCalorieGoal(goal);
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    ),);
  }
}

// ────────────────────────────────────────────────────────────────
// CALORIE RING
// ────────────────────────────────────────────────────────────────
class _CalorieRing extends StatelessWidget {
  const _CalorieRing({
    required this.activeCalories,
    required this.totalCalories,
    required this.goal,
    required this.progress,
    required this.onGoalTap,
  });
  final double activeCalories;
  final double totalCalories;
  final double goal;
  final double progress; // 0.0 – 1.0
  final VoidCallback onGoalTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        children: <Widget>[
          // Ring
          SizedBox(
            width: 120,
            height: 120,
            child: CustomPaint(
              painter: _RingPainter(progress: progress),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      activeCalories.round().toString(),
                      style: const TextStyle(
                        color: AppTheme.primaryOrange,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'kcal',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Calorías activas',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _CalorieRow(
                  label: 'Activas',
                  value: '${activeCalories.round()} kcal',
                  color: AppTheme.primaryOrange,
                ),
                _CalorieRow(
                  label: 'Total (basal)',
                  value: '${totalCalories.round()} kcal',
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onGoalTap,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: const Color(0xFF333333),
                            color: progress >= 1
                                ? AppTheme.success
                                : AppTheme.primaryOrange,
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(progress * 100).round()}%',
                        style: TextStyle(
                          color: progress >= 1
                              ? AppTheme.success
                              : AppTheme.primaryOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onGoalTap,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Meta: ${goal.round()} kcal',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.edit_rounded,
                        size: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ],
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

class _CalorieRow extends StatelessWidget {
  const _CalorieRow({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2 - 10;
    const double strokeWidth = 10.0;

    // Background ring
    final Paint bgPaint = Paint()
      ..color = const Color(0xFF2A2A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring
    final Paint progressPaint = Paint()
      ..color = progress >= 1 ? AppTheme.success : AppTheme.primaryOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress.clamp(0.0, 1.0),
        false,
        progressPaint,
      );
    }

    // Glow effect if completed
    if (progress >= 1) {
      final Paint glowPaint = Paint()
        ..color = AppTheme.success.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi,
        false,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// ────────────────────────────────────────────────────────────────
// HEART RATE CARD
// ────────────────────────────────────────────────────────────────
class _HeartRateCard extends StatelessWidget {
  const _HeartRateCard({
    required this.latest,
    this.avg,
    this.max,
    required this.samples,
  });
  final double latest;
  final double? avg;
  final double? max;
  final List<HealthSample> samples;

  Color get _zoneColor {
    if (latest < 60) {
      return AppTheme.info;
    }
    if (latest < 100) {
      return AppTheme.success;
    }
    if (latest < 140) {
      return AppTheme.warning;
    }
    return AppTheme.danger;
  }

  String get _zoneLabel {
    if (latest < 60) {
      return 'Reposo';
    }
    if (latest < 100) {
      return 'Normal';
    }
    if (latest < 140) {
      return 'Cardio moderado';
    }
    return 'Cardio intenso';
  }

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots = samples
        .asMap()
        .entries
        .map(
          (MapEntry<int, HealthSample> e) =>
              FlSpot(e.key.toDouble(), e.value.value),
        )
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _zoneColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.favorite_rounded, color: _zoneColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Frecuencia cardíaca',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _zoneColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _zoneLabel,
                  style: TextStyle(
                    color: _zoneColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              _HRStat(
                label: 'Actual',
                value: '${latest.round()}',
                unit: 'bpm',
                color: _zoneColor,
                large: true,
              ),
              if (avg != null) ...<Widget>[
                const SizedBox(width: 20),
                _HRStat(
                  label: 'Promedio',
                  value: '${avg!.round()}',
                  unit: 'bpm',
                  color: AppTheme.textSecondary,
                ),
              ],
              if (max != null) ...<Widget>[
                const SizedBox(width: 20),
                _HRStat(
                  label: 'Máximo',
                  value: '${max!.round()}',
                  unit: 'bpm',
                  color: AppTheme.danger,
                ),
              ],
            ],
          ),

          // Chart
          if (spots.length >= 3) ...<Widget>[
            const SizedBox(height: 16),
            SizedBox(
              height: 70,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  lineBarsData: <LineChartBarData>[
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: _zoneColor,
                      belowBarData: BarAreaData(
                        show: true,
                        color: _zoneColor.withValues(alpha: 0.1),
                      ),
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Últimas 8 horas',
              style: TextStyle(
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HRStat extends StatelessWidget {
  const _HRStat({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    this.large = false,
  });
  final String label;
  final String value;
  final String unit;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: large ? 32 : 20,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            const SizedBox(width: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                unit,
                style: TextStyle(
                  color: color.withValues(alpha: 0.7),
                  fontSize: large ? 13 : 11,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────
// SLEEP CARD
// ────────────────────────────────────────────────────────────────
class _SleepCard extends StatelessWidget {
  const _SleepCard({required this.hours});
  final double hours;

  Color get _sleepColor {
    if (hours >= 8) {
      return AppTheme.success;
    }
    if (hours >= 6) {
      return AppTheme.warning;
    }
    return AppTheme.danger;
  }

  String get _sleepLabel {
    if (hours >= 8) {
      return 'Óptimo 🌙';
    }
    if (hours >= 6) {
      return 'Regular';
    }
    return 'Insuficiente';
  }

  @override
  Widget build(BuildContext context) {
    final int h = hours.floor();
    final int m = ((hours - h) * 60).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _sleepColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _sleepColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.bedtime_rounded, color: _sleepColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Text(
                      'Sueño',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _sleepColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _sleepLabel,
                        style: TextStyle(
                          color: _sleepColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Text(
                      '${h}h ${m}min',
                      style: TextStyle(
                        color: _sleepColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'anoche',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
// CALORIES BREAKDOWN
// ────────────────────────────────────────────────────────────────
class _CaloriesBreakdown extends StatelessWidget {
  const _CaloriesBreakdown({required this.active, required this.basal});
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
          const _SectionHeader(
            title: 'Calorías totales quemadas',
            icon: Icons.local_fire_department_rounded,
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(
                child: _CalBreakItem(
                  label: 'Activas',
                  value: active.round(),
                  total: total,
                  color: AppTheme.primaryOrange,
                  icon: Icons.directions_run_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CalBreakItem(
                  label: 'Basales (BMR)',
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
                'Total del día: ${total.round()} kcal',
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

class _CalBreakItem extends StatelessWidget {
  const _CalBreakItem({
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

// ────────────────────────────────────────────────────────────────
// WORKOUT CARD
// ────────────────────────────────────────────────────────────────
class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({required this.workout});
  final HealthWorkout workout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.watch_rounded,
              color: AppTheme.primaryOrange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  workout.type,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${workout.durationMinutes} min · ${workout.calories.round()} kcal',
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
                DateFormat('d MMM').format(workout.date),
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
              Text(
                DateFormat('HH:mm').format(workout.date),
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
// HELPERS
// ────────────────────────────────────────────────────────────────
class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: <Widget>[
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});
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

class _NoWorkoutsCard extends StatelessWidget {
  const _NoWorkoutsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        children: <Widget>[
          Icon(
            Icons.watch_off_rounded,
            color: AppTheme.textSecondary,
            size: 36,
          ),
          SizedBox(height: 8),
          Text(
            'Sin entrenos esta semana',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          Text(
            'Los entrenos del Apple Watch aparecerán aquí',
            style: TextStyle(color: Color(0xFF555555), fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
// PERMISSION SCREENS
// ────────────────────────────────────────────────────────────────
class _PermissionScreen extends StatelessWidget {
  const _PermissionScreen({required this.onRequest});
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[AppTheme.primaryOrange, Color(0xFFFF3B30)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.watch_rounded,
                color: Colors.white,
                size: 52,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Conectar Apple Watch',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'GymTrack Pro puede leer tus datos de salud sincronizados desde el Apple Watch:',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ...<String>[
              '🔥 Calorías activas y basales del día',
              '❤️ Frecuencia cardíaca en tiempo real',
              '👣 Pasos y distancia recorrida',
              '⏱️ Minutos de ejercicio activo',
              '😴 Calidad del sueño',
              '💪 Historial de entrenos del Watch',
            ].map(
              (String item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: <Widget>[
                    Text(
                      item,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRequest,
                icon: const Icon(Icons.health_and_safety_rounded),
                label: const Text('Permitir acceso a Apple Salud'),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tus datos nunca salen del dispositivo.\nSolo lectura, nunca escritura sin permiso.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF555555), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionDeniedScreen extends StatelessWidget {
  const _PermissionDeniedScreen({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.block_rounded, color: AppTheme.danger, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Acceso denegado',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ve a Ajustes → Privacidad → Salud → GymTrack Pro y activa los permisos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Intentar de nuevo'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.error_outline_rounded,
            color: AppTheme.warning,
            size: 50,
          ),
          const SizedBox(height: 12),
          const Text(
            'Error al cargar datos',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
