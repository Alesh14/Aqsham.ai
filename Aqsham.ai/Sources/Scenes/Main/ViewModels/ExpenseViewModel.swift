import Combine
import SwiftUI
import CoreStore

final class ExpenseViewModel: ObservableObject {

    @Injected(Container.expenseStorageService) private var expenseService
    @Injected(Container.dataStackProvider) private var dataStackProvider
    
    @ObservedObject private var preferences = Preferences.shared
    @Published var expense: Double!
    @Published var currency: Currency!
    
    private var cancellables = Set<AnyCancellable>()
    
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
