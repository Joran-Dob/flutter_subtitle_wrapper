import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
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
    on<SubtitleEvent>(_onEvent, transformer: sequential());
    subtitleController.attach(this);
  }

  FutureOr<void> _onEvent(SubtitleEvent event, Emitter emit) async {
    if (event is LoadSubtitle) {
      return _loadSubtitle(event, emit);
    } else if (event is InitSubtitles) {
      return _initSubtitles(event, emit);
    } else if (event is UpdateLoadedSubtitle) {
      emit(LoadedSubtitle(event.subtitle));
    }
  }

  FutureOr<void> _initSubtitles(InitSubtitles event, Emitter emit) async {
    emit(SubtitleInitializating());
    subtitles = await subtitleRepository.getSubtitles();
    emit(SubtitleInitialized());
  }

  FutureOr<void> _loadSubtitle(LoadSubtitle event, Emitter emit) async {
    emit(LoadingSubtitle());
    videoPlayerController.addListener(
      () {
        final videoPlayerPosition = videoPlayerController.value.position;
        for (final Subtitle subtitleItem in subtitles.subtitles) {
          final bool validStartTime = videoPlayerPosition.inMilliseconds >
              subtitleItem.startTime.inMilliseconds;
          final bool validEndTime = videoPlayerPosition.inMilliseconds <
              subtitleItem.endTime.inMilliseconds;
          if (validStartTime && validEndTime) {
            if (!isClosed) {
              add(
                UpdateLoadedSubtitle(
                  subtitle: subtitleItem,
                ),
              );
            }
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
