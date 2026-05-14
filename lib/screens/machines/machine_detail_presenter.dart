import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../core/presenter/base_presenter.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/machine.dart';
import '../../models/ui/ui_models.dart';
import '../../providers/machines_provider.dart';

abstract class MachineDetailView extends BaseView<MachineDetailModel> {
  @override
  void setUI(MachineDetailModel model);
  void navigateToEdit(Machine machine);
  void navigateBack();
}

class MachineDetailPresenter extends BasePresenter<MachineDetailView> {
  MachineDetailPresenter({required super.view, required this.machine});
  final Machine machine;

  @override
  void getUI(BuildContext context) {
    final AppLocalizations s = context.read<LanguageProvider>().strings;
    view.setUI(
      MachineDetailModel(
        strings: s.machines,
        addStrings: s.addMachine,
        common: s.common,
        images: s.images,
        machine: machine,
      ),
    );
  }

  Future<void> deleteMachine(BuildContext context) async {
    await context.read<MachinesProvider>().deleteMachine(machine.id!);
    view.navigateBack();
  }

  void onEditTap() => view.navigateToEdit(machine);
}
