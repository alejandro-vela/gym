import '../../i18n/strings/app_strings.dart';
import '../../i18n/strings/common_strings.dart';
import '../../i18n/strings/machines_strings.dart';
import '../machine.dart';

class MachinesModel {
  const MachinesModel({
    required this.strings,
    required this.images,
    required this.common,
    required this.machines,
    required this.categories,
    required this.selectedCategory,
    required this.isLoading,
  });

  final MachinesStrings strings;
  final ImagePaths images;
  final CommonStrings common;

  final List<Machine> machines;
  final List<String> categories;
  final String selectedCategory;
  final bool isLoading;
}

class MachineDetailModel {
  const MachineDetailModel({
    required this.strings,
    required this.addStrings,
    required this.common,
    required this.images,
    required this.machine,
  });

  final MachinesStrings strings;
  final AddMachineStrings addStrings;
  final CommonStrings common;
  final ImagePaths images;
  final Machine machine;
}

class AddMachineModel {
  const AddMachineModel({
    required this.strings,
    required this.machineStrings,
    required this.common,
    required this.images,
    this.existingMachine,
  });

  final AddMachineStrings strings;
  final MachinesStrings machineStrings;
  final CommonStrings common;
  final ImagePaths images;
  final Machine? existingMachine;

  bool get isEditing => existingMachine != null;
}
