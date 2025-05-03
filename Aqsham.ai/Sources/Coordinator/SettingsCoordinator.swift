import UIKit

protocol SettingsScreenRoute: AnyObject {
    func trigger(_ route: SettingsSectionsView.Section)
}

final class SettingsCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = SettingsViewModel(router: self)
        let controller = SettingsController(viewModel: vm)
        navigationController.pushViewController(controller, animated: false)
    }
}

extension SettingsCoordinator: SettingsScreenRoute {
    
    func trigger(_ route: SettingsSectionsView.Section) {
        switch route {
        case .editCategories:
            break
        case .currency:
            break
        case .language:
            break
        case .notifications:
            break
        case .help:
            break
        }
    }
}
