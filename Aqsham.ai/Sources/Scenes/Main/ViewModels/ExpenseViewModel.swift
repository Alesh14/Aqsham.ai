import Combine
import SwiftUI
import CoreStore

final class ExpenseViewModel: ObservableObject {

    @Injected(Container.expenseStorageService) private var expenseService
    @Injected(Container.dataStackProvider) private var dataStackProvider
    
    @ObservedObject private var preferences = Preferences.shared

    @Published var period: String!
    @Published var expense: Double!
    @Published var currency: Currency!
    
    private var cancellables = Set<AnyCancellable>()

    private var expenses: [Expense] = []
    
    init() {
        self.period = preferences.selectedPeriod.rawValue
        self.currency = preferences.currency
        self.calculateTotalExpenseForSelectedPeriod()
    }
    
    func refreshTotalExpenseIfNeeded() {
        self.calculateTotalExpenseForSelectedPeriod()
    }
    
    func didTapPeriod() {
        let storedPeriod = preferences.selectedPeriod
        switch storedPeriod {
        case .currentDay:
            preferences.selectedPeriod = .currentWeek
        case .currentWeek:
            preferences.selectedPeriod = .currentMonth
        case .currentMonth:
            preferences.selectedPeriod = .currentDay
        }
        self.period = preferences.selectedPeriod.rawValue
    }
    
    private func calculateTotalExpenseForSelectedPeriod() {
        let l = preferences.selectedPeriod.startDate
        let r = Date()
        let tempExpenses = expenseService.fetchExpenses(from: l, to: r)
        if tempExpenses != expenses {
            self.expenses = tempExpenses
        }
        self.expenses = expenseService.fetchExpenses(from: l, to: r)
        self.expense = expenses.reduce(0) { $0 + $1.amount }
    }
}
