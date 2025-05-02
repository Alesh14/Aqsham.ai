import Combine
import Foundation

final class AnalyticsViewModel: ObservableObject {
    
    @LazyInjected(Container.expenseStorageService) private var expenseStorageService
    
    @Published var expenses: [ExpenseItem]!
    
    private var preferences = Preferences.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchExpenses()
        bind()
    }
    
    func fetchExpenses() {
        let selectedPeriod = preferences.selectedPeriod
        let expenses = expenseStorageService.fetchExpenses(from: selectedPeriod.startDate, to: Date())
        
        print(selectedPeriod.startDate)
        
        var categoryAmountDict: [Category: Double] = [:]
        for expense in expenses {
            if let category = expense.category {
                categoryAmountDict[category, default: 0.0] += expense.amount
            }
        }
        
        self.expenses = categoryAmountDict.compactMap { category, amount in
            let name = category.name!
            let icon = category.icon!
            return ExpenseItem(
                iconSystemName: icon,
                categoryName: name,
                totalAmount: amount,
                expenses: expenses.filter({ expense in
                    expense.category?.id == category.id
                })
            )
        }
        .sorted(by: { $0.totalAmount > $1.totalAmount })
    }
    
    private func bind() {
        preferences.$selectedPeriod
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchExpenses()
            }
            .store(in: &cancellables)
    }
}
