import 'package:flutter/foundation.dart';

import '../models/machine.dart';
import '../services/database_service.dart';

class MachinesProvider extends ChangeNotifier {
  List<Machine> _machines = <Machine>[];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'Todas';

  List<Machine> get machines => _filteredMachines;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<Machine> get _filteredMachines {
    return _machines.where((Machine m) {
      final bool matchesSearch = _searchQuery.isEmpty ||
          m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.muscleGroups.any(
            (String g) => g.toLowerCase().contains(_searchQuery.toLowerCase()),
          );
      final bool matchesCategory =
          _selectedCategory == 'Todas' || m.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> loadMachines() async {
    _isLoading = true;
    notifyListeners();
    _machines = await DatabaseService.instance.getAllMachines();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMachine(Machine machine) async {
    final int id = await DatabaseService.instance.insertMachine(machine);
    _machines.add(machine.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateMachine(Machine machine) async {
    await DatabaseService.instance.updateMachine(machine);
    final int idx = _machines.indexWhere((Machine m) => m.id == machine.id);
    if (idx != -1) {
      _machines[idx] = machine;
      notifyListeners();
    }
  }

  Future<void> deleteMachine(int id) async {
    await DatabaseService.instance.deleteMachine(id);
    _machines.removeWhere((Machine m) => m.id == id);
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
