class SubtitleController {
  String subtitlesContent;
  String subtitleUrl;
  final bool showSubtitles;
  SubtitleDecoder subtitleDecoder;
  SubtitleType subtitleType;

  SubtitleController({
    this.subtitleUrl,
    this.subtitlesContent,
    this.showSubtitles = true,
    this.subtitleDecoder,
    this.subtitleType = SubtitleType.webvtt,
  });
}

enum SubtitleDecoder {
  utf8,
  latin1,
}

enum SubtitleType {
  webvtt,
  srt,
}
