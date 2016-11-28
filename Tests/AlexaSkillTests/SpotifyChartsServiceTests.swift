@testable import AlexaSkill
import Foundation
import XCTest

private func load(contentsOf fileName: String) throws -> Data {
    let url = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .appendingPathComponent(fileName)
    return try Data(contentsOf: url)
}

class SpotifyChartsServiceTests: XCTestCase {
    static let allTests = [
        ("testRetrieveCharts", testRetrieveCharts),
        ("testParse", testParse)
    ]
    
    var spotifyChartsService: SpotifyChartsService!
    
    override func setUp() {
        super.setUp()
        
        spotifyChartsService = SpotifyChartsService()
    }

    func testRetrieveCharts() {
        let testExpectation = expectation(description: #function)
        spotifyChartsService.retrieveCharts() {
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testParse() throws {
        let entries = try SpotifyChartsService.parse(data: load(contentsOf: "regional-global-daily-latest.csv"))
        XCTAssertEqual(entries?.count, 200)
        XCTAssertEqual(entries?.first, ChartEntry(trackName: "Starboy", artist: "The Weeknd", url: URL(string: "https://open.spotify.com/track/7lQqaqZu0vjxzpdATOIsDt")!))
        XCTAssertEqual(entries?[1], ChartEntry(trackName: "Black Beatles", artist: "Rae Sremmurd", url: URL(string: "https://open.spotify.com/track/6fujklziTHa8uoM5OQSfIo")!))
    }
}
