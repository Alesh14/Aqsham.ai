import UIKit

final class SettingsCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = SettingsController()
        controller.view.backgroundColor = .blue
        navigationController.pushViewController(controller, animated: false)
    }
}
