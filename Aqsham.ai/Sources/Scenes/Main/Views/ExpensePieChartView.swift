import Charts
import SwiftUI
import Combine

struct ExpensePieChartView: View {
    
    private enum Layout {
        static let backgroundColor: Color = .white
        static let cornerRadius: CGFloat = 12
    }
    
    @ObservedObject private var viewModel: ExpensePieChartViewModel
    
    var onAppearPublisher: AnyPublisher<Void, Never>?

    init(onAppearPublisher: AnyPublisher<Void, Never>? = nil) {
        self.onAppearPublisher = onAppearPublisher
        self.viewModel = ExpensePieChartViewModel(onAppearPublisher: onAppearPublisher)
    }

    var body: some View {
        if viewModel.data.isEmpty {
            HStack {
                Text(AppLocalizedString("There's not enough data to show."))
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color(hex: "#939393"))
                    .kerning(-0.08)
                    .padding(20)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .background(Layout.backgroundColor)
            .cornerRadius(Layout.cornerRadius)
            .onReceive(onAppearPublisher ?? Empty().eraseToAnyPublisher(), perform: { _ in
                viewModel.fetchExpenses()
            })
        } else {
            Chart(viewModel.data, id: \.categoryName) { item in
                SectorMark(
                    angle: .value("Amount", item.totalAmount),
                    innerRadius: .ratio(0.5),
                    angularInset: 1
                )
                .foregroundStyle(by: .value("Category", item.categoryName))
            }
            .onReceive(onAppearPublisher ?? Empty().eraseToAnyPublisher(), perform: { _ in
                viewModel.fetchExpenses()
            })
            .chartLegend(
                position: .trailing,
                alignment: .center,
                spacing: 16
            )
            .frame(height: 250, alignment: .leading)
            .padding(20)
            .background(Layout.backgroundColor)
            .cornerRadius(Layout.cornerRadius)
        }
    }
}
