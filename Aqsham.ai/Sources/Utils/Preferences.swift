import Combine
import Foundation

enum Currency: String {
    case usd = "$"
    case eur = "E"
    case tg = "₸"
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

final class Preferences: ObservableObject {
    
    private enum Keys {
        static let currency = "currency"
        static let selectedPeriod = "selectedPeriod"
    }
    
    static let shared = Preferences()
    
    @Published var currency: Currency {
        didSet {
            UserDefaults.standard.set(currency.rawValue, forKey: Keys.currency)
        }
    }
    
    @Published var selectedPeriod: Period {
        didSet {
            UserDefaults.standard.set(selectedPeriod.rawValue, forKey: Keys.selectedPeriod)
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
    }
}
