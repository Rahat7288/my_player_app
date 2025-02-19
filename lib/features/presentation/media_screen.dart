// ui/media_player_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/constants.dart';
import 'bloc/mdeia_state.dart';
import 'bloc/media_bloc.dart';
import 'bloc/media_event.dart';

class MediaPlayerScreen extends StatelessWidget {
  final MediaBloc mediaBloc;

  const MediaPlayerScreen({
    required this.mediaBloc,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Player'),
      ),
      body: Center(
        child: BlocBuilder<MediaBloc, MediaState>(
          bloc: mediaBloc,
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play/Pause Button
                ElevatedButton(
                  onPressed: () => _handlePlayback(context, state),
                  child: Text(state is PlayingState ? 'Pause' : 'Play'),
                ),

                SizedBox(height: 16),

                // Stop Button
                ElevatedButton(
                  onPressed: () => mediaBloc.add(StopMedia()),
                  child: Text('Stop'),
                ),

                SizedBox(height: 32),

                // Progress Slider
                _buildProgressSlider(state),

                SizedBox(height: 16),

                // Status Text
                Text(_getStatusText(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handlePlayback(BuildContext context, MediaState state) {
    if (state is PlayingState || state is PausedState) {
      mediaBloc.add(PauseMedia());
    } else {
      mediaBloc.add(PlayMedia(url: SAMPLE_AUDIO_URL));
    }
  }

  Widget _buildProgressSlider(MediaState state) {
    if (state is PlayingState || state is PausedState) {
      return Slider(
        value: (state as dynamic).position,
        min: 0.0,
        max: 100.0,
        onChanged: (value) => mediaBloc.add(SeekMedia(position: value)),
      );
    }
    return Container();
  }

  String _getStatusText(MediaState state) {
    if (state is PlayingState) {
      return 'Playing${(state.isBuffering ? '...' : '')}';
    } else if (state is PausedState) {
      return 'Paused';
    } else if (state is ErrorState) {
      return 'Error: ${state.message}';
    }
    return 'Stopped';
  }
}