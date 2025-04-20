import Combine
import SwiftUI

final class ExpenseViewModel: ObservableObject {

    @Injected(Container.expenseStorageService) private var expenseService
    
    @ObservedObject private var preferences = Preferences.shared
    @Published var expense: Double!
    @Published var currency: Currency!
    
    init() {
        self.currency = preferences.currency
        self.calculateTotalExpenseForSelectedPeriod()
    }
    
    func refreshTotalExpense() {
        self.calculateTotalExpenseForSelectedPeriod()
    }
    
    private func calculateTotalExpenseForSelectedPeriod() {
        let l = preferences.selectedPeriod.startDate
        let r = Date()
        self.expense = expenseService.fetchExpenses(from: l, to: r).reduce(0) { $0 + $1.amount }
    }
}
