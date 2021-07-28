import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:subtitle_wrapper_package/data/models/subtitle.dart';
import 'package:subtitle_wrapper_package/data/models/subtitle_token.dart';
import 'package:subtitle_wrapper_package/data/models/subtitles.dart';

import 'package:http/http.dart' as http;
import 'package:subtitle_wrapper_package/data/models/tag.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';

abstract class SubtitleRepository {
  Future<Subtitles> getSubtitles();
}

class SubtitleDataRepository extends SubtitleRepository {
  final SubtitleController subtitleController;

  SubtitleDataRepository({required this.subtitleController});

  // Gets the subtitle content type
  SubtitleDecoder requestContentType(Map<String, dynamic> headers) {
    // Extracts the subtitle content type from the headers
    final encoding = _encodingForHeaders(headers as Map<String, String>);
    if (encoding == latin1) {
      // If encoding type is latin1 return this type
      return SubtitleDecoder.latin1;
    } else {
      // If encoding type is utf8 return this type
      return SubtitleDecoder.utf8;
    }
  }

  // Extract the encoding type from the headers
  Encoding _encodingForHeaders(Map<String, String> headers) =>
      encodingForCharset(
        _contentTypeForHeaders(headers).parameters['charset'],
      );

  // Gets the content type from the headers and returns it as a media type
  MediaType _contentTypeForHeaders(Map<String, String> headers) {
    var _contentType = headers['content-type']!;
    if (_hasSemiColonEnding(_contentType)) {
      _contentType = _fixSemiColonEnding(_contentType);
    }
    return MediaType.parse(_contentType);
  }

  // Check if the string is ending with a semicolon.
  bool _hasSemiColonEnding(String _string) {
    return _string.substring(_string.length - 1, _string.length) == ';';
  }

  // Remove ending semicolon from string.
  String _fixSemiColonEnding(String _string) {
    return _string.substring(0, _string.length - 1);
  }

  // Gets the encoding type for the charset string with a fall back to utf8
  Encoding encodingForCharset(String? charset, [Encoding fallback = utf8]) {
    // If the charset is empty we use the encoding fallback
    if (charset == null) return fallback;
    // If the charset is not empty we will return the encoding type for this charset
    return Encoding.getByName(charset) ?? fallback;
  }

  // Handles the subtitle loading, parsing.
  @override
  Future<Subtitles> getSubtitles() async {
    var subtitlesContent = subtitleController.subtitlesContent;
    final subtitleUrl = subtitleController.subtitleUrl;

    // If the subtitle content parameter is empty we will load the subtitle from the specified url
    if (subtitlesContent == null && subtitleUrl != null) {
      // Lets load the subtitle content from the url
      subtitlesContent = await loadRemoteSubtitleContent(
        subtitleUrl: subtitleUrl,
      );
    }
    // Tries parsing the subtitle data
    // Lets try to parse the subtitle content with the specified subtitle type
    return getSubtitlesData(
      subtitlesContent!,
      subtitleController.subtitleType,
    );
  }

  // Loads the remote subtitle content
  Future<String?> loadRemoteSubtitleContent({
    required String subtitleUrl,
  }) async {
    final subtitleDecoder = subtitleController.subtitleDecoder;
    String? subtitlesContent;
    // Try loading the subtitle content with http.get
    final response = await http.get(
      Uri.parse(subtitleUrl),
    );
    // Lets check if the request was succesfull
    if (response.statusCode == 200) {
      // If the subtitle decoder type is utf8 lets decode it with utf8
      if (subtitleDecoder == SubtitleDecoder.utf8) {
        subtitlesContent = utf8.decode(
          response.bodyBytes,
          allowMalformed: true,
        );
      }
      // If the subtitle decoder type is latin1 lets decode it with latin1
      else if (subtitleDecoder == SubtitleDecoder.latin1) {
        subtitlesContent = latin1.decode(
          response.bodyBytes,
          allowInvalid: true,
        );
      }
      // The  subtitle decoder was not defined so we will extract it from the response headers send from the server
      else {
        final subtitleServerDecoder = requestContentType(
          response.headers,
        );
        // If the subtitle decoder type is utf8 lets decode it with utf8
        if (subtitleServerDecoder == SubtitleDecoder.utf8) {
          subtitlesContent = utf8.decode(
            response.bodyBytes,
            allowMalformed: true,
          );
        }
        // If the subtitle decoder type is latin1 lets decode it with latin1
        else if (subtitleServerDecoder == SubtitleDecoder.latin1) {
          subtitlesContent = latin1.decode(
            response.bodyBytes,
            allowInvalid: true,
          );
        }
      }
    }
    // Return the subtitle content
    return subtitlesContent;
  }

  Subtitles getSubtitlesData(
    String subtitlesContent,
    SubtitleType subtitleType,
  ) {
    RegExp regExp;
    if (subtitleType == SubtitleType.webvtt) {
      regExp = RegExp(
        r'((\d{2}):(\d{2}):(\d{2})\.(\d+)) +--> +((\d{2}):(\d{2}):(\d{2})\.(\d{3})).*[\r\n]+\s*((?:(?!\r?\n\r?).)*(\r\n|\r|\n)(?:.*))',
        caseSensitive: false,
        multiLine: true,
      );
    } else if (subtitleType == SubtitleType.srt) {
      regExp = RegExp(
        r'((\d{2}):(\d{2}):(\d{2})\,(\d+)) +--> +((\d{2}):(\d{2}):(\d{2})\,(\d{3})).*[\r\n]+\s*((?:(?!\r?\n\r?).)*(\r\n|\r|\n)(?:.*))',
        caseSensitive: false,
        multiLine: true,
      );
    } else {
      throw 'Incorrect subtitle type';
    }

    final matches = regExp.allMatches(subtitlesContent).toList();
    final List<Subtitle> subtitleList = <Subtitle>[];

    for (final RegExpMatch regExpMatch in matches) {
      final startTimeHours = int.parse(regExpMatch.group(2)!);
      final startTimeMinutes = int.parse(regExpMatch.group(3)!);
      final startTimeSeconds = int.parse(regExpMatch.group(4)!);
      final startTimeMilliseconds = int.parse(regExpMatch.group(5)!);

      final endTimeHours = int.parse(regExpMatch.group(7)!);
      final endTimeMinutes = int.parse(regExpMatch.group(8)!);
      final endTimeSeconds = int.parse(regExpMatch.group(9)!);
      final endTimeMilliseconds = int.parse(regExpMatch.group(10)!);
      final text = regExpMatch.group(11)!;
      final startTime = Duration(
          hours: startTimeHours,
          minutes: startTimeMinutes,
          seconds: startTimeSeconds,
          milliseconds: startTimeMilliseconds);
      final endTime = Duration(
          hours: endTimeHours,
          minutes: endTimeMinutes,
          seconds: endTimeSeconds,
          milliseconds: endTimeMilliseconds);
      subtitleList.add(Subtitle(
          startTime: startTime,
          endTime: endTime,
          text: text.trim(),
          subtitleTokens: genarateTokens(text)));
    }

    final subtitles = Subtitles(subtitles: subtitleList);
    return subtitles;
  }

  List<SubtitleToken> genarateTokens(String htmlText) {

    final exp = RegExp(
      r'(<([A-Z][A-Z0-9]*)\b[^>]*>(.*?)<\/\2>)',
      multiLine: true,
      caseSensitive: false,
      unicode: true,
    );
    var customTokenTexts = Map<String, SubtitleToken>();
    exp.allMatches(htmlText).toList().forEach(
      (RegExpMatch regExpMathc) {
        Tag tag = Tag.getTag(regExpMathc.group(2)!);
        TextStyle tokenStyle = TextStyle(color: tag.color);
        String tokenText = regExpMathc.group(3)!;
        SubtitleToken subtitleToken = SubtitleToken(
            token: tokenText,
            tokenStyle: tokenStyle,
            description: tag.description);

        customTokenTexts.addAll({tokenText: subtitleToken});
      },
    );
    List<String> rawTexts = htmlText.split(' ');
    bool customTokenTextsKeyContaines(item, index) {
      List<String> splittedKey =
          customTokenTexts.keys.toList()[index].split(' ');
      return splittedKey.contains(item);
    }

    int i = 0;
    List<SubtitleToken> result = [];
    for (int j = 0; j < rawTexts.length;) {
      if (i < customTokenTexts.length &&
          customTokenTextsKeyContaines(rawTexts[j], i)) {
        String key = customTokenTexts.keys.elementAt(i);
        i++;
        j += key.split(" ").length;
        customTokenTexts[key]!.token = customTokenTexts[key]!.token
          ..replaceAll('\n', '')
          ..replaceAll('\t', '');
        if (customTokenTexts[key]!.token != '') {
          result.add(customTokenTexts[key]!);
        }
      } else {
        String token = removeAllHtmlTags(rawTexts[j]);
        if (token != "" && token != '\n' && token != '\t') {
          result.add(SubtitleToken(
              token: token.trim(),
              tokenStyle: TextStyle(color: Colors.white),
              description: ''));
        }
        j++;
      }
    }

    return result;
  }

  String removeAllHtmlTags(String htmlText) {
    final exp = RegExp(
      '(<[^>]*>)',
      multiLine: true,
    );
    var newHtmlText = htmlText;
    exp.allMatches(htmlText).toList().forEach(
      (RegExpMatch regExpMathc) {
        newHtmlText = newHtmlText.replaceAll(regExpMathc.group(0)!, '');
      },
    );
    return newHtmlText;
  }
}
