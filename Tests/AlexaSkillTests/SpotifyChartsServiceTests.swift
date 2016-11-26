@testable import AlexaSkill
import Foundation
import XCTest

class SpotifyChartsServiceTests: XCTestCase {
    static let allTests = [
        ("testHandleIntent", testHandleIntent)
    ]
    
    var spotifyChartsService: SpotifyChartsService!
    
    override func setUp() {
        super.setUp()
        
        spotifyChartsService = SpotifyChartsService()
    }

    func testHandleIntent() {
        let testExpectation = expectation(description: #function)
        spotifyChartsService.retrieve() {
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
