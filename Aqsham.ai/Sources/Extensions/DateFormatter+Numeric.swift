import Foundation

extension Formatter {
    
    static let numberWithSpaces: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
}

extension Numeric {
    
    var formattedWithSpaces: String {
        Formatter.numberWithSpaces.string(for: self) ?? "\(self)"
    }
}
