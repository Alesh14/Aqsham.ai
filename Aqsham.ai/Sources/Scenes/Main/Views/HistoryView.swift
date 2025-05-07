import SwiftUI

final class HistoryViewModel: ObservableObject {
    
    @Injected(Container.expenseStorageService) private var expenseService
    
    @Published var history: [Date: [Expense]] = [:]
    
    func fetchHistory() {
        let groupedByDay: [Date: [Expense]] = Dictionary(grouping: expenseService.expenses) { expense in
            Calendar.current.startOfDay(for: expense.date!)
        }
        history = groupedByDay
    }
}

struct HistoryView: View {
    
    private enum Layout {
        static let cornerRadius: CGFloat = 16
        static let backgroundColor: Color = .white
        static let textColor: Color = .black
        static let iconBackgroundColor: Color = .init(hex: "#F1F2F3")
    }
    
    @ObservedObject private var viewModel = HistoryViewModel()
    @ObservedObject private var preferences = Preferences.shared
    
    private var historySections: [(day: Date, expenses: [Expense])] {
        viewModel.history
            .keys
            .sorted(by: >)
            .map { day in (day: day, expenses: viewModel.history[day]!) }
    }
    
    private let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd.MM.yyyy"
        return f
    }()
    
    var body: some View {
        if viewModel.history.isEmpty {
            VStack (alignment: .leading, spacing: 0) {
                Text(AppLocalizedString("Oops! No expenses yet. Let’s create one!"))
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color(hex: "#939393"))
                    .kerning(-0.08)
                    .padding(20)
            }
            .frame(maxWidth: .infinity)
            .onAppear(perform: viewModel.fetchHistory)
            .navigationTitle(AppLocalizedString("History"))
        } else {
            List {
                ForEach(historySections, id: \.day) { section in
                    daySection(for: section)
                }
            }
            .listStyle(.insetGrouped)
            .onAppear(perform: viewModel.fetchHistory)
            .navigationTitle(AppLocalizedString("History"))
        }
    }
    
    @ViewBuilder
    private func daySection(for section: (day: Date, expenses: [Expense])) -> some View {
        Section(header: Text(dayFormatter.string(from: section.day))) {
            ForEach(section.expenses) { expense in
                expenseRow(expense)
            }
        }
    }
    
    // MARK: - Extracted Row
    
    @ViewBuilder
    private func expenseRow(_ expense: Expense) -> some View {
        HStack {
            buildIcon(
                expense: ExpenseItem(
                    iconSystemName: expense.category!.icon!,
                    categoryName: expense.category!.name!,
                    totalAmount: expense.amount,
                    expenses: []
                )
            )
            
            Text(expense.category!.name!)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .padding(.leading, 12)
            
            Spacer()
            
            Text("\(expense.amount.formattedWithSpaces) \(preferences.currency.rawValue)")
                .font(.system(size: 16, weight: .regular))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            // handle tap
        }
    }
    
    private func buildIcon(expense: ExpenseItem) -> some View {
        ZStack {
            Color(hex: "#F1F2F3")
            Image(systemName: expense.iconSystemName)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.blue)
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
    }
}
