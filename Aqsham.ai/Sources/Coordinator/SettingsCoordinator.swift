import UIKit
import SwiftUI

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
            let vc = UIHostingController(rootView: CurrencyPickView())
            vc.overrideUserInterfaceStyle = .light
            vc.insertBackgroundColor()
            navigationController.present(vc, animated: true)
            
        case .language:
            let vc = UIHostingController(rootView: LanguagePickView())
            vc.overrideUserInterfaceStyle = .light
            vc.insertBackgroundColor()
            navigationController.present(vc, animated: true)
            
        case .notifications:
            Preferences.shared.notificationEnabled.toggle()
            
        case .pinCode:
            let vc = UIHostingController(rootView: PincodeView())
            vc.insertBackgroundColor()
            vc.overrideUserInterfaceStyle = .light
            navigationController.present(vc, animated: true)
            
        case .help:
            guard let url = URL(string: "https://t.me/aleshnasx") else {
                return
            }

            let application = UIApplication.shared
            if application.canOpenURL(url) {
                application.open(url, options: [:])
            }
        }
    }
}
