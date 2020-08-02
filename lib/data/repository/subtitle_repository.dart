import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:subtitle_wrapper_package/data/models/subtitle.dart';
import 'package:subtitle_wrapper_package/data/models/subtitles.dart';

import 'package:http/http.dart' as http;
import 'package:subtitle_wrapper_package/subtitle_controller.dart';

abstract class SubtitleRepository {
  Future<Subtitles> getSubtitles();
}

class SubtitleDataRepository extends SubtitleRepository {
  final SubtitleController subtitleController;

  SubtitleDataRepository({@required this.subtitleController});

  SubtitleDecoder requestContentType(Map<String, dynamic> headers) {
    Encoding encoding = _encodingForHeaders(headers);
    if (encoding == latin1) {
      return SubtitleDecoder.latin1;
    } else {
      return SubtitleDecoder.utf8;
    }
  }

  Encoding _encodingForHeaders(Map<String, String> headers) =>
      encodingForCharset(_contentTypeForHeaders(headers).parameters['charset']);

  MediaType _contentTypeForHeaders(Map<String, String> headers) {
    var contentType = headers['content-type'];
    if (contentType != null) return MediaType.parse(contentType);
    return MediaType('application', 'octet-stream');
  }

  Encoding encodingForCharset(String charset, [Encoding fallback = utf8]) {
    if (charset == null) return fallback;
    return Encoding.getByName(charset) ?? fallback;
  }

  @override
  Future<Subtitles> getSubtitles() async {
    String subtitlesContent = subtitleController.subtitlesContent;
    String subtitleUrl = subtitleController.subtitleUrl;

    if (subtitlesContent == null && subtitleUrl != null) {
      subtitlesContent = await loadRemoteSubtitleContent(
        subtitleUrl,
      );
    }
    try {
      if (subtitleController.subtitleType == SubtitleType.webvtt) {
        return getSubtitlesData(
          subtitlesContent,
          subtitleController.subtitleType,
        );
      } else if (subtitleController.subtitleType == SubtitleType.srt) {
        return getSubtitlesData(
          subtitlesContent,
          subtitleController.subtitleType,
        );
      } else {
        throw "Incorrect subtitle type";
      }
    } catch (e) {
      throw "Error parsing subtitles $e";
    }
  }

  Future<String> loadRemoteSubtitleContent(subtitleUrl) async {
    SubtitleDecoder subtitleDecoder = subtitleController.subtitleDecoder;
    String subtitlesContent;
    try {
      http.Response response = await http.get(subtitleUrl);
      if (response.statusCode == 200) {
        if (subtitleDecoder == SubtitleDecoder.utf8) {
          subtitlesContent = utf8.decode(
            response.bodyBytes,
            allowMalformed: true,
          );
        } else if (subtitleDecoder == SubtitleDecoder.latin1) {
          subtitlesContent = latin1.decode(
            response.bodyBytes,
            allowInvalid: true,
          );
        } else {
          SubtitleDecoder subtitleServerDecoder =
              requestContentType(response.headers);
          if (subtitleServerDecoder == SubtitleDecoder.utf8) {
            subtitlesContent = utf8.decode(
              response.bodyBytes,
              allowMalformed: true,
            );
          } else if (subtitleServerDecoder == SubtitleDecoder.latin1) {
            subtitlesContent = latin1.decode(
              response.bodyBytes,
              allowInvalid: true,
            );
          }
        }
      }
      return subtitlesContent;
    } catch (e) {
      throw ("Failed loading subtitle content $e");
    }
  }

  Subtitles getSubtitlesData(
      String subtitlesContent, SubtitleType subtitleType) {
    RegExp regExp;
    if (subtitleType == SubtitleType.webvtt) {
      regExp = new RegExp(
        r"((\d{2}):(\d{2}):(\d{2})\.(\d+)) +--> +((\d{2}):(\d{2}):(\d{2})\.(\d{3})).*[\r\n]+\s*((?:(?!\r?\n\r?).)*(\r\n|\r|\n)(?:.*))",
        caseSensitive: false,
        multiLine: true,
      );
    } else if (subtitleType == SubtitleType.srt) {
      regExp = new RegExp(
        r"((\d{2}):(\d{2}):(\d{2})\,(\d+)) +--> +((\d{2}):(\d{2}):(\d{2})\,(\d{3})).*[\r\n]+\s*((?:(?!\r?\n\r?).)*(\r\n|\r|\n)(?:.*))",
        caseSensitive: false,
        multiLine: true,
      );
    } else {
      throw ("Incorrect subtitle type");
    }

    List<RegExpMatch> matches = regExp.allMatches(subtitlesContent).toList();
    List<Subtitle> subtitleList = List();

    matches.forEach((RegExpMatch regExpMatch) {
      int startTimeHours = int.parse(regExpMatch.group(2));
      int startTimeMinutes = int.parse(regExpMatch.group(3));
      int startTimeSeconds = int.parse(regExpMatch.group(4));
      int startTimeMilliseconds = int.parse(regExpMatch.group(5));

      int endTimeHours = int.parse(regExpMatch.group(7));
      int endTimeMinutes = int.parse(regExpMatch.group(8));
      int endTimeSeconds = int.parse(regExpMatch.group(9));
      int endTimeMilliseconds = int.parse(regExpMatch.group(10));
      String text = removeAllHtmlTags(regExpMatch.group(11));

      Duration startTime = Duration(
          hours: startTimeHours,
          minutes: startTimeMinutes,
          seconds: startTimeSeconds,
          milliseconds: startTimeMilliseconds);
      Duration endTime = Duration(
          hours: endTimeHours,
          minutes: endTimeMinutes,
          seconds: endTimeSeconds,
          milliseconds: endTimeMilliseconds);

      subtitleList.add(
          Subtitle(startTime: startTime, endTime: endTime, text: text.trim()));
    });

    Subtitles subtitles = Subtitles(subtitles: subtitleList);
    return subtitles;
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"(<[^>]*>)", multiLine: true, caseSensitive: true);
    String newHtmlText = htmlText;
    exp.allMatches(htmlText).toList().forEach((RegExpMatch regExpMathc) {
      if (regExpMathc.group(0) == "<br>") {
        newHtmlText = newHtmlText.replaceAll(regExpMathc.group(0), '\n');
      } else {
        newHtmlText = newHtmlText.replaceAll(regExpMathc.group(0), '');
      }
    });
    return newHtmlText;
  }
}
