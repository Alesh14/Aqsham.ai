import Foundation

final class AddExpenseViewModel {

    @LazyInjected(Container.expenseStorageService) private var expenseService
    
    private unowned let router: AddExpenseScreenRoute
    
    init(router: AddExpenseScreenRoute) {
        self.router = router
    }
    
    func navigate(to screen: AddExpenseScreenSection) {
        router.trigger(screen)
    }
    
    func addExpense(amount: Double, date: Date, categoryID: UUID, comment: String?) {
        expenseService.addExpense(amount: amount, date: date, categoryId: categoryID, comment: comment)
    }
}
