import CoreStore

protocol ExpenseStorageService {
    
    var expenses: [Expense] { get }
    
    @discardableResult
    func eraseAll() -> Bool
    
    @discardableResult
    func addExpense(amount: Double, date: Date, categoryId: UUID) -> Bool
}

final class ExpenseStorageServiceImpl: ExpenseStorageService {
    
    @LazyInjected(Container.dataStackProvider) private var provider
    
    var expenses: [Expense] {
        do {
            let res = try provider.dataStack.fetchAll(From<Expense>())
            return res
        } catch {
            return []
        }
    }
    
    func fetchExpenses(from startDate: Date, to endDate: Date) -> [Expense] {
        do {
            let res = try provider.dataStack.fetchAll(
                From<Expense>()
//                    .where(\.date >= startDate)
//                    .where(\.date <= endDate)
            )
            return res
        } catch {
            return []
        }
    }
    
    @discardableResult
    func eraseAll() -> Bool {
        do {
            _ = try provider.dataStack.perform { transaction in
                try transaction.deleteAll(From<Expense>())
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        return true
    }
    
    @discardableResult
    func addExpense(
        amount: Double, date: Date, categoryId: UUID
    ) -> Bool {
        do {
            try provider.dataStack.perform { transaction in
                let expense = transaction.create(Into<Expense>())
                expense.id = UUID()
                expense.date = date
                expense.amount = amount
                let category = try transaction.fetchOne(
                    From<Category>()
                        .where(\.id == categoryId)
                )
                expense.category = category
            }
        } catch {
            return false
        }
        return true
    }
}
