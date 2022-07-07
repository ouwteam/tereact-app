import 'package:flutter/material.dart';

class CircleIndicator extends CustomPainter {
  final Color color;
  final bool asBorder;
  const CircleIndicator({required this.color, this.asBorder = false});

  @override
  void paint(Canvas canvas, Size size) {
    double dx = 8;
    double dy = 8;
    double rad = 6;
    if (asBorder) {
      rad = 8;
    }

    var paint1 = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(dx, dy), rad, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
