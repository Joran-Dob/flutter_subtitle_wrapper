import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';

abstract class SubtitleRepository {
  Future<Subtitles> getSubtitles();
}

class SubtitleDataRepository extends SubtitleRepository {
  SubtitleDataRepository({required this.subtitleController});
  final SubtitleController subtitleController;

  // Gets the subtitle content type.
  SubtitleDecoder requestContentType(Map<String, dynamic> headers) {
    // Extracts the subtitle content type from the headers.
    final encoding = _encodingForHeaders(headers as Map<String, String>);

    return encoding == latin1 ? SubtitleDecoder.latin1 : SubtitleDecoder.utf8;
  }

  // Gets the encoding type for the charset string with a fall back to utf8.
  Encoding encodingForCharset(String? charset, [Encoding fallback = utf8]) {
    // If the charset is empty we use the encoding fallback.
    if (charset == null) return fallback;
    // If the charset is not empty we will return the encoding type for this charset.

    return Encoding.getByName(charset) ?? fallback;
  }

  // Handles the subtitle loading, parsing.
  @override
  Future<Subtitles> getSubtitles() async {
    var subtitlesContent = subtitleController.subtitlesContent;
    final subtitleUrl = subtitleController.subtitleUrl;

    // If the subtitle content parameter is empty we will load the subtitle from the specified url.
    if (subtitlesContent == null && subtitleUrl != null) {
      // Lets load the subtitle content from the url.
      subtitlesContent = await loadRemoteSubtitleContent(
        subtitleUrl: subtitleUrl,
      );
    }
    // Tries parsing the subtitle data
    // Lets try to parse the subtitle content with the specified subtitle type
    if (subtitlesContent != null) {
      return getSubtitlesData(
        subtitlesContent,
        subtitleController.subtitleType,
      );
    }

    return Subtitles(subtitles: []);
  }

  // Loads the remote subtitle content.
  Future<String?> loadRemoteSubtitleContent({
    required String subtitleUrl,
  }) async {
    final subtitleDecoder = subtitleController.subtitleDecoder;
    String? subtitlesContent;
    // Try loading the subtitle content with http.get.
    try {
      final response = await http.get(
        Uri.parse(subtitleUrl),
      );

      // Lets check if the request was successful.
      // If the subtitle decoder type is utf8 lets decode it with utf8.
      if (response.statusCode == HttpStatus.ok) {
        if (subtitleDecoder == SubtitleDecoder.utf8) {
          subtitlesContent = utf8.decode(
            response.bodyBytes,
            allowMalformed: true,
          );
        }
        // If the subtitle decoder type is latin1 lets decode it with latin1.
        else if (subtitleDecoder == SubtitleDecoder.latin1) {
          subtitlesContent = latin1.decode(
            response.bodyBytes,
            allowInvalid: true,
          );
        }
        // The subtitle decoder was not defined so we will extract it from the response headers send from the server.
        else {
          final subtitleServerDecoder = requestContentType(
            response.headers,
          );
          // If the subtitle decoder type is utf8 lets decode it with utf8.
          if (subtitleServerDecoder == SubtitleDecoder.utf8) {
            subtitlesContent = utf8.decode(
              response.bodyBytes,
              allowMalformed: true,
            );
          }
          // If the subtitle decoder type is latin1 lets decode it with latin1.
          else if (subtitleServerDecoder == SubtitleDecoder.latin1) {
            subtitlesContent = latin1.decode(
              response.bodyBytes,
              allowInvalid: true,
            );
          }
        }
      }
    } catch (e) {
      subtitlesContent = '';
    }

    // Return the subtitle content.
    return subtitlesContent;
  }

  Subtitles getSubtitlesData(String subtitlesContent, SubtitleType subtitleType) {
    RegExp regExp;
    if (subtitleType == SubtitleType.webvtt) {
      regExp = RegExp(
        r'(?:(\d{2}):)?(\d{2}):(\d{2}).(\d{3}) --> (?:(\d{2}):)?(\d{2}):(\d{2}).(\d{3}).*[\r\n]+\s*((?:(?!\r?\n\r?).)*(\r\n|\r|\n)(?:.*))',
        caseSensitive: false,
        multiLine: true,
      );
    } else if (subtitleType == SubtitleType.srt) {
      regExp = RegExp(
        r'(\d{2}):(\d{2}):(\d{2}),(\d{3}) --> (\d{2}):(\d{2}):(\d{2}),(\d{3}).*[\r\n]+\s*((?:(?!\r?\n\r?).)*(\r\n|\r|\n)(?:.*))',
        caseSensitive: false,
        multiLine: true,
      );
    } else {
      throw Exception('Incorrect subtitle type');
    }

    final matches = regExp.allMatches(subtitlesContent);
    final subtitleList = <Subtitle>[];

    for (final RegExpMatch regExpMatch in matches) {
      final startTime = _parseTime(
          regExpMatch.group(1), regExpMatch.group(2)!, regExpMatch.group(3)!, regExpMatch.group(4)!);
      final endTime = _parseTime(
          regExpMatch.group(5), regExpMatch.group(6)!, regExpMatch.group(7)!, regExpMatch.group(8)!);
      final text = removeAllHtmlTags(regExpMatch.group(9)!);

      subtitleList
          .add(Subtitle(startTime: startTime, endTime: endTime, text: text));
    }

    return Subtitles(subtitles: subtitleList);
  }

  Duration _parseTime(String? hoursStr, String minutesStr, String secondsStr,
      String millisecondsStr) {
    final hours = hoursStr != null ? int.parse(hoursStr) : 0;
    final minutes = int.parse(minutesStr);
    final seconds = int.parse(secondsStr);
    final milliseconds = int.parse(millisecondsStr);
    return Duration(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds);
  }

  String removeAllHtmlTags(String htmlText) {
    final exp = RegExp(
      '(<[^>]*>)',
      multiLine: true,
    );
    var newHtmlText = htmlText;
    exp.allMatches(htmlText).toList().forEach(
      (RegExpMatch regExpMatch) {
        newHtmlText = regExpMatch.group(0) == '<br>'
            ? newHtmlText.replaceAll(regExpMatch.group(0)!, '\n')
            : newHtmlText.replaceAll(regExpMatch.group(0)!, '');
      },
    );

    return newHtmlText;
  }

//  final text = removeAllHtmlTags(regExpMatch.group(17)!);

  // Extract the encoding type from the headers.
  Encoding _encodingForHeaders(Map<String, String> headers) =>
      encodingForCharset(
        _contentTypeForHeaders(headers).parameters['charset'],
      );

  // Gets the content type from the headers and returns it as a media type.
  MediaType _contentTypeForHeaders(Map<String, String> headers) {
    var contentType = headers['content-type']!;
    if (_hasSemiColonEnding(contentType)) {
      contentType = _fixSemiColonEnding(contentType);
    }

    return MediaType.parse(contentType);
  }

  // Check if the string is ending with a semicolon.
  bool _hasSemiColonEnding(String string) {
    return string.substring(string.length - 1, string.length) == ';';
  }

  // Remove ending semicolon from string.
  String _fixSemiColonEnding(String string) {
    return string.substring(0, string.length - 1);
  }
}
