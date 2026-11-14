import Foundation
import Testing

@testable import Whisk

/// The catalogs and the code that reads them, checked against each other:
/// every key the code asks for exists in all languages, and no key
/// lingers unused.
@Suite struct LocalizationCatalogs {
    private static let languages = ["en", "fr", "zh-Hans"]

    private func catalog(_ language: String) throws -> [String: Any] {
        var merged: [String: Any] = [:]
        for ext in ["strings", "stringsdict"] {
            let url = try #require(
                Bundle.module.url(
                    forResource: "Localizable", withExtension: ext, subdirectory: nil, localization: language))
            let dictionary = try #require(NSDictionary(contentsOf: url) as? [String: Any])
            merged.merge(dictionary) { current, _ in current }
        }
        return merged
    }

    /// Every key the sources ask for, each as the set of catalog keys it
    /// may resolve to: `"\(count) items"` reaches the catalog as
    /// `%lld items`, an object interpolation as `%@`.
    private func keysUsedInSources() throws -> [Set<String>] {
        let root = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let sources = root.appendingPathComponent("Sources/Whisk", isDirectory: true)
        let enumerator = try #require(FileManager.default.enumerator(at: sources, includingPropertiesForKeys: nil))
        let call = try NSRegularExpression(pattern: #"localized\(\s*"((?:[^"\\]|\\.)*)"\s*\)"#)
        let interpolation = try NSRegularExpression(pattern: #"\\\([^)]*\)"#)
        var used: [Set<String>] = []
        for case let file as URL in enumerator where file.pathExtension == "swift" {
            let text = try String(contentsOf: file, encoding: .utf8)
            for match in call.matches(in: text, range: NSRange(text.startIndex..., in: text)) {
                guard let range = Range(match.range(at: 1), in: text) else { continue }
                let literal = String(text[range]).replacingOccurrences(of: "\\\"", with: "\"")
                let whole = NSRange(literal.startIndex..., in: literal)
                used.append([
                    interpolation.stringByReplacingMatches(in: literal, range: whole, withTemplate: "%lld"),
                    interpolation.stringByReplacingMatches(in: literal, range: whole, withTemplate: "%@"),
                ])
            }
        }
        return used
    }

    @Test func english_and_french_carry_the_same_keys() throws {
        let english = Set(try catalog("en").keys)
        let french = Set(try catalog("fr").keys)
        let chinese = Set(try catalog("zh-Hans").keys)

        #expect(english.subtracting(french).isEmpty)
        #expect(french.subtracting(english).isEmpty)
        #expect(english.subtracting(chinese).isEmpty)
        #expect(chinese.subtracting(english).isEmpty)
    }

    @Test func every_key_the_code_asks_for_exists() throws {
        let catalogs = try Self.languages.map { Set(try catalog($0).keys) }
        let missing = try keysUsedInSources().filter { key in catalogs.contains { key.isDisjoint(with: $0) } }

        #expect(missing.isEmpty, "keys without a catalog entry: \(missing)")
    }

    @Test func no_catalog_key_lingers_unused() throws {
        let english = Set(try catalog("en").keys)
        let used = try keysUsedInSources().reduce(into: Set<String>()) { $0.formUnion($1) }

        let unused = english.subtracting(used)

        #expect(unused.isEmpty, "catalog keys no code asks for: \(unused.sorted())")
    }

    @Test func strings_resolve_from_the_selected_catalog() throws {
        let english = try #require(try catalog("en")["Forever"] as? String)
        let french = try #require(try catalog("fr")["Forever"] as? String)
        let chinese = try #require(try catalog("zh-Hans")["Forever"] as? String)

        #expect(localized("Forever", language: .english) == english)
        #expect(localized("Forever", language: .french) == french)
        #expect(localized("Forever", language: .simplifiedChinese) == chinese)
    }

    @Test func copy_sound_settings_have_the_same_labels_in_every_language() throws {
        let englishKeys: Set<String> = [
            "Copy feedback", "Copy sound", "Play copy sound",
            "Short tick", "Crisp click", "Soft pop", "Quick snap", "Light chime",
            "Woodblock tick", "Dry click", "Round pop", "Short tsk", "Low du",
            "Digital beep", "Bell ding", "Deep dong", "Rising chirp",
            "Xiaomi water drop", "Xiaomi bird and cicada", "Xiaomi wind chime",
        ]
        for language in Self.languages {
            let catalog = try catalog(language)
            for key in englishKeys {
                #expect(catalog[key] as? String != nil)
            }
        }
    }

    @Test func following_a_chinese_system_language_uses_the_whisk_chinese_time_labels() {
        let systemUsesChinese = Bundle.module.preferredLocalizations.first == "zh-Hans"

        #expect(AppLanguage.system.usesSimplifiedChinese == systemUsesChinese)
    }

    @Test func plural_forms_follow_the_count() {
        #expect(localized("\(1) items", language: .simplifiedChinese) == "1 项")
        #expect(localized("\(2) items", language: .simplifiedChinese) == "2 项")
        #expect(["1 item", "1 élément"].contains(localized("\(1) items", language: .english)))
        #expect(["2 items", "2 éléments"].contains(localized("\(2) items", language: .french)))
        #expect(["1 character", "1 caractère"].contains(localized("\(1) characters", language: .english)))
        #expect(["40 characters", "40 caractères"].contains(localized("\(40) characters", language: .french)))
    }
}
