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
  final _subtitleController = SubtitleController(
    subtitleUrl: 'https://pastebin.com/raw/ZWWAL7fK',
    subtitleDecoder: SubtitleDecoder.utf8,
  );

  group(
    'Subtitle BLoC',
    () {
      blocTest<SubtitleBloc, SubtitleState>(
        'subtitle init',
        build: () => SubtitleBloc(
          subtitleController: _subtitleController,
          subtitleRepository: SubtitleDataRepository(
            subtitleController: _subtitleController,
          ),
          videoPlayerController: MockVideoPlayerController(),
        ),
        act: (SubtitleBloc bloc) => bloc.add(
          InitSubtitles(
            subtitleController: _subtitleController,
          ),
        ),
        expect: () => [
          SubtitleInitializating(),
          SubtitleInitialized(),
        ],
      );
      blocTest<SubtitleBloc, SubtitleState>(
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
            subtitle: const Subtitle(
              startTime: Duration(),
              endTime: Duration(
                seconds: 10,
              ),
              text: 'test',
            ),
          ),
        ),
        expect: () => [
          const LoadedSubtitle(
            Subtitle(
              startTime: Duration(),
              endTime: Duration(
                seconds: 10,
              ),
              text: 'test',
            ),
          ),
        ],
      );

      blocTest<SubtitleBloc, SubtitleState>(
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
