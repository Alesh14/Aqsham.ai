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
    
    @objc private func didTapEdit() {
        
    }
    
    private func configUI() {
        let vc = UIHostingController(rootView: SettingsView(onTap: { [weak self] section in
            self?.viewModel.navigate(to: section)
        }))
        
        vc.insertBackgroundColor()
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        vc.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEdit))
    }
}
