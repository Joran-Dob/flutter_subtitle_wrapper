import 'package:flutter/material.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper.dart';
import 'package:video_player/video_player.dart';

class SubtitleRoutePage extends StatelessWidget {
  const SubtitleRoutePage({
    required this.subtitleController,
    required this.videoPlayerController,
    required this.videoChild,
    super.key,
  });

  final SubtitleController subtitleController;
  final VideoPlayerController videoPlayerController;
  final Widget videoChild;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SubtitleWrapper(
        videoPlayerController: videoPlayerController,
        subtitleController: subtitleController,
        videoChild: videoChild,
      ),
    );
  }
}
