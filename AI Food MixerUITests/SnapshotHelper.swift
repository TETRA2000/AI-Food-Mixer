//
//  SnapshotHelper.swift
//  AI Food MixerUITests
//
//  Based on fastlane snapshot SnapshotHelper.
//  https://github.com/fastlane/fastlane/blob/master/snapshot/lib/assets/SnapshotHelper.swift
//

import Foundation
import XCTest

var deviceLanguage = ""
var locale = ""

func setupSnapshot(_ app: XCUIApplication, waitForAnimations: Bool = true) {
    Snapshot.setupSnapshot(app, waitForAnimations: waitForAnimations)
}

func snapshot(_ name: String, waitForLoadingIndicator: Bool = true, timeWaitingForIdle timeout: TimeInterval = 20) {
    if waitForLoadingIndicator {
        Snapshot.snapshot(name, timeWaitingForIdle: timeout)
    } else {
        Snapshot.snapshot(name, timeWaitingForIdle: 0)
    }
}

enum Snapshot {
    static var app: XCUIApplication?
    static var waitForAnimations = true
    static var cacheDirectory: URL?
    static var screenshotsDirectory: URL? {
        return cacheDirectory
    }

    static func setupSnapshot(_ app: XCUIApplication, waitForAnimations: Bool = true) {
        Snapshot.app = app
        Snapshot.waitForAnimations = waitForAnimations

        do {
            let cacheDir = try getCacheDirectory()
            Snapshot.cacheDirectory = cacheDir
            setLanguage(app)
            setLocale(app)
            setLaunchArguments(app)
        } catch {
            NSLog("Snapshot: Error setting up snapshot: \(error)")
        }
    }

    static func setLanguage(_ app: XCUIApplication) {
        guard let cacheDirectory = cacheDirectory else { return }
        let path = cacheDirectory.appendingPathComponent("language.txt")

        do {
            let trimCharacterSet = CharacterSet.whitespacesAndNewlines
            deviceLanguage = try String(contentsOf: path, encoding: .utf8).trimmingCharacters(in: trimCharacterSet)
            app.launchArguments += ["-AppleLanguages", "(\(deviceLanguage))"]
        } catch {
            NSLog("Snapshot: Couldn't detect language; using defaults")
        }
    }

    static func setLocale(_ app: XCUIApplication) {
        guard let cacheDirectory = cacheDirectory else { return }
        let path = cacheDirectory.appendingPathComponent("locale.txt")

        do {
            let trimCharacterSet = CharacterSet.whitespacesAndNewlines
            locale = try String(contentsOf: path, encoding: .utf8).trimmingCharacters(in: trimCharacterSet)
        } catch {
            NSLog("Snapshot: Couldn't detect locale; using defaults")
        }

        if locale.isEmpty, !deviceLanguage.isEmpty {
            locale = Locale(identifier: deviceLanguage).identifier
        }

        if !locale.isEmpty {
            app.launchArguments += ["-AppleLocale", "\"\(locale)\""]
        }
    }

    static func setLaunchArguments(_ app: XCUIApplication) {
        guard let cacheDirectory = cacheDirectory else { return }
        let path = cacheDirectory.appendingPathComponent("snapshot-launch_arguments.txt")

        app.launchArguments += ["-FASTLANE_SNAPSHOT", "YES", "-UITests", "YES"]

        do {
            let launchArguments = try String(contentsOf: path, encoding: .utf8)
            let regex = try NSRegularExpression(pattern: "(\\\".+?\\\"|\\S+)")
            let matches = regex.matches(in: launchArguments, range: NSRange(location: 0, length: launchArguments.count))
            let results = matches.map { result -> String in
                (launchArguments as NSString).substring(with: result.range)
            }
            app.launchArguments += results
        } catch {
            NSLog("Snapshot: Couldn't detect launch arguments; using defaults")
        }
    }

    static func snapshot(_ name: String, timeWaitingForIdle timeout: TimeInterval = 20) {
        guard let app = app else {
            NSLog("Snapshot: XCUIApplication is not set. Call setupSnapshot(app) first.")
            return
        }

        if waitForAnimations {
            sleep(1)
        }

        NSLog("Snapshot: Taking snapshot '\(name)'")

        let screenshot = app.screenshot()
        guard var cacheDirectory = cacheDirectory else {
            NSLog("Snapshot: Cache directory not set")
            return
        }

        do {
            let png = screenshot.pngRepresentation
            cacheDirectory.appendPathComponent("\(name).png")
            try png.write(to: cacheDirectory)
        } catch {
            NSLog("Snapshot: Error writing screenshot: \(error)")
        }

        // Also attach to test results for Xcode viewing
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        XCTContext.runActivity(named: "Snapshot: \(name)") { activity in
            activity.add(attachment)
        }
    }

    static func getCacheDirectory() throws -> URL {
        let cachePath = "tmp/fastlane/screenshots"
        let url = URL(fileURLWithPath: cachePath, isRelative: true)
        let cacheDir = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(cachePath)

        // Also check environment variable
        if let envPath = ProcessInfo().environment["SNAPSHOT_ARTIFACTS"] {
            return URL(fileURLWithPath: envPath)
        }

        // Check common simulator paths
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        if let first = paths.first {
            let dir = URL(fileURLWithPath: first)
                .deletingLastPathComponent()
                .appendingPathComponent(cachePath)
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            return dir
        }

        try FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true)
        return cacheDir
    }
}
