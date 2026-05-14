import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class PrecautionsList extends StatelessWidget {
  const PrecautionsList({
    super.key,
    required this.precautions,
    required this.onDismiss,
  });
  final List<String> precautions;
  final ValueChanged<int> onDismiss;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: precautions
          .asMap()
          .entries
          .map(
            (MapEntry<int, String> e) => Dismissible(
              key: Key('prec_${e.key}'),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => onDismiss(e.key),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                color: AppTheme.danger.withValues(alpha: 0.2),
                child: const Icon(
                  Icons.delete_rounded,
                  color: AppTheme.danger,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.warning.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.warning_rounded,
                      color: AppTheme.warning,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        e.value,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
