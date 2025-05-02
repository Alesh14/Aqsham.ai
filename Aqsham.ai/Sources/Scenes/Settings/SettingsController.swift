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
        let vc = UIHostingController(rootView: SettingsView())
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
