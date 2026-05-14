import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../core/presenter/base_presenter.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/body_measurement.dart';
import '../../models/ui/ui_models.dart';
import '../../providers/workout_provider.dart';

abstract class ProgressView extends BaseView<ProgressModel> {
  @override
  void setUI(ProgressModel model);
  void showAddSheet();
}

class ProgressPresenter extends BasePresenter<ProgressView> {
  ProgressPresenter({required super.view});
  ProgressProvider? _provider;
  BuildContext? _ctx;

  @override
  void getUI(BuildContext context) {
    _ctx = context;
    if (_provider == null) {
      _provider = context.read<ProgressProvider>()
        ..addListener(_onDataChanged);
      unawaited(_provider!.loadProgress());
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
    final ProgressProvider provider = context.read<ProgressProvider>();
    view.setUI(
      ProgressModel(
        strings: s.progress,
        images: s.images,
        common: s.common,
        measurements: provider.measurements,
        sessions: provider.sessions,
        totalWorkouts: provider.totalWorkouts,
        totalMinutes: provider.totalMinutes,
        latestMeasurement: provider.latestMeasurement,
        isLoading: provider.isLoading,
      ),
    );
  }

  void onAddTap() => view.showAddSheet();

  Future<void> addMeasurement(
    BuildContext context,
    BodyMeasurement m,
  ) async {
    await context.read<ProgressProvider>().addMeasurement(m);
  }

  Future<void> deleteMeasurement(
    BuildContext context,
    BodyMeasurement m,
  ) async {
    await context.read<ProgressProvider>().deleteMeasurement(m.id!);
  }
}
