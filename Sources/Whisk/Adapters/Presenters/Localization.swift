import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case simplifiedChinese = "zh-Hans"
    case english = "en"
    case french = "fr"
    case system

    static let defaultsKey = "appLanguage"

    var id: String { rawValue }

    var usesSimplifiedChinese: Bool {
        if self == .simplifiedChinese { return true }
        guard self == .system else { return false }
        return Bundle.module.preferredLocalizations.first == AppLanguage.simplifiedChinese.rawValue
    }

    var label: String {
        switch self {
        case .simplifiedChinese: localized("Simplified Chinese")
        case .english: localized("English")
        case .french: localized("French")
        case .system: localized("Follow System")
        }
    }

    static func stored(in defaults: UserDefaults = .standard) -> AppLanguage {
        guard let value = defaults.string(forKey: defaultsKey) else { return .simplifiedChinese }
        return AppLanguage(rawValue: value) ?? .simplifiedChinese
    }
}

/// User-visible strings resolve through the module's catalogs —
/// `Resources/*.lproj/Localizable.strings`, plural forms in the
/// `.stringsdict` next to it. The selected catalog is bundled with Whisk,
/// so translated text does not depend on a network translation service.
func localized(_ key: String.LocalizationValue, language: AppLanguage = .stored()) -> String {
    guard language != .system,
        let url = Bundle.module.url(
            forResource: language.rawValue, withExtension: "lproj"),
        let bundle = Bundle(url: url)
    else {
        return String(localized: key, bundle: .module)
    }
    return String(localized: key, bundle: bundle, locale: Locale(identifier: language.rawValue))
}
