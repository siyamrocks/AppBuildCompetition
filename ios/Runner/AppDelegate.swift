import UIKit
import Flutter
import Firebase
import OneSignal

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    OneSignal.initWithLaunchOptions(launchOptions)
    OneSignal.setAppId("2244a21f-4b0f-4628-8094-2396c8718394")
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
