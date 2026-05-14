import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/presenter/base_presenter.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/ui/ui_models.dart';
import '../../providers/health_provider.dart';

abstract class HealthView extends BaseView<HealthModel> {
  @override
  void setUI(HealthModel model);
}

class HealthPresenter extends BasePresenter<HealthView> {
  HealthPresenter({required super.view});
  HealthProvider? _provider;
  BuildContext? _ctx;

  @override
  void getUI(BuildContext context) {
    _ctx = context;
    if (_provider == null) {
      _provider = context.read<HealthProvider>()
        ..addListener(_onDataChanged);
      unawaited(_provider!.initialize());
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
    final HealthProvider provider = context.read<HealthProvider>();
    final String timeLabel = s.health.syncedTime(
      DateFormat('HH:mm').format(DateTime.now()),
    );

    view.setUI(
      HealthModel(
        strings: s.health,
        images: s.images,
        common: s.common,
        permissionStatus: provider.permissionStatus,
        summary: provider.summary,
        heartRateSamples: provider.heartRateSamples,
        isLoading: provider.isLoading,
        error: provider.error,
        calorieGoal: provider.calorieGoal,
        calorieProgress: provider.calorieProgress,
        syncedTimeLabel: timeLabel,
      ),
    );
  }

  Future<void> requestPermissions(BuildContext context) async {
    await context.read<HealthProvider>().requestPermissions();
  }

  @override
  Future<void> refresh(BuildContext context) async {
    await context.read<HealthProvider>().refresh();
  }

  void setCalorieGoal(BuildContext context, double goal) {
    context.read<HealthProvider>().setCalorieGoal(goal);
  }
}
