import SwiftUI
import CoreStore

struct CategoryModel: Hashable {
    let id: UUID
    let name: String
    let icon: String
    let color: Color
}

final class CategoryViewModel: ObservableObject {
    
    @Injected(Container.categoryStorageService) private var storageService
    
    unowned let router: AddExpenseScreenRoute
    
    @Published var categories: [CategoryModel] = []
    
    @Published var selectedCategory: CategoryModel? = nil
    
    init(router: AddExpenseScreenRoute) {
        self.router = router
        self.fetchCategories()
    }
    
    func navigate(to screen: AddExpenseScreenSection) {
        router.trigger(.addCategory)
    }
    
    func updateCategoriesIfNeeded() {
        fetchCategories()
    }
    
    private func fetchCategories() {
        let res = storageService.categories.compactMap { category in
            let id = category.id!
            let hex = category.hex!
            let name = category.name!
            let icon = category.icon!
            return CategoryModel(id: id, name: name, icon: icon, color: Color(hex: hex))
        }
        if res != self.categories {
            categories = res
        }
    }
}
