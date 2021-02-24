import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:subtitle_wrapper_package/data/models/subtitle.dart';
import 'package:subtitle_wrapper_package/data/models/subtitles.dart';
import 'package:subtitle_wrapper_package/data/repository/subtitle_repository.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';

part 'subtitle_event.dart';
part 'subtitle_state.dart';

class SubtitleBloc extends Bloc<SubtitleEvent, SubtitleState> {
  final dynamic videoPlayerController;
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
        final subtitle = (subtitles?.subtitles ?? []).firstWhere(
          (subtitleItem) =>
              videoPlayerPosition.inMilliseconds >
                  subtitleItem.startTime.inMilliseconds &&
              videoPlayerPosition.inMilliseconds <
                  subtitleItem.endTime.inMilliseconds,
          orElse: () => Subtitle(
            text: '',
            startTime: videoPlayerPosition,
            endTime: videoPlayerPosition,
          ),
        );

        add(UpdateLoadedSubtitle(subtitle: subtitle));
      }
    });
  }

  @override
  Future<void> close() {
    subtitleController.detach();
    return super.close();
  }
}
