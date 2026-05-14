import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/machine.dart';
import '../../providers/machines_provider.dart';
import '../../theme/app_theme.dart';
import 'add_edit_machine_screen.dart';
import 'machine_detail_screen.dart';

class MachinesScreen extends StatelessWidget {
  const MachinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Máquinas'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              final MachinesProvider provider =
                  context.read<MachinesProvider>();
              unawaited(
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const AddEditMachineScreen(),
                  ),
                ).then((_) => unawaited(provider.loadMachines())),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: context.read<MachinesProvider>().setSearchQuery,
              decoration: const InputDecoration(
                hintText: 'Buscar máquinas o músculos...',
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const _CategoryFilter(),
          const SizedBox(height: 8),
          Expanded(
            child: Consumer<MachinesProvider>(
              builder: (BuildContext context, MachinesProvider provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryOrange,
                    ),
                  );
                }
                if (provider.machines.isEmpty) {
                  return const _EmptyState();
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: provider.machines.length,
                  itemBuilder: (_, int i) => _MachineCard(
                    machine: provider.machines[i],
                    onTap: () => unawaited(
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => MachineDetailScreen(
                            machine: provider.machines[i],
                          ),
                        ),
                      ).then((_) => unawaited(provider.loadMachines())),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final MachinesProvider provider = context.read<MachinesProvider>();
          unawaited(
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const AddEditMachineScreen(),
              ),
            ).then((_) => unawaited(provider.loadMachines())),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva máquina'),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter();

  static const List<String> _categories = <String>[
    'Todas',
    ...kCategories,
  ];

  @override
  Widget build(BuildContext context) {
    final String selected = context.watch<MachinesProvider>().selectedCategory;
    return SizedBox(
      height: 36,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (_, int i) {
          final String cat = _categories[i];
          final bool isSelected = cat == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => context.read<MachinesProvider>().setCategory(cat),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryOrange
                      : AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryOrange
                        : const Color(0xFF333333),
                  ),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    color:
                        isSelected ? Colors.white : AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MachineCard extends StatelessWidget {
  const _MachineCard({required this.machine, required this.onTap});
  final Machine machine;
  final VoidCallback onTap;

  Color get _difficultyColor {
    switch (machine.difficulty) {
      case 1:
        return AppTheme.success;
      case 2:
        return AppTheme.warning;
      case 3:
        return AppTheme.danger;
      default:
        return AppTheme.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Photo area
            Expanded(
              flex: 3,
              child: machine.photoPath != null &&
                      File(machine.photoPath!).existsSync()
                  ? Image.file(
                      File(machine.photoPath!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : const ColoredBox(
                      color: Color(0xFF1E1E1E),
                      child: Center(
                        child: Icon(
                          Icons.fitness_center_rounded,
                          color: Color(0xFF444444),
                          size: 44,
                        ),
                      ),
                    ),
            ),
            // Info area
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      machine.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      machine.muscleGroups.take(2).join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _difficultyColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            machine.difficultyLabel,
                            style: TextStyle(
                              color: _difficultyColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (machine.precautions.isNotEmpty)
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: AppTheme.warning,
                            size: 14,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.fitness_center_rounded,
              color: AppTheme.primaryOrange,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sin máquinas registradas',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Toma una foto a cada máquina\ny regístrala para tu rutina',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
