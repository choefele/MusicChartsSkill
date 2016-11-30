import Foundation
import AlexaSkillsKit

public class AlexaSkillHandler : RequestHandler {
    public let chartsService: ChartsService
    
    public init(chartsService: ChartsService) {
        self.chartsService = chartsService
    }
    
    public func handleLaunch(request: LaunchRequest, session: Session, next: @escaping (StandardResult) -> ()) {
        generateResponse(next: next)
    }
    
    public func handleIntent(request: IntentRequest, session: Session, next: @escaping (StandardResult) -> ()) {
        generateResponse(next: next)
    }
    
    public func handleSessionEnded(request: SessionEndedRequest, session: Session, next: @escaping (VoidResult) -> ()) {
        next(.success())
    }
    
    func generateResponse(next: @escaping (StandardResult) -> ()) {
        chartsService.retrieveCharts { result in
            var message: String
            if case .success(let entries) = result, entries.count >= 3 {
                message = "The top three entries in the global Spotify charts are "
                message += "\(entries[0].trackName) by \(entries[0].artist), "
                message += "\(entries[1].trackName) by \(entries[1].artist) and "
                message += "\(entries[2].trackName) by \(entries[2].artist). "
            } else {
                message = "Sorry, I'm having troubles finding the Spotify charts right now."
            }

            let outputSpeech = OutputSpeech.plain(text: message)
            let standardResponse = StandardResponse(outputSpeech: outputSpeech)
            next(.success(standardResponse: standardResponse, sessionAttributes: [:]))
        }
    }
}
