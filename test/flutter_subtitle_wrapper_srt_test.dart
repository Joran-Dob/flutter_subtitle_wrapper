import 'package:flutter_test/flutter_test.dart';
import 'package:subtitle_wrapper_package/data/models/subtitle.dart';
import 'package:subtitle_wrapper_package/data/models/subtitles.dart';
import 'package:subtitle_wrapper_package/data/repository/subtitle_repository.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';

void main() {
  SubtitleController subtitleController = SubtitleController(
      subtitleType: SubtitleType.srt,
      subtitleUrl: "https://pastebin.com/raw/RCZSky3f");

  const subtitleContentString = '1\r\n'
      '00:00:03,400 --> 00:00:06,177\r\n'
      'In this lesson, we\'re going to be talking about finance. And\r\n'
      '\r\n'
      '2\r\n'
      '00:00:06,177 --> 00:00:10,009\r\n'
      'one of the most important aspects of finance is interest.';

  test('Loading remote of Srt subtitle file', () async {
    SubtitleDataRepository subtitleDataRepository = SubtitleDataRepository(
      subtitleController: subtitleController,
    );
    String subtitleContent = await subtitleDataRepository
        .loadRemoteSubtitleContent(subtitleController.subtitleUrl);
    expect(
      subtitleContent,
      subtitleContentString,
    );
  });

  test('Loading remote of Srt subtitle file with latin1 codec', () async {
    subtitleController.subtitleDecoder = SubtitleDecoder.latin1;
    SubtitleDataRepository subtitleDataRepository = SubtitleDataRepository(
      subtitleController: subtitleController,
    );
    String subtitleContent = await subtitleDataRepository
        .loadRemoteSubtitleContent(subtitleController.subtitleUrl);
    expect(
      subtitleContent,
      subtitleContentString,
    );
  });

  test('Loading remote of Srt subtitle file with utf8 codec', () async {
    subtitleController.subtitleDecoder = SubtitleDecoder.utf8;
    SubtitleDataRepository subtitleDataRepository = SubtitleDataRepository(
      subtitleController: subtitleController,
    );
    String subtitleContent = await subtitleDataRepository
        .loadRemoteSubtitleContent(subtitleController.subtitleUrl);
    expect(
      subtitleContent,
      subtitleContentString,
    );
  });
  test(
    'Parsing remote of Srt subtitle file',
    () async {
      SubtitleDataRepository subtitleDataRepository = SubtitleDataRepository(
        subtitleController: subtitleController,
      );
      Subtitles subtitles = await subtitleDataRepository.getSubtitles();
      expect(
        subtitles.subtitles,
        [
          Subtitle(
            startTime: Duration(
              hours: 0,
              minutes: 0,
              seconds: 3,
              milliseconds: 400,
            ),
            endTime: Duration(
              hours: 0,
              minutes: 0,
              seconds: 6,
              milliseconds: 177,
            ),
            text:
                "In this lesson, we're going to be talking about finance. And",
          ),
          Subtitle(
            startTime: Duration(
              hours: 0,
              minutes: 0,
              seconds: 6,
              milliseconds: 177,
            ),
            endTime: Duration(
              hours: 0,
              minutes: 0,
              seconds: 10,
              milliseconds: 009,
            ),
            text: "one of the most important aspects of finance is interest.",
          ),
        ],
      );
    },
  );
}
