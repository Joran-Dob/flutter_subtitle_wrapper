import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtitle_wrapper_package/bloc/subtitle/subtitle_bloc.dart';
import 'package:subtitle_wrapper_package/data/constants/view_keys.dart';
import 'package:subtitle_wrapper_package/data/models/style/subtitle_style.dart';

class SubtitleTextView extends StatelessWidget {
  final SubtitleStyle subtitleStyle;
  final Color? backgroundColor;

  const SubtitleTextView({
    Key? key,
    required this.subtitleStyle,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subtitleBloc = BlocProvider.of<SubtitleBloc>(context);

    return BlocConsumer<SubtitleBloc, SubtitleState>(
      // TODO (Joran-Dob), improve this workaround.
      // ignore: prefer-extracting-callbacks, this is a workaround for the issue
      listener: (context, state) {
        if (state is SubtitleInitialized) {
          subtitleBloc.add(LoadSubtitle());
        }
      },
      builder: (context, state) {
        return state is LoadedSubtitle
            ? Stack(
                children: <Widget>[
                  if (subtitleStyle.hasBorder)
                    Center(
                      child: Container(
                        color: backgroundColor,
                        child: Text(
                          state.subtitle!.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: subtitleStyle.fontSize,
                            foreground: Paint()
                              ..style = subtitleStyle.borderStyle.style
                              ..strokeWidth = subtitleStyle.borderStyle.strokeWidth
                              ..color = subtitleStyle.borderStyle.color,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(),
                  Center(
                    child: Container(
                      color: backgroundColor,
                      child: Text(
                        state.subtitle!.text,
                        key: ViewKeys.subtitleTextContent,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: subtitleStyle.fontSize,
                          color: subtitleStyle.textColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container();
      },
    );
  }
}
