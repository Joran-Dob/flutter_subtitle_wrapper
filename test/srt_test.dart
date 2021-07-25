import 'package:flutter_test/flutter_test.dart';
import 'package:subtitle_wrapper_package/data/repository/subtitle_repository.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';

void main() {
  final subtitleController = SubtitleController(
      subtitleType: SubtitleType.srt,
      subtitleUrl: 'https://pastebin.com/raw/Jt07EBKK' //with tag
      //subtitleUrl: 'https://pastebin.com/raw/1gt7fAHW',
      );

  const subtitleContentString = '1\r\n'
      '00:00:03,400 --> 00:00:06,177\r\n'
      "In this lesson, we're <br> <a> going to </a> be talking about finance. And\r\n"
      '\r\n'
      '2\r\n'
      '00:00:06,177 --> 00:00:10,009\r\n'
      'one of the most important aspects of finance is interest.';

  test('Loading remote of Srt subtitle file', () async {
    final subtitleDataRepository = SubtitleDataRepository(
      subtitleController: subtitleController,
    );
    final subtitleContent =
        await subtitleDataRepository.loadRemoteSubtitleContent(
      subtitleUrl: subtitleController.subtitleUrl!,
    );
    expect(
      subtitleContent,
      subtitleContentString,
    );
  });

  test('Loading remote of Srt subtitle file with latin1 codec', () async {
    subtitleController.subtitleDecoder = SubtitleDecoder.latin1;
    final subtitleDataRepository = SubtitleDataRepository(
      subtitleController: subtitleController,
    );
    final subtitleContent =
        await subtitleDataRepository.loadRemoteSubtitleContent(
      subtitleUrl: subtitleController.subtitleUrl!,
    );
    expect(
      subtitleContent,
      subtitleContentString,
    );
  });

  test('Loading remote of Srt subtitle file with utf8 codec', () async {
    subtitleController.subtitleDecoder = SubtitleDecoder.utf8;
    final subtitleDataRepository = SubtitleDataRepository(
      subtitleController: subtitleController,
    );
    final subtitleContent =
        await subtitleDataRepository.loadRemoteSubtitleContent(
      subtitleUrl: subtitleController.subtitleUrl!,
    );
    expect(
      subtitleContent,
      subtitleContentString,
    );
  });
  test(
    'Parsing remote of Srt subtitle file',
    () async {
      final subtitleDataRepository = SubtitleDataRepository(
        subtitleController: subtitleController,
      );
      final subtitles = await subtitleDataRepository.getSubtitles();
      expect(subtitles.subtitles[0].subtitleTokens.toString(),
          "[In:Color(0xffffffff), this:Color(0xffffffff), lesson,:Color(0xffffffff), we\'re:Color(0xffffffff),  going to :MaterialColor(primary value: Color(0xff9c27b0)), be:Color(0xffffffff), talking:Color(0xffffffff), about:Color(0xffffffff), finance.:Color(0xffffffff), And:Color(0xffffffff)]");
    },
  );
}
