import 'package:flutter/material.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';

const _defaultFontSize = 16.0;

class SubtitleStyle {
  const SubtitleStyle({
    this.hasBorder = false,
    this.borderStyle = const SubtitleBorderStyle(),
    this.fontSize = _defaultFontSize,
    this.fontWeight = FontWeight.normal,
    this.textColor = Colors.black,
    this.position = const SubtitlePosition(),
  });
  final bool hasBorder;
  final SubtitleBorderStyle borderStyle;
  final double fontSize;

  /// The font weight to use for the subtitle text.
  /// Defaults to [FontWeight.normal].
  ///
  /// This is not used when [hasBorder] is true.
  final FontWeight fontWeight;
  final Color textColor;
  final SubtitlePosition position;
}
