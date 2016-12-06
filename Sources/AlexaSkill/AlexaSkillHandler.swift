import Foundation
import AlexaSkillsKit

public class AlexaSkillHandler : RequestHandler {
    public let chartsService: ChartsService
    
    public init(chartsService: ChartsService) {
        self.chartsService = chartsService
    }
    
    public func handleLaunch(request: LaunchRequest, session: Session, next: @escaping (StandardResult) -> ()) {
        retrieveCharts(locale: request.request.locale, next: next)
    }
    
    public func handleIntent(request: IntentRequest, session: Session, next: @escaping (StandardResult) -> ()) {
        retrieveCharts(locale: request.request.locale, next: next)
    }
    
    public func handleSessionEnded(request: SessionEndedRequest, session: Session, next: @escaping (VoidResult) -> ()) {
        next(.success())
    }
    
    func retrieveCharts(locale: Locale, next: @escaping (StandardResult) -> ()) {
        chartsService.retrieveCharts { result in
            let message = self.generateTopArtistsMessage(result: result, locale: locale)
            let standardResponse = self.generateStandardResponse(message)
            next(.success(standardResponse: standardResponse, sessionAttributes: [:]))
        }
    }

    func generateTopArtistsMessage(result: ChartsServiceResult<[ChartEntry]>, locale: Locale) -> String {
        let message: String
        if case .success(let entries) = result, entries.count >= 3 {
            message = String(format: LocalizedStrings.localize(.top3Format, for: locale),
                             entries[0].trackName, entries[0].artist,
                             entries[1].trackName, entries[1].artist,
                             entries[2].trackName, entries[2].artist)
        } else {
            message = LocalizedStrings.localize(.error, for: locale)
        }


        return message
    }

    func generateStandardResponse(_ message: String) -> StandardResponse {
        let outputSpeech = OutputSpeech.plain(text: message)
        let standardResponse = StandardResponse(outputSpeech: outputSpeech)

        return standardResponse
    }
}
