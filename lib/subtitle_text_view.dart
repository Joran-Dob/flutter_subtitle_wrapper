import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtitle_wrapper_package/bloc/subtitle/subtitle_bloc.dart';
import 'package:subtitle_wrapper_package/data/models/style/subtitle_style.dart';

class SubtitleTextView extends StatelessWidget {
  final SubtitleStyle subtitleStyle;

  const SubtitleTextView({Key? key, required this.subtitleStyle})
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
          return Row(children: [
            SizedBox(
              width: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  substitleBloc.videoPlayerController
                      .seekTo(
                          state.prevSubtitle!.startTime + Duration(seconds: 1))
                      .then((_) => substitleBloc.videoPlayerController.pause());
                },
              ),
            ),
            SizedBox(
              width: 250,
              child: Stack(
                children: <Widget>[
                  if (subtitleStyle.hasBorder)
                    Center(
                      child: Wrap(
                        children: state.subtitle!.subtitleTokens
                            .map((e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  child: Text(
                                    e.token!,
                                    softWrap: true,
                                    style: e.tokenStyle!.copyWith(
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: InkWell(
                                  onTap: () {
                                    debugPrint(e.token);
                                    substitleBloc.videoPlayerController.pause();
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    e.token!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5,
                                                  ),
                                                ),
                                                Text(
                                                  "e.description! description goes here and it's all about this word. we all try for you to learn better",
                                                  textAlign: TextAlign.left,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Text(e.token!,
                                      style: e.tokenStyle,
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
