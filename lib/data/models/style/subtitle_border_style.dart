import 'package:flutter/material.dart';

const _defaultStrokeWidth = 2.0;

class SubtitleBorderStyle {
  final double strokeWidth;
  final PaintingStyle style;
  final Color color;

  const SubtitleBorderStyle({
    this.strokeWidth = _defaultStrokeWidth,
    this.style = PaintingStyle.stroke,
    this.color = Colors.black,
  });
}
