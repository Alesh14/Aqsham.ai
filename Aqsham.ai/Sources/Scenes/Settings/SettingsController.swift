import UIKit
import CoreStore

final class SettingsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        try? provider.dataStack.perform { transaction in
//            let expense = transaction.create(Into<Expense>())
//            expense.id = 1
//            expense.title = "Fruits"
//        }
//        
//        let expenses = try? provider.dataStack.fetchAll(From<Expense>())
        
        
    }
    
    private func configUI() {
        
    }
}
