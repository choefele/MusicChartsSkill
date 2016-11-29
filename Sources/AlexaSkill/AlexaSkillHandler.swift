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
            switch result {
            case .success(let entries):
                message = "The top entry in the global Spotify charts is \(entries.first?.trackName) by \(entries.first?.artist)."
            case .failure:
                message = "Sorry, I'm having troubles finding the Spotify charts right now."
            }
            
            let outputSpeech = OutputSpeech.plain(text: message)
            let standardResponse = StandardResponse(outputSpeech: outputSpeech)
            next(.success(standardResponse: standardResponse, sessionAttributes: [:]))
        }
    }
}
