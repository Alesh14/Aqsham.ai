import Charts
import SwiftUI
import Combine

enum ChartType: String, CaseIterable, Identifiable {
    case pie   = "Pie Chart"
    case bar   = "Bar Chart"
    case line  = "Line Chart"
    var id: String { rawValue }
}

struct ChartPicker: View {
    
    @State var selected: ChartType {
        didSet {
            onChange(selected)
        }
    }
    
    var onChange: ((ChartType) -> Void)

    var body: some View {
        Picker(selection: $selected, label: pickerLabel) {
            ForEach(ChartType.allCases) { type in
                Text(type.rawValue).tag(type)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .accentColor(.gray)
        .font(.system(size: 17))
        .padding(.horizontal)
    }

    private var pickerLabel: some View {
        HStack(spacing: 4) {
            Text(selected.rawValue)
            Image(systemName: "chevron.up.chevron.down")
        }
    }
}

struct VisualizationView: View {
    private enum Layout {
        static let backgroundColor: Color = .white
        static let cornerRadius: CGFloat = 12
    }

    @State var selectedChartType: ChartType = .bar

    @ObservedObject private var viewModel: VisualizationViewModel
    var onAppearPublisher: AnyPublisher<Void, Never>?

    init(onAppearPublisher: AnyPublisher<Void, Never>? = nil) {
        self.onAppearPublisher = onAppearPublisher
        self.viewModel = VisualizationViewModel(onAppearPublisher: onAppearPublisher)
    }

    var body: some View {
        Group {
            if viewModel.data.isEmpty {
                noDataView
            } else {
                chartView
            }
        }
        .background(Layout.backgroundColor)
        .cornerRadius(Layout.cornerRadius)
        .onReceive(onAppearPublisher ?? Empty().eraseToAnyPublisher()) { _ in
            viewModel.fetchExpenses()
        }
    }

    private var noDataView: some View {
        HStack {
            Text(AppLocalizedString("There's not enough data to show."))
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#939393"))
                .padding(20)
            Spacer()
        }
    }

    private var chartView: some View {
        VStack {
            HStack {
                ChartPicker(selected: selectedChartType) { type in
                    selectedChartType = type
                }
                Spacer()
            }
            .padding(.top, 10)

            switch selectedChartType {
            case .pie:
                PieChart(data: viewModel.data)
                    .padding(20)
            case .bar:
                BarChart(data: viewModel.data)
                    .padding(20)
            case .line:
                LineChart(data: viewModel.data)
                    .padding(20)
            }
        }
    }
}

// MARK: – Chart Variants

struct PieChart: View {
    
    let data: [ExpenseItem]
    
    var body: some View {
        Chart(data, id: \.categoryName) { item in
            SectorMark(
                angle: .value("Amount", item.totalAmount),
                innerRadius: .ratio(0.5),
                angularInset: 1
            )
            .foregroundStyle(by: .value("Category", item.categoryName))
        }
        .chartLegend(position: .trailing, alignment: .center, spacing: 16)
        .frame(height: 250)
    }
}

struct BarChart: View {
    let data: [ExpenseItem]
    var body: some View {
        Chart(data, id: \.categoryName) { item in
            BarMark(
                x: .value("Category", item.categoryName),
                y: .value("Amount", item.totalAmount)
            )
            .foregroundStyle(by: .value("Category", item.categoryName))
        }
        .chartYAxisLabel("Amount")
        .frame(height: 250)
    }
}

struct LineChart: View {
    let data: [ExpenseItem]
    var body: some View {
        Chart(data) { item in
            LineMark(
                x: .value("Category", item.categoryName),
                y: .value("Amount", item.totalAmount)
            )
            .foregroundStyle(by: .value("Category", item.categoryName))
        }
        .frame(height: 250)
    }
}
