extension SharedContainer {
    
    static let expenseStorageService = Factory<ExpenseStorageService> {
        ExpenseStorageServiceImpl()
    }
}
