library subtitle_wrapper_package;

import 'package:flutter/material.dart';
import 'package:subtitle_wrapper_package/models/style/subtitle_style.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';
import 'package:subtitle_wrapper_package/subtitle_text_view.dart';
import 'package:video_player/video_player.dart';

class SubTitleWrapper extends StatelessWidget {
  final Widget videoChild;
  final SubtitleController subtitleController;
  final VideoPlayerController videoPlayerController;
  final SubtitleStyle subtitleStyle;

  SubTitleWrapper(
      {Key key,
      @required this.videoChild,
      @required this.subtitleController,
      @required this.videoPlayerController,
      this.subtitleStyle = const SubtitleStyle()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        videoChild,
        subtitleController.showSubtitles
            ? Positioned(
                top: subtitleStyle.position.top,
                bottom: subtitleStyle.position.bottom,
                left: subtitleStyle.position.left,
                right: subtitleStyle.position.right,
                child: SubtitleTextView(
                  subtitleController: subtitleController,
                  videoPlayerController: videoPlayerController,
                  subtitleStyle: subtitleStyle,
                ),
              )
            : Container(
                child: null,
              )
      ],
    );
  }
}
