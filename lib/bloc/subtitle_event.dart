part of 'subtitle_bloc.dart';

abstract class SubtitleEvent extends Equatable {
  const SubtitleEvent();
}

class InitSubtitles extends SubtitleEvent {
  final SubtitleController subtitleController;

  InitSubtitles({@required this.subtitleController});

  @override
  List<Object> get props => [this.subtitleController];
}

class LoadSubtitle extends SubtitleEvent {
  @override
  List<Object> get props => [];
}

class UpdateLoadedSubtitle extends SubtitleEvent {
  final Subtitle subtitle;

  UpdateLoadedSubtitle({this.subtitle});
  @override
  List<Object> get props => [];
}
