import UIKit
import SwiftUI

enum MainScreenSection {
    case chat
    case addExpense((() -> ()))
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
            navigationController.pushViewController(vc, animated: true)
            
        case .addExpense(let completion):
            addExpenseCoordinator.start(in: self, present: true, onCompletion: completion)
        }
    }
}
