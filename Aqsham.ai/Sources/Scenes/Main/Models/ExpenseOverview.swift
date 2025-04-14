import Foundation

struct ExpenseOverview: Identifiable, Equatable {
    let id = UUID()
    let iconSystemName: String
    let categoryName: String
    let totalAmount: Double
}
