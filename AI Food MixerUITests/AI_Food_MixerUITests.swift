import XCTest

final class AI_Food_MixerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Tab Navigation

    @MainActor
    func testTabBarExists() throws {
        XCTAssertTrue(app.tabBars.firstMatch.exists)
    }

    @MainActor
    func testNavigateToCreationsTab() throws {
        app.tabBars.buttons["Creations"].tap()
        XCTAssertTrue(app.navigationBars["Creations"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testNavigateToDiscoverTab() throws {
        app.tabBars.buttons["Discover"].tap()
        XCTAssertTrue(app.navigationBars["Discover"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testNavigateToSettingsTab() throws {
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testNavigateToMixTab() throws {
        // Go to another tab first, then back
        app.tabBars.buttons["Settings"].tap()
        app.tabBars.buttons["Mix"].tap()
        XCTAssertTrue(app.navigationBars["AI Food Mixer"].waitForExistence(timeout: 5))
    }

    // MARK: - Mix Tab

    @MainActor
    func testMixTabShowsTitle() throws {
        XCTAssertTrue(app.navigationBars["AI Food Mixer"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testSurpriseMeButton() throws {
        // Tap the Surprise Me button in the toolbar
        let surpriseButton = app.buttons["Surprise Me"]
        XCTAssertTrue(surpriseButton.waitForExistence(timeout: 5))
        surpriseButton.tap()

        // After Surprise Me, Mixing Bowl should appear
        XCTAssertTrue(app.staticTexts["Mixing Bowl"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testIngredientCardSelection() throws {
        // Target "Grapes" — the first ingredient in the first category, always visible without scrolling
        let firstCard = app.buttons.matching(identifier: "Grapes").firstMatch
        guard firstCard.waitForExistence(timeout: 5) else { return }
        firstCard.tap()
        // Mixing Bowl header should appear
        XCTAssertTrue(app.staticTexts["Mixing Bowl"].waitForExistence(timeout: 5))
    }

    // MARK: - Creations Tab

    @MainActor
    func testCreationsEmptyState() throws {
        app.tabBars.buttons["Creations"].tap()
        // Should show empty state initially
        XCTAssertTrue(app.staticTexts["No Creations Yet"].waitForExistence(timeout: 5))
    }

    // MARK: - Discover Tab

    @MainActor
    func testDiscoverTabShowsItems() throws {
        app.tabBars.buttons["Discover"].tap()
        // Should show at least one discover item
        XCTAssertTrue(app.staticTexts["Curry Lava Pizza Cake"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testDiscoverItemNavigation() throws {
        app.tabBars.buttons["Discover"].tap()
        let card = app.staticTexts["Curry Lava Pizza Cake"]
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        card.tap()
        // Should navigate to detail view
        XCTAssertTrue(app.staticTexts["Ingredients"].waitForExistence(timeout: 5))
    }

    // MARK: - Settings Tab

    @MainActor
    func testSettingsTabShowsSections() throws {
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.staticTexts["AI Configuration"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Customisation"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["About"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testSettingsShowsVersion() throws {
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.staticTexts["Version"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["1.0"].waitForExistence(timeout: 5))
    }

    // MARK: - Launch Performance

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
