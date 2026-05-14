import 'package:flutter/material.dart';

class BodyOutlinePainter extends CustomPainter {
  const BodyOutlinePainter({required this.front});
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

    double x(double v) => v / 220 * size.width;
    double y(double v) => v / 380 * size.height;

    final Path path = Path();

    path.addOval(
      Rect.fromCenter(
        center: Offset(x(110), y(33)),
        width: x(44),
        height: y(44),
      ),
    );

    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x(97), y(52), x(26), y(18)),
        Radius.circular(x(6)),
      ),
    );

    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x(56), y(66), x(108), y(146)),
        Radius.circular(x(10)),
      ),
    );

    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x(8), y(68), x(44), y(110)),
        Radius.circular(x(14)),
      ),
    );

    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x(168), y(68), x(44), y(110)),
        Radius.circular(x(14)),
      ),
    );

    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x(52), y(208), x(116), y(24)),
        Radius.circular(x(8)),
      ),
    );

    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x(54), y(224), x(50), x(150)),
        Radius.circular(x(12)),
      ),
    );

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
  bool shouldRepaint(BodyOutlinePainter old) => old.front != front;
}
