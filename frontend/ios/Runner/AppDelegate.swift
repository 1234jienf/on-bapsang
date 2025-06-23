import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let apiKey = plist["GOOGLE_MAPS_API_KEY"] as? String {
          GMSServices.provideAPIKey(apiKey)
        }

    GeneratedPluginRegistrant.register(with: self)


    // MethodChannel 설정
        let controller = window?.rootViewController as! FlutterViewController
        let configChannel = FlutterMethodChannel(name: "com.example.frontend/config",
                                               binaryMessenger: controller.binaryMessenger)

        configChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
          switch call.method {
          case "getGoogleMapsApiKey":
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
               let plist = NSDictionary(contentsOfFile: path),
               let apiKey = plist["GOOGLE_MAPS_API_KEY"] as? String {
              result(apiKey)
            } else {
            print("API KEY ERROR")
              result(FlutterError(code: "ERROR", message: "API key not found", details: nil))
            }
          default:
            result(FlutterMethodNotImplemented)
          }
        }


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
