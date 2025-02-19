// ui/media_player_screen.dart
import 'package:flutter/material.dart';

import '../../core/utils/Communication_channel.dart';

class MediaControlScreen extends StatefulWidget {
  @override
  _MediaControlScreenState createState() => _MediaControlScreenState();
}

class _MediaControlScreenState extends State<MediaControlScreen> {
  final NativeCommunication _nativeCommunication = NativeCommunication();
  bool isPlaying = false;

  void playMedia() {
    _nativeCommunication.playMedia('https://www.w3schools.com/html/mov_bbb.mp4');
    setState(() {
      isPlaying = true;
    });
  }

  // void pauseMedia() {
  //   _nativeCommunication.pauseMedia();
  //   setState(() {
  //     isPlaying = false;
  //   });
  // }
  //
  // void seekMedia(double position) {
  //   _nativeCommunication.seekMedia(position);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Media Control')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isPlaying ? null : playMedia,
              child: Text('Play'),
            ),
            // ElevatedButton(
            //   onPressed: isPlaying ? pauseMedia : null,
            //   child: Text('Pause'),
            // ),
            Slider(
              value: 0.0, // Update this with the current position
              onChanged: (value) {
                // seekMedia(value);
              },
              min: 0.0,
              max: 100.0, // Set this to the media duration
            ),
          ],
        ),
      ),
    );
  }
}