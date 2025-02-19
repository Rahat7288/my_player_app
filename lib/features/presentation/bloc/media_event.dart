abstract class MediaEvent {}

class PlayMedia extends MediaEvent {
  final String url;

  PlayMedia({required this.url});
}

class PauseMedia extends MediaEvent {}

class StopMedia extends MediaEvent {}

class SeekMedia extends MediaEvent {
  final double position;

  SeekMedia({required this.position});
}

class ErrorEvent extends MediaEvent {
  final String message;

  ErrorEvent({required this.message});
}