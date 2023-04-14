//
//  URLFieldModelTests.swift
//  
//
//  Created by Scott Matthewman on 14/04/2023.
//

import XCTest
@testable import TheatriCalViews

@MainActor
final class URLFieldModelTests: XCTestCase {
    func testURLFieldModelCreation() {
        let model = URLFieldModel(text: "https://example.org", isFocused: false, showPasteButton: .always)
        XCTAssertNotNil(model)
    }

    func testNeverShowPasteButton() {
        let model = URLFieldModel(text: "https://example.org", isFocused: false, showPasteButton: .never)
        XCTAssertFalse(model.isShowingPasteButton)

        model.isFocused = true
        XCTAssertFalse(model.isShowingPasteButton)
    }

    func testAlwaysShowPasteButton() {
        let model = URLFieldModel(text: "https://example.org", isFocused: false, showPasteButton: .always)
        XCTAssertTrue(model.isShowingPasteButton)

        model.isFocused = true
        XCTAssertTrue(model.isShowingPasteButton)
    }

    func testShowPasteButtonWhenFocused() {
        let model = URLFieldModel(text: "https://example.org", isFocused: false, showPasteButton: .whenFocused)
        XCTAssertFalse(model.isShowingPasteButton)

        model.isFocused = true
        XCTAssertTrue(model.isShowingPasteButton)
    }

    func testHandleURLs() async {
        let urls = [
            URL(string: "https://example.org/pasted-url")!,
            URL(string: "https://example.org/ignored-url")!
        ]

        let model = URLFieldModel(text: "https://example.org", isFocused: false, showPasteButton: .never)
        await model.handlePaste(urls: urls)

        XCTAssertEqual(model.text, "https://example.org/pasted-url")
    }
}
