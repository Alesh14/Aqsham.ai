import UIKit
import SwiftUI

enum MainScreenSection {
    case chat
    case history
    case addExpense((() -> ()))
    case expenseDetail(ExpenseItem, (() -> ()))
}

protocol MainScreenRoute: AnyObject {
    func trigger(_ route: MainScreenSection)
}

final class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    let addExpenseCoordinator = AddExpenseCoordinator(navigationController: UINavigationController())
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = MainViewModel(router: self)
        let controller = MainController(viewModel: vm)
        navigationController.pushViewController(controller, animated: false)
    }
}

extension MainCoordinator: MainScreenRoute {
    
    func trigger(_ route: MainScreenSection) {
        switch route {
        case .chat:
            let vc = UIHostingController(rootView: ChatView())
            vc.view.backgroundColor = .white
            vc.hidesBottomBarWhenPushed = true
            vc.overrideUserInterfaceStyle = .light
            navigationController.pushViewController(vc, animated: true)
            
        case .history:
            let vc = UIHostingController(rootView: HistoryView())
            vc.overrideUserInterfaceStyle = .light
            vc.view.backgroundColor = .white
            vc.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(vc, animated: true)
            
        case .addExpense(let completion):
            addExpenseCoordinator.start(in: self, present: true, onCompletion: completion)
            
        case .expenseDetail(let item, let completion):
            let vc = UIHostingController(rootView: ExpenseDetailsView(item: item, onDismiss: completion))
            vc.overrideUserInterfaceStyle = .light
            vc.modalPresentationStyle = .formSheet
            navigationController.present(vc, animated: true)
        }
    }
}
