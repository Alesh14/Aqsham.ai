import UIKit
import SwiftUI
import Combine

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    private lazy var subCoordinators: [Coordinator] = {
        [
            MainCoordinator(navigationController: UINavigationController()),
            SettingsCoordinator(navigationController: UINavigationController())
        ]
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.configEvents()
    }
    
    func start() {
        let coordinator1 = subCoordinators[0]
        coordinator1.start()
        
        let coordinator2 = subCoordinators[1]
        coordinator2.start()
        
        coordinator1.navigationController.tabBarItem = UITabBarItem(
            title: AppLocalizedString("Home"),
            image: UIImage(systemName: "house.fill"),
            tag: 0
        )
        coordinator2.navigationController.tabBarItem = UITabBarItem(
            title: AppLocalizedString("Settings"),
            image: UIImage(systemName: "gear"),
            tag: 1
        )
        
        let controller = UITabBarController()
        controller.viewControllers = [
            coordinator1.navigationController, coordinator2.navigationController
        ]
        navigationController.pushViewController(controller, animated: false)
        
        let pinCodeVC = UIHostingController(rootView: AskPinCodeView())
        
        navigationController.present(pinCodeVC, animated: false)
    }
    
    func configEvents() {
        Preferences.shared.$language.eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let coordinator1 = self?.subCoordinators[0]
                let coordinator2 = self?.subCoordinators[1]
                coordinator1?.navigationController.tabBarItem.title = AppLocalizedString("Home")
                coordinator2?.navigationController.tabBarItem.title = AppLocalizedString("Settings")
            }
            .store(in: &cancellables)
    }
}
