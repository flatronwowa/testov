import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Класс рисования
class Painter extends CustomPainter {
  Painter(this.lines);
  final List<List<Offset>> lines;

  @override
  void paint(Canvas canvas, Size size) {
    for (int lineIndex = 0; lineIndex < lines.length ?? 0; lineIndex++) {
      for (int pointIndex = 0;
          pointIndex < lines[lineIndex].length;
          pointIndex++) {
        final paint = Paint()
          ..color = Colors.black
          ..strokeWidth = 4;
        if (lines[lineIndex].length == 1) {
          canvas.drawPoints(PointMode.points, lines[lineIndex], paint);
        } else if (lines[lineIndex].length != pointIndex + 1) {
          canvas.drawLine(lines[lineIndex][pointIndex],
              lines[lineIndex][pointIndex + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
