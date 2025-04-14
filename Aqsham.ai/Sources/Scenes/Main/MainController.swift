import UIKit
import SwiftUI
import SnapKit

final class MainController: UIViewController {
    
    private let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
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
    
    private func didTapHistory() {}
    
    private func didTapAddExpense() {
        viewModel.navigate(to: .addExpense)
    }
    
    private func didTapTalkToAgent() {
        viewModel.navigate(to: .chat)
    }
    
    private func configUI() {
        let label = UILabel()
        label.text = "My Expenses"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.addCharacterSpacing(kernValue: -0.26)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        self.insertBackgroundColor()
        
        let hostView = MainView(
            onTapAddExpense: didTapAddExpense,
            onTapTalkToAgent: didTapTalkToAgent,
            onTapHistory: didTapHistory
        )
        let vc = UIHostingController(rootView: hostView)
        vc.view.backgroundColor = .clear
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        vc.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
}
