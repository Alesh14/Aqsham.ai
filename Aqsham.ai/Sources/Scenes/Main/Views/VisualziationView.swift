import Charts
import SwiftUI
import Combine

enum ChartType: String, CaseIterable, Identifiable {
    case bar   = "Bar Chart"
    case pie   = "Pie Chart"
    case line  = "Line Chart"
    var id: String { rawValue }
}

struct ChartPicker: View {
    
    @State var selected: ChartType
    
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
        .onChange(of: selected) { oldValue, newValue in
            onChange(newValue)
        }
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

            Group {
                switch selectedChartType {
                case .pie:
                    PieChart(data: viewModel.data)
                case .bar:
                    BarChart(data: viewModel.data)
                case .line:
                    LineChart(data: viewModel.data)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .padding(.bottom, 5)
        }
    }
}


struct PieChart: View {
    
    let data: [ExpenseItem]

    var body: some View {
        Chart(data, id: \.categoryName) { item in
            SectorMark(
                angle: .value(AppLocalizedString("Amount"), item.totalAmount),
                innerRadius: .ratio(0.5),
                angularInset: 1
            )
            .foregroundStyle(by: .value(AppLocalizedString("Category"), item.categoryName))
            
            .annotation(position: .overlay, alignment: .center) {
                VStack(spacing: 2) {
                    Text(item.categoryName)
                        .font(.caption2)
                        .foregroundColor(.white)
                    Text(item.totalAmount, format: .currency(code: Preferences.shared.currency.code))
                        .font(.caption2)
                        .foregroundColor(.white)
                }
                .multilineTextAlignment(.center)
            }
        }
        .chartLegend(position: .trailing, alignment: .center, spacing: 16)
        .frame(height: 250)
    }
}

struct BarChart: View {

    let data: [ExpenseItem]

    private var average: Double {
        guard !data.isEmpty else { return 0 }
        return data.map(\.totalAmount).reduce(0, +) / Double(data.count)
    }

    var body: some View {
        Chart {
            ForEach(data, id: \.categoryName) { item in
                BarMark(
                    x: .value(AppLocalizedString("Category"), item.categoryName),
                    y: .value(AppLocalizedString("Amount"), item.totalAmount)
                )
                .foregroundStyle(by: .value(AppLocalizedString("Category"), item.categoryName))
                
                .annotation(position: .top) {
                    Text(item.totalAmount, format: .currency(code: Preferences.shared.currency.code))
                        .font(.caption2)
                }
            }
        }
        .chartYAxisLabel(AppLocalizedString("Amount"))
        .frame(height: 250)
    }
}

struct LineChart: View {
    
    let data: [ExpenseItem]

    var body: some View {
        Chart {
            ForEach(data, id: \.categoryName) { item in
                LineMark(
                    x: .value(AppLocalizedString("Category"), item.categoryName),
                    y: .value(AppLocalizedString("Amount"), item.totalAmount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(by: .value(AppLocalizedString("Category"), item.categoryName))

                PointMark(
                    x: .value(AppLocalizedString("Category"), item.categoryName),
                    y: .value(AppLocalizedString("Amount"), item.totalAmount)
                )
                .symbolSize(40)
                .foregroundStyle(by: .value(AppLocalizedString("Category"), item.categoryName))
                .annotation(position: .top) {
                    Text(item.totalAmount, format: .currency(code: Preferences.shared.currency.code))
                        .font(.caption2)
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartYAxis {
            AxisMarks(values: .automatic) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartXAxisLabel(AppLocalizedString("Category"))
        .chartYAxisLabel(AppLocalizedString("Amount"))
        .frame(height: 250)
    }
}
