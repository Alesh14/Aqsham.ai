import UIKit
import SwiftUI
import SnapKit

final class MainController: UIViewController {
    
    private let viewModel: MainViewModel
    
    private let titleLabel = UILabel()
    
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onAppearSubject.send()
        titleLabel.text = AppLocalizedString("My Expenses")
    }
    
    private func didTapHistory() {
        viewModel.navigate(to: .history)
    }
    
    private func didTapAddExpense() {
        viewModel.navigate(to: .addExpense({ [weak self] in
            guard let self else { return }
            self.viewModel.onAppearSubject.send()
        }))
    }
    
    private func didTapTalkToAgent() {
        viewModel.navigate(to: .chat)
    }
    
    private func configUI() {
        titleLabel.text = AppLocalizedString("My Expenses")
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.addCharacterSpacing(kernValue: -0.26)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        self.insertBackgroundColor()
        
        let hostView = MainView(
            onTapAddExpense: didTapAddExpense,
            onTapTalkToAgent: didTapTalkToAgent,
            onTapHistory: didTapHistory,
            onTapOpenExpenseDetails: ({ [weak self] expenseItem in
                self?.viewModel.navigate(to: .expenseDetail(expenseItem, { [weak self] in
                    guard let self else { return }
                    self.viewModel.onAppearSubject.send()
                }))
            }),
            onAppearPublisher: viewModel.onAppearPublisher
        )
        let vc = UIHostingController(rootView: hostView)
        vc.view.backgroundColor = .clear
        vc.overrideUserInterfaceStyle = .light
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
