import SwiftUI
import Combine

struct AnalyticsView: View {
    
    private enum Layout {
        static let cornerRadius: CGFloat = 16
        static let backgroundColor: Color = .white
        static let textColor: Color = .black
        static let iconBackgroundColor: Color = .init(hex: "#F1F2F3")
    }
    
    @ObservedObject private var viewModel = AnalyticsViewModel()
    
    @ObservedObject private var preferences = Preferences.shared
    
    var onTapAddExpense: (() -> Void)?
    var onAppearPublisher: AnyPublisher<Void, Never>?
    var onTapOpenExpenseDetails: ((ExpenseItem) -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.expenses.isEmpty {
                VStack (alignment: .leading, spacing: 0) {
                    Text(AppLocalizedString("Oops! No expenses yet. Let’s create one!"))
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(hex: "#939393"))
                        .kerning(-0.08)
                        .padding(20)
                    
                    Divider()
                    
                    Button {
                        onTapAddExpense?()
                    } label: {
                        Text(AppLocalizedString("+ Add new expense"))
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(Color(UIColor.systemBlue))
                            .frame(alignment: .leading)
                            .padding(20)
                    }
                }
                .frame(maxWidth: .infinity)
            } else {
                ForEach($viewModel.expenses, id: \.id) { expense in
                    HStack {
                        buildIcon(expense: expense.wrappedValue)
                            .padding(.leading, 14)
                        
                        Text(expense.wrappedValue.categoryName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Layout.textColor)
                            .padding(.leading, 12)
                        
                        Spacer()
                            .contentShape(Rectangle())
                        
                        Text("\(expense.wrappedValue.totalAmount.formattedWithSpaces) \(preferences.currency.rawValue)")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Layout.textColor)
                            .padding(.trailing, 16)
                        
                    }
                    .contentShape(Rectangle())
                    .padding(.vertical, 12)
                    .onTapGesture {
                        didTapExpense(expense.wrappedValue)
                    }
                    
                    if viewModel.expenses.last! != expense.wrappedValue {
                        Divider()
                    }
                }
            }
        }
        .background(Layout.backgroundColor)
        .cornerRadius(Layout.cornerRadius)
        .onReceive(onAppearPublisher ?? Empty().eraseToAnyPublisher()) { _ in
            viewModel.fetchExpenses()
        }
    }
    
    private func didTapExpense(_ expense: ExpenseItem) {
        onTapOpenExpenseDetails?(expense)
    }
    
    private func buildIcon(expense: ExpenseItem) -> some View {
        ZStack {
            Layout.iconBackgroundColor
            Image(systemName: expense.iconSystemName)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.blue)
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
    }
}
