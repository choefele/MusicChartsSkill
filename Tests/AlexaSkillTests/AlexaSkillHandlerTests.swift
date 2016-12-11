@testable import AlexaSkill
import AlexaSkillsKit
import Foundation
import XCTest

private class FakeChartsService: ChartsService {
    func retrieveCharts(completion: @escaping (ChartsServiceResult<[ChartEntry]>) -> ()) {
        let entries = [
            ChartEntry(trackName: "1", artist: "1", url: URL(string: "http://test.com")!),
            ChartEntry(trackName: "2", artist: "2", url: URL(string: "http://test.com")!),
            ChartEntry(trackName: "3", artist: "3", url: URL(string: "http://test.com")!)
        ]
        completion(.success(entries))
    }
}

private func createIntentEnvelope(for intentName: String) -> (IntentRequest, Session) {
    let request = Request(requestId: "requestId", timestamp: Date(), locale: Locale(identifier: "en"))
    let intentRequest = IntentRequest(request: request, intent: Intent(name: intentName))
    let application = Application(applicationId: "applicationId")
    let user = User(userId: "userId")
    let session = Session(isNew: true, sessionId: "sessionId", application: application, attributes: [:], user: user)
    
    return (intentRequest, session)
}

class AlexaSkillHandlerTests: XCTestCase {
    static let allTests = [
        ("testHandleIntent", testHandleIntent),
        ("testGenerateTopArtistsMessageFailure", testGenerateTopArtistsMessageFailure),
        ("testGenerateTopArtistsMessageTooFewEntries", testGenerateTopArtistsMessageTooFewEntries),
        ("testHandleHelpIntent", testHandleHelpIntent),
        ("testHandleCancelIntent", testHandleCancelIntent),
        ("testHandleStopIntent", testHandleStopIntent)
    ]
    
    var alexaSkillHandler: AlexaSkillHandler!
    
    override func setUp() {
        super.setUp()
        
        alexaSkillHandler = AlexaSkillHandler(chartsService: FakeChartsService())
    }

    func testHandleIntent() {
        let intentEnvelope = createIntentEnvelope(for: "name")
        let testExpectation = expectation(description: #function)
        alexaSkillHandler.handleIntent(request: intentEnvelope.0, session: intentEnvelope.1) { result in
            if case .success(let response) = result,
                let outputSpeech = response.standardResponse.outputSpeech,
                case OutputSpeech.plain(let text) = outputSpeech {
                XCTAssertEqual(text, "The top three entries in the global Spotify charts are 1 by 1, 1 by 1 and 1 by 1.")
            } else {
                XCTFail()
            }
            
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testGenerateTopArtistsMessageFailure() {
        let locale = Locale(identifier: "")
        let error = AlexaSkill.MessageError(message: "message")
        let message = alexaSkillHandler.generateTopArtistsMessage(result: .failure(error), locale: locale)
        XCTAssertEqual(message, LocalizedStrings.localize(.error, for: locale))
    }
    
    func testGenerateTopArtistsMessageTooFewEntries() {
        let locale = Locale(identifier: "")
        let message = alexaSkillHandler.generateTopArtistsMessage(result: .success([ChartEntry]()), locale: locale)
        XCTAssertEqual(message, LocalizedStrings.localize(.error, for: locale))
    }
    
    func testHandleHelpIntent() {
        let intentEnvelope = createIntentEnvelope(for: BuiltInIntent.help.rawValue)
        let testExpectation = expectation(description: #function)
        alexaSkillHandler.handleIntent(request: intentEnvelope.0, session: intentEnvelope.1) { result in
            if case .success(let response) = result,
                let outputSpeech = response.standardResponse.outputSpeech,
                case OutputSpeech.plain(let text) = outputSpeech {
                XCTAssertEqual(text, LocalizedStrings.localize(.help, into: .englishUS))
            } else {
                XCTFail()
            }
            
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testHandleCancelIntent() {
        let intentEnvelope = createIntentEnvelope(for: BuiltInIntent.cancel.rawValue)
        let testExpectation = expectation(description: #function)
        alexaSkillHandler.handleIntent(request: intentEnvelope.0, session: intentEnvelope.1) { result in
            if case .success(let response) = result,
                let outputSpeech = response.standardResponse.outputSpeech,
                case OutputSpeech.plain(let text) = outputSpeech {
                XCTAssertEqual(text, LocalizedStrings.localize(.stop, into: .englishUS))
            } else {
                XCTFail()
            }
            
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testHandleStopIntent() {
        let intentEnvelope = createIntentEnvelope(for: BuiltInIntent.stop.rawValue)
        let testExpectation = expectation(description: #function)
        alexaSkillHandler.handleIntent(request: intentEnvelope.0, session: intentEnvelope.1) { result in
            if case .success(let response) = result,
                let outputSpeech = response.standardResponse.outputSpeech,
                case OutputSpeech.plain(let text) = outputSpeech {
                XCTAssertEqual(text, LocalizedStrings.localize(.stop, into: .englishUS))
            } else {
                XCTFail()
            }
            
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
