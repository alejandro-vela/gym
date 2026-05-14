import 'package:flutter/material.dart';

import '../../providers/pr_streak_provider.dart';
import 'body_outline_painter.dart';
import 'muscle_region.dart';
import 'muscle_status_color.dart';

class BodyDiagram extends StatelessWidget {
  const BodyDiagram({
    super.key,
    required this.front,
    required this.muscleStatus,
    required this.recoveryPercents,
    required this.onMuscleTap,
    required this.tappedMuscle,
  });
  final bool front;
  final Map<String, MuscleStatus> muscleStatus;
  final Map<String, double> recoveryPercents;
  final ValueChanged<String> onMuscleTap;
  final String? tappedMuscle;

  MuscleStatus _s(String m) => muscleStatus[m] ?? MuscleStatus.fresh;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 380,
      child: CustomPaint(
        painter: BodyOutlinePainter(front: front),
        child: Stack(
          children: front ? _frontMuscles() : _backMuscles(),
        ),
      ),
    );
  }

  // ignore: avoid-returning-widgets
  List<Widget> _frontMuscles() => <Widget>[
        MuscleRegion(
          left: 85,
          top: 8,
          width: 50,
          height: 50,
          shape: BoxShape.circle,
          color: Colors.transparent,
          label: '',
          onTap: (_) {},
        ),
        MuscleRegion(
          left: 28,
          top: 72,
          width: 38,
          height: 28,
          label: 'Hombros',
          color: _s('Hombros').color,
          isSelected: tappedMuscle == 'Hombros',
          onTap: onMuscleTap,
        ),
        MuscleRegion(
          left: 154,
          top: 72,
          width: 38,
          height: 28,
          label: '',
          color: _s('Hombros').color,
          isSelected: tappedMuscle == 'Hombros',
          onTap: (_) => onMuscleTap('Hombros'),
        ),
        MuscleRegion(
          left: 62,
          top: 74,
          width: 96,
          height: 52,
          label: 'Pecho',
          color: _s('Pecho').color,
          isSelected: tappedMuscle == 'Pecho',
          onTap: onMuscleTap,
        ),
        MuscleRegion(
          left: 12,
          top: 108,
          width: 28,
          height: 60,
          label: 'Bíceps',
          color: _s('Bíceps').color,
          isSelected: tappedMuscle == 'Bíceps',
          onTap: onMuscleTap,
        ),
        MuscleRegion(
          left: 180,
          top: 108,
          width: 28,
          height: 60,
          label: '',
          color: _s('Bíceps').color,
          isSelected: tappedMuscle == 'Bíceps',
          onTap: (_) => onMuscleTap('Bíceps'),
        ),
        MuscleRegion(
          left: 70,
          top: 132,
          width: 80,
          height: 80,
          label: 'Abdomen',
          color: _s('Abdomen').color,
          isSelected: tappedMuscle == 'Abdomen',
          onTap: onMuscleTap,
        ),
        MuscleRegion(
          left: 54,
          top: 222,
          width: 48,
          height: 90,
          label: 'Cuádriceps',
          color: _s('Cuádriceps').color,
          isSelected: tappedMuscle == 'Cuádriceps',
          onTap: onMuscleTap,
        ),
        MuscleRegion(
          left: 118,
          top: 222,
          width: 48,
          height: 90,
          label: '',
          color: _s('Cuádriceps').color,
          isSelected: tappedMuscle == 'Cuádriceps',
          onTap: (_) => onMuscleTap('Cuádriceps'),
        ),
        MuscleRegion(
          left: 58,
          top: 322,
          width: 40,
          height: 52,
          label: 'Pantorrillas',
          color: _s('Pantorrillas').color,
          isSelected: tappedMuscle == 'Pantorrillas',
          onTap: onMuscleTap,
        ),
        MuscleRegion(
          left: 122,
          top: 322,
          width: 40,
          height: 52,
          label: '',
          color: _s('Pantorrillas').color,
          isSelected: tappedMuscle == 'Pantorrillas',
          onTap: (_) => onMuscleTap('Pantorrillas'),
        ),
      ];

  // ignore: avoid-returning-widgets
  List<Widget> _backMuscles() => <Widget>[
        MuscleRegion(
          left: 75,
          top: 68,
          width: 70,
          height: 32,
          label: 'Trapecio',
          color: _s('Trapecio').color,
          isSelected: tappedMuscle == 'Trapecio',
          onTap: onMuscleTap,
        ),
        MuscleRegion(
          left: 28,
          top: 72,
          width: 38,
          height: 28,
          label: 'Hombros',
          color: _s('Hombros').color,
          isSelected: tappedMuscle == 'Hombros',
          onTap: onMuscleTap,
        ),
        MuscleRegion(
          left: 154,
          top: 72,
          width: 38,
          height: 28,
          label: '',
          color: _s('Hombros').color,
          isSelected: tappedMuscle == 'Hombros',
          onTap: (_) => onMuscleTap('Hombros'),
        ),
        MuscleRegion(
          left: 55,
          top: 105,
          width: 110,
          height: 100,
          label: 'Espalda',
          color: _s('Espalda').color,
          isSelected: tappedMuscle == 'Espalda',
          onTap: onMuscleTap,
        ),
        MuscleRegion(
          left: 12,
          top: 108,
          width: 28,
          height: 60,
          label: 'Tríceps',
          color: _s('Tríceps').color,
          isSelected: tappedMuscle == 'Tríceps',
          onTap: onMuscleTap,
        ),
        MuscleRegion(
          left: 180,
          top: 108,
          width: 28,
          height: 60,
          label: '',
          color: _s('Tríceps').color,
          isSelected: tappedMuscle == 'Tríceps',
          onTap: (_) => onMuscleTap('Tríceps'),
        ),
        MuscleRegion(
          left: 62,
          top: 214,
          width: 96,
          height: 54,
          label: 'Glúteos',
          color: _s('Glúteos').color,
          isSelected: tappedMuscle == 'Glúteos',
          onTap: onMuscleTap,
        ),
        MuscleRegion(
          left: 54,
          top: 274,
          width: 48,
          height: 80,
          label: 'Isquio',
          color: _s('Isquiotibiales').color,
          isSelected: tappedMuscle == 'Isquiotibiales',
          onTap: (_) => onMuscleTap('Isquiotibiales'),
        ),
        MuscleRegion(
          left: 118,
          top: 274,
          width: 48,
          height: 80,
          label: '',
          color: _s('Isquiotibiales').color,
          isSelected: tappedMuscle == 'Isquiotibiales',
          onTap: (_) => onMuscleTap('Isquiotibiales'),
        ),
        MuscleRegion(
          left: 58,
          top: 358,
          width: 40,
          height: 18,
          label: '',
          color: _s('Pantorrillas').color,
          isSelected: tappedMuscle == 'Pantorrillas',
          onTap: (_) => onMuscleTap('Pantorrillas'),
        ),
        MuscleRegion(
          left: 122,
          top: 358,
          width: 40,
          height: 18,
          label: '',
          color: _s('Pantorrillas').color,
          isSelected: tappedMuscle == 'Pantorrillas',
          onTap: (_) => onMuscleTap('Pantorrillas'),
        ),
      ];
}
