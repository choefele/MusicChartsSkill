import Foundation

struct LocalizedStrings {
    enum LanguageID: String {
        case german = "de-DE"
        case englishUS = "en-US"
        case englishGB = "en-GB"
    }

    enum LocalizationID: String {
        case help
        case stop
        case error
        case top3Format
    }
    
    static func localize(_ localizationID: LocalizationID, for locale: Locale, localizedStrings: [LocalizationID: [LanguageID: String]] = localizedStrings) -> String {
        let languageID = LanguageID(rawValue: locale.identifier) ?? .englishUS
        return LocalizedStrings.localize(localizationID, into: languageID, localizedStrings: localizedStrings)
    }

    static func localize(_ localizationID: LocalizationID, into languageID: LanguageID, localizedStrings: [LocalizationID: [LanguageID: String]] = localizedStrings) -> String {
        var localizedString = localizedStrings[localizationID]?[languageID]
        if localizedString == nil && languageID == .englishGB {
            // Try to fall back to US english
            localizedString = localizedStrings[localizationID]?[.englishUS]
        }
        assert(localizedString != nil)
        return localizedString ?? ""
    }

    private static let localizedStrings: [LocalizationID: [LanguageID: String]] = [
        .help: [
            .german: "Ich kann Dir die beliebtesten Songs auf Spotify nennen. Sag einfach öffne Music Charts",
            .englishUS: "I can tell you the most popular tracks on Spotify. Just say open Music Charts."
        ],
        .stop: [
            .german: "Bis bald.",
            .englishUS: "Talk to you soon."
        ],
        .error: [
            .german: "Leider kann ich im Moment die Musikcharts nicht laden.",
            .englishUS: "Sorry, I'm having troubles retrieving the music charts right now."
        ],
        .top3Format: [
            .german: "Die beliebtesten Songs in den Spotify Musikcharts sind %@ by %@, %@ by %@ and %@ by %@.",
            .englishUS: "The top three entries in the global Spotify charts are %@ by %@, %@ by %@ and %@ by %@."
        ]
    ]
}
