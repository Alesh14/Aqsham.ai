import UIKit
import SwiftUI

final class SettingsViewModel {
    
    unowned let router: SettingsScreenRoute
    
    init(router: SettingsScreenRoute) {
        self.router = router
    }
    
    func navigate(to section: SettingsSectionsView.Section) {
        router.trigger(section)
    }
}

final class SettingsController: UIViewController {
    
    let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem?.title = AppLocalizedString("Edit")
    }
    
    @objc private func didTapEdit() {
        let vc = UIHostingController(rootView: EditProfileView())
        vc.overrideUserInterfaceStyle = .light
        vc.insertBackgroundColor()
        self.present(vc, animated: true)
    }
    
    private func configUI() {
        let vc = UIHostingController(rootView: SettingsView(onTap: { [weak self] section in
            self?.viewModel.navigate(to: section)
        }))
        vc.overrideUserInterfaceStyle = .light
        vc.insertBackgroundColor()
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        vc.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: AppLocalizedString("Edit"),
            style: .plain,
            target: self,
            action: #selector(didTapEdit)
        )
    }
}
