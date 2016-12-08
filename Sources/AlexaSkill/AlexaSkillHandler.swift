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
        var message: String
        if case .success(let entries) = result, entries.count >= 3 {
            // As of 3.0.1, there isn't a way to pass a String as CVargArg on 
            // Linux. For this reason, the localized strings are split up into
            // individual pieces. https://bugs.swift.org/browse/SR-957
            message = LocalizedStrings.localize(.top3Begin, for: locale)
            
            let localizedBy = LocalizedStrings.localize(.top3By, for: locale)
            let localizedAnd = LocalizedStrings.localize(.top3And, for: locale)
            message += " \(entries[0].trackName) \(localizedBy) \(entries[0].artist),"
            message += " \(entries[0].trackName) \(localizedBy) \(entries[0].artist) \(localizedAnd)"
            message += " \(entries[0].trackName) \(localizedBy) \(entries[0].artist)."
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
