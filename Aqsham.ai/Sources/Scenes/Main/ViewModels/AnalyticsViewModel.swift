import Combine

final class AnalyticsViewModel: ObservableObject {
    
    @LazyInjected(Container.expenseStorageService) private var expenseStorageService
    
    @Published var expenses: [ExpenseOverview]!
    
    init() {
        fetchExpenses()
    }
    
    func fetchExpenses() {
        let expenses = expenseStorageService.expenses
        
        var categoryAmountDict: [Category: Double] = [:]
        for expense in expenses {
            if let category = expense.category {
                categoryAmountDict[category, default: 0.0] += expense.amount
            }
        }
        
        self.expenses = categoryAmountDict.compactMap { category, amount in
            guard let name = category.name, let icon = category.icon else {
                return nil
            }
            return ExpenseOverview(iconSystemName: icon, categoryName: name, totalAmount: amount)
        }
    }
}
