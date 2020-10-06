import 'package:flutter_test/flutter_test.dart';
import 'package:subtitle_wrapper_package/data/models/subtitle.dart';
import 'package:subtitle_wrapper_package/data/repository/subtitle_repository.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';

void main() {
  var subtitleController = SubtitleController(
    subtitleType: SubtitleType.srt,
    subtitleUrl: 'https://pastebin.com/raw/1gt7fAHW',
  );

  const subtitleContentString = '1\r\n'
      '00:00:03,400 --> 00:00:06,177\r\n'
      'In this lesson, we\'re <br> going to be talking about finance. And\r\n'
      '\r\n'
      '2\r\n'
      '00:00:06,177 --> 00:00:10,009\r\n'
      'one of the most important aspects of finance is interest.';

  test('Loading remote of Srt subtitle file', () async {
    var subtitleDataRepository = SubtitleDataRepository(
      subtitleController: subtitleController,
    );
    var subtitleContent =
        await subtitleDataRepository.loadRemoteSubtitleContent(
      subtitleController.subtitleUrl,
    );
    expect(
      subtitleContent,
      subtitleContentString,
    );
  });

  test('Loading remote of Srt subtitle file with latin1 codec', () async {
    subtitleController.subtitleDecoder = SubtitleDecoder.latin1;
    var subtitleDataRepository = SubtitleDataRepository(
      subtitleController: subtitleController,
    );
    var subtitleContent =
        await subtitleDataRepository.loadRemoteSubtitleContent(
      subtitleController.subtitleUrl,
    );
    expect(
      subtitleContent,
      subtitleContentString,
    );
  });

  test('Loading remote of Srt subtitle file with utf8 codec', () async {
    subtitleController.subtitleDecoder = SubtitleDecoder.utf8;
    var subtitleDataRepository = SubtitleDataRepository(
      subtitleController: subtitleController,
    );
    var subtitleContent =
        await subtitleDataRepository.loadRemoteSubtitleContent(
      subtitleController.subtitleUrl,
    );
    expect(
      subtitleContent,
      subtitleContentString,
    );
  });
  test(
    'Parsing remote of Srt subtitle file',
    () async {
      var subtitleDataRepository = SubtitleDataRepository(
        subtitleController: subtitleController,
      );
      var subtitles = await subtitleDataRepository.getSubtitles();
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
            text: subtitles.subtitles[0].text,
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
            text: 'one of the most important aspects of finance is interest.',
          ),
        ],
      );
    },
  );
}
