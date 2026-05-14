import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../core/presenter/base_presenter.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/machine.dart';
import '../../models/routine_exercise.dart';
import '../../models/ui/ui_models.dart';
import '../../providers/machines_provider.dart';
import '../../providers/routine_provider.dart';

abstract class AddExerciseView extends BaseView<AddExerciseModel> {
  @override
  void setUI(AddExerciseModel model);
  void navigateBack();
}

class AddExercisePresenter extends BasePresenter<AddExerciseView> {
  AddExercisePresenter({
    required super.view,
    required this.dayOfWeek,
    this.existingExercise,
  });
  final int dayOfWeek;
  final RoutineExercise? existingExercise;

  @override
  void getUI(BuildContext context) {
    final AppLocalizations s = context.read<LanguageProvider>().strings;
    final List<Machine> machines = context.read<MachinesProvider>().machines;
    view.setUI(
      AddExerciseModel(
        strings: s.addExercise,
        common: s.common,
        routineStrings: s.routine,
        dayOfWeek: dayOfWeek,
        availableMachines: machines,
        existingExercise: existingExercise,
      ),
    );
  }

  Future<void> save(BuildContext context, RoutineExercise exercise) async {
    final RoutineProvider provider = context.read<RoutineProvider>();
    if (existingExercise != null) {
      await provider.updateExercise(exercise);
    } else {
      await provider.addExercise(exercise);
    }
    view.navigateBack();
  }
}
