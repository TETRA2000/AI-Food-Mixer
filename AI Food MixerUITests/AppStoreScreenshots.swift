//
//  AppStoreScreenshots.swift
//  AI Food MixerUITests
//
//  Automated App Store screenshot generation using fastlane snapshot.
//  Run: `fastlane snapshot` from the project root.
//

import XCTest

@MainActor
final class AppStoreScreenshots: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - App Store Screenshots

    /// Captures all App Store screenshots in a single ordered test.
    /// Using a single test ensures consistent state progression.
    func testCaptureAppStoreScreenshots() throws {

        // Screenshot 1: Mix Tab — the main ingredient selection screen
        XCTAssertTrue(app.navigationBars["AI Food Mixer"].waitForExistence(timeout: 5))
        snapshot("01_MixTab")

        // Screenshot 2: Mixing Bowl — tap "Surprise Me" to select random ingredients
        let surpriseButton = app.buttons["Surprise Me"]
        XCTAssertTrue(surpriseButton.waitForExistence(timeout: 5))
        surpriseButton.tap()
        XCTAssertTrue(app.staticTexts["Mixing Bowl"].waitForExistence(timeout: 5))
        snapshot("02_MixingBowl")

        // Screenshot 3: Discover Tab — curated food concepts
        app.tabBars.buttons["Discover"].tap()
        XCTAssertTrue(app.navigationBars["Discover"].waitForExistence(timeout: 5))
        snapshot("03_Discover")

        // Screenshot 4: Discover Detail — a featured food concept
        let discoverCard = app.staticTexts["Curry Lava Pizza Cake"]
        XCTAssertTrue(discoverCard.waitForExistence(timeout: 5))
        discoverCard.tap()
        XCTAssertTrue(app.staticTexts["Ingredients"].waitForExistence(timeout: 5))
        snapshot("04_DiscoverDetail")

        // Navigate back to Discover
        app.navigationBars.buttons.firstMatch.tap()

        // Screenshot 5: Creations Tab — saved projects
        app.tabBars.buttons["Creations"].tap()
        XCTAssertTrue(app.navigationBars["Creations"].waitForExistence(timeout: 5))
        snapshot("05_Creations")

        // Screenshot 6: Settings Tab
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5))
        snapshot("06_Settings")
    }
}
