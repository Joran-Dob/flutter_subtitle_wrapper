import 'package:flutter/material.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';

const _defaultFontSize = 16.0;
const _defaultFontWeight = FontWeight.normal;
class SubtitleStyle {
  const SubtitleStyle({
    this.hasBorder = false,
    this.borderStyle = const SubtitleBorderStyle(),
    this.fontSize = _defaultFontSize,
    this.fontWeight = _defaultFontWeight,
    this.textColor = Colors.black,
    this.position = const SubtitlePosition(),
  });
  final bool hasBorder;
  final SubtitleBorderStyle borderStyle;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final SubtitlePosition position;
}
