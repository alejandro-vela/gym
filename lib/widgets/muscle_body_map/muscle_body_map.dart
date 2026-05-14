import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../i18n/app_localizations.dart';
import '../../i18n/language_provider.dart';
import '../../providers/pr_streak_provider.dart';
import '../../theme/app_theme.dart';
import 'body_diagram.dart';
import 'muscle_detail.dart';
import 'muscle_legend.dart';
export 'muscle_status_color.dart';

/// Interactive muscle body map widget
class MuscleBodyMap extends StatefulWidget {
  const MuscleBodyMap({
    super.key,
    required this.muscleStatus,
    required this.recoveryPercents,
  });
  final Map<String, MuscleStatus> muscleStatus;
  final Map<String, double> recoveryPercents;

  @override
  State<MuscleBodyMap> createState() => _MuscleBodyMapState();
}

class _MuscleBodyMapState extends State<MuscleBodyMap>
    with SingleTickerProviderStateMixin {
  bool _showFront = true;
  String? _tappedMuscle;
  late AnimationController _flipCtrl;
  late Animation<double> _flipAnim;

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    super.dispose();
  }

  MuscleStatus _status(String muscle) =>
      widget.muscleStatus[muscle] ?? MuscleStatus.fresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Builder(
          builder: (BuildContext ctx) {
            final RecoveryStrings rs =
                ctx.read<LanguageProvider>().strings.recovery;
            return Container(
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MuscleToggleBtn(
                    label: rs.frontView,
                    selected: _showFront,
                    onTap: () => setState(() => _showFront = true),
                  ),
                  MuscleToggleBtn(
                    label: rs.backView,
                    selected: !_showFront,
                    onTap: () => setState(() => _showFront = false),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        AnimatedBuilder(
          animation: _flipAnim,
          builder: (_, Widget? child) {
            final double angle = _flipAnim.value * math.pi;
            final bool isFront =
                angle < math.pi / 2 ? _showFront : !_showFront;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(angle),
              child: BodyDiagram(
                front: isFront,
                muscleStatus: widget.muscleStatus,
                recoveryPercents: widget.recoveryPercents,
                onMuscleTap: (String m) => setState(
                  () => _tappedMuscle = _tappedMuscle == m ? null : m,
                ),
                tappedMuscle: _tappedMuscle,
              ),
            );
          },
        ),
        const SizedBox(height: 8),

        if (_tappedMuscle != null)
          MuscleDetail(
            muscle: _tappedMuscle!,
            status: _status(_tappedMuscle!),
            recoveryPct: widget.recoveryPercents[_tappedMuscle!] ?? 1.0,
          ),

        const SizedBox(height: 12),
        Builder(
          builder: (BuildContext ctx) {
            final RecoveryStrings rs =
                ctx.read<LanguageProvider>().strings.recovery;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MuscleLegendDot(
                  color: AppTheme.success,
                  label: rs.legendFresh,
                ),
                const SizedBox(width: 16),
                MuscleLegendDot(
                  color: AppTheme.warning,
                  label: rs.legendRecovering,
                ),
                const SizedBox(width: 16),
                MuscleLegendDot(
                  color: AppTheme.danger,
                  label: rs.legendFatigued,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
