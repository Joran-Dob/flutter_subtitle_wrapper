import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtitle_wrapper_package/bloc/subtitle/subtitle_bloc.dart';
import 'package:subtitle_wrapper_package/data/models/style/subtitle_style.dart';
import 'package:subtitle_wrapper_package/data/models/subtitle.dart';
import 'package:subtitle_wrapper_package/data/models/subtitle_token.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class SubtitleTextView extends StatelessWidget {
  final SubtitleStyle subtitleStyle;
  Function(SubtitleToken, VideoPlayerController) onSubtitleTokenTap;
  Function(VideoPlayerController controller, Subtitle? prevSub)
      onBackButtonPress;

  SubtitleTextView(
      {Key? key,
      required this.subtitleStyle,
      required this.onSubtitleTokenTap,
      required this.onBackButtonPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final substitleBloc = BlocProvider.of<SubtitleBloc>(context);

    return BlocConsumer<SubtitleBloc, SubtitleState>(
      listener: (context, state) {
        if (state is SubtitleInitialized) {
          substitleBloc.add(LoadSubtitle());
        }
      },
      builder: (context, state) {
        if (state is LoadedSubtitle) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Center(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back,color: Theme.of(context).accentColor,),
                    onPressed: () => onBackButtonPress(
                        substitleBloc.videoPlayerController,
                        state.prevSubtitle!),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.shortestSide * 0.8,
                  child: Stack(
                    children: <Widget>[
                      if (subtitleStyle.hasBorder)
                        Center(
                          child: Wrap(
                            children: state.subtitle!.subtitleTokens
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      child: Text(
                                        e.token,
                                        softWrap: true,
                                        style: e.tokenStyle.copyWith(
                                          fontSize: subtitleStyle.fontSize,
                                          foreground: Paint()
                                            ..style =
                                                subtitleStyle.borderStyle.style
                                            ..strokeWidth = subtitleStyle
                                                .borderStyle.strokeWidth
                                            ..color =
                                                subtitleStyle.borderStyle.color,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ))
                                .toList(),
                          ),
                        )
                      else
                        Container(),
                      Center(
                        child: Wrap(
                          children: state.subtitle!.subtitleTokens
                              .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    child: InkWell(
                                      onTap: () => onSubtitleTokenTap(e,
                                          substitleBloc.videoPlayerController),
                                      child: Text(e.token,
                                          style: e.tokenStyle.copyWith(
                                            fontSize: subtitleStyle.fontSize,
                                          ),
                                          softWrap: true,
                                          textAlign: TextAlign.center),
                                    ),
                                  ))
                              .toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ]);
        } else {
          return Container();
        }
      },
    );
  }
}
