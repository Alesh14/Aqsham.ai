import UIKit

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    private lazy var subCoordinators: [Coordinator] = {
        [
            MainCoordinator(navigationController: UINavigationController()),
            SettingsCoordinator(navigationController: UINavigationController())
        ]
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let coordinator1 = subCoordinators[0]
        coordinator1.start()
        
        let coordinator2 = subCoordinators[1]
        coordinator2.start()
        
        coordinator1.navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        coordinator2.navigationController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        
        let controller = UITabBarController()
        controller.viewControllers = [
            coordinator1.navigationController, coordinator2.navigationController
        ]
        navigationController.pushViewController(controller, animated: false)
    }
}
