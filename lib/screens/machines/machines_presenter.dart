import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../core/presenter/base_presenter.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/machine.dart';
import '../../models/ui/ui_models.dart';
import '../../providers/machines_provider.dart';

abstract class MachinesView extends BaseView<MachinesModel> {
  @override
  void setUI(MachinesModel model);
  void navigateToDetail(Machine machine);
  void navigateToAdd();
}

class MachinesPresenter extends BasePresenter<MachinesView> {
  MachinesPresenter({required super.view});
  MachinesProvider? _provider;
  BuildContext? _ctx;

  @override
  void getUI(BuildContext context) {
    _ctx = context;
    if (_provider == null) {
      _provider = context.read<MachinesProvider>()
        ..addListener(_onDataChanged);
      unawaited(
        _provider!.loadMachines(),
      );
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
    final MachinesProvider provider = context.read<MachinesProvider>();
    view.setUI(
      MachinesModel(
        strings: s.machines,
        images: s.images,
        common: s.common,
        machines: provider.machines,
        categories: <String>[s.machines.filterAll, ...kCategories],
        selectedCategory: provider.selectedCategory,
        isLoading: provider.isLoading,
      ),
    );
  }

  void onSearchChanged(BuildContext context, String query) {
    context.read<MachinesProvider>().setSearchQuery(query);
  }

  void onCategorySelected(BuildContext context, String category) {
    context.read<MachinesProvider>().setCategory(category);
  }

  void onMachineTap(Machine machine) => view.navigateToDetail(machine);
  void onAddTap() => view.navigateToAdd();

  Future<void> deleteMachine(BuildContext context, Machine machine) async {
    await context.read<MachinesProvider>().deleteMachine(machine.id!);
  }
}
