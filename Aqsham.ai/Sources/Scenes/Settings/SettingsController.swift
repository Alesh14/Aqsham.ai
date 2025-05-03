import UIKit
import SwiftUI

final class SettingsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    @objc private func didTapEdit() {
        
    }
    
    private func configUI() {
        let vc = UIHostingController(rootView: SettingsView(onTap: { section in
            switch section {
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
