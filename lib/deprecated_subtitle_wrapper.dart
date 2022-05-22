import 'package:flutter/material.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';
import 'package:video_player/video_player.dart';

// ignore: prefer-match-file-name, this has a different name because of the deprecation.
class SubTitleWrapper extends SubtitleWrapper {
  @Deprecated("Renamed to SubtitleWrapper")
  const SubTitleWrapper({
    Key? key,
    required Widget videoChild,
    required SubtitleController subtitleController,
    required VideoPlayerController videoPlayerController,
    SubtitleStyle subtitleStyle = const SubtitleStyle(),
    Color? backgroundColor,
  }) : super(
          key: key,
          videoChild: videoChild,
          subtitleController: subtitleController,
          videoPlayerController: videoPlayerController,
          subtitleStyle: subtitleStyle,
          backgroundColor: backgroundColor,
        );
}
