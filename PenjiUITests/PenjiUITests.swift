import XCTest

final class PenjiUITests: XCTestCase {
    func testCanStartPracticeFromCharacterSelection() {
        let app = XCUIApplication()
        app.launch()

        let practiceTab = app.descendants(matching: .any).matching(identifier: "練習").firstMatch
        XCTAssertTrue(practiceTab.waitForExistence(timeout: 3))
        practiceTab.tap()
        let aCharacter = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "あ")).firstMatch
        XCTAssertTrue(aCharacter.waitForExistence(timeout: 3))
        aCharacter.tap()
        app.buttons["「あ」を練習する"].tap()

        XCTAssertTrue(app.navigationBars["「あ」を練習"].waitForExistence(timeout: 3), "「あ」を選択したら、あの練習画面を開く")
        XCTAssertTrue(app.staticTexts["なぞり書き"].exists)
    }
}
