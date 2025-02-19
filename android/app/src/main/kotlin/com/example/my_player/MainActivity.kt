package com.example.my_player

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.source.ProgressiveMediaSource
import com.google.android.exoplayer2.upstream.DefaultDataSourceFactory

class MainActivity : FlutterActivity() {
    private lateinit var player: ExoPlayer
    private val channel = MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, METHOD_CHANNEL)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize ExoPlayer
        player = ExoPlayer.Builder(this).build()

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                PLAY_EVENT -> playMedia(call.arguments as String)
                PAUSE_EVENT -> pauseMedia()
                STOP_EVENT -> stopMedia()
                "getPosition" -> getPosition(result)
                "seek" -> seekTo(call.arguments as Double)
            }
        }
    }

    private fun playMedia(url: String) {
        val mediaSource = ProgressiveMediaSource.Factory(DefaultDataSourceFactory(this))
            .createMediaSource(MediaItem.fromUri(Uri.parse(url)))
        player.setMediaSource(mediaSource)
        player.prepare()
        player.play()
    }

    private fun pauseMedia() {
        player.pause()
    }

    private fun stopMedia() {
        player.stop()
        player.release()
    }

    private fun getPosition(result: MethodChannel.Result) {
        result.success(player.currentPosition.toDouble())
    }

    private fun seekTo(position: Double) {
        player.seekTo(position.toLong())
    }
}


