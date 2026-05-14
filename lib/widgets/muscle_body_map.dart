import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/achievement.dart';
import '../providers/pr_streak_provider.dart';
import '../theme/app_theme.dart';

/// Colors per recovery status
extension MuscleStatusColor on MuscleStatus {
  Color get color {
    switch (this) {
      case MuscleStatus.fresh:
        return AppTheme.success;
      case MuscleStatus.recovering:
        return AppTheme.warning;
      case MuscleStatus.fatigued:
        return AppTheme.danger;
    }
  }

  String get label {
    switch (this) {
      case MuscleStatus.fresh:
        return 'Listo';
      case MuscleStatus.recovering:
        return 'Recuperando';
      case MuscleStatus.fatigued:
        return 'Fatigado';
    }
  }
}

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
        // Front/back toggle
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _ToggleBtn(
                label: 'Frontal',
                selected: _showFront,
                onTap: () => setState(() => _showFront = true),
              ),
              _ToggleBtn(
                label: 'Posterior',
                selected: !_showFront,
                onTap: () => setState(() => _showFront = false),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Body diagram
        AnimatedBuilder(
          animation: _flipAnim,
          builder: (_, Widget? child) {
            final double angle = _flipAnim.value * math.pi;
            final bool isFront =
                angle < math.pi / 2 ? _showFront : !_showFront;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(angle),
              child: _BodyDiagram(
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

        // Tapped muscle detail
        if (_tappedMuscle != null)
          _MuscleDetail(
            muscle: _tappedMuscle!,
            status: _status(_tappedMuscle!),
            recoveryPct: widget.recoveryPercents[_tappedMuscle!] ?? 1.0,
          ),

        // Legend
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _LegendDot(color: AppTheme.success, label: 'Listo'),
            SizedBox(width: 16),
            _LegendDot(color: AppTheme.warning, label: 'Recuperando'),
            SizedBox(width: 16),
            _LegendDot(color: AppTheme.danger, label: 'Fatigado'),
          ],
        ),
      ],
    );
  }
}

class _BodyDiagram extends StatelessWidget {
  const _BodyDiagram({
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
        painter: _BodyOutlinePainter(front: front),
        child: Stack(
          children: front ? _frontMuscles() : _backMuscles(),
        ),
      ),
    );
  }

  // ignore: avoid-returning-widgets
  List<Widget> _frontMuscles() => <Widget>[
        // HEAD
        _MuscleRegion(
          left: 85,
          top: 8,
          width: 50,
          height: 50,
          shape: BoxShape.circle,
          color: Colors.transparent,
          label: '',
          onTap: (_) {},
        ),
        // SHOULDERS
        _MuscleRegion(
          left: 28,
          top: 72,
          width: 38,
          height: 28,
          label: 'Hombros',
          color: _s('Hombros').color,
          isSelected: tappedMuscle == 'Hombros',
          onTap: onMuscleTap,
        ),
        _MuscleRegion(
          left: 154,
          top: 72,
          width: 38,
          height: 28,
          label: '',
          color: _s('Hombros').color,
          isSelected: tappedMuscle == 'Hombros',
          onTap: (_) => onMuscleTap('Hombros'),
        ),
        // CHEST
        _MuscleRegion(
          left: 62,
          top: 74,
          width: 96,
          height: 52,
          label: 'Pecho',
          color: _s('Pecho').color,
          isSelected: tappedMuscle == 'Pecho',
          onTap: onMuscleTap,
        ),
        // BICEPS L
        _MuscleRegion(
          left: 12,
          top: 108,
          width: 28,
          height: 60,
          label: 'Bíceps',
          color: _s('Bíceps').color,
          isSelected: tappedMuscle == 'Bíceps',
          onTap: onMuscleTap,
        ),
        // BICEPS R
        _MuscleRegion(
          left: 180,
          top: 108,
          width: 28,
          height: 60,
          label: '',
          color: _s('Bíceps').color,
          isSelected: tappedMuscle == 'Bíceps',
          onTap: (_) => onMuscleTap('Bíceps'),
        ),
        // ABS
        _MuscleRegion(
          left: 70,
          top: 132,
          width: 80,
          height: 80,
          label: 'Abdomen',
          color: _s('Abdomen').color,
          isSelected: tappedMuscle == 'Abdomen',
          onTap: onMuscleTap,
        ),
        // QUADS L
        _MuscleRegion(
          left: 54,
          top: 222,
          width: 48,
          height: 90,
          label: 'Cuádriceps',
          color: _s('Cuádriceps').color,
          isSelected: tappedMuscle == 'Cuádriceps',
          onTap: onMuscleTap,
        ),
        // QUADS R
        _MuscleRegion(
          left: 118,
          top: 222,
          width: 48,
          height: 90,
          label: '',
          color: _s('Cuádriceps').color,
          isSelected: tappedMuscle == 'Cuádriceps',
          onTap: (_) => onMuscleTap('Cuádriceps'),
        ),
        // CALVES L
        _MuscleRegion(
          left: 58,
          top: 322,
          width: 40,
          height: 52,
          label: 'Pantorrillas',
          color: _s('Pantorrillas').color,
          isSelected: tappedMuscle == 'Pantorrillas',
          onTap: onMuscleTap,
        ),
        // CALVES R
        _MuscleRegion(
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
        // TRAPS
        _MuscleRegion(
          left: 75,
          top: 68,
          width: 70,
          height: 32,
          label: 'Trapecio',
          color: _s('Trapecio').color,
          isSelected: tappedMuscle == 'Trapecio',
          onTap: onMuscleTap,
        ),
        // SHOULDERS
        _MuscleRegion(
          left: 28,
          top: 72,
          width: 38,
          height: 28,
          label: 'Hombros',
          color: _s('Hombros').color,
          isSelected: tappedMuscle == 'Hombros',
          onTap: onMuscleTap,
        ),
        _MuscleRegion(
          left: 154,
          top: 72,
          width: 38,
          height: 28,
          label: '',
          color: _s('Hombros').color,
          isSelected: tappedMuscle == 'Hombros',
          onTap: (_) => onMuscleTap('Hombros'),
        ),
        // LATS / BACK
        _MuscleRegion(
          left: 55,
          top: 105,
          width: 110,
          height: 100,
          label: 'Espalda',
          color: _s('Espalda').color,
          isSelected: tappedMuscle == 'Espalda',
          onTap: onMuscleTap,
        ),
        // TRICEPS L
        _MuscleRegion(
          left: 12,
          top: 108,
          width: 28,
          height: 60,
          label: 'Tríceps',
          color: _s('Tríceps').color,
          isSelected: tappedMuscle == 'Tríceps',
          onTap: onMuscleTap,
        ),
        // TRICEPS R
        _MuscleRegion(
          left: 180,
          top: 108,
          width: 28,
          height: 60,
          label: '',
          color: _s('Tríceps').color,
          isSelected: tappedMuscle == 'Tríceps',
          onTap: (_) => onMuscleTap('Tríceps'),
        ),
        // GLUTES
        _MuscleRegion(
          left: 62,
          top: 214,
          width: 96,
          height: 54,
          label: 'Glúteos',
          color: _s('Glúteos').color,
          isSelected: tappedMuscle == 'Glúteos',
          onTap: onMuscleTap,
        ),
        // HAMSTRINGS L
        _MuscleRegion(
          left: 54,
          top: 274,
          width: 48,
          height: 80,
          label: 'Isquio',
          color: _s('Isquiotibiales').color,
          isSelected: tappedMuscle == 'Isquiotibiales',
          onTap: (_) => onMuscleTap('Isquiotibiales'),
        ),
        // HAMSTRINGS R
        _MuscleRegion(
          left: 118,
          top: 274,
          width: 48,
          height: 80,
          label: '',
          color: _s('Isquiotibiales').color,
          isSelected: tappedMuscle == 'Isquiotibiales',
          onTap: (_) => onMuscleTap('Isquiotibiales'),
        ),
        // CALVES L
        _MuscleRegion(
          left: 58,
          top: 358,
          width: 40,
          height: 18,
          label: '',
          color: _s('Pantorrillas').color,
          isSelected: tappedMuscle == 'Pantorrillas',
          onTap: (_) => onMuscleTap('Pantorrillas'),
        ),
        _MuscleRegion(
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

class _MuscleRegion extends StatelessWidget {
  const _MuscleRegion({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.label,
    required this.color,
    required this.onTap,
    this.isSelected = false,
    this.shape = BoxShape.rectangle,
  });
  final double left;
  final double top;
  final double width;
  final double height;
  final String label;
  final Color color;
  final bool isSelected;
  final ValueChanged<String> onTap;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty && shape == BoxShape.rectangle) {
      // Mirror region — no label
      return Positioned(
        left: left,
        top: top,
        child: GestureDetector(
          onTap: () => onTap(label),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: color.withValues(alpha: isSelected ? 0.85 : 0.6),
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
            ),
          ),
        ),
      );
    }

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () => onTap(label),
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: isSelected ? 0.85 : 0.6),
            borderRadius: shape == BoxShape.circle
                ? BorderRadius.circular(width / 2)
                : BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: Colors.white, width: 2)
                : Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: label.isNotEmpty
              ? Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width < 50 ? 8 : 10,
                    fontWeight: FontWeight.bold,
                    shadows: const <Shadow>[
                      Shadow(color: Colors.black54, blurRadius: 4),
                    ],
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

/// Draws a simple body outline silhouette
class _BodyOutlinePainter extends CustomPainter {
  const _BodyOutlinePainter({required this.front});
  final bool front;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF2A2A2A)
      ..style = PaintingStyle.fill;

    final Paint outlinePaint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Scale helper
    double x(double v) => v / 220 * size.width;
    double y(double v) => v / 380 * size.height;

    final Path path = Path();

    // Head
    path.addOval(
      Rect.fromCenter(
        center: Offset(x(110), y(33)),
        width: x(44),
        height: y(44),
      ),
    );

    // Neck
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x(97), y(52), x(26), y(18)),
        Radius.circular(x(6)),
      ),
    );

    // Torso
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x(56), y(66), x(108), y(146)),
        Radius.circular(x(10)),
      ),
    );

    // Left arm
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x(8), y(68), x(44), y(110)),
        Radius.circular(x(14)),
      ),
    );

    // Right arm
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x(168), y(68), x(44), y(110)),
        Radius.circular(x(14)),
      ),
    );

    // Hips
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x(52), y(208), x(116), y(24)),
        Radius.circular(x(8)),
      ),
    );

    // Left leg
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x(54), y(224), x(50), x(150)),
        Radius.circular(x(12)),
      ),
    );

    // Right leg
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x(116), y(224), x(50), x(150)),
        Radius.circular(x(12)),
      ),
    );

    canvas.drawPath(path, paint);
    canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(_BodyOutlinePainter old) => old.front != front;
}

class _MuscleDetail extends StatelessWidget {
  const _MuscleDetail({
    required this.muscle,
    required this.status,
    required this.recoveryPct,
  });
  final String muscle;
  final MuscleStatus status;
  final double recoveryPct;

  @override
  Widget build(BuildContext context) {
    final Color color = status.color;
    final int hoursLeft = kMuscleRecoveryHours[muscle] != null
        ? ((1 - recoveryPct) * (kMuscleRecoveryHours[muscle]!)).round()
        : 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  muscle,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  status == MuscleStatus.fresh
                      ? '✅ Listo para entrenar'
                      : status == MuscleStatus.recovering
                          ? '⏳ ${hoursLeft}h para recuperarse'
                          : '🚫 En recuperación, evita sobreentrenar',
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            child: Column(
              children: <Widget>[
                Text(
                  '${(recoveryPct * 100).round()}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: recoveryPct,
                    backgroundColor: const Color(0xFF333333),
                    color: color,
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  const _ToggleBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppTheme.textSecondary,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
