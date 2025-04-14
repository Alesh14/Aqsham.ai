import UIKit
import SwiftUI

enum AddExpenseScreenSection {
    case main
    case pickCategory(CategoryModel?, ((CategoryModel) -> Void))
    case addCategory
    case goBack
}

protocol AddExpenseScreenRoute: AnyObject {
    func trigger(_ route: AddExpenseScreenSection)
}

final class AddExpenseCoordinator: SubCoordinator {
    
    var navigationController: UINavigationController
    
    private var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(in parentCoordinator: any Coordinator, present: Bool) {
        let vm = AddExpenseViewModel(router: self)
        let vc = UIHostingController(rootView: AddExpenseView(viewModel: vm))
        vc.insertBackgroundColor()
        navigationController.pushViewController(vc, animated: false)
        self.parentCoordinator = parentCoordinator
        if present {
            self.navigationController.modalPresentationStyle = .popover
            self.parentCoordinator?.navigationController.present(self.navigationController, animated: true)
        } else {
            self.parentCoordinator?.navigationController.pushViewController(self.navigationController, animated: true)
        }
    }
}

extension AddExpenseCoordinator: AddExpenseScreenRoute {
    
    func trigger(_ route: AddExpenseScreenSection) {
        switch route {
        case .main:
            navigationController.popToRootViewController(animated: true)
            
        case .pickCategory(let initialCategory, let closure):
            let vm = CategoryViewModel(router: self)
            vm.selectedCategory = initialCategory
            let vc = UIHostingController(rootView: CategoryView(viewModel: vm, onCategorySelected: closure))
            vc.insertBackgroundColor()
            navigationController.pushViewController(vc, animated: true)
            
        case .addCategory:
            let vc = UIHostingController(rootView: AddNewCategoryView(viewModel: .init(router: self)))
            vc.insertBackgroundColor()
            navigationController.pushViewController(vc, animated: true)
            
        case .goBack:
            navigationController.popViewController(animated: true)
        }
    }
}
