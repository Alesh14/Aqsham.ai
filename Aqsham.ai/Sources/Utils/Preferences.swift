import SwiftUI
import Combine
import Foundation

enum Currency: String, CaseIterable {
    
    case usd = "$"
    case eur = "E"
    case tg = "₸"
    case rub = "₽"
    
    var title: String {
        switch self {
        case .usd: AppLocalizedString("currency.usd")
        case .eur: AppLocalizedString("currency.eur")
        case .tg:  AppLocalizedString("currency.tg")
        case .rub: AppLocalizedString("currency.rub")
        }
    }
    
    var code: String {
        switch self {
        case .eur: "EUR"
        case .usd: "USD"
        case .tg:  "KZT"
        case .rub: "RUB"
        }
    }
    
    var flagImage: Image {
        switch self {
        case .usd: Image(.Flag.usd)
        case .eur: Image(.Flag.eur)
        case .tg:  Image(.Flag.kzt)
        case .rub: Image(.Flag.rub)
        }
    }
}

enum Period: String {
    
    case currentDay = "Last Day"
    case currentWeek = "Last Week"
    case currentMonth = "Last Month"
    
    var startDate: Date {
        switch self {
        case .currentDay:
            return Calendar.current.startOfDay(for: Date())
        case .currentWeek:
            return Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        case .currentMonth:
            return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
        }
    }
}

enum Gender: String {
    case male = "Male"
    case female = "Female"
}

final class Preferences: ObservableObject {
    
    private enum Keys {
        static let currency = "currency"
        static let selectedPeriod = "selectedPeriod"
        static let userName = "userName"
        static let gender = "gender"
        static let age = "age"
        static let notificationEnabled = "notificationEnabled"
    }
    
    static let shared = Preferences()
    
    @Published var currency: Currency {
        didSet { UserDefaults.standard.set(currency.rawValue, forKey: Keys.currency) }
    }
    @Published var selectedPeriod: Period {
        didSet { UserDefaults.standard.set(selectedPeriod.rawValue, forKey: Keys.selectedPeriod) }
    }
    @Published var userName: String? {
        didSet { UserDefaults.standard.set(userName, forKey: Keys.userName) }
    }
    @Published var gender: Gender? = nil {
        didSet {
            UserDefaults.standard.set(gender?.rawValue, forKey: Keys.gender)
        }
    }
    @Published var age: Int? = nil {
        didSet { UserDefaults.standard.set(age, forKey: Keys.age) }
    }
    @Published var language: Lanugage {
        didSet {
            guard language != oldValue else {
                return
            }
            LanguageManager.shared.updateLanguage(language)
        }
    }
    @Published var notificationEnabled: Bool {
        didSet {
            UserDefaults.standard.set(notificationEnabled, forKey: Keys.notificationEnabled)
            if notificationEnabled {
                NotificationScheduler.shared.scheduleReminder()
            } else {
                NotificationScheduler.shared.cancel(identifier: AppConstants.notificationIdentifier)
            }
        }
    }
    
    private init() {
        if let string = UserDefaults.standard.string(forKey: Keys.currency), let value = Currency(rawValue: string) {
            currency = value
        } else {
            currency = .usd
        }
        
        if let string = UserDefaults.standard.string(forKey: Keys.selectedPeriod), let value = Period(rawValue: string) {
            selectedPeriod = value
        } else {
            selectedPeriod = .currentDay
        }
        
        if let value = UserDefaults.standard.string(forKey: Keys.userName) {
            userName = value
        }
        
        if let age = UserDefaults.standard.object(forKey: Keys.age) as? Int {
            self.age = age
        }
        
        if let string = UserDefaults.standard.string(forKey: Keys.gender), let value = Gender(rawValue: string) {
            gender = value
        }
        
        self.language = LanguageManager.shared.language
        if let bool = UserDefaults.standard.object(forKey: Keys.notificationEnabled) as? Bool {
            self.notificationEnabled = bool
        } else {
            self.notificationEnabled = true
        }
    }
}
