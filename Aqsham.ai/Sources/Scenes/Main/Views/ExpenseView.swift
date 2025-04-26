import SwiftUI
import Combine

struct ExpenseView: View {
    
    private enum Layout {
        static let cornerRadius: CGFloat = 16
        static let backgroundColor: Color = .white
        static let secondaryTextColor: Color = .init(hex: "#8E8E93")
    }
    
    var onTapAddExpense: (() -> Void)?
    var onTapTalkToAgent: (() -> Void)?
    var onTapHistory: (() -> Void)?

    var onAppearPublisher: AnyPublisher<Void, Never>?
    
    @ObservedObject private var viewModel = ExpenseViewModel()
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                Text("Total Expense")
                    .kerning(-0.08)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Layout.secondaryTextColor)
                
                Spacer()
                
                Button {
                    viewModel.didTapPeriod()
                } label: {
                    Text(viewModel.period)
                        .kerning(-0.08)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Layout.secondaryTextColor)
                }
            }
            
            Text("\(viewModel.expense.formattedWithSpaces) \(viewModel.currency.rawValue)")
                .kerning(0.4)
                .font(.system(size: 34, weight: .bold))
                
            Spacer().frame(height: 32)
            
            HStack (spacing: 0) {
                buildButton(iconName: "plus", title: "Add expense")
                    .onTapGesture { onTapAddExpense?() }
                
                buildButton(iconName: "message.fill", title: "Talk to AI")
                    .onTapGesture { onTapTalkToAgent?() }
                
                buildButton(iconName: "clock.fill", title: "History")
                    .onTapGesture { onTapHistory?() }
            }
        }
        .frame(alignment: .leading)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Layout.backgroundColor)
        .cornerRadius(Layout.cornerRadius)
        .onAppear {
            viewModel.refreshTotalExpenseIfNeeded()
        }
        .onReceive(onAppearPublisher ?? Empty().eraseToAnyPublisher()) { _ in
            viewModel.refreshTotalExpenseIfNeeded()
        }
    }
    
    private func buildButton(iconName: String, title: String) -> some View {
        VStack (spacing: 8) {
            ZStack {
                Color(hex: "#D9EBFF")
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                
                Image(systemName: iconName)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.blue)
            }
            
            Text(title)
                .kerning(-0.23)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity)
    }
}
