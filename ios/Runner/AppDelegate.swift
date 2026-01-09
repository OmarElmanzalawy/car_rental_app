import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  private func paddedBase64(_ value: String) -> String {
    let remainder = value.count % 4
    if remainder == 0 { return value }
    return value.padding(toLength: value.count + (4 - remainder), withPad: "=", startingAt: 0)
  }

  private func parseDartDefines(_ dartDefines: String) -> [String: String] {
    var result: [String: String] = [:]
    for part in dartDefines.split(separator: ",") {
      let encoded = String(part)
      let padded = paddedBase64(encoded)
      guard let data = Data(base64Encoded: padded) else { continue }
      guard let decoded = String(data: data, encoding: .utf8) else { continue }
      let pieces = decoded.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
      if pieces.count != 2 { continue }
      result[String(pieces[0])] = String(pieces[1])
    }
    return result
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let dartDefines = Bundle.main.object(forInfoDictionaryKey: "FlutterDartDefines") as? String
    let defines = dartDefines.map(parseDartDefines) ?? [:]
    let apiKeyFromDefines = defines["GOOGLE_MAPS_API_KEY"]?.trimmingCharacters(in: .whitespacesAndNewlines)
    let apiKeyFromPlist = (Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
    let apiKey = (apiKeyFromDefines?.isEmpty == false ? apiKeyFromDefines : nil) ?? (apiKeyFromPlist?.isEmpty == false ? apiKeyFromPlist : nil)

    if let apiKey {
      GMSServices.provideAPIKey(apiKey)
    } else {
      print("❌ ERROR: Google Maps API key not found (FlutterDartDefines/GOOGLE_MAPS_API_KEY or GMSApiKey).")
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
