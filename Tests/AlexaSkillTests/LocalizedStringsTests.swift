@testable import AlexaSkill
import Foundation
import XCTest

class LocalizedStringsTests: XCTestCase {
    static let allTests = [
        ("testLocalizeAll", testLocalizeAll)
    ]

    func testLocalizeAll() {
        let localizedStrings: [LocalizedStrings.LocalizationID: [LocalizedStrings.LanguageID: String]] = [
            .help: [
                .german: "german",
                .englishUS: "englishUS",
                .englishGB: "englishGB"
            ]
        ]

        XCTAssertEqual(LocalizedStrings.localize(.help, into: .german, localizedStrings: localizedStrings), "german")
        XCTAssertEqual(LocalizedStrings.localize(.help, into: .englishUS, localizedStrings: localizedStrings), "englishUS")
        XCTAssertEqual(LocalizedStrings.localize(.help, into: .englishGB, localizedStrings: localizedStrings), "englishGB")
    }
}
