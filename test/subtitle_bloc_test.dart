import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:subtitle_wrapper_package/bloc/subtitle/subtitle_bloc.dart';
import 'package:subtitle_wrapper_package/data/models/subtitle.dart';
import 'package:subtitle_wrapper_package/data/repository/subtitle_repository.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';
import 'package:video_player/video_player.dart';

class MockVideoPlayerController extends Mock implements VideoPlayerController {}

void main() {
  var _subtitleController = SubtitleController(
    subtitleUrl: 'https://pastebin.com/raw/ZWWAL7fK',
    showSubtitles: true,
    subtitleDecoder: SubtitleDecoder.utf8,
    subtitleType: SubtitleType.webvtt,
  );

  group(
    'Subtitle BLoC',
    () {
      blocTest(
        'subtitle init',
        build: () => SubtitleBloc(
          subtitleController: _subtitleController,
          subtitleRepository: SubtitleDataRepository(
            subtitleController: _subtitleController,
          ),
          videoPlayerController: MockVideoPlayerController(),
        ),
        act: (dynamic bloc) => bloc.add(
          InitSubtitles(
            subtitleController: _subtitleController,
          ),
        ),
        expect: () => [
          SubtitleInitializating(),
          SubtitleInitialized(),
        ],
      );
      blocTest(
        'subtitle update',
        build: () => SubtitleBloc(
          subtitleController: _subtitleController,
          subtitleRepository: SubtitleDataRepository(
            subtitleController: _subtitleController,
          ),
          videoPlayerController: MockVideoPlayerController(),
        ),
        act: (dynamic bloc) => bloc.add(
          UpdateLoadedSubtitle(
            subtitle: Subtitle(
              startTime: Duration(
                seconds: 0,
              ),
              endTime: Duration(
                seconds: 10,
              ),
              text: 'test',
            ),
          ),
        ),
        expect: () => [
          LoadedSubtitle(
            Subtitle(
              startTime: Duration(
                seconds: 0,
              ),
              endTime: Duration(
                seconds: 10,
              ),
              text: 'test',
            ),
          ),
        ],
      );

      blocTest(
        'subtitle load',
        build: () => SubtitleBloc(
          subtitleController: _subtitleController,
          subtitleRepository: SubtitleDataRepository(
            subtitleController: _subtitleController,
          ),
          videoPlayerController: MockVideoPlayerController(),
        ),
        act: (SubtitleBloc bloc) {
          bloc.videoPlayerController.notifyListeners();
          return bloc.add(
            LoadSubtitle(),
          );
        },
        expect: () => [
          LoadingSubtitle(),
        ],
      );
    },
  );
}
