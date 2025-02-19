abstract class MediaState {}

class MediaInitialState extends MediaState {}

class PlayingState extends MediaState {
  final String url;
  final double position;
  final bool isBuffering;

  PlayingState({
    required this.url,
    this.position = 0.0,
    this.isBuffering = false,
  });

  PlayingState copyWith({
    String? url,
    double? position,
    bool? isBuffering,
  }) =>
      PlayingState(
        url: url ?? this.url,
        position: position ?? this.position,
        isBuffering: isBuffering ?? this.isBuffering,
      );
}

class PausedState extends MediaState {
  final String url;
  final double position;

  PausedState({
    required this.url,
    required this.position,
  });
}

class StoppedState extends MediaState {}

class ErrorState extends MediaState {
  final String message;

  ErrorState(this.message);
}