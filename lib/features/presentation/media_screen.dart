import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerScreen extends StatefulWidget {
  final String url;

  const PlayerScreen({Key? key, required this.url}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  static const platform = MethodChannel('com.example.app/media');

  @override
  void initState() {
    super.initState();
    // playMedia();
  }

  Future<void> playMedia() async {
    try {
      await platform.invokeMethod('playMedia', {'url': widget.url});
    } on PlatformException catch (e) {
      print("Failed to play media: '${e.message}'.");
    }
  }

  Future<void> pauseMedia() async {
    try {
      await platform.invokeMethod('pauseMedia');
    } on PlatformException catch (e) {
      print("Failed to pause media: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Player'),
        actions: [
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: pauseMedia,
          ),
        ],
      ),
      body: const Center(
        child: Text('Video is playing...'),
      ),
    );
  }
}
