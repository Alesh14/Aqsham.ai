import Combine
import Foundation

enum Currency: String {
    case usd = "$"
    case eur = "E"
    case tg = "₸"
}

enum Period: String {
    case lastDay = "Last Day"
    case lastWeek = "Last Week"
    case lastMonth = "Last Month"
    
    var startDate: Date {
        switch self {
        case .lastDay:
            return Calendar.current.startOfDay(for: Date())
        case .lastWeek:
            return Calendar.current.date(byAdding: .day, value: -7, to: Calendar.current.startOfDay(for: Date()))!
        case .lastMonth:
            return Calendar.current.date(byAdding: .month, value: -1, to: Calendar.current.startOfDay(for: Date()))!
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
    
    @Published var selectedPeriod: Period = .lastDay {
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
    }
}
