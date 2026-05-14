import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/machine.dart';
import '../../providers/machines_provider.dart';
import '../../theme/app_theme.dart';
import 'add_edit_machine_screen.dart';
import 'machine_detail_screen.dart';
import 'widgets/machine_card.dart';

class MachinesScreen extends StatelessWidget {
  const MachinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MachinesStrings s = context.watch<LanguageProvider>().strings.machines;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.title),
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
              decoration: InputDecoration(
                hintText: s.searchPlaceholder,
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _CategoryFilter(filterAll: s.filterAll),
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
                  return _EmptyState(
                    title: s.emptyTitle,
                    body: s.emptyBody,
                  );
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
                  itemBuilder: (_, int i) => MachineCard(
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
        label: Text(s.newMachine),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.filterAll});
  final String filterAll;

  List<String> get _categories => <String>[filterAll, ...kCategories];

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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.body});
  final String title;
  final String body;

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
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
