library subtitle_wrapper_package;

import 'package:flutter/material.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';
import 'package:subtitle_wrapper_package/subtitle_text_view.dart';
import 'package:video_player/video_player.dart';

class SubTitleWrapper extends StatefulWidget {
  final Widget videoChild;
  final SubtitleController subtitleController;
  final VideoPlayerController videoPlayerController;

  const SubTitleWrapper(
      {Key key,
      this.videoChild,
      this.subtitleController,
      this.videoPlayerController})
      : super(key: key);

  @override
  _SubTitleWrapperState createState() =>
      _SubTitleWrapperState(videoPlayerController);
}

class _SubTitleWrapperState extends State<SubTitleWrapper> {
  final VideoPlayerController videoPlayerController;

  _SubTitleWrapperState(this.videoPlayerController);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.videoChild,
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: SubtitleTextView(
            subtitleController: widget.subtitleController,
            videoPlayerController: videoPlayerController,
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {}
}
