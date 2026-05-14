import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../models/machine.dart';
import '../../providers/machines_provider.dart';
import '../../theme/app_theme.dart';
import 'add_edit_machine_screen.dart';
import 'widgets/machine_info_section.dart';

class MachineDetailScreen extends StatelessWidget {
  const MachineDetailScreen({super.key, required this.machine});
  final Machine machine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () {
                  unawaited(
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            AddEditMachineScreen(machine: machine),
                      ),
                    ).then((_) {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded, color: AppTheme.danger),
                onPressed: () => _confirmDelete(context),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: machine.photoPath != null &&
                      File(machine.photoPath!).existsSync()
                  ? Image.file(
                      File(machine.photoPath!),
                      fit: BoxFit.cover,
                    )
                  : const ColoredBox(
                      color: AppTheme.cardDark,
                      child: Center(
                        child: Icon(
                          Icons.fitness_center_rounded,
                          color: Color(0xFF333333),
                          size: 80,
                        ),
                      ),
                    ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            machine.name,
                            style:
                                Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            machine.category,
                            style: const TextStyle(
                              color: AppTheme.primaryOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    MachineDifficultyBadge(difficulty: machine.difficulty),
                  ],
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: machine.muscleGroups
                      .map((String g) => MachineMuscleChip(label: g))
                      .toList(),
                ),
                const SizedBox(height: 20),

                MachineSection(
                  icon: Icons.info_outline_rounded,
                  title: context.read<LanguageProvider>().strings.machines.detailDescription,
                  child: Text(
                    machine.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                MachineSection(
                  icon: Icons.play_circle_outline_rounded,
                  title: context.read<LanguageProvider>().strings.machines.detailHowToUse,
                  color: AppTheme.info,
                  child: Text(
                    machine.howToUse,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (machine.precautions.isNotEmpty) ...<Widget>[
                  MachinePrecautionsSection(
                    title: context.read<LanguageProvider>().strings.machines.detailPrecautions,
                    precautions: machine.precautions,
                    precautionPhotoPath: machine.precautionPhotoPath,
                  ),
                ],
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final MachinesStrings s = context.read<LanguageProvider>().strings.machines;
    final CommonStrings cs = context.read<LanguageProvider>().strings.common;
    unawaited(showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: Text(
          s.confirmDeleteTitle,
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          s.confirmDeleteBody.replaceAll('{name}', machine.name),
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(cs.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.danger,
            ),
            onPressed: () async {
              await context
                  .read<MachinesProvider>()
                  .deleteMachine(machine.id!);
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: Text(cs.delete),
          ),
        ],
      ),
    ),);
  }
}
