@testable import AlexaSkill
import Foundation
import XCTest

class LocalizedStringsTests: XCTestCase {
    static let allTests = [
        ("testLocalize", testLocalize),
        ("testLocalizeEnglishFallback", testLocalizeEnglishFallback),
        ("testLocalizeWithLocale", testLocalizeWithLocale),
        ("testLocalizeWithLocaleFallback", testLocalizeWithLocaleFallback)
    ]

    func testLocalize() {
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
    
    func testLocalizeEnglishFallback() {
        let localizedStrings: [LocalizedStrings.LocalizationID: [LocalizedStrings.LanguageID: String]] = [
            .help: [
                .german: "german",
                .englishUS: "englishUS"
            ]
        ]

        XCTAssertEqual(LocalizedStrings.localize(.help, into: .englishGB, localizedStrings: localizedStrings), "englishUS")
    }

    func testLocalizeWithLocale() {
        let localizedStrings: [LocalizedStrings.LocalizationID: [LocalizedStrings.LanguageID: String]] = [
            .help: [
                .german: "german"
            ]
        ]

        let locale = Locale(identifier: LocalizedStrings.LanguageID.german.rawValue)
        XCTAssertEqual(LocalizedStrings.localize(.help, for: locale, localizedStrings: localizedStrings), "german")
    }
    
    func testLocalizeWithLocaleFallback() {
        let localizedStrings: [LocalizedStrings.LocalizationID: [LocalizedStrings.LanguageID: String]] = [
            .help: [
                .englishUS: "englishUS"
            ]
        ]
        
        let locale = Locale(identifier: "unknown")
        XCTAssertEqual(LocalizedStrings.localize(.help, for: locale, localizedStrings: localizedStrings), "englishUS")
    }
    
}
