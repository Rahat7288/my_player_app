import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/constants.dart';
import 'mdeia_state.dart';
import 'media_event.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  static const platformChannel = MethodChannel(METHOD_CHANNEL);
  late StreamSubscription _playerStateSubscription;

  MediaBloc() : super(MediaInitialState()) {
    _initializePlatformChannel();
  }

  void _initializePlatformChannel() {
    MethodChannel methodChannel = MethodChannel(METHOD_CHANNEL);

    Future<dynamic> methodCallHandler(MethodCall call) async {
      try {
        switch (call.method) {
          case 'playerStateChanged':
            final Map<String, dynamic>? arguments = call.arguments;
            if (arguments == null) {
              return null;
              return;
            }

            final String? state = arguments['state'];
            if (state == 'completed') {
              add(StopMedia());
            } else if (state == 'error') {
              final String? message = arguments['message'];
              if (message != null) {
                add(ErrorEvent(message: message));
              }
            }
            break;

          default:
            return null; // Instead of notImplemented()
        }
      } catch (e) {
        return null; // Instead of error()
      }
    }

    methodChannel.setMethodCallHandler(methodCallHandler);
  }

  @override
  Stream<MediaState> mapEventToState(MediaEvent event) async* {
    if (event is PlayMedia) {
      yield PlayingState(
        url: event.url,
        isBuffering: true,
      );

      try {
        await platformChannel.invokeMethod(PLAY_EVENT, {'url': event.url});
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is PauseMedia) {
      yield PausedState(
        url: (state as PlayingState).url,
        position: (state as PlayingState).position,
      );
      await platformChannel.invokeMethod(PAUSE_EVENT);
    } else if (event is StopMedia) {
      yield StoppedState();
      await platformChannel.invokeMethod(STOP_EVENT);
    } else if (event is SeekMedia) {
      await platformChannel.invokeMethod('seek', {'position': event.position});
    } else if (event is ErrorEvent) {
      yield ErrorState(event.message);
    }
  }

  @override
  Future<void> close() async {
    _playerStateSubscription.cancel();
    await platformChannel.invokeMethod(STOP_EVENT);
    return super.close();
  }
}
