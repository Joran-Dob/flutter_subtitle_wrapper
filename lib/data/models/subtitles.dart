import 'package:subtitle_wrapper_package/data/models/subtitle.dart';

class Subtitles {
  final List<Subtitle> subtitles;
  @override
  String toString() {
    var res = "[";
    subtitles.forEach((element) => res +=
        element.toString() + element.text != subtitles.last.text ? "," : '');
    res += ']';
    return res;
  }

  Subtitles({
    required this.subtitles,
  });
}
