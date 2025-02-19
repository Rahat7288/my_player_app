package com.example.my_player
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.common.MediaItem
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.app/media"
    private lateinit var player: ExoPlayer

    override
    fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "playMedia") {
                val url = call.argument<String>("url")
                playMedia(url)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }


    }

    private fun playMedia(url: String?) {
        player = ExoPlayer.Builder(this).build()
        val mediaItem = MediaItem.fromUri(url!!)
        player.setMediaItem(mediaItem)
        player.prepare()
        player.play()
    }

    private fun pauseMedia() {
        player.pause()
    }

    private fun seekMedia(position: Float) {
        player.seekTo((position * player.duration).toLong())
    }
}