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

        // Force portrait orientation for App Store screenshots
        XCUIDevice.shared.orientation = .portrait
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Helpers

    /// Selects a tab by label, handling both iPhone tab bar and iPad floating tab bar.
    /// On iPad, the floating tab bar nests duplicate Button elements, so `.firstMatch` is required.
    private func selectTab(_ label: String) {
        let tabBarButton = app.tabBars.buttons[label]
        if tabBarButton.exists {
            tabBarButton.tap()
            return
        }
        // iPad floating tab bar: use firstMatch to avoid multiple-match failure
        let button = app.buttons[label].firstMatch
        if button.waitForExistence(timeout: 3) {
            button.tap()
        }
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

        // Screenshot 3: Generation Result — tap Mix button and wait for generation
        // The accessibility label is "Mix N ingredients" (lowercase)
        let mixButton = app.buttons.matching(NSPredicate(format: "label MATCHES 'Mix [0-9]+ ingredients'")).firstMatch
        XCTAssertTrue(mixButton.waitForExistence(timeout: 5), "Mix button not found")
        if !mixButton.isHittable {
            app.swipeUp()
            sleep(1)
        }
        mixButton.tap()

        // Wait for the generation modal to appear
        let foodConceptNav = app.navigationBars["Food Concept"]
        XCTAssertTrue(foodConceptNav.waitForExistence(timeout: 15), "Food Concept nav bar not found")
        // Wait for placeholder streaming to complete (~3s), plus buffer
        sleep(8)
        snapshot("03_GenerationResult")

        // Dismiss the generation modal
        app.buttons["Close"].tap()

        // Screenshot 4: Discover Tab — curated food concepts
        selectTab("Discover")
        XCTAssertTrue(app.navigationBars["Discover"].waitForExistence(timeout: 5))
        snapshot("04_Discover")

        // Screenshot 5: Discover Detail — a featured food concept
        let discoverCard = app.staticTexts["Curry Lava Pizza Cake"]
        XCTAssertTrue(discoverCard.waitForExistence(timeout: 5))
        discoverCard.tap()
        XCTAssertTrue(app.staticTexts["Ingredients"].waitForExistence(timeout: 5))
        snapshot("05_DiscoverDetail")

        // Navigate back to Discover
        app.navigationBars.buttons.firstMatch.tap()

        // Screenshot 6: Settings Tab
        selectTab("Settings")
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5))
        snapshot("06_Settings")
    }
}
