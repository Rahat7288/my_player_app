import 'package:flutter/services.dart';

class NativeCommunication {
  static const MethodChannel _channel = MethodChannel('com.example.app/media');

  Future<void> playMedia(String url) async {
    try {
      await _channel.invokeMethod('playMedia', {'url': url});
    } catch (e) {
      print("Failed to play media: '${e.toString()}'.");
    }
  }
}