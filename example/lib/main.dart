import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';
import 'package:subtitle_wrapper_package/models/style/subtitle_style.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(
      "https://d11b76aq44vj33.cloudfront.net/media/720/video/5def7824adbbc.mp4",
      "https://d11b76aq44vj33.cloudfront.net/media/720/subtitles/5def7825b0c1b.vtt");
}

class _MyHomePageState extends State<MyHomePage> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  final String link;
  final String subtitleUrl;

  _MyHomePageState(this.link, this.subtitleUrl);

  VideoPlayerController getVideoPlayerController() {
    if (videoPlayerController == null) {
      videoPlayerController = new VideoPlayerController.network(link);
    }
    return videoPlayerController;
  }

  ChewieController getChewieController() {
    if (chewieController == null) {
      chewieController = ChewieController(
        videoPlayerController: getVideoPlayerController(),
        aspectRatio: 3 / 2,
        autoPlay: true,
        autoInitialize: true,
      );
    }
    return chewieController;
  }

  @override
  Widget build(BuildContext context) {
    ChewieController chewieController = getChewieController();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
          elevation: 2.0,
          child: SubTitleWrapper(
              videoPlayerController: chewieController.videoPlayerController,
              subtitleController: SubtitleController(
                subtitleUrl: subtitleUrl,
                showSubtitles: true,
              ),
              subtitleStyle:
                  SubtitleStyle(textColor: Colors.white, hasBorder: true),
              videoChild: Chewie(
                controller: chewieController,
              ))),
    );
  }

  @override
  void dispose() {
    super.dispose();
//    if (videoPlayerController != null && chewieController != null) {
//      videoPlayerController?.dispose();
//      chewieController?.dispose();
//    }
    debugPrint('videoPlayerController - dispose()');
  }
}
