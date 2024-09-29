import 'package:flutter/material.dart';

class DividePainter extends CustomPainter {

  Color color;

  DividePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    paint.strokeWidth = 1.5;

    final start = Offset(0, size.height / 2);
    final end = Offset(size.width, size.height / 2);

    canvas.drawLine(start, end, paint); // Zeichne den Strich
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}