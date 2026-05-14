import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../i18n/app_localizations.dart';
import '../../../i18n/language_provider.dart';
import '../../../theme/app_theme.dart';

class MachineSection extends StatelessWidget {
  const MachineSection({
    super.key,
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

class MachinePrecautionTile extends StatelessWidget {
  const MachinePrecautionTile({
    super.key,
    required this.number,
    required this.text,
  });
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

class MachineMuscleChip extends StatelessWidget {
  const MachineMuscleChip({super.key, required this.label});
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

class MachineDifficultyBadge extends StatelessWidget {
  const MachineDifficultyBadge({super.key, required this.difficulty});
  final int difficulty;

  String _label(BuildContext context) {
    final MachinesStrings s = context.read<LanguageProvider>().strings.machines;
    switch (difficulty) {
      case 1:
        return s.difficulty1;
      case 2:
        return s.difficulty2;
      case 3:
        return s.difficulty3;
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
        _label(context),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class MachinePrecautionsSection extends StatelessWidget {
  const MachinePrecautionsSection({
    super.key,
    required this.title,
    required this.precautions,
    this.precautionPhotoPath,
  });
  final String title;
  final List<String> precautions;
  final String? precautionPhotoPath;

  @override
  Widget build(BuildContext context) {
    return MachineSection(
      icon: Icons.warning_amber_rounded,
      title: title,
      color: AppTheme.warning,
      child: Column(
        children: <Widget>[
          if (precautionPhotoPath != null &&
              File(precautionPhotoPath!).existsSync())
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(precautionPhotoPath!),
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
          if (precautionPhotoPath != null) const SizedBox(height: 12),
          ...precautions.asMap().entries.map(
                (MapEntry<int, String> entry) => MachinePrecautionTile(
                  number: entry.key + 1,
                  text: entry.value,
                ),
              ),
        ],
      ),
    );
  }
}
