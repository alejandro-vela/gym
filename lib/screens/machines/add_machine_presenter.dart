import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../core/presenter/base_presenter.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/machine.dart';
import '../../models/ui/ui_models.dart';
import '../../providers/machines_provider.dart';

abstract class AddMachineView extends BaseView<AddMachineModel> {
  @override
  void setUI(AddMachineModel model);
  void navigateBack();
}

class AddMachinePresenter extends BasePresenter<AddMachineView> {
  AddMachinePresenter({required super.view, this.existingMachine});
  final Machine? existingMachine;

  @override
  void getUI(BuildContext context) {
    final AppLocalizations s = context.read<LanguageProvider>().strings;
    view.setUI(
      AddMachineModel(
        strings: s.addMachine,
        machineStrings: s.machines,
        common: s.common,
        images: s.images,
        existingMachine: existingMachine,
      ),
    );
  }

  Future<void> saveMachine(BuildContext context, Machine machine) async {
    final MachinesProvider provider = context.read<MachinesProvider>();
    if (existingMachine != null) {
      await provider.updateMachine(machine);
    } else {
      await provider.addMachine(machine);
    }
    view.navigateBack();
  }
}
