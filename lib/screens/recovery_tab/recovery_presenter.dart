import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../core/presenter/base_presenter.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/achievement.dart';
import '../../models/ui/ui_models.dart';
import '../../providers/pr_streak_provider.dart';

abstract class RecoveryView extends BaseView<RecoveryModel> {
  @override
  void setUI(RecoveryModel model);
}

class RecoveryPresenter extends BasePresenter<RecoveryView> {
  RecoveryPresenter({required super.view});
  RecoveryProvider? _provider;
  BuildContext? _ctx;

  @override
  void getUI(BuildContext context) {
    _ctx = context;
    if (_provider == null) {
      _provider = context.read<RecoveryProvider>()
        ..addListener(_onDataChanged);
      unawaited(_provider!.loadRecovery());
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
    final RecoveryProvider provider = context.read<RecoveryProvider>();
    final DateTime now = DateTime.now();

    final Map<String, MuscleStatus> statusMap = <String, MuscleStatus>{};
    final Map<String, double> percentMap = <String, double>{};
    final Map<String, MuscleRecoveryEntry?> entryMap =
        <String, MuscleRecoveryEntry?>{};

    for (final String muscle in kMuscleRecoveryHours.keys) {
      statusMap[muscle] = provider.statusFor(muscle, now);
      percentMap[muscle] = provider.recoveryPercentFor(muscle, now);
      entryMap[muscle] = provider.latestByMuscle[muscle];
    }

    view.setUI(
      RecoveryModel(
        strings: s.recovery,
        images: s.images,
        common: s.common,
        muscleStatus: statusMap,
        recoveryPercents: percentMap,
        latestByMuscle: entryMap,
        isLoading: provider.isLoading,
        fatiguedMuscles: statusMap.entries
            .where(
              (MapEntry<String, MuscleStatus> e) =>
                  e.value == MuscleStatus.fatigued,
            )
            .map((MapEntry<String, MuscleStatus> e) => e.key)
            .toList(),
        recoveringMuscles: statusMap.entries
            .where(
              (MapEntry<String, MuscleStatus> e) =>
                  e.value == MuscleStatus.recovering,
            )
            .map((MapEntry<String, MuscleStatus> e) => e.key)
            .toList(),
      ),
    );
  }

  @override
  Future<void> refresh(BuildContext context) =>
      context.read<RecoveryProvider>().loadRecovery();
}
