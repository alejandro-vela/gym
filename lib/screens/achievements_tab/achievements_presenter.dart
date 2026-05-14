import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../core/presenter/base_presenter.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/achievement.dart';
import '../../models/ui/ui_models.dart';
import '../../providers/pr_streak_provider.dart';

abstract class AchievementsView extends BaseView<AchievementsModel> {
  @override
  void setUI(AchievementsModel model);
}

class AchievementsPresenter extends BasePresenter<AchievementsView> {
  AchievementsPresenter({required super.view});
  PrStreakProvider? _provider;
  BuildContext? _ctx;

  @override
  void getUI(BuildContext context) {
    _ctx = context;
    if (_provider == null) {
      _provider = context.read<PrStreakProvider>()
        ..addListener(_onDataChanged);
      unawaited(_provider!.loadAll());
    }
    _buildAndDeliver(context);
  }

  @override
  void dispose() {
    _provider?.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (_ctx != null) {
      _buildAndDeliver(_ctx!);
    }
  }

  void _buildAndDeliver(BuildContext context) {
    final AppLocalizations s = context.read<LanguageProvider>().strings;
    final PrStreakProvider provider = context.read<PrStreakProvider>();
    final List<Achievement> achievements = provider.achievements;

    view.setUI(
      AchievementsModel(
        strings: s.achievements,
        images: s.images,
        common: s.common,
        allPrs: provider.allPrs,
        bestPrByExercise: provider.bestPrByExercise,
        currentStreak: provider.currentStreak,
        longestStreak: provider.longestStreak,
        achievements: achievements,
        unlocked:
            achievements.where((Achievement a) => a.isUnlocked).toList(),
        locked:
            achievements.where((Achievement a) => !a.isUnlocked).toList(),
        isLoading: provider.isLoading,
      ),
    );
  }
}
