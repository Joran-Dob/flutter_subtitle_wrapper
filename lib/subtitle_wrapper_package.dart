library subtitle_wrapper_package;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtitle_wrapper_package/bloc/subtitle/subtitle_bloc.dart';
import 'package:subtitle_wrapper_package/data/models/style/subtitle_style.dart';
import 'package:subtitle_wrapper_package/data/repository/subtitle_repository.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';
import 'package:subtitle_wrapper_package/subtitle_text_view.dart';
import 'package:video_player/video_player.dart';

class SubTitleWrapper extends StatelessWidget {
  final Widget videoChild;
  final SubtitleController subtitleController;
  final VideoPlayerController videoPlayerController;
  final SubtitleStyle subtitleStyle;

  const SubTitleWrapper({
    Key? key,
    required this.videoChild,
    required this.subtitleController,
    required this.videoPlayerController,
    this.subtitleStyle = const SubtitleStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        videoChild,
        if (subtitleController.showSubtitles)
          Positioned(
            top: subtitleStyle.position.top,
            bottom: subtitleStyle.position.bottom,
            left: subtitleStyle.position.left,
            right: subtitleStyle.position.right,
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
                subtitleStyle: subtitleStyle,
              ),
            ),
          )
        else
          Container()
      ],
    );
  }
}
