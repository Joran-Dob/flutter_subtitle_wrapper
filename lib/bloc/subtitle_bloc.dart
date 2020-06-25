import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:subtitle_wrapper_package/data/models/subtitle.dart';
import 'package:subtitle_wrapper_package/data/models/subtitles.dart';
import 'package:subtitle_wrapper_package/data/repository/subtitle_repository.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';
import 'package:video_player/video_player.dart';

part 'subtitle_event.dart';
part 'subtitle_state.dart';

class SubtitleBloc extends Bloc<SubtitleEvent, SubtitleState> {
  final VideoPlayerController videoPlayerController;
  final SubtitleRepository subtitleRepository;

  Subtitles subtitles;

  SubtitleBloc({
    this.videoPlayerController,
    this.subtitleRepository,
  });

  @override
  SubtitleState get initialState => SubtitleInitial();

  @override
  Stream<SubtitleState> mapEventToState(
    SubtitleEvent event,
  ) async* {
    if (event is LoadSubtitle) {
      yield* loadSubtitle();
    } else if (event is InitSubtitles) {
      yield* initSubtitles();
    }
  }

  Stream<SubtitleState> initSubtitles() async* {
    yield SubtitleInitializating();
    yield SubtitleInitialized();
  }

  Stream<SubtitleState> loadSubtitle() async* {
    yield LoadingSubtitle();
    VideoPlayerValue latestValue = videoPlayerController.value;
    Duration videoPlayerPosition = latestValue.position;
    if (videoPlayerPosition != null) {
      Subtitle subtitle;
      subtitles.subtitles.forEach((subtitleItem) {
        if (videoPlayerPosition.inMilliseconds >
                subtitleItem.startTime.inMilliseconds &&
            videoPlayerPosition.inMilliseconds <
                subtitleItem.endTime.inMilliseconds) {
          subtitle = subtitleItem;
        }
      });
      yield LoadedSubtitle(subtitle);
    }
  }
}
