import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../i18n/language_provider.dart';
import '../../../models/machine.dart';
import '../../../theme/app_theme.dart';

class MachineCard extends StatelessWidget {
  const MachineCard({super.key, required this.machine, required this.onTap});
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
                          child: Builder(
                            builder: (BuildContext ctx) => Text(
                              ctx
                                  .read<LanguageProvider>()
                                  .strings
                                  .machines
                                  .difficultyLabel(machine.difficulty),
                              style: TextStyle(
                                color: _difficultyColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
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
