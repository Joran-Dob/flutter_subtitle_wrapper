import 'package:flutter/material.dart';
import 'package:subtitle_wrapper_package/models/subtitle.dart';
import 'package:subtitle_wrapper_package/models/subtitles.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';
import 'package:video_player/video_player.dart';

class SubtitleTextView extends StatefulWidget {
  final SubtitleController subtitleController;
  final VideoPlayerController videoPlayerController;

  const SubtitleTextView(
      {Key key, @required this.subtitleController, this.videoPlayerController})
      : super(key: key);

  @override
  _SubtitleTextViewState createState() =>
      _SubtitleTextViewState(videoPlayerController);
}

class _SubtitleTextViewState extends State<SubtitleTextView> {
  final VideoPlayerController videoPlayerController;
  Subtitle subtitle;

  _SubtitleTextViewState(this.videoPlayerController);

  @override
  void initState() {
    videoPlayerController
        .addListener(() => _subtitleWatcher(videoPlayerController));

    _subtitleWatcher(videoPlayerController);
    super.initState();
  }

  _subtitleWatcher(VideoPlayerController videoPlayerController) async {
    Subtitles subtitles = await widget.subtitleController.getSubtitles();
    VideoPlayerValue latestValue = videoPlayerController.value;

    Duration videoPlayerPosition = latestValue.position;
    if (videoPlayerPosition != null) {
      subtitles.subtitles.forEach((Subtitle subtitleItem) {
        if (videoPlayerPosition.inMilliseconds >
                subtitleItem.startTime.inMilliseconds &&
            videoPlayerPosition.inMilliseconds <
                subtitleItem.endTime.inMilliseconds) {
          setState(() {
            subtitle = subtitleItem;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return subtitle != null
        ? Container(
            child: Stack(
              children: <Widget>[
                // Stroked text as border.
                Center(
                  child: Text(
                    subtitle.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.black,
                    ),
                  ),
                ),
                // Solid text as fill.
                Center(
                  child: Text(
                    subtitle.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            child: null,
          );
  }
}
