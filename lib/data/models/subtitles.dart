import 'package:equatable/equatable.dart';
import 'package:subtitle_wrapper_package/data/models/subtitle.dart';

class Subtitles extends Equatable {
  final List<Subtitle> subtitles;

  Subtitles({this.subtitles});

  @override
  List<Object> get props => [
        this.subtitles,
      ];
}
