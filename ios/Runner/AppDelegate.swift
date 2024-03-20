import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)
//    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
//    let channel = FlutterMethodChannel(name: "com.example.uva_bus_lines/channel",
//                                       binaryMessenger: controller.binaryMessenger)
//
//    channel.setMethodCallHandler({
//        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//        if call.method == "setMapsApiKey" {
//            if let key = call.arguments as? String {
//                GMSServices.provideAPIKey(key)
//            }
//        }
//    })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}