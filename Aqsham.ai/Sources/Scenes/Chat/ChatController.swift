import UIKit
import SwiftUI

final class ChatController: UIViewController {
    
    private enum Layout {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    private func configUI() {
        self.title = "Chat with AI"
        self.insertBackgroundColor()
        
        let vc = UIHostingController(rootView: ChatView())
        vc.view.backgroundColor = .clear
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        vc.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
