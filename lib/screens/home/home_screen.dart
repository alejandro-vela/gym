import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/routine_exercise.dart';
import '../../models/ui/home_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/language_selector.dart';
import '../routine/workout_session_screen.dart';
import 'home_presenter.dart';
import 'widgets/home_active_session.dart';
import 'widgets/home_date_row.dart';
import 'widgets/home_exercise_tile.dart';
import 'widgets/home_stat_card.dart';
import 'widgets/home_tip_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeView {
  late HomePresenter _presenter;
  HomeModel? _model;

  @override
  void initState() {
    super.initState();
    _presenter = HomePresenter(view: this);
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
                HomeDateAndStreakRow(
                  model: m,
                  onWorkoutTap: () => _presenter.startWorkout(context),
                ),
                const SizedBox(height: 20),
                HomeStatsRow(model: m),
                const SizedBox(height: 24),
                if (m.hasActiveSession && m.sessionStart != null)
                  HomeActiveSessionBanner(
                    model: m,
                    onTap: () => _presenter.startWorkout(context),
                  ),
                HomeTodaySectionHeader(
                  model: m,
                  onStartTap: () => _presenter.startWorkout(context),
                ),
                const SizedBox(height: 8),
                if (m.todayExercises.isEmpty)
                  HomeRestDayCard(model: m)
                else
                  ...m.todayExercises.map(
                    (RoutineExercise e) =>
                        HomeExerciseTile(model: m, exercise: e),
                  ),
                const SizedBox(height: 24),
                HomeTipCard(model: m),
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
