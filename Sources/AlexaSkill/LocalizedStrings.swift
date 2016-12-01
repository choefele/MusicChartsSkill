import Foundation

struct LocalizedStrings {
    enum LanguageID: String {
        case german = "de_DE"
    }

    enum LocalizationID: String {
        case help
    }

    static func localize(_ localizationID: LocalizationID, into languageID: LanguageID) -> String {
        let localizedString = LocalizedStrings.localizedStrings[localizationID]?[languageID]
        assert(localizedString != nil)
        return localizedString ?? ""
    }

    private static let localizedStrings: [LocalizationID: [LanguageID: String]] = [
        .help: [
            .german: "Hilfe"
        ]
    ]
}
