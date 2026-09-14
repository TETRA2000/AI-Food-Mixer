import Foundation

/// Read-only facts about the running app, surfaced in Settings > About.
enum AppInfo {
    /// The marketing version (`CFBundleShortVersionString`) of `bundle`,
    /// or `"—"` when the bundle carries no version string.
    static func version(in bundle: Bundle = .main) -> String {
        guard let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
              !version.isEmpty else {
            return "—"
        }
        return version
    }

    /// The minimum iOS release the app runs on.
    static let platform = "iOS 27"
}
