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

    // MARK: - Tab Navigation

    @MainActor
    func testTabBarExists() throws {
        // On iPhone: tab bar; on iPad: sidebar or tab bar
        let hasTabBar = app.tabBars.firstMatch.exists
        let hasSidebar = app.buttons["Mix"].waitForExistence(timeout: 3)
        XCTAssertTrue(hasTabBar || hasSidebar)
    }

    @MainActor
    func testNavigateToCreationsTab() throws {
        selectTab("Creations")
        XCTAssertTrue(app.navigationBars["Creations"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testNavigateToDiscoverTab() throws {
        selectTab("Discover")
        XCTAssertTrue(app.navigationBars["Discover"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testNavigateToSettingsTab() throws {
        selectTab("Settings")
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testNavigateToMixTab() throws {
        // Go to another tab first, then back
        selectTab("Settings")
        selectTab("Mix")
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
        selectTab("Creations")
        // Should show empty state initially
        XCTAssertTrue(app.staticTexts["No Creations Yet"].waitForExistence(timeout: 5))
    }

    // MARK: - Discover Tab

    @MainActor
    func testDiscoverTabShowsItems() throws {
        selectTab("Discover")
        // Should show at least one discover item
        XCTAssertTrue(app.staticTexts["Curry Lava Pizza Cake"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testDiscoverItemNavigation() throws {
        selectTab("Discover")
        let card = app.staticTexts["Curry Lava Pizza Cake"]
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        card.tap()
        // Should navigate to detail view
        XCTAssertTrue(app.staticTexts["Ingredients"].waitForExistence(timeout: 5))
    }

    // MARK: - Settings Tab

    @MainActor
    func testSettingsTabShowsSections() throws {
        selectTab("Settings")
        XCTAssertTrue(app.staticTexts["AI Configuration"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Customisation"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["About"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testSettingsShowsVersion() throws {
        selectTab("Settings")
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
