import "package:flutter/material.dart" show TextStyle;

class SubtitleToken {
  String token;
  TextStyle tokenStyle;
  String description;
  SubtitleToken(
      {required this.token,
      required this.tokenStyle,
      required this.description});
  @override
  String toString() {
    return this.token + this.tokenStyle.color.toString();
  }
}
