import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../providers/pr_streak_provider.dart';
import '../../theme/app_theme.dart';

extension MuscleStatusColor on MuscleStatus {
  Color get color {
    switch (this) {
      case MuscleStatus.fresh:
        return AppTheme.success;
      case MuscleStatus.recovering:
        return AppTheme.warning;
      case MuscleStatus.fatigued:
        return AppTheme.danger;
    }
  }

  String label(BuildContext context) {
    final RecoveryStrings recovery =
        context.read<LanguageProvider>().strings.recovery;
    switch (this) {
      case MuscleStatus.fresh:
        return recovery.legendFresh;
      case MuscleStatus.recovering:
        return recovery.legendRecovering;
      case MuscleStatus.fatigued:
        return recovery.legendFatigued;
    }
  }
}
