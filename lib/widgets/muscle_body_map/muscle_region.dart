import 'package:flutter/material.dart';

class MuscleRegion extends StatelessWidget {
  const MuscleRegion({
    super.key,
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
