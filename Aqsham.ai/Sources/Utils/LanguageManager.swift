import Foundation

enum Lanugage: String, CaseIterable {
    case kazakh  = "kk"
    case russian = "ru"
    case english = "en"
    
    var title: String {
        switch self {
        case .kazakh:  return "Kazakh"
        case .russian: return "Russian"
        case .english: return "English"
        }
    }
    
    var subtitle: String {
        switch self {
        case .kazakh:  return "Қазақша"
        case .russian: return "Русский"
        case .english: return "English"
        }
    }
}

public let LCLBaseBundle = "Base"

final class LanguageManager {
    
    private enum Keys {
        static let language = "language"
    }
    
    static let shared = LanguageManager()
    
    private(set) var language: Lanugage = .english
    
    private init() {
        if let string = UserDefaults.standard.string(forKey: Keys.language), let value = Lanugage(rawValue: string) {
            language = value
        } else {
            let localeId = Locale.preferredLanguages.first ?? "en"
            if localeId.hasPrefix("ru") {
                language = .russian
            } else if localeId.hasPrefix("kk") {
                language = .kazakh
            } else {
                language = .english
            }
        }
    }
    
    func updateLanguage(_ language: Lanugage) {
        self.language = language
        UserDefaults.standard.set(language.rawValue, forKey: Keys.language)
    }
}
