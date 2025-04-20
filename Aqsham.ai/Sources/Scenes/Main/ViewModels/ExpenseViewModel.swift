import Combine
import SwiftUI

final class ExpenseViewModel: ObservableObject {

    @Injected(Container.expenseStorageService) private var expenseService
    
    @ObservedObject private var preferences = Preferences.shared
    
    @Published var totalExpense: Double!
    @Published var currency: Currency!
    
    init() {
        self.currency = preferences.currency
        self.calculateTotalExpenseForSelectedPeriod()
    }
    
    func refreshTotalExpense() {
        self.calculateTotalExpenseForSelectedPeriod()
    }
    
    private func calculateTotalExpenseForSelectedPeriod() {
        self.totalExpense = 0
//        print(Date().addingTimeInterval(-10) > Date())
        expenseService.fetchExpenses(from: Date().addingTimeInterval(-10), to: Date()).forEach({ ex in
            print(ex.amount, ex.date)
        })
//        print(expenseService.expenses)
    }
}
