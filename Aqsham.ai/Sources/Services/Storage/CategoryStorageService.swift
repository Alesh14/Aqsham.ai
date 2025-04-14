import CoreStore

protocol CategoryStorageService {
    
    var categories: [Category] { get }
    
    @discardableResult func addCategory(name: String, icon: String, hex: String) -> Bool
    
    @discardableResult func eraseAll() -> Bool
}

final class CategoryStorageServiceImpl: CategoryStorageService {
    
    @LazyInjected(Container.dataStackProvider) private var provider
    
    var categories: [Category] {
        do {
            let categories = try provider.dataStack.fetchAll(From<Category>())
            return categories
        } catch {
            return []
        }
    }
    
    @discardableResult
    func eraseAll() -> Bool {
        do {
            _ = try provider.dataStack.perform { transaction in
                try transaction.deleteAll(From<Category>())
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        return true
    }
    
    @discardableResult
    func addCategory(name: String, icon: String, hex: String) -> Bool {
        do {
            try provider.dataStack.perform { transaction in
                let category = transaction.create(Into<Category>())
                category.id = UUID()
                category.icon = icon
                category.hex = hex
                category.name = name
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        return true
    }
}
