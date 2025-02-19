import Flutter
import UIKit
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var player: AVPlayer?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.app/media", binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "playMedia" {
                if let args = call.arguments as? [String: Any],
                   let url = args["url"] as? String {
                    self.playMedia(url: url)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "URL is required", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func playMedia(url: String) {
        guard let url = URL(string: url) else { return }
        player = AVPlayer(url: url)
        player?.play()
    }

    private func pauseMedia() {
        player?.pause()
    }

    private func seekMedia(position: Float) {
        let newPosition = CMTime(seconds: Double(position), preferredTimescale: 1)
        player?.seek(to: newPosition)
    }
}