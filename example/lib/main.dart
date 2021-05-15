import 'package:chewie/chewie.dart';
import 'package:example/data/sw_constants.dart';
import 'package:flutter/material.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart'
    show SubtitleController, SubtitleDecoder;
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart'
    show SubTitleWrapper;
import 'package:subtitle_wrapper_package/data/models/style/subtitle_style.dart'
    show SubtitleStyle;
import 'package:subtitle_wrapper_package/data/models/tag.dart' show Tag;
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String link = SwConstants.videoUrl;
  final SubtitleController subtitleController = SubtitleController(
    subtitleUrl: SwConstants.enSubtitle,
    subtitleDecoder: SubtitleDecoder.utf8,
  );

  VideoPlayerController get videoPlayerController {
    return VideoPlayerController.network(
        'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8');
  }

  ChewieController get chewieController {
    return ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      autoInitialize: true,
      allowFullScreen: false,
    );
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
    final localChewieController = chewieController;

    return Scaffold(
      backgroundColor: const Color(0xff0b090a),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            child: SizedBox(
              height: 250,
              child: SubTitleWrapper(
                tags: [
                  // Tag(
                  //   id: "a",
                  //   name: "504",
                  //   color: Colors.orange,
                  //   description: "from 504 words",
                  // )
                ],
                videoPlayerController:
                    localChewieController.videoPlayerController,
                subtitleController: subtitleController,
                subtitleStyle: const SubtitleStyle(
                  textColor: Colors.white,
                  hasBorder: true,
                ),
                videoChild: Chewie(
                  controller: localChewieController,
                ),
                onBackButtonPress: (controller, prevSub) {
                  controller
                      .seekTo(prevSub.startTime + Duration(seconds: 1))
                      .then((_) => controller.pause());
                },
                onSubtitleTokenTap: (e, videoPlayerController) {
                  if (e.description == "") {
                    return;
                  }
                  debugPrint(e.token);
                  videoPlayerController.pause();
                  showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  e.token,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              Text(
                                e.description +
                                    " description goes here and it's all about this word. we all try for you to learn better",
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(
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
                          const Divider(
                            color: Colors.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  elevation:
                                      MaterialStateProperty.all<double>(8.0),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        8.0,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () => updateSubtitleUrl(
                                  subtitleLanguage:
                                      ExampleSubtitleLanguage.english,
                                ),
                                child: const Text('Switch to 🇬🇧'),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  elevation:
                                      MaterialStateProperty.all<double>(8.0),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        8.0,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () => updateSubtitleUrl(
                                  subtitleLanguage:
                                      ExampleSubtitleLanguage.spanish,
                                ),
                                child: const Text('Switch to 🇪🇸'),
                              ),
                              // ElevatedButton(
                              //   style: ButtonStyle(
                              //     elevation:
                              //         MaterialStateProperty.all<double>(8.0),
                              //     shape: MaterialStateProperty.all<
                              //         RoundedRectangleBorder>(
                              //       RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(
                              //           8.0,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              //   onPressed: () => updateSubtitleUrl(
                              //     subtitleLanguage:
                              //         ExampleSubtitleLanguage.dutch,
                              //   ),
                              //   child: const Text('Switch to 🇳🇱'),
                              // ),
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
