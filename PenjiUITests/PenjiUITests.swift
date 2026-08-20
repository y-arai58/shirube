import XCTest

final class PenjiUITests: XCTestCase {
    func testCanStartPracticeFromCharacterSelection() {
        let app = XCUIApplication()
        app.launch()

        let practiceTab = app.descendants(matching: .any).matching(identifier: "練習").firstMatch
        XCTAssertTrue(practiceTab.waitForExistence(timeout: 3))
        practiceTab.tap()
        app.buttons["あ"].tap()
        app.buttons["「あ」を練習する"].tap()

        XCTAssertTrue(app.navigationBars["「あ」を練習"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["なぞり書き"].exists)
    }
}
