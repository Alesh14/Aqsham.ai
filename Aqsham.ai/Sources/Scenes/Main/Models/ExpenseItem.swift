import SwiftUI
import Foundation

struct ExpenseItem: Identifiable, Equatable {
    let id = UUID()
    let iconSystemName: String
    let categoryName: String
    let totalAmount: Double
    var expenses: [Expense]
    var categoryColor: Color?
}
