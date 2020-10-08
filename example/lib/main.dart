import 'package:chewie/chewie.dart';
import 'package:example/data/sw_constants.dart';
import 'package:flutter/material.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';
import 'package:subtitle_wrapper_package/data/models/style/subtitle_style.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(
        SwConstants.videoUrl,
      );
}

class _MyHomePageState extends State<MyHomePage> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  final String link;
  final SubtitleController subtitleController = SubtitleController(
    subtitleUrl: SwConstants.enSubtitle,
    showSubtitles: true,
    subtitleDecoder: SubtitleDecoder.utf8,
    subtitleType: SubtitleType.webvtt,
  );

  _MyHomePageState(
    this.link,
  );

  VideoPlayerController getVideoPlayerController() {
    videoPlayerController ??= VideoPlayerController.network(link);
    return videoPlayerController;
  }

  ChewieController getChewieController() {
    chewieController ??= ChewieController(
      videoPlayerController: getVideoPlayerController(),
      aspectRatio: 3 / 2,
      autoPlay: true,
      autoInitialize: true,
      allowFullScreen: false,
    );
    return chewieController;
  }

  void updateSubtitleUrl({
    ExampleSubtitleLanguage subtitleLanguage,
  }) {
    String subtitleUrl;
    switch (subtitleLanguage) {
      case ExampleSubtitleLanguage.english:
        subtitleUrl = SwConstants.enSubtitle;
        break;
      case ExampleSubtitleLanguage.spanish:
        subtitleUrl = SwConstants.esSubtitle;
        break;
      case ExampleSubtitleLanguage.dutch:
        subtitleUrl = SwConstants.nlSubtitle;
        break;
      default:
    }
    if (subtitleUrl != null) {
      subtitleController.updateSubtitleUrl(
        url: subtitleUrl,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var chewieController = getChewieController();

    return Scaffold(
      backgroundColor: Color(0xff0b090a),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            child: SubTitleWrapper(
              videoPlayerController: chewieController.videoPlayerController,
              subtitleController: subtitleController,
              subtitleStyle: SubtitleStyle(
                textColor: Colors.white,
                hasBorder: true,
              ),
              videoChild: Chewie(
                controller: chewieController,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Color(
                0xff161a1d,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(
                        16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Flutter subtitle wrapper package',
                            style: TextStyle(
                              fontSize: 28.0,
                              color: Colors.white.withOpacity(
                                0.8,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 18.0,
                            ),
                            child: Text(
                              'This package can display SRT and WebVtt subtitles. With a lot of customizable options and dynamic updating support.',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white.withOpacity(
                                  0.8,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Options.',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white.withOpacity(
                                0.8,
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RaisedButton(
                                elevation: 6.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    8.0,
                                  ),
                                ),
                                onPressed: () => updateSubtitleUrl(
                                  subtitleLanguage:
                                      ExampleSubtitleLanguage.english,
                                ),
                                child: Text('Switch to 🇬🇧'),
                              ),
                              RaisedButton(
                                elevation: 6.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    8.0,
                                  ),
                                ),
                                onPressed: () => updateSubtitleUrl(
                                  subtitleLanguage:
                                      ExampleSubtitleLanguage.spanish,
                                ),
                                child: Text('Switch to 🇪🇸'),
                              ),
                              RaisedButton(
                                elevation: 6.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    8.0,
                                  ),
                                ),
                                onPressed: () => updateSubtitleUrl(
                                  subtitleLanguage:
                                      ExampleSubtitleLanguage.dutch,
                                ),
                                child: Text('Switch to 🇳🇱'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (videoPlayerController != null && chewieController != null) {
      videoPlayerController?.dispose();
      chewieController?.dispose();
    }
  }
}

enum ExampleSubtitleLanguage {
  english,
  spanish,
  dutch,
}
