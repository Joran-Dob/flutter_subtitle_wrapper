import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtitle_wrapper_package/bloc/subtitle/subtitle_bloc.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';
import 'package:video_player/video_player.dart';

class SubtitleWrapper extends StatelessWidget {
  const SubtitleWrapper({
    required this.videoChild,
    required this.subtitleController,
    required this.videoPlayerController,
    this.position = const SubtitlePosition(),
    super.key,
    this.textStyle,
    this.backgroundColor,
  });
  final Widget videoChild;
  final SubtitleController subtitleController;
  final VideoPlayerController videoPlayerController;
  final SubtitlePosition position;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        videoChild,
        if (subtitleController.showSubtitles)
          Positioned(
            top: position.top,
            bottom: position.bottom,
            left: position.left,
            right: position.right,
            child: BlocProvider(
              create: (context) => SubtitleBloc(
                videoPlayerController: videoPlayerController,
                subtitleRepository: SubtitleDataRepository(
                  subtitleController: subtitleController,
                ),
                subtitleController: subtitleController,
              )..add(
                  InitSubtitles(
                    subtitleController: subtitleController,
                  ),
                ),
              child: SubtitleTextView(
                textStyle: textStyle,
                backgroundColor: backgroundColor,
              ),
            ),
          )
        else
          Container(),
      ],
    );
  }
}
