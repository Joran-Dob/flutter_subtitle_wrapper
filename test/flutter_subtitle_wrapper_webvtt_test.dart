import 'package:flutter_test/flutter_test.dart';
import 'package:subtitle_wrapper_package/data/models/subtitle.dart';
import 'package:subtitle_wrapper_package/data/models/subtitles.dart';
import 'package:subtitle_wrapper_package/data/repository/subtitle_repository.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';

void main() {
  SubtitleController subtitleController = SubtitleController(
      subtitleType: SubtitleType.webvtt,
      subtitleUrl: "https://pastebin.com/raw/ZWWAL7fK");
  SubtitleDataRepository subtitleDataRepository = SubtitleDataRepository(
    subtitleController: subtitleController,
  );
  test('Loading remote of WebVtt subtitle file', () async {
    String subtitleContent = await subtitleDataRepository
        .loadRemoteSubtitleContent(subtitleController.subtitleUrl);
    expect(
        subtitleContent,
        'WEBVTT\r\n'
        '\r\n'
        '1\r\n'
        '00:00:00.420 --> 00:00:03.510\r\n'
        '<v ->Löksås ipsum själv vi ännu därmed trevnadens kom, häst kanske dimma</v>\r\n'
        '\r\n'
        '2\r\n'
        '00:00:03.510 --> 00:00:07.531\r\n'
        'annat bäckasiner därmed redan gamla, dimmhöljd miljoner groda hela\r\n'
        '\r\n'
        '3\r\n'
        '00:00:07.531 --> 00:00:11.440\r\n'
        'mjuka nu. Smultron icke tre ännu varit denna enligt kan häst, del bäckasiner\r\n'
        '\r\n'
        '4\r\n'
        '00:00:11.440 --> 00:00:14.930\r\n'
        'som tre rot så rot därmed ingalunda, hela ser genom smultron lax flera\r\n'
        '\r\n'
        '5\r\n'
        '00:00:14.930 --> 00:00:16.570\r\n'
        'ordningens. Vi olika del vi samma nya samtidigt vidsträckt dag omfångsrik');
  });
  test('Parsing remote of WebVtt subtitle file', () async {
    Subtitles subtitles = await subtitleDataRepository.getSubtitles();
    print(subtitles.subtitles[0].text);
    expect(
      subtitles.subtitles[0],
      Subtitle(
        startTime: Duration(
          hours: 0,
          minutes: 0,
          seconds: 0,
          milliseconds: 420,
        ),
        endTime: Duration(hours: 0, minutes: 0, seconds: 3, milliseconds: 510),
        text:
            'Löksås ipsum själv vi ännu därmed trevnadens kom, häst kanske dimma',
      ),
    );
  });
}
