import SwiftUI
import Combine
import Foundation

final class VisualizationViewModel: ObservableObject {
    
    @Injected(Container.expenseStorageService) private var expenseStorageService
    
    @Published var data: [ExpenseItem] = []
    
    private var preferences = Preferences.shared
    private var cancellables = Set<AnyCancellable>()
    private var onAppearPublisher: AnyPublisher<Void, Never>?
    
    init(onAppearPublisher: AnyPublisher<Void, Never>?) {
        self.onAppearPublisher = onAppearPublisher
        fetchExpenses()
        bind()
    }
    
    func fetchExpenses() {
        let selectedPeriod = preferences.selectedPeriod
        let expenses = expenseStorageService.fetchExpenses(from: selectedPeriod.startDate, to: Date())
        
        var categoryAmountDict: [Category: Double] = [:]
        for expense in expenses {
            if let category = expense.category {
                categoryAmountDict[category, default: 0.0] += expense.amount
            }
        }
        
        self.data = categoryAmountDict.compactMap { category, amount in
            let name = category.name!
            let icon = category.icon!
            return ExpenseItem(iconSystemName: icon, categoryName: name, totalAmount: amount, expenses: [], categoryColor: Color(hex: category.hex!))
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
