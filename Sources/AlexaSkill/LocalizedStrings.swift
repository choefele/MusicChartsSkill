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
    }

    static func localize(_ localizationID: LocalizationID, into languageID: LanguageID, localizedStrings: [LocalizationID: [LanguageID: String]] = localizedStrings) -> String {
        let localizedString = localizedStrings[localizationID]?[languageID]
        assert(localizedString != nil)
        return localizedString ?? ""
    }

    private static let localizedStrings: [LocalizationID: [LanguageID: String]] = [
        .help: [
            .german: "Ich kann Dir die beliebtesten Songs auf Spotify nennen. Sag einfach öffne Music Charts",
            .englishUS: "I can tell you the most popular tracks on Spotify. Just say open Music Charts.",
            .englishGB: "I can tell you the most popular tracks on Spotify. Just say open Music Charts."
        ],
        .stop: [
            .german: "Bis bald.",
            .englishUS: "Talk to you soon.",
            .englishGB: "Talk to you soon."
        ]
    ]
}
