// ios/Runner/AppDelegate.swift
import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var avPlayer: AVPlayer?
    private let channel = MethodChannel(name: METHOD_CHANNEL, binaryMessenger: flutterEngine?.binaryMessenger)
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GeneratedPluginRegistrant.ensureInitialized()
        
        let controller = window?.rootViewController as? FlutterViewController
        
        channel.setMethodCallHandler({ [weak self] call, result in
            switch call.method {
                case PLAY_EVENT:
                    self?.playMedia(url: call.arguments as? String)
                    result(nil)
                case PAUSE_EVENT:
                    self?.pauseMedia()
                    result(nil)
                case STOP_EVENT:
                    self?.stopMedia()
                    result(nil)
                case "getPosition":
                    self?.getPosition(result)
                case "seek":
                    self?.seekTo(position: call.arguments as? Double)
                default:
                    result(FlutterMethodNotImplemented)
            }
        })
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func playMedia(url: String?) {
        guard let url = url, let playerUrl = URL(string: url) else { return }
        avPlayer = AVPlayer(url: playerUrl)
        NotificationCenter.default.addObserver(self,
                                           selector: #selector(playerItemDidReachEnd),
                                           name: .AVPlayerItemDidPlayToEndTime,
                                           object: nil)
        avPlayer?.play()
    }

    @objc private func playerItemDidReachEnd() {
        channel.invokeMethod(COMPLETED_EVENT, arguments: nil)
    }

    private func pauseMedia() {
        avPlayer?.pause()
    }

    private func stopMedia() {
        avPlayer = nil
    }

    private func getPosition(_ result: FlutterResult) {
        result(avPlayer?.currentTime().seconds ?? 0.0)
    }

    private func seekTo(position: Double?) {
        guard let position = position else { return }
        avPlayer?.seek(to: CMTime(seconds: position, preferredTimescale: CMTimeScale(1)))
    }
}