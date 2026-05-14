import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/machine.dart';
import '../../providers/machines_provider.dart';
import '../../theme/app_theme.dart';
import 'add_edit_machine_screen.dart';

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
                // Header
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
                    _DifficultyBadge(difficulty: machine.difficulty),
                  ],
                ),
                const SizedBox(height: 16),

                // Muscle groups
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: machine.muscleGroups
                      .map((String g) => _MuscleChip(label: g))
                      .toList(),
                ),
                const SizedBox(height: 20),

                // Description
                _Section(
                  icon: Icons.info_outline_rounded,
                  title: 'Descripción',
                  child: Text(
                    machine.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // How to use
                _Section(
                  icon: Icons.play_circle_outline_rounded,
                  title: 'Cómo usarla',
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

                // Precautions
                if (machine.precautions.isNotEmpty) ...<Widget>[
                  _Section(
                    icon: Icons.warning_amber_rounded,
                    title: 'Precauciones',
                    color: AppTheme.warning,
                    child: Column(
                      children: <Widget>[
                        if (machine.precautionPhotoPath != null &&
                            File(machine.precautionPhotoPath!)
                                .existsSync())
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(machine.precautionPhotoPath!),
                              width: double.infinity,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                        if (machine.precautionPhotoPath != null)
                          const SizedBox(height: 12),
                        ...machine.precautions
                            .asMap()
                            .entries
                            .map(
                              (MapEntry<int, String> entry) =>
                                  _PrecautionTile(
                                number: entry.key + 1,
                                text: entry.value,
                              ),
                            ),
                      ],
                    ),
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
    unawaited(showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text(
          'Eliminar máquina',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: Text(
          '¿Eliminar "${machine.name}"? Esta acción no se puede deshacer.',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
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
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back to list
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    ),);
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.child,
    this.color = AppTheme.primaryOrange,
  });
  final IconData icon;
  final String title;
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _PrecautionTile extends StatelessWidget {
  const _PrecautionTile({required this.number, required this.text});
  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppTheme.warning,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MuscleChip extends StatelessWidget {
  const _MuscleChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.primaryOrange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryOrange.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.primaryOrange,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});
  final int difficulty;

  String get label {
    switch (difficulty) {
      case 1:
        return 'Principiante';
      case 2:
        return 'Intermedio';
      case 3:
        return 'Avanzado';
      default:
        return '';
    }
  }

  Color get color {
    switch (difficulty) {
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
