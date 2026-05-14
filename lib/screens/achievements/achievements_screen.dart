import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/achievement.dart';
import '../../providers/pr_streak_provider.dart';
import '../../theme/app_theme.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    unawaited(context.read<PrStreakProvider>().loadAll());
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRs & Logros'),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: AppTheme.primaryOrange,
          labelColor: AppTheme.primaryOrange,
          unselectedLabelColor: AppTheme.textSecondary,
          tabs: const <Widget>[
            Tab(text: '🏆 PRs'),
            Tab(text: '🔥 Racha'),
            Tab(text: '🎖️ Logros'),
          ],
        ),
      ),
      body: Consumer<PrStreakProvider>(
        builder: (BuildContext context, PrStreakProvider provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryOrange,
              ),
            );
          }
          return TabBarView(
            controller: _tab,
            children: <Widget>[
              _PrTab(provider: provider),
              _StreakTab(provider: provider),
              _AchievementsTab(provider: provider),
            ],
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// PRs TAB
// ──────────────────────────────────────────────────────────────────
class _PrTab extends StatefulWidget {
  const _PrTab({required this.provider});
  final PrStreakProvider provider;

  @override
  State<_PrTab> createState() => _PrTabState();
}

class _PrTabState extends State<_PrTab> {
  String? _selectedExercise;

  @override
  Widget build(BuildContext context) {
    final Map<String, PersonalRecord> bestPrs =
        widget.provider.bestPrByExercise;
    if (bestPrs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('🏆', style: TextStyle(fontSize: 50)),
            SizedBox(height: 12),
            Text(
              'Sin PRs aún',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Completa tu primer entreno para\nregistrar tus récords personales',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        if (_selectedExercise != null) ...<Widget>[
          _OneRmChart(
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
        Text(
          _selectedExercise == null
              ? 'Tus mejores marcas'
              : 'Toca otro ejercicio o el mismo para deseleccionar',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        ...bestPrs.entries.map((MapEntry<String, PersonalRecord> e) {
          final bool isSelected = _selectedExercise == e.key;
          return GestureDetector(
            onTap: () => setState(() {
              _selectedExercise = isSelected ? null : e.key;
            }),
            child: _PrCard(pr: e.value, isSelected: isSelected),
          );
        }),
        const SizedBox(height: 60),
      ],
    );
  }
}

class _PrCard extends StatelessWidget {
  const _PrCard({required this.pr, this.isSelected = false});
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
              const Text(
                '1RM est.',
                style: TextStyle(
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

class _OneRmChart extends StatelessWidget {
  const _OneRmChart({required this.exerciseName, required this.prs});
  final String exerciseName;
  final List<PersonalRecord> prs;

  @override
  Widget build(BuildContext context) {
    if (prs.length < 2) {
      return const SizedBox.shrink();
    }

    final List<PersonalRecord> sorted = <PersonalRecord>[...prs]..sort(
        (PersonalRecord a, PersonalRecord b) =>
            a.achievedAt.compareTo(b.achievedAt),
      );
    final List<FlSpot> spots = sorted
        .asMap()
        .entries
        .map(
          (MapEntry<int, PersonalRecord> e) =>
              FlSpot(e.key.toDouble(), e.value.estimated1rm),
        )
        .toList();

    final double minY = spots
            .map((FlSpot s) => s.y)
            .reduce((double a, double b) => a < b ? a : b) -
        5;
    final double maxY = spots
            .map((FlSpot s) => s.y)
            .reduce((double a, double b) => a > b ? a : b) +
        5;

    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.primaryOrange.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$exerciseName — Progresión 1RM',
            style: const TextStyle(
              color: AppTheme.primaryOrange,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      getTitlesWidget: (double v, _) => Text(
                        '${v.toInt()}kg',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                ),
                minY: minY,
                maxY: maxY,
                lineBarsData: <LineChartBarData>[
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppTheme.primaryOrange,
                    barWidth: 2.5,
                    dotData: FlDotData(
                      getDotPainter: (_, __, ___, ____) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// STREAK TAB
// ──────────────────────────────────────────────────────────────────
class _StreakTab extends StatelessWidget {
  const _StreakTab({required this.provider});
  final PrStreakProvider provider;

  static const List<Map<String, Object>> _streakMilestones =
      <Map<String, Object>>[
    <String, Object>{'days': 3, 'label': '3 días seguidos', 'emoji': '🗓️'},
    <String, Object>{'days': 7, 'label': 'Semana completa', 'emoji': '🌟'},
    <String, Object>{'days': 14, 'label': '2 semanas', 'emoji': '💪'},
    <String, Object>{'days': 21, 'label': '21 días (hábito)', 'emoji': '🧠'},
    <String, Object>{'days': 30, 'label': 'Mes de hierro', 'emoji': '🎖️'},
    <String, Object>{'days': 60, 'label': '2 meses', 'emoji': '👑'},
    <String, Object>{'days': 100, 'label': '100 días', 'emoji': '🚀'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        _StreakHeroCard(
          current: provider.currentStreak,
          longest: provider.longestStreak,
        ),
        const SizedBox(height: 20),
        _MotivationCard(streak: provider.currentStreak),
        const SizedBox(height: 20),
        const Text(
          'Metas de racha',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ..._streakMilestones.map(
          (Map<String, Object> m) => _MilestoneTile(
            days: m['days']! as int,
            label: m['label']! as String,
            emoji: m['emoji']! as String,
            current: provider.currentStreak,
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

class _StreakHeroCard extends StatelessWidget {
  const _StreakHeroCard({required this.current, required this.longest});
  final int current;
  final int longest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppTheme.primaryOrange, Color(0xFFE53935)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          const Text('🔥', style: TextStyle(fontSize: 50)),
          const SizedBox(height: 8),
          Text(
            '$current',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const Text(
            'días consecutivos',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Mejor racha: $longest días',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MotivationCard extends StatelessWidget {
  const _MotivationCard({required this.streak});
  final int streak;

  String get _message {
    if (streak == 0) {
      return '¡Empieza hoy! El primer paso es el más difícil.';
    }
    if (streak < 3) {
      return '¡Vas bien! Construye el hábito día a día.';
    }
    if (streak < 7) {
      return '¡Excelente! Ya llevas más de 3 días. No pares.';
    }
    if (streak < 14) {
      return '🔥 ¡Una semana completa! Eres imparable.';
    }
    if (streak < 30) {
      return '💪 Ya es un hábito. Tu cuerpo te lo agradece.';
    }
    return '👑 ¡Leyenda del gym! Llevas $streak días seguidos.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.emoji_events_rounded,
            color: AppTheme.primaryOrange,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _message,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  const _MilestoneTile({
    required this.days,
    required this.label,
    required this.emoji,
    required this.current,
  });
  final int days;
  final String label;
  final String emoji;
  final int current;

  @override
  Widget build(BuildContext context) {
    final bool reached = current >= days;
    final double pct = (current / days).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: reached
            ? AppTheme.success.withValues(alpha: 0.08)
            : AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: reached
              ? AppTheme.success.withValues(alpha: 0.3)
              : const Color(0xFF2A2A2A),
        ),
      ),
      child: Row(
        children: <Widget>[
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(
                    color: reached
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                    fontWeight:
                        reached ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (!reached) ...<Widget>[
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: const Color(0xFF2A2A2A),
                      color: AppTheme.primaryOrange,
                      minHeight: 4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (reached)
            const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.success,
              size: 20,
            )
          else
            Text(
              '$days días',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// ACHIEVEMENTS TAB
// ──────────────────────────────────────────────────────────────────
class _AchievementsTab extends StatelessWidget {
  const _AchievementsTab({required this.provider});
  final PrStreakProvider provider;

  @override
  Widget build(BuildContext context) {
    final List<Achievement> achievements = provider.achievements;
    final List<Achievement> unlocked =
        achievements.where((Achievement a) => a.isUnlocked).toList();
    final List<Achievement> locked =
        achievements.where((Achievement a) => !a.isUnlocked).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Tu colección',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${unlocked.length}/${achievements.length}',
                    style: const TextStyle(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: achievements.isEmpty
                      ? 0
                      : unlocked.length / achievements.length,
                  backgroundColor: const Color(0xFF2A2A2A),
                  color: AppTheme.primaryOrange,
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (unlocked.isNotEmpty) ...<Widget>[
          const Text(
            'Desbloqueados',
            style: TextStyle(
              color: AppTheme.success,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...unlocked.map(
            (Achievement a) => _AchievementCard(achievement: a),
          ),
          const SizedBox(height: 16),
        ],

        const Text(
          'Por desbloquear',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        ...locked.map(
          (Achievement a) => _AchievementCard(achievement: a),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});
  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final bool unlocked = achievement.isUnlocked;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: unlocked
            ? AppTheme.success.withValues(alpha: 0.06)
            : AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unlocked
              ? AppTheme.success.withValues(alpha: 0.25)
              : const Color(0xFF2A2A2A),
        ),
      ),
      child: Row(
        children: <Widget>[
          Text(
            achievement.emoji,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  achievement.title,
                  style: TextStyle(
                    color: unlocked
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  achievement.description,
                  style: TextStyle(
                    color: unlocked
                        ? AppTheme.textSecondary
                        : const Color(0xFF444444),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (unlocked)
            const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.success,
              size: 20,
            ),
        ],
      ),
    );
  }
}
