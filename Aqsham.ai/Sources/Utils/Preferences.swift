import Combine
import Foundation

final class Preferences: ObservableObject {
    
    private enum Keys {
        static let currency = "currency"
    }
    
    static let shared = Preferences()
    
    @Published var currency: Currency {
        didSet {
            UserDefaults.standard.set(currency.rawValue, forKey: Keys.currency)
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
