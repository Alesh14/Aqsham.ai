import Charts
import SwiftUI

struct ExpensePieChartView: View {
    
    @ObservedObject private var viewModel = ExpensePieChartViewModel()

    var body: some View {
        Chart(viewModel.data, id: \.categoryName) { item in
            SectorMark(
                angle: .value("Amount", item.totalAmount),
                innerRadius: .ratio(0.5),
                angularInset: 1
            )
            .foregroundStyle(by: .value("Category", item.categoryName))
            .annotation(position: .overlay) {
                Text(item.categoryName)
                    .font(.caption2)
                    .foregroundColor(.white)
            }
        }
        .chartLegend(.visible)
        .frame(height: 300)
        .padding()
    }
}
