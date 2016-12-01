@testable import AlexaSkill
import Foundation
import XCTest

class LocalizedStringsTests: XCTestCase {
    static let allTests = [
        ("testLocalize", testLocalize)
    ]

    func testLocalize() {
        XCTAssertEqual(LocalizedStrings.localize(.help, into: .german), "Hilfe")
    }
}
