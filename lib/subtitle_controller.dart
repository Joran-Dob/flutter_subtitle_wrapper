class SubtitleController {
  String subtitlesContent;
  String subtitleUrl;
  final bool showSubtitles;
  SubtitleDecoder subtitleDecoder;

  SubtitleController({
    this.subtitleUrl,
    this.subtitlesContent,
    this.showSubtitles = true,
    this.subtitleDecoder,
  });
}

enum SubtitleDecoder {
  utf8,
  latin1,
}
