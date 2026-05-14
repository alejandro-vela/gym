import 'dart:io';

import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class MachinePhotoPicker extends StatelessWidget {
  const MachinePhotoPicker({
    super.key,
    required this.photoPath,
    required this.label,
    required this.tapToAddLabel,
    required this.icon,
    this.color = AppTheme.primaryOrange,
    required this.onTap,
    this.height = 200,
  });
  final String? photoPath;
  final String label;
  final String tapToAddLabel;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        clipBehavior: Clip.antiAlias,
        child: photoPath != null && File(photoPath!).existsSync()
            ? Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.file(File(photoPath!), fit: BoxFit.cover),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(icon, color: color.withValues(alpha: 0.5), size: 40),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: color.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tapToAddLabel,
                    style: TextStyle(
                      color: color.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class SourceButton extends StatelessWidget {
  const SourceButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.primaryOrange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryOrange.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: <Widget>[
            Icon(icon, color: AppTheme.primaryOrange, size: 32),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.primaryOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
