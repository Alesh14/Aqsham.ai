import UIKit

final class SettingsCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = SettingsController()
        navigationController.pushViewController(controller, animated: false)
    }
}
