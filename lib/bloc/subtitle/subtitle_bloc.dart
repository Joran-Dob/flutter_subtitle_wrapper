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
  final SubtitleController subtitleController;

  Subtitles subtitles;

  SubtitleBloc({
    @required this.videoPlayerController,
    @required this.subtitleRepository,
    @required this.subtitleController,
  }) : super(SubtitleInitial()) {
    subtitleController.attach(this);
  }

  @override
  Stream<SubtitleState> mapEventToState(
    SubtitleEvent event,
  ) async* {
    if (event is LoadSubtitle) {
      yield* loadSubtitle();
    } else if (event is InitSubtitles) {
      yield* initSubtitles();
    } else if (event is UpdateLoadedSubtitle) {
      yield LoadedSubtitle(event.subtitle);
    }
  }

  Stream<SubtitleState> initSubtitles() async* {
    yield SubtitleInitializating();
    subtitles = await subtitleRepository.getSubtitles();
    yield SubtitleInitialized();
  }

  Stream<SubtitleState> loadSubtitle() async* {
    yield LoadingSubtitle();
    videoPlayerController.addListener(() {
      var videoPlayerPosition = videoPlayerController.value.position;
      if (videoPlayerPosition != null) {
        for (var subtitleItem in subtitles.subtitles) {
          if (videoPlayerPosition.inMilliseconds >
                  subtitleItem.startTime.inMilliseconds &&
              videoPlayerPosition.inMilliseconds <
                  subtitleItem.endTime.inMilliseconds) {
            add(UpdateLoadedSubtitle(subtitle: subtitleItem));
          }
        }
      }
    });
  }

  @override
  Future<void> close() {
    subtitleController.detach();
    return super.close();
  }
}
