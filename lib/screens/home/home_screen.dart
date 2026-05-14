import 'dart:async';

import 'package:flutter/material.dart';

import '../../i18n/app_localizations.dart';
import '../../models/routine_exercise.dart';
import '../../models/ui/ui_models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/language_selector.dart';
import '../../widgets/pr_widgets.dart';
import '../achievements/achievements_screen.dart';
import '../recovery/muscle_recovery_screen.dart';
import '../routine/workout_session_screen.dart';
import 'home_presenter.dart';

// ─────────────────────────────────────────────────────────────────
// HOME SCREEN  —  implements HomeView
// ─────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeView {
  late HomePresenter _presenter;
  HomeModel? _model; // null until first setUI call

  // ── Lifecycle ──────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _presenter = HomePresenter(view: this);
    // Single entry point: presenter reads context, builds model, calls setUI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _presenter.getUI(context);
    });
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }

  // ── HomeView contract ──────────────────────────────────────────

  @override
  void setUI(HomeModel model) {
    if (mounted) {
      setState(() => _model = model);
    }
  }

  @override
  void navigateToWorkout(int dayOfWeek, List<RoutineExercise> exercises) {
    unawaited(
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => WorkoutSessionScreen(
            dayOfWeek: dayOfWeek,
            exercises: exercises,
          ),
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_model == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryOrange),
        ),
      );
    }
    final HomeModel m = _model!;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildAppBar(m),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                _DateAndStreakRow(
                  model: m,
                  onWorkoutTap: () => _presenter.startWorkout(context),
                ),
                const SizedBox(height: 20),
                _StatsRow(model: m),
                const SizedBox(height: 24),
                if (m.hasActiveSession && m.sessionStart != null)
                  _ActiveSessionBanner(
                    model: m,
                    onTap: () => _presenter.startWorkout(context),
                  ),
                _TodaySectionHeader(
                  model: m,
                  onStartTap: () => _presenter.startWorkout(context),
                ),
                const SizedBox(height: 8),
                if (m.todayExercises.isEmpty)
                  _RestDayCard(model: m)
                else
                  ...m.todayExercises.map(
                    (RoutineExercise e) => _ExerciseTile(model: m, exercise: e),
                  ),
                const SizedBox(height: 24),
                _TipCard(model: m),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: avoid-returning-widgets
  SliverAppBar _buildAppBar(HomeModel m) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      actions: const <Widget>[LanguageSelectorButton()],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[AppTheme.primaryOrange, Color(0xFF1A1A1A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                m.strings.welcome,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                m.strings.appName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sub-widgets (all driven by HomeModel — zero hardcoded strings) ──

class _DateAndStreakRow extends StatelessWidget {
  const _DateAndStreakRow({required this.model, required this.onWorkoutTap});
  final HomeModel model;
  final VoidCallback onWorkoutTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: AppTheme.primaryOrange.withValues(alpha: 0.3)),
          ),
          child: Text(
            '${model.todayDayName} · ${model.todayDateLabel}',
            style: const TextStyle(
              color: AppTheme.primaryOrange,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        StreakBadge(streak: model.currentStreak),
        const SizedBox(width: 8),
        _QuickLinkBtn(
          icon: Icons.map_rounded,
          label: model.strings.quickLinkRecovery,
          color: AppTheme.warning,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const MuscleRecoveryScreen(),
            ),
          ),
        ),
        const SizedBox(width: 6),
        _QuickLinkBtn(
          icon: Icons.emoji_events_rounded,
          label: model.strings.quickLinkPrs,
          color: AppTheme.primaryOrange,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const AchievementsScreen(),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.model});
  final HomeModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _StatCard(
          icon: Icons.fitness_center_rounded,
          label: model.strings.statMachines,
          value: '${model.totalMachines}',
          color: AppTheme.primaryOrange,
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.check_circle_outline_rounded,
          label: model.strings.statWorkouts,
          value: '${model.totalWorkouts}',
          color: AppTheme.success,
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.today_rounded,
          label: model.strings.statTodayExercises,
          value: '${model.todayExercises.length}',
          color: AppTheme.info,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
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
          ],
        ),
      ),
    );
  }
}

class _TodaySectionHeader extends StatelessWidget {
  const _TodaySectionHeader({required this.model, required this.onStartTap});
  final HomeModel model;
  final VoidCallback onStartTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '${model.strings.todayLabel} — ${model.todayDayName}',
          style:
              Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18),
        ),
        if (model.todayExercises.isNotEmpty && !model.hasActiveSession)
          TextButton(
            onPressed: onStartTap,
            child: Text(model.strings.startWorkout),
          ),
      ],
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({required this.model, required this.exercise});
  final HomeModel model;
  final RoutineExercise exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.fitness_center_rounded,
              color: AppTheme.primaryOrange,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  exercise.exerciseName,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${exercise.targetSets} ${model.common.sets} × '
                  '${exercise.targetReps} ${model.common.reps} · '
                  '${exercise.targetWeight}${model.common.kg}',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
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

class _RestDayCard extends StatelessWidget {
  const _RestDayCard({required this.model});
  final HomeModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.hotel_rounded,
            color: AppTheme.textSecondary,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            model.strings.restDayTitle,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 15,
            ),
          ),
          Text(
            model.strings.restDayHint,
            style: const TextStyle(color: Color(0xFF555555), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.model});
  final HomeModel model;

  Color _colorFor(String name) {
    switch (name) {
      case 'info':
        return AppTheme.info;
      case 'success':
        return AppTheme.success;
      case 'warning':
        return AppTheme.warning;
      default:
        return AppTheme.primaryOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TipData tip = model.tipOfDay;
    final Color color = _colorFor(tip.color);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.lightbulb_rounded, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${model.strings.tipOfDay}: ${tip.title}',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tip.body,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
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

class _ActiveSessionBanner extends StatefulWidget {
  const _ActiveSessionBanner({required this.model, required this.onTap});
  final HomeModel model;
  final VoidCallback onTap;

  @override
  State<_ActiveSessionBanner> createState() => _ActiveSessionBannerState();
}

class _ActiveSessionBannerState extends State<_ActiveSessionBanner> {
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!mounted) {
      return;
    }
    setState(() {
      _elapsed = widget.model.sessionStart != null
          ? DateTime.now().difference(widget.model.sessionStart!)
          : Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _timeLabel {
    final String m = _elapsed.inMinutes.toString().padLeft(2, '0');
    final String s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s ${widget.model.strings.activeSessionElapsed}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[AppTheme.primaryOrange, AppTheme.darkOrange],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: <Widget>[
            const Icon(Icons.play_circle_rounded, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.model.strings.activeSessionTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    _timeLabel,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLinkBtn extends StatelessWidget {
  const _QuickLinkBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
