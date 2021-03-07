import 'package:equatable/equatable.dart';

class Subtitle extends Equatable {
  final Duration startTime;
  final Duration endTime;
  final String text;

  const Subtitle({
    required this.startTime,
    required this.endTime,
    required this.text,
  });

  @override
  List<Object?> get props => [startTime, endTime, text];
}
