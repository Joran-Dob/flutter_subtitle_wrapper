import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtitle_wrapper_package/bloc/subtitle/subtitle_bloc.dart';
import 'package:subtitle_wrapper_package/data/constants/view_keys.dart';
import 'package:subtitle_wrapper_package/data/data.dart';

class SubtitleTextView extends StatelessWidget {
  const SubtitleTextView({
    super.key,
    this.textStyle,
    this.backgroundColor,
  });

  final TextStyle? textStyle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubtitleBloc, SubtitleState>(
      builder: (context, state) {
        if (state is LoadedSubtitle && state.subtitle != null) {
          return Stack(
            children: <Widget>[
              Center(
                child: Container(
                  color: backgroundColor,
                  child: _TextContent(
                    text: state.subtitle!.text,
                    textStyle: textStyle,
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _TextContent extends StatelessWidget {
  const _TextContent({
    required this.text,
    this.textStyle,
  });

  final TextStyle? textStyle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      key: ViewKeys.subtitleTextContent,
      textAlign: TextAlign.center,
      style: textStyle,
    );
  }
}
