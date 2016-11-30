@testable import AlexaSkill
import AlexaSkillsKit
import Foundation
import XCTest

class FakeChartsService: ChartsService {
    func retrieveCharts(completion: @escaping (ChartsServiceResult<[ChartEntry]>) -> ()) {
        let entries = [
            ChartEntry(trackName: "1", artist: "1", url: URL(string: "http://test.com")!),
            ChartEntry(trackName: "2", artist: "2", url: URL(string: "http://test.com")!),
            ChartEntry(trackName: "3", artist: "3", url: URL(string: "http://test.com")!)
        ]
        completion(.success(entries))
    }
}

class AlexaSkillHandlerTests: XCTestCase {
    static let allTests = [
        ("testHandleIntent", testHandleIntent)
    ]
    
    var alexaSkillHandler: AlexaSkillHandler!
    
    override func setUp() {
        super.setUp()
        
        alexaSkillHandler = AlexaSkillHandler(chartsService: FakeChartsService())
    }

    func testHandleIntent() {
        let request = Request(requestId: "requestId", timestamp: Date(), locale: Locale(identifier: "en"))
        let intentRequest = IntentRequest(request: request, intent: Intent(name: "name"))
        let application = Application(applicationId: "applicationId")
        let user = User(userId: "userId")
        let session = Session(isNew: true, sessionId: "sessionId", application: application, attributes: [:], user: user)

        let testExpectation = expectation(description: #function)
        alexaSkillHandler.handleIntent(request: intentRequest, session: session) { result in
            if case .success(let response) = result,
                let outputSpeech = response.standardResponse.outputSpeech,
                case OutputSpeech.plain(let text) = outputSpeech {
                XCTAssertTrue(text.hasPrefix("The top three entries"))
            } else {
                XCTFail()
            }
            
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
