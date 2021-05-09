import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

  late Subtitles subtitles;

  SubtitleBloc({
    required this.videoPlayerController,
    required this.subtitleRepository,
    required this.subtitleController,
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
      yield LoadedSubtitle(event.subtitle, event.prevSubtitle);
    }
  }

  Stream<SubtitleState> initSubtitles() async* {
    yield SubtitleInitializating();
    subtitles = await subtitleRepository.getSubtitles();
    yield SubtitleInitialized();
  }

  Stream<SubtitleState> loadSubtitle() async* {
    yield LoadingSubtitle();
    videoPlayerController.addListener(
      () {
        final videoPlayerPosition = videoPlayerController.value.position;
        if (subtitles.subtitles.last.endTime <
            videoPlayerController.value.duration)
          subtitles.subtitles.add(
            Subtitle(
                startTime: subtitles.subtitles.last.endTime,
                endTime: videoPlayerController.value.duration,
                text: "",
                subtitleTokens: []),
          );
        //TODO binary search
        for (var i = 0; i < subtitles.subtitles.length; i++) {
          final subtitleItem = subtitles.subtitles[i];
          final bool validStartTime = videoPlayerPosition.inMilliseconds >
              subtitleItem.startTime.inMilliseconds;
          final bool validEndTime = videoPlayerPosition.inMilliseconds <
              subtitleItem.endTime.inMilliseconds;
          if (validStartTime && validEndTime) {
            add(
              UpdateLoadedSubtitle(
                  subtitle: subtitleItem,
                  prevSubtitle:
                      i >= 1 ? subtitles.subtitles[i - 1] : subtitleItem),
            );
          }
        }
      },
    );
  }

  @override
  Future<void> close() {
    subtitleController.detach();
    return super.close();
  }
}
