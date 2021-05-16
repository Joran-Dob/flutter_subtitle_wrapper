import "package:flutter/material.dart" show TextStyle, required;

class SubtitleToken {
  String? token;
  TextStyle? tokenStyle;
  String? description;
  SubtitleToken(
      {@required this.token,
      @required this.tokenStyle,
      @required this.description});
}
